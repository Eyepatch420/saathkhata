# F004 — Complete Khata Flow Verification

**Status:** PLANNING / VERIFICATION  
**Purpose:** Full end-to-end documentation of the khata system for all 3 roles  
**Critical:** This is the core of SaathKhata — every other feature feeds into this

---

## 1. SYSTEM OVERVIEW

The "Khata" (ledger) is the central feature. It is a shared running balance between a vendor and each of their customers. All transactions — credits (goods/services given), payments (money received), and deliveries (order-based credits) — flow through the ledger.

**Central data entities:**
- `vendor_customer_links` — the relationship between one vendor and one customer. Holds `balance` (denormalized sum of confirmed/auto-confirmed credits minus payments).
- `ledger_entries` — individual financial events (credit, payment, advance, adjustment)
- `orders` / `order_items` — ordered goods, on delivery → generates ledger_entry
- `payment_transactions` — explicit payment records linked to a ledger_entry

---

## 2. THE THREE ROLES

| Role | Creates | Confirms/Disputes | Can See |
|------|---------|-------------------|---------|
| Vendor | credit, adjustment, advance; delivers orders → auto credit | Confirms customer payments | All entries for their customers |
| Customer | payment only | Confirms vendor credits | Their own khata with each vendor |
| Staff | credit (on behalf of vendor), delivers orders → auto credit | Cannot confirm (staff can't confirm) | Their vendor's customers' ledgers |

---

## 3. DATABASE SCHEMA (Khata-Relevant)

### 3.1 `vendor_customer_links`

```sql
id                    UUID PK
vendor_id             UUID FK → users
customer_id           UUID FK → users
is_active             BOOLEAN DEFAULT true
balance               DECIMAL(12,2) DEFAULT 0    -- DENORMALIZED running total
vendor_nickname       VARCHAR(100) NULL
customer_nickname     VARCHAR(100) NULL
default_product       TEXT NULL
default_unit          TEXT NULL
default_qty           DECIMAL(10,3) NULL
default_price_per_unit DECIMAL(10,2) NULL
created_at / updated_at
UNIQUE(vendor_id, customer_id)
```

**balance semantics:** Positive = customer owes vendor. Negative = vendor owes customer (overpaid). `balance` only changes on confirmation/auto-confirmation of an entry, NOT on entry creation.

### 3.2 `ledger_entries`

```sql
id               UUID PK
link_id          UUID FK → vendor_customer_links
vendor_id        UUID FK → users
customer_id      UUID FK → users
amount           DECIMAL(12,2)
type             'credit' | 'payment' | 'advance' | 'adjustment'
date             TIMESTAMP (backdatable)
description      TEXT NULL
quantity         DECIMAL(10,3) NULL
unit             VARCHAR(20) NULL
status           'pending' | 'confirmed' | 'disputed' | 'auto_confirmed'
confirmed_at     TIMESTAMP NULL
is_locked        BOOLEAN DEFAULT false  -- immutable after confirm/dispute
dispute_reason   TEXT NULL
attachment_url   VARCHAR(500) NULL
created_by       UUID FK → users
parent_entry_id  UUID FK → ledger_entries (self-referential)
is_parent        BOOLEAN DEFAULT false
child_count      INTEGER DEFAULT 0
created_at / updated_at
```

**Key invariants:**
- `is_locked = true` when `status IN ('confirmed', 'auto_confirmed', 'disputed')`. **No further modification possible.**
- `balance` is adjusted only on confirmation (not creation) AND only for top-level entries (not child entries).
- Child entries (`parent_entry_id IS NOT NULL`) do NOT contribute to `balance` — only the parent (which holds the total) does.
- `status = 'disputed'` — entry is locked but balance is NOT applied (amount is still "in dispute").

### 3.3 `orders` / `order_items`

```sql
orders:
  id, link_id, vendor_id, customer_id, status (pending/confirmed/rejected/delivered/cancelled)
  note, delivered_by, delivered_by_role ('vendor'|'staff'), delivered_at
  delivery_note, proof_url, ledger_entry_id (FK → ledger_entries)

order_items:
  id, order_id, name, qty, unit, price_per_unit, note, sort_order
```

On delivery, `order.ledger_entry_id` is populated with the created parent ledger entry ID.

---

## 4. BALANCE MECHANICS

### 4.1 How Balance Updates

```
                    Entry Created
                         ↓
                  status = 'pending'
                  is_locked = false
                  balance: UNCHANGED
                         ↓
           ┌─────────────┴─────────────┐
           ↓                           ↓
    Confirmed by               Disputed by
    other party                other party
    (or auto)                  
           ↓                           ↓
    status = 'confirmed'       status = 'disputed'
    is_locked = true           is_locked = true
    balance: UPDATED           balance: UNCHANGED
```

### 4.2 Balance Delta Formula

```typescript
function balanceDelta(type: EntryType, amount: number): number {
  return type === 'credit' ? amount : -amount;
}
// credit → increases what customer owes (balance goes up)
// payment, advance, adjustment → reduces what customer owes (balance goes down)
```

`adjustBalance(linkId, delta)` does `UPDATE vendor_customer_links SET balance = balance + delta`.

### 4.3 Auto-Confirmed Entries (No Confirmation Required)

Certain entries bypass the pending→confirmed flow and are created directly as `auto_confirmed, is_locked=true, balance adjusted immediately`:

| Source | auto_confirmed? | Why |
|--------|----------------|-----|
| Payment recording (`POST /links/:id/payments`) | YES | Payment is self-evidencing |
| Order delivery (vendor/staff marks order as `delivered`) | YES | Vendor/staff controls the delivery action |
| Full settlement (`POST /links/:id/payments/settle`) | YES | Vendor/customer explicit settlement |

Manual ledger entries (`POST /links/:id/entries`) are ALWAYS created as `status = 'pending'` with `is_locked = false`.

### 4.4 The Missing 72-Hour Auto-Confirm

**CRITICAL GAP IDENTIFIED:** The backend has `auto_confirmed` as a status but there is **NO scheduled job that auto-confirms pending entries after 72 hours.** 

The queues system (`src/infrastructure/jobs/queues/index.ts`) only has:
- `token-cleanup` queue (runs every 6 hours — purges expired refresh tokens)
- `notifications` queue (BullMQ for sending push notifications)

There is NO `ledger-auto-confirm` queue or cron job. This means:
- Pending manual entries stay `pending` indefinitely
- The balance is never applied for entries that neither party acts on
- There is no timeout mechanism to prevent stale disputes

**This is a planned feature that hasn't been implemented yet.** The F004 section below covers what needs to be built.

---

## 5. ENTRY LIFECYCLE — MANUAL ENTRIES

### 5.1 Vendor Creates a Credit Entry

```
Vendor Dashboard → Customer Card → tap → SharedLedgerScreen
  → FAB (+ icon) or "Add Entry" button
    → AddEntrySheet (bottom sheet)
      Amount, Type (credit/advance/adjustment), Description, Qty, Unit, Date
      → LedgerBloc: AddLedgerEntry
        → LedgerRepository.addEntry
          → POST /links/:linkId/entries
            Body: { amount, type, date (UTC ISO), description?, quantity?, unit?, attachmentUrl? }
            
Backend:
  1. Verify link exists + user is vendor or customer of that link
  2. If customer: type must be 'payment' (403 otherwise)
  3. INSERT into ledger_entries:
     status = 'pending', is_locked = false, balance NOT changed
  4. emitLedgerEvent('ledger:entry_added', linkId, { entry })
     → Socket.IO broadcasts to all users in room `link:{linkId}`
  5. No push notification on creation (only on confirm)
  
Response: LedgerEntryResponse

Frontend:
  - Socket event received by LedgerBloc (SocketLedgerEntryAdded)
  - Entry inserted at top of allEntries list
  - Balance unchanged in UI (still shows old balance)
  - Customer receives socket update (sees new pending entry)
```

### 5.2 Multi-Item Credit Entry (Vendor)

```
AddEntrySheet → "Add Items" toggle → ItemsFormWidget
  Multiple rows: description + amount + qty + unit
  → LedgerBloc: AddMultiItemLedgerEntry
    For each item in series:
      1. POST /links/:linkId/entries with { isParent: true, ... } for the FIRST item (total)
         Wait for parent entry ID
      2. For each subsequent item:
         POST /links/:linkId/entries with { parentEntryId: parentId }
         
Note: Multi-item is done client-side in sequence — there is NO batch endpoint.
Each child increments parent.child_count.
Parent amount = sum of all items (caller must calculate this).
```

### 5.3 Customer Confirms a Credit Entry

```
Customer sees pending credit in their SharedLedgerScreen
  → Swipe / tap "Confirm" button on entry card
    → LedgerBloc: ConfirmLedgerEntry(entryId)
      → LedgerRepository.confirmEntry(entryId)
        → PATCH /links/:linkId/entries/:entryId/confirm

Backend (LedgerService.confirmEntry):
  1. SELECT ... FOR UPDATE on ledger_entries row (row lock)
  2. Validate:
     - Entry must exist
     - User must be vendor OR customer of this link
     - created_by must NOT be userId (can't confirm own entry)
     - status must be 'pending'
     - is_locked must be false
  3. UPDATE: status='confirmed', confirmed_at=now(), is_locked=true
  4. Balance adjustment: if NOT a child entry:
     linkRepo.adjustBalance(link_id, balanceDelta(type, amount))
  5. Commit transaction
  6. emitLedgerEvent('ledger:entry_updated', linkId, { entry })
  7. Push notifications to BOTH vendor AND customer:
     type: 'entry_confirmed', title: 'Entry Confirmed', body: '₹X entry was confirmed'
     
Frontend:
  - Socket event → LedgerBloc.SocketLedgerEntryUpdated → replace entry in list
  - Balance recalculated from allEntries
  - Balance chip in header updates
  - Both sides' SharedLedgerScreen update in real-time
```

### 5.4 Customer Disputes a Credit Entry

```
Customer sees pending credit they disagree with
  → Tap "Dispute" on entry card
    → DisputeReasonDialog (enter reason)
      → LedgerBloc: DisputeLedgerEntry(entryId, reason)
        → PATCH /links/:linkId/entries/:entryId/dispute
          Body: { reason: string }

Backend (LedgerService.disputeEntry):
  1. SELECT ... FOR UPDATE (row lock, prevents race with confirm)
  2. Validate:
     - created_by must NOT be userId
     - status must be 'pending'
     - is_locked must be false
  3. UPDATE: status='disputed', dispute_reason=reason, is_locked=true
  4. Balance: NOT adjusted (disputed entries don't affect balance)
  5. emitLedgerEvent('ledger:entry_updated', linkId, { entry })
  6. No push notification on dispute (TODO: this should probably notify the vendor)

Frontend:
  - Entry becomes locked, shows dispute badge
  - Balance unchanged (was never applied for pending)
  - Vendor can see the dispute reason in entry detail
```

### 5.5 Vendor Creates a Payment Entry (Manual)

Manual payment recording is done via the LEDGER — not via the Payments endpoint.

Actually, **no** — looking at the code, manual payment recording goes through:
- `POST /links/:linkId/payments` (PaymentController.recordPayment)
- This creates an `auto_confirmed`, `is_locked=true` ledger entry + a `payment_transactions` row

The ledger's `addEntry` with `type: 'payment'` is only accessible to customers (to record that they've paid). When the vendor records a payment (received), they use the dedicated payments endpoint.

