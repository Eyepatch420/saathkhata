# F000 — Master Implementation Plan

**Status:** READY FOR REVIEW  
**Last Updated:** 2026-06-30

---

## 1. OVERVIEW

This document defines the implementation order for all planned features, prioritized by dependency, risk, and business impact. All planning documents must be read before implementation begins.

---

## 2. CRITICAL BUGS TO FIX FIRST (before any feature work)

These are bugs in the currently deployed codebase that must be fixed immediately.

### BUG-001 🔴 Order Delivery Does Not Update Balance

**File:** `saath_khata_backend/src/app/modules/orders/services/order.service.ts`
**Impact:** Link balance never updates when orders are delivered. Customer's outstanding balance will always be 0 from the vendor's perspective even after deliveries.
**Fix:** Add `await this.linkRepo.adjustBalance(order.link_id, orderTotal, trx)` inside the `delivered` transaction, before commit.
**Effort:** 15 minutes. Run `npm run build` then push to trigger CI/CD.

### BUG-002 🟡 Email Login Ambiguous for Dual Accounts

**File:** `saath_khata_backend/src/app/modules/auth/services/auth.service.ts` — `emailLogin()`
**Impact:** If same email is used for both vendor and customer, the login picks arbitrarily.
**Fix:** Pass `role` in email login body, query `WHERE email = ? AND role = ?`.
**Effort:** 30 minutes backend + 15 minutes frontend (pass role from `EmailLoginScreen`).

### BUG-003 🟡 No Push Notification on Entry Dispute

**File:** `saath_khata_backend/src/app/modules/ledger/services/ledger.service.ts` — `disputeEntry()`
**Impact:** Vendor doesn't know when customer disputes their entry. Silent until vendor checks the app.
**Fix:** Add `enqueueNotification` call after dispute transaction commits.
**Effort:** 10 minutes.

---

## 3. FEATURE IMPLEMENTATION ORDER

### Phase 1 — Database Foundation (No UI yet)

All migrations run first to establish the correct schema before any feature code is written.

| Order | Migration | Feature | Description |
|-------|-----------|---------|-------------|
| 1 | `20260034_add_location_to_customer_profiles` | F001 | Add lat/lng/address to customer_profiles |
| 2 | `20260035_vendor_multi_category` | F003 | Add business_categories TEXT[], backfill, GIN index |

These two migrations are independent and can be written/tested together. Run them in number order.

**After migrations:** Update seeds.
- Add `8000000001` vendor + `8000000002` customer with location to `seeds/01_test_accounts.ts`

---

### Phase 2 — Backend Services

Build all backend changes before touching Flutter. This ensures the API is stable before frontend development.

#### Phase 2A — Customer Location (F001 Backend)

**Files to change:**

1. `src/app/modules/auth/types/auth.types.ts`
   - Add `customerLatitude?`, `customerLongitude?`, `customerAddress?` to `SignupInput`
   - Add `customerLocation?` to `UserProfileResponse`

2. `src/app/modules/auth/repositories/auth.repository.ts`
   - Update `createCustomerProfile()` to accept + insert location fields
   - Add `updateCustomerProfile()` method

3. `src/app/modules/auth/services/auth.service.ts`
   - `signup()`: pass location to `createCustomerProfile()` for customer role
   - `updateProfile()`: add customer location update path
   - `_toProfileResponse()`: include customer location in response

4. `src/app/modules/auth/validators/auth.validators.ts`
   - Add optional `customerLatitude`, `customerLongitude`, `customerAddress` to signup + update schemas

5. `src/app/modules/auth/controllers/auth.controller.ts`
   - Pass customer location fields from req.body to service

**Build + Push:** `npm run build` → push → wait for CI

#### Phase 2B — Vendor Multi-Category (F003 Backend)

**Files to change:**

1. `src/app/modules/auth/types/auth.types.ts`
   - Add `businessCategories?: string[]` to `SignupInput` and `UserProfileResponse`

2. `src/app/modules/auth/repositories/auth.repository.ts`
   - Update `createVendorProfile()` to handle `business_categories TEXT[]`

3. `src/app/modules/auth/services/auth.service.ts`
   - `signup()`: normalize `businessCategory`/`businessCategories` → write both columns
   - `updateProfile()`: handle `businessCategories` array
   - `_toProfileResponse()`: include `businessCategories` in vendor profile

4. `src/app/modules/auth/validators/auth.validators.ts`
   - Add `businessCategories: z.array(z.string()).max(5).optional()` to signup + update schemas

