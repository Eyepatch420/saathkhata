# Sprint 3 — Flutter Upload Layer

> **Status:** NOT STARTED
> **Depends on:** Sprint 1 (backend PATCH endpoint live) + Sprint 2 (viewer widgets exist)
> **Blocks:** Nothing (final sprint)
> **See:** [Master Plan](./PAYMENT_PHOTO_PLAN.md) · [Progress](./PROGRESS.md)

---

## Objective

Add photo capture and upload capability across three surfaces:
1. **Vendor/customer entry creation sheet** (`LedgerActions`) — upload-first flow
2. **Entry detail bottom sheet** — attach-later flow for existing pending entries
3. **Staff `RecordEntrySheet`** — upload-first flow, local state only (no LedgerBloc)

By end of Sprint 3, the full payment proof loop is complete:
photo taken → uploaded to Cloudinary → attached to ledger entry → visible in real time to all parties → permanently locked on confirm/dispute.

---

## Critical Design Constraint (read before starting)

`record_entry_sheet.dart` calls `getIt<LedgerRepository>().addEntry()` **directly** — it does NOT go through `LedgerBloc`. This is intentional (staff portal uses the repo directly to avoid bloc coupling). Do NOT add bloc events or dispatch to `LedgerBloc` from the staff sheet. The `attachmentUrl` must flow through the `LedgerEntry` model and the existing `addEntry()` repo call.

The vendor/customer sheet (`LedgerActions`) DOES go through `LedgerBloc` via `AddLedgerEntry` event.

These two flows are handled differently. Keep them separate.

---

## Files to Touch

| File | Change | Notes |
|---|---|---|
| `pubspec.yaml` | Add 3 packages | `image_picker`, `flutter_image_compress`, `dio` |
| `lib/core/services/ledger_attachment_service.dart` | **New file** | Injectable service — handles compress + upload |
| `lib/core/di/injection.dart` | Register service | Add `LedgerAttachmentService` to GetIt |
| `lib/features/shared_ledger/presentation/bloc/ledger_event.dart` | Extend event | Add `attachmentUrl` to `AddLedgerEntry` |
| `lib/features/shared_ledger/domain/repositories/ledger_repository.dart` | Add method | `attachToEntry(entryId, linkId, file)` |
| `lib/features/shared_ledger/data/repositories/ledger_repository_impl.dart` | Implement method | `attachToEntry()` → multipart POST |
| `lib/features/shared_ledger/data/repositories/mock_ledger_repository.dart` | Implement method | Mock stub |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart` | Add camera button | Upload-first in `_showAddEntrySheet()` |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart` | Add attach-later | Button in `_showEntryDetail()` |
| `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart` | Extend | Add "Attach Proof" button for editable state |
| `lib/features/staff_portal/presentation/widgets/record_entry_sheet.dart` | Add camera button | Local state, direct repo call |
| `lib/features/shared_ledger/domain/utils/ledger_permissions.dart` | **New file** | `canEditAttachment()` helper |
| `lib/l10n/app_en.arb` | Add strings | Upload-related UI strings |

---

## Task A — pubspec.yaml Dependencies

```yaml
dependencies:
  image_picker: ^1.1.2
  flutter_image_compress: ^2.3.0
  dio: ^5.7.0
```

Run `flutter pub get` after editing.

**iOS info.plist additions** (if not already present for camera):
```xml
<key>NSCameraUsageDescription</key>
<string>Used to take photos for payment proof</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to attach payment screenshots from gallery</string>
```

**Android** — no changes needed if `targetSdkVersion >= 33` (scoped storage).

---

## Task B — `ledger_permissions.dart` Helper

**New file:** `lib/features/shared_ledger/domain/utils/ledger_permissions.dart`

This is the single authoritative place for the permission rule on Flutter side. Both the entry card and the staff sheet import from here. No duplication.

