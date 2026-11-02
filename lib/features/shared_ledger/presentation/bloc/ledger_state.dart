import 'package:equatable/equatable.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../domain/models/ledger_filter.dart';

abstract class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object?> get props => [];
}

class LedgerInitial extends LedgerState {}

class LedgerLoading extends LedgerState {}

class LedgerActionLoading extends LedgerState {
  final List<LedgerEntry> entries;
  final double balance;
  final EntryStatus? activeFilter;

  const LedgerActionLoading({
    required this.entries,
    required this.balance,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [entries, balance, activeFilter];
}

class LedgerLoaded extends LedgerState {
  final String linkId;
  final List<LedgerEntry> allEntries;
  final List<LedgerEntry> entries;
  final double balance;
  final LedgerFilter filter;
  final int currentPage;
  final int totalEntries;
  final bool isLoadingMore;

  // Keep for backward compat with widgets still reading activeFilter
  EntryStatus? get activeFilter => filter.status;

  bool get hasMore => allEntries.length < totalEntries;

  const LedgerLoaded({
    required this.linkId,
    required this.allEntries,
    required this.entries,
    required this.balance,
    this.filter = const LedgerFilter(),
    this.currentPage = 1,
    this.totalEntries = 0,
    this.isLoadingMore = false,
  });

  LedgerLoaded copyWith({
    String? linkId,
    List<LedgerEntry>? allEntries,
    List<LedgerEntry>? entries,
    double? balance,
    LedgerFilter? filter,
    int? currentPage,
    int? totalEntries,
    bool? isLoadingMore,
  }) =>
      LedgerLoaded(
        linkId: linkId ?? this.linkId,
        allEntries: allEntries ?? this.allEntries,
        entries: entries ?? this.entries,
        balance: balance ?? this.balance,
        filter: filter ?? this.filter,
        currentPage: currentPage ?? this.currentPage,
        totalEntries: totalEntries ?? this.totalEntries,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [
        linkId,
        allEntries,
        entries,
        balance,
        filter,
        currentPage,
        totalEntries,
        isLoadingMore,
      ];
}

class LedgerError extends LedgerState {
  final String message;
  const LedgerError(this.message);

  @override
  List<Object?> get props => [message];
}
