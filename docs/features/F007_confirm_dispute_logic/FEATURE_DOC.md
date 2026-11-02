# F007 — Confirm/Dispute Logic Change (Vendor Credit Auto-Confirm)

**Status:** PLANNING  
**Priority:** HIGH — fundamental change to ledger flow  
**Effort:** Backend 2h · Frontend 2h · Testing 1h  
**Migration:** None required (uses existing `status` column values)  
**Depends on:** F004 (khata flow understanding)  
**Blocks:** F008 (dues definition changes after this), F006 (interaction)

---

## 1. WHAT EXISTS TODAY

### 1.1 Current Ledger Entry Flow

ALL ledger entries — regardless of who creates them — start as `status = 'pending'`:

```
Vendor adds credit (udhaar diya)
  → status = 'pending'
  → Customer must tap "Confirm" 
  → status = 'confirmed', balance updates

Customer adds payment (paisa liya)
  → status = 'pending'
  → Vendor must tap "Confirm"
  → status = 'confirmed', balance updates
```

### 1.2 Current `addEntry()` in `ledger.service.ts`

```typescript
// Simplified current logic
const entry = await this.ledgerRepo.addEntry({
  ...input,
  status: 'pending',   // ← always pending
  is_locked: false,
  created_by: userId,
});
// No adjustBalance call here — balance only updates on confirmEntry()
```

### 1.3 `auto_confirmed` Status Already Exists

The `auto_confirmed` status is already used by:
- `payment.service.ts recordPayment()` — vendor recording payment receipt
- `order.service.ts updateStatus()` delivered branch — order delivery creates auto_confirmed entries
- Both call `linkRepo.adjustBalance()` in the same transaction

So the mechanism exists; we just need to apply it to vendor-created credit entries too.

### 1.4 The Problem

When a vendor adds a credit (e.g., "delivered 2L milk for ₹60"), they KNOW they delivered it. Requiring the customer to confirm creates friction and delays the balance update. In the real-world analog (a physical khata/ledger), the vendor writes the entry and it's authoritative — the customer doesn't "confirm" the vendor's own record.

---

## 2. WHAT CHANGES

### 2.1 New Rule

| Entry Creator | Entry Type | New Behavior |
|---|---|---|
| Vendor | credit | `auto_confirmed` immediately, balance updates |
| Vendor | adjustment | `auto_confirmed` immediately, balance updates |
| Staff (acting as vendor) | credit | `auto_confirmed` immediately, balance updates |
| Staff (acting as vendor) | adjustment | `auto_confirmed` immediately, balance updates |
| Customer | payment | `pending` → vendor must confirm (no change) |
| Customer | advance | `pending` → vendor must confirm (no change) |

**Udhaar diya (credit given) = vendor's authoritative record. No confirmation needed.**  
**Paisa liya (money received) = claim by customer, vendor verifies. Still pending.**

### 2.2 Why `adjustment` Also Auto-Confirms

Adjustments are corrections made by the vendor (e.g., "correcting last week's entry by -₹20"). These are vendor-side administrative actions and should also be authoritative. A vendor adjusting their own records doesn't need customer sign-off.

---

## 3. BACKEND CHANGES

### 3.1 `ledger.service.ts` — `addEntry()` Change

**File:** `saath_khata_backend/src/app/modules/ledger/services/ledger.service.ts`

