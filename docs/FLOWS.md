# SaathKhata — Role Flows & Mock Screens

> Companion to PLAN.md. Shows every screen from init to completion for each feature,
> from all three roles: Vendor (V), Customer (C), Staff (S).
> All mock screens are ASCII approximations of the Flutter UI.

---

## Feature 1 — Multi-Item Ledger Entry

### 1.1 Vendor adds a multi-item credit (Give Credit / "Udhaar Diya")

**Trigger:** Vendor is on the shared ledger for a customer and taps "Udhaar Diya"

```
┌─────────────────────────────────┐
│  ← Sharma Ji Ledger            │
│  Balance: ₹340                  │
│  [entries list...]              │
│                                 │
│ ┌──────────┐  ┌──────────────┐ │
│ │ Paisa    │  │  Udhaar     │ │  ← LedgerActions bottom bar
│ │ Mila ↓   │  │  Diya ↑    │ │
│ └──────────┘  └──────────────┘ │
└─────────────────────────────────┘
         │ tap Udhaar Diya
         ▼
┌─────────────────────────────────┐
│  ↑ Udhaar Diya                  │  ← MultiItemEntrySheet
│  Entry for: Sharma Ji           │
├─────────────────────────────────┤
│  ITEMS                          │
│  ┌───────────────────────────┐  │
│  │ Full Cream Milk    2  × ₹60│  │  ← item row (name | qty | price | = amount | ×)
│  │                   = ₹120 ×│  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │ Curd               1  × ₹40│  │
│  │                   = ₹40  ×│  │
│  └───────────────────────────┘  │
│                                 │
│  [+ Add Item]                   │
│                                 │
│  ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈   │
│  Total             ₹160         │
│                                 │
│  [📷 Camera]  [🖼 Gallery]      │  ← optional photo proof
│                                 │
│  [Save — ₹160 to Sharma Ji's   │
│   Khata]                        │
└─────────────────────────────────┘
         │ tap Save
         ▼
Backend: POST /ledger/entry (parent, amount=160, description="2 items")
         POST /ledger/entry (child1, parentEntryId=parent.id, description="Full Cream Milk", qty=2, amount=120)
         POST /ledger/entry (child2, parentEntryId=parent.id, description="Curd", qty=1, amount=40)
         ▼
Toast: "₹160 added to Sharma Ji's Khata"
Ledger list refreshes → new collapsed entry appears at top
```

### 1.2 Customer sees collapsed + expandable entry

```
┌─────────────────────────────────┐
│  ← Ramesh Dairy Ledger          │
│  Balance: ₹500                  │
├─────────────────────────────────┤
│  ● Jun 15 · 2 items   +₹160  ⌄ │  ← collapsed parent entry
│                                 │
│  ● Jun 14 · Milk 2L   +₹120    │  ← standalone entry
│                                 │
│  ✓ Jun 13 · Payment   -₹500    │
└─────────────────────────────────┘
         │ tap ⌄ on Jun 15 row
         ▼
┌─────────────────────────────────┐
│  ● Jun 15 · 2 items   +₹160  ⌃ │  ← expanded, ⌃ to collapse
│    ├ Full Cream Milk   +₹120   │
│    └ Curd              +₹40   │
│                   Total: ₹160  │
│                                 │
│  ● Jun 14 · Milk 2L   +₹120    │
└─────────────────────────────────┘
```

### 1.3 Staff adds multi-item delivery via Record Entry Sheet

```
Staff Home → [Record Delivery] → RecordEntrySheet
         (credit mode, customer pre-selected or picked from dropdown)
         ▼
┌─────────────────────────────────┐
│  🚚 Record Delivery             │
│  Adds credit to customer's khata│
├─────────────────────────────────┤
│  Customer: [Sharma Ji ▼]        │
├─────────────────────────────────┤
│  ITEMS                          │
│  ┌─────────────────────────────┐│
│  │ Full Cream Milk  2  × ₹60  ││
│  │                  = ₹120  × ││
│  └─────────────────────────────┘│
│  [+ Add Item]                   │
│                                 │
│  Total: ₹120                    │
│                                 │
│  [Deliver & Charge]             │
└─────────────────────────────────┘
```

---