**Wait — re-examining:** The `addEntry` check is:
```typescript
if (isCustomer && input.type !== 'payment') {
  throw new ForbiddenError('Customers can only add payment entries');
}
```

This means:
- **Customer** can only POST `type='payment'` via `POST /links/:linkId/entries`
- **Vendor/Staff** can POST any type (credit, advance, adjustment, payment) via `POST /links/:linkId/entries`

But vendor payment recording via `POST /links/:linkId/payments` creates an `auto_confirmed` entry. Vendor using `POST /links/:linkId/entries` with `type='payment'` would create a `pending` entry — which is wrong behavior.

**Actual design:** Vendors should use `POST /links/:linkId/payments` to record payments received. The frontend only exposes the payments endpoint to vendors, not the raw entry endpoint for payments.

---

## 6. ENTRY LIFECYCLE — ORDER-BASED (AUTOMATIC)

### 6.1 Customer Places Order

```
Customer Dashboard → Vendor Card → "Place Order" button
  → PlaceOrderScreen (VendorLinkItem passed as extra)
    → Items form (name, qty, unit, price per item, order note)
    → OrderBloc: PlaceOrder
      → OrderRepository.create
        → POST /orders
          Body: { linkId, items: [...], note? }

Backend:
  1. Verify link exists + customer is the customer of this link
  2. INSERT into orders (status='pending')
  3. INSERT all order_items
  4. Push notification to VENDOR:
     type: 'order_placed', title: 'New Order', body: 'New order with N items received'
  
No ledger entry created yet. Balance unchanged.

Frontend:
  - Order appears in CustomerOrdersScreen (status: pending)
```

