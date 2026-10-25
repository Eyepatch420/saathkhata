# Auth & OTP Integration Plan — Real UDO OTP for Customer / Vendor / Staff

**Document:** `saath_khata/docs/AUTH_OTP_INTEGRATION_PLAN.md` (full rewrite, v2)
**Repositories:** `saath_khata` (Flutter) and `saath_khata_backend` (Node/Express/Knex/PostgreSQL)
**Scope of this document:** replace the stubbed dummy OTP with server-side UDO OTP verification, and close the security/reliability defects that block a safe release.
**Status:** implementation-ready plan. No application code, migration, secret or production configuration was changed while producing it.

> **Implementation status (2026-10-25):** this plan has been implemented — see
> `docs/AUTH_OTP_IMPLEMENTATION_REPORT.md` for the actual code changes, test
> results, database evidence, blockers and the deployment/rollback runbook.
> Where the implementation deliberately differs from this document (for example
> the extra `otp_sessions.context` column and the legacy account-deletion
> payload), the report calls it out.

### How to read the evidence in this document

| Marker | Meaning |
|---|---|
| **[V]** | **Verified by reading the cited source** in this session. Line numbers refer to the file as it exists now. |
| **[R]** | **Requires runtime verification** (needs a running environment, a VPS shell, or a real provider call). |
| **[D]** | **Product / business decision required.** |
| **[A]** | **Assumption** made explicit so it can be challenged. |

Estimates are labelled "est." and are engineering guesses, not commitments.

---

## 1. Executive summary

**The phone-OTP flow already exists end-to-end and is wired into the app; only the provider call is missing.** `POST /auth/otp/send` hashes the literal string `123456`, stores it, and returns the code in the response body **[V]** (`otp.service.ts:15,32,47`). No SMS library or HTTP client for a messaging provider exists anywhere in `saath_khata_backend/src` **[V]** (the only SMS client in either repository is the Flutter `UdoOtpService`, which is unused by the auth flow).

The job is therefore **not** "build OTP". It is:

1. put a real, bounded, testable UDO adapter behind the existing two endpoints;
2. make the challenge lifecycle ACID-safe and purpose-scoped (today it is neither);
3. enforce cost-bearing rate limits on the server (today the successful-send path has no per-phone or per-IP cap);
4. keep the response contract backwards compatible so **the current app keeps working without a store release**;
5. stop shipping the UDO key inside the Flutter bundle;
6. fix three confirmed defects that become *total* outages for users once every account is phone-based — the account-deletion OTP route does not exist, a wrong OTP returns HTTP 401 (which the app interprets as "session expired"), and a wrong current password also returns 401.

**Single most important correction to the previous version of this plan:** a wrong OTP currently returns **401** (`otp.service.ts:78`), and the app's Dio interceptor treats *every* 401 as "access token expired", calls `/auth/refresh`, and on failure clears the session and force-redirects the router (`api_client.dart:48-90`). Wrong-OTP is therefore not merely a friendly error — it wipes local state and bounces the user out of the flow. Real OTP makes three wrong guesses the *normal* path, so this must be fixed **before** the provider goes live, by returning **400 `OTP_INVALID`** for a wrong code (401 reserved for missing/invalid session tokens).

**Recommended shape (unchanged from the architecture that already exists):**

```
Flutter UI → AuthBloc → AuthRepository → POST /auth/otp/{send,verify}
      → OtpService → OtpProvider (interface) → UdoOtpProvider | DummyOtpProvider
      → otp_sessions (PostgreSQL, purpose-scoped state machine)
      → AuthService/session issuance (unchanged JWT + refresh_tokens design)
```

The UDO API key exists **only** in backend runtime configuration. The app never talks to UDO in production.

**Effort (est.):** 6–9 working days across P0–P5 for a production-safe release; P6–P7 (Flutter hygiene + unrelated auth-integrity fixes) add 3–4 days and are separable.

**What can ship without a mobile release:** the whole provider swap, challenge state machine, rate limits, error codes, signup single-use, and the account-deletion fix — because the app already calls `POST /auth/account/delete-otp` and already sends `{otp}` on `DELETE /auth/account` **[V]** (`auth_repository_impl.dart:152-159,161-177`). That is a matched pair of requests waiting for a backend implementation.

---

## 2. Verified current architecture

### 2.1 Backend stack and boot sequence [V]

| Fact | Evidence |
|---|---|
| Express 4 + TypeScript, Knex + PostgreSQL, Zod validation, winston, BullMQ + Redis, socket.io | `package.json:22-41` |
| Boot: `validateEnv()` → DB check → Redis check (non-fatal) → queues → workers **only if `WORKERS_ENABLED=true`** → HTTP+WS listen | `server.ts:20-59` |
| Env validation: JWT secrets always; DB/Redis/CORS/Cloudinary required when `NODE_ENV=production` | `env.ts:6-27,29-46` |
| Body limit 1 MB; `trust proxy = 1`; helmet; CORS from `CORS_ORIGIN` | `app.ts:34-49` |
| Global limiter 200 req / 15 min (in-process store) | `app.ts:55-63` |
| Auth limiter 20 / 15 min with **`skipSuccessfulRequests: true`** (disabled under `NODE_ENV=test`) | `app.ts:68-85` |
| Error envelope `{success:false,message,error,blockers?}` | `errorHandler.ts:13-24`, `response.ts:4-22` |
| DB pool 2–20, `statement_timeout` 30 s, `acquireConnectionTimeout` 10 s | `connection.ts:18-27` |
| Redis is optional at boot; failures only log a warning | `redis/client.ts:25-36` |
| Repeat jobs: token cleanup every 6 h, deliveries daily 00:30 IST | `jobs/queues/index.ts:76-102` |

### 2.2 Auth surface [V]

| Method | Path | Auth | Behaviour today |
|---|---|---|---|
| POST | `/auth/otp/send` | public | Deletes prior session for the phone, inserts hash of `123456`, returns `{otp:"123456"}` |
| POST | `/auth/otp/verify` | public | Existing active user → `{existingUser:true,user,tokens}`; else `{existingUser:false,signupToken}` (10-min JWT) |
| POST | `/auth/signup` | public | `signupToken` → creates user + role profile in one transaction |
| POST | `/auth/email-signup` | public | Email+password account with `mobile = NULL` |
| POST | `/auth/email-login` | public | `(email, role)` + password; staff excluded |
| POST | `/auth/refresh` | public | Rotates a refresh token (non-atomic — see G13) |
| POST | `/auth/logout`, `/auth/logout-all` | mixed | Revokes one / all refresh tokens |
| GET/PATCH | `/auth/me`, `/auth/profile`, `/auth/change-password` | Bearer | Profile + password |
| DELETE | `/auth/account` | Bearer | Soft delete; **request body is never read** |

Routes: `auth.routes.ts:37,45,55,65,75,83,89,93,95,97,111,121`. There is **no** `/auth/login` and **no** `/auth/account/delete-otp` (both are still called by code/tests that exist — see G9 and G14).

### 2.3 Roles and RBAC [V]

- Roles are `vendor`, `customer`, `staff`. **There is no `delivery` role**; delivery personnel are `staff_members` rows with `users.role='staff'`.
- `users.role` CHECK allows only `('vendor','customer')` as created in `20260001_create_users.ts:26`; the `staff` value therefore depends on a later schema change — **must be confirmed against the live schema** before writing migration 20260041 [R].
- Staff login: vendor grants access (`staff.service.ts:396-426`) → creates a `role='staff'` user bound to the staff phone; one phone = one account (`staff.service.ts:401`). Revoke flips `can_login=false` and revokes that user's sessions (`staff.service.ts:376-387`).
- On every request `authenticate` re-checks `staff_members.can_login && is_active` for staff and `users.is_active` for everyone else (`authenticate.ts:43-56`) → revocation is immediate, not access-token-TTL bound.
- `effectiveVendorId()` maps a staff token to the owner vendor id carried in the JWT (`effectiveVendor.ts:15-28`); `authorize()` gates by role (`authorize.ts:10-27`).

### 2.4 OTP internals as they exist today [V]

`otp.service.ts`:
- `DUMMY_OTP='123456'` (:15), TTL 5 min (:16), `MAX_ATTEMPTS=3` (:17), signup-token TTL 10 min (:18).
- `sendOtp` (:30-48): `delete` any session for the phone (:36) then `insert` (:38-44) — **no transaction**, no cooldown; logs the phone (:46); returns the code (:47).
- `verifyOtp` (:56-106): selects the newest unverified unexpired row (:59-63); rejects attempts ≥ 3 (:69-71); compares SHA-256 (:73-79); on mismatch `increment` then throw (:75-78) — the increment is autocommitted so it *is* durable, but the read→compare→increment window is raceable; on success sets `verified=true` (:82) **before** resolving the user (:85-87), so any later failure burns the challenge.
- New user → `jwt.sign({phone, type:'signup'}, JWT_ACCESS_SECRET, 10m)` (:97-102); `decodeSignupToken` only checks `type==='signup'` (:112-121) → replayable for 10 minutes.
- `OtpService` duplicates `_buildAuthResponse` (:123-210) from `AuthService._buildAuthResponse` (`auth.service.ts:586-633`).

---
### 2.5 Flutter auth architecture [V]

| Layer | Fact | Evidence |
|---|---|---|
| Endpoints | `sendOtp`, `verifyOtp`, `deleteAccountOtp` constants; base URL is the Android emulator host | `api_endpoints.dart:2,5-6,20-21` |
| Client | Dio, 15 s connect/receive, Bearer injection, **single-flight refresh on 401**, error message read from `body['message']` only | `api_client.dart:22-27,48-118,171-183` |
| Logging | bodies redacted for password/refresh/access/Authorization — **`otp` is not in the redaction set**; output suppressed in release | `api_client.dart:9,239-251`, `app_logger.dart:32-37` |
| BLoC states | `AuthLoading / AuthAuthenticated / AuthUnauthenticated / AuthError / AuthOtpSent / AuthOtpVerifiedNewUser` | `auth_state.dart:11-56` |
| OTP send | dispatch `AuthOtpSendRequested`; on `AuthOtpSent` push the OTP screen | `phone_entry_screen.dart:33-41,52-61` |
| OTP verify | 6 single-digit boxes; on `AuthError` toast **and clear all boxes**; role mismatch rejected except `staff` logging in via the vendor card | `otp_verify_screen.dart:25-29,136-150`, `auth_bloc.dart:173-207` |
| Resend | always enabled, no countdown, **success toast shown before the request completes** | `otp_verify_screen.dart:62-70,227-248` |
| Router | public-routes set; authenticated users redirected to `/vendor`, `/customer` or `/staff-home` by role | `app_router.dart:151-190` |
| Storage | tokens + profile in `flutter_secure_storage`; locale in Hive | `storage_service.dart:58-73,189` |
| Provider key in bundle | `.env` is a declared Flutter **asset** and is loaded in `main()` | `pubspec.yaml:88`, `main.dart:25` |
| Dead client | `UdoOtpConfig` + `UdoOtpService` exist but **nothing in the auth path references them** (grep of `lib/` returns only those two files + `main.dart`) | `udo_otp_config.dart:13-58`, `udo_otp_service.dart:30-187` |
| Role selection | only Vendor + Customer cards; if both are selected the flow silently continues as **vendor** | `role_selection_screen.dart:21-26,52-71` |

### 2.6 Tests that exist today [V]

| Suite | State |
|---|---|
| `src/__tests__/auth.test.ts` | **Stale**: posts email+password to `/auth/signup` (:19-51) and calls `/auth/login` (:56-105) — neither matches the current routes or schemas. |
| `src/__tests__/delete-account.test.ts` | Covers soft-delete + blockers through the real app; **no** OTP-confirmation coverage. |
| `src/__tests__/helpers.ts` | `truncateAll()` list (:10-24) **omits `otp_sessions`**. |
| Flutter `test/` | `udo_otp_config_test.dart`, `udo_otp_service_test.dart`, `auth_bloc_delete_account_test.dart`, `settings_screen_delete_account_test.dart`, `widget_test.dart`. No coverage of the OTP screens or `AuthRepositoryImpl`. |
| Executed during this review | `npx tsc --noEmit` in the backend → **exit 0** (backend typechecks). Nothing else was executed; the vitest suites were **not** run because `setup.ts`/`helpers.ts` truncate the configured database. |

---

## 3. Current-state findings with source references

Severity: 🔴 release-blocking for real OTP · 🟠 high · 🟡 medium.

