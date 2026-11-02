# F002 — Auth Redesign: OTP + Email Signup/Login for Vendors & Customers

**Status:** PLANNING  
**Priority:** HIGH (changes the primary entry point of the app)  
**Estimated Effort:** Backend 4h · Frontend 8h · Migration 0.5h

---

## 1. WHAT EXISTS TODAY

### 1.1 Current Auth Flow (Complete Walk-Through)

```
App launch → SplashScreen
  → LanguageSelectionScreen (first launch only)
  → OnboardingScreen (first launch only)
  → RoleSelectionScreen           ← ENTRY POINT
      User picks Vendor or Customer (or both = shows dual-role hint)
      [Note: both selected → only vendor role is used; customer ignored]
    → PhoneEntryScreen(role)
        Validates Indian phone (6-9 prefix, 10 digits)
        Dispatches AuthOtpSendRequested
      → OtpVerifyScreen(phone, role)
          6 OTP boxes
          Dispatches AuthOtpVerifyRequested
          [state: AuthOtpVerifiedNewUser] → ProfileSetupScreen
          [state: AuthAuthenticated]      → go to dashboard (router redirect)
        → ProfileSetupScreen
            Role toggle (vendor/customer) inside screen
            Name (required)
            Email (optional)
            [vendor] Business name, category (single dropdown), location
            UPI ID (optional)
            Dispatches AuthSignupRequested
          → [AuthAuthenticated] → dashboard

Alternative path from PhoneEntryScreen:
  "Having trouble? Use email instead" → EmailLoginScreen(role)
      Email + password fields
      Dispatches AuthEmailLoginRequested
      [AuthAuthenticated] → dashboard (router redirect)
      "Use phone instead" → back to PhoneEntryScreen
```

### 1.2 Auth Bloc Events (Current)

```dart
// lib/features/auth/presentation/bloc/auth_event.dart
AuthOtpSendRequested(phone)
AuthOtpVerifyRequested(phone, otp, role)
AuthSignupRequested(signupToken, name, role, email?, upiId?, businessName?,
                    businessCategory?, businessAddress?)
AuthEmailLoginRequested(email, password, role)
AuthLogoutRequested
AuthProfileUpdateRequested(name?, mobile?, upiId?, businessName?,
                            businessCategory?, businessAddress?,
                            businessLatitude?, businessLongitude?, upiIds?)
AuthPhotoUpdateRequested(file)
AuthDeleteAccountRequested
AuthChangePasswordRequested(current, new)
```

### 1.3 Auth Bloc States (Current)

```dart
AuthInitial
AuthLoading
AuthOtpSent(phone)
AuthOtpVerifiedNewUser(signupToken, phone)
AuthAuthenticated(user)
AuthUnauthenticated
AuthError(message)
```

