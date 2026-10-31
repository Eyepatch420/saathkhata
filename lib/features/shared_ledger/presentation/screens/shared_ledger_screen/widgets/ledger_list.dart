import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/ledger_entry.dart';
import '../../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../../shared/widgets/error_state_widget.dart';
import '../../../bloc/ledger_bloc.dart';
import '../../../bloc/ledger_event.dart';
import '../../../bloc/ledger_state.dart';
import 'entry_card.dart';

class LedgerList extends StatefulWidget {
  final String linkId;
  final String customerName;
  final String currentUserId;
  final bool isVendorView;
  final bool isStaffView;
  final EntryStatus? filterStatus;
  final EntryType? filterType;
  final bool filterDeliveriesOnly;

  const LedgerList({
    super.key,
    required this.linkId,
    required this.customerName,
    required this.currentUserId,
    required this.isVendorView,
    this.isStaffView = false,
    this.filterStatus,
    this.filterType,
    this.filterDeliveriesOnly = false,
  });

  @override
  State<LedgerList> createState() => _LedgerListState();
}

class _LedgerListState extends State<LedgerList> {
  Future<void> _handleRefresh() async {
    context.read<LedgerBloc>().add(RefreshLedger(widget.linkId));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Build a mixed list: DateTime sentinels (date dividers) + LedgerEntry items.
  List<Object> _buildGroupedItems(List<LedgerEntry> entries) {
    final items = <Object>[];
    DateTime? lastDay;
    for (final entry in entries) {
      final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (lastDay == null || day != lastDay) {
        items.add(day);
        lastDay = day;
      }
      items.add(entry);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LedgerBloc, LedgerState>(
      builder: (context, state) {
        if (state is LedgerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LedgerError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () =>
                context.read<LedgerBloc>().add(LoadLedger(widget.linkId)),
          );
        }

        var entries = state is LedgerLoaded
            ? state.entries
            : state is LedgerActionLoading
                ? state.entries
                : <LedgerEntry>[];

        // Apply legacy prop-based filters (used by DeliveriesScreen)
        if (widget.filterStatus != null) {
          entries = entries.where((e) => e.status == widget.filterStatus).toList();
        }
        if (widget.filterType != null) {
          entries = entries.where((e) => e.type == widget.filterType).toList();
        }
        if (widget.filterDeliveriesOnly) {
          entries = entries.where((e) => e.isDelivery).toList();
        }

        final loadedState = state is LedgerLoaded ? state : null;
        final hasMore = loadedState?.hasMore ?? false;
        final isLoadingMore = loadedState?.isLoadingMore ?? false;

        if (state is LedgerActionLoading) {
          return Stack(
            children: [
              _buildList(entries, hasMore: false, isLoadingMore: false),
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x33FFFFFF),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          );
        }

        if (entries.isEmpty) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: EmptyStateWidget(
                  icon: Icons.receipt_long_rounded,
                  title: l10n.noLedgerTransactions,
                  subtitle: l10n.noLedgerTransactionsSubtitle,
                ),
              ),
            ),
          );
        }

        return _buildList(entries, hasMore: hasMore, isLoadingMore: isLoadingMore);
      },
    );
  }

  Widget _buildList(List<LedgerEntry> entries,
      {required bool hasMore, required bool isLoadingMore}) {
    final items = _buildGroupedItems(entries);
    final extraItem = hasMore ? 1 : 0;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primary,
      displacement: 48,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: items.length + extraItem,
        itemBuilder: (_, i) {
          if (i == items.length) {
            if (isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton.icon(
                onPressed: () => context
                    .read<LedgerBloc>()
                    .add(LoadMoreLedger(widget.linkId)),
                icon: const Icon(Icons.expand_more),
                label: Text(AppLocalizations.of(context)!.loadMoreButton),
              ),
            );
          }

          final item = items[i];
          if (item is DateTime) {
            return _DateDivider(date: item);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LedgerEntryCard(
              entry: item as LedgerEntry,
              customerName: widget.customerName,
              currentUserId: widget.currentUserId,
              isVendorView: widget.isVendorView,
              isStaffView: widget.isStaffView,
            ),
          );
        },
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date == today) return l10n.today;
    if (date == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    if (date.year == now.year) return DateFormat('d MMM').format(date);
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _label(context),
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 0.5)),
        ],
      ),
    );
  }
}
