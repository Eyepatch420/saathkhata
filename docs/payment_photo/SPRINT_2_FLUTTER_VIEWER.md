# Sprint 2 — Flutter Viewer Layer

> **Status:** NOT STARTED
> **Depends on:** Sprint 1 deployed and returning real `attachmentUrl` from API
> **Blocks:** Sprint 3 (upload flows build on top of the viewer widgets)
> **See:** [Master Plan](./PAYMENT_PHOTO_PLAN.md) · [Progress](./PROGRESS.md)

---

## Objective

Build the display side only — no uploads yet. By end of Sprint 2:
- The Payments tab is hidden from customer nav
- Any entry with `attachmentUrl != null` shows a thumbnail in the ledger card
- Tapping the card opens a detail sheet that includes the photo
- Tapping the thumbnail opens a full-screen zoomable viewer
- Locked entries show a visual lock indicator on the thumbnail

No camera buttons, no uploads, no `image_picker`. That is Sprint 3.

---

## Files to Touch

| File | Change | Notes |
|---|---|---|
| `lib/core/router/app_router.dart` | Remove Payments tab from customer nav | Hide only, keep route and file |
| `pubspec.yaml` | Add `cached_network_image` | For network image thumbnails |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart` | Add thumbnail | Below the existing row |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart` | **New file** | Extracted widget — thumbnail + viewer |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/full_screen_photo_viewer.dart` | **New file** | `InteractiveViewer` + `Hero` full screen |

---

## Task A — Hide Customer Payments Tab

**File:** `lib/core/router/app_router.dart`

### In `CustomerMainWrapper.build()` — `AppBottomNavBar` items

**Current (lines ~615–621):**
```dart
items: const [
  AppNavItem(riveIcon: AppRiveIcon.home,     label: 'Home'),
  AppNavItem(riveIcon: AppRiveIcon.message,  label: 'My Khatas'),
  AppNavItem(riveIcon: AppRiveIcon.clock,    label: 'Bookings'),
  AppNavItem(riveIcon: AppRiveIcon.zap,      label: 'Payments'),   // ← REMOVE
  AppNavItem(riveIcon: AppRiveIcon.user,     label: 'Profile'),
],
```

**After:**
```dart
items: const [
  AppNavItem(riveIcon: AppRiveIcon.home,     label: 'Home'),
  AppNavItem(riveIcon: AppRiveIcon.message,  label: 'My Khatas'),
  AppNavItem(riveIcon: AppRiveIcon.clock,    label: 'Bookings'),
  AppNavItem(riveIcon: AppRiveIcon.user,     label: 'Profile'),
],
```

### In `_calculateSelectedIndex()`

**Current:**
```dart
if (location == AppRouter.customerHome)     return 0;
if (location == AppRouter.customerKhatas)  return 1;
if (location == AppRouter.customerBookings) return 2;
if (location == AppRouter.customerPayments) return 3;  // ← REMOVE
if (location == AppRouter.customerProfile) return 4;   // becomes 3
return 0;
```

**After:**
```dart
if (location == AppRouter.customerHome)      return 0;
if (location == AppRouter.customerKhatas)   return 1;
if (location == AppRouter.customerBookings) return 2;
if (location == AppRouter.customerProfile)  return 3;
return 0;
```

### In `_onTap()`

**Current:**
```dart
case 0: context.go(AppRouter.customerHome);      break;
case 1: context.go(AppRouter.customerKhatas);    break;
case 2: context.go(AppRouter.customerBookings);  break;
case 3: context.go(AppRouter.customerPayments);  break;  // ← REMOVE
case 4: context.go(AppRouter.customerProfile);   break;  // becomes 3
```

**After:**
```dart
case 0: context.go(AppRouter.customerHome);      break;
case 1: context.go(AppRouter.customerKhatas);    break;
case 2: context.go(AppRouter.customerBookings);  break;
case 3: context.go(AppRouter.customerProfile);   break;
```

**Do NOT touch:**
- The `customerPayments` route definition in the `ShellRoute` routes list
- The `PaymentsScreen` file at `features/customer/presentation/screens/payments_screen.dart`
- The `features/payments/` folder

---

## Task B — Add `cached_network_image` to pubspec

**File:** `pubspec.yaml`

Add under `dependencies:`:
```yaml
cached_network_image: ^3.4.1
```

Run `flutter pub get` after editing.

---

## Task C — New Widget: `LedgerAttachmentSection`

**New file:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart`

