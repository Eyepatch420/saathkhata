# SaathKhata — Flutter Implementation Spec

> Exact file changes, new widgets, bloc/cubit additions, and routing for all 6 features.
> Everything here maps 1:1 to files in `lib/`.
> Read alongside PLAN.md (architecture) and FLOWS.md (screens).

---

## Existing Code Landmarks (quick reference)

| What | File |
|------|------|
| Ledger bottom bar (Udhaar Diya / Paisa Mila) | `shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart` |
| Single-entry add sheet | `_AddEntrySheet` inside `ledger_actions.dart` |
| Staff single-entry sheet | `staff_portal/presentation/widgets/record_entry_sheet.dart` |
| Customer list (vendor) | `vendor/presentation/screens/all_customers_screen.dart` |
| Staff home screen | `staff_portal/presentation/screens/staff_home_screen.dart` |
| Customer dashboard | `customer/presentation/screens/customer_dashboard.dart` |
| Vendor dashboard | `vendor/presentation/screens/vendor_dashboard.dart` |
| Shared ledger screen | `shared_ledger/presentation/screens/shared_ledger_screen.dart` |
| Ledger entry card | `shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart` |
| Route constants | `core/router/app_router.dart` |
| LedgerEntry model | `shared/models/ledger_entry.dart` |
| CustomerLinkItem model | `shared/models/link_model.dart` |
| MembershipTier model | `memberships/domain/models/membership_tier.dart` |
| BookingModel | `shared/models/booking_model.dart` |

---

## Feature 1 — Multi-Item Ledger Entry

### New file: `shared_ledger/presentation/widgets/multi_item_entry_sheet.dart`

This is a standalone widget that can be called from both the vendor ledger and the staff sheet.

```dart
// Public API
Future<void> showMultiItemEntrySheet(
  BuildContext context, {
  required String linkId,
  required String customerName,
  required EntryType type,          // credit = multi-item; payment = single amount
  LedgerBloc? bloc,                 // vendor path
  LedgerRepository? repo,           // staff path (direct repo call)
})
```

**Internal state of the sheet:**

```dart
class _ItemLine {
  final TextEditingController nameCtrl;
  final TextEditingController qtyCtrl;
  final TextEditingController priceCtrl;
  // computed: total = qty * price
}

List<_ItemLine> _items = [];   // starts with one empty row
String? _pendingAttachmentUrl;
bool _uploading = false;
```

**Build layout:**

```
Column:
  ├── Header (icon + title "Udhaar Diya" + customer name)
  ├── ListView of _ItemRow widgets (one per _items entry)
  │     Each _ItemRow: [name field] [qty] × [price] = [total] [×delete]
  ├── [+ Add Item] OutlinedButton
  ├── Divider
  ├── Total row (sum of all item totals)
  ├── Photo proof row (Camera + Gallery buttons)
  ├── [attachment preview if uploaded]
  └── [Save — ₹X to CustomerName] ElevatedButton
```

**Submit logic:**
```dart
// 1. Create parent entry
final parent = await _createEntry(
  amount: grandTotal,
  description: '${_items.length} items',
  isParent: true,
);
// 2. Create child entries sequentially
for (final item in _items) {
  await _createEntry(
    amount: item.total,
    description: item.name,
    quantity: item.qty,
    parentEntryId: parent.id,
  );
}
```

### Changes to `ledger_actions.dart`

```dart
// In _showAddEntrySheet(), change credit path:
void _showAddEntrySheet(BuildContext context, AppLocalizations l10n, EntryType type) {
  if (type == EntryType.credit) {
    showMultiItemEntrySheet(context,
      linkId: linkId,
      customerName: customerName,
      type: EntryType.credit,
      bloc: context.read<LedgerBloc>(),
    );
  } else {
    // payment stays as _AddEntrySheet (single amount)
    showModalBottomSheet(..._AddEntrySheet...);
  }
}
```

### Changes to `shared/models/ledger_entry.dart`

Add fields:
```dart
final String? parentEntryId;
final bool isParent;
final int childCount;
final List<LedgerEntry> children;  // populated by repo when isParent=true
```

Update `fromJson` and `Equatable.props`.

### Changes to `shared_ledger/domain/repositories/ledger_repository.dart`

```dart
// Add batch method
Future<List<LedgerEntry>> addEntries(List<LedgerEntry> entries);
```

### Changes to `entry_card.dart`

