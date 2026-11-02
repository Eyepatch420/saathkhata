# SaathKhata — Feature Implementation Plan

> **Status:** Planning  
> **Date:** 2026-06-28  
> **Scope:** 6 feature areas across Vendor, Customer, and Staff roles  
> **Rule:** Document everything, implement nothing yet. Each section ends with exact file changes needed.

---

## Table of Contents

1. [Multi-Item Ledger Entry (collapsed + expandable)](#1-multi-item-ledger-entry)
2. [Per-Customer Default Quantity (backend + frontend)](#2-per-customer-default-quantity)
3. [Customer Detail Screen — Tabs + Membership in AppBar](#3-customer-detail-screen)
4. [Vendor Membership Plan Management (vendor creates, customer enrolls)](#4-vendor-membership-plans)
5. [Monthly Settlement Screen (vendor + customer, not staff)](#5-monthly-settlement-screen)
6. [Order / Shopping List — 3-role flow (customer → vendor → staff)](#6-order--shopping-list-flow)
7. [Booking: Services per Category + Job Tracker](#7-booking-services--job-tracker)
8. [Client Orders on Vendor Dashboard — when to show](#8-client-orders-on-vendor-dashboard)

---

## Role & Permission Matrix

| Feature | Vendor | Customer | Staff |
|---------|--------|----------|-------|
| Create multi-item credit entry | ✅ | ❌ | ✅ |
| Record multi-item payment | ✅ | ✅ (own payment) | ✅ |
| View collapsed/expanded bill | ✅ | ✅ | ✅ |
| Set per-customer default qty | ✅ | ❌ | ❌ |
| Use default qty in quick delivery | ✅ | N/A | ✅ |
| View customer detail tabs | ✅ | N/A | ✅ (ledger only) |
| Create membership plan | ✅ | ❌ | ❌ |
| View/enroll membership | ❌ | ✅ | ❌ |
| Manage customer memberships | ✅ | ❌ | ❌ |
| View monthly settlement | ✅ | ✅ | ❌ |
| Place order | ❌ | ✅ | ❌ |
| Process/confirm order | ✅ | ❌ | ❌ |
| Deliver order | ✅ | ❌ | ✅ |
| Create service catalog | ✅ | ❌ | ❌ |
| Book appointment | ❌ | ✅ | ❌ |
| Track job stages | ✅ | ✅ (read-only) | ✅ |

---

## 1. Multi-Item Ledger Entry

### What exists
`LedgerActions` → `_AddEntrySheet` (in `ledger_actions.dart`): single-entry sheet.
One amount + one description + one qty → one `AddLedgerEntry` event → one `LedgerEntry` in DB.

Staff `record_entry_sheet.dart` credit mode: one item name + qty + unit price → one `addEntry()` call.

### What we're building
A **collapsed-then-expandable** bill entry. The user adds N item lines. On submit:
- **One parent `LedgerEntry`** is created with `type=credit`, `amount=total`, `description="N items"`.
- Each line item is stored as a JSON array in the description field **or** as separate child entries referencing the parent.

**Decision: Separate child entries with a `parentEntryId` field.**  
Reason: The existing `LedgerEntry` model has no `items` array. Adding a `parentEntryId` to the backend model lets us group them without changing the API contract — the parent is what the customer sees (collapsed), children are revealed when tapped.

### Data model addition (backend)
```
LedgerEntry:
  + parentEntryId: String?   // null = standalone; set = line item under a parent
  + isCollapsed: bool        // true for parent entries that have children
```

The backend `GET /ledger/:linkId` response sorts entries by date. Parent entries that have children will include a `childCount` field in the response so the UI knows whether to show the expand chevron.

### User flow — Vendor (Give Credit / "Udhaar Diya")

```
Ledger Screen
    │
    ▼
[Udhaar Diya button]  ← already exists in LedgerActions
    │
    ▼
MultiItemEntrySheet (NEW — replaces _AddEntrySheet for credit type)
    │
    ├── Item list (starts empty)
    │      ┌────────────────────────────────────┐
    │      │  Milk 2L  × ₹60  =  ₹120    [× ]  │
    │      │  Paneer   × ₹40  =  ₹40     [× ]  │
    │      │  [+ Add Item]                      │
    │      └────────────────────────────────────┘
    │
    ├── Total footer: ₹160
    │
    └── [Save Entry] → fires AddLedgerEntry(parentEntry) then
                        AddLedgerEntry(child1), AddLedgerEntry(child2) sequentially
```

### User flow — Vendor (Paisa Mila / Record Payment)
Payment stays **single-entry** — you collect one lump sum. No multi-item needed.

### User flow — Staff (Record Delivery sheet)
The `_RecordEntrySheet` credit mode currently has one item row.
Replace with the same multi-item list widget used above.
Payment mode stays single-entry.

### User flow — Customer (View in ledger)
Customer ledger (`SharedLedgerScreen`) shows entries from the same API.
A parent entry (with children) renders as a **collapsed card**:

```
┌──────────────────────────────────────────────────────┐
│  ● Jun 15 · 3 items                     +₹160   ⌄   │
└──────────────────────────────────────────────────────┘
  ← tap ⌄ to expand →
┌──────────────────────────────────────────────────────┐
│  ● Jun 15 · 3 items                     +₹160   ⌃   │
│    ├ Milk 2L                            +₹120        │
│    ├ Paneer                             +₹40         │
│    └ Bread                              +₹30  (sub)  │
│                              Total:     +₹190        │
└──────────────────────────────────────────────────────┘
```

The expand/collapse is **local UI state only** — no extra API call needed because children are already loaded with the parent list.

### Files to change / create

| File | Change |
|------|--------|
| `shared/models/ledger_entry.dart` | Add `parentEntryId`, `childCount`, `children` fields |
| `shared_ledger/domain/repositories/ledger_repository.dart` | `addEntry` signature stays; add `addEntries(List<LedgerEntry>)` batch method |
| `shared_ledger/data/repositories/ledger_repository_impl.dart` | Implement `addEntries` |
| `shared_ledger/presentation/bloc/ledger_event.dart` | Add `AddLedgerEntries` event |
| `shared_ledger/presentation/bloc/ledger_bloc.dart` | Handle `AddLedgerEntries` |
| `shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart` | Route credit to `MultiItemEntrySheet` instead of `_AddEntrySheet` |
| `shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart` | Add expand/collapse for parent entries |
| **NEW** `shared_ledger/presentation/widgets/multi_item_entry_sheet.dart` | The new sheet widget, shared by vendor + staff |
| `staff_portal/presentation/widgets/record_entry_sheet.dart` | Replace single-item delivery section with `MultiItemEntrySheet` widget |

---

## 2. Per-Customer Default Quantity

### What exists
`CustomerLinkItem` has: `linkId`, `balance`, `nickname`, `customer`, `tierLevel`, `tierName`.
No `defaultProduct` or `defaultQty` field.

### What we're building
When a vendor adds or edits a customer, they can set a **default product** (name + unit) and **default quantity**. This pre-fills the Staff Quick Delivery screen and the bulk-charge stepper.

### Backend addition
```
Link table:
  + defaultProduct: String?    // e.g. "Full Cream Milk"
  + defaultUnit: String?       // e.g. "L"
  + defaultQty: double?        // e.g. 2.0
  + defaultPricePerUnit: double? // e.g. 60.0
```

New API endpoints:
- `PATCH /api/v1/links/:linkId/defaults` — vendor sets defaults for a customer
- Response: updated `CustomerLinkItem`

### Frontend model change
`CustomerLinkItem` gets 4 new nullable fields:
```dart
final String? defaultProduct;
final String? defaultUnit;
final double? defaultQty;
final double? defaultPricePerUnit;
```

### User flow — Vendor sets defaults

```
All Customers screen
    │
    ▼ long-press OR ⋮ menu on a customer row
    │
[Edit Customer Defaults sheet]
    ┌─────────────────────────────────────┐
    │  Default Product: [Full Cream Milk] │
    │  Unit:            [L]               │
    │  Qty per day:     [2]               │
    │  Price per unit:  [₹60]             │
    │  [Save Defaults]                    │
    └─────────────────────────────────────┘
```

Also shown during Add Customer flow (already has a "Default Daily Delivery" section in the mockup — currently not wired to any backend field).

### User flow — Staff Quick Delivery screen (NEW SCREEN)

This is a **new dedicated screen** in the staff portal that replaces the current "Record Delivery" button → bottom sheet pattern for batch work.

```
Staff Home
    │
    ▼ [⚡ Quick Delivery] button  (new, alongside existing Record Delivery)
    │
StaffQuickDeliveryScreen (NEW)
    │
    ├── All customers loaded from cubit
    │   Each row shows:
    │     [Customer Name]   [default product]   [− 2L +]   = ₹120
    │
    ├── Customers with no default: show qty=0, stepper still works
    │
    └── [Deliver All (N customers)] → fires addEntries() batch
         → each line = one credit LedgerEntry for that customer's linkId
```

The individual "Record Delivery" button (single customer + single item OR multi-item via the new sheet) still exists for non-batch use.

### Files to change / create

| File | Change |
|------|--------|
| `shared/models/link_model.dart` | Add 4 default fields to `CustomerLinkItem` |
| `features/customer/domain/repositories/customer_repository.dart` | Add `updateLinkDefaults()` |
| `features/customer/data/repositories/customer_repository_impl.dart` | Implement it |
| `features/vendor/presentation/screens/all_customers_screen.dart` | Add ⋮ menu → defaults sheet |
| **NEW** `features/vendor/presentation/widgets/customer_defaults_sheet.dart` | Edit defaults sheet |
| `staff_portal/presentation/cubit/staff_portal_cubit.dart` | Expose customers with defaults |
| **NEW** `staff_portal/presentation/screens/staff_quick_delivery_screen.dart` | Batch delivery screen |
| `staff_portal/presentation/screens/staff_home_screen.dart` | Add Quick Delivery button |
| `core/router/app_router.dart` | Add `/staff-home/quick-delivery` route |

---

## 3. Customer Detail Screen

### What exists (vendor side)
When a vendor taps a customer in `all_customers_screen.dart`, it pushes to `SharedLedgerScreen`. That screen shows a balance header + flat list of ledger entries + membership banner inline.

There is **no tabbed customer detail screen** in the current code — the mockup's "Customer Detail" with History / Dues / Delivery / Info tabs does not exist yet.

### What we're building

**3a. Customer Detail Screen (vendor view) — new tabbed screen**

```
┌──────────────────────────────────────────────────────┐
│  ← S  Sharma Ji          📞 💬   [Gold ●]  (appbar) │
│     +91 98765 · Sector 12                            │
├────────────────────────────────────────────────────────
│  ₹340      2L     18d     Jun 1                      │
│  Owed    Daily   OD      Since                       │
├────────────────────────────────────────────────────────
│  [+Delivery] [+Bill] [+Payment] [Chaser]             │
├────────────────────────────────────────────────────────
│  [History] [Dues] [Delivery] [Info]  ← TabBar        │
├────────────────────────────────────────────────────────
│  (tab content)                                       │
└──────────────────────────────────────────────────────┘
```

**Membership badge in AppBar:** The existing `MembershipBanner` widget is a full-width card shown below the balance header. Move it to a compact badge chip in the AppBar title row (like "Gold ●" in amber). Tapping it slides open the full membership sheet. This frees up vertical space for the tab content.

**Tab: History** — the existing ledger list (what `SharedLedgerScreen` already shows), now inside a tab.

**Tab: Dues** — running balance breakdown: opening balance, total credited this month, total paid this month, closing balance. Mirrors the "Monthly Statement" but scoped to this customer only.

**Tab: Delivery** — if vendor category is delivery type (milk/tiffin/newspaper), shows a calendar view of this month's deliveries. Each day cell is green (delivered), red (missed), grey (holiday/skip). Tap a day = day's entries.

**Tab: Info** — customer's phone, address, since date, credit limit, default delivery config (from Feature 2). Edit button opens customer defaults sheet.

**3b. Customer's own ledger (customer view)**
The customer's `SharedLedgerScreen` already shows their ledger per vendor.
Add the same tab structure but scoped to what a customer sees:
- **History tab** — existing ledger list
- **Statement tab** — monthly summary (links to Feature 5)
- **Orders tab** — orders placed with this vendor (links to Feature 6)
- **Info tab** — vendor's contact, business name, category

Membership badge stays in AppBar on customer side too (already compact tier badge via `MembershipTierBadge` widget).

### Files to change / create

| File | Change |
|------|--------|
| **NEW** `features/vendor/presentation/screens/customer_detail_screen.dart` | New tabbed screen |
| **NEW** `features/vendor/presentation/screens/customer_detail_screen/widgets/delivery_calendar.dart` | Monthly delivery calendar |
| **NEW** `features/vendor/presentation/screens/customer_detail_screen/widgets/dues_tab.dart` | Balance breakdown |
| `features/vendor/presentation/screens/all_customers_screen.dart` | Navigate to `CustomerDetailScreen` instead of `SharedLedgerScreen` |
| `shared_ledger/presentation/screens/shared_ledger_screen.dart` | Accept optional `initialTab` param |
| `features/memberships/presentation/widgets/membership_banner.dart` | Extract compact `MembershipChip` variant for AppBar |
| `core/router/app_router.dart` | Add `/vendor/customer-detail` route |

---

## 4. Vendor Membership Plan Management

### What exists
`MembershipTier` model: 3 tiers (Bronze/Silver/Gold) **per vendor**, editable name + discount. Vendor manages via `MembershipTiersScreen`. Customer sees current tier in `MembershipBanner` on the ledger screen.

**Gap:** The current model is pure discount-tier (no "4 haircuts included", no price, no expiry). The mockup's membership plans have price/month, benefits list, advance required, and expiry. Customers enroll and pay.

### What we're building

**This is a significant model expansion.** Rather than replacing the existing tier system (which is already live), we extend it:

```
Current:  MembershipTier = discount tier assigned by vendor
New:      MembershipPlan = priced plan with benefits, that customers can enroll in
```

These are two separate concepts that co-exist:
- **Tier** (existing): discount level vendor assigns to customer (Bronze/Silver/Gold). Shown as badge.
- **Plan** (new): "Gold Membership ₹999/mo — 4 haircuts + 10% off + priority". Customer pays to enroll.

### New models (backend)

```
MembershipPlan:
  id, vendorId, name, pricePerMonth, durationDays
  benefits: String[]
  advanceRequired: double?
  isActive: bool

CustomerMembership:
  id, linkId, planId, planName, enrolledAt, expiresAt
  sessionsTotal: int?
  sessionsUsed: int
  status: active | paused | expired
```

### API endpoints (new)
```
GET    /api/v1/membership/plans             → vendor's plan list
POST   /api/v1/membership/plans             → create plan
PATCH  /api/v1/membership/plans/:id         → update plan
DELETE /api/v1/membership/plans/:id         → archive plan

GET    /api/v1/membership/customers         → vendor: all customer memberships
PATCH  /api/v1/membership/customers/:id     → vendor: adjust sessions, pause, cancel

GET    /api/v1/membership/my                → customer: my memberships
POST   /api/v1/membership/enroll            → customer: enroll in a plan (body: planId, linkId)
```

### Vendor flow

```
Vendor Dashboard → Settings or nav item → [Membership Plans]
    │
MembershipPlansScreen (NEW — not the same as MembershipTiersScreen)
    │
    ├── Plan list (create/edit/archive)
    │
    └── [Members] tab
            │
            All customers with active plans
            Each row: name + plan + expiry + sessions used/total
            Long-press → adjust sessions / pause / cancel
```

### Customer flow

```
Customer Dashboard → tap vendor → SharedLedgerScreen or CustomerDetailScreen
    │
[Browse Plans] button (visible when vendor has active plans)
    │
BrowsePlansScreen (NEW — customer side)
    │
Plans listed with benefits + price
    │
[Enroll → Pay via UPI]
    │
Enrollment confirmed → membership card visible in AppBar badge
```

### Files to change / create

| File | Change |
|------|--------|
| **NEW** `features/memberships/domain/models/membership_plan.dart` | Plan model |
| **NEW** `features/memberships/domain/models/customer_membership.dart` | Enrollment model |
| `features/memberships/domain/repositories/membership_repository.dart` | Add plan CRUD + enrollment methods |
| `features/memberships/data/repositories/membership_repository_impl.dart` | Implement |
| **NEW** `features/memberships/presentation/screens/membership_plans_screen.dart` | Vendor plan manager |
| **NEW** `features/memberships/presentation/screens/browse_plans_screen.dart` | Customer enrollment |
| **NEW** `features/memberships/presentation/screens/customer_memberships_screen.dart` | Vendor sees all enrollments |
| **NEW** `features/memberships/presentation/bloc/membership_plans_cubit.dart` | State for plan management |
| `core/router/app_router.dart` | Add `/membership-plans`, `/browse-plans`, `/member-list` routes |

---

## 5. Monthly Settlement Screen

### What exists
`LedgerStatementService.generateAndShare()` — generates a PDF and opens system share sheet. Called from a button inside `SharedLedgerScreen`. There is **no in-app settlement screen**.

### What we're building
An in-app **Monthly Settlement Screen** for both vendor and customer (not staff). It shows:

```
┌──────────────────────────────────────────────────────┐
│  ← Monthly Statement         [Share PDF]  [Jun 2026] │
├────────────────────────────────────────────────────────
│  ╔══════════════════════════════════════════════════╗ │
│  ║  RAMESH DAIRY          SaathKhata Certified      ║ │
│  ║  Sharma Ji                       Jun 2026        ║ │
│  ╚══════════════════════════════════════════════════╝ │
├────────────────────────────────────────────────────────
│  Opening Balance              ₹0                     │
│  Total Credited (30 entries)  +₹3,600                │
│  Total Paid (2 payments)      -₹3,260                │
│  ─────────────────────────────────────               │
│  Closing Balance              ₹340                   │
├────────────────────────────────────────────────────────
│  Month picker: [Apr] [May] [Jun ✓] [Jul]             │
├────────────────────────────────────────────────────────
│  DELIVERIES THIS MONTH                               │
│  Jun 1   2L Milk         ₹120   ✓                   │
│  Jun 2   2L Milk         ₹120   ✓                   │
│  ...                                                 │
├────────────────────────────────────────────────────────
│  PAYMENTS THIS MONTH                                 │
│  Jun 13  Cash payment    -₹500                      │
│  Jun 1   UPI payment     -₹2,760                    │
├────────────────────────────────────────────────────────
│  [Download PDF]    [Share via WhatsApp]              │
└──────────────────────────────────────────────────────┘
```

Data source: **filter existing ledger entries** by month — no new API needed. The entries are already loaded in `LedgerBloc`. Month picker changes the local filter.

### Entry point
- **Vendor:** From `CustomerDetailScreen` → Dues tab → "View Monthly Statement" button.
- **Customer:** From `SharedLedgerScreen` → existing "Download Statement" button changes to "View Statement" which pushes the new screen; PDF download is still available inside it.

Staff does **not** see this screen (no settlement button in staff portal).

### Files to change / create

| File | Change |
|------|--------|
| **NEW** `features/shared_ledger/presentation/screens/monthly_settlement_screen.dart` | In-app settlement UI |
| `shared_ledger/presentation/screens/shared_ledger_screen.dart` | Change PDF button to navigate to settlement screen |
| `features/vendor/presentation/screens/customer_detail_screen/widgets/dues_tab.dart` | Add "View Statement" button |
| `core/router/app_router.dart` | Add `/ledger/settlement` route |

---

## 6. Order / Shopping List Flow

### What exists
**Nothing** — the order flow (customer sends list to vendor, vendor processes, staff delivers) does not exist in the current codebase. There is no `orders` feature folder.

### What we're building

A 3-role flow:

```
CUSTOMER                    VENDOR                      STAFF
    │                          │                           │
[Place Order]                  │                           │
    │                          │                           │
Types list / photos list       │                           │
    │                          │                           │
    ├──────── POST /orders ────►│                           │
    │                          │                           │
    │                    [Order Inbox]                     │
    │                  Shows new order                     │
    │                          │                           │
    │               [Confirm / Reject]                     │
    │                          │                           │
    │◄── status: confirmed ────┤                           │
    │                          │                           │
    │                          ├──── assigned to staff ───►│
    │                          │                           │
    │                    [Staff sees                       │
    │                     order in                         │
    │                     quick delivery]                  │
    │                          │                           │
    │                          │              [Mark Delivered]
    │                          │                           │
    │◄────── notification: delivered ──────────────────────┤
    │                          │                           │
    │                 [Auto-creates                        │
    │                  LedgerEntry                         │
    │                  for order total]                    │
```

### New models (backend)

```
Order:
  id, linkId, vendorId, customerId
  status: pending | confirmed | rejected | delivered | cancelled
  items: OrderItem[]
  note: String?
  createdAt, updatedAt
  deliveredAt?, deliveredBy? (staff userId)

OrderItem:
  name, qty, unit?, note?
```

### API endpoints (new)

```
POST   /api/v1/orders                    → customer places order
GET    /api/v1/orders/vendor             → vendor sees all incoming orders
GET    /api/v1/orders/customer           → customer sees their orders
PATCH  /api/v1/orders/:id/status         → vendor: confirm/reject; staff: mark delivered
GET    /api/v1/orders/staff              → staff sees confirmed+assigned orders
```

### Customer flow

```
Customer Dashboard → tap vendor → CustomerLedgerScreen
    │
    ▼ [📋 Send Order] button in AppBar or action row
    │
OrderMethodScreen (NEW)
    ├── [Type your list]  → TypeOrderScreen → item rows → Send
    └── [Photo of list]   → Camera → (no AI for now, manual confirm) → Send

    → POST /orders → OrderSentScreen (confirmation + items summary)
```

### Vendor flow

```
Vendor Dashboard → [Orders 🔴N] badge button  (new quick action)
    │
OrderInboxScreen (NEW)
    │
Each order card shows: customer name + items + time + [Confirm] [Reject]
    │
[Confirm] → PATCH status=confirmed → order moves to "processing"
    │
[Mark Delivered] (vendor can also deliver without staff) → creates LedgerEntry automatically
```

**When to show Orders on vendor dashboard:**
Show the "Orders 🔴N" badge on the vendor dashboard **only** when:
1. There are pending (unconfirmed) orders, OR
2. There are confirmed orders not yet delivered

Do NOT show if all orders are delivered or rejected. This matches the mockup's "3 New Orders" stat card.

The "New Client Orders" section in the dashboard body (`dashGrocery` mockup) shows only for **grocery/kirana category** vendors by default (since delivery vendors do repeating fixed orders, not ad-hoc shopping lists). Vendors of other categories can also receive orders but the dashboard prominently surfaces them only for shop-type categories.

### Staff flow

```
Staff Quick Delivery Screen (from Feature 2)
    │
Tab: [Deliveries] | [Orders]  (new tab)
    │
Orders tab shows confirmed orders assigned/visible to this staff
Each order: customer name + items list + [Mark Delivered]
    │
[Mark Delivered] → PATCH /orders/:id/status=delivered
                 → backend auto-creates LedgerEntry for order total (if items have prices)
                 → OR creates a pending entry for vendor to price later
```

### Files to change / create

| File | Change |
|------|--------|
| **NEW** `features/orders/` | Entire new feature folder |
| **NEW** `features/orders/domain/models/order_model.dart` | Order + OrderItem models |
| **NEW** `features/orders/domain/repositories/order_repository.dart` | Abstract repo |
| **NEW** `features/orders/data/repositories/order_repository_impl.dart` | HTTP impl |
| **NEW** `features/orders/presentation/bloc/order_bloc.dart` | State management |
| **NEW** `features/orders/presentation/screens/order_method_screen.dart` | Customer: how to order |
| **NEW** `features/orders/presentation/screens/type_order_screen.dart` | Customer: type list |
| **NEW** `features/orders/presentation/screens/order_sent_screen.dart` | Customer: confirmation |
| **NEW** `features/orders/presentation/screens/order_inbox_screen.dart` | Vendor: incoming orders |
| `features/vendor/presentation/screens/vendor_dashboard.dart` | Add Orders badge + section |
| `features/customer/presentation/screens/customer_dashboard.dart` | Add Send Order entry point |
| `staff_portal/presentation/screens/staff_quick_delivery_screen.dart` | Add Orders tab |
| `core/network/api_endpoints.dart` | Add order endpoints |
| `core/router/app_router.dart` | Add order routes |

---

## 7. Booking: Services per Category + Job Tracker

### What exists
`BookingRepository` has: `getVendorBookings`, `getAvailableSlots`, `createBooking`, `updateBookingStatus`, `saveBookingConfig`, `getBookingConfig`, `toggleSlotFull`.

`BookingConfig` = a map of day-of-week → list of `DaySlot` (startTime, endTime, isEnabled, isFull). This is time-slot management only — **no service catalog**.

`VendorBookingsScreen` exists: shows bookings in tabs (Today/All), can confirm/reject/complete.

`VendorScheduleSetupScreen` exists: configure slots per day.

**Gap:** No service catalog (Haircut/Beard Trim/Hair Colour etc.). No job tracker for tailor/carpenter.

### What we're building

**7a. Service Catalog** (vendor creates, customer sees when booking)

```
VendorService:
  id, vendorId, name, durationMinutes, price, emoji?, isActive
```

Only applicable for vendors whose `businessCategory` falls in service types:
- salon, barber, parlour, tailor, darzi, plumber, electrician, physio, spa, etc.

API:
```
GET    /api/v1/services           → vendor's service list
POST   /api/v1/services           → create service
PATCH  /api/v1/services/:id       → edit service
DELETE /api/v1/services/:id       → deactivate
```

The `BookingModel` gains a `serviceId` and `serviceName` field so bookings reference a specific service.

**7b. Job Tracker** (for tailor, carpenter, repair vendors)

Job tracker uses existing `BookingModel` with status extensions:

```
BookingStatus: pending | confirmed | cancelled | completed
  + intake | cutting | stitching | ready (for job-type categories)
```

Or more cleanly: a separate `jobStage` enum that only applies when the vendor category is job-based.

Vendor sees job cards in a new **"Jobs"** tab on `VendorBookingsScreen`. Each card has a progress bar + "Next Stage →" button. Customer gets a notification on stage change.

### Files to change / create

| File | Change |
|------|--------|
| **NEW** `features/booking/domain/models/vendor_service.dart` | Service model |
| `features/booking/domain/repositories/booking_repository.dart` | Add service CRUD methods |
| `features/booking/data/repositories/booking_repository_impl.dart` | Implement |
| **NEW** `features/booking/presentation/screens/service_catalog_screen.dart` | Vendor: manage services |
| `features/booking/presentation/screens/vendor_bookings_screen.dart` | Add Jobs tab |
| `features/booking/presentation/screens/vendor_schedule_setup_screen.dart` | Link to service catalog |
| `features/booking/presentation/screens/book_appointment_screen.dart` | Service picker before slot |
| `shared/models/booking_model.dart` | Add `serviceId`, `serviceName`, `jobStage` |
| `core/router/app_router.dart` | Add `/services` route |

---

## 8. Client Orders on Vendor Dashboard — When to Show

This answers the question from the screenshots.

### Decision

The "New Client Orders" section appears on the **vendor dashboard** in two situations:

| Scenario | What shows | Where it comes from |
|----------|------------|---------------------|
| Customer sent a shopping list order | Card with customer name + item count + "View →" | Feature 6 orders API |
| Staff recorded a delivery and bill is pending vendor review | NOT shown here — this goes in the ledger as a `pending` entry, visible on the ledger screen | LedgerEntry status=pending |

**Staff-created entries do NOT appear as "orders" on the vendor dashboard.** They show up in the ledger with `status=pending` so the vendor can review them there. The orders inbox is only for customer-initiated orders (the shopping list flow).

**Category filter:** The "New Client Orders" section only renders if:
```dart
final cat = user.businessCategory?.toLowerCase() ?? '';
final showOrders = ['grocery', 'kirana', 'pharmacy', 'retail', 'wholesale']
    .any((c) => cat.contains(c));
```
Other categories (salon, dairy) can still receive orders but they show as a compact badge, not a full section in the dashboard body.

---

## Implementation Order

The correct build order (each depends on the previous):

```
1. Multi-Item Entry (Feature 1)          ← no new backend model needed beyond parentEntryId
2. Per-Customer Default Qty (Feature 2)  ← backend Link table change + new screen
3. Customer Detail Tabs (Feature 3)      ← uses existing ledger + Feature 2 data
4. Monthly Settlement Screen (Feature 5) ← uses existing ledger entries, filter by month
5. Order Flow (Feature 6)                ← new feature, new backend
6. Service Catalog (Feature 7a)          ← extends existing booking
7. Job Tracker (Feature 7b)              ← extends Feature 7a
8. Membership Plans (Feature 4)          ← largest change, last
```

---

## Backend Summary — All New Endpoints

```
# Feature 1 — Multi-item entries
(no new endpoint — use existing POST /ledger/entry, add parentEntryId field)

# Feature 2 — Default qty
PATCH  /api/v1/links/:linkId/defaults

# Feature 4 — Membership plans
GET/POST        /api/v1/membership/plans
PATCH/DELETE    /api/v1/membership/plans/:id
GET             /api/v1/membership/customers
PATCH           /api/v1/membership/customers/:id
GET             /api/v1/membership/my
POST            /api/v1/membership/enroll

# Feature 6 — Orders
GET/POST        /api/v1/orders
GET             /api/v1/orders/vendor
GET             /api/v1/orders/customer
GET             /api/v1/orders/staff
PATCH           /api/v1/orders/:id/status

# Feature 7 — Services
GET/POST        /api/v1/services
PATCH/DELETE    /api/v1/services/:id
```

---

## What Does NOT Change

- Auth flow (OTP, role selection)
- Existing bulk-charge screen — stays as-is for multi-customer single-product delivery
- Staff pay screen
- Notification flow
- PDF statement generation (extended by Feature 5, not replaced)
- Reports screen
- Search / discover vendors

---

*See sibling documents for each feature's detailed wire-flows and mock screens.*
