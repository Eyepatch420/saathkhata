# SaathKhata — Explicit Design Decisions

> Answers every open question from the planning session.
> Each decision is final so the team doesn't need to re-discuss.

---

## Q1: Multi-item entry — one collapsed entry or N separate entries?

**Decision: One parent entry + N child entries, parent shown collapsed in the ledger.**

- Parent entry: `isParent=true`, `amount=total`, `description="N items"`. This is what the customer sees by default and what counts toward the balance.
- Each child: `parentEntryId=parent.id`, individual `amount`, `description=itemName`, `quantity`. Children do NOT count toward balance (only parent does).
- Customer taps the parent row → it expands inline to show all child rows with a subtotal.
- Staff and vendor see the same collapsed/expanded behaviour.
- Vendor can always view children to verify what was sent.

---

## Q2: When should "New Client Orders" show on the vendor dashboard?

**Decision: Orders section shows only for shop-category vendors AND only when there are pending/confirmed-not-yet-delivered orders.**

- Categories that show the Orders section in the dashboard body: `grocery`, `kirana`, `pharmacy`, `retail`, `wholesale`, `catering`.
- All other categories (dairy, salon, tailor, newspaper): show only the badge count — no body section. They can still receive orders and access them from the Orders inbox route.
- Staff-created deliveries do NOT appear in the Orders section. They create `LedgerEntry(status=pending)` which the vendor sees in the Ledger, not in Orders.
- The badge ("Orders 🔴3") disappears when all orders are in `delivered` or `rejected` state.

---

## Q3: Per-customer default quantity — backend or UI-only?

**Decision: Backend (with DB column) + full frontend round-trip.**

- `links` table gets: `default_product`, `default_unit`, `default_qty`, `default_price_per_unit`.
- `PATCH /api/v1/links/:linkId/defaults` endpoint created.
- `CustomerLinkItem` Flutter model gets the 4 fields.
- Staff Quick Delivery screen pre-fills from `customer.defaultQty`.
- Customers with no default: shown with qty=0, stepper still works manually.

---

## Q4: Membership — existing tier system vs. new plans — how do they co-exist?

**Decision: Two separate concepts, both live side by side.**

| | Tier (existing) | Plan (new) |
|--|--|--|
| Created by | Vendor | Vendor |
| Assigned by | Vendor (manually sets Bronze/Silver/Gold) | Customer (self-enrolls and pays) |
| Price | Free (no payment) | Customer pays ₹X/month |
| Purpose | Discount on dues | Benefits package (sessions + discounts) |
| Where shown | AppBar badge on shared ledger | AppBar badge + card on customer side |
| Backend table | `links.tier_level` (already) | New `membership_plans` + `customer_memberships` |

The AppBar badge shows whichever is active. If customer has a plan, it shows the plan name. If only a tier, shows tier name.

---

## Q5: Customer detail screen — does it replace the existing SharedLedgerScreen navigation or add to it?

**Decision: CustomerDetailScreen is a new screen that wraps SharedLedgerScreen's History tab.**

- From vendor's All Customers list → tapping a customer now goes to `CustomerDetailScreen` (new).
- `CustomerDetailScreen` History tab renders the same `LedgerList` widget and uses the same `LedgerBloc`.
- The existing `SharedLedgerScreen` route (`/ledger`) is kept as-is for:
  - Customer's own view of a vendor's ledger
  - Staff's view of a customer's ledger
  - Direct deep-links from notifications
- Vendor can still reach `/ledger` directly (e.g. from notification tap) — it shows the flat ledger without tabs.

---

## Q6: Monthly Settlement — who can see it?

**Decision: Vendor and Customer only. Staff cannot access it.**

- Entry point on vendor side: CustomerDetailScreen → Dues tab → "View Monthly Statement" button.
- Entry point on customer side: SharedLedgerScreen → AppBar icon (replaces old "Download PDF" direct-action).
- Staff home, staff customers screen, staff quick delivery: no settlement button. No route accessible.
- If staff somehow has the route URL, the backend `/ledger/:linkId` will work (staff can read ledger) but the frontend simply won't render the entry point.

---

## Q7: Service catalog — which vendor categories get it?

**Decision: Service catalog is shown for these business categories (case-insensitive substring match):**

```
salon, barber, parlour, spa, massage, physio, physiotherapy,
tailor, darzi, alteration,
plumber, electrician, carpenter, repair, maintenance,
tutor, coach, trainer,
laundry, dhobi
```

Grocery/dairy/newspaper vendors do NOT get a service catalog. They use the existing Bulk Charge flow for product delivery.

The Job Tracker sub-feature is further restricted to:
```
tailor, darzi, alteration, carpenter, repair, electrician, plumber
```

---

## Q8: Job stages — tailor vs. repair?

**Decision: Two stage sets, selected by category.**

Tailor/alteration stages: `intake → cutting → stitching → ready → delivered`

Repair/electrician/plumber/carpenter stages: `intake → in_progress → testing → ready → delivered`

Stage progression is always forward-only (no going back). "Next Stage →" button advances by one. "Mark Delivered" jumps directly to `delivered` from `ready`.

---

## Q9: Order-to-ledger conversion — when and how?

**Decision: On `status=delivered`, backend auto-creates a LedgerEntry with amount=0 and description="Order — N items".**

Reason: Orders don't have prices (they're shopping lists). The vendor still needs to manually price the delivery separately (via the ledger Add Bill flow). The auto-created entry is a marker/reference so both sides can see the delivery happened.

If in the future orders get per-item pricing (v2), the backend can compute and set the actual amount.

The `orders.ledger_entry_id` field links the order to the resulting ledger entry so both can be shown in context.

---

## Q10: Can staff see the monthly settlement?

**Decision: No.** Staff is an operational role (deliver + collect). Financial summaries are vendor and customer territory. No entry point in staff portal.

---

## Q11: Does the customer see the Orders tab in their ledger?

**Decision: Yes, but scoped to this vendor only.**

On the customer side, `SharedLedgerScreen` will get a small "Orders" tab in a future iteration (post-Sprint 3). For now, customers can see their order history by navigating to the order confirmation screen they've already sent. A dedicated orders list for customers is Sprint 6 territory.

---

## Q12: What about the "Delivery" tab in CustomerDetailScreen for non-delivery vendors?

**Decision: Hide it for non-delivery categories.**

The tab controller dynamically has 3 tabs (History / Dues / Info) for service vendors, and 4 tabs (History / Dues / Delivery / Info) for delivery-category vendors.

Delivery categories: `dairy`, `milk`, `tiffin`, `newspaper`, `magazine`, `water`, `gas`.

---

## Summary — Role × Feature Access

```
FEATURE                    VENDOR   CUSTOMER   STAFF
Multi-item credit entry      ✅        ❌         ✅
Multi-item view (expand)     ✅        ✅         ✅
Payment mode (single)        ✅        ✅         ✅
Default qty (set)            ✅        ❌         ❌
Quick delivery screen        N/A       N/A        ✅
Customer detail tabs         ✅        ❌         ❌ (goes to /ledger)
Monthly settlement screen    ✅        ✅         ❌
Create membership plan       ✅        ❌         ❌
Enroll in plan               ❌        ✅         ❌
Manage customer memberships  ✅        ❌         ❌
Place order                  ❌        ✅         ❌
Confirm/reject order         ✅        ❌         ❌
Deliver order                ✅        ❌         ✅
Create services              ✅        ❌         ❌
Book appointment             ❌        ✅         ❌
View job tracker             ✅        ✅ (r/o)   ✅
Advance job stage            ✅        ❌         ✅
```
