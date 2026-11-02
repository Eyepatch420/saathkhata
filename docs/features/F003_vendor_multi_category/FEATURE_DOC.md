# F003 — Vendor Multi-Category Signup

**Status:** PLANNING  
**Priority:** MEDIUM  
**Estimated Effort:** Backend 2h · Frontend 3h · Migration 1h

---

## 1. WHAT EXISTS TODAY

### 1.1 Database — `vendor_profiles`

```sql
business_category VARCHAR(100) NULL
```

A single nullable string column. No FK constraint, no validation — any string is accepted. Created in `migrations/20260002_create_vendor_profiles.ts`. A Full-Text Search (FTS) index was added on `business_name` and a B-tree index on `business_category` in migration `20260017_dual_accounts_and_search.ts` for the vendor search feature.

```sql
-- From 20260017:
CREATE INDEX idx_vendor_profiles_category ON vendor_profiles (business_category);
-- GIN FTS on business_name:
ALTER TABLE vendor_profiles ADD COLUMN fts_name tsvector GENERATED ALWAYS AS (to_tsvector('simple', coalesce(business_name, ''))) STORED;
CREATE INDEX idx_vendor_profiles_fts ON vendor_profiles USING GIN(fts_name);
```

### 1.2 Backend — Category List (Constants)

`src/app/shared/constants/index.ts` defines `VENDOR_CATEGORIES`:
```typescript
export const VENDOR_CATEGORIES = [
  'Milk / Dairy',
  'Press / Dhobi',
  'Maid / Cook',
  'Newspaper',
  'Water Can',
  'Tiffin / Food',
  'Kirana / Grocery',
  'Salon / Parlour',
  'Construction Labour',
  'Transport / Auto',
  'Other',
] as const;
```

This is used for reference only — the backend does NOT validate that `business_category` matches this list. Any string can be stored.

### 1.3 Backend — Signup Service

`auth.service.ts` `signup()`:
```typescript
await this.authRepo.createVendorProfile({
  user_id: newUser.id,
  business_name: input.businessName ?? null,
  business_category: input.businessCategory ?? null,  // ← single string
  business_address: input.businessAddress ?? null,
  latitude: input.businessLatitude ?? null,
  longitude: input.businessLongitude ?? null,
}, trx);
```

### 1.4 Backend — Search

`search.service.ts` uses `business_category` for filtering:
```typescript
query.whereRaw('LOWER(vp.business_category) = LOWER(?)', [category])
```
And for display in search results.

### 1.5 Frontend — Profile Setup (`profile_setup_screen.dart`)

```dart
// In _vendorCategories():
return [
  'Milk / Dairy', 'Press / Dhobi', 'Maid / Cook', ...
];

// In the form:
if (isVendor) ...[
  const SizedBox(height: 20),
  DropdownButtonFormField<String>(
    value: _selectedCategory,
    onChanged: (val) => setState(() => _selectedCategory = val),
    items: _vendorCategories().map((cat) => DropdownMenuItem(
      value: cat, child: Text(cat),
    )).toList(),
    decoration: const InputDecoration(labelText: 'Business Category'),
  ),
```

**Single dropdown — only one category can be selected.**

### 1.6 Frontend — User Model

`lib/features/auth/data/models/user_model.dart`:
```dart
final String? businessCategory;  // single string
```

### 1.7 Backend — Auth Types

`auth.types.ts`:
```typescript
businessCategory?: string;  // single string in SignupInput + UserProfileResponse
```

---

## 2. THE USER'S REQUEST

> "FOR THE VENDOR SIGNUP ALLOW THE USE OF MULTIPLE CATEGORIES. Checkbox format (NOT FilterChip — actual checkboxes, Material 3 style). Soft border radius, Material 3 aesthetic. Add 'Gym / Fitness' to categories list. Max 3 categories, min 1. 'Others' section where vendor can add their OWN custom categories (not just select 'Other') — vendor can add 1 or more free-text custom categories ON TOP OF the checkboxes. These custom categories count toward the max-3 total."

---

## 3. DESIGN DECISION: How to Store Multiple Categories

### Option A: TEXT[] PostgreSQL array column ✅ CHOSEN

```sql
ALTER TABLE vendor_profiles
  ADD COLUMN business_categories TEXT[] NOT NULL DEFAULT '{}';
```

