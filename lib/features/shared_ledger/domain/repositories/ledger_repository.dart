import 'dart:io';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/models/ledger_balance.dart';
import '../models/ledger_filter.dart';

abstract class LedgerRepository {
  Future<LedgerPageResult> getEntries(
    String linkId, {
    int page = 1,
    int limit = 50,
    LedgerFilter? filter,
  });
  Future<LedgerEntry> addEntry(LedgerEntry entry);
  Future<LedgerEntry> confirmEntry(String entryId);
  Future<LedgerEntry> disputeEntry(String entryId, String reason);

  /// Fetch O(1) balance + stats from the denormalized link column.
  Future<LedgerBalance> getBalance(String linkId);

  /// Upload or replace a payment proof photo on a pending (unlocked) entry.
  /// Calls PATCH /links/:linkId/entries/:entryId/attachment.
  /// The socket will broadcast ledger:entry_updated after success.
  Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile);
}
