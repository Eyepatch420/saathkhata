# Graph Context Reference — Payment Photo System

> This file maps graph node IDs (as graphify generates them) to the actual file paths and class/method names that matter for this feature. Use it as a lookup when querying the graph across sessions.
>
> **See:** [Master Plan](./PAYMENT_PHOTO_PLAN.md) · [Progress](./PROGRESS.md)
>
> Last graphify run: 2026-06-23

---

## Flutter Side

### Core Nodes

| Graph Node ID (approximate) | File | Class / Method |
|---|---|---|
| `ledger_entry_ledgerentry` | `lib/shared/models/ledger_entry.dart` | `LedgerEntry` model — has `attachmentUrl`, `isLocked`, `createdBy` |
| `ledger_bloc_ledgerbloc` | `lib/features/shared_ledger/presentation/bloc/ledger_bloc.dart` | `LedgerBloc` — handles `AddLedgerEntry`, `SocketLedgerEntryAdded`, `SocketLedgerEntryUpdated` |
| `ledger_event_addledgerentry` | `lib/features/shared_ledger/presentation/bloc/ledger_event.dart` | `AddLedgerEntry` — extended with `attachmentUrl` in Sprint 3 |
| `ledger_repository_ledgerrepository` | `lib/features/shared_ledger/domain/repositories/ledger_repository.dart` | Abstract — `addEntry()`, `attachToEntry()` (Sprint 3) |
| `ledger_repository_impl_ledgerrepositoryimpl` | `lib/features/shared_ledger/data/repositories/ledger_repository_impl.dart` | Real impl — hits backend API |
| `mock_ledger_repository_mockledgerrepository` | `lib/features/shared_ledger/data/repositories/mock_ledger_repository.dart` | Mock impl — dev/test |
| `entry_card_ledgerentrycard` | `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/entry_card.dart` | Entry card widget — thumbnail (Sprint 2) + attach-later button (Sprint 3) |
| `ledger_actions_ledgeractions` | `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart` | `_showAddEntrySheet()` — camera button added Sprint 3 |
| `attachment_section_ledgerattachmentsection` | `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart` | **New Sprint 2** — reusable thumbnail + hero widget |
| `full_screen_photo_viewer_fullscreenphotoviewer` | `lib/features/shared_ledger/presentation/screens/shared_ledger_screen/widgets/full_screen_photo_viewer.dart` | **New Sprint 2** — `InteractiveViewer` full screen |
| `ledger_attachment_service_ledgerattachmentservice` | `lib/core/services/ledger_attachment_service.dart` | **New Sprint 3** — compress + upload injectable service |
| `ledger_permissions_caneditattachment` | `lib/features/shared_ledger/domain/utils/ledger_permissions.dart` | **New Sprint 3** — `canEditAttachment()` helper |
| `record_entry_sheet_recordentrysheetstate` | `lib/features/staff_portal/presentation/widgets/record_entry_sheet.dart` | Staff entry sheet — `_pendingAttachmentUrl` local state (Sprint 3) |
| `injection_getit` | `lib/core/di/injection.dart` | DI container — `LedgerAttachmentService` registered Sprint 3 |
| `app_router_customermainwrapper` | `lib/core/router/app_router.dart` | Customer nav — Payments tab removed Sprint 2 |

### Key Edges (Flutter)

```
ledger_actions → ledger_attachment_service      [upload-first flow, Sprint 3]
ledger_attachment_service → ledger_repository   [attach-later: calls attachToEntry()]
ledger_permissions ← entry_card                 [canEditAttachment guard in detail sheet]
ledger_permissions ← ledger_actions             [canEditAttachment guard Sprint 3]
record_entry_sheet → ledger_attachment_service  [staff local upload, NOT via bloc]
record_entry_sheet → ledger_repository          [direct addEntry() call — bypasses bloc]
attachment_section ← entry_card                 [reused in card AND detail sheet]
attachment_section → full_screen_photo_viewer   [tap to open]
ledger_bloc ← ledger_socket_service             [SocketLedgerEntryUpdated after attach]
```

---

## Backend Side

### Core Nodes