```typescript
async addEntry(input: AddEntryInput, actorContext: ActorContext): Promise<LedgerEntry> {
  const { userId, role } = actorContext;
  
  // Resolve link access (existing logic unchanged)
  const link = await this._resolveLinkAccess(input.linkId, actorContext);
  
  // NEW: Determine if this is a vendor-side entry
  const isVendorSide = role === 'vendor' || role === 'staff';
  const shouldAutoConfirm = isVendorSide && 
    (input.type === 'credit' || input.type === 'adjustment');
  
  const status = shouldAutoConfirm ? 'auto_confirmed' : 'pending';
  const isLocked = shouldAutoConfirm;
  const confirmedAt = shouldAutoConfirm ? new Date() : null;
  
  return await db.transaction(async (trx) => {
    const entry = await this.ledgerRepo.addEntry({
      ...input,
      status,
      is_locked: isLocked,
      confirmed_at: confirmedAt,
      created_by: userId,
    }, trx);
    
    // NEW: Adjust balance immediately for auto-confirmed entries
    if (shouldAutoConfirm) {
      // credit increases balance (customer owes more), adjustment can be +/-
      const delta = input.type === 'credit' ? input.amount : input.amount; // adjustment amount carries sign
      await this.linkRepo.adjustBalance(input.linkId, delta, trx);
    }
    
    // Emit socket event (existing, status is now auto_confirmed)
    this.socketService.emitToLink(input.linkId, 'ledger:entry_added', {
      entry: { ...entry, status },
    });
    
    // Push notification — message changes based on auto-confirm
    if (shouldAutoConfirm) {
      // Notify customer: "Vendor added ₹X credit"
      await enqueueNotification({
        userId: link.customerId,
        title: 'New entry in your khata',
        body: `₹${input.amount} credit added by vendor`,
        data: { linkId: input.linkId, entryId: entry.id },
      });
    } else {
      // Existing: notify other party about pending entry
      // (payment pending → notify vendor)
      const notifyUserId = role === 'customer' ? link.vendorId : link.customerId;
      await enqueueNotification({
        userId: notifyUserId,
        title: 'New pending entry',
        body: `₹${input.amount} ${input.type} — confirmation needed`,
        data: { linkId: input.linkId, entryId: entry.id },
      });
    }
    
    return entry;
  });
}
```

### 3.2 Multi-Item Parent/Child Entries

When vendor creates a multi-item delivery (parent entry + child entries), ALL get auto_confirmed:
- Parent entry: `status='auto_confirmed'`, `is_locked=true`
- Child entries: same
- `adjustBalance` called ONCE with parent total amount (children never adjust balance — existing rule)

No code change needed for child creation logic — children inherit status from the create call which uses the same `shouldAutoConfirm` branch.

### 3.3 `confirmEntry()` — No Longer Callable for Vendor Credits

After this change, vendor credits arrive as `auto_confirmed` and `is_locked=true`. The existing `confirmEntry()` already validates:
```typescript
if (entry.is_locked) throw new AppError('Entry is locked', 400);
```
So attempting to re-confirm an auto_confirmed entry will correctly fail. No additional guard needed.

### 3.4 `disputeEntry()` — Also Blocked

`is_locked=true` means customers can no longer dispute auto_confirmed vendor credits. This is **by design** — vendor authority. Document this tradeoff clearly.

If dispute capability is needed in the future, it would require a separate "dispute auto-confirmed entry" flow with different rules (e.g., vendor review required).

---

## 4. FRONTEND CHANGES

### 4.1 Customer's `SharedLedgerScreen`

**Before:** Credit entries from vendor showed as `pending` with "Confirm" and "Dispute" action buttons.  
**After:** Credit entries arrive as `auto_confirmed`. No action buttons shown.

```dart
// In LedgerEntryTile or wherever action buttons are rendered:
// Remove: if (entry.status == EntryStatus.pending && entry.createdBy != currentUserId)
//           → show Confirm / Dispute buttons

// New logic:
bool canConfirm = entry.status == EntryStatus.pending && 
                  entry.type == EntryType.payment &&  // only payments need vendor confirm
                  currentRole == Role.vendor;

bool canDispute = entry.status == EntryStatus.pending &&
                  entry.type == EntryType.credit &&   // only if credits still arrive pending
                  currentRole == Role.customer;
// After F007: canDispute will always be false for credits (they're auto_confirmed)
```

### 4.2 Status Display

| Status | Display Label | Color |
|---|---|---|
| `auto_confirmed` | "Confirmed" or no badge (clean) | Green |
| `pending` | "Pending" | Amber |
| `confirmed` | "Confirmed" | Green |
| `disputed` | "Disputed" | Red |

Auto-confirmed entries display the same as manually confirmed entries from the customer's perspective — they don't need to see the mechanism.

### 4.3 Vendor's `SharedLedgerScreen`

Vendor sees their credit entries as `auto_confirmed` (they created them). No change to vendor flow needed — vendor already couldn't "confirm" their own entries.

### 4.4 Staff Screen