5. `src/app/modules/search/services/search.service.ts`
   - Update category filter to use array containment: `vp.business_categories @> ARRAY[?]`

**Build + Push:** `npm run build` → push → wait for CI

#### Phase 2C — Email Signup (F002 Backend)

**Files to change:**

1. `src/app/modules/auth/routes/auth.routes.ts`
   - Add `POST /auth/email-signup` route

2. `src/app/modules/auth/validators/auth.validators.ts`
   - Add `emailSignupSchema` validator

3. `src/app/modules/auth/controllers/auth.controller.ts`
   - Add `emailSignup` controller method

4. `src/app/modules/auth/services/auth.service.ts`
   - Add `emailSignup()` method (no signupToken required)

5. Fix BUG-002 in same PR: update `emailLogin()` to accept + require `role`, query `WHERE email=? AND role=?`

**Build + Push**

#### Phase 2D — Auto-Confirm Cron + Bug Fixes

1. Fix BUG-001: `order.service.ts` — add `adjustBalance` call in delivered branch
2. Fix BUG-003: `ledger.service.ts` — add dispute notification
3. Add `auto-confirm` queue + worker (72h auto-confirm for pending entries)

**Build + Push**

---

### Phase 3 — Frontend

#### Phase 3A — Customer Location UI (F001 Flutter)

Build first because it's small and isolated.

**Files to change:**

1. `lib/features/auth/presentation/screens/profile_setup_screen.dart`
   - Show `LocationPickerTile` for customer role (currently vendor-only)
   - Pass `customerLatitude`, `customerLongitude`, `customerAddress` in `AuthSignupRequested`

2. `lib/features/auth/presentation/bloc/auth_event.dart`
   - Add `customerLatitude`, `customerLongitude`, `customerAddress` to `AuthSignupRequested`

3. `lib/features/auth/presentation/bloc/auth_bloc.dart`
   - Pass customer location to `authRepository.signup()`

4. `lib/features/auth/domain/repositories/auth_repository.dart`
   - Add customer location params to `signup()` abstract method

5. `lib/features/auth/data/repositories/auth_repository_impl.dart`
   - Include customer location in POST /auth/signup body

6. `lib/features/auth/data/models/user_model.dart`
   - Add `customerLocation` field (or explicit lat/lng/address fields)

7. `lib/features/auth/data/models/auth_response_model.dart`
   - Parse `customerLocation` from response

8. `lib/features/customer/presentation/screens/customer_profile_screen.dart`
   - Display customer location if set

9. `lib/features/auth/presentation/screens/edit_profile_screen.dart`
   - Allow editing customer location

#### Phase 3B — Vendor Multi-Category UI (F003 Flutter)

**Files to change:**

1. **New file:** `lib/core/constants/vendor_categories.dart`
   - Extract `kVendorCategories` list

2. `lib/features/auth/presentation/screens/profile_setup_screen.dart`
   - Replace single `DropdownButtonFormField` with multi-select `FilterChip` wrap
   - Use `List<String> _selectedCategories` state

3. `lib/features/auth/presentation/bloc/auth_event.dart`
   - Add `businessCategories: List<String>?` to `AuthSignupRequested`

4. `lib/features/auth/data/repositories/auth_repository_impl.dart`
   - Include `businessCategories` in signup body

5. `lib/features/auth/data/models/user_model.dart`
   - Add `businessCategories: List<String>` field

6. `lib/features/auth/presentation/screens/edit_profile_screen.dart`
   - Multi-select chip UI for editing categories

7. `lib/features/search/presentation/screens/vendor_profile_screen.dart`
   - Show categories joined: `category1 · category2`

#### Phase 3C — Auth Redesign (F002 Flutter)

More complex. Requires Phase 3A and 3B to be done first (EmailSignupScreen reuses their widgets).

**New screens:**

1. **New:** `lib/features/auth/presentation/screens/auth_landing_screen.dart`
   - Single role selection (radio/pill, not checkbox) + Phone vs Email choice
   - Replace current dual-select `RoleSelectionScreen`

2. **New:** `lib/features/auth/presentation/screens/email_signup_screen.dart`
   - Full signup form (name, email, password, confirm)
   - Role-specific fields: vendor → BusinessName, multi-category chips, location
   - Customer → location picker (from F001)

**Modified screens:**

3. `lib/features/auth/presentation/screens/email_login_screen.dart`
   - Add `role` param to body (fix BUG-002 frontend)
   - Add "Sign up with email instead" link → navigates to EmailSignupScreen

