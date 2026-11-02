import 'package:equatable/equatable.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../domain/models/ledger_filter.dart';

abstract class LedgerEvent extends Equatable {
  const LedgerEvent();

  @override
  List<Object?> get props => [];
}

class LoadLedger extends LedgerEvent {
  final String linkId;
  const LoadLedger(this.linkId);

  @override
  List<Object?> get props => [linkId];
}

class AddLedgerEntry extends LedgerEvent {
  final double amount;
  final EntryType type;
  final String? description;
  final double? quantity;
  final String? unit;
  final String linkId;
  final String? attachmentUrl;
  final DateTime? date;

  const AddLedgerEntry({
    required this.amount,
    required this.type,
    required this.linkId,
    this.description,
    this.quantity,
    this.unit,
    this.attachmentUrl,
    this.date,
  });

  @override
  List<Object?> get props => [amount, type, description, quantity, unit, linkId, attachmentUrl, date];
}

class ItemRow {
  final String description;
  final double amount;
  final double? quantity;
  final String? unit;

  const ItemRow({
    required this.description,
    required this.amount,
    this.quantity,
    this.unit,
  });
}

/// Vendor-side multi-item credit entry.
/// Creates one parent entry (total) + N child entries sequentially.
class AddMultiItemLedgerEntry extends LedgerEvent {
  final String linkId;
  final List<ItemRow> items;
  final DateTime? date;

  const AddMultiItemLedgerEntry({
    required this.linkId,
    required this.items,
    this.date,
  });

  @override
  List<Object?> get props => [linkId, items, date];
}

class ConfirmLedgerEntry extends LedgerEvent {
  final String entryId;
  const ConfirmLedgerEntry(this.entryId);
  @override
  List<Object?> get props => [entryId];
}

class DisputeLedgerEntry extends LedgerEvent {
  final String entryId;
  final String reason;
  const DisputeLedgerEntry({required this.entryId, required this.reason});
  @override
  List<Object?> get props => [entryId, reason];
}

class FilterLedger extends LedgerEvent {
  final EntryStatus? filterStatus;
  const FilterLedger(this.filterStatus);
  @override
  List<Object?> get props => [filterStatus];
}

/// Silent pull-to-refresh — fetches from the API without emitting LedgerLoading,
/// so existing entries stay visible while the indicator spins at the top.
class RefreshLedger extends LedgerEvent {
  final String linkId;
  const RefreshLedger(this.linkId);

  @override
  List<Object?> get props => [linkId];
}

class SocketLedgerEntryAdded extends LedgerEvent {
  final LedgerEntry entry;
  const SocketLedgerEntryAdded(this.entry);
  @override
  List<Object?> get props => [entry];
}

class SocketLedgerEntryUpdated extends LedgerEvent {
  final LedgerEntry entry;
  const SocketLedgerEntryUpdated(this.entry);
  @override
  List<Object?> get props => [entry];
}

class LoadMoreLedger extends LedgerEvent {
  final String linkId;
  const LoadMoreLedger(this.linkId);
  @override
  List<Object?> get props => [linkId];
}

class ApplyLedgerFilter extends LedgerEvent {
  final LedgerFilter filter;
  const ApplyLedgerFilter(this.filter);
  @override
  List<Object?> get props => [filter];
}

class ClearLedgerFilter extends LedgerEvent {
  const ClearLedgerFilter();
}