## Feature 2 — Per-Customer Default Quantity

### 2.1 Vendor sets defaults for a customer

```
All Customers Screen
┌─────────────────────────────────┐
│  All Customers  38  +           │
│  [Search...]                    │
│  [All] [Overdue] [Paid]         │
├─────────────────────────────────┤
│  S  Sharma Ji         ₹340  ⋮  │  ← ⋮ menu
│     Sector 12                   │
├─────────────────────────────────┤
         │ tap ⋮
         ▼
┌─────────────────────────────────┐
│  Sharma Ji                      │  ← bottom action sheet
│  ─────────────────────────────  │
│  📋 View Ledger                 │
│  ⚙  Set Default Delivery       │  ← new option
│  ✏  Edit Nickname               │
│  🔗 View Link Info              │
└─────────────────────────────────┘
         │ tap Set Default Delivery
         ▼
┌─────────────────────────────────┐
│  Default Delivery — Sharma Ji   │  ← CustomerDefaultsSheet
│  Pre-fills Quick Delivery daily │
├─────────────────────────────────┤
│  Product name                   │
│  [Full Cream Milk            ]  │
│                                 │
│  Unit    [L   ]                 │
│                                 │
│  Default qty per day            │
│  [−] [  2  ] [+]               │
│                                 │
│  Price per unit  [₹60       ]   │
│                                 │
│  Daily amount:  ₹120            │
│                                 │
│  [Save Defaults]                │
└─────────────────────────────────┘
```

### 2.2 Staff Quick Delivery Screen (new dedicated screen)

```
Staff Home
┌─────────────────────────────────┐
│  Ramesh Dairy (Raju's account)  │
│  Staff: Raju                    │
├─────────────────────────────────┤
│  ┌──────────────────────────┐   │
│  │ 🚚 Record Delivery       │   │  ← existing button (single customer)
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │ ⚡ Quick Delivery         │   │  ← NEW button
│  │ All customers at once    │   │
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │ 💰 Collect Payment       │   │  ← existing button
│  └──────────────────────────┘   │
└─────────────────────────────────┘
         │ tap ⚡ Quick Delivery
         ▼
StaffQuickDeliveryScreen
┌─────────────────────────────────┐
│  ← Quick Delivery  Jun 28       │
│  3/7 done  ████░░░░ 43%         │
├─────────────────────────────────┤
│  ✅ Sharma Ji                   │  ← green = marked done
│     Full Cream Milk  2L  ₹120   │
│                                 │
│  ✅ Priya Mehta                 │
│     Full Cream Milk  1L  ₹60    │
│                                 │
│  ○  Gupta Store   [−] [5L] [+] │  ← pending, stepper
│     Full Cream Milk       ₹300  │   pre-filled from defaultQty
│                     [Mark ✓]   │
│                                 │
│  ○  Anita Verma   [−] [1L] [+] │
│                     [Mark ✓]   │
│                                 │
│  ⊘  Singh Store  (no default)  │  ← no default set, qty=0
│     [−] [0 ] [+]  [Mark ✓]    │
│                                 │
├─────────────────────────────────┤
│  Done: 3 · Remaining: 4         │
│  [Finish & Save Remaining (4)]  │  ← batch submit
└─────────────────────────────────┘
```

Individual tapping [Mark ✓] = immediate single entry (optimistic).
[Finish & Save Remaining] = batch submit all pending rows with current qty.

---

## Feature 3 — Customer Detail Screen (Vendor View)

### 3.1 New tabbed screen — vendor navigates to it from All Customers

```
All Customers → tap customer row
         ▼
CustomerDetailScreen
┌─────────────────────────────────┐
│  ← S  Sharma Ji   📞  💬  [Gold●]│  ← compact tier badge in AppBar
│     +91 98765 · Sector 12       │
├─────────────────────────────────┤
│  ┌──────┐ ┌──────┐ ┌────┐ ┌───┐│
│  │ ₹340 │ │  2L  │ │18d │ │Jun││
│  │Owed  │ │Daily │ │ OD │ │ 1 ││
│  └──────┘ └──────┘ └────┘ └───┘│
├─────────────────────────────────┤
│ [+Delivery] [+Bill] [+Pay] [Chase]│
├─────────────────────────────────┤
│ [History] [Dues] [Delivery] [Info]│  ← TabBar
├─────────────────────────────────┤
│  (Tab content below)             │
└─────────────────────────────────┘
```