### 1.4 Auth Repository (Current)

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
sendOtp(phone) → POST /auth/otp/send
verifyOtp(phone, otp) → POST /auth/otp/verify
signup(signupToken, name, role, ...) → POST /auth/signup
emailLogin(email, password) → POST /auth/email-login
refreshTokens(refreshToken) → POST /auth/refresh
logout(refreshToken) → POST /auth/logout
getProfile() → GET /auth/me
updateProfile(...) → PATCH /auth/profile
updatePhoto(file) → POST /auth/photo
deleteAccount() → DELETE /auth/account
changePassword(current, new) → POST /auth/change-password
```

### 1.5 Backend Auth Routes (Current)

```
POST   /auth/otp/send            → OtpController.sendOtp
POST   /auth/otp/verify          → OtpController.verifyOtp
POST   /auth/signup              → AuthController.signup
POST   /auth/email-login         → AuthController.emailLogin
POST   /auth/refresh             → AuthController.refresh
POST   /auth/logout              → AuthController.logout (auth required)
GET    /auth/me                  → AuthController.me (auth required)
PATCH  /auth/profile             → AuthController.updateProfile (auth required)
POST   /auth/photo               → AuthController.updatePhoto (auth required)
DELETE /auth/account             → AuthController.deleteAccount (auth required)
POST   /auth/change-password     → AuthController.changePassword (auth required)
```

### 1.6 Backend OTP Service (Current)

- `sendOtp(phone)` → creates `otp_sessions` row with SHA-256 of dummy OTP `123456`, TTL 5 minutes
- `verifyOtp(phone, otp)` → validates hash, max 3 attempts, 5 min expiry
  - Existing user found by phone → full `AuthResponse`
  - New user → `signupToken` JWT (10 min, carries `{phone, type:'signup'}`)
- Dummy OTP `123456` hardcoded — no real SMS

### 1.7 Backend Email Login (Current)

- `emailLogin(email, password)` → finds user by email (globally, not per-role), validates bcrypt hash
- Staff role explicitly blocked from email login
- Returns `AuthResponse` with tokens

### 1.8 Email in Signup (Current Gap)

- `POST /auth/signup` accepts an optional `email` field
- If email is provided, it's stored on the `users` row
- **There is NO separate email-signup flow.** OTP is the only way to create an account.
- Email is used as a **post-signup optional field** or for **email-only login after account exists**

### 1.9 Database Constraint (Current)

`migrations/20260017_dual_accounts_and_search.ts`:
- `users.email` is UNIQUE per `(email, role)` — two accounts can share an email IF one is vendor and one is customer
- `users.email` is nullable (from migration 20260021)
- `users.password_hash` is nullable (OTP users have no password)

### 1.10 The Phone → RoleSelection gap

The current `RoleSelectionScreen` both selections are toggle-able (can have both selected). But when `_onContinue()` runs, it only uses `_vendorSelected ? 'vendor' : 'customer'` — vendor wins. Dual-role creates a confusing UX.

---

## 2. THE USER'S REQUEST (INTERPRETED)

> "We are mainly having the OTP as the login and the signup as well. We do have the email but it's only for the login part. It's not connected to the signup. Read through the flow and redesign the screens first keeping in mind that the current OTP functionality will remain but we will be giving the users (vendors + customers) the option to login and signup with email as well."

**Translation:**
1. OTP login + OTP signup must continue working as-is.
2. Users should also be able to **sign up** with email (email + password, role selection).
3. Users should also be able to **log in** with email (this partially exists — email-only login exists but has no signup path).
4. The auth screen flow needs a redesign to accommodate both paths elegantly.
5. Applies to both Vendor and Customer (not Staff — staff phones only).

---

## 3. WHAT NEEDS TO CHANGE

### 3.1 New Email Signup Backend

Currently: `POST /auth/signup` only accepts `signupToken` (from OTP verify). There's no way to create an account with email+password without first doing OTP.

**Required:** New endpoint or modification so email+password signup creates an account directly.

**Option A (Recommended):** Add `POST /auth/email-signup` — a clean separate endpoint:

```
POST /auth/email-signup
Body: { email, password, name, role, upiId?, businessName?, businessCategory?, businessAddress?, ... }
Response: AuthResponse (same shape as /auth/signup)
```

**Why separate vs. modifying /auth/signup?**  
`/auth/signup` requires a `signupToken` (OTP-verified). Adding an email path would require branching logic on the server and makes testing harder. A separate endpoint is cleaner and allows different validation rules.

**Backend service method:** `AuthService.emailSignup()`:
```typescript
async emailSignup(input: EmailSignupInput, ipAddress?: string): Promise<AuthResponse> {
  // 1. Check email uniqueness for this role
  // 2. Hash password with bcrypt
  // 3. Create user + profile in transaction (no OTP token needed)
  // 4. Return AuthResponse
}
```

### 3.2 Password Validation

Email signup introduces passwords. Need validation:
- Min 8 chars
- (Optional) at least one digit or special char
- Max 100 chars

Backend: Zod validator on `POST /auth/email-signup`.  
Frontend: Validation before dispatch.

### 3.3 Email Uniqueness per Role

Already enforced: `UNIQUE(email, role)`. This means:
- Same email can have ONE vendor account and ONE customer account
- The signup validator must check `(email, role)` not just `email`

### 3.4 Frontend Screen Redesign

**Current architecture is:**
```
RoleSelectionScreen → PhoneEntryScreen → OtpVerifyScreen → ProfileSetupScreen
                                       ↘ EmailLoginScreen
```

**New architecture should be:**
```
RoleSelectionScreen (redesigned to be cleaner — single selection)
  → AuthMethodScreen(role)          ← NEW SCREEN
      Option 1: "Continue with Phone (OTP)"
      Option 2: "Continue with Email"
    → [OTP path] PhoneEntryScreen(role) → OtpVerifyScreen → ProfileSetupScreen
    → [Email path] EmailAuthScreen(role) ← NEW SCREEN
        Two sub-flows toggled by a tab or link:
          "Log In" tab:    email + password → AuthEmailLoginRequested
          "Sign Up" tab:   email + password + name + role fields → AuthEmailSignupRequested
