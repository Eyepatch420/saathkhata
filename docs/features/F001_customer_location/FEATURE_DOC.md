# F001 — Customer Location

**Status:** PLANNING  
**Priority:** HIGH (prerequisite for nothing, but needed by search & delivery)  
**Estimated Effort:** Backend 2h · Frontend 3h · Migration 0.5h · Seed update 0.5h

---

## 1. WHAT EXISTS TODAY

### 1.1 Database — `customer_profiles`

Created in `migrations/20260003_create_customer_profiles.ts`:

```
customer_profiles
  id          UUID PK
  user_id     UUID FK → users.id (CASCADE, UNIQUE)
  created_at  TIMESTAMP
  updated_at  TIMESTAMP
```

**No location columns.** The table is intentionally lean (comment in migration says location is future).

### 1.2 Database — `vendor_profiles` (contrast)

Vendors have `latitude DECIMAL(10,8)` and `longitude DECIMAL(11,8)` added via `migrations/20260016_add_location_to_vendor_profiles.ts`. This migration added nullable coordinates to vendor_profiles only.

### 1.3 Backend — Auth Service (`src/app/modules/auth/services/auth.service.ts`)

`signup()` creates `customer_profile` with only `{ user_id: newUser.id }` — no location fields accepted.

`updateProfile()` accepts `businessLatitude`/`businessLongitude` for vendors only. No location params for customer update path.

`_toProfileResponse()` returns `vendorProfile.businessLatitude/Longitude` but no equivalent for customers.

### 1.4 Backend — Auth Types (`src/app/modules/auth/types/auth.types.ts`)

`SignupInput` has no `customerLatitude` / `customerLongitude` fields.  
`UserProfileResponse` has no `customerLocation` equivalent.

### 1.5 Backend — Auth Repository (`src/app/modules/auth/repositories/auth.repository.ts`)

`createCustomerProfile()` only inserts `{ user_id }`.

### 1.6 Frontend — Profile Setup (`lib/features/auth/presentation/screens/profile_setup_screen.dart`)

Vendor signup already shows `LocationPickerTile` for `_role == 'vendor'`. When `_role == 'customer'`, no location picker is shown.

`_handleSignup()` does not pass any location for customers.

### 1.7 Frontend — Models

`lib/shared/models/location_model.dart` — `LocationData` exists: `{ displayName, latitude, longitude }`.

### 1.8 Test Seed (`seeds/01_test_accounts.ts`)

Existing test customers:
- `9111100002` — Zara Khan (no location, `customer_profiles` row with only `user_id`)
- `9111100003` — Rohit Verma (no location)
- `9111100004` — Neha Gupta (no location)

**The user mentions phones `8000000001` (vendor) and `8000000002` (customer). These do NOT exist in the seed. The seed uses the `9111100001`–`9111100006` range.** This feature document will address adding location to `8000000002`. This likely means a **new seed entry** must be added, or the user wants to add an additional dedicated test account.

---

## 2. WHAT NEEDS TO CHANGE

### 2.1 Database Migration (NEW)

Add `latitude` and `longitude` columns to `customer_profiles`. Follow the exact same pattern as vendor location migration.

**New migration file:** `migrations/20260034_add_location_to_customer_profiles.ts`

```typescript
export async function up(knex: Knex): Promise<void> {
  await knex.schema.alterTable('customer_profiles', (table) => {
    table.decimal('latitude', 10, 8).nullable();
    table.decimal('longitude', 11, 8).nullable();
    table.text('address').nullable(); // human-readable display string from reverse-geocode
  });
}
```

**Why `address` column too?** Vendor profiles store location via `business_address` in the `vendor_profiles` table. Customers need an equivalent so the address string (from LocationIQ reverse-geocode) persists and is shown in the UI without re-querying the geocoding API on every screen load.

**Why nullable?** Existing customers have no location. We cannot make it NOT NULL without a default or backfill, and a default coordinate would be wrong data.

### 2.2 Seed Update — Add `8000000002` customer WITH location

The user explicitly requested: "add the location of already existing customer with phone number 8000000002."