**Tab: History**
```
│  ● Jun 15 · 2 items    +₹160  ⌄│
│  ● Jun 14 · Milk 2L    +₹120   │
│  ✓ Jun 13 · Payment   -₹500   │
│  ● Jun 12 · Milk 2L    +₹120   │
│  (same as existing ledger list) │
```

**Tab: Dues**
```
│  JUNE 2026                      │
│  [Apr] [May] [Jun✓] [Jul]       │
│  ─────────────────────────────  │
│  Opening Balance        ₹0      │
│  Total Credited   +₹3,600       │
│  Total Paid       -₹3,260       │
│  ─────────────────────────────  │
│  Closing Balance        ₹340    │
│                                 │
│  [View Monthly Statement →]     │
```

**Tab: Delivery** (only for delivery-category vendors)
```
│  June 2026                      │
│  M  T  W  T  F  S  S           │
│  ✅ ✅ ✅ ✅ ✅ ✅ –            │  ← green = delivered, – = holiday/Sunday
│  ✅ ✅ ✅ ❌ ✅ ✅ –            │  ← red = missed
│  ✅ ...                         │
│                                 │
│  Tap any day to see entry detail│
```

**Tab: Info**
```
│  CONTACT                        │
│  📞 +91 98765 43210             │
│  📍 Sector 12, Near Park        │
│                                 │
│  ACCOUNT                        │
│  Since: Jun 1, 2025             │
│  Credit limit: ₹3,000           │
│                                 │
│  DEFAULT DELIVERY               │
│  Full Cream Milk · 2L · ₹60/L  │
│  [Edit Defaults]                │
```

**Membership chip behavior (all roles, AppBar)**
```
Vendor sees:  [Gold ●]  in AppBar action row
              Tap → slides up MembershipSheet:
              ┌───────────────────────────────┐
              │ Sharma Ji · Gold Member       │
              │ Discount: 10% off per due     │
              │ Change tier: [Bronze][Silver][Gold✓]│
              │ [Save]                        │
              └───────────────────────────────┘

Customer sees: [Gold ●]  in their ledger AppBar
               Tap → see tier benefits
               If no tier + vendor has plans → [Browse Plans]
```

---

## Feature 4 — Vendor Membership Plans

### 4.1 Vendor creates a plan

```
Vendor Side Nav / Settings → [Membership Plans]
         ▼
MembershipPlansScreen
┌─────────────────────────────────┐
│  Membership Plans       [+]     │
│  Raju Salon                     │
├─────────────────────────────────┤
│  ACTIVE PLANS                   │
│  ┌──────────────────────────┐   │
│  │ 🥇 Gold  ₹999/mo         │   │
│  │ 4 Haircuts · 10% off     │   │
│  │ 3 enrolled     [Edit]    │   │
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │ 🥈 Silver  ₹599/mo       │   │
│  │ 2 Haircuts · 5% off      │   │
│  │ 1 enrolled     [Edit]    │   │
│  └──────────────────────────┘   │
│                                 │
│  [👥 View All Members]          │
│                                 │
│  NOTE: Discount tiers are       │
│  separate (see Tier Settings)   │
└─────────────────────────────────┘
         │ tap [+]
         ▼
Create / Edit Plan Sheet
┌─────────────────────────────────┐
│  Create Membership Plan         │
├─────────────────────────────────┤
│  Plan Name    [Gold Membership] │
│  Duration     [30] days         │
│  Price        [₹999] /month     │
│                                 │
│  BENEFITS                       │
│  ✓ 4 Haircuts included    [×]  │
│  ✓ 10% off extra services [×]  │
│  ✓ Priority booking slot  [×]  │
│  [+ Add benefit]               │
│                                 │
│  SESSIONS (optional)            │
│  Total sessions: [4]            │
│  (leave 0 for unlimited)        │
│                                 │
│  ADVANCE REQUIRED               │
│  [None] [₹200 ✓] [₹500]       │
│                                 │
│  [Publish Plan]                 │
└─────────────────────────────────┘
```