```

**Alternatively (simpler, less navigation depth):**
```
RoleSelectionScreen (single-select, cleaner)
  → LoginChoiceScreen(role)         ← NEW (combines entry point)
      ┌─────────────────────────────────────────┐
      │  [Phone / OTP]  or  [Email / Password]  │  ← segmented control or tabs
      └─────────────────────────────────────────┘
      When Phone selected:
        → enter phone → get OTP → verify → profile setup (for new) / dashboard (for existing)
      When Email selected:
        → "Log In" flow: email + password → login
        → "Sign Up" flow: email + password → profile setup → dashboard
```

**Recommended approach:** Single screen for the auth method choice (phone vs email), with email having togglable login/signup sub-sections. This minimizes navigation depth and is familiar UX.

### 3.5 Screens to Create / Modify

| Screen | Action |
|--------|--------|
| `RoleSelectionScreen` | Simplify to single-select only (currently has both-select toggle) |
| NEW: `AuthMethodScreen(role)` | Shows phone OR email choice. Clean, branded. |
| `PhoneEntryScreen` | Unchanged except entry point changes |
| `OtpVerifyScreen` | Unchanged |
| `ProfileSetupScreen` | Role toggle can be REMOVED (role comes from RoleSelectionScreen now through the whole flow) |
| `EmailLoginScreen` | EXPAND to also handle signup (add a "Create Account" toggle/tab) OR replace with `EmailAuthScreen` |
| NEW event: `AuthEmailSignupRequested` | New event for email-based signup |

### 3.6 New Auth Bloc Event

```dart
AuthEmailSignupRequested({
  required String email,
  required String password,
  required String name,
  required String role,
  String? upiId,
  String? businessName,
  String? businessCategory,
  String? businessAddress,
  double? customerLatitude,
  double? customerLongitude,
  String? customerAddress,
})
```

**Note:** This event does NOT use a `signupToken` — email signup doesn't need OTP verification first.

### 3.7 New Auth Bloc State

`AuthEmailSignupRequested` can reuse `AuthLoading` / `AuthAuthenticated` / `AuthError` — no new state needed.

### 3.8 Auth Repository Changes

```dart
// New method in AuthRepository interface
Future<AuthResponse> emailSignup({
  required String email,
  required String password,
  required String name,
  required String role,
  String? upiId,
  String? businessName,
  String? businessCategory,
  String? businessAddress,
});
```

Implementation: `POST /auth/email-signup`.

### 3.9 Backend — New Endpoint

`POST /auth/email-signup`:
```typescript
// auth.routes.ts
router.post('/email-signup', validate(emailSignupSchema), AuthController.emailSignup);

// auth.controller.ts
static emailSignup = async (req, res, next) => {
  const result = await authService.emailSignup(req.body, req.ip);
  sendSuccess(res, result, 201);
};

// auth.service.ts
async emailSignup(input: EmailSignupInput, ipAddress?: string): Promise<AuthResponse> {
  const bcrypt = await import('bcryptjs');
  const { BCRYPT_ROUNDS } = await import('../../../shared/constants');
  
  // Uniqueness check: (email, role) pair
  const conflict = await getDb()('users')
    .where({ email: input.email, role: input.role })
    .first();
  if (conflict) throw new ConflictError('An account with this email already exists for this role');
  
  const passwordHash = await bcrypt.hash(input.password, BCRYPT_ROUNDS);
  
  const user = await getDb().transaction(async (trx) => {
    const newUser = await this.authRepo.createUser({
      email: input.email,
      password_hash: passwordHash,
      name: input.name,
      mobile: null,
      role: input.role,
      profile_photo_url: null,
      upi_id: input.role === 'customer' ? (input.upiId ?? null) : null,
      is_active: true,
      email_verified: false,
      last_login_at: null,
    }, trx);
    
    if (input.role === 'vendor') {
      const vendorProfile = await this.authRepo.createVendorProfile({
        user_id: newUser.id,
        business_name: input.businessName ?? null,
        business_category: input.businessCategory ?? null,
        business_address: input.businessAddress ?? null,
        latitude: null,
        longitude: null,
      }, trx);
      if (input.upiId) {
        await this.authRepo.replaceVendorUpiIds(vendorProfile.id,
          [{ upiId: input.upiId, isPrimary: true }], trx);
      }
    } else {
      await this.authRepo.createCustomerProfile({ user_id: newUser.id }, trx);
    }
    
    return newUser;
  });
  
  logger.info('New user registered via email', { userId: user.id, role: user.role });
  return this._buildAuthResponse(user, ipAddress);
}
```

### 3.10 Email Signup Validator (Backend)

```typescript
const emailSignupSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(8).max(100),
  name: z.string().min(1).max(100),
  role: z.enum(['vendor', 'customer']),
  upiId: z.string().max(100).optional().nullable(),
  businessName: z.string().max(200).optional().nullable(),
  businessCategory: z.string().max(100).optional().nullable(),
  businessAddress: z.string().max(500).optional().nullable(),
});
```

---

## 4. NAVIGATION REDESIGN

### 4.1 New Navigation Flow

```
SplashScreen
  → LanguageSelectionScreen (first launch)
  → OnboardingScreen (first launch)
  → AuthLandingScreen (REPLACES RoleSelectionScreen)
      Role selection: single-select (Vendor / Customer)
      Auth method: Phone (OTP) | Email
      
      IF Phone selected:
        → PhoneEntryScreen(role)
          → OtpVerifyScreen(phone, role)
            [existing user] → dashboard
            [new user]      → ProfileSetupScreen(signupToken, phone, role)
                              [role is pre-set from AuthLandingScreen, no toggle needed]
      
      IF Email + "Log In":
        → Same as current EmailLoginScreen but role-aware
        
      IF Email + "Sign Up":
        → EmailSignupScreen(role)
            Name, Email, Password, ConfirmPassword
            [vendor] Business name, category (multi-select), location
            [customer] location
            UPI (optional)
            → Dispatches AuthEmailSignupRequested
            → AuthAuthenticated → dashboard