| # | Sev | Finding | Evidence | Phase |
|---|---|---|---|---|
| G1 | 🔴 | OTP is a fixed `123456`; no SMS is sent by the backend | `otp.service.ts:15,32,47` | P1 |
| G2 | 🔴 | The OTP is returned in the HTTP response body | `otp.controller.ts:16-17` | P1 |
| G3 | 🔴 | **Wrong OTP returns 401**, which the app turns into "refresh → clear session → redirect" | `otp.service.ts:78`, `api_client.dart:48-90` | P1 |
| G4 | 🔴 | No per-phone cooldown/cap; the auth limiter deliberately ignores successful requests, so successful OTP sends are effectively unlimited (only the 200/15 min global cap applies) | `app.ts:68-85` | P1 |
| G5 | 🟠 | `sendOtp` is delete-then-insert with no transaction → concurrent sends can leave two active rows | `otp.service.ts:36-44` | P1 |
| G6 | 🟠 | Attempt cap is raceable (read → compare → increment); no row lock, no conditional update | `otp.service.ts:69-79` | P1 |
| G7 | 🟠 | Challenge has **no purpose**, so any future OTP purpose would share one namespace with login | `20260021_otp_auth.ts:20-29` | P1 |
| G8 | 🟠 | `otp_sessions` is never cleaned; retention is unbounded and phone numbers are kept forever | only refs are `otp.service.ts` + the migration | P1 |
| G9 | 🔴 | **Account deletion is dead-ended for every phone account**: the app calls `POST /auth/account/delete-otp` (404) and `DeleteAccountFlow` aborts on that error before showing the confirm dialog; for phone-less accounts `DELETE /auth/account` executes on the JWT alone, ignoring the typed confirmation | `api_endpoints.dart:21`, `auth_repository_impl.dart:152-159,161-177`, `delete_account_flow.dart:31-46,159-183`, `auth.routes.ts:121`, `auth.controller.ts:156-164` | P3 |
| G10 | 🟡 | OTP-only users are asked for a "current password" they never had; it *works* only because the service skips the compare when `password_hash` is null and the validator merely requires a non-empty string | `auth.validators.ts:131-137`, `auth.service.ts:474-478`, `change_password_screen.dart:99-101` | P4 |
| G11 | 🟠 | `mobile` can be changed with no proof of ownership; no uniqueness pre-check in the service, so a collision surfaces as a 500 | `auth.service.ts:186`, `auth.validators.ts:74-77`, `edit_profile_screen.dart:181-183` | P3 |
| G12 | 🟠 | Signup token is replayable for 10 min (no single-use record, no binding to a challenge id) | `otp.service.ts:97-121` | P3 |
| G13 | 🟠 | Refresh rotation is non-atomic (`findActive` → `revoke` → mint) → two concurrent refreshes can both mint a valid pair | `auth.repository.ts:170-181`, `auth.service.ts:126-145` | P7 |
| G14 | 🟡 | Signup does the email conflict check outside the transaction while the DB constraint is `(email, role)` → the race surfaces as 500 instead of 409 | `auth.service.ts:48-53`, `20260017_dual_accounts_and_search.ts:32-36` | P3 |
| G15 | 🟡 | Stale backend auth tests + `otp_sessions` missing from `truncateAll()` | `auth.test.ts:19-105`, `helpers.ts:10-24` | P1 |
| G16 | 🟡 | Staff must guess the "Vendor" card to log in | `auth_bloc.dart:178-187`, `role_selection_screen.dart:52-71` | P6 |
| G17 | 🟠 | Provider API key is compiled into the app bundle (`.env` is an asset) | `pubspec.yaml:88`, `main.dart:25` | P6 |
| G18 | 🔴 | Deploy injects only 4 secrets, auto-runs migrations **and seeds** on every `main` push; seeds rewrite/delete production rows for 9 hard-coded phones | `deploy.yml:29-60`, `seeds/01_test_accounts.ts:26-30,44-88,470` | P0 |
| G19 | 🟡 | `email-signup` creates phone-less accounts that can never use OTP (parallel identity) | `auth.service.ts:488-565` | P4 |
| G20 | 🟠 | No provider timeout/circuit-breaker; a UDO outage would hang login | no client today | P2 |
| G21 | 🟡 | Wrong **current password** also returns 401 → same spurious refresh/force-logout path as G3 | `auth.service.ts:476`, `api_client.dart:48-90` | P4 |
| G22 | 🟡 | OTP/phone PII is logged in plaintext (`phone` in OTP logs; `otp` not redacted in dev client logs) | `otp.service.ts:46,104,108`, `api_client.dart:9` | P2 |
| G23 | 🟡 | Success-response construction is duplicated (`OtpService._buildAuthResponse` vs `AuthService._buildAuthResponse`) → drift risk | `otp.service.ts:123-210`, `auth.service.ts:586-633` | P2 |

### 3.1 Deployment facts that constrain the order of work [V]

`.github/workflows/deploy.yml` runs on every push to `main`:

1. `sed`-deletes then re-appends `CLOUDINARY_*` and `GEMINI_API_KEY` into `.env` on the VPS (`:29-37`);
2. `git pull` → `npm install` → `npm run build` (`:40-46`);
3. `NODE_ENV=development npm run migrate:latest` (`:49`) — note this means migrations run with the **development** knex block, not the `production` block (`knexfile.ts:7-26` vs `:28-43`);
4. `NODE_ENV=development npm run seed` (`:52`) — runs seeds in production on every deploy;
5. `pm2 restart saath-khata-backend --update-env` (`:55`);
6. health check; **any boot failure fails the deploy** (`:58-60`).

Consequences the plan must respect:

- A new env var that is *required at boot* breaks the deploy unless the secret is already injected → **secrets first, code second** (§20).
- `seed` is not harmless in production: `seeds/01_test_accounts.ts` deletes `orders`, `bookings`, `payment_transactions`, `ledger_entries`, `scheduled_deliveries`, `service_subscriptions` rows belonging to nine hard-coded phone numbers (`:44-88`) and prints "OTP for all: 123456" (`:470`). If any real customer ever uses those numbers, a deploy destroys their financial history. **P0 fixes this.**
- Number of pm2 instances is **not visible from the repository** → whether the in-process rate-limit store is per-instance is unknown [R].

---

## 4. Official UDO contract (verified against the live documentation)

Sources fetched in this session:
- `https://developers.uniquedigitaloutreach.com/generate-and-verify`
- `https://developers.uniquedigitaloutreach.com/errors`
- `https://developers.uniquedigitaloutreach.com/authentication`

### 4.1 Generate an OTP

```http
POST /v1/verify
apikey: <key>
Content-Type: application/json

{ "configId": "a73cd9xe-XXXX-XXXX-XXXX-7f731bcf4y64", "to": "91XXXXXXXXXX" }
```

```json
{ "data": "33888968-XXXX-XXXX-XXXX-3010e0069668", "error": null, "message": "OTP Generated Successfully!" }
```

- `data` **is the `verifyId`** required by the validate call.
- `configId` "decides template, channel and expiry" → **OTP length, channel and TTL are provider-side configuration**, not request parameters.
- `to` is an MSISDN with country code.

### 4.2 Validate an OTP

```http
POST /v1/verify/validate
apikey: <key>
Content-Type: application/json

{ "verifyId": "33888968-XXXX-XXXX-XXXX-3010e0069668", "otp": "XXXXXX" }
```

```json
{ "data": "33888968-XXXX-XXXX-XXXX-3010e0069668", "error": null, "message": "OTP Verified Successfully!" }
```

### 4.3 What the documentation does and does not promise

| Property | Documented? | Consequence for this design |
|---|---|---|
| Auth header name | **Yes** — `apikey`, found in the dashboard under API settings | Send exactly this header; no bearer prefix |
| Success envelope | **Yes** — `{data, error: null, message}` | Success requires `error === null` **and** a non-empty `data` |
| Failure envelope | **Yes** — `{ "error": true, "message": "Api Key not found" }` | Branch on status **and** `error`, never on status alone |
| Status codes | **Only 200, 400, 500** are documented | Treat undocumented 401/403/429 defensively (§12) |
| Error types | `error` (provider fault) / `invalid_request` (caller fault) | `invalid_request` → configuration alert, not a user error |
| Single-use | **Yes** — "the OTP is designed for single-use and expires after a specified timeframe" | Local challenge must also be single-use |
| Expiry / OTP length / template / channel | **No explicit values** — derived from `configId` | Our local TTL is a second independent bound; the shorter wins |
| Rate limits / provider-side attempt limits | **Not documented** | We enforce our own budget and assume the provider may also lock |
| Idempotency of `/v1/verify` | **Not documented** | **Never auto-retry a generate call** — a retry may send a second SMS |
| Does a failed validate invalidate the OTP? | **Not documented** | Treat the provider as possibly destructive: never loop on validate |
| `sender` / DLT header | Only on `POST /v1/sms`, **not** on `/v1/verify` | **`UDO_OTP_SENDER_ID` is not needed** for this integration |
| Delivery receipts | Separate webhook product, not part of generate/validate | Out of scope; no synchronous delivery proof |

