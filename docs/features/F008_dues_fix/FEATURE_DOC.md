# F008 — Ledger Dues Fix

**Status:** READY TO IMPLEMENT
**Priority:** HIGH (visible bug, affects all 3 roles)
**Estimated Effort:** Frontend 1h · Backend 0h (no schema/API change needed)
**Depends on:** None (self-contained filter logic fix)
**Blocking:** F009 (tab redesign references "Dues" concept corrected here)

---

## 1. CURRENT STATE

### 1.1 The Bug

Opening the Shared Ledger for any customer and tapping the **Pending** filter chip shows ALL entries with `status = pending` — including **payment entries** (`type = 'payment'`). Payments are what the customer gave the vendor ("paisa diya"). These should never appear in a "Dues" context because dues represent what the customer owes, not what they have already paid.

### 1.2 Where the Filter Lives

`LedgerFilterBar` in:
```
lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/filter_bar.dart
```

It dispatches `FilterLedger(EntryStatus.pending)` when the user taps the Pending chip. The handler in `LedgerBloc._applyFilter()` is:

```dart
// lib/features/shared_ledger/presentation/bloc/ledger_bloc.dart  line 44-47
List<LedgerEntry> _applyFilter(List<LedgerEntry> all, EntryStatus? filter) {
  if (filter == null) return all;
  return all.where((e) => e.status == filter).toList();
}
```

This is a pure status filter. It does not consider `entry.type`. Result: a pending payment entry (`type = 'payment', status = 'pending'`) passes the filter and appears alongside pending credits.

### 1.3 Why Payment Entries Are Pending

When a customer records a payment, the backend creates the entry with:
- `type = 'payment'`
- `status = 'pending'`

The entry stays `pending` until the **vendor** confirms receipt of the cash. So a payment entry is legitimately pending — it just does not belong in a "what the customer owes" view.

### 1.4 Current Filter Chips (Filter Bar)

| Chip label | `filterStatus` dispatched | Bug impact |
|---|---|---|
| All | `null` | No bug — shows everything |
| Pending | `EntryStatus.pending` | **BUG** — shows pending payments alongside pending credits |
| Confirmed | `EntryStatus.confirmed` | No bug — confirmed payments and credits are both valid to show |
| Disputed | `EntryStatus.disputed` | No bug — no concept of disputed payments in typical flow |

### 1.5 Interaction with F007 (Auto-Confirm Toggle)

F006/F007 introduced `customer_auto_confirm` on the link. When this is enabled:
- Vendor credits are created with `status = 'auto_confirmed'` immediately.
- There are no "pending credits" in this mode — they jump straight to auto_confirmed.

This means: after F007, the Pending filter for credits can be nearly empty for links with auto-confirm on. A user might see only pending payments under "Pending," making the bug even more confusing. The fix is still required.

---

## 2. THE BUG IN DETAIL

### 2.1 Reproduction Steps

1. Log in as customer (test phone `8000000002`).
2. Open a shared ledger.
3. Record a payment (`type = 'payment'`). It lands as `status = 'pending'` waiting for vendor confirmation.
4. Tap the **Pending** chip in the filter bar.
5. **Observed:** The payment entry appears under Pending.
6. **Expected:** Only credit entries (what customer owes) should appear under a dues/pending context.

### 2.2 Data Perspective

Given these entries on a link:

| id | type | status | amount |
|---|---|---|---|
| e1 | credit | pending | ₹500 |
| e2 | payment | pending | ₹200 |
| e3 | credit | auto_confirmed | ₹300 |
| e4 | payment | confirmed | ₹100 |

Current Pending filter returns: `[e1, e2]` — includes the payment.

Correct Pending filter should return: `[e1]` — pending credits only.

If we want to show "what is owed" (all unresolved credits): `[e1, e3]` — both pending and auto_confirmed credits.

---

## 3. FIX APPROACH

### 3.1 Deciding What "Dues" Means

There are two valid interpretations; both require the same code path. The right one depends on business intent:

**Option A — Pending credits only**
Show entries where `status = pending AND type = credit`. These are credits the customer hasn't confirmed yet (in manual-confirm mode). After F007 auto-confirm, this list is empty for those links.

**Option B — All outstanding credits (recommended)**
Show entries where `type = credit AND status IN (pending, auto_confirmed)`. These are all credits that represent the customer's debt, whether confirmed by both parties or auto-confirmed. This is the true "what is owed" view.

**Decision: Option B.** The filter chip should be renamed from "Pending" to "Dues" and show all credit-type entries regardless of their confirmation status. This aligns with the user's mental model: "dues" = what I owe, not "which entries are unconfirmed."

### 3.2 New `_applyFilter` Logic

The current `_applyFilter` takes a single `EntryStatus?`. We need a richer filter. Two approaches:

**Approach 1 — Add a dedicated `duesFilter` flag to `FilterLedger`** (recommended)

```dart
// Updated FilterLedger event
class FilterLedger extends LedgerEvent {
  final EntryStatus? filterStatus;
  final bool duesOnly;  // NEW: when true, show only credit-type entries
  const FilterLedger(this.filterStatus, {this.duesOnly = false});
  @override
  List<Object?> get props => [filterStatus, duesOnly];
}
```

```dart
// Updated _applyFilter in LedgerBloc
List<LedgerEntry> _applyFilter(
  List<LedgerEntry> all,
  EntryStatus? filter, {
  bool duesOnly = false,
}) {
  var list = all;

  // Dues = credit entries only (pending or auto_confirmed — what customer owes)
  if (duesOnly) {
    list = list.where((e) =>
      e.type == EntryType.credit &&
      (e.status == EntryStatus.pending ||
       e.status == EntryStatus.autoConfirmed)
    ).toList();
    return list;
  }

  // Standard status filter
  if (filter == null) return list;
  return list.where((e) => e.status == filter).toList();
}
```

**Approach 2 — Extend EntryStatus filter to also accept a type mask** (more complex, skip for now)

Approach 1 is simpler and self-contained. Use it.

### 3.3 Updated `_onFilterLedger` Handler

```dart
void _onFilterLedger(FilterLedger event, Emitter<LedgerState> emit) {
  final current = state;
  if (current is! LedgerLoaded) return;
  emit(LedgerLoaded(
    allEntries: current.allEntries,
    entries: _applyFilter(
      current.allEntries,
      event.filterStatus,
      duesOnly: event.duesOnly,   // NEW
    ),
    balance: current.balance,
    activeFilter: event.filterStatus,
    activeDuesFilter: event.duesOnly,   // store flag in state
  ));
}
```

### 3.4 `LedgerLoaded` State Change

Add `activeDuesFilter` field to `LedgerLoaded`:

```dart
class LedgerLoaded extends LedgerState {
  final List<LedgerEntry> allEntries;
  final List<LedgerEntry> entries;
  final double balance;
  final EntryStatus? activeFilter;
  final bool activeDuesFilter;   // NEW

  const LedgerLoaded({
    required this.allEntries,
    required this.entries,
    required this.balance,
    this.activeFilter,
    this.activeDuesFilter = false,   // NEW — default false
  });
}
```

All existing `LedgerLoaded(...)` construction sites already pass `activeFilter` and nothing else — adding `activeDuesFilter` with a default of `false` is backward-compatible.

### 3.5 Filter Bar UI Change

Rename the "Pending" chip to "Dues" and dispatch `FilterLedger(null, duesOnly: true)`:

```dart
// In filter_bar.dart — replace the Pending chip:
_LedgerFilterChip(
  label: l10n.filterDues,                   // NEW l10n key
  isActive: state is LedgerLoaded &&
            (state as LedgerLoaded).activeDuesFilter,
  color: AppColors.warning,
  onTap: () => context
      .read<LedgerBloc>()
      .add(const FilterLedger(null, duesOnly: true)),
),
```

The active check also changes: instead of `activeFilter == EntryStatus.pending`, check `activeDuesFilter == true`.

---

## 4. AFFECTED FILES

