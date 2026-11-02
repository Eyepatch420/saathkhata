# F009 — Ledger Enhancements

**Status:** PLANNING
**Depends on:** F005 (Schedule/Subscription system — scheduled deliveries surface here)
**Roles affected:** Vendor, Customer, Staff (all 3 see date dividers and filters; some tabs are role-specific)

---

## 1. CURRENT STATE

### 1.1 SharedLedgerScreen layout

`SharedLedgerScreen` is a single-screen design — there are no tabs. It shows:

- `LedgerBalanceHeader` (fixed top)
- `MembershipBanner` (vendor-only, fixed)
- `LedgerFilterBar` — horizontal chip row: **All · Pending · Confirmed · Disputed** (status-only, client-side)
- `LedgerList` — flat `ListView` of `LedgerEntryCard` widgets, sorted by `created_at DESC` from the backend, pull-to-refresh supported

The AppBar has two icon buttons that push secondary screens:
- `Icons.local_shipping_outlined` → `DeliveriesScreen`
- `Icons.calendar_month_rounded` → `MonthlySettlementScreen`

### 1.2 DeliveriesScreen

A separate pushed screen. Reuses `LedgerBloc` via `BlocProvider.value`. Passes `filterDeliveriesOnly: true` to `LedgerList`, which client-side filters entries where `entry.isDelivery == true` (description starts with `"Order delivery"`). No Orders concept exists here.

### 1.3 LedgerBloc — existing events

```dart
LoadLedger(linkId)          // initial load, emits LedgerLoading → LedgerLoaded
AddLedgerEntry(...)         // optimistic prepend
AddMultiItemLedgerEntry(...)
ConfirmLedgerEntry(entryId)
DisputeLedgerEntry(entryId, reason)
FilterLedger(status?)       // client-side status filter only
RefreshLedger(linkId)       // pull-to-refresh, no LedgerLoading emitted
SocketLedgerEntryAdded(entry)
SocketLedgerEntryUpdated(entry)
```

### 1.4 LedgerLoaded state

```dart
class LedgerLoaded extends LedgerState {
  final List<LedgerEntry> allEntries;  // full unfiltered list
  final List<LedgerEntry> entries;     // post-filter slice
  final double balance;
  final EntryStatus? activeFilter;     // single status filter or null
}
```

### 1.5 Repository / backend

`LedgerRepositoryImpl.getEntries()` calls:
```
GET /links/:linkId/entries?page=1&limit=100
```
Returns `{ entries: [...], total: N }`. The `total` field exists but is currently ignored.

Backend `ledgerQuerySchema` already accepts:
- `page`, `limit`
- `status` — enum: `pending | confirmed | disputed | auto_confirmed`
- `type` — enum: `credit | payment | advance | adjustment`

Backend `LedgerRepository.findByLinkId()` applies these via Knex `.andWhere()`. The ORDER is `created_at DESC`.

### 1.6 Date field

`LedgerEntry.date` is a `DateTime` parsed from the backend `date` column (a TIMESTAMP). Entries can be backdated (F010). The list is currently ordered by `created_at`, not `date`.

---

## 2. WHAT CHANGES

### 2.1 Tab restructure in SharedLedgerScreen

Convert the single-body layout into a `TabBar` + `TabBarView` with four tabs:

| Tab | Icon | Contents |
|-----|------|---------|
| **Entries** | `receipt_long_rounded` | All ledger entries (default tab) with date dividers |
| **Deliveries** | `local_shipping_outlined` | Delivery entries + scheduled deliveries (F005); monthly grouping toggle |
| **Orders** | `shopping_bag_outlined` | `orders` table records for this link — what the customer ordered |
| **Payments** | `payments_rounded` | Entries where `type == payment` or `type == advance` |

The existing AppBar icon buttons for Deliveries and Monthly Statement are removed — the functionality moves into the tabs.

The `LedgerFilterBar` chip row remains but is enhanced (see §2.4). It is shown only in the **Entries** tab. Each tab may have its own lighter filter controls inline.