**Pros:**
- Native PostgreSQL type
- Can be GIN-indexed for fast containment queries (`@>`, `&&`)
- No JOIN needed
- Custom free-text categories store alongside predefined ones transparently

**Cons:**
- Breaks the existing `business_category` VARCHAR(100) search query — must update to array containment
- Knex requires `knex.raw` for array literal writes

### Option B: New junction table `vendor_categories`

Normalized but adds JOIN overhead to every profile read. Overkill given the small cardinality (max 3 entries per vendor). Not chosen.

### Option C: JSONB column

Schema-less but less performant for GIN containment queries compared to TEXT[]. Not chosen.

### Final Decision: **Option A (TEXT[]) + keep `business_category` for backward compat**

Add `business_categories TEXT[]` for multi-category including custom entries. Keep `business_category` (single VARCHAR) but treat it as a denormalized cache of `categories[0]` for backward compat. The "Other" predefined option and any vendor-typed custom strings all go into the same `business_categories` array.

---

## 4. REQUIRED DATABASE CHANGES

**New migration:** `migrations/20260035_vendor_multi_category.ts`

```typescript
import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  // 1. Add the TEXT[] column
  await knex.schema.alterTable('vendor_profiles', (table) => {
    table.specificType('business_categories', 'TEXT[]').notNullable().defaultTo('{}');
  });

  // 2. Backfill: copy existing single categories into the new array
  await knex.raw(`
    UPDATE vendor_profiles
    SET business_categories = ARRAY[business_category]
    WHERE business_category IS NOT NULL
      AND business_category != ''
  `);

  // 3. GIN index for fast array containment queries (category filter in search)
  await knex.raw(`
    CREATE INDEX idx_vendor_profiles_categories_gin
    ON vendor_profiles USING GIN(business_categories)
  `);
}

export async function down(knex: Knex): Promise<void> {
  await knex.raw('DROP INDEX IF EXISTS idx_vendor_profiles_categories_gin');
  await knex.schema.alterTable('vendor_profiles', (table) => {
    table.dropColumn('business_categories');
  });
  // Note: business_category VARCHAR survives — backward compat is preserved on rollback
}
```

---

## 5. REQUIRED BACKEND CHANGES

### 5.1 Auth Types (`auth.types.ts`)

```typescript
interface SignupInput {
  // ... existing fields
  businessCategory?: string;          // deprecated, kept for old client compat
  businessCategories?: string[];      // NEW: array of predefined + custom categories
}

interface UpdateProfileInput {
  // ... existing fields
  businessCategories?: string[];      // NEW
}

interface UserProfileResponse {
  vendorProfile?: {
    businessName: string | null;
    businessCategory: string | null;        // first category, backward compat
    businessCategories: string[];           // NEW: full array including custom entries
    businessAddress: string | null;
    // ... existing fields
  }
}
```

### 5.2 Auth Repository (`auth.repository.ts`)

`createVendorProfile()` — add `business_categories` to the insert:

```typescript
async createVendorProfile(data: {
  user_id: string;
  business_name: string | null;
  business_category: string | null;
  business_categories: string[];
  business_address: string | null;
  latitude: number | null;
  longitude: number | null;
}, trx: Knex.Transaction): Promise<VendorProfile> {
  const [profile] = await trx('vendor_profiles').insert({
    user_id: data.user_id,
    business_name: data.business_name,
    business_category: data.business_category,          // backward compat cache
    business_categories: trx.raw('?::TEXT[]', [JSON.stringify(data.business_categories).replace('[', '{').replace(']', '}')]),
    business_address: data.business_address,
    latitude: data.latitude,
    longitude: data.longitude,
  }).returning('*');
  return profile;
}
```

> **Note on TEXT[] literal in Knex:** Use `knex.raw('ARRAY[??]::TEXT[]', [categories])` or cast via `knex.raw('?::TEXT[]', ['{' + categories.join(',') + '}'])`. Prefer building the array literal in SQL to avoid escaping edge cases:
> ```typescript
> business_categories: knex.raw(
>   `ARRAY[${categories.map(() => '?').join(',')}]::TEXT[]`,
>   categories
> ),
> ```

