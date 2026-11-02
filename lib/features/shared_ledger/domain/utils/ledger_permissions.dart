import '../../../../shared/models/ledger_entry.dart';

/// Returns true if the current user may add or replace the attachment on [entry].
///
/// Mirrors the backend canEditAttachment() in ledger.service.ts:
///   - Entry must not be locked (confirmed / disputed)
///   - Caller must be the creator, OR be the vendor owner of the link
bool canEditAttachment({
  required LedgerEntry entry,
  required String currentUserId,
  required bool isVendorView,
}) {
  if (entry.isLocked) return false;
  if (entry.createdBy == currentUserId) return true;
  if (isVendorView && entry.vendorId != null && entry.vendorId == currentUserId) return true;
  return false;
}