### 2.2 Orders tab vs Deliveries tab — the distinction

- **Orders tab:** Shows `orders` records (`GET /orders/customer` or `GET /orders/vendor`) for this specific `link_id`. These are the customer's placed orders (pending / confirmed / rejected / delivered). Vendor and staff see all orders placed by this customer. Customer sees their own orders with this vendor.
- **Deliveries tab:** Shows `ledger_entries` where `isDelivery == true` (auto-created credit entries when an order is delivered), PLUS — after F005 — scheduled delivery entries flagged with a "Scheduled" badge. This is delivery-execution history.

The key distinction: Orders = intent (what was ordered). Deliveries = fulfilment (what was actually delivered and credited).

### 2.3 Monthly view for Deliveries tab

The Deliveries tab header area has a toggle button (list icon vs calendar icon). When toggled to **Monthly view**:

- Entries are grouped by `yyyy-MM` from `entry.date`
- Each group is headed by an expandable `_MonthHeader` widget
- `_MonthHeader` shows: `"June 2026  —  8 deliveries · ₹4,250"`
- Tap the header to collapse/expand that month's entries
- Default state: current month expanded, previous months collapsed
- List order: most recent month first

### 2.4 Date dividers in Entries list

All three roles see this in the **Entries** tab.

The existing flat `ListView` in `LedgerList` is replaced with a mixed list of:
- `_DateDivider` widgets (non-interactive headers)
- `LedgerEntryCard` widgets

Grouping key = `entry.date` (NOT `created_at`), so backdated entries (F010) appear in the correct chronological position.

Label rules:
- Today's date → `"Today"`
- Yesterday → `"Yesterday"`
- Within this calendar year → `"12 Jun"` (day + abbreviated month)
- Older than this year → `"12 Jun 2025"`

The list is sorted by `entry.date DESC` so the most recent group is at top.

### 2.5 Complete filter for Ledger (Entries tab)

The existing `LedgerFilterBar` is replaced by a richer filter system:

**Active filter chip row (always visible, horizontal scroll):**
```
[Filter icon btn]  [× Status: Pending]  [× Type: Credit]  [× Jun 2026]  [× ₹0–₹500]
```
Each chip shows the active value and an `×` to clear that dimension. The filter icon button opens the full filter panel.

**Full filter panel (Modal bottom sheet):**
```
┌────────────────────────────────────────────────────┐
│  Filter Entries                            [Reset] │
├────────────────────────────────────────────────────┤
│  STATUS                                            │
│  ○ All   ● Pending   ○ Confirmed   ○ Disputed      │
├────────────────────────────────────────────────────┤
│  TYPE                                              │
│  ○ All                                             │
│  ○ Credit (given)   ○ Payment (received)           │
│  ○ Advance          ○ Adjustment                   │
│  ○ Deliveries only                                 │
├────────────────────────────────────────────────────┤
│  DATE RANGE                                        │
│  From: [  Pick date  ]    To: [  Pick date  ]      │
├────────────────────────────────────────────────────┤
│  AMOUNT RANGE                                      │
│  Min: [₹___________]   Max: [₹___________]         │
├────────────────────────────────────────────────────┤
│          [  Apply Filter  ]                        │
└────────────────────────────────────────────────────┘
```

**Filter dimensions:**
- `status`: `null | pending | confirmed | disputed | auto_confirmed`
- `type`: `null | credit | payment | advance | adjustment | delivery` (delivery = isDelivery client-side)
- `dateFrom`: `DateTime?`
- `dateTo`: `DateTime?`
- `amountMin`: `double?`
- `amountMax`: `double?`

**Apply strategy:**
- If `allEntries.length < 100` (i.e., we have the full set) AND no date/amount filters are set: apply entirely client-side.
- If date or amount filters are set, OR `total > 100` (from backend response): re-fetch with query params — reset to page 1.

### 2.6 Pagination

**Current:** fetches all 100 entries once.