4. `lib/features/auth/presentation/screens/profile_setup_screen.dart`
   - Remove role toggle (role comes from auth flow)
   - Accept role in route extra

5. `lib/features/auth/presentation/screens/otp_verify_screen.dart`
   - Pass `role` in profileSetup push extra

**New event:**

6. `lib/features/auth/presentation/bloc/auth_event.dart`
   - Add `AuthEmailSignupRequested` event

7. `lib/features/auth/presentation/bloc/auth_bloc.dart`
   - Handle `AuthEmailSignupRequested`

8. `lib/features/auth/domain/repositories/auth_repository.dart`
   - Add `emailSignup()` abstract method

9. `lib/features/auth/data/repositories/auth_repository_impl.dart`
   - Implement `emailSignup()` → POST /auth/email-signup

10. `lib/core/router/app_router.dart`
    - Add `authLanding` and `emailSignup` routes
    - Update `_publicRoutes`

11. `lib/core/network/api_endpoints.dart`
    - Add `emailSignup` endpoint constant

---

## 4. DEPENDENCY GRAPH

```
BUG-001 ──────────────────────────────────────────────────────► FIX
BUG-002 ──────────────────────────────────────────────────────► FIX
BUG-003 ──────────────────────────────────────────────────────► FIX

Migration 20260034 (customer location) ──► Phase 2A ──► Phase 3A
Migration 20260035 (multi-category) ────► Phase 2B ──► Phase 3B
Phase 2A + Phase 2B ─────────────────────────────────► Phase 2C (email-signup uses same profile fields)
Phase 3A + Phase 3B ─────────────────────────────────► Phase 3C (EmailSignupScreen uses location + category widgets)

Phase 2D (auto-confirm + balance fix) — independent, can be done anytime
```

---

## 5. IMPLEMENTATION SEQUENCE (RECOMMENDED)

```
Week 1:
  Day 1: BUG-001 + BUG-002 + BUG-003 (backend) → build + push
  Day 2: Migration 20260034 + Migration 20260035 + seed update → build + push
  Day 3: Phase 2A (customer location backend) → build + push
  Day 4: Phase 2B (multi-category backend) → build + push
  Day 5: Phase 2D (auto-confirm cron, partial) → build + push

Week 2:
  Day 1-2: Phase 3A (customer location flutter)
  Day 3-4: Phase 3B (vendor multi-category flutter)
  Day 5:   Phase 2C (email-signup backend) → build + push

Week 3:
  Day 1-3: Phase 3C (auth redesign flutter — most complex)
  Day 4-5: Integration testing with all 3 test phones
```

---

## 6. TESTING MILESTONES

After each phase, test with the specified phones:

| Phase | Test | Phones |
|-------|------|--------|
| Bug fixes | Order delivery → balance updates | `8000000001` (vendor), `8000000002` (customer) |
| F001 | New customer signup with location | `8000000002` |
| F001 | Existing customer add location via edit profile | `8000000002` |
| F003 | Vendor signup with 2+ categories | `8000000001` |
| F003 | Search vendors by category | Customer phone |
| F002 | Email signup (vendor) | test-email-vendor@test.com |
| F002 | Email signup (customer) | test-email-customer@test.com |
| F002 | Email login after signup | same emails |
| F002 | OTP flow still works after auth redesign | `8000000001`, `8000000002` |
| Khata | End-to-end: order → delivery → payment → balance=0 | `8000000001`, `8000000002`, staff `7500000001` |

---

## 7. IMPORTANT NOTES FOR IMPLEMENTATION

### 7.1 Before Any Push

Always run:
```bash
cd /Users/hacksman/Developer/Flutter/saath_khata_backend
npm run build
# fix any TypeScript errors
git push
# wait for GitHub Actions CI to pass
```

### 7.2 Test Phones

- Vendor: `8000000001` (to be added to seed)
- Customer: `8000000002` (to be added to seed, WITH location: Bandra West, Mumbai)
- Staff: `7500000001` (to be set up after vendor account exists)
- OTP for all: `123456`

### 7.3 Feature Flag / Rollback Order

If a feature needs rollback:
1. Run migration `down()` if schema was changed
2. Revert backend service changes
3. Revert frontend changes
4. Re-seed test data

### 7.4 Do Not Merge Until

- [ ] TypeScript builds without errors (`npm run build`)
- [ ] Migration runs without errors on fresh DB
- [ ] Migration `down()` works cleanly
- [ ] OTP login still works for existing test accounts
- [ ] Khata balance is correct after order delivery (BUG-001 fix verified)