### 4.2 Vendor manages members

```
MembershipPlansScreen → [👥 View All Members]
         ▼
CustomerMembershipsScreen
┌─────────────────────────────────┐
│  Members · 4 active             │
│  [All Plans] [Gold] [Silver]    │
├─────────────────────────────────┤
│  S  Sharma Ji                   │
│     Gold · Exp: Jun 30          │
│     Sessions: 3/4 used  (amber) │
│     [Adjust] [Pause] [Cancel]   │
├─────────────────────────────────┤
│  P  Priya Mehta                 │
│     Gold · Exp: Jun 20  ⚠ soon │
│     Sessions: 4/4 used  (red)   │
│     [Adjust] [Pause] [Cancel]   │
├─────────────────────────────────┤
│  R  Rohan Kumar                 │
│     Silver · Exp: Jul 10        │
│     Sessions: 1/2 used  (green) │
│     [Adjust] [Pause] [Cancel]   │
└─────────────────────────────────┘
```

### 4.3 Customer browses and enrolls in a plan

```
Customer → ledger screen for Raju Salon
         ↓
AppBar shows: [No plan ●] (grey)  OR  [Gold ●] (amber if enrolled)

If no plan → banner at top of ledger:
┌─────────────────────────────────┐
│  💎 Raju Salon has membership   │
│  plans — save up to 10%         │
│  [Browse Plans →]               │
└─────────────────────────────────┘
         │ tap
         ▼
BrowsePlansScreen
┌─────────────────────────────────┐
│  ← Membership Plans             │
│  Raju Salon                     │
├─────────────────────────────────┤
│  ┌──────────────────────────┐   │
│  │ ★ POPULAR               │   │
│  │ 🥇 Gold      ₹999/mo     │   │
│  │ ✓ 4 Haircuts included   │   │
│  │ ✓ 10% off extra services │   │
│  │ ✓ Priority booking slot │   │
│  │ [Enroll → Pay ₹999 UPI] │   │
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │ 🥈 Silver    ₹599/mo     │   │
│  │ ✓ 2 Haircuts included   │   │
│  │ ✓ 5% off extras         │   │
│  │ [Enroll → Pay ₹599 UPI] │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
         │ tap Enroll
         ▼
UPI payment screen (existing flow)
         ▼
Enrollment confirmed → AppBar badge updates to [Gold ●]
```

### 4.4 Customer views their membership card

```
AppBar [Gold ●] tap → MembershipCardSheet
┌─────────────────────────────────┐
│  🥇 GOLD MEMBER                 │
│  Raju Salon                     │
├─────────────────────────────────┤
│  ┌──────┐ ┌───────┐ ┌────────┐ │
│  │ 3/4  │ │ ₹150  │ │ Jun 30 │ │
│  │Used  │ │Saved  │ │Expires │ │
│  └──────┘ └───────┘ └────────┘ │
│  ●●●○  1 session left          │
├─────────────────────────────────┤
│  BENEFITS                       │
│  ✓ 4 Haircuts (3 used, 1 left) │
│  ✓ 10% off extras   (active)   │
│  ✓ Priority booking (active)   │
├─────────────────────────────────┤
│  [🔄 Renew ₹999]  [⏸ Pause]    │
└─────────────────────────────────┘
```

---

## Feature 5 — Monthly Settlement Screen

### 5.1 Vendor views settlement for a customer

```
CustomerDetailScreen → Dues tab → [View Monthly Statement]
         ▼
MonthlySettlementScreen
┌─────────────────────────────────┐
│  ← Monthly Statement   [Share] │
│  Sharma Ji · Ramesh Dairy       │
├─────────────────────────────────┤
│  [Apr] [May] [Jun ✓] [Jul]     │  ← horizontal month picker
├─────────────────────────────────┤
│  ╔═══════════════════════════╗  │
│  ║ JUNE 2026 STATEMENT       ║  │
│  ║ Ramesh Dairy              ║  │
│  ║ Sharma Ji                 ║  │
│  ╚═══════════════════════════╝  │
├─────────────────────────────────┤
│  Opening Balance           ₹0  │
│  Total Credited (+30)  +₹3,600 │
│  Total Paid (×2)       -₹3,260 │
│  ─────────────────────────────  │
│  Closing Balance         ₹340  │
├─────────────────────────────────┤
│  CREDITS THIS MONTH             │
│  Jun 1   Milk 2L         ₹120  │
│  Jun 2   Milk 2L         ₹120  │
│  Jun 3   2 items ⌄       ₹160  │  ← expandable
│  ...                            │
├─────────────────────────────────┤
│  PAYMENTS THIS MONTH            │
│  Jun 13  Cash          -₹500   │
│  Jun 1   UPI         -₹2,760   │
├─────────────────────────────────┤
│  [📄 Download PDF]              │
│  [📤 Share via WhatsApp]        │
└─────────────────────────────────┘
```