**New — infinite scroll with "Load more":**
- First load: `page=1, limit=50`
- A `_LoadMoreButton` appears at the bottom of `LedgerList` when `allEntries.length < total`
- Tapping dispatches `LoadMoreLedger(linkId, page: nextPage)`
- `LedgerBloc` appends the new page to `allEntries` without emitting `LedgerLoading`
- Pull-to-refresh resets to page 1 and replaces `allEntries`
- Socket events are prepended to `allEntries` regardless of pagination state

### 2.7 "Add to Schedule" from Deliveries tab

In the **Deliveries** tab, the FAB label changes to **"Add to Schedule"** (when F005 is implemented). Tapping opens the F005 subscription creation flow pre-filled with:
- `linkId` (from context)
- `vendorId` / `customerId` (from the link)
- Default product/qty/unit from `vendor_customer_links.default_*` fields

Until F005 is implemented, this button is hidden (feature-flagged).

### 2.8 Scheduled deliveries in Deliveries tab

When F005 is built, scheduled delivery entries (auto-generated on schedule trigger) arrive with a marker (e.g., `description` starts with `"Scheduled delivery"` or a new `source: 'schedule'` field on the entry). These entries in the Deliveries tab get a **"Scheduled"** badge chip overlaid on their `LedgerEntryCard`.

---

## 3. NEW DATA MODELS

### 3.1 LedgerFilter model

```dart
class LedgerFilter extends Equatable {
  final EntryStatus? status;
  final EntryType? type;
  final bool deliveriesOnly;      // maps to type filter client-side
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? amountMin;
  final double? amountMax;

  const LedgerFilter({
    this.status,
    this.type,
    this.deliveriesOnly = false,
    this.dateFrom,
    this.dateTo,
    this.amountMin,
    this.amountMax,
  });

  bool get isEmpty =>
    status == null && type == null && !deliveriesOnly &&
    dateFrom == null && dateTo == null &&
    amountMin == null && amountMax == null;

  int get activeCount {
    int n = 0;
    if (status != null) n++;
    if (type != null || deliveriesOnly) n++;
    if (dateFrom != null || dateTo != null) n++;
    if (amountMin != null || amountMax != null) n++;
    return n;
  }

  // Convert to backend query params (date + amount go to API; type/status can go either way)
  Map<String, dynamic> toQueryParams() => {
    if (status != null) 'status': status!.toJson(),
    if (type != null && !deliveriesOnly) 'type': type!.toJson(),
    if (dateFrom != null) 'from': dateFrom!.toUtc().toIso8601String(),
    if (dateTo != null) 'to': dateTo!.toUtc().toIso8601String(),
    if (amountMin != null) 'amount_min': amountMin,
    if (amountMax != null) 'amount_max': amountMax,
  };

  @override
  List<Object?> get props => [status, type, deliveriesOnly, dateFrom, dateTo, amountMin, amountMax];
}
```

### 3.2 Updated LedgerLoaded state

```dart
class LedgerLoaded extends LedgerState {
  final List<LedgerEntry> allEntries;   // all fetched entries (may be page 1..N concatenated)
  final List<LedgerEntry> entries;      // post-filter slice shown to UI
  final double balance;
  final LedgerFilter filter;            // replaces activeFilter: EntryStatus?
  final int currentPage;
  final int totalEntries;               // from backend response
  final bool isLoadingMore;             // true while LoadMoreLedger is in flight

  bool get hasMore => allEntries.length < totalEntries;
}
```

---

## 4. NEW LEDGER BLOC EVENTS

```dart
/// Load additional pages and append to allEntries.
class LoadMoreLedger extends LedgerEvent {
  final String linkId;
  const LoadMoreLedger(this.linkId);
}

/// Apply a full LedgerFilter. Triggers re-fetch if date/amount filters are set
/// OR if the loaded set is not the complete ledger (hasMore == true).
class ApplyLedgerFilter extends LedgerEvent {
  final LedgerFilter filter;
  const ApplyLedgerFilter(this.filter);
}

/// Clear all filters back to default.
class ClearLedgerFilter extends LedgerEvent {
  const ClearLedgerFilter();
}
```