Staff creating credits on vendor's behalf: entries auto_confirmed. Staff sees same as vendor view.

### 4.5 Notification Handling

Push notification for auto_confirmed credit:
```
Title: "Khata updated"
Body:  "Sharma Dairy added ₹60 to your khata"
```
Not: "You have a pending entry" (no action required).

The `NotificationBloc` may need to differentiate notification types to show the right CTA (if notification is tapped — navigate to ledger, don't show "Confirm" dialog).

---

## 5. INTERACTION WITH OTHER FEATURES

### 5.1 F006 — Auto-Confirm Toggle

F006 adds a per-link `customer_auto_confirm` toggle. After F007:
- Vendor credits → **always** `auto_confirmed` (F007 rule, overrides F006)
- The F006 toggle applies to OTHER scenarios (if any future entry types are added that aren't vendor credits)
- In practice, F007 + F008 together mean: vendor credits = always auto_confirmed; customer payments = always pending until vendor confirms

**Document this clearly in F006:** The toggle does NOT affect vendor-created credits after F007 is implemented.

### 5.2 F008 — Dues Fix

After F007, "Dues" = `auto_confirmed` credits that haven't been offset by confirmed payments = the `link.balance` value. The dues section no longer needs to show `pending` credits (since none exist). See F008 for the updated dues definition.

### 5.3 F004 — Khata Flow

The "72-hour auto-confirm" cron job planned in F004 becomes less critical after F007. Vendor credits are already auto-confirmed. Only payment entries remain pending, and those are vendor-confirmed (the party with more incentive to act). The auto-confirm cron is still useful for vendor negligence on customer payments but lower priority.

---

## 6. EDGE CASES

| Case | Behavior |
|---|---|
| Vendor creates credit while offline → synced later | Entry arrives auto_confirmed when sync completes. Balance updates server-side at creation time. |
| Race: vendor edits credit amount before customer sees it | Can't — entry is locked immediately. Edits blocked. |
| Vendor accidentally adds wrong amount | Must add an adjustment entry (negative amount) to correct. Can't edit locked entry. |
| Customer wants to dispute auto_confirmed credit | Not possible — entry is locked. Customer must contact vendor directly. Out-of-app resolution. |
| Staff creates credit for wrong customer | Same as vendor — locked immediately. Staff/vendor must add adjustment. |
| Adjustment entry with negative amount | `adjustBalance` called with negative delta → balance decreases. Correct. |
| Vendor has both `credit` and `adjustment` in same request | Each entry processed individually. Both auto-confirm. |
| Link is inactive / customer deleted | Existing `_resolveLinkAccess` validation catches this before entry creation. |

---

## 7. CURRENT PENDING ENTRY FLOW (to be REMOVED for credits)

```
Current flow being replaced:
1. Vendor creates credit → status=pending
2. Customer gets push notification: "New entry needs confirmation"
3. Customer opens app → sees pending entry
4. Customer taps "Confirm" → POST /links/:id/entries/:entryId/confirm
5. status=confirmed, is_locked=true, adjustBalance called
6. Both parties get push notification: "Entry confirmed"

New flow:
1. Vendor creates credit → status=auto_confirmed, is_locked=true, adjustBalance called
2. Customer gets push notification: "Vendor added ₹X to your khata" (informational)
3. Customer opens app → sees confirmed entry (no action needed)
```

---

## 8. API CHANGES

### 8.1 `POST /links/:id/entries`

No change to request body. The `status` in the response changes:
```json
{
  "id": "...",
  "type": "credit",
  "amount": 60,
  "status": "auto_confirmed",   // ← was "pending"
  "is_locked": true,             // ← was false
  "confirmed_at": "2026-06-30T...",  // ← was null
}
```

### 8.2 `POST /links/:id/entries/:entryId/confirm`

Still exists for customer payment entries (vendor confirms customer payments). No change.

### 8.3 `POST /links/:id/entries/:entryId/dispute`

Will return 400 for any `auto_confirmed` entry (`is_locked=true` check). No code change needed.

---

## 9. BALANCE MECHANICS AFTER F007

```
Initial balance: 0

Vendor adds ₹100 credit → auto_confirmed → balance = +100
Vendor adds ₹50 credit  → auto_confirmed → balance = +150
Customer pays ₹80       → pending (vendor confirms) → balance unchanged
Vendor confirms payment → status=confirmed → balance = +70
```

The `link.balance` now updates in real-time as vendor adds credits (no confirmation lag).

---

## 10. FEATURE FLAG / ROLLOUT

Add environment variable for safe rollout:
```
VENDOR_CREDIT_AUTO_CONFIRM=true
```

In `addEntry()`:
```typescript
const autoConfirmEnabled = process.env.VENDOR_CREDIT_AUTO_CONFIRM === 'true';
const shouldAutoConfirm = autoConfirmEnabled && isVendorSide && 
  (input.type === 'credit' || input.type === 'adjustment');
```

Default to `true` in production after testing. Remove flag after stable.

---

## 11. REQUIRED DB CHANGES

None. The `status` column already supports `'auto_confirmed'`. The `confirmed_at` and `is_locked` columns already exist.

---

## 12. REQUIRED BACKEND CHANGES

| File | Change |
|---|---|
| `src/app/modules/ledger/services/ledger.service.ts` | `addEntry()`: detect vendor-side credit/adjustment, set auto_confirmed, call adjustBalance |
| `src/app/modules/ledger/services/ledger.service.ts` | Change push notification message for auto_confirmed entries |

---

## 13. REQUIRED FRONTEND CHANGES

| File | Change |
|---|---|
| Ledger entry tile widget | Remove "Confirm" button for credit entries (they arrive as auto_confirmed) |
| Ledger entry tile widget | Remove "Dispute" button for auto_confirmed entries |
| Notification handler | Different CTA for auto_confirmed credit notifications (no confirm dialog) |
| `LedgerEntry` model | Ensure `auto_confirmed` status is handled in `isConfirmed` / `isPending` getters |

---

## 14. REQUIRED MIGRATION

None.

---

## 15. TESTING STRATEGY

### Functional Tests
- [ ] Vendor creates credit → entry status is `auto_confirmed`, `is_locked=true`
- [ ] Vendor creates credit → `link.balance` immediately updates
- [ ] Customer views ledger → credit entry shows as confirmed, no action buttons
- [ ] Customer attempts to confirm auto_confirmed entry → 400 error
- [ ] Customer attempts to dispute auto_confirmed entry → 400 error
- [ ] Customer creates payment → entry stays `pending`, vendor sees action button
- [ ] Vendor confirms customer payment → balance updates

### Edge Case Tests
- [ ] Vendor creates credit with past date (backdated, F010) → still auto_confirmed
- [ ] Staff creates credit → auto_confirmed (staff acts as vendor)
- [ ] Vendor creates adjustment (negative) → auto_confirmed, balance decreases
- [ ] Multi-item delivery → parent + children all auto_confirmed

### Regression Tests
- [ ] Order delivery auto_confirmed flow still works (unchanged)
- [ ] Payment recording auto_confirmed flow still works (unchanged)
- [ ] Manual `confirmEntry()` for payment entries still works

---

## 16. ROLLBACK

1. Set `VENDOR_CREDIT_AUTO_CONFIRM=false` in environment
2. Redeploy backend — new credits will be `pending` again
3. Existing `auto_confirmed` entries remain locked (safe — they represent real deliveries)
4. Frontend rollback: restore "Confirm" button for credit entries in pending state

---

## 17. RISKS

| Risk | Likelihood | Mitigation |
|---|---|---|
| Vendor adds wrong amount — can't edit | Medium | Document clearly; add adjustment entry as correction path |
| Customer feels they have no say in credits | Medium | Informational notification explains what was added; out-of-app dispute resolution |
| Balance updates before customer agrees | High (by design) | This is the intended behavior — vendor authority |
| Existing pending credit entries at deploy time | Low | They remain pending; only NEW entries after deploy get auto_confirmed |

---

## 18. DEPENDENCIES

```
F007 ──► F008 (dues definition changes — dues = balance, not pending credits)
F007 ──► F006 (interaction: F006 toggle doesn't affect vendor credits after F007)
F007 ──► F009 (ledger display: auto_confirmed entries display without action buttons)
```
