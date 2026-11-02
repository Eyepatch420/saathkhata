# Sprint 1 — Backend Implementation

> **Status:** NOT STARTED
> **Depends on:** Nothing (first sprint)
> **Blocks:** Sprint 2 (Flutter viewer needs real attachment_url from API)
> **See:** [Master Plan](./PAYMENT_PHOTO_PLAN.md) · [Progress](./PROGRESS.md)

---

## Objective

Wire the backend end-to-end so that:
1. `attachmentUrl` can be passed at entry creation time (upload-first flow)
2. A dedicated `PATCH attachment` endpoint lets anyone with write rights attach/replace a photo on a pending entry
3. Cloudinary handles compression and storage
4. The socket broadcasts the update to all viewers in real time

---

## Files to Touch

| File | Change Type | Notes |
|---|---|---|
| `src/infrastructure/cloudinary/client.ts` | Add method | `uploadLedgerAttachment()` |
| `src/app/modules/ledger/types/ledger.types.ts` | Extend types | `AddEntryInput.attachmentUrl?`, `DbLedgerEntry` audit fields (if migration added) |
| `src/app/modules/ledger/validators/ledger.validators.ts` | Extend schema | Add `attachmentUrl` to `addEntrySchema` |
| `src/app/modules/ledger/repositories/ledger.repository.ts` | Add method | `updateAttachment()` |
| `src/app/modules/ledger/services/ledger.service.ts` | Add method + extend `addEntry` | `attachToEntry()`, pass `attachmentUrl` through `create()` |
| `src/app/modules/ledger/controllers/ledger.controller.ts` | Add handler | `attachToEntry` handler |
| `src/app/modules/ledger/routes/ledger.routes.ts` | Add route | `PATCH /:entryId/attachment` with multer middleware |
| `migrations/20260026_ledger_attachment_audit.ts` | New file (if audit cols) | `attachment_uploaded_by`, `attachment_uploaded_at` |

---

## Task 1 — `CloudinaryService.uploadLedgerAttachment()`

**File:** `src/infrastructure/cloudinary/client.ts`

Add after `uploadStaffQr()`:

```typescript
async uploadLedgerAttachment(
  buffer: Buffer,
  linkId: string,
  publicId: string,   // 'entry_{entryId}' or 'temp_{userId}_{timestamp}'
): Promise<string> {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      {
        folder: `saath_khata/ledger_attachments/${linkId}`,
        public_id: publicId,
        overwrite: true,
        resource_type: 'image',
        transformation: [
          { width: 1200, height: 1200, crop: 'limit' },
          { quality: 'auto', fetch_format: 'auto' },
        ],
      },
      (error, result) => {
        if (error || !result) {
          logger.error('Cloudinary ledger attachment upload failed', { linkId, publicId, error });
          reject(error ?? new Error('Upload failed'));
        } else {
          resolve(result.secure_url);
        }
      },
    );
    stream.end(buffer);
  });
}
```

**Graph node this produces:** `cloudinary_client_cloudinaryservice_uploadledgerattachment`

**Verify:** existing `uploadStaffQr` pattern is identical except folder and public_id scheme. This is a direct copy-adjust.

---

## Task 2 — Extend Validator (`addEntrySchema`)

**File:** `src/app/modules/ledger/validators/ledger.validators.ts`

**Current `addEntrySchema`** (lines 6–21) has: `amount`, `type`, `date`, `description`, `quantity`, `unit`.

**Add:**
```typescript
attachmentUrl: z.string().url('Must be a valid URL').max(500).optional(),
```

**Why this matters:** Zod strips unknown keys by default. If Flutter sends `attachmentUrl` but the schema doesn't include it, it silently disappears before reaching the service layer. This is the most dangerous silent failure in the plan.

**Also export the updated DTO type:**
```typescript
export type AddEntryDto = z.infer<typeof addEntrySchema>;
// Now includes attachmentUrl?: string
```

---

## Task 3 — Extend Types (`AddEntryInput`, `DbLedgerEntry`)

**File:** `src/app/modules/ledger/types/ledger.types.ts`

**`AddEntryInput`** — add:
```typescript
attachmentUrl?: string;
```

**`DbLedgerEntry`** — if audit migration is being done, add:
```typescript
attachment_uploaded_by: string | null;
attachment_uploaded_at: Date | null;
```

**`LedgerEntryResponse`** — if audit columns added, expose them:
```typescript
attachmentUploadedBy: string | null;
attachmentUploadedAt: string | null;
```

And update `formatEntry()` in `ledger.service.ts` to include them.

---

## Task 4 — `LedgerRepository.updateAttachment()`

**File:** `src/app/modules/ledger/repositories/ledger.repository.ts`

Add after `updateStatus()`:

```typescript
async updateAttachment(
  id: string,
  attachmentUrl: string,
  uploadedBy?: string,
): Promise<DbLedgerEntry> {
  const update: Partial<DbLedgerEntry> = {
    attachment_url: attachmentUrl,
    updated_at: new Date(),
  };
  // Only set audit fields if columns exist (after migration)
  if (uploadedBy) {
    (update as any).attachment_uploaded_by = uploadedBy;
    (update as any).attachment_uploaded_at = new Date();
  }
  const [entry] = await this.db<DbLedgerEntry>('ledger_entries')
    .where({ id })
    .update(update)
    .returning('*');
  return entry;
}
```

**Graph node:** `repositories_ledger_repository_ledgerrepository_updateattachment`

---

## Task 5 — `LedgerService.attachToEntry()` + extend `addEntry()`

**File:** `src/app/modules/ledger/services/ledger.service.ts`

### 5a — Extend `addEntry()` to pass `attachmentUrl`

In the existing `addEntry()` method, the `ledgerRepo.create()` call currently passes `attachment_url: null`. Change to:

```typescript
attachment_url: input.attachmentUrl ?? null,
```

That's the only change needed in `addEntry()`. The URL is already validated by Zod before reaching here.

### 5b — Add `attachToEntry()` method

Add the `canEditAttachment` helper function (module-level, not a class method):

```typescript
function canEditAttachment(
  entry: DbLedgerEntry,
  userId: string,
  userRole: string,
  vendorId?: string,
): boolean {
  if (entry.is_locked) return false;
  if (entry.created_by === userId) return true;
  if (userRole === 'vendor' && vendorId === entry.vendor_id) return true;
  return false;
}
```

Add to `LedgerService` class:

```typescript
async attachToEntry(
  linkId: string,
  entryId: string,
  userId: string,
  attachmentUrl: string,
  staff?: StaffContext,
): Promise<LedgerEntryResponse> {
  const { link } = await this._resolveLinkAccess(linkId, userId, staff);

  const entry = await this.ledgerRepo.findById(entryId);
  if (!entry) throw new NotFoundError('Entry not found');
  if (entry.link_id !== linkId) throw new ForbiddenError('Entry does not belong to this link');

  const actorId = staff ? staff.actingUserId : userId;
  const actorRole = staff ? 'vendor' : (link.vendor_id === userId ? 'vendor' : 'customer');
  const actorVendorId = staff ? staff.vendorId : (link.vendor_id === userId ? userId : undefined);

  if (!canEditAttachment(entry, actorId, actorRole, actorVendorId)) {
    if (entry.is_locked) {
      throw new ForbiddenError('Entry is locked — attachment cannot be changed after confirm or dispute');
    }
    throw new ForbiddenError('You do not have permission to edit this attachment');
  }

  const updated = await this.ledgerRepo.updateAttachment(entryId, attachmentUrl, actorId);

  // Broadcast so all open ledger views update in real time
  emitLedgerEvent('ledger:entry_updated', linkId, { linkId, entry: formatEntry(updated) });

  return formatEntry(updated);
}
```

**Graph node:** `services_ledger_service_ledgerservice_attachtoentry`

---

## Task 6 — `LedgerController.attachToEntry()`

**File:** `src/app/modules/ledger/controllers/ledger.controller.ts`

The controller receives the already-uploaded Cloudinary URL from the service layer. The multer middleware (on the route) handles the actual upload.

Add to `LedgerController` class:

```typescript
attachToEntry = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    if (!req.user) throw new UnauthorizedError();
    if (!req.file) throw new ValidationError('Image file is required');

    if (!isCloudinaryConfigured()) {
      throw new BadRequestError('Photo upload is not configured on this server');
    }

    const cloudinarySvc = new CloudinaryService();
    const entryId = req.params.entryId;
    const linkId = req.params.linkId;
    const publicId = `entry_${entryId}`;

    const attachmentUrl = await cloudinarySvc.uploadLedgerAttachment(
      req.file.buffer,
      linkId,
      publicId,
    );

    const result = await this.ledgerService.attachToEntry(
      linkId,
      entryId,
      req.user.sub,
      attachmentUrl,
      staffContext(req),
    );

    sendSuccess(res, result, 'Attachment uploaded');
  } catch (error) {
    next(error);
  }
};
```

**Import additions needed:**
```typescript
import { CloudinaryService, isCloudinaryConfigured } from '../../../../infrastructure/cloudinary/client';
import { BadRequestError } from '../../shared/errors/AppError';
```

---

## Task 7 — New Route

**File:** `src/app/modules/ledger/routes/ledger.routes.ts`

Add multer setup (copy pattern from `staff.routes.ts`):

```typescript
import multer from 'multer';

const attachmentUpload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },  // 5MB
  fileFilter: (_req, file, cb) => {
    const allowed = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
    if (allowed.includes(file.mimetype)) cb(null, true);
    else cb(new Error('Only jpg, png, webp images are allowed'));
  },
});
```

Add route after `/:entryId/dispute`:

```typescript
/**
 * PATCH /api/v1/links/:linkId/entries/:entryId/attachment
 * Upload or replace a payment proof photo on a pending entry.
 * Guarded: entry must not be locked, caller must be creator or vendor-owner.
 */
router.patch(
  '/:entryId/attachment',
  attachmentUpload.single('file'),
  ledgerController.attachToEntry,
);
```

---

## Task 8 — Migration (Optional but Recommended)

**File:** `migrations/20260026_ledger_attachment_audit.ts`

```typescript
import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.table('ledger_entries', (table) => {
    table.uuid('attachment_uploaded_by').nullable().references('id').inTable('users');
    table.timestamp('attachment_uploaded_at').nullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.table('ledger_entries', (table) => {
    table.dropColumn('attachment_uploaded_by');
    table.dropColumn('attachment_uploaded_at');
  });
}
```

**Decision gate:** If this migration is skipped, remove the audit field logic from `updateAttachment()` in Task 4 and from `formatEntry()`. Mark in `PROGRESS.md`.

---

## Code Flow Simulation (read before implementing)

```
Flutter POST /entries with attachmentUrl
  → ledger.routes.ts router.post('/')
  → ledgerController.addEntry
    → addEntrySchema.safeParse(req.body)           ← attachmentUrl validated here (Task 2)
    → ledgerService.addEntry(linkId, userId, input)
      → _resolveLinkAccess() → confirms link exists and user is participant
      → isCustomer check: customer can only add 'payment' type
      → ledgerRepo.create({ ..., attachment_url: input.attachmentUrl ?? null })  ← Task 5a
      → linkRepo.adjustBalance()
      → emitLedgerEvent('ledger:entry_added')
      → return formatEntry(entry)                  ← attachmentUrl included in response
  ← Flutter receives entry with attachmentUrl set
  ← Socket 'ledger:entry_added' fires → LedgerBloc adds to list → card renders thumbnail

Flutter PATCH /entries/:id/attachment (multipart)
  → attachmentUpload.single('file') multer middleware (Task 7)
  → ledgerController.attachToEntry
    → req.file validated
    → cloudinarySvc.uploadLedgerAttachment(buffer, linkId, 'entry_entryId')  ← Task 1
    → ledgerService.attachToEntry(linkId, entryId, userId, url)
      → _resolveLinkAccess()
      → ledgerRepo.findById(entryId)
      → canEditAttachment() check:
          if is_locked → ForbiddenError (audit trail intact)
          if not creator AND not vendor-owner → ForbiddenError
      → ledgerRepo.updateAttachment(entryId, url, actorId)
      → emitLedgerEvent('ledger:entry_updated')    ← real-time to all viewers
      → return formatEntry(updated)
  ← Flutter receives updated entry via socket → SocketLedgerEntryUpdated → card rerenders
```

---

## Edge Cases Handled in This Sprint

| Scenario | Handling |
|---|---|
| `attachmentUrl` sent but Zod schema missing it | Fixed by Task 2 — silent strip prevented |
| Locked entry PATCH request | `canEditAttachment()` returns false → `ForbiddenError` |
| Staff editing another staff's attachment | `entry.created_by !== staff.actingUserId` AND staff is not vendor owner → `ForbiddenError` |
| Customer tries to attach to a credit entry (not theirs) | `created_by !== customerId` → `ForbiddenError` |
| Non-image file upload | multer `fileFilter` rejects → 400 error before controller |
| File over 5MB | multer `limits.fileSize` rejects → 400 error before controller |
| Cloudinary not configured | `isCloudinaryConfigured()` check → `BadRequestError` with clear message |
| Same Cloudinary `public_id` reused (replace photo) | `overwrite: true` in upload config → safe replacement while pending |

---

## Verification Checklist

Before marking Sprint 1 done, confirm:

- [ ] `POST /entries` with `attachmentUrl` body field → entry saved with URL, returned in response
- [ ] `POST /entries` without `attachmentUrl` → entry saved with `attachment_url: null` (unchanged behavior)
- [ ] `PATCH /entries/:id/attachment` by creator → Cloudinary upload, DB update, socket broadcast
- [ ] `PATCH /entries/:id/attachment` by vendor on staff's pending entry → succeeds (vendor override)
- [ ] `PATCH /entries/:id/attachment` by staff on another staff's entry → `403 Forbidden`
- [ ] `PATCH /entries/:id/attachment` on confirmed entry → `403 Forbidden`
- [ ] `PATCH /entries/:id/attachment` with non-image file → `400 Bad Request`
- [ ] `PATCH /entries/:id/attachment` with file > 5MB → `400 Bad Request`
- [ ] Socket `ledger:entry_updated` fires after successful attachment
- [ ] `formatEntry()` still includes `attachmentUrl` in the response

---

## Notes for Next Sprint

After Sprint 1 is deployed, Flutter Sprint 2 can start. The only thing Sprint 2 needs from Sprint 1 is that real `attachment_url` values come back from the API. Sprint 2 is purely viewer — no uploads, no new backend work needed.