### 5.2 Customer views settlement for a vendor

```
Customer → ledger for Ramesh Dairy
         ↓ existing "Download Statement" button changes to "View Statement"
         ▼
MonthlySettlementScreen (same screen, different role context)
(same layout as above, but customer sees their own perspective:
 "Payable to Ramesh Dairy: ₹340")
```

**No staff access** — the "View Statement" entry point does not exist in `StaffHomeScreen` or `StaffCustomersScreen`.

---

## Feature 6 — Order / Shopping List Flow

### 6.1 Customer places an order

```
Customer Dashboard → vendor tile → [📋 Order] button
OR
Customer Dashboard → top action → [+ New Order]
         ▼
OrderMethodScreen
┌─────────────────────────────────┐
│  ← Send Order to Vendor         │
│  Raju Kirana Store              │
├─────────────────────────────────┤
│  How do you want to send        │
│  your order?                    │
│                                 │
│  ┌──────────────────────────┐   │
│  │ ✏ Type your list         │   │
│  │ Add items one by one     │   │
│  └──────────────────────────┘   │
│                                 │
│  ┌──────────────────────────┐   │
│  │ 📷 Photo of your list    │   │
│  │ Handwritten? Photograph  │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
         │ tap Type list
         ▼
TypeOrderScreen
┌─────────────────────────────────┐
│  ← Type Your List     [Send ✓] │
│  Raju Kirana · 4 items          │
├─────────────────────────────────┤
│  ┌───────────────────────────┐  │
│  │ Atta (10kg)    1 bag  [×] │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │ Toor Dal       2 kg   [×] │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │ Sunflower Oil  5L tin [×] │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │ Item name   │ Qty         │  │  ← draft new item row
│  │ [Rice...  ] │ [5 kg    ]  │  │
│  │ Note: [India Gate...]      │  │
│  │ [+ Add This Item]          │  │
│  └───────────────────────────┘  │
│                                 │
│  Delivery note: [before 7pm...] │
│                                 │
│  [📤 Send Order (4 items)]     │
└─────────────────────────────────┘
         │ submit
         ▼
POST /api/v1/orders
         ▼
OrderSentScreen
┌─────────────────────────────────┐
│  Order Sent! ✅                  │
│  Raju Kirana was notified       │
├─────────────────────────────────┤
│  ORDER SUMMARY                  │
│  Atta 10kg          1 bag       │
│  Toor Dal           2 kg        │
│  Sunflower Oil      5L          │
│  Sugar              2 kg        │
│  Sent at:  Today 11:23am        │
├─────────────────────────────────┤
│  WHAT HAPPENS NEXT              │
│  ✅ Order sent                  │
│  ⏳ Vendor confirms             │
│  🚚 Delivery scheduled          │
│  📒 Bill added to Khata         │
└─────────────────────────────────┘
```

### 6.2 Vendor processes the order

```
Vendor Dashboard — shows "Orders 🔴3" badge when pending orders exist
         ▼
OrderInboxScreen
┌─────────────────────────────────┐
│  Client Orders  3 pending       │
│  [Pending] [Confirmed] [All]    │
├─────────────────────────────────┤
│  SHARMA JI          Just now    │
│  5 items · Sector 12            │
│  Atta·Dal·Oil·Sugar·Rice        │
│  ┌──────────┐  ┌────────────┐   │
│  │ ✅ Confirm│  │ ❌ Reject  │   │
│  └──────────┘  └────────────┘   │
├─────────────────────────────────┤
│  MEHTA FAMILY       10 min ago  │
│  3 items                        │
│  [Confirmed] ✓                  │
│  [Mark Delivered] (vendor only) │
└─────────────────────────────────┘
         │ tap Confirm
         ▼
PATCH /orders/:id { status: "confirmed" }
Customer receives push notification: "Your order was confirmed!"
Vendor order card moves to Confirmed tab
```