| Graph Node ID (approximate) | File | Class / Method |
|---|---|---|
| `cloudinary_client_cloudinaryservice` | `src/infrastructure/cloudinary/client.ts` | `CloudinaryService` — `uploadLedgerAttachment()` (Sprint 1) |
| `ledger_validators_addentryschema` | `src/app/modules/ledger/validators/ledger.validators.ts` | Zod schema — `attachmentUrl` field added Sprint 1 |
| `ledger_types_addentryinput` | `src/app/modules/ledger/types/ledger.types.ts` | `AddEntryInput` — `attachmentUrl?` field |
| `ledger_repository_ledgerrepository_updateattachment` | `src/app/modules/ledger/repositories/ledger.repository.ts` | `updateAttachment()` — new Sprint 1 |
| `ledger_service_ledgerservice_addentry` | `src/app/modules/ledger/services/ledger.service.ts` | `addEntry()` — now passes `attachmentUrl` through |
| `ledger_service_ledgerservice_attachtoentry` | `src/app/modules/ledger/services/ledger.service.ts` | `attachToEntry()` — new Sprint 1, includes permission check |
| `ledger_service_caneditattachment` | `src/app/modules/ledger/services/ledger.service.ts` | `canEditAttachment()` — module-level helper |
| `ledger_controller_ledgercontroller_attachtoentry` | `src/app/modules/ledger/controllers/ledger.controller.ts` | `attachToEntry` handler — new Sprint 1 |
| `ledger_routes_attachmentupload` | `src/app/modules/ledger/routes/ledger.routes.ts` | `PATCH /:entryId/attachment` + multer middleware |
| `staff_routes_qrupload` | `src/app/modules/staff/routes/staff.routes.ts` | Template for multer pattern — copy for ledger routes |

### Key Edges (Backend)

```
ledger_routes_attachmentupload → ledger_controller_attachtoentry
ledger_controller_attachtoentry → cloudinary_client_uploadledgerattachment
ledger_controller_attachtoentry → ledger_service_attachtoentry
ledger_service_attachtoentry → ledger_service_caneditattachment
ledger_service_attachtoentry → ledger_repository_updateattachment
ledger_service_attachtoentry → ledger_socket_emitledgerevent     [real-time broadcast]
ledger_service_addentry → ledger_validators_addentryschema       [Zod validation gate]
ledger_validators_addentryschema → ledger_types_addentryinput    [type flows from schema]
```

---

## Cross-Stack Data Flow Nodes

These are conceptual nodes that appear in both Flutter and backend graph queries:

| Concept | Backend representation | Flutter representation |
|---|---|---|
| `attachment_url` (DB field) | `DbLedgerEntry.attachment_url` | `LedgerEntry.attachmentUrl` |
| Permission check | `canEditAttachment()` in `ledger.service.ts` | `canEditAttachment()` in `ledger_permissions.dart` |
| Real-time update | `emitLedgerEvent('ledger:entry_updated')` in `ledger.service.ts` | `SocketLedgerEntryUpdated` in `LedgerBloc` |
| Lock enforcement | `entry.is_locked` check in `attachToEntry()` | `entry.isLocked` check in `canEditAttachment()` + no UI button |
| Staff identity | `staff.actingUserId` as `created_by` | `record_entry_sheet.dart` direct `addEntry()` call |

---

## Graph Queries to Use for this Feature

When re-running graphify or querying the graph in future sessions, use these to get relevant context:

```bash
# All nodes touched by the payment photo feature
graphify query "ledger attachment upload photo cloudinary" --budget 2000

# Permission model trace
graphify path "ledger_service_caneditattachment" "ledger_repository_updateattachment"

# Flutter upload chain
graphify path "ledger_attachment_service_ledgerattachmentservice" "ledger_repository_ledgerrepository"

# Staff sheet bypass
graphify explain "record_entry_sheet_recordentrysheetstate"

# Socket broadcast chain
graphify path "ledger_service_attachtoentry" "ledger_bloc_ledgerbloc"
```

---

## Community Detection Notes

In the graphify run on 2026-06-23, the payment/ledger nodes cluster into two communities:

1. **Ledger Data Community** — `LedgerEntry`, `LedgerRepository`, `LedgerBloc`, `LedgerState` — data and state management
2. **Ledger UI Community** — `entry_card`, `ledger_actions`, `attachment_section`, `full_screen_photo_viewer`, `record_entry_sheet` — presentation layer

The `LedgerAttachmentService` (Sprint 3) should bridge community 1 and 2 — it is the only node that is imported by both UI widgets and the repository layer. Verify this after graphify re-run post-Sprint-3.