`updateVendorProfile()` — handle array update:
```typescript
async updateVendorProfile(userId: string, updates: Partial<VendorProfileRow>, trx?: Knex.Transaction): Promise<void> {
  const db = trx ?? this.knex;
  // business_categories needs special handling as TEXT[]
  if (updates.business_categories) {
    const cats = updates.business_categories as string[];
    const arrLiteral = db.raw(
      `ARRAY[${cats.map(() => '?').join(',')}]::TEXT[]`,
      cats
    );
    updates = { ...updates, business_categories: arrLiteral as any };
  }
  await db('vendor_profiles').where({ user_id: userId }).update(updates);
}
```

### 5.3 Auth Service — `signup()`

```typescript
// Normalize: support old single businessCategory OR new businessCategories array
const categories: string[] = input.businessCategories?.length
  ? input.businessCategories
  : input.businessCategory
    ? [input.businessCategory]
    : [];

// categories may include predefined names AND custom strings entered by vendor
await this.authRepo.createVendorProfile({
  user_id: newUser.id,
  business_name: input.businessName ?? null,
  business_category: categories[0] ?? null,   // backward compat: first entry
  business_categories: categories,
  business_address: input.businessAddress ?? null,
  latitude: input.businessLatitude ?? null,
  longitude: input.businessLongitude ?? null,
}, trx);
```

### 5.4 Auth Service — `updateProfile()`

```typescript
if (user.role === 'vendor' && input.businessCategories !== undefined) {
  const categories = input.businessCategories;
  profileUpdates.business_categories = categories;
  profileUpdates.business_category = categories[0] ?? null; // backward compat cache
}
```

### 5.5 Auth Service — `_toProfileResponse()`

```typescript
vendorProfile: vp ? {
  businessName: vp.business_name,
  businessCategory: vp.business_category,            // first entry cache
  businessCategories: (vp.business_categories as string[]) ?? [],
  businessAddress: vp.business_address,
  // ... rest
} : undefined,
```

### 5.6 Auth Validators (`auth.validators.ts`)

**Signup validator:**
```typescript
const signupSchema = z.object({
  // ... existing
  businessCategory: z.string().max(100).optional().nullable(),  // kept for compat
  businessCategories: z
    .array(z.string().min(1).max(100))
    .min(0)
    .max(3, 'Maximum 3 categories allowed')
    .optional(),
});
```

**Update profile validator:**
```typescript
const updateProfileSchema = z.object({
  // ... existing
  businessCategories: z
    .array(z.string().min(1).max(100))
    .min(1, 'At least 1 category required')
    .max(3, 'Maximum 3 categories allowed')
    .optional(),
});
```

**Server-side category validation note:** The backend does NOT restrict to the predefined list — it accepts any string. This allows vendor-typed custom categories to be stored as-is. The max-3 and max-100-char limits are the only guardrails.

### 5.7 Auth Controller (`auth.controller.ts`)

No changes required. The controller delegates to `authService.signup()` and `authService.updateProfile()`, which are updated above.

### 5.8 Search Service (`search.service.ts`)

Update category filter from exact match on `business_category` to array containment on `business_categories`:

**Before:**
```typescript
query.whereRaw('LOWER(vp.business_category) = LOWER(?)', [category])
```

**After:**
```typescript
// Uses the GIN index on business_categories for performance
query.whereRaw(
  `EXISTS (
    SELECT 1 FROM unnest(vp.business_categories) AS cat
    WHERE LOWER(cat) = LOWER(?)
  )`,
  [category]
);
```

Alternatively, using the GIN `@>` operator (case-sensitive but indexed):
```typescript
query.whereRaw(`vp.business_categories @> ARRAY[?]::TEXT[]`, [category]);
```

Use the `unnest` + `LOWER` form when case-insensitive matching matters (user searches "milk/dairy" vs "Milk / Dairy"). Use `@>` when input is always normalized to the exact canonical form (safe if search filter values come from `VENDOR_CATEGORIES` constants).

**Recommendation:** Use `unnest` + `LOWER` for robustness.

### 5.9 Search Result Mapping

`search.service.ts` `_toSearchResult()` (or equivalent mapper):
```typescript
businessCategory: row.business_category ?? null,
businessCategories: (row.business_categories as string[]) ?? [],
```

Ensure `business_categories` is included in the `SELECT` clause of the search query.

### 5.10 Constants Update (`src/app/shared/constants/index.ts`)

