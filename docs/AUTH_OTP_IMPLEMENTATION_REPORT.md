# Auth & OTP Implementation Report — Real UDO OTP

**Companion to:** `docs/AUTH_OTP_INTEGRATION_PLAN.md`
**Repositories:** `saath_khata` (Flutter) · `saath_khata_backend` (Node/Express/Knex/PostgreSQL)
**Date:** 2026-10-25
**Readiness verdict:** **READY FOR STAGING** — see §H. Live UDO acceptance is blocked on the real `configId` (§F).

---

## A. Changes made

### Backend (`saath_khata_backend`)

| File | Change | Security / correctness improvement |
|---|---|---|
| `src/infrastructure/sms/otpConfig.ts` *(new)* | Typed, validated OTP configuration (`parseOtpConfig`, `getOtpConfig`). | Invalid limits fail startup instead of silently disabling protection. `OTP_PROVIDER` unset ⇒ disabled (503), never a dummy fallback. `dummy` in production throws. Unknown provider names throw. |
| `src/infrastructure/sms/otpProvider.types.ts` *(new)* | Provider interface + typed errors (`Unavailable`, `Config`, `Protocol`, `InvalidNumber`) + `maskPhone`/`toMsisdn`. | An outage can never be reported as a wrong OTP, and a wrong OTP is never retried. |
| `src/infrastructure/sms/udoOtp.provider.ts` *(new)* | UDO `POST /v1/verify` + `/v1/verify/validate` adapter using `fetch` + `AbortController`, bounded by `OTP_REQUEST_TIMEOUT_MS`, no retries. | Four explicit success checks (status → JSON → `error !== true` → non-empty `data`); a non-empty `data` on an error status is *not* accepted as success; no provider message reaches a client; key/`verifyId` never logged. |
| `src/infrastructure/sms/dummyOtp.provider.ts` *(new)* | Development/test provider; throws when constructed with `NODE_ENV=production`. | A fixed code can never authenticate a production user. |
| `src/infrastructure/sms/otpProvider.factory.ts` *(new)* | Memoised provider resolution; no fallback. | Misconfiguration fails closed. |
| `migrations/20260041_otp_challenge_state.ts` *(new)* | Additive `otp_sessions` columns (`purpose`, `status`, `provider`, `provider_ref`, `ip_hash`, `context`, `consumed_at`, `signup_consumed_at`, `verify_lease_until`), `otp_hash` nullable, CHECK constraints, partial unique index on active `(phone, purpose)`, lookup/expiry/terminal indexes. | Purpose-scoped, single-use, provider-backed challenges with a database-level guarantee of at most one active challenge per phone+purpose. Legacy rows are retired to `expired` **before** the unique index is built. |
| `src/app/modules/auth/repositories/otpChallenge.repository.ts` *(new)* | All OTP SQL: `reserve` (advisory lock, cool-down, hourly/daily/global caps, supersede, insert), `markSent`/`markFailed`, lease claim, atomic failed-attempt increment, conditional consume, signup-token burn, batched retention. | Race-safe counters; no transaction is ever held across a network call. The cool-down counts in-flight `pending` rows too, so parallel sends cannot fire two SMS (verified by a 10-way concurrency test); a `failed` row is excluded, so an outage still allows an immediate retry. |
| `src/app/modules/auth/services/otp.service.ts` *(rewritten)* | Send (reserve → provider → confirm) and verify (lease → provider → consume+settle) state machines; per-IP limiter (Redis with a bounded timeout, in-memory fallback); signup-token signing/binding; privacy-safe structured logs. | Removes the hard-coded `123456`, the returned OTP, and the 401-for-wrong-code behaviour. |
| `src/app/modules/auth/services/authResponse.builder.ts` *(new)* | Single session-minting path shared by password login, OTP login and signup. | The refresh-token insert can run inside the challenge-consume transaction, so no session exists without a consumed challenge. |
| `src/app/modules/auth/errors/otp.errors.ts` *(new)* | Stable public codes (`OTP_INVALID`, `OTP_EXPIRED`, `OTP_LOCKED`, `OTP_COOLDOWN`, `OTP_RATE_LIMITED`, `OTP_VERIFY_IN_PROGRESS`, `OTP_NOT_READY`, `OTP_ALREADY_USED`, `OTP_PROVIDER_UNAVAILABLE`, `OTP_PROVIDER_MISCONFIGURED`, `OTP_DISABLED`, `OTP_INVALID_NUMBER`). | Wrong OTP is **400**, never 401 (the Flutter Dio interceptor would have force-logged-out). |
| `src/app/shared/errors/AppError.ts`, `middlewares/errorHandler.ts` | Optional `retryAfterSeconds` (+ `Retry-After` header), error-code overrides, `ServiceUnavailableError`. | Enables 409/429/503 semantics without changing the envelope shape. |
| `src/app/modules/auth/services/auth.service.ts` | Signup burns its signup token inside the create transaction and maps PG `23505` to 409; `mobile` change requires OTP proof (`409 PHONE_VERIFICATION_REQUIRED`); `POST /auth/account/delete-otp` + confirmation-verified deletion (the shipped client's password-in-`otp` payload is still accepted for phone-less accounts and bcrypt-verified); phone change request/confirm; wrong current password → 400; OTP-only accounts may set a password. | Closes signup-token replay, phone takeover, unverified account deletion, and the "wrong password logs you out" defect — without requiring an app release. |
| `src/app/modules/auth/services/token.service.ts` | Adds `jti` to refresh tokens. | Two logins in the same second no longer collide on the unique token hash (previously a 500 during rotation). |
| `controllers/{otp,auth}.controller.ts`, `routes/auth.routes.ts`, `validators/auth.validators.ts` | Strict Zod schemas, new protected endpoints, shared OTP service wiring. | Rejects unknown properties (a client cannot choose a privileged purpose); validates before any expensive work. |
| `types/auth.types.ts`, `repositories/auth.repository.ts` | Challenge row shape, purposes/statuses, signup payload, `createRefreshToken(…, trx)`. | Type-safe transaction-aware session creation. |
| `src/app/shared/utils/env.ts` | Validates OTP configuration at boot. | Malformed limits/provider config fail fast; unset provider keeps the API healthy with OTP disabled. |
| `src/app/shared/utils/seedGuard.ts` *(new)* + `seeds/01,02` | Seeds refuse to run without `SEED_ALLOWED=true`, on `NODE_ENV=production`, or when `DATABASE_URL` is set. | Stops the seed (which deletes ledger/order/payment rows for nine fixed phones) from ever touching a deployment database. |
| `.github/workflows/deploy.yml` | Removed `npm run seed`; secrets (Cloudinary/Gemini/UDO/OTP_PROVIDER) are passed as env vars and written with a non-echoing `upsert_env`; a missing secret leaves the existing value intact. | No destructive seeding on deploy, no secret values in CI logs or the remote process list. |
| `src/infrastructure/jobs/{queues,tokenCleanup.processor}.ts`, `bootstrap/server.ts` | `cleanup-otp` repeat job on the existing queue; the processor dispatches on job name; bounded, batched deletion of terminal challenges older than 30 days. | `otp_sessions` no longer grows without bound; no new worker/process. |
| `migrations/20260013_production_indexes.ts` | Added `export const config = { transaction: false }`. | Pre-existing defect: `CREATE INDEX CONCURRENTLY` inside a transaction made a *fresh* database unmigratable. |
| `src/__tests__/*` | Rewrote stale suites; added `otp.test.ts`, `otpProvider.test.ts`, OTP cases in `auth.test.ts` and `delete-account.test.ts`, a `createActiveLink` helper, and `otp_sessions` in the truncate list. | See §C. |
| `.env.example` *(new, untracked by the repo's gitignore)* | Documents every variable, including the OTP block. | Operational clarity without secrets. |
| `.env.test` *(local, git-ignored)* | Disposable test database + dummy provider. | DB-backed tests can never point at a live database. |

---

## B. Implementation status

| Phase | Status | Notes |
|---|---|---|
| **P0 — Deployment/config safety** | **COMPLETE** | Seed step removed from `deploy.yml`; `SEED_ALLOWED` + environment guards (verified by running the seeds against a scratch DB); secrets injected without echoing; `env.ts` validates the OTP config; `.env.example` documented. |
| **P1 — Schema + provider infrastructure** | **COMPLETE** | Migration applied to a disposable database, and up → down → up verified on a second scratch database; UDO/dummy adapters + factory; adapter unit tests with a fake HTTP layer. |
| **P2 — Real OTP (send/verify, limits, errors, cleanup, kill switch)** | **COMPLETE (mock-verified)** | The live UDO call is the only unverified element (§F). |
| **P3 — Authentication integrity** | **COMPLETE** | `POST /auth/account/delete-otp`, confirmation-verified deletion (incl. shipped-client payload), phone-change endpoints, `409 PHONE_VERIFICATION_REQUIRED`, single-use signup tokens, `23505 → 409`. |
| **P4 — Password/email compatibility** | **COMPLETE** | `currentPassword` optional for OTP-only accounts; wrong password is `400 INVALID_CREDENTIALS`; email login otherwise unchanged. |
| **P5 — Staging/production readiness** | **PARTIALLY COMPLETE** | Automated suite green; real-SMS verification, staging DB, installed-app compatibility and a kill-switch rehearsal still need an environment (§F). |
| **P6 — Flutter release hygiene** | **COMPLETE (code)** | Provider code/credentials removed, log redaction, server-driven countdown, code-aware errors; `flutter analyze` clean and tests green. Store release + bundle inspection pending. |
| **P7 — Additional auth-integrity fixes** | **PARTIALLY COMPLETE** | Stale tests rewritten; refresh-token `jti` collision fixed (it caused a 500 during rotation). The full atomic refresh-rotation race remediation is **not** implemented — see §F. |

---

## C. Test results

All commands were run in this session. Nothing is quoted from an earlier run.

| Command | Result |
|---|---|
| `npm run typecheck` (backend) | **PASS** — `tsc --noEmit`, exit 0 |
| `npm run build` (backend) | **PASS** — `tsc --project tsconfig.json`, exit 0 |
| `npx vitest run` (backend) | **PASS** — full run: **8 files / 125 tests**, exit 0. The final hardening (cool-down now also covers in-flight `pending` sends) plus one more concurrency test were added afterwards; the three affected suites (`otp`, `auth`, `delete-account`) were re-run: **70/70 passed**. The other five suites were untouched by that change and passed in the full run. Suite total is now 126. |
| `npm run migrate:latest` against `saath_khata_test` | **PASS** — 29 migrations applied in batch 2, exit 0 |
| Scratch DB: `migrate:latest` → insert rows → `migrate:down 20260041` → `migrate:up 20260041` | **PASS** — 41 migrations in batch 1; the down step removed the provider-backed row, restored `otp_hash NOT NULL` and dropped the new columns/indexes; the re-up succeeded. Scratch DB dropped afterwards. |
| Seed-guard smoke test on the scratch DB | **PASS** — `seed:run` refused ("SEED_ALLOWED=true is required"), and refused again with `SEED_ALLOWED=true` + `DATABASE_URL` set ("indicates a deployment database"), before any write. |
| `psql -c '\d otp_sessions'` | **PASS** — all new columns, 2 CHECK constraints and 4 indexes present |
| `flutter analyze` | **PASS** — "No issues found!" |
| `flutter test` | **PASS** — **23 tests**, exit 0 |
| `npm run lint` (backend) | **NOT RUNNABLE** — `eslint: command not found`; `eslint` is not a dependency of the repo and no config exists. Pre-existing gap, unrelated to this work. |

### Backend suites

| File | Tests | What it proves |
|---|---|---|
| `auth.test.ts` | 27 | send metadata with no OTP/`verifyRef`; strict schemas; cool-down; failed-send retry; wrong OTP → `400 OTP_INVALID`; 3-strike lockout; expired challenge; consumed replay → `409`; existing-user login creates exactly one refresh token; new-user signup token; signup replay → `401 SIGNUP_TOKEN_USED`; staff self-signup → 422; refresh rotation; logout revocation; email login success and `400 INVALID_CREDENTIALS`; wrong current password → `400`; OTP-only password set; phone-change no-op/blocked/verified/duplicate; 5-way verify concurrency; concurrent wrong guesses stay within the budget. |
| `otp.test.ts` | 11 | hourly/daily/global caps (with provider-call counts), kill switch, outage → `503` + `failed` row + no stored ref, immediate retry after outage, misconfiguration mapping, verification outage does not consume an attempt, purpose isolation, retention/cleanup, and ten parallel sends collapsing to one provider call / one active challenge. |
| `otpProvider.test.ts` | 24 | adapter success, invalid number, 200-with-`error:true`, 401/403, 429/5xx, data-present-on-error-status is not success, malformed JSON, missing `data`, timeout/abort, DNS failure, validate → true/false, config refusal, dummy-in-production refusal, config defaults/bounds, MSISDN + masking. |
| `delete-account.test.ts` | 32 | existing blocker/soft-delete behaviour plus: missing OTP, wrong OTP, login-purpose OTP rejected, password-required path for phone-less accounts, `USE_PASSWORD_CONFIRMATION`, refresh-token revocation, identifier reuse, and shipped-client compatibility (password arriving in the `otp` field for phone-less accounts). |
| `ledger.test.ts`, `links.test.ts`, `remind-all.test.ts`, `device-tokens.test.ts` | 32 | unchanged product behaviour, with stale helpers rewritten for the current routes and the F006 entry lifecycle. |

### Flutter suites

`auth_contract_test.dart` (error-code semantics + send-result parsing), `auth_bloc_delete_account_test.dart`, and the settings delete-account widget tests (23 total).

### Tests that were already failing before this work (rewritten, not deleted)

| Suite | Why it failed | Resolution |
|---|---|---|
| `auth.test.ts` | Targeted `POST /auth/signup` with an email/password body and `POST /auth/login`, both removed when auth moved to phone OTP. | Rewritten against the current OTP + email-login routes. |
| `links.test.ts`, `ledger.test.ts`, `remind-all.test.ts` | Created links through `POST /links`, which no longer exists (connections go through `/link-requests`). They silently ran on `undefined` link ids. | Link setup moved to a documented `createActiveLink` helper / the request-accept flow; ledger expectations updated to the F006 auto-confirm + counterparty-confirm lifecycle. |
| `device-tokens.test.ts` | Expected `400` where the shared Zod layer returns `422 VALIDATION_ERROR`. | Expectations corrected. |
| `delete-account.test.ts` (2 cases) | Assumed a wrong password returns `401`, and that deletion keeps the email on the row. | Corrected to `400 INVALID_CREDENTIALS` and to the "identifiers are freed" behaviour added by commit `4d2510a`. |
| `test/widget_test.dart` | Untouched Flutter counter template; the app construction was commented out, so it asserted on an empty tree. | Replaced with `auth_contract_test.dart`. |

### Not run (environment-dependent)

Live UDO generate/validate, real SMS delivery, staging-database verification, an installed old-app build against the new backend, and release-bundle inspection. See §F.

---

## D. Security verification (evidence)

| Requirement | Evidence |
|---|---|
| No OTP in any response | `auth.test.ts` serialises the whole `/otp/send` and `/otp/verify` bodies and asserts the dummy code and `providerRef` are absent. Response shape is `{sent, expiresInSeconds, resendAfterSeconds}`. |
| No provider key in the Flutter bundle | `lib/core/config/udo_otp_config.dart`, `lib/features/auth/data/services/udo_otp_service.dart` and their tests are deleted; `UDO_OTP_*` is removed from the app `.env`/`.env.example`; the only remaining `.env` key is `LOCATIONIQ_API_KEY`. (APK inspection still to be run on a release build.) |
| Production dummy-provider rejection | `parseOtpConfig({NODE_ENV:'production', OTP_PROVIDER:'dummy'})` throws; `new DummyOtpProvider({nodeEnv:'production'})` throws; and a live `validateEnv()` call with `NODE_ENV=production OTP_PROVIDER=dummy` aborts startup with `Invalid OTP configuration: OTP_PROVIDER=dummy is not permitted in production. Use OTP_PROVIDER=udo.` |
| Rate limits enforced | DB-backed cool-down / hourly / daily / global caps asserted in `otp.test.ts` (provider call count stays at the allowed number) and in `auth.test.ts` (`OTP_COOLDOWN` + `retryAfterSeconds`). |
| Correct 401/400 semantics | `auth.test.ts`: wrong OTP → `400 OTP_INVALID`; wrong current password → `400 INVALID_CREDENTIALS`; wrong email password → `400 INVALID_CREDENTIALS`; missing/invalid bearer → `401`. |
| Single-use verification | Conditional `UPDATE … WHERE status='sent'` consume; `auth.test.ts` asserts a consumed challenge replays as `409 OTP_ALREADY_USED`, and 5 parallel verifies produce exactly one session. |
| Single-use signup token | Token carries the consumed `challengeId`; the burn runs inside the account-creation transaction; `auth.test.ts` replays a token and gets `401 SIGNUP_TOKEN_USED` with one user row. |
| Account deletion confirmation | `POST /auth/account/delete-otp` + OTP-verified `DELETE`; `delete-account.test.ts` covers missing OTP, wrong OTP, login-purpose OTP (rejected), and the password path for phone-less accounts. |
| Phone-change verification | `PATCH /auth/profile {mobile: other}` → `409 PHONE_VERIFICATION_REQUIRED`; change-request/confirm flow proves ownership; duplicate numbers → `409 PHONE_ALREADY_REGISTERED`. |
| Production seed protection | Seed step removed from the workflow; `assertSeedingAllowed()` refuses without `SEED_ALLOWED=true`, on `NODE_ENV=production`, or when `DATABASE_URL` is set. |
| Concurrency correctness | Advisory lock serialises sends; verification lease prevents parallel validation; atomic attempt counter; conditional consume. Asserted against DB state in `auth.test.ts` and `otp.test.ts`. |
| Privacy-safe logging | Only `maskPhone(...)`, challenge id, purpose, provider, duration and an 8-char IP hash prefix are logged. The Flutter API logger now redacts `otp`, passwords, tokens and `apikey`. |
| Existing-app compatibility (no release) | Request/response shapes are unchanged (`{phone}`, `{phone,otp}`, `{existingUser,user,tokens}`/`{signupToken}`). `DELETE /auth/account` still accepts the shipped client's single `{otp}` field — for phone-less accounts that value is the password and is bcrypt-verified (tested). The OTP screen's countdown comes from the *new* response metadata, which the old client simply ignores. |

---

## E. Database changes

**Migration:** `20260041_otp_challenge_state.ts` (additive).

- Columns: `purpose`, `status`, `provider`, `provider_ref`, `ip_hash`, `context`, `consumed_at`, `signup_consumed_at`, `verify_lease_until`; `otp_hash` made nullable.
- Constraints: `otp_sessions_status_check`, `otp_sessions_purpose_check`.
- Indexes: `otp_sessions_one_active_idx` (partial unique on `(phone,purpose)` where status is active), `otp_sessions_phone_purpose_created_idx`, `otp_sessions_expires_pending_idx`, `otp_sessions_terminal_created_idx`.
- Backfill: all legacy rows → `expired` (they can never be validated by a provider), then a defensive de-duplication pass, then the unique index.

**Connection pooling:** pool max 20; no query in the OTP path holds a connection across a network call.

**Tested on a disposable database:** `saath_khata_test` (created for this work, no production data). `migrate:latest` ran 29 migrations in one batch and `\d otp_sessions` confirmed the schema above.

**Up/down/up verified on a second scratch database** (`saath_khata_mig_test`, dropped afterwards): all 41 migrations applied from empty; two sample rows inserted (one provider-backed with `otp_hash IS NULL`); `migrate:down 20260041_otp_challenge_state.ts` succeeded and left the original 7-column table with `otp_hash NOT NULL`; `migrate:up` re-applied cleanly.

**Production was not touched.** The `down()` path is destructive by design (it deletes provider-backed rows to restore `NOT NULL`), which is why the documented rollback is an application-only revert, never `migrate:rollback`.

**Cleanup:** `cleanup-otp` repeat job every 6 h on the existing `token-cleanup` queue, deleting terminal challenges older than 30 days in 5 000-row batches, plus a bounded per-phone opportunistic delete on the send path.

---

## F. Remaining blockers (external)

| # | Blocker | Impact | Owner |
|---|---|---|---|
| 1 | Real UDO **`configId`** | Cannot generate a real OTP; `OTP_PROVIDER` must stay unset in production until it exists. | Product / UDO |
| 2 | UDO answers to plan §4.4: configured TTL, OTP length/format, whether a wrong validate consumes a provider attempt, whether a new generate invalidates the previous `verifyId`, IP allowlisting/concurrency caps, DLT template/sender on the config | Our local TTL/attempt budget stays authoritative either way, but the UX (how many provider-side attempts remain) is unknown. | UDO support |
| 3 | Product decisions plan §25.3 (daily cap 10 vs 30, global cap 500 + paging, keep/retire `email-signup`, phone-change session revocation, staff role card, SMS budget owner) | Defaults are implemented (10 / 500 / keep / no revocation); confirmation needed. | Product |
| 4 | VPS facts: pm2 mode (single vs cluster), `WORKERS_ENABLED`, proxy hop count, live `users.role` CHECK, current `otp_sessions` row count | Per-IP limits are only meaningful with the right proxy hops; cleanup only runs with a worker. | Ops |
| 5 | Staging sign-off: real-SMS send/receive on a controlled number, installed old-app compatibility, kill-switch rehearsal, release-bundle inspection | P5/P6 acceptance criteria; not executable from this environment. | QA / Ops |
| 6 | Refresh-token rotation race (two concurrent refreshes can both mint pairs) | Not OTP-related; the same-second token collision that caused a **500** is fixed, but the full atomic revoke-and-issue is still open (P7). | Backend |

---

## G. Deployment instructions

### 1. GitHub secrets (repo → Settings → Secrets)

| Secret | Value |
|---|---|
| `UDO_OTP_API_KEY` | UDO dashboard API key (server-side only) |
| `UDO_OTP_CONFIG_ID` | The verification-config ID for this account |
| `OTP_PROVIDER` | `udo` **only after** staging verification; leave empty/unset before that |

Existing secrets (VPS, Cloudinary, Gemini) are unchanged. Values are passed as environment variables and written with a non-echoing helper, so they never appear in the workflow log.

### 2. VPS `.env` (one-time, before enabling OTP)

The workflow preserves existing lines. Confirm these exist on the server:

```
OTP_PROVIDER=udo
OTP_SENDING_ENABLED=true
OTP_IP_HASH_SALT=<random, >= 16 chars>
OTP_COOLDOWN_SECONDS=30
OTP_MAX_PER_HOUR=5
OTP_MAX_PER_DAY=10
OTP_MAX_ATTEMPTS=3
OTP_TTL_SECONDS=300
OTP_REQUEST_TIMEOUT_MS=5000
OTP_GLOBAL_DAILY_MAX=500
OTP_IP_MAX_PER_HOUR=20
```

No secret values are printed anywhere. `OTP_IP_HASH_SALT` is required in production whenever `OTP_PROVIDER` is set (startup fails otherwise).

### 3. Deploy order

1. Merge code with `OTP_PROVIDER` **unset** → the app boots, migrations run, OTP endpoints answer `503 OTP_DISABLED`, and every other API keeps working.
2. Health check: `curl -fsS http://127.0.0.1:3001/api/v1/health`.
3. Set `OTP_PROVIDER=udo` (secret + rerun the workflow, or edit `.env` and `pm2 restart saath-khata-backend --update-env`).
4. Smoke test with a controlled number: `POST /api/v1/auth/otp/send {"phone":"<test>"}` → `200` with `{sent,expiresInSeconds,resendAfterSeconds}` and **no** `otp` field; confirm the SMS arrives; verify the code; confirm `GET /api/v1/health` stays green.
5. Watch logs for `otp.provider.misconfigured` / `otp.provider.timeout`.

### 4. Validation commands (before enabling)

```bash
npm run typecheck && npm run build && npm test   # requires a disposable DB (.env.test)
flutter analyze && flutter test                 # app repo
curl -fsS http://127.0.0.1:3001/api/v1/health
```

### 5. Rollback

| Situation | Action |
|---|---|
| Provider outage or bad configuration | `OTP_SENDING_ENABLED=false` + restart → instant `503 OTP_DISABLED`, everything else keeps working. |
| Bad code release | Revert the commit and redeploy. The migration is additive, so older code keeps working against the migrated schema (`verified` is still maintained). |
| Never | `npm run migrate:rollback` in production (the `down()` deletes provider-backed rows), and never `OTP_PROVIDER=dummy` in production. |

---

## H. Readiness verdict

**READY FOR STAGING.**

Backend typecheck/build/tests pass, the migration is verified on a disposable database, the provider boundary is unit-tested with a fake HTTP layer, and the auth flows (wrong OTP, lockout, cooldown, purpose isolation, account deletion, phone change, signup replay) are covered by DB-backed tests. The Flutter client builds clean and its tests pass with the provider code removed.

Production activation still requires the real `configId`, a staging SMS round-trip on a controlled number, the VPS facts in §F, and explicit deployment authorization. Those are environmental dependencies, not code gaps.