The existing `FilterLedger(EntryStatus?)` event is deprecated; `ApplyLedgerFilter` replaces it. Keep `FilterLedger` as a thin wrapper for backward compatibility until all call sites are migrated.

---

## 5. BACKEND CHANGES

### 5.1 New query params on GET /links/:linkId/entries

Add to `ledgerQuerySchema` in `ledger.validators.ts`:

```typescript
export const ledgerQuerySchema = z.object({
  page:        z.coerce.number().int().positive().default(1),
  limit:       z.coerce.number().int().positive().max(100).default(50), // change default from 20 to 50
  status:      z.enum(ENTRY_STATUSES).optional(),
  type:        z.enum(ENTRY_TYPES).optional(),
  from:        z.string().datetime({ offset: true }).optional(),   // NEW
  to:          z.string().datetime({ offset: true }).optional(),   // NEW
  amount_min:  z.coerce.number().nonnegative().optional(),         // NEW
  amount_max:  z.coerce.number().positive().optional(),            // NEW
});
```

### 5.2 Repository changes in ledger.repository.ts

`findByLinkId` gains the new params:

```typescript
async findByLinkId(linkId: string, params: LedgerQueryParams) {
  const { page, limit, status, type, from, to, amount_min, amount_max } = params;

  const baseQuery = this.db<DbLedgerEntry>('ledger_entries')
    .where({ link_id: linkId })
    .whereNull('parent_entry_id');

  if (status)      baseQuery.andWhere({ status });
  if (type)        baseQuery.andWhere({ type });
  if (from)        baseQuery.andWhere('date', '>=', new Date(from));
  if (to)          baseQuery.andWhere('date', '<=', new Date(to));
  if (amount_min)  baseQuery.andWhere('amount', '>=', amount_min);
  if (amount_max)  baseQuery.andWhere('amount', '<=', amount_max);

  // ORDER by date DESC (not created_at) so backdated entries appear correctly
  const [{ count }] = await baseQuery.clone().count<[{ count: string }]>('id as count');
  const entries = await baseQuery.clone()
    .orderBy('date', 'desc')   // CHANGED from created_at to date
    .limit(limit)
    .offset((page - 1) * limit);

  return { entries, total: parseInt(count, 10) };
}
```

**Note:** Changing the ORDER to `date DESC` is required for the date divider feature to work correctly, and aligns with F010 (backdated entries). This is a non-breaking change — the response structure is the same.

### 5.3 Response shape (unchanged)

```json
{
  "success": true,
  "data": {
    "entries": [...],
    "total": 142
  },
  "message": "Entries retrieved"
}
```

---

## 6. FRONTEND CHANGES

### 6.1 SharedLedgerScreen — Tab conversion

```dart
class _SharedLedgerViewState extends State<SharedLedgerView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
```

Replace the `Column` body with:
```dart
body: Column(
  children: [
    LedgerBalanceHeader(...),
    if (widget.isVendorView && !widget.isStaffView) MembershipBanner(...),
    TabBar(
      controller: _tabController,
      tabs: [
        Tab(icon: Icon(Icons.receipt_long_rounded), text: l10n.tabEntries),
        Tab(icon: Icon(Icons.local_shipping_outlined), text: l10n.tabDeliveries),
        Tab(icon: Icon(Icons.shopping_bag_outlined), text: l10n.tabOrders),
        Tab(icon: Icon(Icons.payments_rounded), text: l10n.tabPayments),
      ],
    ),
    Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          EntriesTabView(linkId: ..., isVendorView: ..., isStaffView: ...),
          DeliveriesTabView(linkId: ..., isVendorView: ..., isStaffView: ...),
          OrdersTabView(linkId: ..., isVendorView: ..., isStaffView: ...),
          PaymentsTabView(linkId: ..., isVendorView: ..., isStaffView: ...),
        ],
      ),
    ),
  ],
),
```

