# Manual Payment + Photo-to-Ledger System — Master Plan

> **Status:** Planning complete. Sprint 1 not yet started.
> **Last updated:** 2026-06-23
> **See also:** [PROGRESS.md](./PROGRESS.md) · [SPRINT_1_BACKEND.md](./SPRINT_1_BACKEND.md) · [SPRINT_2_FLUTTER_VIEWER.md](./SPRINT_2_FLUTTER_VIEWER.md) · [SPRINT_3_FLUTTER_UPLOAD.md](./SPRINT_3_FLUTTER_UPLOAD.md) · [GRAPH_CONTEXT.md](./GRAPH_CONTEXT.md)

---

## Goal

Replace the visible UPI/gateway Payments tab with a ledger-centric payment proof system.

```
BEFORE (current)           AFTER (target)
────────────────           ──────────────
Payment                    Ledger Entry
  ↓                          ↓
UPI Gateway                Optional Photo Proof
  ↓                          ↓
Payment Records            Confirm / Dispute
                             ↓
                           Lock Forever (is_locked = true)
```

The ledger becomes the single source of truth. The `features/payments/` folder is not deleted — it is hidden from nav only, so it can be re-enabled later.

---

## Core Principle

A photo attached to a ledger entry is evidence. Once the entry transitions to `confirmed` or `disputed`, `is_locked` becomes `true` and the attachment is permanently frozen. No one — vendor, customer, staff, or admin — can replace, remove, or re-upload it after that point.

---

## What Already Exists (do not rebuild)

| Asset | Location | Status |
|---|---|---|
| `attachment_url VARCHAR(500)` | DB `ledger_entries` table | ✅ Exists — no migration for this field |
| `CloudinaryService` | `src/infrastructure/cloudinary/client.ts` | ✅ Exists — add one new method |
| `is_locked` enforcement | `ledger.service.ts` confirm/dispute | ✅ Already blocks mutation on locked entries |
| `attachmentUrl` in `LedgerEntryResponse` | `ledger.types.ts` + `formatEntry()` | ✅ Already serialized to Flutter |
| `attachmentUrl` in `LedgerEntry` Flutter model | `lib/shared/models/ledger_entry.dart` | ✅ Field exists, just never populated |
| Multer image upload pattern | `staff.routes.ts` (`qrUpload`) | ✅ Copy-paste pattern |
| `StaffContext` for staff-as-vendor | `ledger.service.ts` | ✅ Staff already act as vendor-side |
| `emitLedgerEvent()` socket broadcast | `ledger-socket.ts` | ✅ Already wired in service |

---

## What Must Be Built

### Backend (Sprint 1)
1. `CloudinaryService.uploadLedgerAttachment()` — new method in `client.ts`
2. `addEntrySchema` — add `attachmentUrl` field in `ledger.validators.ts`
3. `AddEntryInput` — add `attachmentUrl?` in `ledger.types.ts`
4. `LedgerRepository.updateAttachment()` — new repo method
5. `LedgerService.attachToEntry()` — new service method with permission check
6. `LedgerController.attachToEntry()` — new controller handler
7. `PATCH /links/:linkId/entries/:entryId/attachment` — new route with multer middleware
8. Pass `attachmentUrl` through `ledgerRepo.create()` in `addEntry()` service method
9. Optional migration: `attachment_uploaded_by` + `attachment_uploaded_at` columns (decision needed)

### Flutter (Sprint 2 — viewer layer)
10. `CachedNetworkImage` thumbnail in `entry_card.dart`
11. Photo section in `_showEntryDetail()` bottom sheet
12. Full-screen `InteractiveViewer` photo viewer
13. Lock overlay on thumbnail when `isLocked = true`
14. `pubspec.yaml` — add `cached_network_image`

### Flutter (Sprint 3 — upload layer)
15. `pubspec.yaml` — add `image_picker`, `flutter_image_compress`, `dio`
16. `lib/core/services/ledger_attachment_service.dart` — new service
17. Camera/gallery button in `LedgerActions._showAddEntrySheet()` (vendor flow)
18. Local `_pendingAttachmentUrl` state in `_RecordEntrySheetState` (staff flow — **not bloc**)
19. Attach-later button in `entry_card.dart` detail sheet
20. `AddLedgerEntry` event — add `attachmentUrl` field
21. `LedgerRepository.attachToEntry()` abstract method + impl + mock

---

## Permission Model