Add `'Gym / Fitness'` before `'Other'`:
```typescript
export const VENDOR_CATEGORIES = [
  'Milk / Dairy',
  'Press / Dhobi',
  'Maid / Cook',
  'Newspaper',
  'Water Can',
  'Tiffin / Food',
  'Kirana / Grocery',
  'Salon / Parlour',
  'Construction Labour',
  'Transport / Auto',
  'Gym / Fitness',   // NEW
  'Other',
] as const;

export type VendorCategory = typeof VENDOR_CATEGORIES[number];
```

---

## 6. REQUIRED FRONTEND CHANGES

### 6.1 Constants File

**Create** `lib/core/constants/vendor_categories.dart`:
```dart
const kVendorCategories = [
  'Milk / Dairy',
  'Press / Dhobi',
  'Maid / Cook',
  'Newspaper',
  'Water Can',
  'Tiffin / Food',
  'Kirana / Grocery',
  'Salon / Parlour',
  'Construction Labour',
  'Transport / Auto',
  'Gym / Fitness',  // NEW
  'Other',
];
```

Remove the inline `_vendorCategories()` method from `profile_setup_screen.dart` and import from here.

### 6.2 Profile Setup Screen — Checkbox Multi-Select UI

**Replace** the single `DropdownButtonFormField` with a Material 3 checkbox-based multi-select section.

The design has two sub-sections:
1. Predefined checkbox list (all `kVendorCategories` items)
2. "Your Own Categories" section with a text field + add button for custom free-text entries

**State:**
```dart
final List<String> _selectedCategories = [];        // predefined picks
final List<String> _customCategories = [];          // vendor-typed entries
final TextEditingController _customCatController = TextEditingController();

// Combined for submission
List<String> get _allCategories => [..._selectedCategories, ..._customCategories];
```

**Max enforcement:**
```dart
bool get _atMax => _allCategories.length >= 3;
```

**Widget tree:**

```dart
// ── Category Section ──────────────────────────────────────────
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.outlineVariant,
    ),
    borderRadius: BorderRadius.circular(12),   // soft M3 radius
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section header
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Row(
          children: [
            Text(
              'Business Category',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _allCategories.isEmpty
                    ? Theme.of(context).colorScheme.errorContainer
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_allCategories.length}/3',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _allCategories.isEmpty
                      ? Theme.of(context).colorScheme.onErrorContainer
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          'Select up to 3 (min 1)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),

      // Predefined checkboxes
      ...kVendorCategories.map((cat) {
        final isSelected = _selectedCategories.contains(cat);
        final isDisabled = _atMax && !isSelected;
        return CheckboxListTile.adaptive(
          value: isSelected,
          onChanged: isDisabled
              ? null
              : (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedCategories.add(cat);
                    } else {
                      _selectedCategories.remove(cat);
                    }
                  });
                },
          title: Text(
            cat,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDisabled
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.38)
                  : null,
            ),
          ),
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.onPrimary,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),

      // Divider before custom section
      Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),

      // Custom categories header
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(
          'Add your own',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),

      // Existing custom category chips (dismissible)
      if (_customCategories.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _customCategories.map((custom) {
              return InputChip(
                label: Text(custom),
                onDeleted: () => setState(() => _customCategories.remove(custom)),
                deleteIcon: const Icon(Icons.close, size: 16),
              );
            }).toList(),
          ),
        ),

      // Text field + Add button
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customCatController,
                enabled: !_atMax,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: _atMax ? 'Max 3 reached' : 'e.g. Organic Vegetables',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _addCustomCategory(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _atMax ? null : _addCustomCategory,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    ],
  ),
),
```

**Add custom category helper:**
```dart
void _addCustomCategory() {
  final text = _customCatController.text.trim();
  if (text.isEmpty) return;
  if (_atMax) return;
  if (_allCategories.contains(text)) return; // no duplicates
  setState(() {
    _customCategories.add(text);
    _customCatController.clear();
  });
}
```

**Validation in `_handleSignup()`:**
```dart
if (isVendor && _allCategories.isEmpty) {
  _showError(l10n.categoryRequired);  // 'Please select at least 1 category'
  return;
}
if (_allCategories.length > 3) {
  _showError('Maximum 3 categories allowed');
  return;
}
```

### 6.3 Edit Profile Screen (`edit_profile_screen.dart` or `vendor_profile_edit_screen.dart`)

Replicate the same checkbox + custom-category section from §6.2. Pre-fill state from `user.businessCategories`:

```dart
@override
void initState() {
  super.initState();
  final all = widget.user.businessCategories;
  for (final cat in all) {
    if (kVendorCategories.contains(cat)) {
      _selectedCategories.add(cat);
    } else {
      _customCategories.add(cat);
    }
  }
}
```

