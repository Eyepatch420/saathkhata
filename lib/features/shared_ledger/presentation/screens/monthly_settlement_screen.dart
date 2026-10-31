import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../bloc/ledger_bloc.dart';
import '../bloc/ledger_state.dart';

class MonthlySettlementScreen extends StatefulWidget {
  final String customerName;
  final bool isVendorView;

  const MonthlySettlementScreen({
    super.key,
    required this.customerName,
    required this.isVendorView,
  });

  @override
  State<MonthlySettlementScreen> createState() =>
      _MonthlySettlementScreenState();
}

class _MonthlySettlementScreenState extends State<MonthlySettlementScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _prevMonth() => setState(
      () => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1));

  void _nextMonth() {
    final next = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    if (next.isBefore(DateTime.now())) {
      setState(() => _selectedMonth = next);
    }
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year && _selectedMonth.month == now.month;
  }

  List<LedgerEntry> _entriesForMonth(List<LedgerEntry> all) {
    return all.where((e) {
      return e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.monthlyStatementTitle),
            Text(
              widget.customerName,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: BlocBuilder<LedgerBloc, LedgerState>(
        builder: (context, state) {
          final allEntries = state is LedgerLoaded
              ? state.allEntries
              : state is LedgerActionLoading
                  ? state.entries
                  : <LedgerEntry>[];

          final monthEntries = _entriesForMonth(allEntries);

          final credits = monthEntries
              .where((e) =>
                  e.type == EntryType.credit &&
                  (e.status == EntryStatus.confirmed ||
                      e.status == EntryStatus.autoConfirmed))
              .fold(0.0, (s, e) => s + e.amount);

          final payments = monthEntries
              .where((e) =>
                  (e.type == EntryType.payment ||
                      e.type == EntryType.advance) &&
                  (e.status == EntryStatus.confirmed ||
                      e.status == EntryStatus.autoConfirmed))
              .fold(0.0, (s, e) => s + e.amount);

          final netDue = credits - payments;

          return Column(
            children: [
              // Month picker
              _MonthPicker(
                month: _selectedMonth,
                onPrev: _prevMonth,
                onNext: _isCurrentMonth ? null : _nextMonth,
              ),
              // Summary cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: widget.isVendorView
                            ? l10n.totalBilledLabel
                            : l10n.totalDuesLabel,
                        amount: credits,
                        color: AppColors.error,
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        label: l10n.payments,
                        amount: payments,
                        color: AppColors.success,
                        icon: Icons.arrow_downward_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              // Net due
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: netDue > 0
                      ? AppColors.error.withValues(alpha: 0.08)
                      : AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      netDue >= 0 ? l10n.netDueLabel : l10n.advanceSingle,
                      style: AppTypography.labelLarge,
                    ),
                    Text(
                      '₹${netDue.abs().toStringAsFixed(2)}',
                      style: AppTypography.h3.copyWith(
                        color: netDue > 0 ? AppColors.error : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Entry list
              if (monthEntries.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.noTransactionsThisMonth,
                      style: const TextStyle(color: AppColors.textHint),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: monthEntries.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 1),
                    itemBuilder: (_, i) =>
                        _SettlementEntryRow(entry: monthEntries[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Month Picker ─────────────────────────────────────────────────────────────

class _MonthPicker extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  const _MonthPicker(
      {required this.month, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrev,
          ),
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: AppTypography.labelLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNext,
            color: onNext == null ? AppColors.textHint : null,
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style:
                      AppTypography.bodySmall.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: AppTypography.h3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Entry Row ────────────────────────────────────────────────────────────────

class _SettlementEntryRow extends StatelessWidget {
  final LedgerEntry entry;

  const _SettlementEntryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCredit = entry.type == EntryType.credit;
    final color = isCredit ? AppColors.error : AppColors.success;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            DateFormat('dd').format(entry.date),
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textHint, fontSize: 11),
          ),
          const SizedBox(width: 12),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.description ??
                  (isCredit ? l10n.creditLabel : l10n.paymentLabel),
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isCredit ? '+' : '-'}₹${entry.amount.toStringAsFixed(2)}',
            style: AppTypography.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