```dart
// Add expand/collapse for parent entries
class EntryCard extends StatefulWidget { ... }

class _EntryCardState extends State<EntryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    if (!entry.isParent) return _buildSimpleRow(entry);

    return Column(children: [
      _buildParentRow(entry, expanded: _expanded, onTap: () {
        setState(() => _expanded = !_expanded);
      }),
      if (_expanded)
        ...entry.children.map((child) => _buildChildRow(child)),
    ]);
  }
}
```

### Changes to `staff_portal/presentation/widgets/record_entry_sheet.dart`

Replace the single-item delivery section (item name + qty + price fields) with a call to `MultiItemEntrySheet` or inline the same `_ItemLine` list pattern. Payment mode (single amount + note) stays unchanged.

---

## Feature 2 — Per-Customer Default Quantity

### Changes to `shared/models/link_model.dart`

Add to `CustomerLinkItem`:
```dart
final String? defaultProduct;
final String? defaultUnit;
final double? defaultQty;
final double? defaultPricePerUnit;
```

Update `fromJson`:
```dart
defaultProduct: json['defaultProduct'] as String?,
defaultUnit: json['defaultUnit'] as String?,
defaultQty: (json['defaultQty'] as num?)?.toDouble(),
defaultPricePerUnit: (json['defaultPricePerUnit'] as num?)?.toDouble(),
```

### New file: `features/vendor/presentation/widgets/customer_defaults_sheet.dart`

```dart
Future<void> showCustomerDefaultsSheet(
  BuildContext context, {
  required CustomerLinkItem customer,
  required VoidCallback onSaved,
})
```

Contains fields: product name, unit, qty stepper (−/+), price per unit. Daily total shown auto-computed. On save: `PATCH /links/:linkId/defaults`.

### Changes to `vendor/presentation/screens/all_customers_screen.dart`

Add ⋮ `PopupMenuButton` or `showModalBottomSheet` action sheet on each customer row:
- View Ledger (existing)
- Set Default Delivery → `showCustomerDefaultsSheet()`
- Edit Nickname (if exists)

### New file: `staff_portal/presentation/screens/staff_quick_delivery_screen.dart`

```dart
class StaffQuickDeliveryScreen extends StatelessWidget {
  // Loaded from StaffPortalCubit (already has customers list with defaults)
}
```

**State:** Uses a local `Map<String, double> _quantities` initialized from `customer.defaultQty ?? 0` for each customer. A `Set<String> _done` tracks ticked customers.

**Layout:**
```
Scaffold
  ├── AppBar: "Quick Delivery · [date]" + progress indicator
  ├── Body: ListView of _QuickDeliveryRow
  │     Each row: avatar + name + product name + stepper + amount + [Mark ✓]
  └── BottomBar: summary + [Finish & Save Remaining (N)]
```

Individual [Mark ✓]: fires `addEntries([single entry])` immediately, moves row to green done state.

[Finish & Save Remaining]: fires `addEntries([all pending rows with qty>0])` as a batch.

### Changes to `staff_portal/presentation/screens/staff_home_screen.dart`

Add a third action button: `⚡ Quick Delivery` that navigates to `AppRouter.staffQuickDelivery`.

### Changes to `core/router/app_router.dart`

```dart
static const String staffQuickDelivery = '/staff-home/quick-delivery';
// Add GoRoute for it pointing to StaffQuickDeliveryScreen
```

---

## Feature 3 — Customer Detail Screen (Vendor View)

### New file: `features/vendor/presentation/screens/customer_detail_screen.dart`

```dart
class CustomerDetailScreen extends StatefulWidget {
  final CustomerLinkItem customer;
  final bool isStaffView;
}
```

Uses a `DefaultTabController(length: 4)`.

AppBar:
```dart
AppBar(
  title: Row(children: [
    CircleAvatar(child: Text(customer.displayName[0])),
    SizedBox(width: 10),
    Column(children: [
      Text(customer.displayName),
      Text(customer.customer.mobile ?? ''),
    ]),
  ]),
  actions: [
    if (customer.tierLevel != null)
      _MembershipChip(level: customer.tierLevel!, name: customer.tierName!),
    IconButton(icon: Icon(Icons.phone_rounded), ...),
    IconButton(icon: Icon(Icons.message_rounded), ...),
  ],
  bottom: TabBar(tabs: [
    Tab(text: 'History'),
    Tab(text: 'Dues'),
    Tab(text: 'Delivery'),   // only shown for delivery-category vendors
    Tab(text: 'Info'),
  ]),
)
```