```

### 4.2 New Routes Required

```dart
static const String authLanding = '/auth';
static const String emailSignup  = '/email-signup';
```

Update `_publicRoutes` set accordingly.

### 4.3 ProfileSetupScreen Changes

If role is passed through the flow from `AuthLandingScreen` → `PhoneEntryScreen` → `OtpVerifyScreen` → `ProfileSetupScreen`, the role toggle inside `ProfileSetupScreen` can be REMOVED. The role is known from the beginning of the flow.

The `OtpVerifyScreen` already receives `role` as a prop. It pushes to `profileSetup` with `extra: {'signupToken': ..., 'phone': ...}`. Role needs to be added: `extra: {'signupToken': ..., 'phone': ..., 'role': ...}`.

`ProfileSetupScreen` reads role from extra instead of showing a toggle.

---

## 5. CURRENT ARCHITECTURE

### 5.1 Auth Module Stack

```
UI:         Screens → BlocConsumer/BlocBuilder
State:      AuthBloc (BLoC)
Events:     AuthEvent subclasses
States:     AuthState subclasses
Repository: AuthRepository (abstract) → AuthRepositoryImpl
Network:    ApiClient (Dio) → Backend REST API
Storage:    StorageService (flutter_secure_storage) → access/refresh tokens
```

### 5.2 AuthStateNotifier (Router Integration)

`lib/core/router/auth_state_notifier.dart` listens to `AuthBloc` state changes and notifies `GoRouter` to re-evaluate redirect rules. Authentication state drives navigation globally.

### 5.3 Token Storage

`StorageService` stores `access_token` and `refresh_token` in secure storage. On app start, `AuthBloc` reads these and calls `GET /auth/me` to restore session.

---

## 6. EXISTING LIMITATIONS

- **Email signup doesn't exist.** Users MUST have a phone number to create an account. Email is a post-signup optional add-on.
- **Dual-role selection is confusing.** Selecting both Vendor and Customer creates ambiguity; the code silently picks vendor.
- **ProfileSetupScreen role toggle is redundant.** Role was already picked on `RoleSelectionScreen` — asking again creates inconsistency.
- **Email login doesn't know which role to log into** if the user has both vendor+customer accounts with the same email. Currently `findUserByEmail` returns the first match — the `(email, role)` composite unique means there can be 2 rows. The email login endpoint doesn't have a role param. **This is a bug for dual-account users.**

---

## 7. TECHNICAL DEBT

- `emailLogin()` in auth.service.ts calls `findUserByEmail(email)` which does `WHERE email = ?` — but the DB now has `UNIQUE(email, role)`, meaning TWO rows could exist for same email (one vendor, one customer). The current code returns `findFirst()` — this picks arbitrarily. **Fix needed: accept `role` param in email login.**

---

## 8. EDGE CASES

| Case | Behavior |
|------|----------|
| Email signup with email already used for same role | ConflictError 409 |
| Email signup with email used for different role | Success (dual account allowed) |
| User has OTP account, tries email signup with same email | Only possible if they added email to OTP account. If email+role combo exists, 409. |
| Email login without a password (OTP-only user who never set password) | `user.password_hash` is null → UnauthorizedError "Invalid email or password" (current behavior, correct) |
| Email signup with very weak password | Validator rejects if < 8 chars |
| Two simultaneous signups with same email+role | DB constraint catches the second one with a 409 |
| Phone signup then email signup with same email+role | At OTP signup, email is optional. If they use same email as another account of same role → `ConflictError` from existing check in `signup()` |
| Staff tries email signup | Not supported — staff accounts are created by vendors, not self-signup. Block `role='staff'` in email-signup validator. |

---

## 9. RACE CONDITIONS

- Email signup with uniqueness check + insert: the check and insert are NOT in the same DB transaction in the current email-login code. The signup flow IS transactional. The email-signup endpoint should do the uniqueness check INSIDE the transaction (or rely on the DB constraint to catch races). **The DB `UNIQUE(email, role)` constraint is the safety net.**

---

## 10. REQUIRED DATABASE CHANGES

**None for this feature itself.** The existing schema already supports:
- Nullable email ✓
- Nullable password_hash ✓
- UNIQUE(email, role) ✓

No new migration required.

---

## 11. REQUIRED BACKEND CHANGES

| File | Change |
|------|--------|
| `src/app/modules/auth/routes/auth.routes.ts` | Add `POST /auth/email-signup` route |
| `src/app/modules/auth/controllers/auth.controller.ts` | Add `emailSignup` controller method |
| `src/app/modules/auth/services/auth.service.ts` | Add `emailSignup()` method |
| `src/app/modules/auth/validators/auth.validators.ts` | Add `emailSignupSchema` validator |
| `src/app/modules/auth/services/auth.service.ts` | Fix `emailLogin()` to accept `role` param and query `WHERE email = ? AND role = ?` |
| `src/app/modules/auth/controllers/auth.controller.ts` | Pass `role` from body to `emailLogin()` |
| `src/app/modules/auth/validators/auth.validators.ts` | Add `role` to email-login schema |

---

## 12. REQUIRED FRONTEND CHANGES

| File | Change |
|------|--------|
| NEW: `lib/features/auth/presentation/screens/auth_landing_screen.dart` | Replaces/redesigns RoleSelectionScreen + entry |
| NEW: `lib/features/auth/presentation/screens/email_signup_screen.dart` | Full email signup form |
| `lib/features/auth/presentation/screens/email_login_screen.dart` | Add `role` param; accept `role` in body; fix dual-account lookup |
| `lib/features/auth/presentation/screens/profile_setup_screen.dart` | Remove role toggle; accept role from extra |
| `lib/features/auth/presentation/screens/otp_verify_screen.dart` | Pass `role` to profileSetup extra |
| `lib/features/auth/presentation/bloc/auth_event.dart` | Add `AuthEmailSignupRequested` |
| `lib/features/auth/presentation/bloc/auth_bloc.dart` | Handle `AuthEmailSignupRequested` → `emailSignup()` |
| `lib/features/auth/domain/repositories/auth_repository.dart` | Add `emailSignup()` abstract method |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Implement `emailSignup()` → `POST /auth/email-signup` |
| `lib/core/router/app_router.dart` | Add `authLanding`, `emailSignup` routes; update `_publicRoutes` |
| `lib/core/network/api_endpoints.dart` | Add `emailSignup` endpoint constant |

---

## 13. REQUIRED UI REDESIGNS

### 13.1 AuthLandingScreen (NEW)

**Purpose:** Single screen that unifies role selection + auth method choice.

**Layout concept:**
```
┌─────────────────────────────────┐
│          SaathKhata             │
│       Logo / Illustration       │
│                                 │
│  Who are you?                   │
│  ○ Vendor  ○ Customer           │
│                                 │
│  ─────────── or ───────────    │
│                                 │
│  [  Continue with Phone  ]      │  ← Primary (OTP)
│  [  Continue with Email  ]      │  ← Secondary
│                                 │
│  Already have an account?       │
│  Log in with phone / email      │
└─────────────────────────────────┘
```

Single-select roles (Radio buttons or pill-style toggles, not checkboxes).

### 13.2 EmailAuthScreen or EmailLoginScreen Expansion

**For login:**
```
┌─────────────────────────────────┐
│  [Vendor] Log in                │
│                                 │
│  [Email ___________________]    │
│  [Password _________________]   │
│                           [👁]   │
│                                 │
│  [     Log In     ]             │
│                                 │
│  Don't have an account?         │
│  Sign up with email →           │
│                                 │
│  ← Use phone instead            │
└─────────────────────────────────┘
```

**For signup:**
```
┌─────────────────────────────────┐
│  [Vendor] Create Account        │
│                                 │
│  [Name _____________________]   │
│  [Email ____________________]   │
│  [Password _________________]   │
│  [Confirm Password _________]   │
│                                 │
│  [vendor fields...]             │
│                                 │
│  [   Create Account   ]         │
│                                 │
│  Already have an account?       │
│  Log in →                       │
└─────────────────────────────────┘
```

---

## 14. REQUIRED API CHANGES

**New endpoint:**
```
POST /auth/email-signup
Body: {
  email: string,
  password: string,
  name: string,
  role: 'vendor' | 'customer',
  upiId?: string,
  businessName?: string,
  businessCategory?: string | string[],  // depends on F003
  businessAddress?: string,
}
Response: { user: UserProfileResponse, tokens: { accessToken, refreshToken, expiresIn } }
```

**Modified endpoint:**
```
POST /auth/email-login
Body: {
  email: string,
  password: string,
  role: 'vendor' | 'customer',  ← NEW FIELD
}
```

---

## 15. DEPENDENCIES WITH OTHER FEATURES

- **F001 (Customer Location):** Email signup for customers should also include the location picker. The `EmailSignupScreen` for customers needs the `LocationPickerTile`.
- **F003 (Multi-category vendor):** If vendor signup allows multiple categories (F003), the `EmailSignupScreen` for vendors needs the multi-category selector instead of a single dropdown. F003 should be implemented first or in parallel.
- **F004 (Khata flow):** No direct dependency. Auth is independent of Khata logic.

**Implementation order:** F001 + F003 should be done before or alongside F002 because their form changes affect the same screens (`ProfileSetupScreen`, `EmailSignupScreen`). Doing them out of order means touching the same screens twice.

---

## 16. TESTING STRATEGY

### Functional Tests
- [ ] OTP signup: unchanged, still works
- [ ] OTP login (existing user): unchanged
- [ ] Email signup (vendor): creates vendor account, returns AuthResponse
- [ ] Email signup (customer): creates customer account, returns AuthResponse
- [ ] Email login: works with role, returns correct account
- [ ] Email login without role param: backward-compat or error

### Edge Case Tests
- [ ] Email signup duplicate (same email+role) → 409
- [ ] Email signup (email used for other role) → 201, dual account created
- [ ] Email signup weak password (<8 chars) → 400 validation error
- [ ] Email login with wrong password → 401
- [ ] Email login for OTP-only user (no password_hash) → 401, correct message
- [ ] Staff email login → 403 ForbiddenError

### UI Tests
- [ ] AuthLandingScreen: role selection is single-select
- [ ] AuthLandingScreen: "Continue with Phone" navigates to PhoneEntryScreen with role
- [ ] AuthLandingScreen: "Continue with Email" navigates to email auth with role
- [ ] Email auth: toggle between login and signup within the screen
- [ ] Email signup form: shows vendor fields when vendor role
- [ ] Email signup form: shows customer fields when customer role
- [ ] After email signup: redirected to appropriate dashboard

### Regression Tests
- [ ] Existing OTP flow completely unbroken
- [ ] Router redirect still works for all roles (vendor/customer/staff)
- [ ] Token refresh still works
- [ ] Profile update still works

---

## 17. ROLLBACK CONSIDERATIONS

- New endpoint `/auth/email-signup` can be disabled by removing the route. No data rollback needed if no accounts were created via it.
- Frontend screens: revert to previous `RoleSelectionScreen` + `EmailLoginScreen`.
- Email login `role` param: make it optional with backward compat (if no role, use old `findUserByEmail`).

---

## 18. RISKS

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Existing email-login users confused by new role param | Medium | Make `role` optional with fallback |
| Dual-account users (same email, vendor+customer) get the wrong account | High | Fix email-login to require `role` |
| Weak password policies leading to account takeovers | Medium | Enforce min 8 chars; future: 2FA |
| RoleSelectionScreen redesign breaks existing navigation | Medium | Test all navigation paths |
| ProfileSetupScreen role removal breaks OTP signup | Medium | Thorough regression testing |
