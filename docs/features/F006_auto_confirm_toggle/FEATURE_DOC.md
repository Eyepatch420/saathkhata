# F006 — Customer Auto-Confirm Toggle

**Status:** Planned  
**Priority:** High  
**Requested by:** Vendor/Customer UX feedback  
**Affects:** Backend (`vendor_customer_links`, `ledger.service.ts`, `link.service.ts`, `link.routes.ts`), Flutter (`SettingsScreen`, `SharedLedgerScreen`, link models, customer repository)

---

## 1. Background and Motivation

Today every entry — regardless of whether the vendor or customer created it — starts with `status = 'pending'` and waits for the other party to tap Confirm. For many long-standing vendor-customer relationships this friction is unnecessary: the customer trusts the vendor's records and always confirms them. The feature request asks for a way to skip this manual confirm step entirely so that vendor-added credit entries are accepted the moment the vendor saves them.

This is a **per-link** preference controlled exclusively by the customer. A customer might auto-confirm entries from their daily vegetable vendor while keeping manual confirm on for a less-trusted supplier.

> **Interaction with F007:** F007 (in the next document) makes vendor credits unconditionally auto-confirmed at the server level, regardless of any toggle. F006 is therefore most meaningful as a user-facing setting that communicates intent and provides a future-proofing mechanism for edge cases (e.g., a hypothetical vendor type that does not fall under F007's rule). Implement F006 first as the preference layer; F007 enforces it at the business-logic level.

---

## 2. Current Flow

```
Vendor taps "Add Credit" (udhaar diya)
  └─ POST /api/v1/links/:linkId/entries
       └─ ledger.service.ts addEntry()
            └─ ledger_entries INSERT → status='pending', is_locked=false
  (No balance change yet)
Customer opens SharedLedgerScreen
  └─ Sees entry card with Confirm / Dispute buttons
       └─ Taps Confirm → POST /api/v1/entries/:entryId/confirm
            └─ ledger.service.ts confirmEntry()
                 └─ status='confirmed', is_locked=true
                 └─ linkRepo.adjustBalance(linkId, +amount)
```

The customer must manually act. If they never tap Confirm, the balance never updates and both parties are left in limbo.

---

## 3. Proposed Flow (with Auto-Confirm ON)

```
Vendor taps "Add Credit"
  └─ POST /api/v1/links/:linkId/entries
       └─ ledger.service.ts addEntry()
            └─ Reads link.customer_auto_confirm (new column)
            └─ IF true AND isVendorSide AND type='credit':
                 └─ INSERT → status='auto_confirmed', confirmed_at=NOW(), is_locked=true
                 └─ linkRepo.adjustBalance(linkId, +amount)   ← same transaction
            └─ ELSE: INSERT → status='pending' (existing path)
  Real-time socket: ledger:entry_added fires with the entry already confirmed
  Push notification to customer: "₹X added to your khata by [Vendor]"
```

No action required from the customer. The entry is locked and the balance reflects it immediately.

---

## 4. Data Model Change

### 4.1 New Column

**Table:** `vendor_customer_links`

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `customer_auto_confirm` | `BOOLEAN` | NOT NULL | `true` | When true, vendor/staff-created credit entries are auto-confirmed on this link |

### 4.2 Migration

**File:** `migrations/20260036_add_customer_auto_confirm_to_links.ts`

```typescript
import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.alterTable('vendor_customer_links', (table) => {
    table
      .boolean('customer_auto_confirm')
      .notNullable()
      .defaultTo(true);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.alterTable('vendor_customer_links', (table) => {
    table.dropColumn('customer_auto_confirm');
  });
}
```

All existing links get `customer_auto_confirm = true` automatically via the `DEFAULT true` clause applied during the ALTER — no backfill script needed.

### 4.3 TypeScript Type Update

In `src/app/modules/links/types/link.types.ts`, add the new field to `DbVendorCustomerLink`:

```typescript
export interface DbVendorCustomerLink {
  // ... existing fields ...
  customer_auto_confirm: boolean;   // ← ADD THIS
}
```

Also add to `LinkResponse` and `VendorLinkItem`/`CustomerLinkItem` so the frontend can read it:

```typescript
export interface LinkResponse {
  // ... existing fields ...
  customerAutoConfirm: boolean;
}

export interface VendorLinkItem {
  // ... existing fields ...
  // NOT exposed here — vendor cannot read or act on this preference
}

export interface CustomerLinkItem {
  // ... existing fields ...
  // NOT exposed to vendor either — purely a customer-side preference
}
```

Add `customerAutoConfirm` only to the response object returned by `getLinkById()` for the customer's own requests, or add it as a dedicated field on a new `CustomerLinkSettings` response shape.

---

## 5. Backend Changes

### 5.1 `ledger.service.ts` — `addEntry()` Logic Branch

**File:** `src/app/modules/ledger/services/ledger.service.ts`

Current code at line 162 always inserts `status: 'pending'`. The change adds a check immediately before the `create()` call:

```typescript
async addEntry(
  linkId: string,
  userId: string,
  input: AddEntryInput,
  staff?: StaffContext,
): Promise<LedgerEntryResponse> {
  const { link, actorId, isVendorSide } = await this._resolveLinkAccess(linkId, userId, staff);
  if (!link.is_active) throw new BadRequestError('This link is no longer active');

  const isCustomer = !staff && link.customer_id === userId;
  if (isCustomer && input.type !== 'payment') {
    throw new ForbiddenError('Customers can only add payment entries');
  }

  // ── F006: Auto-confirm check ──────────────────────────────────────────────
  // A credit entry created by the vendor side is auto-confirmed when the customer
  // has opted into auto-confirm for this link.
  const shouldAutoConfirm =
    isVendorSide &&
    input.type === 'credit' &&
    link.customer_auto_confirm === true;

  const initialStatus: EntryStatus = shouldAutoConfirm ? 'auto_confirmed' : 'pending';
  const confirmedAt: Date | null = shouldAutoConfirm ? new Date() : null;
  const isLocked: boolean = shouldAutoConfirm;
  // ─────────────────────────────────────────────────────────────────────────

  // ... parent entry validation ...

  const db = getDb();
  const trx = await db.transaction();
  try {
    const entry = await this.ledgerRepo.create(
      {
        // ... other fields ...
        status: initialStatus,          // ← was hardcoded 'pending'
        confirmed_at: confirmedAt,      // ← was hardcoded null
        is_locked: isLocked,            // ← was hardcoded false
        // ...
      },
      trx,
    );

    if (input.parentEntryId) {
      await this.ledgerRepo.incrementChildCount(input.parentEntryId, trx);
    }

    // ── F006: Adjust balance inside the SAME transaction if auto-confirmed ──
    if (shouldAutoConfirm && !input.parentEntryId) {
      // Only top-level (non-child) entries affect balance — same rule as confirmEntry().
      const delta = balanceDelta(input.type, input.amount);
      await this.linkRepo.adjustBalance(linkId, delta, trx);
    }

    await trx.commit();

    await invalidateVendorReports(link.vendor_id);

    emitLedgerEvent('ledger:entry_added', linkId, { linkId, entry: formatEntry(entry) });

    // Notify customer when vendor auto-adds a credit entry
    if (shouldAutoConfirm) {
      await enqueueNotification({
        recipientUserId: link.customer_id,
        type: 'entry_auto_confirmed',
        title: 'Khata Updated',
        body: `₹${input.amount.toFixed(0)} added to your khata`,
        data: { linkId, entryId: entry.id, amount: input.amount },
      });
    }

    return formatEntry(entry);
  } catch (err) {
    await trx.rollback();
    throw err;
  }
}
```

**Key invariant maintained:** `balanceDelta` and `adjustBalance` are called inside the same Knex transaction that inserts the entry, identical to how `confirmEntry()` handles it. There is no window where the entry exists without the balance being updated.

### 5.2 New Endpoint — Toggle Auto-Confirm

**Route:** `PATCH /api/v1/links/:linkId/auto-confirm`  
**Auth:** Customer only (or either party where the caller is the customer — service enforces)  
**Body:** `{ "enabled": boolean }`

#### Route (`link.routes.ts`)

```typescript
/**
 * PATCH /api/v1/links/:linkId/auto-confirm
 * Customer toggles auto-confirm for vendor-created credits on this link.
 * Default is ON (true). Only the customer on the link can change this.
 */
router.patch('/:linkId/auto-confirm', authorize('customer'), linkController.updateAutoConfirm);
```

#### Service (`link.service.ts`)

```typescript
async updateAutoConfirm(
  linkId: string,
  customerId: string,
  enabled: boolean,
): Promise<void> {
  const link = await this.linkRepo.findById(linkId);
  if (!link) throw new NotFoundError('Link not found');
  if (link.customer_id !== customerId) throw new ForbiddenError('Only the customer on this link can change auto-confirm');
  if (!link.is_active) throw new BadRequestError('Link is not active');

  await getDb()('vendor_customer_links')
    .where({ id: linkId })
    .update({ customer_auto_confirm: enabled, updated_at: new Date() });

  logger.info('Auto-confirm updated', { linkId, customerId, enabled });
}
```

#### Controller (`link.controller.ts`)

```typescript
updateAutoConfirm = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    if (!req.user) throw new UnauthorizedError();
    const { enabled } = req.body;
    if (typeof enabled !== 'boolean') throw new ValidationError('"enabled" must be a boolean');
    await this.linkService.updateAutoConfirm(req.params.linkId, req.user.sub, enabled);
    sendSuccess(res, null, 'Auto-confirm preference updated');
  } catch (error) {
    next(error);
  }
};
```

#### Validator (Zod)

```typescript
export const updateAutoConfirmSchema = z.object({
  enabled: z.boolean(),
});
```

---

## 6. Frontend — Flutter Changes

### 6.1 Model Update

**File:** `lib/shared/models/ledger_entry.dart` — no change needed; `EntryStatus.autoConfirmed` already exists.

**File:** `lib/features/vendor/domain/models/vendor_link.dart` (or wherever `VendorLinkItem` is modeled) — no change needed; vendor does not see this field.

**Customer link model** (wherever the customer's `VendorLinkItem` is defined in Dart):

```dart
class CustomerVendorLink {
  // ... existing fields ...
  final bool customerAutoConfirm;   // ← ADD

  // fromJson:
  customerAutoConfirm: json['customerAutoConfirm'] as bool? ?? true,
}
```

### 6.2 Customer Repository — New Toggle Method

**File:** `lib/features/customer/domain/repositories/customer_repository.dart`

```dart
abstract class CustomerRepository {
  // ... existing methods ...
  Future<void> updateAutoConfirm(String linkId, {required bool enabled});
}
```

**Implementation** in `lib/features/customer/data/repositories/customer_repository_impl.dart`:

```dart
@override
Future<void> updateAutoConfirm(String linkId, {required bool enabled}) async {
  await _apiClient.patch(
    '/links/$linkId/auto-confirm',
    data: {'enabled': enabled},
  );
}
```

### 6.3 Settings Screen — New "Ledger Preferences" Section

**File:** `lib/features/settings/presentation/screens/settings_screen.dart`

Add a new section visible only to customers, placed after "Account Settings" and before "Legal Info":

```dart
// Inside SettingsScreen.build(), after the _SectionLabel(label: l10n.accountSettings) block:

BlocBuilder<AuthBloc, AuthState>(
  buildWhen: (_, s) => s is AuthAuthenticated,
  builder: (context, authState) {
    final user = authState is AuthAuthenticated ? authState.user : null;
    if (user == null || user.isVendor) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        _SectionLabel(label: 'Ledger Preferences'),
        const SizedBox(height: 8),
        _SettingsTile(
          icon: Icons.auto_awesome_rounded,
          title: 'Auto-Confirm Entries',
          subtitle: 'Manage per-vendor auto-confirm settings',
          onTap: () => context.push(AppRouter.ledgerPreferences),
        ),
      ],
    );
  },
),
```

#### New Screen: `LedgerPreferencesScreen`

**File:** `lib/features/settings/presentation/screens/ledger_preferences_screen.dart`

This screen lists all the customer's active vendor links with a `SwitchListTile` per row:

```dart
class LedgerPreferencesScreen extends StatefulWidget {
  const LedgerPreferencesScreen({super.key});
  // ...
}

// For each vendor link:
SwitchListTile(
  title: Text(link.vendor.businessName ?? link.vendor.name),
  subtitle: Text(link.customerAutoConfirm
      ? 'Auto-confirming vendor entries'
      : 'Manual confirmation required'),
  value: link.customerAutoConfirm,
  onChanged: (val) async {
    await getIt<CustomerRepository>()
        .updateAutoConfirm(link.linkId, enabled: val);
    // reload list
  },
  activeColor: AppColors.primary,
  secondary: CircleAvatar(
    backgroundImage: link.vendor.profilePhotoUrl != null
        ? NetworkImage(link.vendor.profilePhotoUrl!)
        : null,
    child: link.vendor.profilePhotoUrl == null
        ? const Icon(Icons.store_rounded)
        : null,
  ),
),
```

### 6.4 SharedLedgerScreen — Inline Toggle in Header

**File:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/balance_header.dart`

When the viewer is the customer (`!isVendorView`), surface a small toggle row beneath the balance chip:

```dart
// Customer-only sub-row inside LedgerBalanceHeader:
if (!isVendorView)
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.textHint),
      const SizedBox(width: 4),
      Text('Auto-confirm', style: AppTypography.bodySmall),
      const SizedBox(width: 8),
      Switch.adaptive(
        value: _autoConfirm,       // local state loaded from link model
        onChanged: _onToggleAutoConfirm,
        activeColor: AppColors.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ],
  ),