### 6.2 Vendor Confirms Order

```
Vendor receives 'order_placed' push notification
  → VendorOrdersScreen shows pending orders
    → Vendor taps order → Order detail sheet
      → "Confirm" button
        → OrderBloc: UpdateOrderStatus(orderId, 'confirmed')
          → PATCH /orders/:orderId/status
            Body: { status: 'confirmed' }

Backend:
  1. Verify vendor owns this order
  2. Check transition: pending → confirmed is allowed
  3. UPDATE order status = 'confirmed'
  4. Push notification to CUSTOMER:
     'Order Confirmed' → 'Your order has been confirmed and will be delivered soon'

No ledger entry yet. Balance unchanged.
```

### 6.3 Order Rejected

```
Vendor sees pending order → "Reject" button
  → PATCH /orders/:orderId/status { status: 'rejected' }
  
Backend:
  1. pending → rejected is allowed
  2. Push notification to CUSTOMER: 'Order Rejected'
  
No ledger entry. Order is terminal state.
```

### 6.4 Vendor/Staff Marks Order as Delivered

```
VendorOrdersScreen or StaffOrdersScreen → confirmed order
  → "Mark Delivered" button
    → DeliveryProofSheet (optional: delivery note, proof URL)
      → OrderBloc: UpdateOrderStatus(orderId, 'delivered', { deliveryNote, proofUrl })
        → PATCH /orders/:orderId/status
          Body: { status: 'delivered', deliveryNote?, proofUrl? }

Backend (OrderService.updateStatus, 'delivered' branch):
  BEGIN TRANSACTION
  1. Fetch all order_items for this order
  2. Calculate total = sum(item.qty × item.price_per_unit)
  3. CREATE parent ledger_entry:
     { link_id, vendor_id, customer_id, amount: total, type: 'credit',
       date: now, description: 'Order delivery (by vendor|staff)',
       status: 'auto_confirmed', confirmed_at: now, is_locked: true,
       created_by: actorId (vendor or staff user), is_parent: true,
       child_count: itemCount }
  4. For each order_item, CREATE child ledger_entry:
     { parent_entry_id: parentEntry.id, amount: itemSubtotal,
       description: item.name, quantity: item.qty, unit: item.unit,
       type: 'credit', status: 'auto_confirmed', is_locked: true,
       is_parent: false }
  5. UPDATE order: status='delivered', delivered_by=actorId,
     delivered_by_role='vendor'|'staff', delivered_at=now,
     delivery_note, proof_url, ledger_entry_id=parentEntry.id
  COMMIT
  
  6. emitLedgerEvent('ledger:entry_added', linkId, { entry: parentEntry })
  7. Push to CUSTOMER:
     type: 'order_delivered', title: 'Order Delivered',
     body: 'Your order of N items has been delivered (₹total)'

Balance: The parent entry's amount is applied to vendor_customer_links.balance
         IMMEDIATELY (auto_confirmed) — balance goes up by `total`.

NOTE: The balance adjustment happens inside the delivery transaction:
  - linkRepo.adjustBalance is NOT called in this flow (unlike payment service)
  - Looking at order.service.ts: I see only ledger creation and order status update,
    but NOT linkRepo.adjustBalance()

⚠️ CRITICAL FINDING: The order delivery flow (OrderService.updateStatus 'delivered')
creates auto_confirmed ledger entries but does NOT call linkRepo.adjustBalance().
This means balance is NOT updated when orders are delivered.

Compare with payment.service.ts which explicitly calls:
  await this.linkRepo.adjustBalance(linkId, -input.amount, trx);

This is a BUG or the balance is expected to be recalculated from entries on every
read (not denormalized). Looking at the balance endpoint: it returns link.balance
(the denormalized field) + stats from ledger entries. The denormalized balance is
the source of truth for the balance chip.

CONCLUSION: Order delivery does not update the denormalized balance.
Payment recording DOES update the denormalized balance.
Manual confirmed entries DO update the denormalized balance.

This means the delivery ledger entries (auto_confirmed) don't contribute to
link.balance but DO count in the stats queries (confirmed_count, totalCreditAmount).
The displayed balance on SharedLedgerScreen may be incorrect for delivery-heavy flows.

This needs verification/fix.
```