**Tab 0 — History:**
Reuse `LedgerList` widget from the existing shared ledger screen. Pass the same `LedgerBloc`.

**Tab 1 — Dues:**
New `DuesTab` widget (see below).

**Tab 2 — Delivery:**
New `DeliveryCalendarTab` widget (see below). Conditionally shown based on vendor category.

**Tab 3 — Info:**
Simple read-only display of customer info + `EditDefaultsButton`.

### New file: `features/vendor/presentation/screens/customer_detail_screen/widgets/dues_tab.dart`

Reads from `LedgerBloc` state. Groups entries by month. Shows summary:
- Opening balance = balance from previous month
- Credits = sum of credit entries this month
- Payments = sum of payment entries this month
- Closing = opening + credits - payments

Month picker: horizontal `ListView` of month chips.
"View Monthly Statement →" button pushes `MonthlySettlementScreen`.

### New file: `features/vendor/presentation/screens/customer_detail_screen/widgets/delivery_calendar_tab.dart`

A simple month grid (7 columns × ~5 rows). Each cell = a day number.

Color coding from `LedgerBloc` entries:
- Green: has a credit entry on that day
- Red: no entry but it was a working day (requires "working days" config — defer to vendor profile)
- Grey: Sunday or holiday

### Changes to `vendor/presentation/screens/all_customers_screen.dart`

Change tap handler from `context.push(AppRouter.sharedLedger, extra: {...})` to `context.push(AppRouter.customerDetail, extra: customer)`.

### New compact widget: `_MembershipChip`

```dart
// In customer_detail_screen.dart or memberships/presentation/widgets/
class MembershipChip extends StatelessWidget {
  final int level;
  final String name;
  final VoidCallback onTap;
  // Renders: [Gold ●] chip in amber/silver/bronze color
}
```

Tap opens a `showModalBottomSheet` with the full `MembershipBanner` content.

### Changes to `core/router/app_router.dart`

```dart
static const String customerDetail = '/vendor/customer-detail';

GoRoute(
  path: customerDetail,
  builder: (context, state) {
    final customer = state.extra as CustomerLinkItem;
    return CustomerDetailScreen(customer: customer);
  },
),
```

---

## Feature 4 — Vendor Membership Plans

### New model files

**`features/memberships/domain/models/membership_plan.dart`**
```dart
class MembershipPlan {
  final String id;
  final String vendorId;
  final String name;
  final double pricePerMonth;
  final int durationDays;
  final List<String> benefits;
  final int? sessionsTotal;     // null = unlimited
  final double? advanceRequired;
  final bool isActive;
  final int enrolledCount;
  // fromJson, toJson
}
```

**`features/memberships/domain/models/customer_membership.dart`**
```dart
class CustomerMembership {
  final String id;
  final String linkId;
  final String planId;
  final String planName;
  final String vendorName;         // only on customer-side response
  final DateTime enrolledAt;
  final DateTime expiresAt;
  final int? sessionsTotal;
  final int sessionsUsed;
  final String status;             // active | paused | expired | cancelled
  // fromJson
}
```

### New screens

**`features/memberships/presentation/screens/membership_plans_screen.dart`**
- Lists vendor's plans (created/inactive)
- FAB → create plan sheet
- "View All Members" button → `CustomerMembershipsScreen`
- Long-press a plan → edit sheet

**`features/memberships/presentation/screens/browse_plans_screen.dart`**
- Customer-facing, receives `vendorId` + `linkId`
- Shows active plans with benefits
- [Enroll → Pay via UPI] → existing UPI flow → on success calls `POST /membership/enroll`

**`features/memberships/presentation/screens/customer_memberships_screen.dart`**
- Vendor sees all enrolled customers
- Filter chips: All / by plan name
- Each row: name + plan + expiry + sessions + [Adjust] [Pause] [Cancel]

### New cubit: `membership_plans_cubit.dart`

Separate from existing `MembershipCubit` (which handles the per-link tier banner).
Handles plan CRUD and customer enrollment list for the vendor.

### Changes to `membership_repository.dart`

Add methods:
```dart
Future<List<MembershipPlan>> getVendorPlans();
Future<MembershipPlan> createPlan(MembershipPlan plan);
Future<MembershipPlan> updatePlan(String id, Map<String, dynamic> fields);
Future<void> deletePlan(String id);
Future<List<CustomerMembership>> getCustomerMemberships();
Future<void> updateCustomerMembership(String id, Map<String, dynamic> fields);
Future<List<MembershipPlan>> getPublicPlans(String vendorId);
Future<CustomerMembership> enrollInPlan({required String linkId, required String planId});
Future<List<CustomerMembership>> getMyMemberships();
```