### Who can view a photo
Anyone sharing the ledger: vendor, customer, staff. `attachment_url` is a public Cloudinary URL — no signed URLs needed since both parties already have a business relationship (active link).

### Who can upload/replace
```
canEditAttachment =
  !entry.is_locked
  && (
    entry.createdBy == currentUser.id          // creator (vendor, customer, or staff who made it)
    || (currentUser.role == 'vendor'
        && currentUser.id == link.vendorId)    // vendor-owner override ONLY
  )
```

**Key design decisions:**
- Staff CANNOT edit another staff member's attachment — only the creating staff member or the vendor owner can.
- Vendor owner override is intentional: if staff uploads wrong photo before customer confirms, vendor can correct it.
- Customer can upload proof on their own payment entries only.

### When it locks forever
```
status = 'confirmed'  →  is_locked = true  →  canEditAttachment = false for everyone
status = 'disputed'   →  is_locked = true  →  canEditAttachment = false for everyone
```

No exceptions. This is enforced at the service layer on the backend, not just the UI.

---

## Cloudinary Folder Structure

```
saath_khata/
└── ledger_attachments/
    ├── {linkId}/
    │   └── entry_{entryId}      ← attach-later flow
    └── temp/
        └── temp_{userId}_{ts}   ← upload-first flow (orphan-safe)
```

**Transformations applied on every upload:**
```json
{ "width": 1200, "height": 1200, "crop": "limit", "quality": "auto", "fetch_format": "auto" }
```

Typical result: 4MB screenshot → 200–500KB.

**Orphan handling:** temp uploads that never become entries are accepted as low-cost orphans. A future cron job (not in scope now — marked as tech debt) can delete `temp/` files older than 30 days.

---

## Backend API Surface

### Existing endpoint — extended
```
POST /api/v1/links/:linkId/entries
Body: { amount, type, description?, quantity?, unit?, date?, attachmentUrl? }
```
The `attachmentUrl` field is new. Flutter sends it when using the upload-first flow.

### New endpoint
```
PATCH /api/v1/links/:linkId/entries/:entryId/attachment
Content-Type: multipart/form-data
Field: file (image, max 5MB)

Guards:
  - authenticate middleware
  - entry.is_locked === false
  - canEditAttachment(entry, req.user, link)

Response: { success: true, attachmentUrl: string, entry: LedgerEntryResponse }
```

After successful upload, socket emits `ledger:entry_updated` to the `linkId` room so both parties see the photo appear in real time.

---

## Flutter Data Flow (traced from graph)

### Upload-first (vendor/customer creating new entry)

```
LedgerActions._showAddEntrySheet()
  → [user taps camera icon]
  → LedgerAttachmentService.uploadAttachment(file, linkId, 'temp_${userId}_${ts}')
      → POST multipart to PATCH endpoint? No — temp uploads go direct to Cloudinary
      → Actually: POST /api/v1/upload/ledger-temp (new lightweight endpoint)
      → Returns: { attachmentUrl: string }
  → _pendingUrl stored in sheet StatefulWidget state
  → Thumbnail shown inline in the sheet
  → [user taps submit]
  → LedgerBloc.add(AddLedgerEntry(..., attachmentUrl: _pendingUrl))
      → LedgerRepository.addEntry(entry with attachmentUrl)
      → POST /api/v1/links/:linkId/entries
      → Backend creates entry with attachment_url already set
      → Socket emits ledger:entry_added
      → LedgerBloc._onSocketEntryAdded → updates state
      → LedgerList rebuilds → LedgerEntryCard shows thumbnail
```

### Attach-later (adding proof to existing pending entry)

```
LedgerEntryCard._showEntryDetail() (bottom sheet)
  → [user sees "Attach Proof" button — visible only if canEditAttachment]
  → ImagePicker.pickImage()
  → flutter_image_compress (local compress, quality 75, max 1200px)
  → LedgerAttachmentService.uploadAttachment(file, linkId, entry.id)
      → POST multipart → PATCH /api/v1/links/:linkId/entries/:entryId/attachment
      → Cloudinary: saath_khata/ledger_attachments/{linkId}/entry_{entryId}
      → DB update: attachment_url = url, updated_at = now
      → Socket: emitLedgerEvent('ledger:entry_updated', linkId, {entry})
  → Flutter receives socket event → SocketLedgerEntryUpdated
  → LedgerBloc._onSocketEntryUpdated → replaces entry in state list
  → LedgerEntryCard rebuilds with thumbnail
```