Locally observed responses (recorded in the app repo's `docs/UDO_OTP_API.md:148-197`, produced by earlier manual probing — **not** official and **not** re-executed here **[R]**):
`400 {"error":true,"message":"Enter a valid apikey in header"}`, `"API Key is Invalid or Expired!"`, `"Invalid Config ID"`, `"invalid Verify ID"`, `"No Valid Numbers Found..!!"`, and `500` for provider faults.

### 4.4 Questions UDO must answer before production

1. The real **`configId`** for this account (blocking — no OTP can be generated without it).
2. The **TTL configured on that `configId`** (our local TTL must be ≤ it, or ours becomes effective — acceptable but must be known).
3. The **OTP length/format** on that `configId` (assumed 6 digits; the UI has 6 boxes).
4. Whether a **wrong validate consumes an attempt**, and how many attempts the provider allows.
5. Whether **re-sending** for the same MSISDN invalidates the previous `verifyId`.
6. Whether the account has **IP allowlisting** or concurrency caps a VPS caller could trip.
7. Whether `configId` already carries a **DLT-approved template/sender** (so `/v1/sms` is never needed).

---

## 5. Target architecture

### 5.1 Principle

**Phone number = identity. Email = an optional credential on that identity.** Every OTP challenge is server-owned, purpose-scoped, single-use, cooldown-protected and audited. The frontend is a convenience layer; **the backend is the only authority** on code correctness, attempt counts, cooldowns and identity.

### 5.2 Component diagram

```
Flutter: PhoneEntryScreen → AuthBloc → AuthRepositoryImpl → ApiClient
                                   │
                    POST /auth/otp/send   POST /auth/otp/verify
                                   │
Backend: OtpController → OtpService ──► OtpChallengeRepository (PostgreSQL: otp_sessions)
                             │                     ▲
                             ├─► OtpProvider (interface) ─► UdoOtpProvider (HTTPS, apikey)
                             │                            └► DummyOtpProvider (dev/test only)
                             ├─► RateLimitPolicy (per-phone via DB rows; per-IP via Redis/in-memory)
                             └─► AuthSessionIssuer → TokenService + refresh_tokens (unchanged)
```

**No new tables.** One additive migration extends `otp_sessions`. No new public endpoints except the two the app already calls for account deletion.

### 5.3 Explicit non-goals

- No new auth framework, no Passport, no session cookies, no change to JWT/refresh semantics in the first release.
- No migration of the `users` identity model.
- No delivery receipts, SMS templating service, or billing subsystem.
- No rewrite of `AuthBloc` or routing.

### 5.4 Preserved contracts (must not change in P1/P2)

`POST /auth/otp/send` keeps `{phone}` → `200 {success,message,data}`; `POST /auth/otp/verify` keeps `{phone,otp}` → `200 {existingUser,user,tokens}` or `{existingUser:false,signupToken}`. The app reads only `data.existingUser`, `data.user`, `data.tokens`, `data.signupToken`, and `message` on errors **[V]** (`auth_repository_impl.dart:17-40`, `api_client.dart:171-183`) — so **removing `data.otp` and adding fields is safe for already-installed versions**.

---

## 6. Provider adapter design

### 6.1 Files (new, backend only)

```
src/infrastructure/sms/
  otpProvider.types.ts     // OtpProvider interface + typed errors
  udoOtp.provider.ts       // fetch() implementation of the documented contract
  dummyOtp.provider.ts     // development/test only, hard-refuses in production
  otpProvider.factory.ts   // resolves provider from env, validates config, caches instance
```

Conventions: named classes with constructor injection like `OtpService`, `AppError` subclasses for typed failures (`shared/errors/AppError.ts:1-54`), `logger` from `shared/logger`, and the existing `src/infrastructure/*` folder style (`cloudinary/client.ts`).

### 6.2 Interface

```ts
export interface OtpProvider {
  readonly name: 'udo' | 'dummy';
  /** Sends a code. Throws OtpProviderError on any failure. Never retries. */
  generate(input: { msisdn: string }): Promise<{ providerRef: string }>;
  /** Validates a code. Resolves true/false; throws OtpProviderError on outage/config faults. */
  validate(input: { providerRef: string; code: string }): Promise<boolean>;
}
```

Return **`boolean` for "wrong code"** and throw a **typed error for "could not decide"**. This is the most important boundary in the design: an outage must never be reported as "wrong OTP", and a wrong OTP must never be retried.

### 6.3 Typed errors and mapping

| Provider outcome | Adapter error | HTTP to app | Code |
|---|---|---|---|
| Timeout / DNS / connection reset / TLS | `OtpProviderUnavailableError` | 503 | `OTP_PROVIDER_UNAVAILABLE` |
| 5xx | `OtpProviderUnavailableError` | 503 | `OTP_PROVIDER_UNAVAILABLE` |
| 400 `{error:true}` on **generate** | `OtpProviderConfigError` | 503 | `OTP_PROVIDER_MISCONFIGURED` |
| 400 on **validate**, `invalid Verify ID` | treated as wrong/expired code | 400 | `OTP_INVALID` |
| 200 `{error:null, data:<uuid>}` | success | — | — |
| 200 with `error:true` | mapped from `message` as above | as above | as above |
| Unparseable JSON / missing `data` | `OtpProviderProtocolError` | 503 | `OTP_PROVIDER_UNAVAILABLE` |
| 401/403 (undocumented) | `OtpProviderConfigError` | 503 | `OTP_PROVIDER_MISCONFIGURED` |
| 429 (undocumented) | `OtpProviderUnavailableError` | 503 | `OTP_PROVIDER_UNAVAILABLE` |

The adapter **never** forwards the provider `message` (it may disclose configuration details); it logs at `warn` and returns the stable code from §12.

### 6.4 Implementation rules

1. `fetch()` + `AbortController`; timeout from `OTP_REQUEST_TIMEOUT_MS` (default **5000**, below the 10 s acquire budget in `connection.ts:27`).
2. Exactly four checks, in order: `response.ok` → JSON parse → `body.error === null` → non-empty string `data`.
3. **No retries** — not on timeout, not on 5xx, not on reset.
4. Never log `apikey`, the OTP, the `verifyId`, or the full MSISDN (log `98******10`).
5. `Content-Type: application/json` and an explicit `User-Agent`.
6. `providerRef` is **never** returned to the client.
7. The adapter holds **no database transaction** — always called outside `db.transaction()` (§9).
8. `DummyOtpProvider` throws at construction when `NODE_ENV === 'production'` (§20.3).

### 6.5 MSISDN normalisation

- **Storage / uniqueness / rate-limit key:** 10 digits, `^[6-9][0-9]{9}$` — identical to `auth.validators.ts:5` and `users_mobile_unique` (`20260021_otp_auth.ts:48-52`).
- **Provider request:** `91` + the 10 digits → `919876543210`.
- **Reject, never coerce:** anything not reducible to exactly 10 digits starting `6-9` → `400 VALIDATION_ERROR`.

---

## 7. Challenge-state model

### 7.1 States (snake_case, matching the existing DB style)

| State | Meaning | Terminal? |
|---|---|---|
| `pending` | Row created, provider call not yet confirmed | no |
| `sent` | Provider accepted the request; `provider_ref` persisted | no |
| `consumed` | Code validated **and** consumed locally exactly once | yes |
| `failed` | Provider refused the request (outage, bad config) — no code exists | yes |
| `expired` | TTL passed without a successful consume | yes |
| `locked` | Attempt budget exhausted | yes |
| `superseded` | A newer challenge replaced it for the same `(phone, purpose)` | yes |

### 7.2 Legal transitions

```
                 ┌────────► failed            (provider error / timeout)
 pending ────────┤
                 ├────────► sent ────┬──────► consumed   (validate=true, single conditional update)
                 │                   ├──────► locked     (attempts exhausted)
                 │                   ├──────► expired    (ttl passed / cleanup)
                 │                   └──────► superseded (newer send for same purpose)
                 └────────► superseded         (replaced while the provider call was in flight)
```

Illegal states are prevented by construction:

| Attack / mistake | Prevention |
|---|---|
| Superseded challenge becomes active again | No transition out of a terminal state; every lookup filters `status IN ('pending','sent')` |
| Consume twice | `UPDATE … WHERE id=? AND status='sent' RETURNING id` → 0 rows means already consumed |
| Failed provider call reported as "sent" | `status='sent'` only in the update that also stores `provider_ref` |
| Cross-purpose reuse | `purpose` is part of uniqueness, lookup **and** behaviour; clients never supply a privileged purpose |
| Wrong provider implementation | `provider` stored per row; adapter must match the configured provider, else `409 OTP_PROVIDER_MISMATCH` (defensive) |
| Two active challenges per `(phone,purpose)` | Partial unique index (§8) + advisory lock (§9.1) |
| Stale request overwrites a newer challenge | Every write is `WHERE id = <own id>`; supersession is one-way |
| Tokens from an unconsumed challenge | Session row is created **only** inside the transaction that flips the row to `consumed` (§9.2) |

### 7.3 Purposes

| Purpose | Used by | Phone source | Available to |
|---|---|---|---|
| `login` | `/auth/otp/send` + `/auth/otp/verify` (the only purpose the current app requests) | request body | anyone |
| `account_delete` | `POST /auth/account/delete-otp` | **authenticated user row** (never the body) | authenticated user |
| `phone_change` | `POST /auth/phone/change-request` (P3) | **`newPhone` from the body**, authorized by the session | authenticated user |
| `email_setup` | deferred to P4 | authenticated user row | authenticated user |

**Rule:** for every purpose except `login`, the purpose is hard-coded in the route handler. `login` stays implicit (the existing `sendOtpSchema` remains `{phone}` — `auth.validators.ts:9-11` — so old and new clients behave identically).

### 7.4 Response per state at verify time

| State when verify arrives | Response |
|---|---|
| no row / `expired` / `failed` / `superseded` | `400 OTP_EXPIRED` ("Request a new code") |
| `locked` | `429 OTP_LOCKED` |
| `consumed` | `409 OTP_ALREADY_USED` |
| `pending` | `409 OTP_NOT_READY` (send still in flight) |
| `sent` | normal verification path |

### 7.5 Naming note

`status` is not a reserved word for column names in PostgreSQL and Knex emits it unquoted safely. No rename is needed.

---

## 8. Database schema and migration strategy

### 8.1 Migration `20260041_otp_challenge_state.ts` (additive)

`otp_sessions` today has only `id, phone, otp_hash, expires_at, verified, attempts, created_at` (`20260021_otp_auth.ts:20-29`) plus an index on `phone` (:28).

| Column | Type | Default | Purpose |
|---|---|---|---|
| `purpose` | `varchar(32) NOT NULL` | `'login'` | challenge namespace |
| `status` | `varchar(16) NOT NULL` | `'pending'` | state machine |
| `provider` | `varchar(16) NOT NULL` | `'dummy'` | audit + mismatch guard |
| `provider_ref` | `varchar(128) NULL` | — | UDO `verifyId` (never exposed) |
| `ip_hash` | `varchar(64) NULL` | — | forensics without raw IPs |
| `consumed_at` | `timestamptz NULL` | — | single-use proof |
| `signup_consumed_at` | `timestamptz NULL` | — | single-use signup token (§15) |
| `verify_lease_until` | `timestamptz NULL` | — | serialises verifies without holding a lock across the network (§9.2) |
| `otp_hash` | *drop* `NOT NULL` | — | NULL for provider-backed rows |

Kept for one release: `verified` (written as `verified = (status='consumed')`) so a **code rollback keeps working** against the migrated schema (§20.4).

```sql
ALTER TABLE otp_sessions ADD CONSTRAINT otp_sessions_status_check
  CHECK (status IN ('pending','sent','consumed','failed','expired','locked','superseded'));
ALTER TABLE otp_sessions ADD CONSTRAINT otp_sessions_purpose_check
  CHECK (purpose IN ('login','account_delete','phone_change','email_setup'));

CREATE UNIQUE INDEX otp_sessions_one_active_idx
  ON otp_sessions (phone, purpose) WHERE status IN ('pending','sent');
CREATE INDEX otp_sessions_phone_purpose_created_idx
  ON otp_sessions (phone, purpose, created_at DESC);
CREATE INDEX otp_sessions_expires_pending_idx
  ON otp_sessions (expires_at) WHERE status IN ('pending','sent');
```

### 8.2 Backfill (same migration, **before** creating the unique index)

```sql
UPDATE otp_sessions SET status = 'expired', provider = 'dummy' WHERE status = 'pending';
```

Required: pre-existing dummy rows can never be validated against UDO, and duplicate active rows would make the partial unique index fail.

### 8.3 Rollback (`down()`)

Drop the three indexes, the two CHECK constraints, then the columns; restore `otp_hash NOT NULL`. That restore **fails** while provider-backed rows with `otp_hash IS NULL` exist, so `down()` must first `DELETE FROM otp_sessions WHERE otp_hash IS NULL` — destructive, and documented in the migration header. **Preferred rollback is application-only** (§20.4). Never run `migrate:rollback` in production.

### 8.4 Pre-migration verification (blocking, [R])

1. Confirm `users.role` actually permits `'staff'` — the original CHECK does not (`20260001_create_users.ts:26`), so a later migration widened it; find and cite it before relying on it.
2. Confirm `users_mobile_unique` still exists and is still partial.
3. Record the `otp_sessions` row count (drives index-build time and whether a maintenance window is needed).

### 8.5 Cleanup (extend the existing worker — no new worker)

`tokenCleanup.processor.ts:10-20` is job-name-agnostic. Dispatch on `job.name` and add a second repeat job to the existing `token-cleanup` queue in `scheduleTokenCleanup()` (`jobs/queues/index.ts:76-86`).

| Job | Schedule | Statement |
|---|---|---|
| `cleanup-tokens` | every 6 h (existing) | unchanged |
| `cleanup-otp` | every 6 h, offset | `DELETE FROM otp_sessions WHERE id IN (SELECT id FROM otp_sessions WHERE status IN ('consumed','failed','expired','locked','superseded') AND created_at < now() - interval '30 days' LIMIT 5000)` looped until 0 rows |

Retention: **30 days** for terminal rows (audit + abuse investigation); active/`sent` rows are never deleted.

**Fallback if `WORKERS_ENABLED` is unset on the VPS** (unknown → [R]): `sendOtp` also deletes that phone's old terminal rows (`status NOT IN ('pending','sent') AND created_at < now() - interval '1 day'`), which is index-backed and bounded, so the table cannot grow without bound even with no worker running.

---

## 9. Transaction and concurrency design

### 9.0 The rule that shapes everything

**PostgreSQL and UDO cannot share a transaction.** No amount of `db.transaction()` makes an SMS send atomic with a row write. The design therefore uses **short transactions around the database only**, with an explicit, auditable state for "a provider call is in flight", plus a documented ambiguity window. Nothing below claims otherwise.

### 9.1 Send — three short transactions, no DB transaction across the network

```
sendOtp(phone, purpose='login'):
  # ── Phase A: reserve (short txn, ~1 ms) ──────────────────────────────
  BEGIN
    SELECT pg_advisory_xact_lock(hashtext(purpose || ':' || phone))  -- serialise same-phone sends
    if OTP_SENDING_ENABLED != true                  -> 503 OTP_DISABLED
    last = SELECT created_at FROM otp_sessions
             WHERE phone=$1 AND purpose=$2 AND status IN ('sent','consumed','locked')
             ORDER BY created_at DESC LIMIT 1
    if last and now() - last < OTP_COOLDOWN_SECONDS  -> 429 OTP_COOLDOWN (retryAfterSeconds)
    hour = count(*) … phone,purpose, created_at > now()-1h     -- counts ALL rows
    day  = count(*) … phone,purpose, created_at > now()-24h
    if hour >= OTP_MAX_PER_HOUR -> 429 OTP_RATE_LIMITED (retryAfterSeconds)
    if day  >= OTP_MAX_PER_DAY  -> 429 OTP_RATE_LIMITED (retryAfterSeconds)
    global = count(*) … created_at > now()-24h                 -- all phones
    if global >= OTP_GLOBAL_DAILY_MAX -> 503 OTP_DISABLED (+ logger.error alert)
    UPDATE otp_sessions SET status='superseded'
      WHERE phone=$1 AND purpose=$2 AND status IN ('pending','sent')
    INSERT INTO otp_sessions
      (phone,purpose,status,provider,expires_at,otp_hash,attempts,ip_hash)
      VALUES ($1,$2,'pending',$3, now()+OTP_TTL_SECONDS, NULL, 0, $4)
      RETURNING id
  COMMIT                                    -- advisory lock released here

  # ── Phase B: provider call (NO transaction, 5 s timeout, no retry) ───
  ref = provider.generate({ msisdn: '91'+phone })

  # ── Phase C: confirm (short txn) ─────────────────────────────────────
  BEGIN
    row = UPDATE otp_sessions SET status='sent', provider_ref=$ref, provider=$provider
            WHERE id=$id AND status='pending' RETURNING id
  COMMIT
  if row is empty:                       -- superseded while in flight (should be impossible)
      log otp_challenge_superseded
      return 200 {sent:true, supersededByNewer:true}   # newest SMS is the valid one
  return 200 {sent:true, expiresInSeconds, resendAfterSeconds}
```

**Why the advisory lock and not "rely on the unique index":** the index enforces the invariant; the lock makes the *sequence* (cooldown check → supersede → insert) deterministic so two concurrent requests cannot both pass the cooldown test before either inserts. Index = safety net, lock = correctness mechanism. Both are cheap: the lock is transactional, keyed by a 32-bit hash of `purpose:phone`.

**Deliberate asymmetry in the counters:**

- **Cooldown** counts only challenges that could have produced an SMS (`sent`, `consumed`, `locked`), so a provider outage does not lock a user out for 30 s per failed attempt.
- **Hourly/daily caps count every row** in the window, including `failed` ones — these are the SMS-cost controls, so a failing provider is not hammered.
- **Global cap** counts every row in 24 h across all phones → the emergency brake.

**Provider failure path (Phase B throws):**

```
  BEGIN
    UPDATE otp_sessions SET status='failed', provider_ref=NULL
      WHERE id=$id AND status='pending'
  COMMIT
  OtpProviderConfigError      -> 503 OTP_PROVIDER_MISCONFIGURED + logger.error alert
  OtpProviderUnavailableError -> 503 OTP_PROVIDER_UNAVAILABLE
```

A `failed` row is never reported as "sent" and is never redeemable — there is no `provider_ref` to validate against.

**Ambiguity (documented, unavoidable):** if the provider call times out *after* UDO accepted the request, an SMS may arrive whose `verifyId` we never stored. Correct behaviour: tell the client "failed, try again"; the retry creates a **new** challenge and a **new** SMS. Cost: one wasted SMS. **Never** auto-retry the provider call.

---
### 9.2 Verify — validate outside the lock, consume inside a conditional update

Chosen strategy: **optimistic leasing**, not "hold a row lock during the network call".

Rejected alternative — `SELECT … FOR UPDATE` around `provider.validate()`: every in-flight verify would pin one of the **20** pool connections (`connection.ts:20`) for up to the 5 s provider timeout, and twenty simultaneous verifies would starve the entire API. Row locks also cannot have a timeout shorter than `statement_timeout` (30 s) without extra machinery.

```
verifyOtp(phone, code, purpose='login'):
  # ── Phase A: claim the lease (short txn) ─────────────────────────────
  BEGIN
    row = SELECT * FROM otp_sessions
            WHERE phone=$1 AND purpose=$2 AND status IN ('pending','sent')
            ORDER BY created_at DESC LIMIT 1
            FOR UPDATE
    if !row                              -> 400 OTP_EXPIRED
    if row.expires_at <= now()           -> UPDATE … 'expired'; 400 OTP_EXPIRED
    if row.status == 'pending'           -> 409 OTP_NOT_READY
    if row.attempts >= OTP_MAX_ATTEMPTS  -> UPDATE … 'locked'; 429 OTP_LOCKED
    if row.verify_lease_until > now()    -> 429 OTP_VERIFY_IN_PROGRESS (retryAfterSeconds: 2)
    if row.provider_ref IS NULL          -> 400 OTP_EXPIRED
    UPDATE otp_sessions SET verify_lease_until = now() + interval '10 seconds'
      WHERE id = row.id AND status='sent'
  COMMIT                                   -- no lock held during the network call

  # ── Phase B: provider validate (no txn, 5 s timeout, no retry) ───────
  ok = provider.validate({ providerRef: row.provider_ref, code })

  # ── Phase C: settle (short txn) ──────────────────────────────────────
  BEGIN
    if ok:
      claimed = UPDATE otp_sessions
                  SET status='consumed', consumed_at=now(), verified=true,
                      verify_lease_until=NULL
                WHERE id=$id AND status='sent' AND purpose=$purpose
                RETURNING id
      if claimed is empty:                 -- lost the race / already consumed
          ROLLBACK; throw 409 OTP_ALREADY_USED
      user = resolve user by phone (is_active = true)
      if user is null:
          signupToken = sign({phone, challengeId:$id, type:'signup'}, 10m)
          COMMIT; return {existingUser:false, signupToken}
      insert refresh_tokens row            -- inside the SAME txn as the consume
      COMMIT                               -- exactly one session per consume
      return {existingUser:true, user, tokens}
    else:
      new = UPDATE otp_sessions
              SET attempts = attempts + 1,
                  verify_lease_until = NULL,
                  status = CASE WHEN attempts + 1 >= OTP_MAX_ATTEMPTS
                                THEN 'locked' ELSE status END
            WHERE id=$id AND status='sent'
            RETURNING attempts, status
      COMMIT                               -- ← failed attempt is DURABLE before we throw
      if new.status == 'locked' -> throw 429 OTP_LOCKED
      else                      -> throw 400 OTP_INVALID
```

Three properties this buys, each explicitly required:

1. **Failed attempts survive the error.** The increment commits, *then* the exception is thrown — never "increment inside a transaction that the throw rolls back".
2. **Exactly one consume.** The `status='sent'` predicate in the `RETURNING` update is the serialisation point; two parallel successes yield one winner and one `409`.
3. **No tokens without consumption.** The refresh-token insert lives in the same transaction as the consume, so any failure rolls back both. If the process dies after commit but before the response is written, the retry gets `409 OTP_ALREADY_USED` → request a new code. Annoying, never unsafe.

**Lease instead of lock:** concurrent guesses against the *same* challenge get `429 OTP_VERIFY_IN_PROGRESS` for the duration of the provider call, so parallelism cannot exceed the attempt budget and the provider is never asked to validate the same code twice concurrently. The lease is 10 s (2× the provider timeout), so a crashed request cannot wedge the challenge.

**Trade-off accepted:** a legitimate double-tap of "Verify" gets a 429 instead of a second validation — strictly better than burning two provider attempts for one user action.

**Ambiguity (documented, unavoidable):** if `provider.validate()` returns `true` but Phase C fails (process killed, DB error), the challenge stays `sent` while the provider has burned the OTP. The next attempt fails provider-side → `OTP_INVALID`/`OTP_EXPIRED` → user requests a new code. We **never** compensate by issuing tokens without a local consume.

---
### 9.3 Signup — single-use inside the creating transaction

```
signup(signupToken, name, role, …):
  payload = verifyJwt(signupToken, JWT_ACCESS_SECRET); assert payload.type==='signup'
  BEGIN
    claimed = UPDATE otp_sessions
                SET signup_consumed_at = now()
              WHERE id = payload.challengeId
                AND phone = payload.phone
                AND purpose = 'login'
                AND status = 'consumed'
                AND signup_consumed_at IS NULL
              RETURNING id
    if claimed is empty -> 401 SIGNUP_TOKEN_USED          -- replay or wrong binding
    insert users + vendor/customer profile + (optional) upi rows
  COMMIT                                                  -- account creation and token use are atomic
```

- If account creation fails for **any** reason the transaction rolls back and the token stays usable for a safe retry. **Decision: retry-safe**, because "consumed but no account" is worse than a 10-minute replay window that is already bound to a consumed challenge and a specific phone.
- Role is **not** taken from the challenge (a phone has no role); it is chosen at signup exactly as today and remains restricted to `vendor|customer` (`auth.validators.ts:28-30`) — a client can never self-assign `staff`.
- Duplicate phone/email after signup: catch PG `23505` on `users_mobile_unique` / `users_email_role_unique` and map to `409 PHONE_ALREADY_REGISTERED` / `409 EMAIL_ALREADY_REGISTERED` instead of a 500 (G14).

### 9.4 Refresh rotation (P7 — not release-blocking)

```
BEGIN
  claimed = UPDATE refresh_tokens SET is_revoked = true, replaced_by_hash = $newHash
              WHERE token_hash = $oldHash AND is_revoked = false AND expires_at > now()
              RETURNING user_id
  if claimed is empty:
      COMMIT
      revokeAllUserRefreshTokens(userId)     -- reuse detected
      throw 401
  insert new refresh token row
COMMIT
```

This closes G13 by making the revoke the serialisation point instead of a read-then-write. Deliberately **not** part of P1: it does not affect OTP correctness and would enlarge the blast radius of the first release.

### 9.5 Distributed-failure matrix (what the system does, not what it wishes)

| # | Failure | Behaviour | User sees |
|---|---|---|---|
| 1 | Challenge row created, UDO generate fails | Row → `failed`; no ref; cooldown not started | 503, retry allowed immediately |
| 2 | UDO sent, response timed out | Row → `failed`; SMS may arrive but is unredeemable | 503; retry sends a new code |
| 3 | UDO succeeded, persisting the ref failed | Row stays `pending`, then `expired` at TTL | 503 / `409 OTP_NOT_READY` |
| 4 | Two sends race | Advisory lock serialises; second hits cooldown `429` | one SMS |
| 5 | New challenge supersedes one still in flight | Old row `superseded`; Phase C's conditional update is a no-op | `{sent:true,supersededByNewer:true}` |
| 6 | Validate succeeded, local commit failed | Challenge stays `sent`; provider OTP burned | `OTP_INVALID`/`OTP_EXPIRED` on retry → new code |
| 7 | Client retries after an ambiguous timeout | Server state decides: cooldown / already-consumed / normal verify | deterministic error, never a duplicate session |

Rows 4 and 5 are effectively unreachable in practice (30 s cooldown + 5 s provider timeout), but the machine is defensive rather than optimistic.

---

## 10. Phone and OTP validation rules

### 10.1 Phone (unchanged canonical form — `^[6-9]\d{9}$`)

| Check | Rule | Where |
|---|---|---|
| Presence + type | `z.string()` required | `sendOtpSchema` / `verifyOtpSchema` (`auth.validators.ts:9-18`) |
| Format | `^[6-9]\d{9}$`, exactly 10 digits, no `+`, spaces or dashes | same regex as today |
| Unknown fields | **`.strict()`** on the OTP schemas (currently permissive) — reject `purpose`, `otp`, etc. on send | new |
| Trimming | `.trim()` before the regex, then reject if changed materially (never "fix" a number) | new |
| Country | India only. The MSISDN sent to UDO is `91` + the 10 digits | adapter |
| Non-existent/reachable numbers | **Cannot be proven by regex.** UDO's `No Valid Numbers Found..!!` is the only existence signal → mapped to `400 OTP_INVALID_NUMBER` | adapter |

Rejected on purpose: E.164-as-primary-key. The DB, the partial unique index and the app all use the 10-digit form; switching would require a data migration and an app release for zero security gain.

### 10.2 OTP code

| Check | Rule |
|---|---|
| Presence | `z.string()` required |
| Length | exactly 6 — from the app's UI and the assumed `configId` format; **must be confirmed with UDO** ([D]/[R]) |
| Charset | `^\d{6}$`, kept as **string** (leading zeros are significant — never `parseInt`) |
| Body size | `express.json({limit:'1mb'})` already bounds it (`app.ts:48`); the 6-char regex bounds it further |
| Unknown fields | rejected by `.strict()` |
| Logging | never logged server-side at any level; added to the Flutter client's redaction set (§13.5) |

### 10.3 Request schemas (all Zod, all reused conventions)

| Endpoint | Schema change |
|---|---|
| `POST /auth/otp/send` | `z.object({phone}).strict()` — unchanged shape |
| `POST /auth/otp/verify` | `z.object({phone, otp}).strict()` — unchanged shape |
| `POST /auth/account/delete-otp` | no body |
| `DELETE /auth/account` | `z.object({otp: z.string().regex(/^\d{6}$/).optional(), password: z.string().optional()}).strict()` |
| `POST /auth/phone/change-request` | `z.object({newPhone}).strict()` |
| `POST /auth/phone/change-confirm` | `z.object({newPhone, otp}).strict()` |
| `PATCH /auth/profile` | keep `.strict()`; `mobile` accepted **only** if identical to the stored value, otherwise `409 PHONE_VERIFICATION_REQUIRED` (§16.2) |

Every new optional field needs a deliberate default: there are none except `otp`/`password` on `DELETE /auth/account`, whose absence produces a specific 400 rather than a silent downgrade.

---

## 11. Rate limiting and abuse prevention

### 11.1 Where enforcement lives

| Control | Enforced in | Cross-instance? | Fails open? |
|---|---|---|---|
| Per-phone cooldown / hourly / daily / global cap | **PostgreSQL rows** inside the send transaction (§9.1) | ✅ yes (rows are shared) | ❌ no — authoritative control |
| Per-IP send limit | Redis `INCR`+`EXPIRE` when reachable; otherwise the existing in-process limiter | ✅ with Redis, ⚠️ per-process without | ⚠️ **yes, by design** — secondary control |
| Attempt budget | `otp_sessions.attempts` (§9.2) | ✅ yes | ❌ no |
| Verify concurrency | `verify_lease_until` (§9.2) | ✅ yes | ❌ no |
| Global kill switch | `OTP_SENDING_ENABLED`, checked per request | ✅ yes (env) | ❌ no |
| Coarse request flood | existing `express-rate-limit` 200/15 min + 20/15 min auth limiter (`app.ts:55-85`) | ⚠️ per-process | — |

**Why the per-IP control may fail open:** Redis is explicitly optional at boot (`redis/client.ts:25-36`), so a Redis outage must not take login down. The per-phone limits — the ones that bound SMS spend — are unaffected. This is a documented hierarchy, not an oversight.

`[R]` The number of pm2 processes is not visible from the repository. If production runs `pm2 start … -i N`, every `express-rate-limit` counter is per-process; the per-phone DB limits remain exact regardless, which is why they are primary.

### 11.2 Defaults (configurable; product owner may adjust)

| Variable | Default | Rationale |
|---|---|---|
| `OTP_COOLDOWN_SECONDS` | **30** | Prevents double-tap SMS; short enough for a legitimate retry |
| `OTP_MAX_PER_HOUR` | **5** | A user needs 1–2; 5 tolerates network failures |
| `OTP_MAX_PER_DAY` | **10** | Bounds per-user cost even under a stuck client retry loop |
| `OTP_MAX_ATTEMPTS` | **3** | Matches today's `MAX_ATTEMPTS` (`otp.service.ts:17`); 3/10⁶ guessing odds |
| `OTP_GLOBAL_DAILY_MAX` | **500** | Emergency brake for a new app; revisit with real volume [D] |
| `OTP_IP_MAX_PER_HOUR` | **20** | Shared mobile NAT means this must stay generous |
| `OTP_TTL_SECONDS` | **300** | Matches today's 5 min; must be ≤ the `configId` TTL (§4.4) |
| `OTP_REQUEST_TIMEOUT_MS` | **5000** | Below the 10 s acquire budget and the 15 s client timeout |

### 11.3 Behavioural guarantees

- **A rejected request never calls UDO.** Every limit is evaluated in Phase A, before Phase B.
- **429s carry `retryAfterSeconds`** computed from the real remaining window, plus a `Retry-After` header.
- **Cooldown is a server value.** The Flutter countdown (§13.3) is cosmetic; changing the device clock changes nothing.
- **Purpose isolation:** counters are keyed by `(phone, purpose)`, so an account-delete OTP does not consume the login allowance.
- **No silent downgrade:** a misconfigured or disabled provider returns 503; it never falls back to a fixed code (§20.3).

### 11.4 Client IP handling

`app.set('trust proxy', 1)` (`app.ts:35`) trusts exactly one proxy hop. `[R]` Confirm the VPS topology (nginx/Cloudflare → pm2). With two hops `req.ip` is the proxy address and per-IP limits collapse into one bucket — a correctness bug, not a hole, but it must be checked before relying on `OTP_IP_MAX_PER_HOUR`.

### 11.5 What is stored about the client

Only `sha256(ip + OTP_IP_HASH_SALT)` in `otp_sessions.ip_hash`; the raw IP is never persisted for OTP. `users.mobile` stays plaintext because it is the identity and must reach the provider.

---

## 12. Error-handling contract

### 12.1 Envelope (unchanged shape + one additive field)

```json
{ "success": false, "message": "Too many attempts. Request a new code.",
  "error": "OTP_LOCKED", "retryAfterSeconds": 300 }
```

`errorHandler.ts:13-24` already emits `{success,message,error}` and spreads extras for one special case (`blockers`). Add `retryAfterSeconds` the same way — additive, so `ApiClient.extractErrorMessage` (`api_client.dart:177-183`) keeps working untouched.

### 12.2 Codes

| Condition | HTTP | `error` | Notes |
|---|---|---|---|
| Malformed body / bad phone / bad code shape | 422 | `VALIDATION_ERROR` | existing `ValidationError` (`AppError.ts:32-36`) |
| **Wrong OTP** | **400** | `OTP_INVALID` | **changed from 401** — see §12.3 |
| Expired / missing challenge | 400 | `OTP_EXPIRED` | |
| Too many attempts | 429 | `OTP_LOCKED` | `retryAfterSeconds` = remaining TTL |
| Resend cooldown | 429 | `OTP_COOLDOWN` | `retryAfterSeconds` |
| Hourly / daily cap | 429 | `OTP_RATE_LIMITED` | `retryAfterSeconds` |
| Send still in flight | 409 | `OTP_NOT_READY` | |
| Challenge already consumed | 409 | `OTP_ALREADY_USED` | |
| Concurrent verify on same challenge | 429 | `OTP_VERIFY_IN_PROGRESS` | `retryAfterSeconds: 2` |
| Superseded by newer send | 200 | — (`supersededByNewer:true`) | not an error |
| Provider outage / timeout | 503 | `OTP_PROVIDER_UNAVAILABLE` | `Retry-After: 60` |
| Provider misconfiguration | 503 | `OTP_PROVIDER_MISCONFIGURED` | + `logger.error` for alerting |
| OTP sending disabled | 503 | `OTP_DISABLED` | kill switch |
| Number rejected by provider | 400 | `OTP_INVALID_NUMBER` | |
| Signup token expired | 401 | `UNAUTHORIZED` | existing message |
| Signup token already used | 401 | `SIGNUP_TOKEN_USED` | |
| Phone already registered | 409 | `PHONE_ALREADY_REGISTERED` | from PG `23505` |
| Email already registered | 409 | `EMAIL_ALREADY_REGISTERED` | from PG `23505` |
| Phone change requires verification | 409 | `PHONE_VERIFICATION_REQUIRED` | §16.2 |
| Account deletion blocked | 409 | `DELETE_ACCOUNT_BLOCKED` | existing, with `blockers` |
| Missing/invalid Bearer token | 401 | `UNAUTHORIZED` | unchanged |
| Insufficient role | 403 | `FORBIDDEN` | unchanged |
| Unexpected | 500 | `INTERNAL_ERROR` | unchanged, no internals leaked |

No raw UDO message, stack trace, SQL error or key ever reaches the client; `errorHandler.ts:36-42` remains the last line of defence for unknown errors.

### 12.3 The 401 problem (blocking — must land with P2)

`api_client.dart:48-90`: **any** 401 on a non-refresh request triggers a refresh attempt; if there is no refresh token (logged-out user) or the refresh fails, the client clears storage and calls `forceUnauthenticated()`, which the router turns into a redirect (`auth_state_notifier.dart:22-25`, `app_router.dart:169-190`).

Today a wrong OTP throws `UnauthorizedError` (`otp.service.ts:78`) and a wrong current password does the same (`auth.service.ts:476`), so:

- three typos on the OTP screen = three refresh attempts + session clear + router churn;
- a mistyped current password logs the user out of the device.

**Decision: 401 means "your session is invalid" and nothing else.** OTP failures move to 400/409/429 per §12.2; `changePassword` moves to **400 `INVALID_CREDENTIALS`** (P4). No app change is needed because the app reads only `message`.

### 12.4 Example exchange (wrong code three times)

```
POST /auth/otp/verify {"phone":"9876543210","otp":"000000"} → 400 {"error":"OTP_INVALID","message":"Incorrect OTP. 2 attempts left."}
POST /auth/otp/verify {"phone":"9876543210","otp":"111111"} → 400 {"error":"OTP_INVALID","message":"Incorrect OTP. 1 attempt left."}
POST /auth/otp/verify {"phone":"9876543210","otp":"222222"} → 429 {"error":"OTP_LOCKED","retryAfterSeconds":300,"message":"Too many attempts. Request a new code."}
POST /auth/otp/verify {"phone":"9876543210","otp":"333333"} → 429 {"error":"OTP_LOCKED", …}   (still locked, even if correct)
```

Attempt counts in messages come from the same durable counter that gates the request, so the message can never disagree with enforcement.

---

## 13. Flutter integration requirements

**Nothing in P1–P3 requires a store release.** §13.1 lists what already works; §13.2–13.4 are P6 UX items; §13.5 is the security hygiene that *does* need a release.

### 13.1 Already compatible (no change needed) [V]

| Behaviour | Why it already works |
|---|---|
| `POST /auth/otp/send` with `{phone}` | `auth_repository_impl.dart:17-24`; ignores the response payload |
| `POST /auth/otp/verify` reading `existingUser/user/tokens/signupToken` | `auth_repository_impl.dart:26-40` |
| Displaying server error text | `extractErrorMessage` reads `message` only (`api_client.dart:177-183`) |
| `POST /auth/account/delete-otp` then `DELETE /auth/account {otp}` | already implemented client-side (`auth_repository_impl.dart:152-177`) |
| Role routing incl. `staff → /staff-home` | `app_router.dart:169-190` |

### 13.2 Phone entry screen (P6 polish)

| Requirement | Current state | Action |
|---|---|---|
| Reject invalid input | ✅ `^[6-9]\d{9}$` + toast (`phone_entry_screen.dart:33-41`) | keep |
| Digits-only + max length | partial (`TextInputType.phone`) | add `FilteringTextInputFormatter.digitsOnly`, `maxLength: 10` |
| Duplicate submit in flight | ✅ disabled during `AuthLoading` | keep |
| No request while typing | ✅ | keep |
| Timeout/offline copy | generic Dio message | map `connectionTimeout`/`connectionError` to "Check your connection" |

### 13.3 OTP verification screen (P6 — only after backend limits exist)

| Requirement | Current state | Required change |
|---|---|---|
| 6 numeric boxes, auto-advance, backspace | ✅ `otp_verify_screen.dart:25-48,72-126` | keep |
| Resend countdown | ❌ none; link always enabled (`:227-248`) | 30 s timer seeded from the server's `retryAfterSeconds`; disable while counting |
| Resend toast timing | ❌ success toast before the request resolves (`:62-70`) | spinner, then success/failure after the response |
| Distinct handling of 429 / 503 / 409 | ❌ all errors collapse to one toast and clear every box (`:143-149`) | `OTP_LOCKED`/`OTP_EXPIRED` → clear + "request a new code"; `OTP_PROVIDER_UNAVAILABLE` → keep digits + "service unavailable"; `OTP_INVALID` → clear, keep countdown |
| Duplicate verify | ✅ disabled during `AuthLoading` | keep |
| Background/reopen | state in the BLoC; fields local | acceptable (OTP lives ≤ 5 min) |
| OTP in persistent storage | ✅ never stored | keep |
| Accessibility | no semantics on boxes | `Semantics(label: 'Digit N of 6')` |
| Localisation | uses `l10n.*` | add new strings to all ARB bundles |

### 13.4 Network behaviour

- 15 s connect/receive timeouts (`api_client.dart:24-25`); **no retry interceptor exists**, which is correct for OTP — never add one for `/auth/otp/*`.
- Send timeout → "we could not confirm the SMS; wait for it, or request a new code after 30 s". **Never auto-retry.**
- Verify timeout → it may have succeeded. Re-enable the button for one manual retry; the server answers deterministically (§9.5 row 7).
- `forceUnauthenticated()` must never fire for OTP endpoints — guaranteed once §12.3 lands.

### 13.5 Security hygiene (P6 — requires a release)

1. Add `'otp'` to `_redactedKeys` (`api_client.dart:9`).
2. Delete `lib/core/config/udo_otp_config.dart`, `lib/features/auth/data/services/udo_otp_service.dart`, and their two tests; remove `.env` from `pubspec.yaml:88`; remove `dotenv.load` from `main.dart:25`; drop `flutter_dotenv` (`pubspec.yaml:73`). **Verified safe:** the only `lib/` consumers are those two files plus `main.dart`.
3. Remove the debug `[DEBUG] Bearer token` logging (`auth_bloc.dart:50-52,195-197`).
4. Verify the release bundle: `unzip -p app-release.apk assets/flutter_assets/.env` must fail after removal.

### 13.6 State model

Keep `AuthState` unchanged. The richer backend errors do not need new BLoC states: `AuthError(message)` is enough because the app renders `message`, and the only branch that matters (retry vs request-new-code) can be derived from the error code in P6. **Do not add a parallel state machine.**

---

## 14. Customer / vendor / staff authentication flows

### 14.1 Role facts that constrain the design [V]

- A phone number maps to **at most one** `users` row across all roles (`users_mobile_unique`, `20260021_otp_auth.ts:48-52`; re-enforced in `staff.service.ts:401`).
- `staff` accounts are created **only** when a vendor grants app access; there is no self-service staff signup.
- The app has two role cards (vendor/customer); a staff member must pick "Vendor" (`auth_bloc.dart:178-187`).
- After login the router sends `staff` → `/staff-home`, `vendor` → `/vendor`, `customer` → `/customer` (`app_router.dart:175-181`).

### 14.2 Customer

| Step | Behaviour |
|---|---|
| Account creation | New phone → OTP → `existingUser:false` + `signupToken` → `/auth/signup` with `role:'customer'` |
| Phone already exists | `existingUser:true` → tokens; the app rejects if `user.role !== 'customer'` (`auth_bloc.dart:178-187`) |
| OTP purpose | `login` |
| User resolution | `users.mobile = phone AND is_active` |
| Tokens | access 15 m + refresh 7 d (`constants/index.ts:1-4`) |
| Home | `/customer` |
| Inactive account | `is_active=false` → `authenticate` rejects (`authenticate.ts:52-55`) |

### 14.3 Vendor

Identical to the customer path with `role:'vendor'`, plus a `vendor_profiles` row created in the same transaction (`auth.service.ts:73-92`), and `/vendor` as home.

### 14.4 Staff (incl. delivery)

| Step | Behaviour |
|---|---|
| Account creation | vendor `POST /staff` then `PATCH /staff/:id/access {canLogin:true}` → `role='staff'` user created with the staff phone (`staff.service.ts:396-426`) |
| OTP | same `login` purpose — no staff-specific endpoint |
| User resolution | `users.mobile = phone` → `role='staff'` |
| Token | access/refresh carry `vendorId` = owner (`otp.service.ts:126-142`, `auth.service.ts:589-605`) |
| Authorization | `effectiveVendorId()` for vendor-scoped work; `authorize('vendor')` gates vendor-only routes |
| Home | `/staff-home` |
| Access revoked | login throws `ForbiddenError` (`otp.service.ts:131-133`) **and** every later request is rejected (`authenticate.ts:43-50`) |
| Deactivated staff member | `staff_members.is_active=false` → both checks fail |

### 14.5 What OTP must never do

- **Never grant a role.** A verified phone proves control of the number only. `role` is chosen at signup (restricted to `vendor|customer`) or set by a vendor's staff grant.
- **Never bypass staff checks.** No OTP branch may skip `findStaffAccessForUser` or the `can_login/is_active` re-check.
- **Never let a client change the purpose** of an existing challenge (§7.3).
- **Never create an account for an existing phone.** `existingUser:true` short-circuits.

### 14.6 One UX wart, deliberately deferred

A staff member must select "Vendor" on the role screen. That is a one-screen copy/UX fix (G16) scheduled in P6 — doing it earlier would require an app release *before* the backend can serve it, inverting the safe deployment order.

---

## 15. Signup-token and session security

### 15.1 The token

```json
{ "phone": "9876543210", "challengeId": "<otp_sessions.id>", "type": "signup", "iat": …, "exp": … }
```

Signed with `JWT_ACCESS_SECRET`, TTL 10 min (unchanged), and — new — carries `challengeId`.

**Secret reuse:** the token cannot be used as an access token because `authenticate` requires `payload.type === 'access'` (`authenticate.ts:37-39`) and `decodeSignupToken` requires `'signup'` (`otp.service.ts:116`). Accepted trade-off: one secret, two type-checked token types. A dedicated `JWT_SIGNUP_SECRET` would be cleaner but adds a required env var and a deploy-ordering constraint for no security gain today.

### 15.2 Threats and controls

| Threat | Control |
|---|---|
| Replay within 10 min | `signup_consumed_at` conditional update (§9.3) |
| Expired token | `jwt.verify` enforces `exp` |
| Token used for a different phone | `phone = payload.phone` predicate; the account is created with `payload.phone`, never a body field |
| Token used for an unauthorized role | `signupSchema.role` is `z.enum(['vendor','customer'])` (`auth.validators.ts:28-30`) — `staff` is not expressible |
| Replay after account creation | challenge is `consumed` and `signup_consumed_at` is set; both predicates fail |
| Two concurrent signups with one token | the conditional update serialises on the row; exactly one wins, the other gets `401 SIGNUP_TOKEN_USED` |
| Token accepted after its challenge is invalidated | the predicate requires `status='consumed'` — `superseded`/`expired`/`locked` cannot be used |
| Duplicate account race (same phone) | `users_mobile_unique` + `23505 → 409` |

### 15.3 Decision: is the token retry-safe?

**Yes.** The `signup_consumed_at` write is inside the account-creation transaction, so a failure (e.g. duplicate email) rolls back the consumption and the user can fix the form and retry with the same token for the rest of its 10 minutes. Rationale: the alternative ("burn on first attempt") turns a typo into a full OTP round-trip, and the replay window is already bound to one consumed challenge and one phone.

### 15.4 Refresh-token reuse detection today

`refreshTokens` revokes all sessions when a token hash is not found (`auth.service.ts:129-137`) — good intent, but two *valid* concurrent refreshes both pass `findActiveRefreshToken` (`auth.repository.ts:170-175`) and both mint pairs. Fixed in P7 (§9.4). Not release-blocking for OTP.

---

## 16. Account-deletion and phone-change findings

### 16.1 Account deletion (🔴 confirmed; fixed in P3 with **zero app changes**)

**Verified behaviour today:**

1. `DeleteAccountFlow.start` → warning dialog → "type DELETE" dialog → if the account has a phone, `repo.sendDeleteAccountOtp()` (`delete_account_flow.dart:31-42`).
2. That call targets `POST /auth/account/delete-otp` (`api_endpoints.dart:21`), **a route that does not exist** → 404 → the flow shows a toast and **returns**, never opening the confirmation dialog (`delete_account_flow.dart:36-41`).
3. For an account **without** a phone the dialog appears, the user types a code, and `DELETE /auth/account` is called with `{otp}` (`auth_repository_impl.dart:161-177`) — but the controller never reads the body (`auth.controller.ts:156-164`) and `deleteAccount(userId)` (`auth.service.ts:421`) deletes on the JWT alone.

So: phone users cannot delete at all; phone-less users delete with an unverified client-side string. Once every account is phone-based (P1), deletion is **broken for all users** — a store-compliance problem (Google Play data-deletion requirement) as well as a security one.

**Fix (P3):**

| Endpoint | Behaviour |
|---|---|
| `POST /auth/account/delete-otp` (Bearer) | purpose `account_delete`; phone taken from the **user row**; if `mobile IS NULL` → `409 USE_PASSWORD_CONFIRMATION`; same cooldown/caps as login |
| `DELETE /auth/account` (Bearer, `{otp}` or `{password}`) | with a phone → verify+consume an `account_delete` challenge inside the same transaction that runs the blocker checks and the soft-delete; without a phone → require the password (bcrypt compare) |

Preserved unchanged: all blockers and messages (`auth.service.ts:264-392`), soft-delete semantics (`:432-459`), `DELETE_ACCOUNT_BLOCKED` + `blockers`, session revocation, `409` mapping. A **login** OTP can never authorize deletion (purpose isolation, §7.3).

### 16.2 Phone-number change (🟠 confirmed)

`PATCH /auth/profile {mobile}` writes `users.mobile` with no ownership proof (`auth.service.ts:186`) while the app sends `mobile` on **every** save (`edit_profile_screen.dart:181-183`). Consequences: a user can attach any unclaimed number; the number's real owner can then log into that account (the OTP goes to the real owner); a collision with an existing number is a raw 500 (`23505`).

**Fix (P3, backend-only, no regression):**

- `mobile` equal to the stored value → accepted as a no-op, so "edit profile" keeps working unchanged.
- `mobile` different (or set for the first time) → `409 PHONE_VERIFICATION_REQUIRED`, no write.
- New verified flow: `POST /auth/phone/change-request {newPhone}` → `phone_change` OTP to **newPhone**; `POST /auth/phone/change-confirm {newPhone, otp}` → consume + update in one transaction, with a pre-check and `23505 → 409 PHONE_ALREADY_REGISTERED`.
- Sessions are **not** revoked on phone change (identity unchanged, control just proven); documented decision.

### 16.3 Email identity (🟡 scoped out)

`email-signup` stays, `email-login` stays, `(email, role)` uniqueness stays. In scope: make `currentPassword` optional when `password_hash IS NULL` (P4) and return `400 INVALID_CREDENTIALS` instead of 401 for a wrong current password (§12.3). Adding/changing an email from the profile is **out of scope** for this release.

---

## 17. Performance and resource management

| Concern | Analysis | Mitigation |
|---|---|---|
| Pool pressure | Pool max **20** (`connection.ts:20`); a verify holding a row lock across the provider call would consume a connection for up to 5 s | Leasing (§9.2) — no connection held during the network call |
| Statement timeout | 30 s (`connection.ts:23`) | Every query in §9 is index-backed and sub-millisecond |
| Provider latency | Unknown (undocumented) [R] | 5 s `AbortController` timeout; latency logged as `durationMs` |
| Send path cost | 1 advisory lock + 1 select + 4 counts + 1 update + 1 insert | All keyed by `(phone,purpose,created_at)`; counts bounded by the 24 h window |
| Cleanup cost | 30-day retention keeps the table small | Batched `LIMIT 5000` loop + partial index on `expires_at` |
| Table growth | Currently unbounded (G8) | 30-day retention + per-phone opportunistic delete |
| Index build | New partial unique index on an existing table | Table is tiny today [R: confirm row count]; built inside the migration transaction |
| Connection acquisition | 10 s timeout (`connection.ts:27`) | Provider timeout (5 s) < acquire budget, so a verify is never blocked longer than one round trip |
| Socket.IO / push | Login also connects the socket and inits push (`auth_bloc.dart:198-200`) | Unchanged; not on the OTP critical path |
| Per-IP limiter | In-process fallback | Documented degradation (§11.1) |

---

## 18. Privacy, logging and observability

### 18.1 Structured events (JSON in production via winston, `logger/index.ts:17-28`)

| Event | Level | Fields (never sensitive) |
|---|---|---|
| `otp.send.requested` | info | `challengeId`, `purpose`, `phoneMasked`, `ipHash8` |
| `otp.send.sent` | info | + `provider`, `durationMs` |
| `otp.send.failed` | warn | + `errorCode`, `durationMs` |
| `otp.send.rate_limited` | warn | `challengeId?`, `limit:'cooldown'\|'hour'\|'day'\|'ip'\|'global'` |
| `otp.verify.succeeded` | info | `challengeId`, `purpose`, `durationMs`, `userId` |
| `otp.verify.failed` | warn | `challengeId`, `attemptsRemaining`, `errorCode` |
| `otp.challenge.locked` | warn | `challengeId`, `phoneMasked` |
| `otp.challenge.superseded` | info | old + new `challengeId` |
| `otp.challenge.expired` | debug | `challengeId` |
| `otp.provider.timeout` | error | `provider`, `durationMs` |
| `otp.provider.misconfigured` | error | `provider`, `reason` |
| `otp.signup.token_replay` | warn | `challengeId`, `phoneMasked` |
| `otp.dummy_provider_used` | info (dev only) | — |

### 18.2 Never logged

OTP values, `provider_ref`/`verifyId`, the API key, JWTs, passwords, full request bodies, raw provider responses, full MSISDN (mask `98******10`), raw client IPs.

Existing violations to fix in P2: `logger.info('OTP session created', { phone })` (`otp.service.ts:46`), `{ phone }` in the signup/verify-success logs (`:104,108`), and the Flutter `otp` field missing from `_redactedKeys` (`api_client.dart:9`). `requestLogger.ts:10-16` already logs only method/path/status/duration.

### 18.3 Metrics (derived from logs; no new platform)

| Metric | Source | Alert |
|---|---|---|
| Send success rate | `otp.send.sent` / `requested` | < 90 % over 15 min |
| Verify success rate | `verify.succeeded` / (`succeeded`+`failed`) | drop below 40 % |
| Provider p95 latency | `durationMs` | > 3000 ms |
| Timeout rate | `otp.provider.timeout` | ≥ 5 in 10 min |
| 429 volume | `rate_limited` | > 50 in 10 min (possible abuse) |
| Misconfiguration | `otp.provider.misconfigured` | **any occurrence → page** |
| Challenge inconsistency | `supersededByNewer` | any occurrence outside a deploy |
| Table growth | `SELECT count(*) FROM otp_sessions` | > 100 k rows |

`pm2 logs` plus `/api/v1/health` remain the operational surface; no monitoring platform is introduced for this feature.

---

## 19. Environment and secret management

### 19.1 New variables (backend only)

| Variable | Required | Default | Notes |
|---|---|---|---|
| `OTP_PROVIDER` | **prod: yes** (`udo`) | `dummy` outside production | `dummy` in production **fails boot** |
| `UDO_OTP_API_KEY` | yes when provider is `udo` | — | GitHub secret → `.env` |
| `UDO_OTP_CONFIG_ID` | yes when provider is `udo` | — | **blocking: value still unknown** |
| `UDO_OTP_BASE_URL` | no | `https://api.uniquedigitaloutreach.com` | documented default |
| `OTP_COOLDOWN_SECONDS` | no | 30 | |
| `OTP_MAX_PER_HOUR` | no | 5 | |
| `OTP_MAX_PER_DAY` | no | 10 | |
| `OTP_MAX_ATTEMPTS` | no | 3 | |
| `OTP_TTL_SECONDS` | no | 300 | ≤ `configId` TTL |
| `OTP_REQUEST_TIMEOUT_MS` | no | 5000 | |
| `OTP_GLOBAL_DAILY_MAX` | no | 500 | |
| `OTP_IP_MAX_PER_HOUR` | no | 20 | |
| `OTP_IP_HASH_SALT` | prod: yes when IP limiting is on | — | random string |
| `OTP_SENDING_ENABLED` | no | `true` | kill switch |

**Not needed:** `UDO_OTP_SENDER_ID`, `UDO_OTP_USERNAME`, template IDs — `configId` carries channel/template/sender/expiry (§4.3).

Names reuse the app's existing `UDO_OTP_*` convention (`docs/UDO_OTP_API.md`, `RUNNING.md`) so operators see one vocabulary.

### 19.2 Validation rules by environment (`shared/utils/env.ts`)

```
production:
  OTP_PROVIDER='dummy'                      -> throw at boot ("must be udo in production")
  OTP_PROVIDER='udo' without key/configId   -> throw at boot
  numeric settings unparseable or <= 0      -> throw at boot
development / test:
  OTP_PROVIDER defaults to 'dummy'; 'udo' allowed when both secrets are present
  dummy provider logs a warning on every send
```

**Fail-closed without bricking the API (decision):** if `NODE_ENV=production` and `OTP_PROVIDER` is **unset**, the server boots and **all OTP endpoints return `503 OTP_DISABLED`** while the rest of the API works. Boot fails **only** for an explicitly invalid configuration (`dummy` in production, or `udo` without credentials). This satisfies "never silently fall back to a fixed code" without turning a forgotten env var into a total outage — which matters because `deploy.yml:58-60` fails the deploy on a boot error.

### 19.3 Secrets handling

- Values reach the VPS through GitHub **secrets** → `.env`; never into git.
- The deploy script must not print values: keep `echo "KEY=${{ secrets.KEY }}" >> .env` (writes a file, not the log), and never add `cat .env`, `set -x`, or a `grep` that echoes a key.
- Verify a secret by **behaviour** (call the endpoint, expect 200/503), never by printing it.
- The Flutter app must contain no `UDO_OTP_*` at all (§13.5).

---

## 20. Deployment and rollback strategy

### 20.1 Rollout order (each step independently deployable)

| Step | Change | Why this order |
|---|---|---|
| 1 | Add `UDO_OTP_API_KEY` + `UDO_OTP_CONFIG_ID` as GitHub secrets | Secrets must exist before code can use them |
| 2 | Add the injection lines to `deploy.yml` **and** remove `npm run seed`; add the seed guard | Pipeline-only change (G18) |
| 3 | Deploy the migration + adapter with `OTP_PROVIDER` unset | OTP endpoints behave as today; schema is additive; nothing user-visible changes |
| 4 | Set `OTP_PROVIDER=udo` in the VPS `.env`, restart | Flips the provider in seconds without a code deploy |
| 5 | Verify send/verify end-to-end with a real number | P2 acceptance (fails closed on any error) |
| 6 | Deploy P3 (delete-OTP, phone change, signup single-use) | Pure backend; the app already calls these routes |

### 20.2 Why not "flip the provider first"

`OTP_PROVIDER` is read at boot, so setting it before the adapter exists does nothing; and the migration must exist before any code writes `status`/`purpose`. Schema → code → flag.

### 20.3 Production must fail closed

| Situation | Behaviour |
|---|---|
| `OTP_PROVIDER=udo`, creds valid, UDO up | normal |
| `OTP_PROVIDER=udo`, UDO down/timeout | `503 OTP_PROVIDER_UNAVAILABLE`; **no** fallback; email-login users can still sign in |
| `OTP_PROVIDER=udo`, UDO rejects key/config | `503 OTP_PROVIDER_MISCONFIGURED` + error log; no fallback |
| `OTP_PROVIDER` unset in production | `503 OTP_DISABLED` (fail closed; API otherwise healthy) |
| `OTP_PROVIDER=dummy` in production | **boot fails**; the deploy's health check catches it |
| `OTP_SENDING_ENABLED=false` | `503 OTP_DISABLED` immediately, without a restart |

**The previous plan's `OTP_PROVIDER=dummy` "emergency rollback" is explicitly rejected.** A fixed `123456` in production lets anyone who knows the code log in as any phone number. An outage must produce a service error, never weaker authentication.

### 20.4 Emergency rollback

1. **Fastest (seconds, no deploy):** set `OTP_SENDING_ENABLED=false` (or unset `OTP_PROVIDER`) in the VPS `.env` → `pm2 restart saath-khata-backend --update-env`. Login degrades to email/password for accounts that have one; **no** insecure path opens.
2. **Code rollback:** revert the OTP commits → push → the pipeline redeploys. The additive schema **stays**, and old code remains compatible because:
   - it still selects `WHERE verified=false AND expires_at > now()`, and new rows keep `verified` in sync (§8.1);
   - it inserts rows without `purpose`/`status`/`provider`, which take the defaults `login`/`pending`/`dummy`;
   - it deletes the previous row for a phone before inserting (`otp.service.ts:36`), so the new partial unique index is never violated.
3. **Challenges created by a failed deployment** are `pending`/`sent` with a 5-minute TTL; they expire on their own and cleanup removes them after 30 days. No manual data surgery.
4. **Never** run `migrate:rollback` in production (§8.3).

### 20.5 Verifying no insecure fallback is live

```
curl -s -X POST $API/auth/otp/send -H 'Content-Type: application/json' \
  -d '{"phone":"<real-number>"}' | jq
```
- Must **not** contain `data.otp`.
- Must return 200 (provider accepted) or 503 (provider/flag) — never 200 with a code.
- `pm2 logs` must show `otp.send.sent` with `provider:"udo"` and must **not** show `otp.dummy_provider_used`.

### 20.6 Deployment-time seeds

**Decision: remove `npm run seed` from the production deploy.** Seeds are development fixtures that delete ledger/order/payment rows for nine hard-coded phones (`seeds/01_test_accounts.ts:44-88`). Also guard the file itself:

```ts
if (process.env.SEED_ALLOWED !== 'true' || process.env.NODE_ENV === 'production') {
  console.warn('Seed skipped: development fixtures are disabled in this environment');
  return;
}
```

Because the deploy forces `NODE_ENV=development` for knex (`deploy.yml:49,52`), a `NODE_ENV`-only guard would **not** work — the explicit `SEED_ALLOWED` flag is the reliable switch. Removing the step is the primary fix; the guard is defence in depth.

### 20.7 Migration behaviour during deploy

`migrate:latest` runs before the app restart, under `NODE_ENV=development` (so knex uses the discrete `DB_*` variables rather than `DATABASE_URL`, `knexfile.ts:7-26`). Migration 20260041 is additive and online-safe at the current table size; it takes a brief `ACCESS EXCLUSIVE` lock on `otp_sessions` only. `[R]` Confirm the table's row count before deploying.

---

## 21. Test strategy

Nothing in this section was executed during this review. Only `npx tsc --noEmit` (backend) was run, and it exited 0.

### 21.1 Commands that actually exist

| Side | Command | Source |
|---|---|---|
| Backend | `npm run lint` (`eslint src --ext .ts --max-warnings 0`) | `package.json:19` |
| Backend | `npm run typecheck` (`tsc --noEmit`) | `package.json:20` |
| Backend | `npm run build` (`tsc -p tsconfig.json`) | `package.json:8` |
| Backend | `npm test` (`vitest run`), `npm run test:coverage` | `package.json:16-18` |
| Backend | `npm run migrate:latest`, `npm run migrate:status` | `package.json:10,13` |
| Flutter | `flutter analyze` | `analysis_options.yaml` present |
| Flutter | `flutter test` | `test/` present; `bloc_test` + `mocktail` at `pubspec.yaml:81-82` |
| Flutter | `flutter build apk --release` | standard; bundle inspection in §13.5 |

There is **no** lint script for the app and **no** integration-test harness; do not invent one.

### 21.2 Provider unit tests (no network, no real SMS)

Fake HTTP layer (inject a `fetch`-compatible stub into `UdoOtpProvider`; never touch the internet):

| Case | Assertion |
|---|---|
| 200 `{data:"uuid",error:null}` on generate | returns `{providerRef:"uuid"}` |
| 200 `{data:"uuid",error:null}` on validate | returns `true` |
| 200 `{error:true,message:"…"}` | throws the mapped typed error, never `false` |
| 400 invalid key / invalid config | `OtpProviderConfigError` |
| 400 `invalid Verify ID` on validate | `false` (treated as wrong code) |
| 401 / 403 / 429 (undocumented) | config / unavailable per §6.3 |
| 500 | `OtpProviderUnavailableError` |
| Timeout (abort) | `OtpProviderUnavailableError`, elapsed ≈ `OTP_REQUEST_TIMEOUT_MS` |
| DNS failure / ECONNRESET | `OtpProviderUnavailableError` |
| Malformed JSON | `OtpProviderProtocolError` |
| 200 with `data: null` | `OtpProviderProtocolError` |
| MSISDN normalisation | `9876543210 → 919876543210`; `+91 98765-43210 → 919876543210`; `12345 → reject` |
| Missing key/config | factory throws at construction |
| `OTP_PROVIDER=dummy` + `NODE_ENV=production` | constructor throws |

### 21.3 OTP service / integration tests (real PostgreSQL, fake provider)

`[V]` The suite uses a real database (`setup.ts:1-27`) and `truncateAll()` — **add `otp_sessions` to `TRUNCATE_ORDER`** (`helpers.ts:10-24`) or state leaks between tests.

| Case | Expected |
|---|---|
| send → verify (correct) | 200, `existingUser:true`, one `refresh_tokens` row, challenge `consumed` |
| verify wrong ×1 | 400 `OTP_INVALID`, `attempts=1` **committed** |
| verify wrong ×3 | 3rd → 429 `OTP_LOCKED`; 4th (even correct) → 429 |
| expired challenge | 400 `OTP_EXPIRED`, no mutation |
| send within cooldown | 429 `OTP_COOLDOWN` + `retryAfterSeconds` ≤ 30, provider **not** called |
| 6 sends in an hour | 6th → 429 `OTP_RATE_LIMITED` |
| daily cap | 11th → 429 |
| global cap | 503 `OTP_DISABLED` |
| provider outage | 503 `OTP_PROVIDER_UNAVAILABLE`, challenge `failed`, retry allowed immediately |
| provider timeout | same, `durationMs` ≈ timeout |
| missing provider config in prod mode | 503 `OTP_PROVIDER_MISCONFIGURED` (or boot failure for `dummy`) |
| purpose confusion: login OTP used on `account_delete` | 400 `OTP_EXPIRED` (no challenge for that purpose) |
| consumed challenge re-verify | 409 `OTP_ALREADY_USED` |
| supersede: new send invalidates old | old row `superseded`; verifying the old code → 400 |
| cleanup job | terminal rows older than 30 days deleted; `sent` rows kept |

---
### 21.4 Concurrency tests (assert database state, not just HTTP codes)

| Scenario | Assertion |
|---|---|
| 10 parallel `send` for one phone | exactly 1 provider call, exactly 1 row in `('pending','sent')`, 9 × 429 |
| 5 parallel `verify` with the same **correct** code | exactly 1 success, exactly 1 `refresh_tokens` row, others 409/429 |
| 5 parallel `verify` with **wrong** codes | `attempts` ends at 3 (not 5); status `locked` |
| 2 parallel `signup` with one token | exactly 1 user row; the other 401 `SIGNUP_TOKEN_USED` |
| 2 parallel `signup`, same phone, different tokens | 1 × 201, 1 × 409 `PHONE_ALREADY_REGISTERED`, never 500 |
| 2 parallel `refresh` with the same token | after P7: exactly 1 success, 1 × 401 |

### 21.5 Security tests

| Test | Expected |
|---|---|
| Brute force 1000 codes | challenge locks after 3; provider called ≤ 3 times |
| SMS flooding one phone | 429 after the hourly cap; provider calls equal allowed sends |
| Flooding many phones from one IP | per-IP limiter (with Redis) rejects; per-phone limits still exact |
| Role escalation: `POST /auth/signup {role:'staff'}` | 422 |
| Staff bypass: staff token on `authorize('vendor')` routes | 403 |
| Staff revoked mid-session | next request 401 (`authenticate.ts:43-50`) |
| Deleted/inactive account login | no tokens issued |
| Delete account without a valid OTP | 400/401, account intact |
| Delete account with a **login** OTP | rejected (purpose isolation) |
| Phone takeover: `PATCH /auth/profile {mobile:<other>}` | 409 `PHONE_VERIFICATION_REQUIRED`, no write |
| OTP returned in any response | grep every OTP response body — none |
| OTP/phone in logs | no `phone`/`otp` values in emitted log lines |
| Secrets in Flutter bundle | no `UDO_OTP_` strings in the release APK |
| `OTP_PROVIDER=dummy` in production | boot fails |
| SQL injection in `phone`/`otp` | 422 (regex), no SQL error logged |

### 21.6 Flutter tests

| Test | Layer |
|---|---|
| `AuthOtpSendRequested` → `AuthOtpSent` | `bloc_test` with a mock repository |
| `sendOtp` failure → `AuthError` with the server message | mock `AuthRepository` |
| Verify success → tokens saved + `AuthAuthenticated` | existing pattern (`auth_bloc_delete_account_test.dart`) |
| Verify new user → `AuthOtpVerifiedNewUser` | bloc |
| Wrong OTP → boxes cleared + toast | widget test on `OtpVerifyScreen` |
| Rate-limited response → "request a new code" copy | widget test (after P6) |
| Resend disabled during countdown | widget test (after P6) |
| Repository parses `{existingUser:false, signupToken}` | `AuthRepositoryImpl` with a mocked Dio |
| Staff role routing | widget test on the router redirect |

### 21.7 Quality gates per phase

| Gate | P0 | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|---|---|---|---|---|---|---|---|---|
| `npm run typecheck` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — | ✅ |
| `npm run lint` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — | ✅ |
| `npm test` (db-backed) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — | ✅ |
| `npm run build` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — | ✅ |
| `flutter analyze` | — | — | — | — | — | ✅ | ✅ | — |
| `flutter test` | — | — | — | — | — | ✅ | ✅ | — |

**Passing unit tests do not prove the authentication system is secure.** §21.5 and the manual gates in §23 are mandatory and cannot be replaced by mocks.

### 21.8 Test-environment rules

- Provider is always the fake one in CI; **no real SMS in automated tests**.
- The DB-backed suite needs `DB_*` + `JWT_*` in `.env.test` (`setup.ts:19-27`) and runs migrations first (`npm run migrate:latest`).
- `NODE_ENV=test` disables the auth limiter (`app.ts:69-70`), so rate-limit tests must exercise the new **OtpService** limits directly rather than relying on `express-rate-limit`.
- Concurrency tests need `fileParallelism: false` retained (`vitest.config.ts:13`) and must not share phone numbers across files.

---

## 22. Phased implementation plan

Each phase is independently reviewable, deployable and revertible. "Files" lists the shape of the change, not an exhaustive diff.

### P0 — Configuration and pipeline readiness (est. 0.5 day) · no user-visible change

| | |
|---|---|
| **Scope** | Make it safe to inject provider secrets and stop production seeding |
| **Files** | `.github/workflows/deploy.yml`; `seeds/01_test_accounts.ts`; `src/app/shared/utils/env.ts` |
| **Changes** | Add `UDO_OTP_API_KEY` / `UDO_OTP_CONFIG_ID` injection (same sed+append pattern as `:29-37`); **remove** `npm run seed` (`:52`); add the `SEED_ALLOWED` guard to the seed file; extend `validateEnv()` with the OTP rules from §19.2, gated on `OTP_PROVIDER` so an unset provider changes nothing |
| **Dependencies** | The two secrets must be created in GitHub **before** this deploy |
| **Tests** | `typecheck`, `lint`, `npm test`, `build`; a dry run of the deploy on a branch |
| **Acceptance** | Deploy is green; `otp_sessions`/`users` unchanged; a fresh clone without `SEED_ALLOWED` seeds nothing; `.env` on the VPS contains the two new keys **without** the values appearing in the CI log |
| **Rollback** | Revert the workflow commit; secrets are inert until code reads them |
| **Risk** | A malformed injection line could truncate `.env`. Mitigate by appending (never rewriting) and by verifying with the health check that already exists |

### P1 — Migration + provider adapter, provider still disabled (est. 1.5 days) · no user-visible change

| | |
|---|---|
| **Scope** | Schema and code that can run the real provider, with `OTP_PROVIDER` unset |
| **Files** | `migrations/20260041_otp_challenge_state.ts`; `src/infrastructure/sms/{otpProvider.types,udoOtp.provider,dummyOtp.provider,otpProvider.factory}.ts`; `src/app/modules/auth/services/otp.service.ts` (behaviour-preserving refactor only); `src/__tests__/helpers.ts` (add `otp_sessions` to truncate) |
| **Changes** | Additive migration (§8) + backfill; provider interface + UDO adapter + dummy adapter + factory; replace the hardcoded `123456` with `provider.generate()` **only** when a provider is configured, keeping the dummy path otherwise |
| **Dependencies** | P0 |
| **Tests** | §21.2 in full; `typecheck`, `lint`, `npm test`, `build` |
| **Acceptance** | Migration applies and rolls back cleanly on a scratch DB; `migrate:status` clean; with `OTP_PROVIDER` unset the API behaves **exactly** as before (dummy code, no SMS) |
| **Rollback** | Code rollback only (schema stays, §20.4) |
| **Risk** | The unique index fails on legacy duplicate rows → the backfill (§8.2) must run first, in the same migration |

### P2 — Real OTP through UDO (est. 2 days) · the main event, still no app release

| | |
|---|---|
| **Scope** | Real send/verify, purpose-scoped state machine, cooldown, ACID semantics, error codes, logging |
| **Files** | `otp.service.ts` (rewrite), `otp.controller.ts`, `auth.validators.ts` (`.strict()`), `auth.routes.ts` (mount delete-otp in P3, not here), `AppError.ts` (new typed errors / `retryAfterSeconds`), `errorHandler.ts` (emit `retryAfterSeconds`), `auth.service.ts` (remove the duplicated `_buildAuthResponse` usage in `OtpService`), `jobs/queues/index.ts` + `tokenCleanup.processor.ts` (cleanup job) |
| **Changes** | §9.1 send, §9.2 verify, §11 limits, §12 codes (incl. **401 → 400 `OTP_INVALID`**), §18 logging; response loses `data.otp` |
| **Dependencies** | P1 + the real `configId` |
| **Tests** | §21.3, §21.4, relevant §21.5 |
| **Acceptance** | A real phone receives an SMS; the response contains no code; 3 wrong codes → `OTP_LOCKED`; immediate resend → `OTP_COOLDOWN`; concurrent sends produce one SMS; failed attempts are visible in the DB; provider outage → 503 with **no** fallback |
| **Rollback** | `OTP_SENDING_ENABLED=false` (seconds), then code rollback |
| **Risk** | Provider semantics differ from the docs (attempts/expiry). Mitigate by keeping our own attempt budget and TTL authoritative, and by testing with a real number on a staging build before enabling production |

---
### P3 — Authentication integrity: delete-account OTP, phone change, signup single-use (est. 1.5 days) · no app release

| | |
|---|---|
| **Scope** | Close G9, G11, G12, G14 |
| **Files** | `auth.routes.ts`, `auth.controller.ts`, `auth.service.ts`, `otp.service.ts` (+ `OtpChallengeRepository`), `auth.validators.ts`, `src/__tests__/delete-account.test.ts` |
| **Changes** | `POST /auth/account/delete-otp` + `DELETE /auth/account {otp\|password}` (§16.1); `mobile` change → `409 PHONE_VERIFICATION_REQUIRED` + `phone/change-request|confirm` (§16.2); signup token carries `challengeId` and is consumed atomically (§9.3); `23505` → 409 mapping |
| **Dependencies** | P2 (needs purposes + the consume primitives) |
| **Tests** | §21.3 delete/phone/signup rows; §21.4 parallel-signup rows; §21.5 takeover rows; extend `delete-account.test.ts` |
| **Acceptance** | A phone user can delete their account in the app **without a new release**; a login OTP cannot delete an account; the typed confirmation is actually verified server-side; changing `mobile` to another number is refused; a replayed signup token is refused; duplicate phone/email return 409, not 500 |
| **Rollback** | Code rollback; no schema change |
| **Risk** | Blockers are unchanged but deletion now requires a fresh OTP — the seed/e2e script `scripts/delete-account-e2e.ts` and `delete-account.test.ts` must be updated in the same PR |

### P4 — Email/password coherence, optional (est. 0.5 day)

| | |
|---|---|
| **Scope** | G10 + G21 only. No new email flow |
| **Files** | `auth.validators.ts` (`currentPassword` optional), `auth.service.ts` (`UnauthorizedError` → `BadRequestError` for a wrong current password), app `change_password_screen.dart` (hide the current-password field when the user has none — needs a release, can ship later) |
| **Changes** | OTP-only users get a clean "set a password" path; a wrong current password stops force-logging users out |
| **Dependencies** | P2 (error codes) |
| **Tests** | password set with no prior hash; wrong current password → 400 not 401; email login still works afterwards |
| **Acceptance** | An OTP-only user can set a password and then use `/auth/email-login`; a wrong current password no longer clears the session |
| **Rollback** | Code rollback |
| **Risk** | Making `currentPassword` optional must be conditional on `password_hash IS NULL` in the **service**, not just the schema — otherwise it weakens password change for users who do have one |

### P5 — Staging verification and production rollout (est. 1 day)

| | |
|---|---|
| **Scope** | Prove it, then flip the flag |
| **Steps** | 1) Full suite green on a staging DB; 2) real OTP to a real handset for customer, vendor and staff; 3) verify the **old installed app version** still logs in (emulator with the current release build); 4) deploy P1–P3 to production with `OTP_PROVIDER` unset; 5) set `OTP_PROVIDER=udo`, restart; 6) `curl` checks from §20.5; 7) watch logs for 24 h |
| **Acceptance** | §23 table for P5; zero `otp.provider.misconfigured`; send success ≥ 95 %; no response contains a code; no `otp.dummy_provider_used` in production logs |
| **Rollback** | §20.4 |
| **Risk** | Enabling the flag during peak hours multiplies blast radius. Enable in a low-traffic window; `OTP_GLOBAL_DAILY_MAX` caps the damage |