### 6.4 Auth Event / State

```dart
class AuthSignupRequested extends AuthEvent {
  const AuthSignupRequested({
    required this.phone,
    required this.otp,
    required this.name,
    required this.role,
    this.businessName,
    this.businessCategories,  // NEW: replaces businessCategory
    this.businessAddress,
    this.businessLatitude,
    this.businessLongitude,
  });

  final List<String>? businessCategories;

  // backward compat getter for any code that reads single category
  String? get businessCategory =>
      businessCategories?.isNotEmpty == true ? businessCategories!.first : null;
}
```

### 6.5 Auth Repository — `signup()` (`auth_repository.dart`)

```dart
Future<UserModel> signup({
  // ... existing params
  List<String>? businessCategories,
}) async {
  final body = <String, dynamic>{
    // ... existing fields
  };
  if (businessCategories != null && businessCategories.isNotEmpty) {
    body['businessCategories'] = businessCategories;
    body['businessCategory'] = businessCategories.first; // backward compat
  }
  // ... POST /auth/signup
}
```

### 6.6 User Model (`user_model.dart`)

```dart
class UserModel extends Equatable {
  const UserModel({
    // ... existing
    this.businessCategory,
    this.businessCategories = const [],
  });

  final String? businessCategory;         // first entry, backward compat
  final List<String> businessCategories;  // NEW: full array incl. custom

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final vp = json['vendorProfile'] as Map<String, dynamic>?;
    final rawCats = vp?['businessCategories'];
    final List<String> cats = rawCats is List
        ? rawCats.cast<String>()
        : vp?['businessCategory'] != null
            ? [vp!['businessCategory'] as String]
            : [];

    return UserModel(
      // ... existing fields
      businessCategory: vp?['businessCategory'] as String?,
      businessCategories: cats,
    );
  }

  @override
  List<Object?> get props => [
    // ... existing
    businessCategory,
    businessCategories,
  ];
}
```

### 6.7 Vendor Search Result Model

`lib/features/search/data/models/vendor_search_result.dart`:
```dart
class VendorSearchResult extends Equatable {
  const VendorSearchResult({
    // ... existing
    this.businessCategory,
    this.businessCategories = const [],
  });

  final String? businessCategory;
  final List<String> businessCategories;  // NEW

  // Display helper: "Milk / Dairy · Kirana / Grocery"
  String get categoriesDisplay =>
      businessCategories.isNotEmpty
          ? businessCategories.join(' · ')
          : businessCategory ?? '';

  factory VendorSearchResult.fromJson(Map<String, dynamic> json) {
    final rawCats = json['businessCategories'];
    return VendorSearchResult(
      // ... existing fields
      businessCategory: json['businessCategory'] as String?,
      businessCategories: rawCats is List ? rawCats.cast<String>() : [],
    );
  }
}
```

### 6.8 Search Result Card & Vendor Profile Screen

Replace single `businessCategory` display with `categoriesDisplay` getter:
```dart
// In VendorCard widget:
Text(vendor.categoriesDisplay),

// In VendorProfileScreen:
Text(vendorSearchResult.categoriesDisplay),
```

---

## 7. CONSTANTS FILE (Both Backend + Frontend)

### Backend (`src/app/shared/constants/index.ts`)

Updated list with `'Gym / Fitness'` inserted before `'Other'`:
```typescript
export const VENDOR_CATEGORIES = [
  'Milk / Dairy',
  'Press / Dhobi',
  'Maid / Cook',
  'Newspaper',
  'Water Can',
  'Tiffin / Food',
  'Kirana / Grocery',
  'Salon / Parlour',
  'Construction Labour',
  'Transport / Auto',
  'Gym / Fitness',   // NEW
  'Other',
] as const;
```

### Flutter (`lib/core/constants/vendor_categories.dart`)

```dart
const kVendorCategories = [
  'Milk / Dairy',
  'Press / Dhobi',
  'Maid / Cook',
  'Newspaper',
  'Water Can',
  'Tiffin / Food',
  'Kirana / Grocery',
  'Salon / Parlour',
  'Construction Labour',
  'Transport / Auto',
  'Gym / Fitness',  // NEW
  'Other',
];
```

---

## 8. BACKWARD COMPATIBILITY