This widget is reused in both the card thumbnail and the detail sheet. Keeping it extracted means graphify tracks it as a single distinct node rather than duplicated inline logic.

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import 'full_screen_photo_viewer.dart';

/// Shows a thumbnail if [attachmentUrl] is set.
/// If [isLocked] is true, shows a lock badge over the thumbnail.
/// Tapping opens [FullScreenPhotoViewer].
class LedgerAttachmentSection extends StatelessWidget {
  final String? attachmentUrl;
  final bool isLocked;
  /// heroTag must be unique per entry — pass entry.id
  final String heroTag;

  const LedgerAttachmentSection({
    super.key,
    required this.attachmentUrl,
    required this.isLocked,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (attachmentUrl == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Hero(
              tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: attachmentUrl!,
                width: 150,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 150,
                  height: 100,
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 150,
                  height: 100,
                  color: AppColors.textHint.withValues(alpha: 0.1),
                  child: const Icon(Icons.broken_image_rounded,
                      color: AppColors.textHint),
                ),
              ),
            ),
            if (isLocked)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded, color: Colors.white, size: 10),
                      SizedBox(width: 3),
                      Text('Proof Locked',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => FullScreenPhotoViewer(
          imageUrl: attachmentUrl!,
          heroTag: heroTag,
          isLocked: isLocked,
        ),
      ),
    );
  }
}
```

---

## Task D — New Widget: `FullScreenPhotoViewer`

**New file:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/full_screen_photo_viewer.dart`

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';

class FullScreenPhotoViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final bool isLocked;

  const FullScreenPhotoViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isLocked
            ? Row(
                children: [
                  const Icon(Icons.lock_rounded, color: AppColors.warning, size: 16),
                  const SizedBox(width: 6),
                  Text('Proof Locked',
                      style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                ],
              )
            : Text('Payment Proof',
                style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Hero(
            tag: heroTag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (_, __) => const CircularProgressIndicator(
                color: Colors.white,
              ),
              errorWidget: (_, __, ___) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 48),
                  const SizedBox(height: 8),
                  Text('Could not load image',
                      style: AppTypography.bodySmall
                          .copyWith(color: Colors.white54)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Task E — Add Thumbnail to `LedgerEntryCard`

**File:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart`

**Add import:**
```dart
import 'attachment_section.dart';
```

**In `LedgerEntryCard.build()`, after the main `Row` (before the pending action buttons section), add:**

```dart
if (entry.attachmentUrl != null) ...[
  const SizedBox(height: 12),
  LedgerAttachmentSection(
    attachmentUrl: entry.attachmentUrl,
    isLocked: entry.isLocked,
    heroTag: 'entry_attachment_${entry.id}',
  ),
],
```

The full card `Column` structure becomes:
```
Row (icon + description + amount + status chip)
  ↓  [if attachmentUrl != null]
LedgerAttachmentSection (thumbnail)
  ↓  [if pending + not locked + right side]
Row (Dispute / Confirm buttons)
  ↓  [if disputed]
dispute reason row
```

---

## Task F — Add Photo to `_showEntryDetail()` Bottom Sheet

**File:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart`

**In `_showEntryDetail()`, add the attachment section after the existing `LedgerDetailRow` fields and before the final `SizedBox(height: 8)`:**

```dart
if (entry.attachmentUrl != null) ...[
  const Divider(height: 24),
  LedgerAttachmentSection(
    attachmentUrl: entry.attachmentUrl,
    isLocked: entry.isLocked,
    heroTag: 'detail_attachment_${entry.id}',  // different heroTag from card
  ),
  const SizedBox(height: 8),
  if (entry.isLocked)
    Row(
      children: [
        const Icon(Icons.lock_rounded, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          'This proof is locked and cannot be changed',
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textHint, fontSize: 11),
        ),
      ],
    ),
],
```

**Important:** The detail sheet's `LedgerAttachmentSection` uses a different `heroTag` (`detail_attachment_${entry.id}`) than the card (`entry_attachment_${entry.id}`). If they shared the same tag, the Hero animation would conflict when both are visible simultaneously. Using different tags is intentional.

---

## Code Flow Simulation

```
SharedLedgerScreen
  → LedgerBloc loads entries via LedgerRepository.getEntries()
  → API GET /links/:linkId/entries → entries with attachmentUrl field
  → LedgerBloc emits LedgerLoaded(entries: [...])
  → LedgerList builds LedgerEntryCard for each entry

LedgerEntryCard.build()
  → entry.attachmentUrl != null?
      YES → LedgerAttachmentSection(url, isLocked: entry.isLocked)
              → CachedNetworkImage (thumbnail 150×100)
              → if isLocked → 'Proof Locked' badge overlay
              → onTap → FullScreenPhotoViewer via PageRouteBuilder
      NO  → SizedBox.shrink()  (no visual change for entries without photo)

  → entry.status == pending && !isLocked?
      → Dispute / Confirm buttons (unchanged)

LedgerEntryCard._showEntryDetail()
  → LedgerDetailRow × N (amount, type, date, etc)
  → if attachmentUrl != null → Divider + LedgerAttachmentSection (larger view)
  → if isLocked → lock explanation text

FullScreenPhotoViewer
  → Hero animation from thumbnail
  → AppBar with lock indicator if locked
  → InteractiveViewer (zoom 0.5x → 5x)
  → tap back → Hero animation back to card
```

---

## Edge Cases Handled in This Sprint

| Scenario | Handling |
|---|---|
| `attachmentUrl` is null | `LedgerAttachmentSection` returns `SizedBox.shrink()` — zero visual impact |
| Cloudinary URL fails to load | `errorWidget` shows broken image icon with fallback |
| Entry is locked but has a photo | Lock badge overlay on thumbnail + lock text in detail sheet |
| Two entries with photos visible simultaneously | Distinct `heroTag` per entry prevents Hero conflicts |
| Detail sheet and card both visible (nested Hero) | Different heroTag prefixes: `entry_attachment_` vs `detail_attachment_` |
| Large image (pre-compress on backend) | Cloudinary serves optimized version via `fetch_format: auto` — fast load |

---

## Verification Checklist

Before marking Sprint 2 done, confirm:

- [ ] Customer bottom nav shows 4 tabs (Home, My Khatas, Bookings, Profile) — Payments tab gone
- [ ] Profile tab is now index 3 (was 4) — tapping it navigates correctly
- [ ] Navigating to `/customer/payments` directly still works (route not deleted)
- [ ] Entry card with `attachmentUrl` shows 150×100 thumbnail below the amount row
- [ ] Entry card without `attachmentUrl` shows no thumbnail (no layout shift)
- [ ] Locked entry shows "Proof Locked" badge on thumbnail
- [ ] Tapping thumbnail opens full-screen viewer with Hero animation
- [ ] Full-screen viewer has lock indicator in AppBar when entry is locked
- [ ] InteractiveViewer allows zoom and pan
- [ ] Back navigation from full-screen viewer Hero-animates back to thumbnail
- [ ] Detail bottom sheet shows photo section below existing detail rows
- [ ] Detail sheet shows lock explanation text for locked entries
- [ ] No compile errors — all imports resolved
- [ ] Hot reload works on entry card changes (no state loss)

---

## Notes for Sprint 3

After Sprint 2 is done, Sprint 3 adds upload capability. It builds directly on:
- `LedgerAttachmentSection` — Sprint 3 will add an "Attach Proof" button below/beside it for editable entries
- `_showEntryDetail()` sheet — Sprint 3 will add "Attach Proof" button here for the attach-later flow
- `_RecordEntrySheetState` in `record_entry_sheet.dart` — Sprint 3 adds camera button and local `_pendingAttachmentUrl` state
