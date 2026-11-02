import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/ledger_filter.dart';
import '../../domain/repositories/ledger_repository.dart';
import 'ledger_event.dart';
import 'ledger_state.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../core/utils/app_logger.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  final LedgerRepository _repository;

  static const _m = 'Ledger';

  LedgerBloc(this._repository) : super(LedgerInitial()) {
    on<LoadLedger>(_onLoadLedger);
    on<AddLedgerEntry>(_onAddEntry);
    on<AddMultiItemLedgerEntry>(_onAddMultiItemEntry);
    on<ConfirmLedgerEntry>(_onConfirmEntry);
    on<DisputeLedgerEntry>(_onDisputeEntry);
    on<FilterLedger>(_onFilterLedger);
    on<RefreshLedger>(_onRefreshLedger);
    on<SocketLedgerEntryAdded>(_onSocketEntryAdded);
    on<SocketLedgerEntryUpdated>(_onSocketEntryUpdated);
    on<LoadMoreLedger>(_onLoadMore);
    on<ApplyLedgerFilter>(_onApplyFilter);
    on<ClearLedgerFilter>(_onClearFilter);
  }

  double _calcBalance(List<LedgerEntry> entries) {
    double balance = 0;
    for (final entry in entries) {
      if (entry.status != EntryStatus.confirmed &&
          entry.status != EntryStatus.autoConfirmed) {
        continue;
      }
      if (entry.type == EntryType.credit) {
        balance += entry.amount;
      } else {
        balance -= entry.amount;
      }
    }
    return balance;
  }

  List<LedgerEntry> _applyClientFilter(List<LedgerEntry> all, LedgerFilter filter) {
    return all.where((e) {
      if (filter.status != null) {
        if (filter.status == EntryStatus.pending) {
          if (!(e.status == EntryStatus.pending && e.type == EntryType.credit)) return false;
        } else {
          if (e.status != filter.status) return false;
        }
      }
      if (filter.deliveriesOnly && !e.isDelivery) return false;
      if (!filter.deliveriesOnly && filter.type != null && e.type != filter.type) return false;
      return true;
    }).toList();
  }

  LedgerLoaded _loaded(LedgerLoaded current, List<LedgerEntry> all) => current.copyWith(
        allEntries: all,
        entries: _applyClientFilter(all, current.filter),
        balance: _calcBalance(all),
      );

  Future<void> _onLoadLedger(LoadLedger event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Loading ledger for linkId:${event.linkId}');
    emit(LedgerLoading());
    try {
      final result = await _repository.getEntries(event.linkId, page: 1, limit: 50);
      AppLogger.i(_m, 'Loaded ${result.entries.length}/${result.total} entries');
      emit(LedgerLoaded(
        linkId: event.linkId,
        allEntries: result.entries,
        entries: result.entries,
        balance: _calcBalance(result.entries),
        currentPage: 1,
        totalEntries: result.total,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Ledger load failed', e);
      emit(const LedgerError('Failed to load ledger'));
    }
  }

  Future<void> _onAddEntry(AddLedgerEntry event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Adding entry — amount:${event.amount} type:${event.type.name}');
    final current = state;
    if (current is! LedgerLoaded) return;

    emit(LedgerActionLoading(entries: current.entries, balance: current.balance));
    try {
      final newEntry = LedgerEntry(
        id: '',
        linkId: event.linkId,
        amount: event.amount,
        type: event.type,
        date: event.date ?? DateTime.now(),
        description: event.description,
        quantity: event.quantity,
        unit: event.unit,
        status: EntryStatus.pending,
        createdBy: '',
        attachmentUrl: event.attachmentUrl,
      );
      final created = await _repository.addEntry(newEntry);
      AppLogger.i(_m, 'Entry added — id:${created.id}');
      final updatedAll = [created, ...current.allEntries];
      emit(_loaded(current, updatedAll));
    } catch (e) {
      AppLogger.e(_m, 'Add entry failed', e);
      emit(current.copyWith());
    }
  }

  Future<void> _onAddMultiItemEntry(
      AddMultiItemLedgerEntry event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Adding multi-item entry — ${event.items.length} items');
    final current = state;
    if (current is! LedgerLoaded) return;

    emit(LedgerActionLoading(entries: current.entries, balance: current.balance));
    try {
      final total = event.items.fold(0.0, (sum, i) => sum + i.amount);
      final entryDate = event.date ?? DateTime.now();
      final parentEntry = LedgerEntry(
        id: '',
        linkId: event.linkId,
        amount: total,
        type: EntryType.credit,
        date: entryDate,
        description: '${event.items.length} items',
        status: EntryStatus.pending,
        createdBy: '',
        isParent: true,
        childCount: event.items.length,
      );
      final createdParent = await _repository.addEntry(parentEntry);

      final children = <LedgerEntry>[];
      for (final item in event.items) {
        final child = LedgerEntry(
          id: '',
          linkId: event.linkId,
          amount: item.amount,
          type: EntryType.credit,
          date: entryDate,
          description: item.description,
          quantity: item.quantity,
          unit: item.unit,
          status: EntryStatus.pending,
          createdBy: '',
          parentEntryId: createdParent.id,
        );
        final createdChild = await _repository.addEntry(child);
        children.add(createdChild);
      }

      final parentWithChildren = createdParent.copyWith(children: children);
      final updatedAll = [parentWithChildren, ...current.allEntries];
      emit(_loaded(current, updatedAll));
    } catch (e) {
      AppLogger.e(_m, 'Multi-item entry failed', e);
      emit(LedgerError(e.toString().replaceFirst('Exception: ', '')));
      emit(current.copyWith());
    }
  }

  Future<void> _onConfirmEntry(ConfirmLedgerEntry event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Confirming entry id:${event.entryId}');
    final current = state;
    if (current is! LedgerLoaded) return;

    emit(LedgerActionLoading(entries: current.entries, balance: current.balance));
    try {
      final confirmed = await _repository.confirmEntry(event.entryId);
      AppLogger.i(_m, 'Entry confirmed — id:${confirmed.id}');
      final updatedAll = current.allEntries.map((e) => e.id == confirmed.id ? confirmed : e).toList();
      emit(_loaded(current, updatedAll));
    } catch (e) {
      AppLogger.e(_m, 'Confirm entry failed', e);
      emit(current.copyWith());
    }
  }

  Future<void> _onDisputeEntry(DisputeLedgerEntry event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Disputing entry id:${event.entryId}');
    final current = state;
    if (current is! LedgerLoaded) return;

    emit(LedgerActionLoading(entries: current.entries, balance: current.balance));
    try {
      final disputed = await _repository.disputeEntry(event.entryId, event.reason);
      AppLogger.i(_m, 'Entry disputed — id:${disputed.id}');
      final updatedAll = current.allEntries.map((e) => e.id == disputed.id ? disputed : e).toList();
      emit(_loaded(current, updatedAll));
    } catch (e) {
      AppLogger.e(_m, 'Dispute entry failed', e);
      emit(current.copyWith());
    }
  }

  Future<void> _onRefreshLedger(RefreshLedger event, Emitter<LedgerState> emit) async {
    AppLogger.i(_m, 'Pull-to-refresh for linkId:${event.linkId}');
    final current = state;
    try {
      final filter = current is LedgerLoaded ? current.filter : const LedgerFilter();
      final result = await _repository.getEntries(
        event.linkId,
        page: 1,
        limit: 50,
        filter: filter.isEmpty ? null : filter,
      );
      AppLogger.i(_m, 'Refresh done — ${result.entries.length} entries');
      final base = current is LedgerLoaded ? current : LedgerLoaded(
        linkId: event.linkId,
        allEntries: const [],
        entries: const [],
        balance: 0,
      );
      emit(base.copyWith(
        allEntries: result.entries,
        entries: _applyClientFilter(result.entries, filter),
        balance: _calcBalance(result.entries),
        currentPage: 1,
        totalEntries: result.total,
        isLoadingMore: false,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Refresh failed', e);
    }
  }

  // Backward-compat: FilterLedger(status) → ApplyLedgerFilter
  void _onFilterLedger(FilterLedger event, Emitter<LedgerState> emit) {
    final current = state;
    if (current is! LedgerLoaded) return;
    final newFilter = current.filter.copyWith(
      status: event.filterStatus,
      clearStatus: event.filterStatus == null,
    );
    add(ApplyLedgerFilter(newFilter));
  }

  Future<void> _onLoadMore(LoadMoreLedger event, Emitter<LedgerState> emit) async {
    final current = state;
    if (current is! LedgerLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.currentPage + 1;
      final result = await _repository.getEntries(
        event.linkId,
        page: nextPage,
        limit: 50,
        filter: current.filter.isEmpty ? null : current.filter,
      );
      final combined = [...current.allEntries, ...result.entries];
      // Deduplicate by id
      final seen = <String>{};
      final deduped = combined.where((e) => seen.add(e.id)).toList();
      emit(current.copyWith(
        allEntries: deduped,
        entries: _applyClientFilter(deduped, current.filter),
        balance: _calcBalance(deduped),
        currentPage: nextPage,
        totalEntries: result.total,
        isLoadingMore: false,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Load more failed', e);
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onApplyFilter(ApplyLedgerFilter event, Emitter<LedgerState> emit) async {
    final current = state;
    if (current is! LedgerLoaded) return;

    final filter = event.filter;
    final needsRefetch = filter.dateFrom != null ||
        filter.dateTo != null ||
        filter.amountMin != null ||
        filter.amountMax != null ||
        current.hasMore;

    if (!needsRefetch) {
      emit(current.copyWith(
        entries: _applyClientFilter(current.allEntries, filter),
        filter: filter,
      ));
      return;
    }

    emit(LedgerLoading());
    try {
      final result = await _repository.getEntries(
        current.linkId,
        page: 1,
        limit: 50,
        filter: filter.isEmpty ? null : filter,
      );
      emit(LedgerLoaded(
        linkId: current.linkId,
        allEntries: result.entries,
        entries: _applyClientFilter(result.entries, filter),
        balance: _calcBalance(result.entries),
        filter: filter,
        currentPage: 1,
        totalEntries: result.total,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Apply filter failed', e);
      emit(const LedgerError('Failed to apply filter'));
    }
  }

  void _onClearFilter(ClearLedgerFilter event, Emitter<LedgerState> emit) {
    add(const ApplyLedgerFilter(LedgerFilter()));
  }

  void _onSocketEntryAdded(SocketLedgerEntryAdded event, Emitter<LedgerState> emit) {
    final current = state;
    if (current is! LedgerLoaded) return;
    if (current.allEntries.any((e) => e.id == event.entry.id)) return;
    AppLogger.i(_m, 'Socket: entry added id:${event.entry.id}');
    final updatedAll = [event.entry, ...current.allEntries];
    emit(_loaded(current, updatedAll));
  }

  void _onSocketEntryUpdated(SocketLedgerEntryUpdated event, Emitter<LedgerState> emit) {
    final current = state;
    if (current is! LedgerLoaded) return;
    AppLogger.i(_m, 'Socket: entry updated id:${event.entry.id}');
    final updatedAll = current.allEntries
        .map((e) => e.id == event.entry.id ? event.entry : e)
        .toList();
    emit(_loaded(current, updatedAll));
  }
}