| Scenario | Behavior |
|----------|----------|
| Old client sends only `businessCategory` (string) | Backend normalizes: `categories = [businessCategory]`; stored in both columns |
| New client sends `businessCategories` (array) | `business_category` cache set to `categories[0]` |
| Existing vendor (pre-migration, has `business_category` value) | Migration backfills `business_categories = ARRAY[business_category]` |
| Existing vendor (pre-migration, `business_category IS NULL`) | `business_categories` stays `'{}'` — vendor can update at next profile edit |
| Search by category (existing callers) | API query param unchanged; backend filter updated to array containment |
| `GET /auth/me` response | Always returns both `businessCategory` (string/null) and `businessCategories` (array) |

---

## 9. CURRENT SEARCH DISPLAY

Vendor search results currently show `businessCategory` in the card subtitle. After this feature, display the joined array:

```
Milk / Dairy · Gym / Fitness
```

This uses `VendorSearchResult.categoriesDisplay` (see §6.7).

---

## 10. VENDOR PROFILE SCREEN (Customer-Facing)

`lib/features/search/presentation/screens/vendor_profile_screen.dart` shows `vendorSearchResult.businessCategory`. After F003, use `vendorSearchResult.categoriesDisplay`. The `VendorSearchResult` model needs `businessCategories: List<String>` added (see §6.7).

---

## 11. REQUIRED MIGRATIONS

1. `migrations/20260035_vendor_multi_category.ts` — ADD `business_categories TEXT[]` + backfill from `business_category` + GIN index

No other migrations needed. `business_category` VARCHAR column is preserved.

---

## 12. REQUIRED API CHANGES

**POST /auth/signup** (vendor):
```json
{
  "businessCategories": ["Milk / Dairy", "Gym / Fitness"],
  "businessCategory": "Milk / Dairy"    // still accepted, backward compat
}
```

**PATCH /auth/profile** (vendor):
```json
{
  "businessCategories": ["Milk / Dairy", "My Custom Service"]
}
```

**GET /auth/me** (vendor response):
```json
{
  "vendorProfile": {
    "businessCategory": "Milk / Dairy",
    "businessCategories": ["Milk / Dairy", "My Custom Service"],
    ...
  }
}
```

**GET /search/vendors?category=Milk+%2F+Dairy**
No change to endpoint or query param. Backend filter logic updated to array containment.

---

## 13. LIMITATIONS AFTER THIS CHANGE

- Maximum **3** categories per vendor (validator enforcement — down from the old single limit, up to allow multi-select)
- Custom categories: each max 100 chars; no server-side whitelist restriction (any string accepted)
- The `business_category` column becomes a denormalized cache of `categories[0]` — acceptable trade-off for backward compat
- The predefined `'Other'` checkbox entry is still available — vendors can select it AND also add free-text custom entries; they are independent. Selecting "Other" does not auto-enable the text field.
- Category search (`/search/vendors?category=...`) only matches against the stored array values. Custom vendor categories will only surface if a customer searches the exact custom text (unlikely). Predefined categories are indexed normally.

---

## 14. EDGE CASES

| Case | Behavior |
|------|----------|
| Vendor signs up with 0 categories | Validator rejects at frontend (min 1 enforced) and backend (if update, `min(1)`) |
| Vendor selects 3 predefined + tries to add 1 custom | Frontend disables checkbox clicks and Add button; shows "Max 3 reached" hint |
| Vendor types a custom category that matches a predefined name | Accepted but deduplicated — check `_allCategories.contains(text)` before adding |
| Vendor clears all categories in edit profile | Backend `updateProfileSchema` enforces `min(1)` |
| Old client sends only `businessCategory` string | Backend: `categories = [businessCategory]` |
| Category string contains SQL injection attempt | Knex parameterization prevents injection; stored as raw string |
| Pre-migration vendor with `business_category = 'Other'` | Backfill: `business_categories = ARRAY['Other']` |
| Vendor sets "Gym / Fitness" custom (before it was predefined) | During migration, existing custom "Gym / Fitness" strings remain in `business_categories` unchanged; the new predefined checkbox will match them on profile edit because the edit screen classifies `kVendorCategories` members into `_selectedCategories` |
| Customer (not vendor) signup body includes `businessCategories` | Ignored by auth service — only vendor profile creation reads it |

---

## 15. TESTING STRATEGY

### Backend / Integration Tests

