# Payment Photo System — Progress Tracker

> **Last updated:** 2026-06-23
> **See:** [Master Plan](./PAYMENT_PHOTO_PLAN.md)

---

## Sprint Status

| Sprint | Status | Tasks Done | Tasks Total |
|---|---|---|---|
| Sprint 1 — Backend | ✅ DONE | 8 | 8 |
| Sprint 2 — Flutter Viewer | ✅ DONE | 6 | 6 |
| Sprint 3 — Flutter Upload | ✅ DONE | 9 | 9 |

---

## Sprint 1 — Backend

| # | Task | Status | Notes |
|---|---|---|---|
| 1 | `CloudinaryService.uploadLedgerAttachment()` | ✅ | `src/infrastructure/cloudinary/client.ts` |
| 2 | Extend `addEntrySchema` with `attachmentUrl` | ✅ | `ledger.validators.ts` |
| 3 | Add `attachmentUrl?` to `AddEntryInput` | ✅ | `ledger.types.ts` |
| 4 | `LedgerRepository.updateAttachment()` | ✅ | `ledger.repository.ts` |
| 5a | `LedgerService.addEntry()` → pass `attachmentUrl` | ✅ | `ledger.service.ts` |
| 5b | `LedgerService.attachToEntry()` + `canEditAttachment()` | ✅ | `ledger.service.ts` |
| 6 | `LedgerController.attachToEntry()` | ✅ | `ledger.controller.ts` |
| 7 | `PATCH /:entryId/attachment` route + multer | ✅ | `ledger.routes.ts` |
| 8 | Audit migration (optional) | ⬜ DEFERRED | `attachment_uploaded_by` + `attachment_uploaded_at` — skipped for now, tech debt |

**Decision gate:** Run migration 20260026 for audit columns? → **UNDECIDED**
- If YES: add columns in `updateAttachment()`, expose in `formatEntry()`
- If NO: mark as tech debt in PAYMENT_PHOTO_PLAN.md and skip

**Verification:** Run Sprint 1 checklist in [SPRINT_1_BACKEND.md](./SPRINT_1_BACKEND.md)

---

## Sprint 2 — Flutter Viewer

| # | Task | Status | Notes |
|---|---|---|---|
| A | Hide customer Payments tab in `app_router.dart` | ✅ | 4 tabs now; Profile at index 3 |
| B | Add `cached_network_image` + `flutter_image_compress` to `pubspec.yaml` | ✅ | Both added |
| C | New widget: `attachment_section.dart` | ✅ | `LedgerAttachmentSection` — reused in card + detail sheet |
| D | New widget: `full_screen_photo_viewer.dart` | ✅ | `InteractiveViewer` + `Hero` |
| E | Thumbnail in `entry_card.dart` | ✅ | After main Row, before action buttons |
| F | Photo in `_showEntryDetail()` bottom sheet | ✅ | Different `heroTag` prefix (`detail_attachment_`) from card |

**Depends on:** Sprint 1 deployed and returning real `attachmentUrl` from API

**Verification:** Run Sprint 2 checklist in [SPRINT_2_FLUTTER_VIEWER.md](./SPRINT_2_FLUTTER_VIEWER.md)

---

## Sprint 3 — Flutter Upload

| # | Task | Status | Notes |
|---|---|---|---|
| A | `pubspec.yaml` — `flutter_image_compress` (done in Sprint 2), `image_picker` already existed | ✅ | |
| B | New: `ledger_permissions.dart` helper | ✅ | `lib/features/shared_ledger/domain/utils/ledger_permissions.dart` |
| C | New: `ledger_attachment_service.dart` | ✅ | `lib/core/services/ledger_attachment_service.dart` |
| D | Register `LedgerAttachmentService` in DI | ✅ | `injection.dart` |
| E | Extend `AddLedgerEntry` event with `attachmentUrl` | ✅ | `ledger_event.dart` |
| F | `LedgerRepository.attachToEntry()` — abstract + impl + mock + endpoint | ✅ | 4 files |
| G | `attachmentUrl` wired through `addEntry` repo + bloc | ✅ | `ledger_repository_impl.dart` + `ledger_bloc.dart` |
| H | Camera button in `LedgerActions` (extracted to `_AddEntrySheet` StatefulWidget) | ✅ | Upload-first flow |
| I | Attach-later + Replace button in `_EntryDetailSheet` StatefulWidget | ✅ | `canEditAttachment` guard |
| J | Camera button in `record_entry_sheet.dart` | ✅ | Staff flow — local state, NOT bloc |

**Depends on:** Sprint 2 complete

**Verification:** Run Sprint 3 checklist in [SPRINT_3_FLUTTER_UPLOAD.md](./SPRINT_3_FLUTTER_UPLOAD.md)

---

## Decision Log

| Date | Decision | Rationale |
|---|---|---|
| 2026-06-23 | Keep `features/payments/` folder — hide only from nav | Route may be re-enabled for UPI gateway later |
| 2026-06-23 | Staff upload uses local state, NOT LedgerBloc | `record_entry_sheet.dart` calls repo directly — adding bloc events would break the established pattern |
| 2026-06-23 | `canEditAttachment()` lives in a single util file on both backend and Flutter | Prevents drift if permission rules change |
| 2026-06-23 | No signed Cloudinary URLs | Both parties are in a confirmed business link — public URL is acceptable |
| 2026-06-23 | Orphan temp uploads accepted | Negligible storage cost; cron cleanup deferred to tech debt |
| 2026-06-23 | Audit migration (20260026) — UNDECIDED | Mark decision before starting Sprint 1 |

---

## Known Issues / Blockers

None yet. Mark blockers here as they arise.

Format: `[DATE] BLOCKER: description — waiting on X`

---

## Tech Debt (out of scope, named here so they don't get lost)

- [ ] Cron: delete Cloudinary `temp/` uploads older than 30 days
- [ ] Audit columns: `attachment_uploaded_by`, `attachment_uploaded_at` (if not done in Sprint 1)
- [ ] Re-enable UPI Payments tab when UPI gateway ready
- [ ] l10n: translate new strings to all 13 language ARB files (currently only English)
- [ ] Signed Cloudinary URLs if privacy requirements tighten