### P6 — Flutter release hygiene (est. 2 days + store review)

| | |
|---|---|
| **Scope** | Remove the bundled key; add countdown + error handling; accessibility; optional staff role card |
| **Files** | `api_client.dart`, `main.dart`, `pubspec.yaml`, delete `udo_otp_config.dart` + `udo_otp_service.dart` + their tests, `otp_verify_screen.dart`, `phone_entry_screen.dart`, `role_selection_screen.dart`, ARB files |
| **Changes** | §13.2–13.5, §A of G16 |
| **Dependencies** | P2 in production (the UI changes assume real limits exist) |
| **Tests** | §21.6; `flutter analyze`; `flutter test`; release-bundle inspection |
| **Acceptance** | Release APK contains no `UDO_OTP_`/`API_KEY` strings; resend respects the server countdown; each error code produces a distinct message; staff can log in without guessing "Vendor" |
| **Rollback** | Previous store release stays installable; the backend is version-agnostic |
| **Risk** | Removing `flutter_dotenv` breaks any *future* feature that starts using `.env` between planning and release — re-grep before deleting |

### P7 — Separate authentication-integrity fixes (est. 1–2 days)

| | |
|---|---|
| **Scope** | Refresh rotation (§9.4), stale test suite rewrite (`auth.test.ts`), `email-signup` identity convergence decision (G19) |
| **Files** | `auth.repository.ts`, `auth.service.ts`, `src/__tests__/auth.test.ts` |
| **Dependencies** | none (deliberately deferred so it cannot destabilise P2) |
| **Acceptance** | Concurrent refresh yields exactly one token pair; the rewritten `auth.test.ts` exercises real routes and passes |
| **Rollback** | Code rollback |
| **Risk** | `refresh_tokens` gets a `replaced_by_hash` column → needs its own additive migration (20260042) |