### Changes to `core/router/app_router.dart`

```dart
static const String membershipPlans   = '/membership-plans';
static const String memberList        = '/membership-plans/members';
static const String browsePlans       = '/browse-plans';
```

### Changes to `shared_ledger/presentation/screens/shared_ledger_screen.dart`

When customer views and vendor has plans but customer has no active membership:
Show a slim banner above the ledger list:
```
💎 [VendorName] has membership plans → [Browse Plans]
```

### Changes to `customer/presentation/screens/customer_dashboard.dart`

`VendorTile` widget: if `VendorLinkItem` eventually carries membership info, show a small tier badge on the tile. (Defer to v2 if API change is needed.)

---

## Feature 5 — Monthly Settlement Screen

### New file: `features/shared_ledger/presentation/screens/monthly_settlement_screen.dart`

```dart
class MonthlySettlementScreen extends StatefulWidget {
  final String linkId;
  final String counterpartyName;
  final bool isVendorView;
  // Receives already-loaded entries from the LedgerBloc,
  // or reloads them if navigated to directly.
}
```

**Internal state:**
```dart
DateTime _selectedMonth = DateTime.now();  // first day of current month
```

**Build:**
```
Scaffold
  ├── AppBar: "Monthly Statement" + [Share PDF] icon + counterpartyName subtitle
  ├── Body:
  │   ├── Month picker (horizontal ListView of month chips, last 6 months)
  │   ├── Summary card (opening / credits / payments / closing)
  │   ├── Section: Credits this month (entries.where(type==credit, month match))
  │   │   Each: date | description (expandable if parent) | amount
  │   ├── Section: Payments this month (entries.where(type==payment, month match))
  │   └── Buttons: [Download PDF] [Share WhatsApp]
  └── (no bottom action bar — this is read-only)
```

**Data:** Reuses entries already in `LedgerBloc` state (already paginated). Month filter is local.

**PDF:** Calls existing `LedgerStatementService.generateAndShare()` with filtered entries.

### Changes to `shared_ledger/presentation/screens/shared_ledger_screen.dart`

Replace or supplement the existing "Download Statement" `IconButton` in the AppBar:

```dart
// Before: opens PDF directly
// After: pushes MonthlySettlementScreen
IconButton(
  icon: Icon(Icons.bar_chart_rounded),
  onPressed: () => context.push(AppRouter.monthlySettlement, extra: {...}),
),
```

Staff view: the icon is hidden when `isStaffView == true`.

### Changes to `core/router/app_router.dart`

```dart
static const String monthlySettlement = '/ledger/settlement';

GoRoute(
  path: monthlySettlement,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return MonthlySettlementScreen(
      linkId: extra['linkId'] as String,
      counterpartyName: extra['name'] as String,
      isVendorView: extra['isVendorView'] as bool,
    );
  },
),
```

---

## Feature 6 — Orders / Shopping List

### New feature folder: `features/orders/`

```
features/orders/
  domain/
    models/
      order_model.dart           ← Order + OrderItem
    repositories/
      order_repository.dart      ← abstract
  data/
    repositories/
      order_repository_impl.dart ← HTTP calls
  presentation/
    bloc/
      order_bloc.dart
      order_event.dart
      order_state.dart
    screens/
      order_method_screen.dart   ← customer: type/photo choice
      type_order_screen.dart     ← customer: item list entry
      order_sent_screen.dart     ← customer: confirmation
      order_inbox_screen.dart    ← vendor: incoming orders
    widgets/
      order_item_row.dart        ← shared: one item in a list
      order_status_chip.dart     ← shared: pending/confirmed/delivered chip
```

### `order_model.dart`

```dart
enum OrderStatus { pending, confirmed, rejected, delivered, cancelled }

class Order {
  final String id;
  final String linkId;
  final OrderStatus status;
  final List<OrderItem> items;
  final String? note;
  final String? customerName;   // populated on vendor response
  final DateTime createdAt;
  final DateTime? deliveredAt;
}

class OrderItem {
  final String name;
  final String? qty;
  final String? note;
}
```

### `type_order_screen.dart`

```dart
class _DraftItem {
  TextEditingController nameCtrl;
  TextEditingController qtyCtrl;
  TextEditingController noteCtrl;
}
List<_DraftItem> _items;
TextEditingController _deliveryNoteCtrl;
```

