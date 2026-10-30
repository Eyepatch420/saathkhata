# SaathKhata — App flow map (vendor · customer · staff/delivery)

**Purpose.** Read this end-to-end to answer "how does this feature work, who does what, and what happens at the edges?" Everything here was read from the code in `saath_khata` (Flutter) and `saath_khata_backend` (Express) and exercised against a running backend.

Legend: **[code]** = read from source, **[live]** = exercised against the local API on 2026-10-30 (dummy OTP `123456`), **[emu]** = exercised in the Android emulator.

---

## 1. Who is who

| Persona | `users.role` | Landing route | Bottom nav |
|---|---|---|---|
| Vendor / seller | `vendor` | `/vendor` (`app_router.dart:180`) | Home · Staff · Booking · Schedule · Reports · Settings |
| Customer / buyer | `customer` | `/customer` | Home · My Khatas · Bookings · Schedule · Profile |
| Staff (delivery / helper) | `staff` | `/staff-home` | Home · Customers · Pay · Orders |

**Key navigation fact:** the role picker only offers **Vendor** and **Customer** (`role_selection_screen.dart`). A delivery person logs in through the **Vendor** card — the *server* decides the landing page from `users.role`, and the router redirect sends `user.isStaff` to `/staff-home` **[emu]**. Confirmed live: `8000000003` typed under the Vendor card landed on "Ansari General Store · Staff · Ravi Kumar".

`_publicRoutes` = splash, language-selection, onboarding, role-selection, phone-entry, otp-verify, login, email-login, email-signup, profile-setup, location-picker. Everything else redirects an unauthenticated user to `/role-selection`, and an authenticated user away from the public screens (`app_router.dart:152-190`) **[code]**.

---

## 2. Login / logout (the gate everything else sits behind)

### 2.1 Phone + OTP **[live] [emu]**

```
Role card → /phone-entry {role} → POST /auth/otp/send {phone}
        → /otp-verify {phone, role, resendAfterSeconds}
        → POST /auth/otp/verify {phone, otp}
             existing user → {existingUser:true, user, tokens}
             new number    → {existingUser:false, signupToken}
        → /profile-setup (new users) → POST /auth/signup {signupToken, name, role, …}
```

- The OTP is **never** in the response: `{sent, expiresInSeconds, resendAfterSeconds}` only **[live]**.
- The resend countdown comes from the server (`resendAfterSeconds`), not a hard-coded value. The backend default is **60 s** (`OTP_COOLDOWN_SECONDS`).
- The phone number is sent as exactly **10 digits**. The client strips `+91`, spaces, dashes and a leading trunk zero before the request, and the backend normalises again at the validation boundary.
- A **resend never navigates**. `AuthOtpSendRequested` carries an origin (`phoneEntry` / `resend`) and `AuthOtpSent` echoes it, so the number screen stays silent while the OTP screen is on top. Back from the OTP screen always returns straight to the number screen — there is no second OTP screen on the stack.
- Server-side controls verified live: cooldown → `429 OTP_COOLDOWN` + `retryAfterSeconds`; wrong code → `400 OTP_INVALID`; reusing a consumed code → `409 OTP_ALREADY_USED`; 3 wrong attempts burns the challenge.
- Every code is **single-use** and purpose-scoped (`login`, `account_delete`, `phone_change`, `email_setup`), so an account-deletion code can never be replayed as a login **[code]** `otpConfig.ts`.

### 2.2 Email + password **[code]**
`/email-login` → `POST /auth/email-login {email, password, role}`; `/email-signup` → `POST /auth/email-signup` (no OTP). Staff cannot use email login — the backend refuses; staff must use phone OTP.

### 2.3 Staff login provisioning **[live]**
Staff do **not** self-signup. Vendor adds a staff member (`POST /staff`) → grants access (`PATCH /staff/:id/access {canLogin:true}`) → the backend provisions a `users` row with role `staff` (`hasAppAccount` flips to `true`). From then on the staff phone logs in with OTP like anyone else.

### 2.4 Logout **[emu]**
Vendor: Settings → Logout. Customer: Profile → Logout. Both show a confirm dialog, then `AuthBloc._onLogout`: `POST /auth/logout {refreshToken}` → `storage.clearAll()` → socket disconnect → `AuthUnauthenticated` → router bounces to `/role-selection` **[emu]**; the server logged `POST /logout → 200` **[live]**.