### 6.3 Staff delivers the order

```
Staff Quick Delivery Screen → [Orders] tab
┌─────────────────────────────────┐
│  ← Quick Delivery               │
│  [Deliveries] | [Orders ●2]     │
├─────────────────────────────────┤
│  SHARMA JI                      │
│  Atta·Dal·Oil·Sugar·Rice (5)    │
│  Confirmed · Today 11:23am      │
│  [📋 View Items] [Mark Delivered]│
├─────────────────────────────────┤
│  MEHTA FAMILY                   │
│  3 items                        │
│  Confirmed · Today 10:45am      │
│  [📋 View Items] [Mark Delivered]│
└─────────────────────────────────┘
         │ tap Mark Delivered
         ▼
PATCH /orders/:id { status: "delivered", deliveredBy: staffUserId }
Backend auto-creates LedgerEntry (credit) for the order total
Customer push: "Your order from Raju Kirana has been delivered!"
Vendor push: "Sharma Ji's order was delivered by Raju"
```

---

## Feature 7a — Service Catalog (Booking)

### 7.1 Vendor creates services (only for service-category vendors)

```
Vendor Bottom Nav → [📅 Bookings] (existing)
         ▼
VendorBookingsScreen — gains new [Services] tab in AppBar actions
         │ or via: [⚙ Manage] → [My Services]
         ▼
ServiceCatalogScreen
┌─────────────────────────────────┐
│  My Services       [+]          │
│  Raju Salon                     │
├─────────────────────────────────┤
│  ✂  Haircut           ₹150     │
│     30 min            [✏ Edit] │
├─────────────────────────────────┤
│  🪒  Beard Trim        ₹80     │
│     20 min            [✏ Edit] │
├─────────────────────────────────┤
│  💈  Hair Colour       ₹600    │
│     90 min            [✏ Edit] │
├─────────────────────────────────┤
│  [+ Add New Service]            │
└─────────────────────────────────┘
         │ tap +
         ▼
Add/Edit Service Sheet
┌─────────────────────────────────┐
│  New Service                    │
├─────────────────────────────────┤
│  Service name  [Head Massage  ] │
│  Emoji / icon  [💆]             │
│  Duration      [45] minutes     │
│  Price         [₹200          ] │
│                                 │
│  [Save Service]                 │
└─────────────────────────────────┘
```

### 7.2 Customer selects service when booking

```
Customer → Vendor Profile → [Book Appointment]
         ▼
BookAppointmentScreen (modified — service picker added at top)
┌─────────────────────────────────┐
│  ← Book Appointment             │
│  Raju Salon                     │
├─────────────────────────────────┤
│  SELECT SERVICE                 │
│  ○ ✂ Haircut      30min  ₹150  │
│  ● 🪒 Beard Trim  20min  ₹80   │  ← selected
│  ○ 💈 Hair Colour 90min  ₹600  │
├─────────────────────────────────┤
│  SELECT DATE                    │
│  [Mon] [Tue ✓] [Wed] [Thu] [Fri]│
├─────────────────────────────────┤
│  AVAILABLE SLOTS (20min blocks) │
│  [9:00] [9:30] [10:30 ✓] [2:00]│
├─────────────────────────────────┤
│  Beard Trim · Jun 17 · 10:30am  │
│  ₹80 (₹40 advance)              │
│                                 │
│  [Confirm & Pay ₹40 Advance]    │
└─────────────────────────────────┘
```

## Feature 7b — Job Tracker (Tailor / Carpenter)

### 7.3 Vendor tracks job stages