### 6.2 Date divider widget

```dart
class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _label(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (d.year == now.year) return DateFormat('d MMM').format(d);
    return DateFormat('d MMM yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(children: [
        Expanded(child: Divider(thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(_label(context),
              style: const TextStyle(fontSize: 11, color: AppColors.textHint,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Divider(thickness: 0.5)),
      ]),
    );
  }
}
```

**Building the mixed item list** in `EntriesTabView`:

```dart
List<Object> _buildGroupedItems(List<LedgerEntry> entries) {
  // entries arrive sorted by date DESC from backend
  final items = <Object>[];
  DateTime? lastDate;
  for (final entry in entries) {
    final entryDay = DateTime(entry.date.year, entry.date.month, entry.date.day);
    if (lastDate == null || entryDay != lastDate) {
      items.add(entryDay);  // sentinel — rendered as _DateDivider
      lastDate = entryDay;
    }
    items.add(entry);
  }
  return items;
}
```

Use `itemBuilder` with type checking:
```dart
itemBuilder: (_, i) {
  final item = items[i];
  if (item is DateTime) return _DateDivider(date: item);
  return LedgerEntryCard(entry: item as LedgerEntry, ...);
},
```

### 6.3 Monthly view widget for Deliveries tab

```dart
class _MonthHeader extends StatefulWidget {
  final DateTime month;
  final List<LedgerEntry> deliveries;
  final bool initiallyExpanded;
}

class _MonthHeaderState extends State<_MonthHeader> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.deliveries.fold(0.0, (s, e) => s + e.amount);
    return Column(children: [
      InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.primary.withValues(alpha: 0.06),
          child: Row(children: [
            Text(DateFormat('MMMM yyyy').format(widget.month),
                style: AppTypography.labelLarge),
            const SizedBox(width: 8),
            Text('${widget.deliveries.length} deliveries · ₹${total.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const Spacer(),
            Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textHint),
          ]),
        ),
      ),
      if (_expanded)
        ...widget.deliveries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: LedgerEntryCard(entry: e, ...),
        )),
    ]);
  }
}
```

### 6.4 Filter bottom sheet

Opened by the filter icon button in `EntriesTabView`. Uses `showModalBottomSheet` with `isScrollControlled: true`. Internally stateful — holds a draft `LedgerFilter` and dispatches `ApplyLedgerFilter` only on tap of "Apply Filter".

The active filter chip row above the list:
```dart
// Shows one chip per active filter dimension
Row(children: [
  if (filter.status != null)
    _ActiveFilterChip(label: 'Status: ${filter.status!.name}',
        onRemove: () => bloc.add(ApplyLedgerFilter(filter.copyWith(clearStatus: true)))),
  if (filter.type != null || filter.deliveriesOnly)
    _ActiveFilterChip(label: filter.deliveriesOnly ? 'Deliveries only' : 'Type: ${filter.type!.name}',
        onRemove: () => bloc.add(ApplyLedgerFilter(filter.copyWith(clearType: true)))),
  if (filter.dateFrom != null || filter.dateTo != null)
    _ActiveFilterChip(label: _dateRangeLabel(filter),
        onRemove: () => bloc.add(ApplyLedgerFilter(filter.copyWith(clearDates: true)))),
  if (filter.amountMin != null || filter.amountMax != null)
    _ActiveFilterChip(label: _amountRangeLabel(filter),
        onRemove: () => bloc.add(ApplyLedgerFilter(filter.copyWith(clearAmount: true)))),
])
```

### 6.5 Pagination — Load More

At the bottom of `LedgerList` (inside the `ListView`), add an item at index `entries.length` when `state.hasMore`:

```dart
// Inside _buildRefreshableList:
itemCount: items.length + (state.hasMore ? 1 : 0),
itemBuilder: (_, i) {
  if (i == items.length) {
    // Load more sentinel
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return TextButton.icon(
      onPressed: () => context.read<LedgerBloc>().add(LoadMoreLedger(widget.linkId)),
      icon: const Icon(Icons.expand_more),
      label: const Text('Load more'),
    );
  }
  final item = items[i];
  // ... date divider or entry card
}
```