---

## 8. NEW FEATURES — IMPLEMENTATION ORDER (F005–F011)

### Phase 4 — Ledger Logic Fixes (no UI, high impact)

These change core ledger behavior and must ship before any UI work that depends on them.

| Order | Feature | Effort | Description |
|-------|---------|--------|-------------|
| 1 | **F007** Confirm/Dispute Logic | BE 2h + FE 2h | Vendor credits → auto_confirmed immediately. No migration needed. |
| 2 | **F008** Dues Fix | FE 1h | Filter dues to credits-only. No backend change. |
| 3 | **F006** Auto-Confirm Toggle | BE 2h + FE 2h + Migration 20260036 | Per-link `customer_auto_confirm` flag. Add after F007. |

**F007 must ship first** — it changes what "pending" means and what "dues" contains. F008 fix depends on understanding the new dues definition.

#### Phase 4 Backend (F007)

1. `src/app/modules/ledger/services/ledger.service.ts`
   - In `addEntry()`: detect `isVendorSide && type in ['credit','adjustment']` → set `status='auto_confirmed'`, `is_locked=true`, call `adjustBalance()` in same transaction
   - Change push notification message for auto_confirmed credits

2. `src/app/modules/ledger/validators/ledger.validators.ts`
   - Add optional env-flag check `VENDOR_CREDIT_AUTO_CONFIRM`

**Build + Push**

#### Phase 4 Frontend (F007 + F008)

1. `AddEntrySheet` or ledger entry tile widget — remove "Confirm" button for credit entries
2. `LedgerBloc._applyFilter()` — change dues filter: `type == EntryType.credit` condition added
3. Test: vendor adds credit → appears auto_confirmed; payment entries gone from dues

#### Phase 4 Backend + Migration (F006)

1. Migration `20260036_customer_auto_confirm_on_links.ts` — ADD `customer_auto_confirm BOOLEAN DEFAULT true`
2. `PATCH /links/:id/auto-confirm` endpoint
3. `addEntry()`: check `link.customer_auto_confirm` for non-vendor-credit entries (post-F007, this mainly affects edge cases)

---

### Phase 5 — Schedule/Subscription System (F005)

Largest new system. Depends on F007 (ledger entries created by cron should be auto_confirmed).

#### Phase 5 DB Migration (20260037)

Three new tables: `scheduled_services`, `service_subscriptions`, `scheduled_deliveries`

See `docs/features/F005_schedule_subscription/FEATURE_DOC.md` for full schema.

#### Phase 5 Backend

1. New module: `src/app/modules/schedule/` — routes, controllers, services, repositories, types, validators
2. BullMQ queue: `scheduled-deliveries` — daily cron, processes active subscriptions
3. Key endpoints: CRUD for services, subscribe/unsubscribe customers, manual deliver, skip

**Build + Push**

#### Phase 5 Frontend

1. Vendor: `ServicesListScreen`, `ServiceDetailScreen`, `CreateServiceSheet`
2. Customer: `CustomerSubscriptionsScreen`, vendor profile subscription opt-in
3. Staff: today's scheduled deliveries in `StaffHomeScreen`
4. New `ScheduleBloc/Cubit`

---

### Phase 6 — Ledger Enhancements (F009 + F010)

Depends on F007 (auto_confirmed entries), F005 (scheduled deliveries appear in Deliveries tab).

#### Phase 6 Backend (F009)

1. `GET /links/:id/entries` — add filter params: `from`, `to`, `type`, `amount_min`, `amount_max`
2. Sort change: `ORDER BY date DESC, created_at DESC` (also covers F010 backdated sort)

#### Phase 6 Frontend (F009)

1. Tab restructure in `SharedLedgerScreen`
2. Date divider widgets (grouped by `entry.date`)
3. Monthly view in Deliveries tab
4. `LedgerFilter` model + filter bottom sheet
5. Pagination: `LoadMoreLedger` event, append to entries list

#### Phase 6 Frontend (F010 — Backdated Entries)

1. Date picker in `AddEntrySheet` — defaults to today, allows past year
2. Backend validator for date range (no future, max 1yr)
3. Sort order: `ORDER BY date DESC` (same change as F009)

---

### Phase 7 — Auth + Discovery Enhancements (F002 + F011)

F002 depends on F001+F003. F011 depends on F003 (businessCategories).