**Action:** Add a new entry to the seed for phone `8000000002` as a customer with a location. Also add `8000000001` as the vendor this customer links to (matching the user's stated test phone pairs).

**New seed section** (idempotent, checks-then-inserts):

```typescript
// PRIMARY TEST PAIR (user-specified test phones)
// Vendor:   8000000001  
// Customer: 8000000002  (with location: Bandra, Mumbai)
```

Location coordinates for `8000000002`: latitude `19.0596`, longitude `72.8295`, address `Bandra West, Mumbai - 400050`.

### 2.3 Backend — Auth Types

Add to `SignupInput`:

```typescript
customerLatitude?: number | null;
customerLongitude?: number | null;
customerAddress?: string | null;
```

Add to `UserProfileResponse`:

```typescript
customerLocation?: {
  latitude: number | null;
  longitude: number | null;
  address: string | null;
} | null;
```

### 2.4 Backend — Auth Repository

Update `createCustomerProfile()` to accept and insert location:

```typescript
createCustomerProfile(data: {
  user_id: string;
  latitude?: number | null;
  longitude?: number | null;
  address?: string | null;
}, trx?: Knex.Transaction): Promise<...>
```

### 2.5 Backend — Auth Service

**`signup()`:** When `input.role === 'customer'`, pass location from `input` to `createCustomerProfile()`.

**`updateProfile()`:** Add customer location update path (similar to vendor's `profileUpdates`):

```typescript
if (user.role === 'customer') {
  const customerProfileUpdates: Record<string, unknown> = {};
  if (updates.customerLatitude !== undefined) customerProfileUpdates.latitude = updates.customerLatitude;
  if (updates.customerLongitude !== undefined) customerProfileUpdates.longitude = updates.customerLongitude;
  if (updates.customerAddress !== undefined) customerProfileUpdates.address = updates.customerAddress;
  if (Object.keys(customerProfileUpdates).length > 0) {
    await this.authRepo.updateCustomerProfile(userId, customerProfileUpdates);
  }
}
```

**`_toProfileResponse()`:** Fetch customer profile for `role === 'customer'` and include location in response.

### 2.6 Backend — Auth Validators

Add optional `customerLatitude`, `customerLongitude`, `customerAddress` to the signup validator schema (Zod/Joi — check actual validator file).

### 2.7 Frontend — Profile Setup Screen

Show `LocationPickerTile` for customers too (not just vendors):

```dart
// Currently: if (isVendor) ...[..., LocationPickerTile(...)]
// Change to: show LocationPickerTile for BOTH roles, outside the isVendor block
```

Pass picked location in `AuthSignupRequested`:

```dart
customerLatitude: _role == 'customer' ? _pickedLocation?.latitude : null,
customerLongitude: _role == 'customer' ? _pickedLocation?.longitude : null,
customerAddress: _role == 'customer' ? _pickedLocation?.displayName : null,
```

### 2.8 Frontend — Auth Bloc / Event / State

`AuthSignupRequested` event: add `customerLatitude`, `customerLongitude`, `customerAddress` optional params.

`AuthBloc` `_handleSignupRequested()`: pass through to `authRepository.signup()`.

### 2.9 Frontend — Auth Repository

`AuthRepositoryImpl.signup()`: add location params to the API body for customer role.

### 2.10 Frontend — User Model / Auth Response Model

Add `customerLocation` (latitude, longitude, address) to response parsing so the user object in state carries this after login/signup.

---

## 3. WHY IT NEEDS TO CHANGE

- **Delivery context:** When vendor records a delivery entry for a customer, knowing the customer's approximate location enables future delivery-route features.
- **Customer UX:** Customers can see their registered location in their profile, helping with context ("this is where my milk is delivered").
- **Vendor UX:** Vendors can see a list of customers with locations for route planning.
- **Test parity:** The user explicitly said `8000000002` should have a location. The existing seed doesn't have this phone at all, so it needs to be added.

---

## 4. CURRENT AUTH FLOW (how location fits)

```
RoleSelectionScreen
  → PhoneEntryScreen(role)
    → OtpVerifyScreen(phone, role)
      → [existing user] AuthAuthenticated → go to dashboard
      → [new user]     AuthOtpVerifiedNewUser(signupToken, phone)
        → ProfileSetupScreen
          ← user selects role
          ← user enters name, email (opt), upi (opt)
          ← [VENDOR] business name, category, LocationPickerTile
          ← [CUSTOMER] CURRENTLY NOTHING for location ← THIS CHANGES
          → AuthSignupRequested → backend POST /auth/signup → AuthAuthenticated
```

---

## 5. CURRENT NAVIGATION FLOW

`LocationPickerTile` opens `AppRouter.locationPicker` → `LocationPickerScreen` (uses LocationIQ API for geocoding). Returns a `LocationData` object via `context.push<LocationData>`. This widget and screen already exist and work for vendors.

---

## 6. CURRENT STATE MANAGEMENT

`AuthBloc` handles all auth events/states. `AuthSignupRequested` is the event that POSTs to backend. The bloc is already wired into `ProfileSetupScreen`.

---

## 7. CURRENT BUSINESS LOGIC

- Location is **optional** for both vendors and customers. No mandatory validation.
- `LocationPickerTile` presents an OpenStreetMap-powered picker via `LocationPickerScreen`.
- Coordinates are DECIMAL(10,8) for lat, DECIMAL(11,8) for lng (vendor pattern to follow).

---

## 8. CURRENT SERVICES INVOLVED

- `lib/features/location/data/services/location_iq_service.dart` — geocoding  
- `lib/features/location/presentation/screens/location_picker_screen.dart` — UI  
- `lib/shared/widgets/location_picker_tile.dart` — the tile widget used in forms

---

## 9. EXISTING LIMITATIONS

- `customer_profiles` has NO location columns. Any attempt to store customer location would fail at DB level today.
- `UserProfileResponse` for customers does not return location, so even if stored, the frontend wouldn't see it.
- The seed file has no `8000000001`/`8000000002` accounts — the user-specified test pair doesn't exist yet.

---

## 10. EXISTING TECHNICAL DEBT

- `customer_profiles` is intentionally thin with a comment promising future additions. This migration is the first of those additions.
- Location is stored redundantly (coordinates + address string) for both vendor and now customer. This is acceptable denormalization for display performance.

---

## 11. EDGE CASES

| Case | Behavior |
|------|----------|
| Customer signs up without picking location | `latitude`, `longitude`, `address` are null — allowed |
| Customer picks location, then changes it in edit profile | Update endpoint patches the 3 fields atomically |
| Two customers have the same address string | Fine — no uniqueness constraint |
| Location picker returns null (user cancels) | No update to state, `_pickedLocation` stays null |
| Backend receives `lat`/`lng` without `address` | Store coordinates with null address — ok |
| Backend receives `address` without `lat`/`lng` | Store address string only — ok for display |
| Migration runs on existing customer_profiles rows | They get lat=null, lng=null, address=null — safe |
| `8000000001` vendor already exists | Seed must be idempotent: check before insert |
| `8000000002` customer already exists from a prior seed run | Delete and re-seed (idempotent pattern already in seed) |

---

## 12. RACE CONDITIONS / TRANSACTIONS

None introduced. Customer location is set at signup time or later via profile update. Single-row write, no concurrent contention expected.

---

## 13. REQUIRED DATABASE CHANGES

```sql
ALTER TABLE customer_profiles
  ADD COLUMN latitude  DECIMAL(10, 8) NULL,
  ADD COLUMN longitude DECIMAL(11, 8) NULL,
  ADD COLUMN address   TEXT           NULL;
```

**New migration file:** `migrations/20260034_add_location_to_customer_profiles.ts`

---

## 14. REQUIRED BACKEND CHANGES

| File | Change |
|------|--------|
| `src/app/modules/auth/types/auth.types.ts` | Add `customerLatitude`, `customerLongitude`, `customerAddress` to `SignupInput`; add `customerLocation` to `UserProfileResponse` |
| `src/app/modules/auth/repositories/auth.repository.ts` | Update `createCustomerProfile()` + add `updateCustomerProfile()` |
| `src/app/modules/auth/services/auth.service.ts` | Pass location in `signup()` + handle in `updateProfile()` + expose in `_toProfileResponse()` |
| `src/app/modules/auth/validators/auth.validators.ts` | Add optional location fields to signup validator |
| `src/app/modules/auth/controllers/auth.controller.ts` | Pass `customerLatitude/Longitude/Address` from body to service |
| `seeds/01_test_accounts.ts` | Add `8000000001` vendor + `8000000002` customer WITH location + link them |

---

## 15. REQUIRED FRONTEND CHANGES

| File | Change |
|------|--------|
| `lib/features/auth/presentation/screens/profile_setup_screen.dart` | Show `LocationPickerTile` for customer role; pass location to event |
| `lib/features/auth/presentation/bloc/auth_event.dart` | Add location params to `AuthSignupRequested` |
| `lib/features/auth/presentation/bloc/auth_bloc.dart` | Pass location to repository |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Include location in signup API body |
| `lib/features/auth/data/models/auth_response_model.dart` | Parse `customerLocation` from response |
| `lib/features/auth/data/models/user_model.dart` | Add `customerLocation` field |
| `lib/features/customer/presentation/screens/customer_profile_screen.dart` | Display customer location |
| `lib/features/auth/presentation/screens/edit_profile_screen.dart` | Allow editing customer location |

---

## 16. REQUIRED API CHANGES

**POST /auth/signup** body (customer signup):
```json
{
  "signupToken": "...",
  "name": "...",
  "role": "customer",
  "customerLatitude": 19.0596,
  "customerLongitude": 72.8295,
  "customerAddress": "Bandra West, Mumbai - 400050"
}
```

**PATCH /auth/profile** body (customer update):
```json
{
  "customerLatitude": 19.0596,
  "customerLongitude": 72.8295,
  "customerAddress": "Bandra West, Mumbai - 400050"
}
```

**GET /auth/me** response (customer):
```json
{
  "id": "...",
  "role": "customer",
  "customerLocation": {
    "latitude": 19.0596,
    "longitude": 72.8295,
    "address": "Bandra West, Mumbai - 400050"
  }
}
```

---

## 17. REQUIRED MIGRATIONS

1. `migrations/20260034_add_location_to_customer_profiles.ts` — ADD COLUMNS
2. `seeds/01_test_accounts.ts` update — idempotent, adds `8000000001`/`8000000002`

---

## 18. TESTING STRATEGY

### Functional Tests
- [ ] Customer signup WITHOUT location → profile created, location fields null
- [ ] Customer signup WITH location → location persisted and returned in /auth/me
- [ ] Customer profile update with location → fields updated, response reflects new values
- [ ] Vendor signup unaffected → vendor location still works as before

### Edge Case Tests
- [ ] Signup with lat/lng but no address → succeeds, address = null
- [ ] Signup with address but no lat/lng → succeeds, coordinates = null
- [ ] Two signups with same coordinates → both succeed (no uniqueness constraint)
- [ ] Migration down → columns removed without data loss on fresh DB

### API Tests
- [ ] POST /auth/signup with customer role + location fields → 201, customerLocation in response
- [ ] PATCH /auth/profile (customer) with location → 200, location updated
- [ ] GET /auth/me (customer) → customerLocation present

### Seed Tests
- [ ] Seed runs idempotently twice → same state after both runs
- [ ] `8000000002` exists with coordinates after seeding

### UI Tests
- [ ] Profile setup for customer role shows LocationPickerTile
- [ ] LocationPickerTile tap → location picker opens
- [ ] Location selected → tile shows address string
- [ ] Signup without picking location → proceeds normally
- [ ] After signup, customer dashboard doesn't break with location in user model

### Regression Tests
- [ ] Vendor signup with location still works
- [ ] OTP login for existing customers still works
- [ ] Staff login unaffected

---

## 19. ROLLBACK CONSIDERATIONS

- Migration `down()` removes the 3 columns from `customer_profiles`. Any stored customer location data is lost on rollback. This is acceptable — location is informational, not financial.
- Frontend rollback: revert `ProfileSetupScreen` and event changes. Safe.
- Seed rollback: seed is idempotent; re-seeding after rollback is safe.

---

## 20. RISKS

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Existing customer_profiles rows break migration | Low | All new columns are nullable |
| Frontend breaks if `customerLocation` is null | Medium | Null-safe access in model parsing |
| `8000000001/8000000002` conflict with existing users | Low | Seed is idempotent with delete-then-insert |
| LocationIQ API rate limit during testing | Low | LocationIQ calls are user-triggered only |

---

## 21. DEPENDENCIES WITH OTHER FEATURES

- **F002 (Auth Redesign):** Location picker appears in ProfileSetupScreen. If the auth redesign changes ProfileSetupScreen heavily, this feature's location picker placement must be re-integrated into the new screen.
- **F003 (Multi-category vendor):** No dependency.
- **Khata flow:** No direct dependency. Customer location is profile data only.
- **Search feature (existing):** Vendor search already works. Customer location could enable future "find vendors near me" search enhancement, but that's a separate feature.

---

## 22. SECURITY CONSIDERATIONS

- Location is user-provided and optional. No PII beyond what the user explicitly shares.
- Coordinates are stored as DECIMAL — no injection risk.
- Address string is TEXT — must be sanitized at input (Zod validator: `z.string().max(300)`).
- Coordinates are returned to the authenticated user only (auth token required for /auth/me).
- Vendor should NOT be able to see exact customer coordinates through the ledger/link API unless a specific "show customer location" endpoint is built (none planned in this feature).