### 6.6 Updated LedgerBloc handlers

```dart
// In LedgerBloc constructor, add:
on<LoadMoreLedger>(_onLoadMore);
on<ApplyLedgerFilter>(_onApplyFilter);
on<ClearLedgerFilter>(_onClearFilter);

Future<void> _onLoadMore(LoadMoreLedger event, Emitter<LedgerState> emit) async {
  final current = state;
  if (current is! LedgerLoaded) return;
  if (!current.hasMore || current.isLoadingMore) return;

  emit(current.copyWith(isLoadingMore: true));
  try {
    final nextPage = current.currentPage + 1;
    final result = await _repository.getEntries(
      event.linkId,
      page: nextPage,
      limit: 50,
      filter: current.filter,
    );
    final combined = [...current.allEntries, ...result.entries];
    emit(LedgerLoaded(
      allEntries: combined,
      entries: _applyClientFilter(combined, current.filter),
      balance: _calcBalance(combined),
      filter: current.filter,
      currentPage: nextPage,
      totalEntries: result.total,
      isLoadingMore: false,
    ));
  } catch (e) {
    AppLogger.e(_m, 'Load more failed', e);
    emit(current.copyWith(isLoadingMore: false));
  }
}

Future<void> _onApplyFilter(ApplyLedgerFilter event, Emitter<LedgerState> emit) async {
  final current = state;
  if (current is! LedgerLoaded) return;

  final filter = event.filter;

  // If no backend params needed (pure client-side), skip re-fetch
  final needsRefetch = filter.dateFrom != null || filter.dateTo != null ||
      filter.amountMin != null || filter.amountMax != null ||
      current.hasMore;

  if (!needsRefetch) {
    emit(LedgerLoaded(
      allEntries: current.allEntries,
      entries: _applyClientFilter(current.allEntries, filter),
      balance: current.balance,
      filter: filter,
      currentPage: current.currentPage,
      totalEntries: current.totalEntries,
    ));
    return;
  }

  emit(LedgerLoading());
  try {
    final result = await _repository.getEntries(
      current.linkId,  // Need linkId on state — see §7 note
      page: 1,
      limit: 50,
      filter: filter,
    );
    emit(LedgerLoaded(
      allEntries: result.entries,
      entries: _applyClientFilter(result.entries, filter),
      balance: _calcBalance(result.entries),
      filter: filter,
      currentPage: 1,
      totalEntries: result.total,
    ));
  } catch (e) {
    emit(const LedgerError('Failed to apply filter'));
  }
}

List<LedgerEntry> _applyClientFilter(List<LedgerEntry> all, LedgerFilter filter) {
  return all.where((e) {
    if (filter.status != null && e.status != filter.status) return false;
    if (filter.deliveriesOnly && !e.isDelivery) return false;
    if (!filter.deliveriesOnly && filter.type != null && e.type != filter.type) return false;
    // date/amount already filtered server-side when needsRefetch
    return true;
  }).toList();
}
```

**Note on linkId in state:** `LedgerLoaded` currently does not store `linkId`. Add it:
```dart
class LedgerLoaded extends LedgerState {
  final String linkId;   // ADD THIS
  // ... rest unchanged
}
```
This is needed for `ApplyLedgerFilter` to re-fetch without holding linkId elsewhere.

---

## 7. EDGE CASES AND NOTES

### 7.1 Filter + pagination interaction

When a filter is applied that requires a backend fetch, reset `currentPage = 1` and replace `allEntries`. "Load more" then fetches page 2 of the filtered result. This is correct — pagination is always scoped to the active filter params.

### 7.2 Date dividers with active filter

When a status or type filter is applied client-side, some entries are hidden. Date dividers should only appear when at least one entry follows them. Re-compute `_buildGroupedItems` from the already-filtered `entries` list (not `allEntries`).