Edge: the access token stays cryptographically valid until it expires (~15 min) — `authenticate` consults no blocklist, so `/auth/me` still answers `200` with a post-logout access token **[live]**. Only the refresh chain is dead (`/auth/refresh` → `401`). The app never notices because it wiped the token locally.


---

## 3. How a relationship (the "khata") is created

Nobody can see anybody's ledger until a **link** exists. Two entry points, both needing the other side to accept:

| Direction | Who starts | Endpoint | Acceptor |
|---|---|---|---|
| Vendor → customer | vendor knows the customer's phone/email | `POST /link-requests/vendor-send {customerIdentifier, nickname?}` | customer: `PATCH /link-requests/:id/accept` |
| Customer → vendor | customer adds/scans a vendor | `POST /link-requests/customer-send {vendorIdentifier, nickname?}` | vendor: `PATCH /link-requests/:id/accept` |

**[live]** vendor-send → customer `pending-customer` shows it → accept → a `vendor_customer_links` row appears for **both** sides with the **same** `linkId`, and each side sees the other via `GET /links/customers` (vendor) / `GET /links/vendors` (customer).

Edges: a request to a phone with no account, a self-request, or a duplicate link are rejected; declining sets the request `declined` and creates nothing. `isPending` on `/links/vendors` marks a link created by an unaccepted flow.

---

## 4. Ledger mechanics (the money truth)

### 4.1 Entry types and direction (`ledger.service.ts:35`)

```
credit      → +amount (customer owes more)
payment     → −amount
advance     → −amount
adjustment  → ± (sign of the amount decides)
```

### 4.2 Statuses and who may move them

| Status | Created by | Meaning |
|---|---|---|
| `pending` | vendor credit/adjustment when the customer has **not** opted into auto-confirm | customer must confirm or dispute |
| `auto_confirmed` | vendor credit/adjustment when `vendor_customer_links.customer_auto_confirm = true` **and** env `VENDOR_CREDIT_AUTO_CONFIRM !== 'false'` | balance moves immediately, entry locked |
| `confirmed` | customer confirms a pending entry | balance moves now, entry locked |
| `disputed` | customer rejects with a reason (≥5 chars) | balance **never** moved, entry locked |

Rules enforced server-side (`ledger.service.ts:269-300`):
- only a **participant** may confirm/dispute; you cannot confirm your **own** entry;
- only a `pending`, **unlocked** entry can be confirmed or disputed;
- confirm/dispute take a **row lock** (`SELECT … FOR UPDATE`) so two taps cannot double-apply the balance;
- **child entries** (line items under a parent) never touch the balance — only the parent (or a standalone entry) carries the total;
- attachments can be added/replaced only while the entry is unlocked (creator or vendor owner);
- customers may only add **`payment`** entries — they can never invent a debt.

### 4.3 Payments and settlement
`POST /links/:linkId/payments {amount, paymentMethod?, upiTransactionId?, note?}` atomically creates an `auto_confirmed` payment entry + a `payment_transactions` row and reduces the balance. Either party may record one (customer paying, vendor collecting cash). `POST …/payments/settle` pays off the exact outstanding balance in one shot.

### 4.4 Auto-confirm is a *customer* toggle
Profile → **Auto-Confirm Entries** (`PATCH /links/:linkId/auto-confirm`, customer-only). It decides whether future vendor credits lock immediately or wait for the customer. The env flag is the global kill-switch for the whole feature.

### 4.5 What the reports read
`/reports/summary|outstanding|collected-today|monthly|customers|customers/:linkId` read the denormalised `vendor_customer_links.balance` and payment rows, so a confirmed entry shows up in reports instantly (cache invalidated on every write).

### 4.6 Ledger truth verified live
```
vendor POST credit 250 (pending)          → balance 1250 (unchanged), pendingCount 1
customer PATCH …/confirm                  → balance 1500, confirmedCount 1
vendor POST credit 100 → customer dispute → balance 1500, disputedCount 1
customer POST payment 300                 → balance 0, totalCredit 300, totalPayment 300
```
Cross-persona check: the **customer** app showed ₹1,500 outstanding for "Ansari General Store" while the vendor app showed ₹6,460 across its customers **[emu]**.

---

## 5. Delivery flows (three personas, one thread)

There are **two** delivery mechanisms, and they converge on the same ledger.

### 5.1 Order-based delivery (customer wants goods now)

