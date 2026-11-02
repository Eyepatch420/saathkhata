# SaathKhata — Backend Specification

> All new endpoints, DB schema additions, and model changes needed for the 6 feature areas.
> Existing endpoints are NOT listed unless they need a change.
> Backend: Express + TypeScript + PostgreSQL (saath_khata_backend)

---

## DB Schema Changes

### 1. `ledger_entries` table — add `parent_entry_id`

```sql
ALTER TABLE ledger_entries
  ADD COLUMN parent_entry_id UUID REFERENCES ledger_entries(id) ON DELETE CASCADE,
  ADD COLUMN is_parent       BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN child_count     INT NOT NULL DEFAULT 0;

-- Index for fast child lookup
CREATE INDEX idx_ledger_entries_parent ON ledger_entries(parent_entry_id)
  WHERE parent_entry_id IS NOT NULL;
```

**Behaviour:**
- When a parent entry is created, `is_parent=true`, `amount` = sum of all children.
- Each child has `parent_entry_id` set. Children are NOT counted toward the balance directly — only the parent is.
- `child_count` is a denormalized counter updated by trigger or by the service.
- `GET /ledger/:linkId` returns entries where `parent_entry_id IS NULL` (top-level only), plus a `children` array for each parent.

### 2. `links` table — add default delivery fields

```sql
ALTER TABLE links
  ADD COLUMN default_product       TEXT,
  ADD COLUMN default_unit          TEXT,
  ADD COLUMN default_qty           DECIMAL(10,3),
  ADD COLUMN default_price_per_unit DECIMAL(10,2);
```

### 3. New table: `membership_plans`

```sql
CREATE TABLE membership_plans (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  price_per_month DECIMAL(10,2) NOT NULL,
  duration_days   INT NOT NULL DEFAULT 30,
  benefits        TEXT[] NOT NULL DEFAULT '{}',
  sessions_total  INT,          -- NULL = unlimited
  advance_required DECIMAL(10,2),
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_membership_plans_vendor ON membership_plans(vendor_id);
```

### 4. New table: `customer_memberships`

```sql
CREATE TABLE customer_memberships (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  link_id         UUID NOT NULL REFERENCES links(id) ON DELETE CASCADE,
  plan_id         UUID NOT NULL REFERENCES membership_plans(id),
  plan_name       TEXT NOT NULL,  -- snapshot at enroll time
  enrolled_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at      TIMESTAMPTZ NOT NULL,
  sessions_total  INT,
  sessions_used   INT NOT NULL DEFAULT 0,
  status          TEXT NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','paused','expired','cancelled')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_customer_memberships_link   ON customer_memberships(link_id);
CREATE INDEX idx_customer_memberships_plan   ON customer_memberships(plan_id);
CREATE INDEX idx_customer_memberships_status ON customer_memberships(status);
```

### 5. New table: `vendor_services`

```sql
CREATE TABLE vendor_services (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  emoji        TEXT,
  duration_min INT NOT NULL DEFAULT 30,
  price        DECIMAL(10,2) NOT NULL,
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order   INT NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vendor_services_vendor ON vendor_services(vendor_id);
```

### 6. `bookings` table — add service reference + job stage

```sql
ALTER TABLE bookings
  ADD COLUMN service_id   UUID REFERENCES vendor_services(id) ON DELETE SET NULL,
  ADD COLUMN service_name TEXT,       -- snapshot at booking time
  ADD COLUMN job_stage    TEXT        -- NULL for time-slot bookings
                          CHECK (job_stage IN (
                            NULL,'intake','cutting','stitching','ready',
                            'in_progress','testing','delivered'
                          ));
```

### 7. New table: `orders`

```sql
CREATE TABLE orders (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  link_id        UUID NOT NULL REFERENCES links(id) ON DELETE CASCADE,
  vendor_id      UUID NOT NULL REFERENCES users(id),
  customer_id    UUID NOT NULL REFERENCES users(id),
  status         TEXT NOT NULL DEFAULT 'pending'
                 CHECK (status IN ('pending','confirmed','rejected','delivered','cancelled')),
  note           TEXT,
  delivered_by   UUID REFERENCES users(id),
  delivered_at   TIMESTAMPTZ,
  ledger_entry_id UUID REFERENCES ledger_entries(id), -- set when delivered
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id  UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  name      TEXT NOT NULL,
  qty       TEXT,           -- stored as string e.g. "2 kg", "5L", "1 bag"
  note      TEXT,
  sort_order INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_orders_link     ON orders(link_id);
CREATE INDEX idx_orders_vendor   ON orders(vendor_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status   ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```

---

## New API Endpoints

### Feature 1 — Multi-item ledger entries

**No new route.** Existing `POST /api/v1/ledger/entry` is called N+1 times:
1. First call: parent entry (`isParent=true`, `amount=total`, no `parentEntryId`)
2. N calls: child entries (`parentEntryId=<parent.id>`, individual amounts)