---

## 23. Acceptance criteria (per phase, verifiable)

| Phase | Must be demonstrably true |
|---|---|
| P0 | Secrets exist in GitHub; deploy injects them without printing values; `npm run seed` is gone from the production deploy; `SEED_ALLOWED` guards the seed file; deploy is green; health check passes |
| P1 | `migrate:latest` applies on a copy of production data; `migrate:rollback` restores the previous shape **on that copy**; `migrate:status` clean; with `OTP_PROVIDER` unset the OTP endpoints behave byte-for-byte as today; provider unit tests green with zero network calls |
| P2 | Real SMS received; response has no `otp` field; wrong code ×3 → `429 OTP_LOCKED`; 4th attempt with the *correct* code still `429`; resend inside cooldown → `429 OTP_COOLDOWN` with `retryAfterSeconds`; 10 parallel sends → 1 SMS; `attempts` incremented and committed after a failed guess; provider outage → `503` and **no** fallback; `OTP_PROVIDER=dummy` in production refuses to boot |
| P3 | Phone user deletes the account from the **existing** app build; a `login` OTP cannot delete; delete with a wrong OTP leaves the account intact; a phone change to a foreign number is refused with `409`; a replayed signup token is refused; duplicate phone/email → `409` (never 500) |
| P4 | OTP-only user sets a password and then logs in with email; a wrong current password returns `400` and does **not** clear the session |
| P5 | Old app build + new backend: customer, vendor and staff all log in; send success ≥ 95 % over 24 h; zero misconfiguration events; no code in any response body; kill switch verified |
| P6 | Release bundle contains no provider key; resend countdown matches the server; each error code shows a distinct message; `flutter analyze` + `flutter test` green; staff login requires no role guessing |
| P7 | Concurrent refresh → one pair; rewritten `auth.test.ts` passes; `email-signup` behaviour documented as either retained or deprecated |

