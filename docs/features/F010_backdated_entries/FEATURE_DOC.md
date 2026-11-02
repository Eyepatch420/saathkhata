# F010 — Backdated Ledger Entries

**Status:** PLANNING  
**Priority:** MEDIUM  
**Effort:** Backend 1h · Frontend 2h · Migration: none  
**Depends on:** F004, F007  
**Integrates with:** F009 (date dividers), F007 (auto_confirmed status still applies)

---

## 1. WHAT EXISTS TODAY

### 1.1 Database

`ledger_entries.date` is a `TIMESTAMP` column that already exists. It is separate from `created_at`. The column is populated at entry creation.

Current behavior: `date` is set to `new Date()` (now) when an entry is created. There is no validation preventing a past date from being passed.

### 1.2 Backend

`AddEntryInput` in `src/app/modules/ledger/types/ledger.types.ts`:
```typescript
export interface AddEntryInput {
  linkId: string;
  type: 'credit' | 'payment' | 'advance' | 'adjustment';
  amount: number;
  description?: string;
  date?: string;  // ← already optional, defaults to now()
  // ...
}
```

`ledger.repository.ts addEntry()` already sends the `date` field to Postgres. If not provided, the DB `DEFAULT NOW()` applies (or the service sets it to `new Date().toISOString()`).

No backend validation prevents a past date from being passed. The column accepts any valid timestamp.

### 1.3 Frontend — `AddEntrySheet`

The `AddEntrySheet` widget (bottom sheet for adding entries) does NOT currently show a date picker. The `date` field in the API call is always omitted — meaning the backend defaults to `NOW()`.

`LedgerRepositoryImpl` already has the field in its model:
```dart
// In LedgerEntry model:
final DateTime date;

// In addEntry() API call:
'date': entry.date.toUtc().toIso8601String(),
```

So the model and API call support it — the UI just doesn't expose it.

### 1.4 Sort Order

Entries are currently sorted by `created_at DESC` in `ledger.repository.ts findByLinkId()`. For backdated entries, this means a backdated entry (created today but dated last week) will appear at the TOP of the list, not in its chronological position.

---

## 2. WHAT NEEDS TO CHANGE

1. **Frontend:** Add optional date picker to `AddEntrySheet` — defaults to today, allows past dates
2. **Backend:** Add validation — reject future dates, optionally cap how far back (1 year)
3. **Backend:** Change sort order from `created_at DESC` to `date DESC, created_at DESC`
4. **Frontend model:** Ensure `LedgerBloc` and display use `entry.date` for display and grouping (not `created_at`)

---

## 3. DATE PICKER UI DESIGN

### 3.1 AddEntrySheet Changes

Add a tappable date row below the amount/description fields:

```
┌─────────────────────────────────────┐
│  Amount         ₹ [    60          ]│
│  Description    [milk delivery     ]│
│  Date           [Today, 1 Jul 2026 ]│  ← NEW (tappable)
│                         ↑           │
│               Calendar icon + date  │
│  [Cancel]              [Add Entry]  │
└─────────────────────────────────────┘
```

When tapped → opens Material 3 `DatePickerDialog`:
```dart
final picked = await showDatePicker(
  context: context,
  initialDate: _selectedDate ?? DateTime.now(),
  firstDate: DateTime.now().subtract(const Duration(days: 365)), // 1 year max backdate
  lastDate: DateTime.now(), // no future dates
);
if (picked != null) setState(() => _selectedDate = picked);
```

Display logic:
- Today → show "Today"
- Yesterday → show "Yesterday"  
- This week → show "Mon, 30 Jun"
- Older → show "15 Jun 2026"

If date is in the past, show a small "Past date" chip/badge next to the date to make it visually clear the entry is being backdated:

```dart
if (_selectedDate != null && _selectedDate!.isBefore(_today)) 
  Chip(label: Text('Past date'), backgroundColor: Colors.orange.shade100)
```

### 3.2 No Date Picker = Today

The date picker row is optional UI. If the user doesn't tap it, `_selectedDate` is null and the API call omits `date` → backend defaults to `NOW()`. Backward compatible.

---

## 4. BACKEND VALIDATION

### 4.1 Validation in `addEntry()` or validator

```typescript
// In ledger.validators.ts addEntrySchema:
date: z.string().datetime().optional().refine(
  (val) => {
    if (!val) return true; // optional
    const entryDate = new Date(val);
    const now = new Date();
    
    // No future dates
    if (entryDate > now) return false;
    
    // Max 1 year backdate
    const oneYearAgo = new Date();
    oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);
    if (entryDate < oneYearAgo) return false;
    
    return true;
  },
  { message: 'Date must be between 1 year ago and today' }
),
```

### 4.2 Why 1-Year Limit?

- Prevents data integrity issues from very old entries mixing with current balance
- Reasonable business rule: if you're backdating more than a year, there's likely an accounting error, not a legitimate missing entry
- Can be relaxed to 2 years or removed entirely if business needs dictate

---

## 5. SORT ORDER CHANGE