```
customer: /place-order {vendor}       POST /orders              → pending
vendor:   Orders tab                  GET  /orders/vendor
vendor:   confirm / reject            PATCH /orders/:id/status  → confirmed | rejected
staff:    Orders tab (delivery queue) GET  /orders/staff        → confirmed orders only
staff:    mark delivered              PATCH /orders/:id/status  → delivered
vendor:   cancel                      PATCH /orders/:id/status  → cancelled
```
Statuses: `pending → confirmed → delivered`, with `rejected`/`cancelled` as terminal exits. Vendors and staff may also raise an order *for* a customer (`POST /orders/vendor`) when the customer cannot use the app — the customer is derived from the link, never from the body.

### 5.2 Subscription → auto delivery (milk/newspaper pattern)

```
vendor:   Schedule tab → create service (name, price, weekly slots)
customer: vendor profile → subscribe      POST /schedule/services/:id/subscriptions
nightly 00:30 IST job (idempotent)        scheduled_deliveries rows for "today"
staff:    Deliveries tab                  GET /schedule/deliveries
staff:    delivered → ledger entry        PATCH /schedule/deliveries/:id/deliver
staff:    skipped (customer away)         PATCH /schedule/deliveries/:id/skip
customer: pause / resume                  PATCH /schedule/subscriptions/:id/{pause|resume}
```
A delivered row writes a `ledger_entries` row with `source_type = 'delivery'` and `scheduled_delivery_id` set, so the debt is traceable back to the exact delivery. `POST /schedule/dev/run-deliveries` fires the same idempotent generator on demand (used for testing instead of waiting for the cron).

### 5.3 Staff "quick" money actions (the delivery person's real job)

The staff home has four big buttons **[emu]**:
- **Quick Delivery** — pre-fills the customer's default product/qty/price and posts a ledger entry.
- **Orders** — the confirmed-order queue.
- **Amount Pending** — "customer took goods, add to their khata" → a `credit` entry on the owner vendor's link.
- **Amount Received** — "customer paid" → a `payment` entry (reduces the khata).

All three money actions go through the same `LedgerService` with a **staff context**: the link is resolved by the *owner vendor*, the balance belongs to the vendor, and `created_by` records the staff user for audit (`ledger.service.ts:73-95`).

### 5.4 Who enables what

| Capability | Vendor | Customer | Staff |
|---|---|---|---|
| Create a link request | ✅ `vendor-send` | ✅ `customer-send` | ❌ |
| Accept a link request | ✅ | ✅ | ❌ |
| Add `credit` / `adjustment` / `advance` | ✅ | ❌ (403) | ✅ via owner vendor |
| Add `payment` | ✅ | ✅ (own khata) | ✅ via owner vendor |
| Confirm / dispute an entry | ❌ own entries; ✅ as counterparty | ✅ | ❌ |
| Toggle auto-confirm | ❌ | ✅ | ❌ |
| Add/edit staff, pay salary, mark attendance | ✅ | ❌ | ❌ |
| View delivery queue / mark delivered | ✅ | ❌ | ✅ |
| Reports, bulk charge, membership plans | ✅ | ❌ | read-only where allowed |

Enforced by `authorize(...)` per route plus per-row participant checks inside the services — `403 FORBIDDEN` comes back before any data is read **[live]** (`customer → /reports/summary = 403`, `customer → /links/customers = 403`).

---

## 6. Edge cases and how they are handled