| File | Change |
|---|---|
| `lib/features/shared_ledger/presentation/bloc/ledger_event.dart` | Add `duesOnly` param to `FilterLedger` |
| `lib/features/shared_ledger/presentation/bloc/ledger_state.dart` | Add `activeDuesFilter` to `LedgerLoaded` |
| `lib/features/shared_ledger/presentation/bloc/ledger_bloc.dart` | Update `_applyFilter` + `_onFilterLedger` |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/filter_bar.dart` | Rename chip "Pending" → "Dues", dispatch updated event, update active check |
| `lib/l10n/app_en.arb` (and all 8 language ARBs) | Add `filterDues` key |

**No backend changes.** The fix is entirely client-side filter logic.

---

## 5. ROLE-BY-ROLE BEHAVIOR AFTER FIX

### 5.1 Vendor View

The vendor opens a specific customer's ledger. "Dues" chip shows:
- All credit entries (both `pending` and `auto_confirmed`) — these are what the vendor has charged/billed to the customer that haven't been fully settled by payments.
- Payment entries (both pending/confirmed/disputed) do NOT appear here.

From vendor's perspective: "Dues = how much this customer owes me right now."

### 5.2 Customer View

The customer opens a vendor's ledger. "Dues" chip shows:
- All credit entries the vendor has posted against the customer's account.
- Their own payment entries do NOT appear.

From customer's perspective: "Dues = how much I owe this vendor."

### 5.3 Staff View

Staff uses `SharedLedgerScreen` with `isStaffView = true` but otherwise sees the same data as the vendor. Dues filter behavior is identical to vendor view.

---

## 6. BALANCE CONSISTENCY

The `_calcBalance()` function in `LedgerBloc` is already correct — it only sums `confirmed` and `auto_confirmed` entries:

```dart
double _calcBalance(List<LedgerEntry> entries) {
  double balance = 0;
  for (final entry in entries) {
    if (entry.status != EntryStatus.confirmed &&
        entry.status != EntryStatus.autoConfirmed) continue;
    if (entry.type == EntryType.credit) {
      balance += entry.amount;
    } else {
      balance -= entry.amount;
    }
  }
  return balance;
}
```

The balance header (`LedgerBalanceHeader`) already shows the correct net due amount. The Dues filter is purely a visual tool for the entry list — it does not affect the balance calculation.

---

## 7. INTERACTION WITH OTHER FEATURES

### 7.1 F006 / F007 — Auto-Confirm Toggle

When `customer_auto_confirm = true` on a link:
- All vendor credits arrive as `auto_confirmed` immediately.
- The Dues filter (Option B) correctly includes `auto_confirmed` credits.
- Result: Dues filter shows the full unpaid credit history — exactly right.

When `customer_auto_confirm = false`:
- Vendor credits arrive as `pending`.
- Customer must confirm.
- Dues filter shows unconfirmed credits — correct.

### 7.2 F009 — Ledger Tab Redesign

F009 may restructure `SharedLedgerScreen` into tabs (Entries / Deliveries / Payments / Orders). If a "Dues" tab is introduced in that design, its filter condition should use the same logic defined here: `type = credit AND status IN (pending, auto_confirmed)`. The implementation in `_applyFilter` becomes the single source of truth.

### 7.3 Socket Updates

When a socket event (`SocketLedgerEntryUpdated`) arrives — e.g., a vendor confirms a payment — the updated entry passes through `_applyFilter(updatedAll, current.activeFilter, duesOnly: current.activeDuesFilter)`. If the user is on the Dues filter and a credit entry becomes `confirmed` (rare — credits are typically not "confirmed" by vendor; that concept is customer-side), it would drop out of the Dues view. This is correct behavior.

---

## 8. WHAT STAYS THE SAME

- The "All" chip continues to show all entries regardless of type or status.
- The "Confirmed" chip continues to show all confirmed entries (both credit and payment).
- The "Disputed" chip continues to show all disputed entries.
- The balance calculation is unchanged.
- No backend API changes.

---

## 9. L10N

Add one new key across all 9 ARB files:

```
filterDues
```

English value: `"Dues"`. Existing translations for `"Pending"` are used by the `statusPending` key which still refers to the status label in entry cards — do not rename that key.

---

## 10. TESTING STRATEGY

### 10.1 Manual Test Plan

| # | Action | Expected result |
|---|---|---|
| 1 | Vendor adds a credit entry (₹500) | Entry appears under "All" and "Dues" |
| 2 | Customer adds a payment (₹200) | Payment appears under "All" only, NOT under "Dues" |
| 3 | Tap "Dues" filter chip | Only credit entries shown; payment is absent |
| 4 | Vendor confirms customer's payment | Payment moves to confirmed; still absent from "Dues" |
| 5 | Customer confirms a credit | Credit moves to confirmed; **still appears in "Dues"** (because it's still a credit-type entry that hasn't been offset by a payment) |
| 6 | Pull-to-refresh while on "Dues" filter | Dues filter remains active after refresh |
| 7 | Socket: another device adds a credit entry | Entry appears in Dues list in real-time if Dues filter is active |
| 8 | Socket: another device adds a payment entry | Payment does NOT appear in Dues list |

### 10.2 Regression Check

- "All" filter: still shows all entry types.
- "Confirmed" filter: still shows confirmed credits and confirmed payments together.
- "Disputed" filter: unchanged.
- Balance header: unchanged — not affected by filter chip.

---

## 11. ROLLBACK PLAN

This is a pure client-side change. Rolling back means reverting the four Dart files listed in section 4 and the ARB files. No database migration involved. Deploy a hotfix by reverting the commit on the `macbook` branch.

---

## 12. OPEN QUESTIONS

| Question | Status | Decision |
|---|---|---|
| Should "Dues" include `confirmed` credits (i.e., entries the customer has accepted but not yet offset)? | Open | Current design includes `pending + auto_confirmed`. `confirmed` credits (customer-confirmed, vendor-posted) ARE part of the balance and arguably should also appear in Dues. Revisit after testing. |
| Should the "Dues" chip count show a badge with number of outstanding credit entries? | Deferred | Low priority; implement in F009 tab redesign. |
| Do we ever want "Dues" for payments specifically (vendor waiting for cash)? | No | Out of scope. Vendor can use "Pending" filter (which after this fix shows pending entries of all types) or a dedicated "Unconfirmed Payments" view in the future. |