### 5.1 `ledger.repository.ts findByLinkId()`

```typescript
// Current:
.orderBy('le.created_at', 'desc')

// New:
.orderBy('le.date', 'desc')
.orderBy('le.created_at', 'desc')  // tiebreaker for same-day entries
```

This ensures:
- Backdated entries appear in their correct chronological position
- Two entries on the same day are sub-sorted by when they were created
- Newly created entries (date = NOW) still appear at top since their date is today

### 5.2 Impact on Existing Entries

Existing entries all have `date = created_at` (since date was never set differently). Sorting by `date DESC` gives the same result as `created_at DESC` for them. No visual regression.

---

## 6. INTERACTION WITH F007 (AUTO-CONFIRM)

Backdated vendor credits are still auto_confirmed:
```
Vendor backdates credit to June 15 → status=auto_confirmed, is_locked=true
Balance updates immediately (at time of API call, today)
```

The entry DATE is June 15 but the balance adjustment happens NOW (when the API call is made). This is correct — we're not retroactively reconstructing balance history, just recording an entry at a past date for record-keeping.

---

## 7. INTERACTION WITH F009 (DATE DIVIDERS)

F009 adds date divider headers to the entries list (grouped by `entry.date`). Backdated entries will appear under their correct date group:

```
TODAY — 1 Jul 2026
  Adjustment: -₹10 (created today but dated today)

MONDAY — 15 Jun 2026
  Milk delivery: ₹60 (backdated to Jun 15, added today)
  
SUNDAY — 14 Jun 2026  
  Milk delivery: ₹60 (regular entry from Jun 14)
```

The date dividers MUST use `entry.date` not `entry.created_at` for this to work correctly.

---

## 8. ALL 3 ROLES

| Role | Can Backdate? | Types |
|---|---|---|
| Vendor | Yes | credit, adjustment |
| Customer | Yes | payment, advance |
| Staff | Yes | credit, adjustment (on vendor's behalf) |

All roles get the same date picker UI in their respective `AddEntrySheet` variant. The business rules (F007 auto-confirm for vendor credits) apply regardless of the entry date.

---

## 9. EDGE CASES

| Case | Behavior |
|---|---|
| Backdate to before the link was created | Allowed — the entry date is informational. The link.created_at is not validated against. |
| Backdate to same date as a disputed entry | Allowed — entries are independent records. |
| Future date sent in API | Rejected with 400: "Date must be between 1 year ago and today" |
| Date > 1 year ago sent | Rejected with 400 |
| Date omitted from API call | Defaults to NOW() — existing behavior preserved |
| Two entries backdated to same date | Both appear under same date divider, sub-sorted by created_at |
| Backdated entry changes monthly delivery count (F009) | Yes — monthly view (deliveries tab) uses entry.date, so backdated deliveries count in that month |

---

## 10. REQUIRED DB CHANGES

None. `ledger_entries.date` column already exists and accepts past timestamps.

---

## 11. REQUIRED BACKEND CHANGES

| File | Change |
|---|---|
| `src/app/modules/ledger/validators/ledger.validators.ts` | Add date validation: no future, max 1yr backdate |
| `src/app/modules/ledger/repositories/ledger.repository.ts` | Change sort: `ORDER BY date DESC, created_at DESC` |

---

## 12. REQUIRED FRONTEND CHANGES

| File | Change |
|---|---|
| `AddEntrySheet` widget | Add optional date picker row, `_selectedDate` state, include date in `AddLedgerEntry` event |
| `AddLedgerEntry` event (LedgerBloc) | Add `date: DateTime?` param |
| `LedgerRepositoryImpl.addEntry()` | Include `date` in body only when `event.date != null` |
| Date divider logic (F009) | Use `entry.date` not `entry.created_at` for grouping |

---

## 13. TESTING STRATEGY

- [ ] Vendor adds entry with yesterday's date → entry appears under yesterday's date divider
- [ ] Date picker shows only today and past dates (calendar future dates are disabled)
- [ ] Date > 1 year ago → backend returns 400
- [ ] Future date → backend returns 400
- [ ] Omitting date → backend defaults to today (existing behavior unchanged)
- [ ] Backdated vendor credit → auto_confirmed (F007 rule still applies)
- [ ] Backdated entry appears in correct position after sort-by-date change
- [ ] Monthly delivery view (F009) includes backdated delivery in its correct month

---

## 14. ROLLBACK

- Remove date picker from `AddEntrySheet` (frontend change only)
- Revert sort order change in repository (entries re-sort by created_at)
- Remove backend date validation (or keep it — it's non-breaking)
- No data migration needed in either direction

---

## 15. RISKS

| Risk | Likelihood | Mitigation |
|---|---|---|
| Sort order change reorders UI for existing users | Low | Existing entries have date=created_at, so sort result is identical |
| Backdated entries confuse balance history | Low | Balance is a running total; entry date is cosmetic for display only |
| Vendor backdates to manipulate appearance of dues | Low | Balance still reflects confirmed totals; entry date doesn't affect balance calculation |