### 6.5 Staff Quick Delivery

```
Staff Portal → StaffHomeScreen → "Quick Delivery" tab
  → StaffQuickDeliveryScreen
    → Select customer (from vendor's customers list)
    → Pre-fills default product/qty/price from link defaults
    → Staff can override qty, price
    → "Deliver" button
      → Creates an order (or directly creates ledger entry?)
      
Note: Need to check StaffQuickDeliveryScreen implementation.
The staff delivery may go through the order flow OR directly through the ledger.
If through orders: same 6.4 flow above.
If direct ledger entry: staff creates credit entry on behalf of vendor.
```

---

## 7. ENTRY LIFECYCLE — PAYMENT RECORDING

### 7.1 Customer Records Payment (via Ledger Entry)

```
Customer SharedLedgerScreen → "Add Payment" button
  → AddEntrySheet with type forced to 'payment'
    → LedgerBloc: AddLedgerEntry(type: payment, amount, linkId)
      → POST /links/:linkId/entries { type: 'payment', amount, ... }

Backend:
  status = 'pending', balance NOT changed
  → Vendor must CONFIRM this payment for it to count

CONFIRMATION (vendor side):
  Vendor sees pending payment in their ledger
  → Confirms it
  → balance -= amount (payment reduces what customer owes)
```

### 7.2 Vendor Records Payment (Explicit Payment Recording)