---

## 24. Risk register

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|---|
| R1 | `UDO_OTP_CONFIG_ID` unknown/wrong → no OTP possible | High (currently unknown) | Blocks P2 | Obtain before P1 merge; `OTP_PROVIDER` stays unset until verified | Product |
| R2 | Provider expiry/attempt semantics differ from assumptions | Medium | Users locked out earlier than expected | Keep local TTL/attempts authoritative; confirm via UDO support (§4.4) | Backend |
| R3 | SMS cost blow-out (abuse or bug) | Medium | Financial | Per-phone/hour/day + global cap + kill switch; alerts | Backend |
| R4 | Provider outage blocks all logins | Medium | Total login outage | 503 fail-closed + email/password remains for legacy accounts; documented runbook | Ops |
| R5 | Deploy-order mistake (code before secrets) | Medium | Failed deploy (recoverable) or 503s | §20.1 order; `OTP_PROVIDER` unset by default | Ops |
| R6 | Migration lock on a large `otp_sessions` | Low | Seconds of write blocking on that table only | Confirm row count first (§8.4); table is small | Backend |
| R7 | Multiple pm2 instances → per-IP limits ineffective | Unknown [R] | Cost/abuse | Per-phone DB limits are primary and exact | Ops |
| R8 | Wrong-OTP 401 regression reintroduced | Low | Users bounced mid-login | Covered by §21.5 "wrong OTP returns 400" test | Backend |
| R9 | Old app versions break | Low | Login outage | Contract preserved (§5.4); verified with an installed build in P5 | QA |
| R10 | `delete-account` flow still broken after P3 | Low | Store-compliance failure | P3 acceptance explicitly uses the existing app build; `scripts/delete-account-e2e.ts` updated | QA |
| R11 | Seed guard bypassed by a future workflow change | Low | Data loss | Remove the step entirely + guard + code review of `deploy.yml` | Ops |
| R12 | Flutter release blocked by store review | Medium | Key stays in the bundle longer | Not a security dependency for login; track separately | Mobile |