### Staff flow (record_entry_sheet.dart — IMPORTANT: does NOT use LedgerBloc)

```
_RecordEntrySheetState
  → String? _pendingAttachmentUrl  ← local state, NOT bloc
  → [user taps camera icon]
  → LedgerAttachmentService.uploadAttachment(file, linkId, 'temp_${userId}_${ts}')
  → _pendingAttachmentUrl = url; setState((){}); (shows thumbnail)
  → [user taps submit]
  → getIt<LedgerRepository>().addEntry(LedgerEntry(...))
      ↑ This is a DIRECT repo call, not bloc — must pass attachmentUrl here
  → The LedgerRepository.addEntry() impl sends attachmentUrl in POST body
```

**Critical:** `record_entry_sheet.dart` calls `LedgerRepository.addEntry()` directly — it never touches `LedgerBloc`. So `attachmentUrl` must flow through the `LedgerEntry` model itself, not through a new bloc event. `LedgerEntry.addEntry()` in the repo impl already serializes the model to JSON for the API call.

---

## LedgerEntry Model Change Required

Current `LedgerEntry` model has `attachmentUrl` as a read-only field (populated from API). For the upload-first flow we need to be able to construct a `LedgerEntry` with `attachmentUrl` set before the API call. This is fine — the model already has the field, the `addEntry` repo impl just needs to include it in the POST body.

Check `ledger_repository_impl.dart` — the `toJson()` on `LedgerEntry` model must include `attachmentUrl`. Verify this in Sprint 3.

---

## Modularization Required for Graphify Context

The current code has some tight coupling that must be loosened as part of this work, to keep graphify context trees clean and prevent context bleed between sessions:

1. **`LedgerAttachmentService`** must be a standalone injectable service in `lib/core/services/` — not inlined into widgets. This makes the graph edge `widget → service → api` explicit rather than `widget → dio → api`.

2. **`canEditAttachment()` logic** must live in a single place on both backend and Flutter — not duplicated across the entry card, detail sheet, and staff sheet. On Flutter: a `bool canEdit(LedgerEntry entry, String currentUserId, bool isVendor)` function in `lib/features/shared_ledger/domain/utils/ledger_permissions.dart`. On backend: a `canEditAttachment(entry, user, link)` helper in `ledger.service.ts`.

3. **`_showEntryDetail()` photo section** must be extracted to a dedicated widget `LedgerAttachmentSection` in `shared_ledger_screen/widgets/attachment_section.dart` — not inlined into the existing bottom sheet builder. This keeps the graph node distinct.

4. **Staff sheet upload state** is intentionally local (not bloc) — document this explicitly in the file with a comment so future devs don't try to "fix" it by adding bloc events.

---

## Migration Decision

| Column | Required? | Notes |
|---|---|---|
| `attachment_url` | ✅ Already exists | No migration |
| `attachment_uploaded_by UUID` | 🟡 Recommended | Audit trail for who uploaded. Requires migration. |
| `attachment_uploaded_at TIMESTAMP` | 🟡 Recommended | Audit trail for when uploaded. Requires migration. |

**Decision needed before Sprint 1 starts:** If adding the audit columns, write migration `20260026_ledger_attachment_audit.ts`. If deferring, mark as tech debt in `PROGRESS.md`.

---

## Tech Debt Items (out of scope now, named so they don't get lost)

- [ ] Cron job: delete Cloudinary `temp/` uploads older than 30 days
- [ ] Audit columns: `attachment_uploaded_by`, `attachment_uploaded_at` (if not done in Sprint 1)
- [ ] Re-enable UPI payments tab when UPI gateway is ready
- [ ] Signed Cloudinary URLs if privacy requirements change

---

## Sprint Overview

| Sprint | Focus | Dependency |
|---|---|---|
| [Sprint 1](./SPRINT_1_BACKEND.md) | Backend: validator, Cloudinary method, new route, service logic | None |
| [Sprint 2](./SPRINT_2_FLUTTER_VIEWER.md) | Flutter: thumbnail, detail sheet photo, full-screen viewer, lock UI, hide payments tab | Sprint 1 must be deployed |
| [Sprint 3](./SPRINT_3_FLUTTER_UPLOAD.md) | Flutter: image picker, local compress, upload service, upload-first + attach-later flows, staff sheet | Sprint 2 complete |
