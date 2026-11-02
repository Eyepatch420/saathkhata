# F011 — Customer Vendor Discovery by Category

**Status:** PLANNING  
**Priority:** LOW-MEDIUM (UX enhancement)  
**Effort:** Frontend 2h · Backend: none  
**Migration:** None  
**Depends on:** F003 (businessCategories array for multi-category vendors)

---

## 1. WHAT EXISTS TODAY

### 1.1 `MyKhatasScreen` (Customer's All Vendors View)

The customer's "Khatas" tab shows all linked vendors as a flat `ListView`:

```
┌─────────────────────────────┐
│  My Vendors          [+]    │
│─────────────────────────────│
│  [Sharma Dairy]  ₹1,250 due │
│  [Ansari Kirana] ₹600 due   │
│  [Meena Tailors] ₹0         │
│  [Raj Tiffin]    ₹200 due   │
└─────────────────────────────┘
```

No grouping, no filter, no category context.

### 1.2 Data Model

`VendorLinkItem` from `GET /links/vendors`:
```dart
class VendorLinkItem {
  final String linkId;
  final double balance;
  final VendorSummary vendor;
  final DateTime createdAt;
}

class VendorSummary {
  final String userId;
  final String businessName;
  final String? businessCategory;  // ← single string only
  // After F003: businessCategories: List<String>? will be added
}
```

### 1.3 Search is Separate

`SearchScreen` is for discovering NEW vendors (unadded). This feature is about the ALREADY-LINKED vendors in MyKhatasScreen. These are two separate concerns.

---

## 2. WHAT CHANGES

### 2.1 Grouped View with Category Headers

```
┌─────────────────────────────────┐
│  My Vendors              [=]    │
│─────────────────────────────────│
│  [All] [Dairy] [Kirana] [Press] │  ← filter chips
│─────────────────────────────────│
│  MILK / DAIRY  (2)              │
│  [Sharma Dairy]  ₹1,250 due     │
│  [Ansari General] ₹600 due      │
│                                 │
│  KIRANA / GROCERY  (1)          │
│  [Raj Kirana]    ₹0             │
│                                 │
│  PRESS / DHOBI  (1)             │
│  [Meena Tailors] ₹0             │
│                                 │
│  OTHER  (1)                     │
│  [Unnamed Vendor] ₹200 due      │
└─────────────────────────────────┘
```

### 2.2 Filter Chip Row

Horizontal scrollable row of chips at the top:
- **"All"** chip — always first, selected by default, shows ungrouped flat list
- One chip per unique category among the customer's vendors
- Only categories that the customer actually has vendors in
- Tapping a category chip scrolls to that group (or filters to show only that category)

---

## 3. GROUPING LOGIC (CLIENT-SIDE)

No backend change needed. All grouping is done from the already-loaded `List<VendorLinkItem>`.

```dart
// In MyKhatasScreen widget or a helper:
Map<String, List<VendorLinkItem>> _groupByCategory(List<VendorLinkItem> vendors) {
  final Map<String, List<VendorLinkItem>> groups = {};
  
  for (final item in vendors) {
    // After F003: use businessCategories[0] as primary; fallback to businessCategory
    final category = item.vendor.businessCategories?.isNotEmpty == true
        ? item.vendor.businessCategories!.first
        : (item.vendor.businessCategory ?? 'Other');
    
    groups.putIfAbsent(category, () => []).add(item);
  }
  
  return groups;
}

List<String> _sortedCategories(Map<String, List<VendorLinkItem>> groups) {
  final categories = groups.keys.toList();
  // "Other" always last
  categories.sort((a, b) {
    if (a == 'Other') return 1;
    if (b == 'Other') return -1;
    return a.compareTo(b);
  });
  return categories;
}
```

### 3.1 Multi-Category Vendors (after F003)

A vendor with `businessCategories = ['Milk / Dairy', 'Kirana / Grocery']` appears under their **primary category** (`categories[0]` = 'Milk / Dairy') only. They do NOT appear under multiple groups. This avoids duplicate tiles.

### 3.2 Vendors with No Category

Shown under an "**Other**" group at the bottom.

---

## 4. FILTER CHIP BEHAVIOR

```dart
String? _activeCategory; // null = "All"

// Filter chip row:
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [
    FilterChip(
      label: Text('All'),
      selected: _activeCategory == null,
      onSelected: (_) => setState(() => _activeCategory = null),
    ),
    ...categories.map((cat) => FilterChip(
      label: Text(_shortCategoryName(cat)), // "Milk / Dairy" → "Dairy"
      selected: _activeCategory == cat,
      onSelected: (_) => setState(() => _activeCategory = cat),
    )),
  ]),
)
```

When `_activeCategory != null`:
- Show only the vendors in that category group
- Hide all other groups + their headers

When `_activeCategory == null` (All):
- Show grouped view with all category headers

### 4.1 Short Category Names for Chips

To keep chips compact in the horizontal scroll:

| Full Name | Chip Label |
|---|---|
| Milk / Dairy | Dairy |
| Press / Dhobi | Press |
| Maid / Cook | Maid |
| Kirana / Grocery | Kirana |
| Tiffin / Food | Tiffin |
| Salon / Parlour | Salon |
| Construction Labour | Labour |
| Transport / Auto | Transport |
| Gym / Fitness | Gym |
| Newspaper | News |
| Other | Other |

---

## 5. WIDGET STRUCTURE

```dart
MyKhatasScreen
  └── Column
        ├── AppBar (existing)
        ├── CategoryFilterRow   ← NEW
        │     └── SingleChildScrollView → Row of FilterChips
        └── Expanded
              └── _activeCategory == null
                    ? GroupedVendorList   ← NEW
                    : FilteredVendorList  ← NEW (flat, single category)

GroupedVendorList
  └── ListView (slivers)
        ├── CategoryHeader("MILK / DAIRY (2)")
        ├── VendorTile(...)
        ├── VendorTile(...)
        ├── CategoryHeader("KIRANA (1)")
        ├── VendorTile(...)
        └── ...

CategoryHeader widget:
  Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      categoryName.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.2,
      ),
    ),
  )
```

`VendorTile` widget is **unchanged** — same tile used in both views.

---

## 6. STATE MANAGEMENT

`CustomerBloc` already loads vendors via `LoadVendors` event → `CustomerLoaded(vendors: List<VendorLinkItem>)`.

No new bloc state needed. The grouping and filtering is **pure widget-level UI logic** — `setState` on `_activeCategory` is sufficient. `CustomerBloc` just provides the flat list; the widget derives the grouped view.

---

## 7. `VendorSummary` MODEL UPDATE

After F003 ships, `VendorSummary` needs `businessCategories`:

```dart
class VendorSummary {
  final String userId;
  final String businessName;
  final String? businessCategory;         // keep for backward compat
  final List<String>? businessCategories; // ← ADD (from F003)
  
  // Convenience getter for primary category
  String? get primaryCategory => 
    businessCategories?.isNotEmpty == true 
      ? businessCategories!.first 
      : businessCategory;
}
```

The `GET /links/vendors` backend response will include `businessCategories` after F003 is deployed.

---

## 8. BACKEND CHANGES

**None required for this feature.** The `GET /links/vendors` endpoint already returns `businessCategory`. After F003 ships, it will also return `businessCategories`. No new endpoint or query change needed.

---

## 9. EMPTY STATES

| State | Display |
|---|---|
| No vendors linked at all | Existing empty state ("Add your first vendor") — unchanged |
| All vendors have no category | Single "Other" group |
| Filter chip active, 0 vendors in that category | Should not happen (chips only shown for existing categories) |

---

## 10. INTERACTION WITH SEARCH FEATURE

The existing `SearchScreen` is for discovering new vendors (unadded). It has its own category filter (`/search/vendors?category=...`). These are separate:

- **MyKhatasScreen** = your connected vendors, grouped by category
- **SearchScreen** = discover new vendors by category

They share the same `VENDOR_CATEGORIES` constant but serve different user intents.

---

## 11. PERFORMANCE

Client-side grouping of 20–100 items is trivial. No memoization needed for typical vendor counts. If a customer somehow has 200+ vendors (unlikely), a `useMemoized` / `ChangeNotifier` approach can be added, but it's premature for this feature.

---

## 12. REQUIRED BACKEND CHANGES

None.

---

## 13. REQUIRED FRONTEND CHANGES

| File | Change |
|---|---|
| `lib/features/customer/presentation/screens/my_khatas_screen.dart` | Add `_activeCategory` state, `CategoryFilterRow`, `GroupedVendorList` |
| `lib/features/search/domain/models/vendor_search_result.dart` | Add `businessCategories: List<String>?` to `VendorSummary` |
| New widget: `CategoryHeader` | Simple styled header widget (can be inline or extracted) |

---

## 14. TESTING STRATEGY

- [ ] Customer with vendors in 3 categories → sees 3 category groups + 3 filter chips
- [ ] "All" chip selected → grouped view with all headers
- [ ] Tap "Dairy" chip → only Dairy vendors shown, other groups hidden
- [ ] Vendor with no category → appears under "Other"
- [ ] Multi-category vendor (after F003) → appears under primary category only, not duplicated
- [ ] Customer with 0 vendors → existing empty state (no chips, no groups)
- [ ] All vendors in same category → one group, one chip (plus "All")
- [ ] VendorTile tap → navigates to SharedLedgerScreen (unchanged)

---

## 15. ROLLBACK

Revert `MyKhatasScreen` to flat `ListView` (remove grouping logic and filter chips). No DB or API changes to revert.

---

## 16. RISKS

| Risk | Likelihood | Mitigation |
|---|---|---|
| Chip row wraps / overflows on small screens | Low | `SingleChildScrollView` horizontal prevents wrapping |
| Category names too long for chips | Medium | Use short category names (see §4.1) |
| F003 not yet deployed when F011 ships | Medium | Graceful fallback: use `businessCategory` (single) if `businessCategories` is null |