```
SharedLedgerScreen → "Record Payment" button (vendor view)
  → RecordPaymentSheet
    → amount, UPI transaction ID (opt), payment method, note
    → PaymentBloc (or direct call): POST /links/:linkId/payments
      Body: { amount, paymentMethod, upiTransactionId?, note? }

Backend (PaymentService.recordPayment):
  BEGIN TRANSACTION
  1. CREATE ledger_entry: type='payment', status='auto_confirmed',
     is_locked=true, confirmed_at=now
  2. linkRepo.adjustBalance(linkId, -amount, trx)   ← BALANCE UPDATED IMMEDIATELY
  3. CREATE payment_transaction row linked to ledger_entry
  COMMIT
  4. Push notification to CUSTOMER: 'Payment Received', '₹X payment via UPI'

Balance goes down immediately. No confirmation needed.
```

### 7.3 Full Settlement

```
Vendor or Customer → SharedLedgerScreen → "Settle" button
  → ConfirmDialog
    → POST /links/:linkId/payments/settle { note? }

Backend (PaymentService.settleLink):
  1. Get current balance from link
  2. If balance <= 0: throw BadRequestError
  3. Calls recordPayment(linkId, userId, { amount: currentBalance, method: 'upi' })
  → balance becomes 0
  → auto_confirmed ledger entry created
  → push notification to the other party
```

---

## 8. SHARED LEDGER SCREEN — FRONTEND

### 8.1 Navigation to SharedLedgerScreen

**From Vendor:**
```
AllCustomersScreen / CustomerDetailScreen → customer card tap
  → context.push(AppRouter.sharedLedger, extra: {
      'linkId': customer.linkId,
      'name': customer.displayName,
      'isVendorView': true,
      'isStaffView': false,
    })
```

**From Customer:**
```
MyKhatasScreen → vendor card tap → SharedLedgerScreen(isVendorView: false)
```

**From Staff:**
```
StaffCustomersScreen → customer → SharedLedgerScreen(isVendorView: true, isStaffView: true)
```

### 8.2 SharedLedgerScreen Structure

```
AppBar: customerName | balance chip
Tabs:
  "Entries"   → LedgerList (all entries, filterable by status)
  "Deliveries" → DeliveriesScreen (filtered to isDelivery entries only)
  "Payments"  → PaymentsListWidget
  "Orders"    → (vendor/staff view shows all, customer view shows their orders)

FAB: (vendor/staff) Add Entry button → slides up AddEntrySheet
     (customer) hidden or Add Payment button

Balance chip:
  Shows link.balance (from SharedLedgerScreen constructor arg passed from parent)
  LedgerBloc._calcBalance() recalculates from loaded entries (sum of confirmed credits - payments)
  Note: discrepancy possible between link.balance (denormalized) and calculated from entries
```

### 8.3 LedgerBloc State Machine

```
LedgerInitial
  ↓ LoadLedger(linkId)
LedgerLoading
  ↓ getEntries (up to 100 entries, page 1)
LedgerLoaded(allEntries, entries, balance, activeFilter)
  ↓ AddLedgerEntry / AddMultiItemLedgerEntry
LedgerActionLoading (keeps showing entries while action runs)
  ↓ on success
LedgerLoaded (entry added to allEntries prepended)
  ↓ ConfirmLedgerEntry
LedgerActionLoading
  ↓ on success
LedgerLoaded (entry updated in list, balance recalculated)
  ↓ DisputeLedgerEntry → same
  ↓ FilterLedger(status?) → pure state transform, no API call
  ↓ SocketLedgerEntryAdded → insert entry if not already present
  ↓ SocketLedgerEntryUpdated → replace existing entry
  ↓ RefreshLedger → silent refetch (no LedgerLoading, spinner at top only)
```

### 8.4 Balance Calculation (Frontend)

```dart
double _calcBalance(List<LedgerEntry> entries) {
  double balance = 0;
  for (final e in entries) {
    if (e.status != EntryStatus.confirmed && e.status != EntryStatus.autoConfirmed) continue;
    if (e.parentEntryId != null) continue; // child entries don't contribute
    if (e.type == EntryType.credit) {
      balance += e.amount;
    } else {
      balance -= e.amount;
    }
  }
  return balance;
}
```

This recalculates balance from the loaded 100 entries. The `link.balance` (denormalized) is used for the initial display until entries are loaded.

---

## 9. REAL-TIME UPDATES (SOCKET.IO)

### 9.1 Connection

```
App start → AuthBloc._onCheckStatus → getIt<LedgerSocketService>().connect(accessToken)
Auth login → ... → connect(accessToken)
```

### 9.2 Socket Architecture

```
Client connects to /socket.io
  Authentication: JWT in socket.handshake.auth.token
  On connection: server calls socket.join('user:{userId}')

When client opens a SharedLedgerScreen:
  LedgerSocketService emits 'ledger:join' { linkId }
  Server: socket.join('link:{linkId}')
  
When client closes SharedLedgerScreen (dispose):
  LedgerSocketService emits 'ledger:leave' { linkId }
  Server: socket.leave('link:{linkId}')
```

### 9.3 Events Emitted by Server