UI: same pattern as `MultiItemEntrySheet` but simpler (no price field — this is a shopping list, not a bill). Items don't have prices. AppBar shows "Send ✓" action button.

### `order_inbox_screen.dart`

```dart
class OrderInboxScreen extends StatelessWidget {
  // Uses OrderBloc state
  // Tab: Pending | Confirmed | All
}
```

Each order card:
- Customer name + time
- Item count + item names preview
- Action buttons: [✅ Confirm] [❌ Reject] for pending
- [Mark Delivered] for confirmed

### Changes to `vendor/presentation/screens/vendor_dashboard.dart`

In the quick-actions row (after the existing action buttons), add conditionally:

```dart
if (pendingOrderCount > 0)
  _QuickActionBadge(
    icon: Icons.shopping_bag_outlined,
    label: 'Orders',
    badge: pendingOrderCount.toString(),
    color: AppColors.warning,
    onTap: () => context.push(AppRouter.orderInbox),
  ),
```

Also add a "New Client Orders" section in the body — conditionally shown for grocery/shop category vendors:

```dart
if (_isShopCategory(user.businessCategory))
  _RecentOrdersSection(orders: state.recentPendingOrders),
```

### Changes to `customer/presentation/screens/customer_dashboard.dart`

On `VendorTile`, add a secondary action:

```dart
// Inside VendorTile actions row:
OutlinedButton.icon(
  icon: Icon(Icons.list_alt_rounded),
  label: Text('Order'),
  onPressed: () => context.push(AppRouter.orderMethod,
    extra: { 'linkId': vendor.linkId, 'vendorName': vendor.displayName }),
),
```

### Changes to `staff_portal/presentation/screens/staff_quick_delivery_screen.dart`

Add a bottom `TabBar` with two tabs: [Deliveries] and [Orders]. The Orders tab shows `_StaffOrdersList` widget — reads from `OrderRepository.getStaffOrders()`.

### Changes to `core/router/app_router.dart`

```dart
static const String orderMethod  = '/order-method';
static const String typeOrder    = '/order/type';
static const String orderSent    = '/order/sent';
static const String orderInbox   = '/vendor/orders';
```

### DI registration (injection.dart)

Register `OrderRepository` and `OrderBloc` in `getIt`.

---

## Feature 7 — Services + Job Tracker

### New model: `features/booking/domain/models/vendor_service.dart`

```dart
class VendorService extends Equatable {
  final String id;
  final String vendorId;
  final String name;
  final String? emoji;
  final int durationMin;
  final double price;
  final bool isActive;
  final int sortOrder;
  // fromJson, toJson
}
```

### Changes to `shared/models/booking_model.dart`

```dart
// Add to BookingModel:
final String? serviceId;
final String? serviceName;
final String? jobStage;  // null | 'intake' | 'cutting' | 'stitching' | 'ready' | 'in_progress' | 'testing' | 'delivered'
```

### New screen: `features/booking/presentation/screens/service_catalog_screen.dart`

```dart
class ServiceCatalogScreen extends StatelessWidget {
  // Loads services from BookingRepository
  // Lists them as cards with emoji + name + duration + price + [Edit]
  // FAB → Add Service sheet
}
```

Add/Edit sheet: name field + emoji picker (simple TextInput) + duration (int field) + price.

### Changes to `vendor_bookings_screen.dart`

Add a [Jobs] tab — only rendered when `user.businessCategory` is tailor/carpenter/repair type:

```dart
bool get _showJobsTab {
  final cat = user.businessCategory?.toLowerCase() ?? '';
  return ['tailor','darzi','carpenter','repair','electrician','plumber']
      .any((c) => cat.contains(c));
}
```

Each job card in the Jobs tab:
```
┌────────────────────────────────┐
│ [Customer Name]    [Stage chip]│
│ [item description] Due: date   │
│ [●●○○] progress bar            │
│ [Notify Client] [Next Stage →] │
└────────────────────────────────┘
```

"Next Stage →" calls `PATCH /bookings/:id/status` with the next `jobStage` value.

### Changes to `book_appointment_screen.dart`

Add a service selection step before the date/slot picker:

```dart
// Step 0: Service picker (loaded from GET /services/public/:vendorId)
// Once a service is selected, the slot duration filter uses service.durationMin
// Step 1: Date picker (existing)
// Step 2: Slot picker (existing, filtered by durationMin)
```

### Changes to `customer/presentation/screens/customer_bookings_screen.dart`