- [ ] `POST /auth/signup` (vendor) with `businessCategories: ['Milk / Dairy', 'Kirana / Grocery']` → `business_categories = {'Milk / Dairy','Kirana / Grocery'}`, `business_category = 'Milk / Dairy'`
- [ ] `POST /auth/signup` with `businessCategories: ['A','B','C','D']` (4 items) → 400 "Maximum 3 categories"
- [ ] `POST /auth/signup` with only `businessCategory: 'Water Can'` (old client) → normalized to `['Water Can']` in both columns
- [ ] `PATCH /auth/profile` with `businessCategories: ['New Cat']` → both columns updated
- [ ] `PATCH /auth/profile` with `businessCategories: []` → 400 "At least 1 category required"
- [ ] `GET /auth/me` → response includes both `businessCategory` and `businessCategories`
- [ ] `GET /search/vendors?category=Milk+%2F+Dairy` → returns vendors whose `business_categories` contains 'Milk / Dairy'
- [ ] Search does NOT return vendor whose `business_categories` contains only 'Kirana / Grocery' when filtering by 'Milk / Dairy'
- [ ] Migration backfill: seed vendor with `business_category = 'Tiffin / Food'` → after migration, `business_categories = {'Tiffin / Food'}`
- [ ] Custom category: signup with `['Organic Veggies']` (not in predefined list) → stored and returned correctly

### Flutter Widget / Unit Tests

- [ ] Selecting 1 predefined checkbox → `_allCategories.length == 1`, counter shows "1/3"
- [ ] Selecting 3 predefined checkboxes → all further checkboxes disabled, Add button disabled
- [ ] Typing custom category and tapping Add → appears as chip in custom section, counts toward total
- [ ] Deleting a chip → total decreases, checkboxes re-enabled
- [ ] Duplicate custom category not added
- [ ] Edit profile: pre-fills predefined categories into `_selectedCategories` and custom entries into `_customCategories`
- [ ] `UserModel.fromJson` with `businessCategories: ['A', 'B']` → `businessCategories` = `['A', 'B']`
- [ ] `UserModel.fromJson` with legacy `businessCategory: 'X'` (no `businessCategories`) → `businessCategories` = `['X']`

---

## 16. DEPENDENCIES WITH OTHER FEATURES

- **F002 (Auth Redesign):** Any `EmailSignupScreen` or redesigned vendor onboarding screen must use the same checkbox widget from §6.2. Extract into a reusable `VendorCategoryPicker` widget (`lib/features/auth/presentation/widgets/vendor_category_picker.dart`) that both screens import.
- **F001 (Customer Location):** No dependency.
- **F004 (Khata Flow):** No dependency.
- **F005 (Schedule/Subscription):** Service templates are not filtered by category but category metadata is useful context. No hard dependency.
- **Vendor Search (existing):** Category filter query must be updated in the same PR as §5.8 — they are part of the same migration/backend deploy.

---

## 17. SECURITY CONSIDERATIONS

- Max 3 categories enforced by Zod validator on both signup and update routes
- Each category string max 100 chars enforced by Zod — prevents unbounded storage
- Custom free-text categories are user-supplied strings stored verbatim; no HTML rendering on backend so XSS is not a concern at the API layer. Frontend should render as plain `Text` (not HTML)
- Knex parameterizes all values including array elements — SQL injection is not possible via category strings
- GIN index containment query uses parameterized input via Knex `raw` with bound values

---

## 18. ROLLBACK CONSIDERATIONS

- `down()` in `20260035_vendor_multi_category.ts` drops `business_categories` column and GIN index only. `business_category` VARCHAR column survives with its data intact.
- Search `whereRaw` for category filter must be reverted to the old `LOWER(vp.business_category) = LOWER(?)` form when rolling back.
- Frontend rollback: revert `VendorCategoryPicker` checkbox UI back to single `DropdownButtonFormField`. The `UserModel.businessCategories` field can remain (harmlessly empty list).
- Data risk: vendors who set multiple categories or custom categories before rollback will lose all but their first category (only `business_category` survives). This is acceptable for a rollback scenario.
- **Zero-downtime deploy order:**
  1. Deploy backend migration (adds column, backfills, indexes) — old backend code continues to use `business_category`
  2. Deploy new backend code (reads/writes both columns)
  3. Deploy new Flutter app (sends `businessCategories` array)
  4. Rollback is safe at any step in this order