| Event | Room | Payload | Trigger |
|-------|------|---------|---------|
| `ledger:entry_added` | `link:{linkId}` | `{ linkId, entry: LedgerEntryResponse }` | new entry created |
| `ledger:entry_updated` | `link:{linkId}` | `{ linkId, entry: LedgerEntryResponse }` | entry confirmed/disputed/attachment |
| `membership:updated` | `link:{linkId}` | membership data | membership change |
| `notification:new` | `user:{userId}` | notification object | new push notification |

### 9.4 Client Handling

```dart
// LedgerSocketService subscribes to ledger:entry_added and ledger:entry_updated
// and dispatches to LedgerBloc:
SocketLedgerEntryAdded(entry)   → bloc event
SocketLedgerEntryUpdated(entry) → bloc event

// Deduplication in bloc:
SocketLedgerEntryAdded: skip if entry.id already in allEntries
SocketLedgerEntryUpdated: replace entry by id
```

---

## 10. NOTIFICATIONS (PUSH + IN-APP)

### 10.1 Push Notification Flow

```
Backend action → enqueueNotification({ recipientUserId, type, title, body, data })
  → BullMQ 'notifications' queue
    → Worker (notification.worker.ts) processes job:
      1. Creates notification row in 'notifications' table
      2. Calls sendPushToUser(userId, title, body, data)
         → Gets FCM device tokens from device_tokens table
         → messaging.sendEachForMulticast(...)
      3. emitNotificationToUser(userId, notificationData)
         → Socket.IO to 'user:{userId}' room: 'notification:new'
```

### 10.2 Notification Types by Khata Action

| Action | Recipient(s) | Type |
|--------|-------------|------|
| Customer places order | Vendor | `order_placed` |
| Vendor confirms order | Customer | `order_status_changed` (confirmed) |
| Vendor rejects order | Customer | `order_status_changed` (rejected) |
| Order delivered | Customer | `order_delivered` |
| Entry confirmed | Vendor + Customer | `entry_confirmed` |
| Payment received | Other party | `payment_received` |
| Vendor sends remind-all | All customers with balance | `payment_reminder` |

**No notification on:** entry creation, entry dispute, entry attachment, link request sent

### 10.3 In-App Notifications

`NotificationsScreen` fetches from `GET /notifications`. `NotificationBloc` loads unread count on app start. Badge on the bell icon.

---

## 11. ROLE-SPECIFIC ACTIONS SUMMARY

### 11.1 Vendor Actions

| Action | Endpoint | Ledger Effect |
|--------|----------|--------------|
| Add credit entry | POST /links/:id/entries { type:'credit' } | pending entry, balance unchanged |
| Add advance entry | POST /links/:id/entries { type:'advance' } | pending entry |
| Add adjustment | POST /links/:id/entries { type:'adjustment' } | pending entry |
| Add multi-item credit | N sequential POSTs | parent + child entries, all pending |
| Record payment received | POST /links/:id/payments | auto_confirmed entry, balance -= amount |
| Confirm customer's payment | PATCH /entries/:id/confirm | balance -= customer's payment amount |
| Settle link | POST /links/:id/payments/settle | auto_confirmed payment entry, balance = 0 |
| Mark order delivered | PATCH /orders/:id/status {delivered} | auto_confirmed credit entries |
| Remind all customers | POST /links/remind-all | notification only, no ledger |

### 11.2 Customer Actions

| Action | Endpoint | Ledger Effect |
|--------|----------|--------------|
| Record payment made | POST /links/:id/entries { type:'payment' } | pending entry |
| Confirm vendor's credit | PATCH /entries/:id/confirm | balance += vendor's credit amount |
| Dispute vendor's credit | PATCH /entries/:id/dispute | entry locked, balance unchanged |
| Place order | POST /orders | no ledger until delivery |
| View their khata | GET /links/:id/entries | read-only |

### 11.3 Staff Actions

| Action | Endpoint | Ledger Effect |
|--------|----------|--------------|
| Add credit (on behalf of vendor) | POST /links/:id/entries { type:'credit' } | pending entry, created_by = staff.userId |
| Mark order delivered | PATCH /orders/:id/status { delivered } | auto_confirmed entries, delivered_by = staff |
| Quick delivery | POST via order or direct entry | same as above |
| View customer ledger | GET /links/:id/entries | read-only |

**Staff CANNOT:**
- Confirm or dispute entries
- Record payments
- Access settings
- Add customers

---

## 12. LINK CREATION FLOW (prerequisite to Khata)