Existing bookings list — add a job status card variant when `booking.jobStage != null`.

### Changes to `core/router/app_router.dart`

```dart
static const String serviceCatalog = '/services';

GoRoute(
  path: serviceCatalog,
  builder: (context, state) => const ServiceCatalogScreen(),
),
```

### Changes to `booking_repository.dart`

```dart
// Add:
Future<List<VendorService>> getServices();
Future<List<VendorService>> getPublicServices(String vendorId);
Future<VendorService> createService(VendorService service);
Future<VendorService> updateService(String id, Map<String, dynamic> fields);
Future<void> deleteService(String id);
Future<BookingModel> updateJobStage(String bookingId, String stage);
```

---

## l10n Keys Needed (approximate, English values)

```arb
"multiItemEntryTitle": "Add Items",
"addItem": "Add Item",
"itemName": "Item Name",
"unitPrice": "Unit Price",
"saveEntry": "Save Entry",
"grandTotal": "Total",

"defaultDelivery": "Default Delivery",
"defaultProduct": "Default Product",
"defaultQty": "Default Qty / Day",
"quickDelivery": "Quick Delivery",
"allCustomersRoute": "All at once",
"markDone": "Mark Done",
"finishAndSave": "Finish & Save Remaining ({n})",

"customerDetail": "Customer Detail",
"historyTab": "History",
"duesTab": "Dues",
"deliveryTab": "Delivery",
"infoTab": "Info",
"viewMonthlyStatement": "View Monthly Statement",
"openingBalance": "Opening Balance",
"closingBalance": "Closing Balance",

"membershipPlans": "Membership Plans",
"createPlan": "Create Plan",
"publishPlan": "Publish Plan",
"browsePlans": "Browse Plans",
"enroll": "Enroll",
"sessionsUsed": "{used}/{total} sessions",
"membershipExpiring": "Expiring in {days} days",

"monthlyStatement": "Monthly Statement",
"creditsThisMonth": "Credits This Month",
"paymentsThisMonth": "Payments This Month",
"shareWhatsApp": "Share via WhatsApp",
"downloadPdf": "Download PDF",

"sendOrder": "Send Order",
"typeYourList": "Type Your List",
"orderSent": "Order Sent!",
"orderConfirmed": "Order confirmed",
"markDelivered": "Mark Delivered",
"clientOrders": "Client Orders",
"newOrders": "{n} New Orders",

"myServices": "My Services",
"addService": "Add Service",
"serviceName": "Service Name",
"durationMin": "Duration (minutes)",
"jobTracker": "Job Tracker",
"nextStage": "Next Stage →",
"notifyClient": "Notify Client",
"markDeliveredJob": "Mark Delivered"
```

---

## DI Additions (injection.dart)

```dart
// Feature 1 — no new registration (reuses LedgerRepository)

// Feature 2
getIt.registerLazySingleton<CustomerDefaultsRepository>(
  () => CustomerDefaultsRepositoryImpl(getIt<ApiClient>()),
);

// Feature 4
getIt.registerLazySingleton<MembershipPlansRepository>(
  () => MembershipRepositoryImpl(getIt<ApiClient>()),  // extends existing impl
);
getIt.registerFactory<MembershipPlansCubit>(
  () => MembershipPlansCubit(getIt<MembershipPlansRepository>()),
);

// Feature 6
getIt.registerLazySingleton<OrderRepository>(
  () => OrderRepositoryImpl(getIt<ApiClient>()),
);
getIt.registerFactory<OrderBloc>(
  () => OrderBloc(getIt<OrderRepository>()),
);

// Feature 7
// BookingRepository already registered — add new methods to existing impl
```

---

## Build Order for Development

```
Sprint 1:
  ✦ Feature 1 (Multi-item entry) — shared_ledger + staff portal widgets
  ✦ Feature 2 (Default qty) — model + vendor UI + staff quick delivery screen

Sprint 2:
  ✦ Feature 3 (Customer detail tabs) — new screen, depends on Feature 2
  ✦ Feature 5 (Monthly settlement) — new screen, depends on existing ledger

Sprint 3:
  ✦ Feature 6 (Orders) — entirely new feature, new backend + new frontend folder

Sprint 4:
  ✦ Feature 7a (Service catalog) — extends booking
  ✦ Feature 7b (Job tracker) — extends Feature 7a

Sprint 5:
  ✦ Feature 4 (Membership plans) — largest scope, new models + screens both sides
```