```dart
import '../../../../shared/models/ledger_entry.dart';

/// Returns true if the current user may add or replace the attachment
/// on this entry.
///
/// Rule mirrors backend canEditAttachment():
///   - Entry must not be locked
///   - Caller must be the creator OR be the vendor-owner of the link
bool canEditAttachment({
  required LedgerEntry entry,
  required String currentUserId,
  required bool isVendorView,
  required String? vendorId,
}) {
  if (entry.isLocked) return false;
  if (entry.createdBy == currentUserId) return true;
  if (isVendorView && vendorId != null && vendorId == entry.vendorId) return true;
  return false;
}
```

---

## Task C — `LedgerAttachmentService`

**New file:** `lib/core/services/ledger_attachment_service.dart`

This is an injectable singleton. Both the vendor sheet and staff sheet use it. It handles:
1. Local compression via `flutter_image_compress`
2. Upload via multipart `dio` to the backend PATCH endpoint
3. Temp upload path for upload-first flow (before entry ID exists)

```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../network/api_client.dart';  // existing Dio client in the project

class LedgerAttachmentService {
  final Dio _dio;

  LedgerAttachmentService(this._dio);

  /// Compress image locally, then upload to backend attachment endpoint.
  /// Returns the Cloudinary URL.
  ///
  /// For attach-later flow: pass the known [entryId].
  /// For upload-first flow: pass null for [entryId] — backend uses temp naming.
  Future<String> uploadAttachment({
    required File imageFile,
    required String linkId,
    String? entryId,
  }) async {
    // 1. Local compress — reduces upload time on slow rural connections
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 75,
      minWidth: 100,
      minHeight: 100,
      keepExif: false,
    );

    if (compressedBytes == null) throw Exception('Image compression failed');

    // 2. Build multipart form
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        compressedBytes,
        filename: entryId != null ? 'entry_$entryId.jpg' : 'temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });

    // 3. POST to backend
    final endpoint = entryId != null
        ? '/links/$linkId/entries/$entryId/attachment'
        : '/links/$linkId/entries/attachment/temp';

    final response = await _dio.patch(endpoint, data: formData);

    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) throw Exception('Upload failed');
    return data['data']['attachmentUrl'] as String;
  }
}
```

**Note on temp upload endpoint:** The temp upload path (`/attachment/temp`) is a lightweight endpoint that only uploads to Cloudinary and returns the URL — it does NOT create a ledger entry. This keeps upload-first clean: Flutter uploads, gets URL, then creates entry with URL embedded. Add this route to `ledger.routes.ts` in Sprint 1 if not already done.

**Register in DI:**

In `lib/core/di/injection.dart`, add:
```dart
getIt.registerLazySingleton<LedgerAttachmentService>(
  () => LedgerAttachmentService(getIt<Dio>()),
);
```

---

## Task D — Extend `AddLedgerEntry` Event

**File:** `lib/features/shared_ledger/presentation/bloc/ledger_event.dart`

**Current:**
```dart
class AddLedgerEntry extends LedgerEvent {
  final double amount;
  final EntryType type;
  final String? description;
  final double? quantity;
  final String? unit;
  final String linkId;
  ...
}
```

**Add:**
```dart
final String? attachmentUrl;

const AddLedgerEntry({
  required this.amount,
  required this.type,
  required this.linkId,
  this.description,
  this.quantity,
  this.unit,
  this.attachmentUrl,   // ← new
});

@override
List<Object?> get props => [amount, type, description, quantity, unit, linkId, attachmentUrl];
```

Verify that `LedgerBloc._onAddEntry()` passes `attachmentUrl` through to `LedgerRepository.addEntry()`. Check `ledger_bloc.dart` — the entry constructed there must include `attachmentUrl: event.attachmentUrl`.

---

## Task E — `LedgerRepository` + Impls

### Abstract interface

**File:** `lib/features/shared_ledger/domain/repositories/ledger_repository.dart`

Add:
```dart
/// Upload or replace a photo proof on a pending entry.
/// Calls PATCH /links/:linkId/entries/:entryId/attachment
Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile);
```

### Real implementation

**File:** `lib/features/shared_ledger/data/repositories/ledger_repository_impl.dart`