The frontend fires these sequentially. The backend may optionally expose a batch endpoint later.

**Change to existing `GET /api/v1/ledger/:linkId`:**
```typescript
// Response shape change — parent entries now include children array
interface LedgerEntry {
  // existing fields...
  parentEntryId?: string
  isParent: boolean
  childCount: number
  children?: LedgerEntry[]   // populated only for parent entries
}
```

---

### Feature 2 — Per-customer default quantity

#### PATCH `/api/v1/links/:linkId/defaults`
**Auth:** Vendor token only (must own the link)

**Request body:**
```json
{
  "defaultProduct": "Full Cream Milk",
  "defaultUnit": "L",
  "defaultQty": 2.0,
  "defaultPricePerUnit": 60.0
}
```

**Response:**
```json
{
  "linkId": "uuid",
  "defaultProduct": "Full Cream Milk",
  "defaultUnit": "L",
  "defaultQty": 2.0,
  "defaultPricePerUnit": 60.0
}
```

**Also:** `GET /api/v1/links/customers` response already returns `CustomerLinkItem` — add the 4 new fields to the response DTO.

---

### Feature 4 — Membership plans

#### GET `/api/v1/membership/plans`
**Auth:** Vendor token  
Returns vendor's own plans (all, including inactive).

**Response:**
```json
[{
  "id": "uuid",
  "name": "Gold Membership",
  "pricePerMonth": 999,
  "durationDays": 30,
  "benefits": ["4 Haircuts included", "10% off extra services"],
  "sessionsTotal": 4,
  "advanceRequired": 200,
  "isActive": true,
  "enrolledCount": 3
}]
```

#### POST `/api/v1/membership/plans`
**Auth:** Vendor token

**Request body:**
```json
{
  "name": "Gold Membership",
  "pricePerMonth": 999,
  "durationDays": 30,
  "benefits": ["4 Haircuts included", "10% off"],
  "sessionsTotal": 4,
  "advanceRequired": 200
}
```

#### PATCH `/api/v1/membership/plans/:planId`
**Auth:** Vendor token (must own the plan)  
Partial update. Same body shape as POST.

#### DELETE `/api/v1/membership/plans/:planId`
**Auth:** Vendor token  
Sets `is_active=false`. Does not delete rows (existing enrollments reference it).

---

#### GET `/api/v1/membership/customers`
**Auth:** Vendor token  
Returns all active customer memberships for this vendor.

**Response:**
```json
[{
  "id": "uuid",
  "linkId": "uuid",
  "customerName": "Sharma Ji",
  "planId": "uuid",
  "planName": "Gold Membership",
  "enrolledAt": "2026-06-01T00:00:00Z",
  "expiresAt": "2026-06-30T23:59:59Z",
  "sessionsTotal": 4,
  "sessionsUsed": 3,
  "status": "active"
}]
```

#### PATCH `/api/v1/membership/customers/:membershipId`
**Auth:** Vendor token  
Vendor can adjust sessions, pause, or cancel.

**Request body:**
```json
{
  "status": "paused",          // optional
  "sessionsUsed": 2,           // optional — direct override
  "expiresAt": "2026-07-30"    // optional — extend
}
```

---

#### GET `/api/v1/membership/my`
**Auth:** Customer token  
Returns customer's own memberships (all vendors).

**Response:**
```json
[{
  "id": "uuid",
  "linkId": "uuid",
  "vendorName": "Raju Salon",
  "planId": "uuid",
  "planName": "Gold Membership",
  "pricePerMonth": 999,
  "benefits": ["4 Haircuts included", "10% off"],
  "enrolledAt": "2026-06-01T00:00:00Z",
  "expiresAt": "2026-06-30T23:59:59Z",
  "sessionsTotal": 4,
  "sessionsUsed": 3,
  "status": "active"
}]
```

#### GET `/api/v1/membership/plans/public/:vendorId`
**Auth:** Customer token  
Returns a vendor's **active** plans (for the browse screen).

#### POST `/api/v1/membership/enroll`
**Auth:** Customer token

**Request body:**
```json
{
  "linkId": "uuid",
  "planId": "uuid"
}
```

**Response:** Created `customer_membership` object.

**Side effect:** Backend emits `membership:updated` WebSocket event on the link's room.

---

### Feature 5 — Monthly Settlement

**No new endpoint.** The settlement screen filters existing `GET /api/v1/ledger/:linkId` data by month on the client side. The PDF endpoint already exists via `LedgerStatementService`.

---

### Feature 6 — Orders

#### POST `/api/v1/orders`
**Auth:** Customer token

**Request body:**
```json
{
  "linkId": "uuid",
  "items": [
    { "name": "Atta", "qty": "10 kg", "note": "Aashirvaad brand" },
    { "name": "Toor Dal", "qty": "2 kg" }
  ],
  "note": "Please deliver before 7pm"
}
```