```
Vendor adds customer:
  VendorDashboard → FAB → showVendorAddCustomerSheet
    → Enter customer identifier (phone or email)
    → LinkRequestRepository.vendorSendRequest
      → POST /link-requests/vendor-send { customerIdentifier, nickname? }
        Backend: finds customer by phone/email, creates link_request (initiated_by='vendor')
      → Customer receives push notification
      → Customer accepts → link created in vendor_customer_links
      → linkId assigned, balance = 0

Customer adds vendor:
  CustomerDashboard → FAB → showCustomerAddVendorSheet
    → Enter vendor identifier
    → LinkRequestRepository.customerSendByIdentifier
      → POST /link-requests/customer-send { vendorIdentifier, nickname? }
      → Vendor receives notification
      → Vendor accepts → link created
```

---

## 13. IDENTIFIED BUGS AND GAPS

### 13.1 🔴 CRITICAL: Balance Not Updated on Order Delivery

**File:** `src/app/modules/orders/services/order.service.ts`, `updateStatus` method (delivered branch)

The delivery flow creates `auto_confirmed` ledger entries but does NOT call `linkRepo.adjustBalance()`. The `payment.service.ts` DOES call `adjustBalance`. This inconsistency means:

- `link.balance` (denormalized) does NOT include delivery credits
- Frontend balance chip shows incorrect balance for delivery-based flows
- The `stats` query in `getBalance` endpoint counts `auto_confirmed` in `totalCreditAmount` — but the denormalized `balance` field is wrong

**Fix needed:** Add `await this.linkRepo.adjustBalance(order.link_id, orderTotal, trx)` in the `delivered` branch of `OrderService.updateStatus`.

### 13.2 🟡 MEDIUM: No 72-Hour Auto-Confirm Job

Pending entries that neither party acts on stay pending forever. The schema supports `auto_confirmed` but there is no cron job to move `pending` → `auto_confirmed` after 72 hours.

**Fix needed:**
1. Add a `ledger-auto-confirm` queue in `queues/index.ts`
2. Schedule a cron job (e.g., every 6 hours): find entries where `status='pending'` AND `created_at < NOW() - INTERVAL '72 hours'` AND `is_locked = false`
3. For each: UPDATE status='auto_confirmed', is_locked=true, confirmed_at=now()
4. Call linkRepo.adjustBalance for each such entry (within a transaction)
5. Send push notifications to both parties

### 13.3 🟡 MEDIUM: No Push Notification on Dispute

When a customer disputes an entry, the vendor is NOT notified. The `disputeEntry` code explicitly says "No push notification on dispute." This should send a notification to the vendor.

### 13.4 🟡 MEDIUM: Balance Discrepancy

The frontend `_calcBalance` recalculates balance from loaded entries (limited to 100 via `limit: 100`). For customers with > 100 entries, the calculated balance will be wrong. The `link.balance` denormalized field should be authoritative, but as noted in bug 13.1, it's also potentially wrong for delivery entries.

### 13.5 🟡 MEDIUM: Staff Quick Delivery Implementation Unknown

`StaffQuickDeliveryScreen` was not read by agents. Need to verify whether it goes through the order flow or directly creates ledger entries. If it creates ledger entries directly (bypassing orders), then `delivered_by_role` and `delivery_note` fields won't be populated on the order.

### 13.6 🟢 LOW: Child Entry Balance Risk

Child ledger entries created from multi-item delivery orders have `parent_entry_id` set. The `balanceDelta` is only applied for non-child entries (`if (!locked.parent_entry_id)`). This is correct. But the delivery flow creates children with `auto_confirmed` status — these would still not contribute to balance (since only parent does). The parent has the full total. This is correct design but must be preserved.

### 13.7 🟢 LOW: Email login dual-account bug (documented in F002)

If same email exists for vendor + customer, `emailLogin` picks arbitrarily.

---

## 14. THE KHATA FLOW — COMPLETE END-TO-END TRACE

```
HAPPY PATH (most common: milk vendor, daily delivery):

T+0: Vendor creates link with customer (link_requests → accepted → vendor_customer_links, balance=0)
T+1: Customer places milk order (orders status=pending, no ledger)
T+2: Vendor confirms order (orders status=confirmed, no ledger, customer notified)
T+3: Staff delivers milk:
     → PATCH /orders/:id/status { status: 'delivered', deliveredByRole: 'staff' }
     → OrderService: 
         parent ledger_entry { type:'credit', amount:₹30, status:'auto_confirmed' }
         child entry { amount:₹30, description:'Full Cream Milk', qty:1, unit:'L' }
         order updated, ledger_entry_id set
     → BUG: link.balance NOT updated (stays 0)
     → Socket event → customer sees new entry in their khata
     → Customer push: 'Order Delivered ₹30'
     
T+4: Vendor records cash payment received:
     → POST /links/:id/payments { amount: 30, method: 'cash' }
     → PaymentService: auto_confirmed payment entry, link.balance -= 30 (now 0)
     → Customer push: 'Payment Received ₹30'

NET BALANCE: 0 (correct, but only because payment offset the delivery)
ACTUAL STATE: delivery credit exists in entries (auto_confirmed) but NOT in link.balance
              payment exists in entries (auto_confirmed) and IS in link.balance
```