```dart
@override
Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile) async {
  final url = await getIt<LedgerAttachmentService>().uploadAttachment(
    imageFile: imageFile,
    linkId: linkId,
    entryId: entryId,
  );
  // The backend returns the updated entry — parse it
  // But we already get it via the socket broadcast (ledger:entry_updated)
  // So we can return a dummy or the parsed response — either is fine
  // since LedgerBloc picks up the socket event and updates state anyway.
  return LedgerEntry(
    id: entryId,
    linkId: linkId,
    amount: 0,
    type: EntryType.payment,
    date: DateTime.now(),
    status: EntryStatus.pending,
    createdBy: '',
    attachmentUrl: url,
  );
}
```

**Better pattern:** Parse the actual response from the PATCH endpoint rather than constructing a dummy. Check `ledger_repository_impl.dart` for how `addEntry()` maps the API response to `LedgerEntry` — use the same pattern.

### Mock implementation

**File:** `lib/features/shared_ledger/data/repositories/mock_ledger_repository.dart`

```dart
@override
Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile) async {
  await Future.delayed(const Duration(milliseconds: 800));
  // Return a mock entry — in dev the socket won't fire so simulate via state
  return LedgerEntry(
    id: entryId,
    linkId: linkId,
    amount: 100,
    type: EntryType.payment,
    date: DateTime.now(),
    status: EntryStatus.pending,
    createdBy: 'mock-user',
    attachmentUrl: 'https://res.cloudinary.com/mock/mock_attachment.jpg',
  );
}
```

---

## Task F — Camera Button in `LedgerActions._showAddEntrySheet()` (vendor/customer upload-first)

**File:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart`

The `_showAddEntrySheet()` method shows a `StatelessWidget` bottom sheet via `showModalBottomSheet`. Convert the `builder` body to a `StatefulWidget` so we can hold `_pendingUrl` and show a thumbnail preview.

**Pattern:**

Replace the `builder: (ctx) => Padding(...)` with a `builder: (ctx) => _AddEntrySheet(bloc: bloc, type: type, linkId: linkId, customerName: customerName)` and extract to a new `StatefulWidget` `_AddEntrySheet`.

Inside `_AddEntrySheetState`:
```dart
String? _pendingUrl;
bool _uploading = false;

// Camera button widget (add above amount field):
Row(
  children: [
    OutlinedButton.icon(
      onPressed: _uploading ? null : () => _pickAndUpload(ImageSource.camera),
      icon: const Icon(Icons.camera_alt_rounded, size: 16),
      label: const Text('Camera'),
    ),
    const SizedBox(width: 10),
    OutlinedButton.icon(
      onPressed: _uploading ? null : () => _pickAndUpload(ImageSource.gallery),
      icon: const Icon(Icons.photo_library_rounded, size: 16),
      label: const Text('Gallery'),
    ),
    if (_uploading) ...[
      const SizedBox(width: 10),
      const SizedBox(
        width: 16, height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ],
  ],
),
if (_pendingUrl != null) ...[
  const SizedBox(height: 12),
  LedgerAttachmentSection(
    attachmentUrl: _pendingUrl,
    isLocked: false,
    heroTag: 'new_entry_attachment',
  ),
],

// Upload logic:
Future<void> _pickAndUpload(ImageSource source) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: source, imageQuality: 85);
  if (picked == null) return;

  setState(() => _uploading = true);
  try {
    final url = await getIt<LedgerAttachmentService>().uploadAttachment(
      imageFile: File(picked.path),
      linkId: widget.linkId,
      entryId: null,  // upload-first: no entryId yet
    );
    setState(() { _pendingUrl = url; _uploading = false; });
  } catch (e) {
    setState(() => _uploading = false);
    if (mounted) AppToast.show(context, 'Upload failed: ${e.toString().replaceFirst('Exception: ', '')}', type: ToastType.error);
  }
}

