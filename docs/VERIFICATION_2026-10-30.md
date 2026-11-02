## Verification run — 2026-10-30 (accounts · endpoint trace · deletion)

Everything below was executed against the **local dev backend** (`:3001`, `OTP_PROVIDER=dummy`, disposable DB `saath_khata`) with the real Flutter app on a Pixel_10 emulator. No production data was created or deleted.

### 1. Accounts created through the public API only

| # | Account | How | Result |
|---|---|---|---|
| A1 | `9222200011` vendor "Newgen Traders" | OTP send → verify (`existingUser:false`) → `POST /auth/signup` | `201` |
| A2 | `9222200012` customer "Kavya Nair" | same flow | `201` |
| A3 | `9222200013` customer "Imran Sheikh" | same flow | `201` |
| A4 | `newgen.desk@example.test` vendor (no phone) | `POST /auth/email-signup` | `201` |
| A5 | staff `9222200014` "Suresh Patil" | vendor `POST /staff` → `PATCH /staff/:id/access {canLogin:true}` (account auto-provisioned, `hasAppAccount:true`) | `201` / `200` |
| A6 | link vendor ↔ customer | `POST /link-requests/vendor-send` → customer `PATCH …/accept` | `201` / `200`, shared `linkId` |
| A7 | obligation | vendor `POST /links/:id/entries {amount:300, type:credit}` → customer confirms | `201`, balance `0 → 300` |

Note: a staff member needs **no** signup — granting app access provisions the `users` row, so `POST /auth/signup` correctly rejects role `staff` (`422 "Role must be vendor or customer"`).

### 2. Endpoint trace (frontend catalogue → backend)

Script probed all 124 paths declared in `lib/core/network/api_endpoints.dart` with no token, using each route's real method:

```
401 → 115 routes (mounted, auth required)
422 →   6 routes (mounted, public + validation)
200 →   3 routes (/content/terms, /content/privacy, /auth/logout)
404 ROUTE_NOT_FOUND → 0
```
Verdict: **no drift** — every endpoint the app calls exists on the backend.

First attempt returned `429` for all 124 because the global limiter (200 req/15 min) had already been tripped by the earlier test scripts; the limiter runs *before* routing, so those results were discarded and the trace was re-run against a freshly started server.

### 3. Deletion + pruning evidence

| Scenario | Expected | Observed |
|---|---|---|
| Customer with an outstanding balance | blocked | `409 DELETE_ACCOUNT_BLOCKED`, blocker `OUTSTANDING_BALANCE`; **no column changed** |
| …after recording a payment for the exact balance | deleted | `200`, `is_active=false`, `mobile=NULL`, `links_active 1→0`, **ledger + payment rows kept** |
| Customer with no obligations | deleted | `200`, same pruning, `refresh_tokens` revoked (`is_revoked=1`), no orphan rows |
| Email-only vendor, wrong password | rejected | `400 INVALID_CREDENTIALS`, account untouched |
| Email-only vendor, correct password | deleted | `200`, `email=NULL`; the same email re-signs up immediately (`201`) |
| Vendor with an active staff member | blocked | `409`, blocker `ACTIVE_STAFF` |
| …after `DELETE /staff/:id` (deactivate) | deleted | `200`; `staff_members` row **kept** with `can_login=false` |
| Staff user deletes own account after the vendor was deleted | should work | **`401 "App access has been revoked"`** — gap, see `APP_FLOW_MAP.md` §7 |
| Deleted phone tries to log in again | identifier freed | `existingUser:false` + fresh `signupToken` |
| Old access token after deletion | rejected | `401 "Account is no longer active"` |
| Old refresh token after deletion | rejected | `401` |
| FK integrity after all deletions | no orphans | `ledger_orphans=0`, `link_orphans=0`, `staff_orphans=0` |

Snapshots (psql, before → after) for the customer with history:
```
before  {is_active:true,  mobile:"9222200012", links_active:1, links_total:1, ledger_rows:1, payment_rows:0, refresh_tokens:1, refresh_revoked:0}
blocked {is_active:true,  mobile:"9222200012", links_active:1, links_total:1, ledger_rows:1, payment_rows:0, refresh_tokens:1, refresh_revoked:0}  ← unchanged
after   {is_active:false, mobile:null,         links_active:0, links_total:1, ledger_rows:2, payment_rows:1, refresh_tokens:1, refresh_revoked:1}
```

### 4. Defect fixed as a direct result

`GET /links/null/entries` (and any blank/stale/`null` link id) returned `500 INTERNAL_ERROR` from Postgres `22P02`. Now guarded by `validateLinkId` → `404 NOT_FOUND`, deployed as `de9b0ee`. Verified: `null`, blank, and unknown UUIDs all return `404`, while `/links/customers` still returns `200`.

### 5. Not covered here

- Real-SMS login on a controlled handset (one send to `9650263185` succeeded through UDO; the code was never entered).
- Production data — untouched. `93` tables/rows in the dev DB only.