---

## 25. Unresolved questions and external dependencies

### 25.1 Blocking (backend cannot finish P2 without these)

| # | Question | Owner |
|---|---|---|
| Q1 | The real UDO **`configId`** | Product/UDO |
| Q2 | The **TTL and OTP length** configured on that `configId` | Product/UDO |
| Q3 | Does a **wrong validate consume an attempt** provider-side, and how many attempts before invalidation? | UDO support |
| Q4 | Does a **new generate** for the same MSISDN invalidate the previous `verifyId`? | UDO support |
| Q5 | Is there **IP allowlisting** or a concurrency cap on the account? | UDO support |
| Q6 | Does `configId` carry a **DLT-approved template/sender**? | Product/UDO |

### 25.2 Runtime facts to confirm on the VPS

| # | Question |
|---|---|
| Q7 | Is `pm2` running one process or N (cluster mode)? — determines per-IP limiter effectiveness |
| Q8 | Is `WORKERS_ENABLED=true` set for a worker process? — determines whether cleanup runs |
| Q9 | How many proxy hops are in front of Express? — determines whether `req.ip` is the real client |
| Q10 | Does the live `users.role` CHECK include `'staff'`, and in which migration? |
| Q11 | Current `otp_sessions` row count |

### 25.3 Product decisions