| Order | Feature | Effort |
|-------|---------|--------|
| 1 | **F002** Auth Redesign (already planned in phases 2C/3C) | BE 3h + FE 4h |
| 2 | **F011** Vendor Discovery by Category | FE 2h only |

F011 is frontend-only: add `CategoryFilterRow` and grouped view to `MyKhatasScreen`.

---

## 9. COMPLETE DEPENDENCY GRAPH

```
BUG-001 ──────────────────────────────────────────────────► FIX (order delivery balance)
BUG-002 ──────────────────────────────────────────────────► FIX (email login role filter)
BUG-003 ──────────────────────────────────────────────────► FIX (dispute notification)

F007 ─────────────────────────────────────────────────────► F008 (dues = credits only)
F007 ─────────────────────────────────────────────────────► F006 (F006 scope clarified)
F007 + F005 ──────────────────────────────────────────────► F009 (scheduled deliveries tab)

Migration 20260034 (customer location) ───► Phase 2A ────► Phase 3A
Migration 20260035 (vendor multi-category) ► Phase 2B ────► Phase 3B
Migration 20260036 (auto-confirm flag) ───► Phase 4 F006
Migration 20260037 (schedule tables) ─────► Phase 5

Phase 3A + Phase 3B ─────────────────────────────────────► Phase 3C (F002 email signup)
Phase 3B (businessCategories) ───────────────────────────► F011 (category grouping)

F009 + F010 sort change (same backend change) ───────────► ship together
```

---

## 10. FULL IMPLEMENTATION SEQUENCE

```
Week 1 — Bug fixes + foundation:
  Day 1: BUG-001 + BUG-002 + BUG-003 → build + push
  Day 2: Migration 20260034 + 20260035 + seed update → build + push
  Day 3: Phase 2A (customer location backend) → build + push
  Day 4: Phase 2B (multi-category backend) → build + push
  Day 5: F007 backend (vendor credit auto-confirm) → build + push

Week 2 — Ledger fixes + Flutter phase 3A/3B:
  Day 1: F008 frontend (dues filter fix) + F007 frontend (remove confirm button)
  Day 2-3: Phase 3A (customer location flutter)
  Day 4-5: Phase 3B (vendor multi-category flutter — checkbox M3 UI)

Week 3 — Auth redesign + auto-confirm:
  Day 1: Phase 2C (email signup backend) + F006 migration + backend → build + push
  Day 2-3: Phase 3C (auth redesign flutter — most complex)
  Day 4: F006 flutter (auto-confirm toggle in settings)
  Day 5: Integration test all 3 phones

Week 4 — Schedule system:
  Day 1-2: Migration 20260037 + F005 backend (schedule module) → build + push
  Day 3-5: F005 flutter (vendor + customer + staff screens)

Week 5 — Ledger enhancements:
  Day 1-2: F009 backend (filter params + sort change) → build + push
  Day 3-4: F009 flutter (date dividers, tabs, filter sheet, pagination)
  Day 5: F010 flutter (date picker in AddEntrySheet) + backend date validation

Week 6 — Final polish:
  Day 1: F011 flutter (vendor discovery by category in MyKhatasScreen)
  Day 2-3: End-to-end test: subscription flow + ledger + all 3 roles
  Day 4-5: Regression testing + buffer
```

---

## 11. FEATURE DOCUMENT REFERENCES

| Feature | Document |
|---------|----------|
| F001 Customer Location | `docs/features/F001_customer_location/FEATURE_DOC.md` |
| F002 Auth Redesign | `docs/features/F002_auth_redesign/FEATURE_DOC.md` |
| F003 Multi-Category | `docs/features/F003_vendor_multi_category/FEATURE_DOC.md` |
| F004 Khata Flow | `docs/features/F004_khata_flow/FEATURE_DOC.md` |
| F005 Schedule/Subscription | `docs/features/F005_schedule_subscription/FEATURE_DOC.md` |
| F006 Auto-Confirm Toggle | `docs/features/F006_auto_confirm_toggle/FEATURE_DOC.md` |
| F007 Confirm/Dispute Logic | `docs/features/F007_confirm_dispute_logic/FEATURE_DOC.md` |
| F008 Dues Fix | `docs/features/F008_dues_fix/FEATURE_DOC.md` |
| F009 Ledger Enhancements | `docs/features/F009_ledger_enhancements/FEATURE_DOC.md` |
| F010 Backdated Entries | `docs/features/F010_backdated_entries/FEATURE_DOC.md` |
| F011 Vendor Discovery | `docs/features/F011_customer_vendor_discovery/FEATURE_DOC.md` |