**Response:** Created order object with all items.

**Side effect:** Push notification to vendor. WebSocket `order:new` event.

---

#### GET `/api/v1/orders/vendor`
**Auth:** Vendor token  
Query params: `status=pending|confirmed|all` (default=all), `page`, `limit`

**Response:**
```json
{
  "orders": [{
    "id": "uuid",
    "linkId": "uuid",
    "customerName": "Sharma Ji",
    "status": "pending",
    "items": [
      { "name": "Atta", "qty": "10 kg" },
      { "name": "Toor Dal", "qty": "2 kg" }
    ],
    "note": null,
    "createdAt": "2026-06-28T11:23:00Z"
  }],
  "total": 5,
  "pending": 3
}
```

#### GET `/api/v1/orders/customer`
**Auth:** Customer token  
Returns customer's own orders (all vendors). Same shape.

#### GET `/api/v1/orders/staff`
**Auth:** Staff token  
Returns confirmed (not yet delivered) orders visible to this staff member (vendor's customers).

#### PATCH `/api/v1/orders/:orderId/status`
**Auth:** Vendor token OR Staff token

**Request body:**
```json
{
  "status": "confirmed"   // vendor action
}
```
or
```json
{
  "status": "delivered"   // staff or vendor action
}
```

**On `delivered`:**
1. Set `delivered_by = requesterId`, `delivered_at = NOW()`
2. Auto-create a `LedgerEntry` of type `credit` for the order:
   - `description = "Order — N items"`
   - `amount = 0` (no prices on order items yet — vendor prices separately)
   - OR if the vendor has set prices on items, compute total
3. Set `orders.ledger_entry_id` to the new entry's id
4. Emit `order:status_changed` WebSocket event
5. Send push notification to customer and vendor

---

### Feature 7 — Services

#### GET `/api/v1/services`
**Auth:** Vendor token  
Returns vendor's services (active + inactive).

**Response:**
```json
[{
  "id": "uuid",
  "name": "Haircut",
  "emoji": "✂️",
  "durationMin": 30,
  "price": 150,
  "isActive": true,
  "sortOrder": 0
}]
```

#### GET `/api/v1/services/public/:vendorId`
**Auth:** Customer token  
Returns only active services for a vendor (for booking screen).

#### POST `/api/v1/services`
**Auth:** Vendor token

**Request body:**
```json
{
  "name": "Head Massage",
  "emoji": "💆",
  "durationMin": 45,
  "price": 200
}
```

#### PATCH `/api/v1/services/:serviceId`
**Auth:** Vendor token (must own service)  
Partial update. Same body.

#### DELETE `/api/v1/services/:serviceId`
**Auth:** Vendor token  
Sets `is_active=false`.

---

## Existing Endpoint Changes

### `GET /api/v1/links/customers`
Add to each `CustomerLinkItem` in response:
```json
{
  "defaultProduct": "Full Cream Milk",
  "defaultUnit": "L",
  "defaultQty": 2.0,
  "defaultPricePerUnit": 60.0
}
```

### `GET /api/v1/ledger/:linkId`
Change response shape for parent entries (see Feature 1 above).

### `POST /api/v1/bookings`
Accept optional `serviceId` field. If provided, snapshot `service_name` from the service record.

### `PATCH /api/v1/bookings/:id/status`
Accept new job stage values: `intake`, `cutting`, `stitching`, `ready`, `in_progress`, `testing`.
On stage change, emit `booking:stage_changed` WebSocket event and queue a push notification to the customer.

---

## WebSocket Events (additions)

| Event | Room | Payload | Consumers |
|-------|------|---------|-----------|
| `order:new` | `vendor:{vendorId}` | `{ orderId, customerName, itemCount }` | Vendor |
| `order:status_changed` | `link:{linkId}` | `{ orderId, status, by }` | All on link |
| `membership:plan_updated` | `vendor:{vendorId}` | `{ planId }` | Vendor |
| `booking:stage_changed` | `link:{linkId}` | `{ bookingId, jobStage }` | Customer |

---

## Authentication Notes

- All new vendor-only endpoints check `req.user.role === 'vendor'`
- Staff endpoints check `req.user.role === 'staff'` and that the requested link's vendor matches the staff's `vendorId`
- Customer endpoints check `req.user.role === 'customer'`
- OTP is still dummy `123456` in dev

---

## Migration Files Needed

```
migrations/
  YYYYMMDD_001_add_parent_entry_id_to_ledger_entries.sql
  YYYYMMDD_002_add_defaults_to_links.sql
  YYYYMMDD_003_create_membership_plans.sql
  YYYYMMDD_004_create_customer_memberships.sql
  YYYYMMDD_005_create_vendor_services.sql
  YYYYMMDD_006_add_service_and_job_stage_to_bookings.sql
  YYYYMMDD_007_create_orders_and_order_items.sql
```