| # | Decision | Default if unanswered |
|---|---|---|
| D1 | Daily per-phone cap: 10 (recommended) vs 30 (previous plan) | 10 |
| D2 | Global daily cap (500) and who is paged when it trips | 500, on-call engineer |
| D3 | Keep or retire `POST /auth/email-signup` (G19) | keep, deprecated in docs |
| D4 | Phone change revokes sessions? | no |
| D5 | Is the staff role card in scope for the next release? | P6, optional |
| D6 | SMS budget owner + alert threshold | product owner |

Engineering-resolvable without product input: challenge model, concurrency strategy, error codes, retry policy, migration shape, cleanup retention, test matrix.

---

## 26. Definition of done

The OTP integration is done when **all** of the following are true:

1. `OTP_PROVIDER=udo` in production; a real handset receives a code; no response body ever contains a code.
2. `otp_sessions` has purposes, states, one active challenge per `(phone,purpose)`, a durable attempt counter, and 30-day cleanup.
3. Cooldown, hourly, daily, per-IP and global limits are enforced server-side, and a rejected request never reaches UDO.
4. Wrong code → `400 OTP_INVALID`; locked → `429 OTP_LOCKED`; outage → `503` — and none of them clears the user's session.
5. A phone user can delete their account from the shipped app build, with server-side OTP confirmation and unchanged blocker rules.
6. A phone number can only be attached after proving control of it.
7. Signup tokens are single-use, bound to a consumed challenge and a phone, and consumed atomically with account creation.
8. `OTP_PROVIDER=dummy` cannot run in production; an unset provider fails closed.
9. The production deploy no longer seeds fixtures and injects the provider secrets without printing them.
10. §21.2–21.5 pass; §21.6 passes for the release build; the previous app version still works.
11. Log metrics exist for send success, verify success, provider latency, timeouts, 429s and misconfiguration.
12. This document matches what was actually built (update it in the same PR as any deviation).

---

## Appendix A — File map

### A.1 Backend (`../saath_khata_backend`)

| Path | Role in this plan |
|---|---|
| `src/app/modules/auth/services/otp.service.ts` | Core rewrite: send/verify state machine (currently dummy) |
| `src/app/modules/auth/controllers/otp.controller.ts` | Request parsing; response envelope |
| `src/app/modules/auth/routes/auth.routes.ts` | Add delete-otp + phone-change routes |
| `src/app/modules/auth/validators/auth.validators.ts` | `.strict()` OTP schemas; delete/phone-change schemas |
| `src/app/modules/auth/services/auth.service.ts` | Signup single-use, delete confirmation, phone-change guard, password errors |
| `src/app/modules/auth/repositories/auth.repository.ts` | Refresh rotation (P7) |
| `src/app/modules/auth/middleware/{authenticate,authorize,effectiveVendor}.ts` | Unchanged; why staff revocation is immediate |
| `src/app/shared/errors/AppError.ts` | New typed errors + `retryAfterSeconds` |
| `src/app/shared/middlewares/errorHandler.ts` | Emit `retryAfterSeconds` |
| `src/app/shared/utils/env.ts` | OTP env validation |
| `src/infrastructure/sms/*` | **New**: provider interface, UDO adapter, dummy adapter, factory |
| `src/infrastructure/jobs/{queues,processors}` | OTP cleanup job |
| `migrations/20260041_otp_challenge_state.ts` | **New** additive migration |
| `seeds/01_test_accounts.ts` | Production-unsafe; guard |
| `.github/workflows/deploy.yml` | Secret injection; remove seeding |
| `src/__tests__/{helpers,delete-account,auth}.test.ts` | Truncate list, new coverage, stale rewrite |

### A.2 App (`saath_khata`)

| Path | Role |
|---|---|
| `lib/core/network/api_endpoints.dart` | Endpoint constants (already include `deleteAccountOtp`) |
| `lib/core/network/api_client.dart` | 401→refresh behaviour (**why 401 must be reserved**), redaction set |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | OTP + delete/confirm calls (already correct) |
| `lib/features/auth/presentation/bloc/auth_bloc.dart` | Role-mismatch logic, post-login side effects |
| `lib/features/auth/presentation/screens/{phone_entry,otp_verify,change_password}_screen.dart` | P6 UX |
| `lib/features/settings/presentation/widgets/delete_account_flow.dart` | Client half of deletion (blocked today by the missing route) |
| `lib/core/config/udo_otp_config.dart`, `lib/features/auth/data/services/udo_otp_service.dart` | **Delete in P6** |
| `pubspec.yaml`, `lib/main.dart` | Remove `.env` asset + `flutter_dotenv` |

---

## Appendix B — Corrections to the previous version of this plan

| # | Previous claim | Verified reality | Consequence |
|---|---|---|---|
| B1 | Wrong-OTP 401 implication not called out | 401 on `/auth/otp/verify` triggers the app's refresh interceptor and force-logout (`api_client.dart:48-90`) | **New blocking finding**; wrong OTP moves to `400 OTP_INVALID` (P2) |
| B2 | "OTP users can never set a password" (🔴, P3) | The service already allows it when `password_hash IS NULL` (`auth.service.ts:474-478`); only the schema/UI force a dummy `currentPassword` | Downgraded to 🟡 UX, moved to P4, reframed as "optional current password" |
| B3 | "Account deletion deletes on JWT alone" | True only for **phone-less** accounts; phone accounts are dead-ended at the missing `delete-otp` route (`delete_account_flow.dart:36-41`) | Two distinct defects; P3 covers both with no app release |
| B4 | `deploy.yml:87-107`, `app.ts:85-98`, `helpers.ts:117` | Real locations: `deploy.yml:29-60`, `app.ts:68-85`, `helpers.ts:10-24` | Citations corrected |
| B5 | Rollback via `OTP_PROVIDER=dummy` | Rejected: a fixed code in production is an authentication bypass | Replaced by kill switch + fail-closed + code rollback |
| B6 | OTP cleanup via a new worker | The existing `token-cleanup` queue/worker is job-name-agnostic | No new worker |
| B7 | Refresh race scheduled in P2 | Not a dependency of OTP correctness | Moved to P7 |
| B8 | Rate limits described generically | `skipSuccessfulRequests: true` is the specific reason successful sends are uncapped (`app.ts:76`) | Called out as G4 |
| B9 | Seeds described as "idempotent test accounts" | The seed **deletes** ledger/order/payment rows for nine phones and runs on every production deploy (`seeds/01_test_accounts.ts:44-88`, `deploy.yml:52`) | Promoted to 🔴 G18 and fixed in P0 |
| B10 | Phone-change fix assumed a hard block was safe | The app sends `mobile` on every profile save (`edit_profile_screen.dart:181-183`) | Changed to "no-op allowed, change requires OTP" |
| B11 | Staff/delivery role ambiguity | Confirmed again: no `delivery` role; delivery staff are `role='staff'` | Persona flows written accordingly (§14) |

---

## Appendix C — What was inspected, and what was not

**Backend read:** all auth sources (`otp.service`, `otp.controller`, `auth.controller`, `auth.service`, `auth.repository`, `auth.types`, `auth.validators`, `auth.routes`, the three middlewares, `token.service`), `AppError`, `errorHandler`, `response.ts`, `requestLogger`, `logger`, `env.ts`, `app.ts`, `server.ts`, `constants`, `connection.ts`, `redis/client.ts`, `jobs/queues`, `tokenCleanup.processor`, `staff.service.ts`, `knexfile.ts`, `vitest.config.ts`, `__tests__/{auth,delete-account}.test.ts`, `__tests__/{helpers,setup}.ts`, migrations `20260001/20260017/20260021`, `seeds/01_test_accounts.ts`, `package.json`, `deploy.yml`, plus directory listings of `migrations/`, `seeds/`, `scripts/`.

**App read:** `main.dart`, `pubspec.yaml`, `api_client.dart`, `api_endpoints.dart`, `app_router.dart` (routes + redirect), `auth_state_notifier.dart`, `storage_service.dart`, `app_logger.dart`, `injection.dart`, `auth_bloc/auth_event/auth_state`, `phone_entry_screen`, `otp_verify_screen`, `role_selection_screen`, `change_password_screen`, `edit_profile_screen` (mobile handling), `delete_account_flow`, `auth_repository_impl`, `udo_otp_config`, `udo_otp_service`, and the `test/` listing.

**Fetched:** the three UDO documentation pages listed in §4.

**Not inspected / not verifiable from here:** the VPS (pm2 mode, proxy hops, `.env`), the live schema and row counts, the UDO dashboard (`configId`, TTL, DLT template), production Redis, the production `users.role` CHECK, and any real provider response (no OTP was sent).

**Executed:** `npx tsc --noEmit` in the backend → exit 0. Nothing else: no test suite, no migration, no deploy, no SMS.

**Changed:** only this file. No application code, migration, secret, workflow or production configuration was modified.