```
VendorBookingsScreen → [Jobs] tab (visible for tailor/carpenter category)
┌─────────────────────────────────┐
│  Jobs  12 active                │
├─────────────────────────────────┤
│  SHARMA JI                      │
│  2 Kurtas · Due: Jun 18         │
│  [──●──○──○──○] Stage: Cutting  │
│  [Notify Client] [Next Stage →] │
├─────────────────────────────────┤
│  PRIYA MEHTA                    │
│  Blouse · Due: Jun 16           │
│  [──●──●──●──○] Stage: Ready    │
│  [Notify Client] [Mark Delivered]│
├─────────────────────────────────┤
│  RAMESH KUMAR                   │
│  Suit · Due: Jun 25             │
│  [●──○──○──○] Stage: Intake     │
│  [Notify Client] [Next Stage →] │
└─────────────────────────────────┘
```

Stages for tailor: Intake → Cutting → Stitching → Ready → Delivered
Stages for carpenter/repair: Intake → In Progress → Testing → Ready → Delivered

### 7.4 Customer tracks their job

```
Customer bookings screen → job card
┌─────────────────────────────────┐
│  Rafi Tailor                    │
│  2 Kurtas · Due: Jun 18         │
│  [──●──●──○──○]                 │
│  Currently: Stitching           │
│  Est. ready: Jun 18             │
├─────────────────────────────────┤
│  Payment: ₹1,200                │
│  Advance paid:  -₹400           │
│  Balance on pickup: ₹800        │
│                                 │
│  [📞 Call Rafi Tailor]          │
└─────────────────────────────────┘
```

---

## Complete Navigation Map

```
VENDOR
├── /vendor (Dashboard)
│   ├── Orders badge → /vendor/orders
│   └── Quick actions → bulk-charge, outstanding, collected
├── /vendor/customers (All Customers)
│   └── tap customer → /vendor/customer-detail
│       ├── Tab: History → [shared ledger list]
│       ├── Tab: Dues → /ledger/settlement
│       ├── Tab: Delivery → delivery calendar
│       └── Tab: Info → defaults editor
├── /booking (Bookings)
│   ├── Tab: Today / Upcoming
│   ├── Tab: Jobs (tailor/repair category)
│   └── AppBar → /services (Service Catalog)
├── /membership-plans (NEW)
│   └── → /member-list (NEW)
└── /ledger (Shared Ledger, existing — also entry from customer-detail)

CUSTOMER
├── /customer (Dashboard)
│   └── vendor tile → /ledger (per vendor)
│       ├── [View Statement] → /ledger/settlement
│       ├── [Browse Plans] → /browse-plans (NEW)
│       └── [📋 Order] → /order-method (NEW)
├── /customer/booking (My Bookings)
│   └── job card → in-screen job tracker
└── /customer/profile (Profile)

STAFF
├── /staff-home (Home)
│   ├── [⚡ Quick Delivery] → /staff-home/quick-delivery (NEW)
│   │   ├── Tab: Deliveries (from Feature 2)
│   │   └── Tab: Orders (from Feature 6)
│   ├── [🚚 Record Delivery] → RecordEntrySheet (multi-item, Feature 1)
│   └── [💰 Collect Payment] → RecordEntrySheet (single amount)
└── /staff-home/customers (Customer List)
    └── → /ledger (per customer, isStaffView=true)
```

---

## Data Flow Diagram — All Features Connected

```
                    ┌──────────────┐
                    │   BACKEND    │
                    │  Express+TS  │
                    │  PostgreSQL  │
                    └──────┬───────┘
                           │ REST + WebSocket
              ┌────────────┼────────────┐
              │            │            │
         ┌────▼───┐  ┌─────▼──┐  ┌────▼───┐
         │ VENDOR │  │CUSTOMER│  │ STAFF  │
         │  App   │  │  App   │  │  App   │
         └────┬───┘  └─────┬──┘  └────┬───┘
              │             │           │
         Feature            │      Feature 2
         1,2,3,4,5,6,7      │      (Quick Delivery)
                            │      Feature 1
                            │      (Multi-item)
                       Feature 1,3
                       4(enroll),5
                       6(place order)

WebSocket events that all 3 roles receive in real-time:
  ledger:entry_added   → updates ledger list live
  ledger:entry_updated → status changes (confirmed/disputed)
  membership:updated   → tier/plan changes
  order:status_changed → order flow notifications
```

---

*All screens above are Flutter widget trees. See PLAN.md for exact file paths.*