| Edge case | Behaviour |
|---|---|
| Wrong OTP | `400 OTP_INVALID`, counts as one of 3 attempts; the challenge dies after 3 |
| OTP reuse | `409 OTP_ALREADY_USED` — a consumed challenge is never valid again |
| Resend spam | `429 OTP_COOLDOWN` + `retryAfterSeconds` (server truth drives the UI countdown) |
| Deleted/disabled user keeps a JWT | `401 "Account is no longer active"` on the very next call **[live]** |
| Staff access revoked mid-session | `401 "App access has been revoked"` **[live]** (see §7 gap) |
| Two confirms at once | row lock serialises them; the second gets `Entry is already confirmed` |
| Dispute after confirm | rejected — a locked entry cannot be disputed |
| Customer tries to add a credit | `403 "Customers can only add payment entries"` |
| Entry date older than 1 year or in the future | `422` (validator bounds `date`) |
| Amount 0 / negative / > 99,99,999 | `422` |
| Balance hidden until confirm | vendor sees `pendingCount`, balance moves only on confirm/auto-confirm **[live]** |
| Empty/malformed/unknown link id | `404 NOT_FOUND` (was a 500 before this session's fix — §8) |
| Deleted account's phone reused | allowed: identifiers are cleared on delete, so the number starts a fresh signup **[live]** |
| Deleting with obligations | `409 DELETE_ACCOUNT_BLOCKED` listing every blocker (`OUTSTANDING_BALANCE`, `ACTIVE_STAFF`, …) **[live]** |
| Rate limits | global 200 req/15 min; auth 20 **failed** attempts/15 min |



---

## 7. Account deletion — what it prunes and what it keeps **[live]**

`DELETE /auth/account` — phone users send `{otp}` obtained from `POST /auth/account/delete-otp`; email-only users send `{password}`.

**Pruned / severed**
- `users.is_active → false`, `mobile → NULL`, `email → NULL` (identifiers freed for reuse)
- every `vendor_customer_links` row touching the user → `is_active = false`
- all refresh tokens → `is_revoked = true` (kept as an audit trail, not deleted)
- vendor: every `staff_members.can_login → false`; staff: own row → `can_login = false`

**Kept on purpose**
- `ledger_entries`, `payment_transactions`, `orders`, `bookings`, `scheduled_*`, `staff_members` — history keeps resolving to a real (now anonymous) owner. FK orphan check after deletion: **0 orphans** **[live]**.

Measured before → after (customer with one confirmed credit and one payment):
```
is_active true → false | mobile 9222200012 → NULL | links_active 1 → 0 (links_total 1)
ledger_rows 1 → 2 (payment entry added) | payments 0 → 1 | refresh_tokens 1, revoked 0 → 1
```
A **blocked** attempt leaves every column unchanged (no partial writes) **[live]**, and blockers come back as a list the app can render:
```json
409 {"error":"DELETE_ACCOUNT_BLOCKED",
     "blockers":[{"code":"OUTSTANDING_BALANCE","message":"You have an unsettled ledger balance with 1 vendor. …"}]}
```
Email-only accounts are password-gated (`400 INVALID_CREDENTIALS` on a wrong password), and the freed email can immediately be used for a new signup **[live]**.

### Known gap found here
A staff member whose `can_login` was revoked (because their vendor was deleted) **cannot delete their own account**: `POST /auth/account/delete-otp` returns `401 "App access has been revoked"` **[live]**. Their `users` row stays active with the phone attached, so that phone gets `existingUser:true` on OTP verify but every API call then 401s — a dead end. Recommended fix: let `authenticate` attach the user (with a `staffAccessRevoked` flag) for the auth self-service routes so `/auth/account*` still works, instead of rejecting before the route is reached.

---

## 8. Frontend → backend endpoint map

`lib/core/network/api_endpoints.dart` is the single catalogue (124 declared endpoints). All of them were probed against a running backend on 2026-10-30 **[live]**:

- **115** answered `401` (mounted, auth required)
- **6** answered `422` (mounted, public + validation)
- **3** answered `200` (public read/no-op: `/content/terms`, `/content/privacy`, `/auth/logout`)
- **0** answered `404 ROUTE_NOT_FOUND` → **no frontend call points at a missing route**

| Frontend constants | Path | Backend module |
|---|---|---|
| `sendOtp`, `verifyOtp`, `signup`, `emailLogin`, `emailSignup`, `refresh`, `logout`, `me`, `updateProfile`, `changePassword`, `deleteAccount`, `deleteAccountOtp` | `/auth/*` | `modules/auth` |
| `myCustomers`, `myVendors`, `remindAll`, `linkById`, `linkNickname`, `linkDefaults`, `linkAutoConfirm` | `/links/*` | `modules/links` |
| `linkEntries`, `linkBalance`, `confirmEntry`, `disputeEntry`, `attachToEntry` | `/links/:id/entries*` | `modules/ledger` |
| `linkPayments`, `settleLink` | `/links/:id/payments*` | `modules/payments` |
| `parseVoice` | `/links/:id/voice/parse` | `modules/voice` |
| `notifications`, `notifUnreadCount`, `notifReadAll`, `notifReadOne` | `/notifications*` | `modules/notifications` |
| `staff*` (11 constants incl. `staffMe`, `staffMeSalaryHistory`, `staffMeQr`) | `/staff*` | `modules/staff` |
| `bookings`, `bookingConfig`, `bookingSlotFull`, `publicSlots`, `vendorBookings`, `customerBookings`, `bookingById`, `dateSlots*`, `replicateDateSlots`, `mergeDateSlots` | `/bookings*` | `modules/bookings` |
| `registerDevice` | `/devices/token` | `modules/devices` |
| `linkRequests`, `vendorSendLinkRequest`, `customerSendLinkRequest`, `pending*`, `sent*`, `vendorSent*`, `linkRequestById`, `acceptLinkRequest`, `declineLinkRequest` | `/link-requests*` | `modules/link-requests` |
| `membershipPlans`, `membershipPlanById`, `membersDashboard`, `useBenefit`, `decrementBenefit`, `membershipStatus`, `enrollMember`, `requestMembership`, `pendingMembershipRequests`, `approve/declineMembershipRequest` | `/memberships*` | `modules/memberships` |
| `productTemplates`, `productTemplateById`, `bulkCharge` | `/templates*` | `modules/product-templates` |
| `searchVendors`, `vendorPublicProfile` | `/search/vendors*` | `modules/search` |
| `placeOrder`, `placeOrderForCustomer`, `vendorOrders`, `customerOrders`, `staffOrders`, `updateOrderStatus` | `/orders*` | `modules/orders` |
| `reportSummary`, `reportCustomers`, `reportCustomerDetail`, `reportOutstanding`, `reportCollectedToday`, `reportMonthly` | `/reports*` | `modules/reports` |
| `schedule*` (12 constants incl. `scheduleDeliveryDeliver`, `scheduleDeliverySkip`, `scheduleMyDeliveries`) | `/schedule*` | `modules/schedule` |
| `termsAndConditions`, `privacyPolicy` | `/content/*` | `modules/content` |

Repositories behind those constants: `vendor_repository_impl`, `customer_repository_impl`, `ledger_repository_impl`, `payment_repository_impl`, `order_repository_impl`, `booking_repository_impl`, `membership_repository_impl`, `link_request_repository_impl`, `notification_repository_impl`, `template_repository`, `voice_repository_impl`, `auth_repository_impl`, plus `api_client.dart` (base URL + token refresh) and `ledger_socket_service.dart` (same host, `/socket.io`).

### Two real defects found while tracing
1. **`/links/null/entries` (blank or stale link id) returned `500 INTERNAL_ERROR`** — Postgres `22P02 invalid input syntax for type uuid`. Fixed this session with `validateLinkId` on the ledger/payment/voice routers → now `404 NOT_FOUND` **[live]**; `/links/customers` & co. untouched.

---

## 9. Reproduce this by hand (10 minutes)

Backend (dev, no SMS, OTP `123456`):
```bash
cd saath_khata_backend
# .env needs: OTP_PROVIDER=dummy, OTP_SENDING_ENABLED=true
npm run migrate:latest && SEED_ALLOWED=true npx knex --knexfile knexfile.ts seed:run
npm run dev                                        # :3001
cd ../saath_khata && flutter run -d emulator-5554  # app talks to 10.0.2.2:3001
```
Seeded logins (all OTP `123456`): vendor `9111100001` (Amaan Ansari), customer `9111100002` (Zara Khan), vendor `8000000001`, customer `8000000002`, **staff `8000000003`** (Ravi Kumar — log in via the Vendor card).

Then: login → logout → login as customer → confirm/dispute an entry → login as staff → Amount Pending / Amount Received.

Real SMS path (production-like): `.env` gets `OTP_PROVIDER=udo`, `UDO_OTP_API_KEY`, `UDO_OTP_CONFIG_ID`, `OTP_IP_HASH_SALT`. Every send costs one real SMS — use a controlled number only.

---

## 10. Open items

1. **Staff self-deletion dead end** (§7) — needs the `authenticate` tweak.
2. **Legacy soft-deleted rows** (`7000000001`, `9186037279`, `9278398281`) are `is_active=false` but still hold their mobile numbers — they predate the current pruning logic; a one-off backfill would clear them.
3. **Post-logout access token** stays valid until expiry (§2.4) — acceptable; add a short blocklist if instant revocation is required.
4. Refresh-token rotation reuse is **rejected** (verified), but the fully atomic revoke-and-issue race (P7) is still open.

2. **UDO provider contract mismatches** (fixed in `b460365`, see `AUTH_OTP_IMPLEMENTATION_REPORT.md`): `/v1/verify` returns `verifyId` (not `data`), and `/v1/verify/validate` uses `401 "Incorrect Otp!"` for a wrong code.