```

The widget must hold a `bool _autoConfirm` in local state, initialized from the link model fetched by the parent, and call `CustomerRepository.updateAutoConfirm()` on change with a rollback on error.

**New route** to add in `app_router.dart`:

```dart
GoRoute(
  path: '/settings/ledger-preferences',
  name: AppRouter.ledgerPreferences,
  builder: (_, __) => const LedgerPreferencesScreen(),
),
```

---

## 7. State Management

There is no BLoC needed for the auto-confirm toggle itself — it is a one-shot async mutation. Use local `StatefulWidget` state in the `LedgerPreferencesScreen` and `LedgerBalanceHeader` widget. Pattern:

1. Load the `customerAutoConfirm` value from the link model (already in memory from the customer's vendor list fetch).
2. Optimistically flip local state when the user toggles.
3. Call repository; on error, flip back and show a snackbar.

If the `LedgerBloc` ever needs to be aware of the auto-confirm setting (e.g., to conditionally show a "pending" badge), add `bool customerAutoConfirm` to `LedgerLoaded` state and populate it during `_onLoadLedger` from a link detail fetch.

---

## 8. Interaction with Dispute

When `customer_auto_confirm = true`, a vendor credit is immediately set to `status='auto_confirmed', is_locked=true`. The `is_locked=true` flag is the gating mechanism for all mutation endpoints. In `disputeEntry()` (line 325 of `ledger.service.ts`):

```typescript
if (locked.is_locked) {
  await trx.rollback();
  throw new BadRequestError('Entry is locked and cannot be modified');
}
```

**Result:** An auto-confirmed entry **cannot be disputed**. This is an intentional design tradeoff — the customer opted in to auto-confirm, thereby waiving the right to dispute on a per-entry basis.

**Mitigation:** The customer retains three recourse mechanisms:
1. Turn off auto-confirm at any time (affects future entries only — existing locked entries are immutable).
2. Record an offsetting `payment` or `adjustment` entry to correct the balance (payment entries go through the normal vendor-confirm flow).
3. Contact the vendor directly; the vendor can (in a future admin flow) create a correcting `adjustment` entry.

**Document this prominently** in the UI toggle tooltip or help text: "When ON, vendor entries are accepted automatically and cannot be disputed."

---

## 9. Staff-Created Credit Entries

`_resolveLinkAccess()` returns `isVendorSide: true` for staff acting on the owner vendor's data (see `ledger.service.ts` lines 91–100). The `shouldAutoConfirm` check at line 5.1 evaluates `isVendorSide` — it is `true` for staff. Therefore staff-created credit entries **also auto-confirm** when the customer has `customer_auto_confirm = true`. This matches real-world behaviour: the staff is acting as an agent of the vendor.

---

## 10. Multi-Item (Parent/Child) Entries

`AddMultiItemLedgerEntry` in `ledger_bloc.dart` (line 109) creates one parent entry then N child entries sequentially, each via `addEntry()`. With F006:

- The **parent** entry auto-confirms (`shouldAutoConfirm = true`) → balance adjusted once for the total.
- Each **child** entry also auto-confirms → `shouldAutoConfirm = true` BUT `!input.parentEntryId` is false for children, so `adjustBalance` is NOT called for children (same rule as `confirmEntry()` line 265). Correct.
- Net effect: balance is adjusted exactly once (for the parent total). All entries are locked immediately.

---

## 11. Socket Events

No change to the socket event name. `emitLedgerEvent('ledger:entry_added', ...)` fires with the entry already in `auto_confirmed` state. Flutter's `_onSocketEntryAdded` handler (ledger_bloc.dart line 264) receives it, adds it to `allEntries`, and `_calcBalance` correctly counts `autoConfirmed` entries because it already handles that status at line 31–32:

```dart
if (entry.status != EntryStatus.confirmed &&
    entry.status != EntryStatus.autoConfirmed) {
  continue;
}
```

No Flutter balance calculation changes required.

---

## 12. API Changes Summary

| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| `PATCH` | `/api/v1/links/:linkId/auto-confirm` | Customer JWT | Set `customer_auto_confirm` on a link |
| (modified) | `POST /api/v1/links/:linkId/entries` | Vendor / Staff JWT | Now auto-confirms when `customer_auto_confirm=true` |
| `GET` | `/api/v1/links/:linkId` | Customer JWT | Returns `customerAutoConfirm` field in response |

No breaking changes to existing API consumers — all additions are additive new fields.

---

## 13. Localization

New strings required in `lib/l10n/app_en.arb` (and all 9 language ARB files):

```
"ledgerPreferences": "Ledger Preferences",
"autoConfirmEntries": "Auto-Confirm Entries",
"autoConfirmEntriesSubtitle": "Manage per-vendor auto-confirm settings",
"autoConfirmOn": "Auto-confirming vendor entries",
"autoConfirmOff": "Manual confirmation required",
"autoConfirmWarning": "When ON, vendor entries are accepted automatically and cannot be disputed.",
"autoConfirmToggleTitle": "Auto-confirm",
```

---

## 14. Testing

### Backend Tests

- `POST /links/:id/entries` with `customer_auto_confirm=true` → entry `status=auto_confirmed, is_locked=true`, balance updated in same transaction.
- `POST /links/:id/entries` with `customer_auto_confirm=false` → entry `status=pending, is_locked=false`, balance unchanged.
- `POST /links/:id/entries` by customer (payment type) with `customer_auto_confirm=true` → NOT auto-confirmed (rule only applies to vendor-side credit entries).
- `PATCH /links/:id/auto-confirm` by vendor → 403 Forbidden.
- `PATCH /links/:id/auto-confirm` by customer → 200, column updated.
- Dispute auto-confirmed entry → 400 `Entry is locked`.
- Staff creates credit on link with `customer_auto_confirm=true` → auto-confirmed.
- Parent + child multi-item: parent auto-confirmed, balance adjusted once, children locked, no extra balance adjustment.

### Flutter Tests

- `LedgerBloc._calcBalance` correctly counts `autoConfirmed` entries (already does — verify no regression).
- `LedgerPreferencesScreen` renders a `SwitchListTile` per link with correct initial value.
- Toggle fires `CustomerRepository.updateAutoConfirm()` with correct `enabled` value.
- Toggle error → rollback local state, snackbar shown.

---

## 15. Rollback Plan

1. Set `customer_auto_confirm = false` for all links via SQL (`UPDATE vendor_customer_links SET customer_auto_confirm = false`). This disables auto-confirm for all existing links without any code change.
2. Deploy previous build without F006 code.
3. Run migration `down()` to drop the column.

Existing `auto_confirmed` entries that were created during the rollout window remain locked. They are valid ledger records and do not need to be reverted. If a customer disputes a batch, handle via manual `adjustment` entries.

---

## 16. Open Questions / Decisions Required

| # | Question | Recommended Default |
|---|----------|---------------------|
| 1 | Should `auto_confirmed` entries be visually distinct from `confirmed` (different chip label/colour)? | Yes — show "Auto" chip in a lighter shade of `AppColors.success` |
| 2 | Should vendor see the customer's auto-confirm preference in their customer list? | No — vendor cannot act on it; showing it adds cognitive load |
| 3 | When a customer turns auto-confirm OFF mid-relationship, should the vendor be notified? | Optional push: "Customer has disabled auto-confirm for new entries" |
| 4 | Should staff be able to override auto-confirm per entry (opt into pending even when auto-confirm is ON)? | Out of scope for F006 |