### 7.3 Socket events during pagination

Socket `SocketLedgerEntryAdded` prepends to `allEntries`. Do not change `totalEntries` or `currentPage`. The new entry is visible immediately. When user later presses "Load more", the backend may return it again — deduplicate by id:
```dart
final combined = [...current.allEntries, ...result.entries]
    ..sortBy((e) => e.date, descending: true); // re-sort
// Deduplicate
final seen = <String>{};
final deduped = combined.where((e) => seen.add(e.id)).toList();
```

### 7.4 "Deliveries only" filter vs Deliveries tab

The Deliveries-only chip in the filter panel filters the **Entries** tab. The **Deliveries** tab always shows all delivery entries regardless of the Entries-tab filter state. These are independent filter states — each tab maintains its own display logic.

### 7.5 Orders tab data fetching

The Orders tab needs its own data source: `GET /orders/customer` (for customer role) or filter `GET /orders/vendor` by `linkId`. This is a separate BLoC or cubit (`OrdersForLinkCubit`) that loads lazily when the user first taps the Orders tab (use `TabController.addListener` to detect first activation).

### 7.6 Backdated entries (F010 interaction)

When `AddLedgerEntry` is dispatched with a past `date`, the optimistic prepend puts it at the top of `allEntries`. On the next `RefreshLedger` (or the socket event), it will be in the correctly sorted position. The date divider system will then show it under its actual date grouping. There is no client-side re-sort on optimistic add — this is acceptable; the entry moves to its correct position on refresh.

---

## 8. REPOSITORY INTERFACE CHANGE

```dart
abstract class LedgerRepository {
  Future<LedgerPageResult> getEntries(
    String linkId, {
    int page = 1,
    int limit = 50,
    LedgerFilter? filter,
  });
  // ... rest unchanged
}

class LedgerPageResult {
  final List<LedgerEntry> entries;
  final int total;
  const LedgerPageResult({required this.entries, required this.total});
}
```

`LedgerRepositoryImpl.getEntries` maps `LedgerFilter` to query params and passes `page`/`limit`.

---

## 9. LOCALIZATION KEYS NEEDED

```
tabEntries
tabDeliveries
tabOrders
tabPayments
filterByStatus
filterByType
filterByDateRange
filterByAmount
filterApply
filterReset
filterDateFrom
filterDateTo
filterAmountMin
filterAmountMax
filterDeliveriesOnly
loadMore
addToSchedule
monthlyViewToggle
```

---

## 10. TESTING STRATEGY

### Unit tests (LedgerBloc)
- `ApplyLedgerFilter` with pure client-side filter — no HTTP call, entries filtered correctly
- `ApplyLedgerFilter` with date filter — triggers re-fetch, emits loading then loaded
- `LoadMoreLedger` — appends entries, increments `currentPage`
- `LoadMoreLedger` when `!hasMore` — noop
- `SocketLedgerEntryAdded` during page 2 load — deduplication works
- `_buildGroupedItems` — correct date divider insertion including "Today" / "Yesterday" labels
- `LedgerFilter.activeCount` — counts correct dimensions
- `LedgerFilter.toQueryParams` — omits null values

### Integration / widget tests
- `EntriesTabView` with 3 entries across 2 different dates — 2 date dividers rendered
- Filter bottom sheet: tapping "Apply" dispatches `ApplyLedgerFilter`
- Active filter chip `×` dispatches filter with that dimension cleared
- "Load more" button visible when `hasMore`, dispatches `LoadMoreLedger`
- Monthly view in Deliveries tab: expand/collapse month header

### Backend tests
- `GET /links/:id/entries?from=2026-06-01T00:00:00Z&to=2026-06-30T23:59:59Z` — only June entries returned
- `GET /links/:id/entries?amount_min=100&amount_max=500` — range enforced
- `GET /links/:id/entries?page=2&limit=10` — correct offset, `total` unchanged
- Combined filters — `status=pending&from=...` — both constraints applied
- ORDER is `date DESC` not `created_at DESC`