// When submitting:
widget.bloc.add(AddLedgerEntry(
  amount: amount,
  type: widget.type,
  linkId: widget.linkId,
  description: ...,
  quantity: ...,
  attachmentUrl: _pendingUrl,   // ← pass the URL
));
```

---

## Task G — Attach-Later Button in Entry Detail Sheet

**File:** `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart`

The `_showEntryDetail()` method currently shows a bottom sheet with a static list of `LedgerDetailRow` widgets. We need to make it stateful to handle the upload.

**Pattern:** Extract the detail sheet builder to `_EntryDetailSheet` StatefulWidget.

Inside `_EntryDetailSheetState`, after the `LedgerAttachmentSection` (added in Sprint 2):

```dart
// Show attach button only if user can edit
if (canEditAttachment(
    entry: entry,
    currentUserId: currentUserId,
    isVendorView: isVendorView,
    vendorId: entry.vendorId,
  ) && entry.attachmentUrl == null) ...[
  const SizedBox(height: 12),
  SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: _uploadInProgress ? null : _attachProof,
      icon: _uploadInProgress
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.attach_file_rounded, size: 16),
      label: Text(_uploadInProgress ? 'Uploading...' : 'Attach Proof'),
    ),
  ),
],
// If there's already a photo, show a "Replace" option (only while pending)
if (canEditAttachment(...) && entry.attachmentUrl != null) ...[
  const SizedBox(height: 6),
  TextButton.icon(
    onPressed: _uploadInProgress ? null : _attachProof,
    icon: const Icon(Icons.refresh_rounded, size: 14),
    label: const Text('Replace Photo', style: TextStyle(fontSize: 12)),
  ),
],
```

```dart
Future<void> _attachProof() async {
  final source = await _showSourcePicker();  // simple dialog: Camera / Gallery
  if (source == null) return;

  final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
  if (picked == null || !mounted) return;

  setState(() => _uploadInProgress = true);
  try {
    // Use repo's attachToEntry which calls LedgerAttachmentService internally
    final updated = await getIt<LedgerRepository>().attachToEntry(
      entry.id,
      entry.linkId,
      File(picked.path),
    );
    // Socket will broadcast entry_updated → bloc updates state → card rerenders
    if (mounted) {
      Navigator.pop(context);  // close sheet — card will update via socket
      AppToast.show(context, 'Proof attached', type: ToastType.success);
    }
  } catch (e) {
    if (mounted) {
      setState(() => _uploadInProgress = false);
      AppToast.show(context, e.toString().replaceFirst('Exception: ', ''), type: ToastType.error);
    }
  }
}
```

---

## Task H — Staff `RecordEntrySheet` Camera Button

**File:** `lib/features/staff_portal/presentation/widgets/record_entry_sheet.dart`

**IMPORTANT — this does NOT use LedgerBloc. It calls `getIt<LedgerRepository>().addEntry()` directly.**

In `_RecordEntrySheetState`:

1. Add state variable:
```dart
String? _pendingAttachmentUrl;
bool _uploadingPhoto = false;
```

2. Add camera button row (add above the submit button, below the note/amount field):
```dart
Row(
  children: [
    OutlinedButton.icon(
      onPressed: _uploadingPhoto ? null : () => _pickAndUpload(ImageSource.camera),
      icon: const Icon(Icons.camera_alt_rounded, size: 16),
      label: const Text('Camera'),
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
    ),
    const SizedBox(width: 8),
    OutlinedButton.icon(
      onPressed: _uploadingPhoto ? null : () => _pickAndUpload(ImageSource.gallery),
      icon: const Icon(Icons.photo_library_rounded, size: 16),
      label: const Text('Gallery'),
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
    ),
    if (_uploadingPhoto)
      const Padding(
        padding: EdgeInsets.only(left: 10),
        child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
  ],
),
if (_pendingAttachmentUrl != null) ...[
  const SizedBox(height: 10),
  LedgerAttachmentSection(
    attachmentUrl: _pendingAttachmentUrl,
    isLocked: false,
    heroTag: 'staff_new_entry_attachment',
  ),
],
```

3. Add `_pickAndUpload()`:
```dart
Future<void> _pickAndUpload(ImageSource source) async {
  final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
  if (picked == null || !mounted) return;

  setState(() => _uploadingPhoto = true);
  try {
    final linkId = _customer!.linkId;
    final url = await getIt<LedgerAttachmentService>().uploadAttachment(
      imageFile: File(picked.path),
      linkId: linkId,
      entryId: null,  // temp upload, no entryId yet
    );
    setState(() { _pendingAttachmentUrl = url; _uploadingPhoto = false; });
  } catch (e) {
    setState(() => _uploadingPhoto = false);
    if (mounted) AppToast.show(context, 'Photo upload failed', type: ToastType.error);
  }
}
```

4. In `_submit()`, update the `addEntry()` call to pass `attachmentUrl`:

The current `_submit()` calls:
```dart
await getIt<LedgerRepository>().addEntry(
  LedgerEntry(
    id: '',
    linkId: _customer!.linkId,
    amount: _amount,
    type: widget.type,
    date: DateTime.now(),
    description: desc,
    quantity: ...,
    status: EntryStatus.pending,
    createdBy: '',
  ),
);
```

Add `attachmentUrl: _pendingAttachmentUrl` to the `LedgerEntry` constructor call. The `LedgerRepositoryImpl.addEntry()` already serializes `attachmentUrl` from the model if it's non-null (verify this in `ledger_repository_impl.dart` — check the `toJson()` or the manual JSON construction in the POST body).

---

## Task I — l10n Strings

**File:** `lib/l10n/app_en.arb`

Add the following keys:
```json
"attachProof": "Attach Proof",
"replacePhoto": "Replace Photo",
"uploading": "Uploading...",
"photoUploadFailed": "Photo upload failed",
"proofAttached": "Proof attached",
"proofLocked": "Proof Locked",
"camera": "Camera",
"gallery": "Gallery",
"selectPhotoSource": "Add payment proof",
"paymentProof": "Payment Proof"
```

After editing `app_en.arb`, run `flutter gen-l10n` to regenerate all localization files. Then update `app_localizations.dart` and all `app_localizations_*.dart` files (or let the gen tool handle it).

Per project feedback convention: add the import and usage together in each widget file, not in separate edits.

---

## Code Flow Simulation — Full Upload-First (Vendor)

```
User taps "Give Credit" in LedgerActions
  → _showAddEntrySheet() opens _AddEntrySheet (StatefulWidget)
  → User taps "Camera" button
    → _pickAndUpload(ImageSource.camera)
      → ImagePicker.pickImage() → File
      → setState(_uploading = true)
      → LedgerAttachmentService.uploadAttachment(file, linkId, entryId: null)
          → FlutterImageCompress.compressWithFile() → Uint8List
          → dio.patch('/links/linkId/entries/attachment/temp', FormData)
          → Backend: uploads to Cloudinary temp/ folder → returns url
      → setState(_pendingUrl = url, _uploading = false)
      → LedgerAttachmentSection thumbnail appears in sheet
  → User fills amount + description
  → User taps submit
    → LedgerBloc.add(AddLedgerEntry(..., attachmentUrl: _pendingUrl))
      → LedgerBloc._onAddEntry()
        → LedgerRepository.addEntry(entry with attachmentUrl)
          → POST /links/linkId/entries { amount, type, ..., attachmentUrl: url }
          → Backend: creates entry with attachment_url = url
          → Socket: emitLedgerEvent('ledger:entry_added', linkId, {entry})
      → SocketLedgerEntryAdded(entry) received by SharedLedgerScreen
      → LedgerBloc._onSocketEntryAdded → adds to state list
      → LedgerList rebuilds → LedgerEntryCard shows thumbnail immediately
```

## Code Flow Simulation — Attach-Later (Customer on Payment Entry)

```
Customer opens LedgerEntryCard → taps card → _showEntryDetail()
  → _EntryDetailSheet (StatefulWidget) renders
  → canEditAttachment(entry, customerId, isVendorView: false, vendorId) = true
    (customer created this payment entry, entry is pending)
  → "Attach Proof" button visible
  → Customer taps "Attach Proof"
    → _attachProof()
      → _showSourcePicker() → user picks Gallery
      → ImagePicker.pickImage() → File
      → setState(_uploadInProgress = true)
      → getIt<LedgerRepository>().attachToEntry(entryId, linkId, file)
          → LedgerAttachmentService.uploadAttachment(file, linkId, entryId)
              → compress → dio.patch('/links/linkId/entries/entryId/attachment', FormData)
              → Backend: canEditAttachment check passes
              → Cloudinary: saath_khata/ledger_attachments/linkId/entry_entryId
              → DB: UPDATE ledger_entries SET attachment_url = ... WHERE id = entryId
              → Socket: emitLedgerEvent('ledger:entry_updated', linkId, {entry})
          → Returns updated entry
      → Navigator.pop (closes detail sheet)
      → AppToast.show('Proof attached')
  → LedgerSocketService.onEntryUpdated fires → SocketLedgerEntryUpdated(entry)
  → LedgerBloc._onSocketEntryUpdated → replaces entry in state list
  → LedgerEntryCard rebuilds with thumbnail
```

---

## Edge Cases Handled in This Sprint

| Scenario | Handling |
|---|---|
| User picks photo then cancels entry | Temp upload is an orphan — accepted, negligible cost |
| Upload fails mid-way (network error) | `_uploading` / `_uploadingPhoto` resets to false, toast shown, entry not created |
| Staff submits without a photo | `_pendingAttachmentUrl = null` → `addEntry()` with `attachmentUrl = null` → standard behavior |
| Staff tries to attach on another staff's pending entry | Backend `canEditAttachment()` rejects → 403 → repo throws → toast shown |
| Entry gets confirmed between user opening sheet and tapping attach | Backend `is_locked` check → 403 → toast: "Entry is locked..." |
| Large photo (3-4MB) selected | `FlutterImageCompress` reduces to ~300-600KB before upload → fast on slow connections |
| iOS permission denied (camera/gallery) | `image_picker` throws → catch block → show permission error toast |
| `_customer` is null when staff taps camera | Camera button is disabled if `_customer == null` (same guard as submit button) |
| Duplicate heroTag across new entry sheets | All temp upload thumbnails use `heroTag: 'new_entry_attachment'` — acceptable since only one sheet is open at a time |

---

## Verification Checklist

Before marking Sprint 3 done, confirm:

- [ ] Vendor can open "Give Credit" sheet → see Camera + Gallery buttons
- [ ] Tapping Camera on vendor sheet → takes photo → thumbnail appears in sheet
- [ ] Submitting vendor sheet with photo → entry created with thumbnail in ledger
- [ ] Submitting vendor sheet without photo → entry created normally (no regression)
- [ ] Customer can open "Record Payment" sheet → see Camera + Gallery buttons
- [ ] Customer takes photo → thumbnail in sheet → entry created with photo
- [ ] Entry card shows thumbnail after creation (via socket update)
- [ ] Existing pending entry with no photo → "Attach Proof" button visible in detail sheet (when `canEditAttachment` = true)
- [ ] Attach proof → uploads → socket fires → card thumbnail appears without reopening
- [ ] Existing pending entry with photo → "Replace Photo" button visible in detail sheet
- [ ] Replace photo → Cloudinary overwrites, socket fires, card updates
- [ ] Confirmed/disputed entry → no "Attach Proof" button visible
- [ ] Staff can record delivery → sees Camera + Gallery buttons
- [ ] Staff records payment with photo → entry created → thumbnail appears in vendor's ledger view
- [ ] Staff records payment without photo → normal entry (no regression)
- [ ] Photo on staff entry is NOT replaceable by another staff member
- [ ] Photo on staff entry IS replaceable by vendor owner (while pending)
- [ ] All new strings available in at least English (other languages can be added after)
- [ ] `flutter analyze` passes
- [ ] `flutter build` passes (no compile errors)

---

## Post-Sprint Tech Debt

- [ ] Add all new l10n keys to all 13 language ARB files (bho, bn, gu, hi, kn, mai, ml, mr, pa, ta, te + bho + en)
- [ ] Add `temp/` folder cleanup endpoint or cron to backend (delete Cloudinary temp uploads > 30 days)
- [ ] Consider signed Cloudinary URLs if customer data privacy requirements tighten
- [ ] Re-enable UPI payments tab (`AppRiveIcon.zap`) when UPI gateway is ready