---

## 15. REQUIRED FIXES TO IMPLEMENT

### 15.1 Fix Order Delivery Balance Update

**File:** `src/app/modules/orders/services/order.service.ts`

In the `delivered` branch (around line 205), after creating ledger entries, add:
```typescript
await this.linkRepo.adjustBalance(order.link_id, orderTotal, trx);
```
This must be inside the transaction, before `trx.commit()`.

### 15.2 Implement 72-Hour Auto-Confirm Cron

**New file:** `src/infrastructure/jobs/workers/auto-confirm.worker.ts`

```typescript
export async function runAutoConfirm(): Promise<void> {
  const db = getDb();
  const cutoff = new Date(Date.now() - 72 * 60 * 60 * 1000);
  
  const staleEntries = await db('ledger_entries')
    .where({ status: 'pending', is_locked: false })
    .where('created_at', '<', cutoff)
    .whereNull('parent_entry_id') // only top-level entries
    .select('*');
    
  for (const entry of staleEntries) {
    const trx = await db.transaction();
    try {
      await db('ledger_entries').transacting(trx).where({ id: entry.id }).update({
        status: 'auto_confirmed',
        confirmed_at: new Date(),
        is_locked: true,
        updated_at: new Date(),
      });
      const delta = entry.type === 'credit' 
        ? parseFloat(entry.amount) 
        : -parseFloat(entry.amount);
      await linkRepo.adjustBalance(entry.link_id, delta, trx);
      await trx.commit();
      
      // Notify both parties
      await enqueueNotification({ recipientUserId: entry.vendor_id, type: 'entry_auto_confirmed', ... });
      await enqueueNotification({ recipientUserId: entry.customer_id, type: 'entry_auto_confirmed', ... });
      
      emitLedgerEvent('ledger:entry_updated', entry.link_id, { linkId: entry.link_id, entry: formatEntry(entry) });
    } catch { await trx.rollback(); }
  }
}
```

Schedule in `queues/index.ts`:
```typescript
// Add auto-confirm queue
autoConfirmQueue = new Queue('auto-confirm', { connection });
await autoConfirmQueue.add('run', {}, { repeat: { pattern: '0 */6 * * *' } }); // every 6h
```

### 15.3 Add Dispute Notification

In `LedgerService.disputeEntry`, after commit, add:
```typescript
await enqueueNotification({
  recipientUserId: entry.vendor_id,
  type: 'entry_disputed',
  title: 'Entry Disputed',
  body: `₹${amount} entry was disputed: ${reason.substring(0, 50)}`,
  data: { linkId: entry.link_id, entryId, amount },
});
```

---

## 16. CURRENT ARCHITECTURE (VERIFIED)

```
Frontend:
  SharedLedgerScreen
    ├── LedgerBloc (state: LedgerInitial/Loading/ActionLoading/Loaded/Error)
    ├── LedgerRepositoryImpl → ApiClient → Backend
    └── LedgerSocketService → Socket.IO

Backend:
  ledger.routes.ts
    ├── GET  /links/:linkId/entries           → LedgerController.getEntries
    ├── POST /links/:linkId/entries           → LedgerController.addEntry
    ├── PATCH /links/:linkId/entries/:id/confirm  → LedgerController.confirmEntry
    ├── PATCH /links/:linkId/entries/:id/dispute  → LedgerController.disputeEntry
    └── POST /links/:linkId/entries/:id/attachment → LedgerController.attachToEntry
  
  LedgerService
    ├── LedgerRepository (DB queries)
    └── LinkRepository (balance adjustments)
  
  OrderService → LedgerRepository + OrderRepository + LinkRepository
  PaymentService → LedgerRepository + PaymentRepository + LinkRepository
```

---

## 17. SCALING CONSIDERATIONS

- `ledger_entries` has compound indexes on `(link_id, created_at)` and `(link_id, status)` — efficient for per-link pagination
- Balance is denormalized (not recalculated from sum on every read) — O(1) balance fetch
- The 100-entry frontend limit means very old entries don't load — for long-running vendor-customer relationships, a "load more" button is needed
- Socket.IO rooms per link (`link:{linkId}`) — well-designed for real-time per-pair updates
- BullMQ + Redis for notification fanout — non-blocking

---

## 18. SECURITY

- All ledger endpoints require authentication (JWT Bearer)
- Staff accessing vendor's customer ledger uses `effectiveVendorId` middleware which checks staff's `vendor_id` in JWT
- `confirmEntry` / `disputeEntry` validate that `created_by !== userId` (can't confirm own entries)
- Row-level locking (`FOR UPDATE`) prevents race conditions on confirm/dispute
- `is_locked = true` prevents any modification after the terminal state
- No direct SQL from frontend — all parameterized via Knex
