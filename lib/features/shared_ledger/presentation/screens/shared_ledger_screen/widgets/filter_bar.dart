import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/localization/localized_labels.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/ledger_entry.dart';
import '../../../../../shared_ledger/domain/models/ledger_filter.dart';
import '../../../bloc/ledger_bloc.dart';
import '../../../bloc/ledger_event.dart';
import '../../../bloc/ledger_state.dart';

class LedgerFilterBar extends StatelessWidget {
  const LedgerFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LedgerBloc, LedgerState>(
      builder: (context, state) {
        final filter = state is LedgerLoaded
            ? state.filter
            : const LedgerFilter();
        final hasActiveFilters = !filter.isEmpty;

        return Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              // Filter icon button
              InkWell(
                onTap: () => _showFilterSheet(context, filter),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: hasActiveFilters
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasActiveFilters
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 16,
                        color: hasActiveFilters
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      if (hasActiveFilters) ...[
                        const SizedBox(width: 4),
                        Text(
                          '${filter.activeCount}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Active filter chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (!hasActiveFilters) ...[
                        // Default status chips when no filter active
                        _StatusChip(
                          label: AppLocalizations.of(context)!.filterAll,
                          isActive: true,
                          onTap: () {},
                        ),
                        const SizedBox(width: 6),
                        _StatusChip(
                          label: AppLocalizations.of(context)!.statusPending,
                          color: AppColors.warning,
                          onTap: () => context.read<LedgerBloc>().add(
                            ApplyLedgerFilter(
                              LedgerFilter(status: EntryStatus.pending),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _StatusChip(
                          label: AppLocalizations.of(context)!.statusConfirmed,
                          color: AppColors.success,
                          onTap: () => context.read<LedgerBloc>().add(
                            ApplyLedgerFilter(
                              LedgerFilter(status: EntryStatus.confirmed),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _StatusChip(
                          label: AppLocalizations.of(context)!.statusDisputed,
                          color: AppColors.error,
                          onTap: () => context.read<LedgerBloc>().add(
                            ApplyLedgerFilter(
                              LedgerFilter(status: EntryStatus.disputed),
                            ),
                          ),
                        ),
                      ] else ...[
                        if (filter.status != null)
                          _ActiveChip(
                            label: l10n.filterStatusChip(
                              l10n.entryStatusName(filter.status!),
                            ),
                            onRemove: () => context.read<LedgerBloc>().add(
                              ApplyLedgerFilter(
                                filter.copyWith(clearStatus: true),
                              ),
                            ),
                          ),
                        if (filter.type != null || filter.deliveriesOnly) ...[
                          if (filter.status != null) const SizedBox(width: 6),
                          _ActiveChip(
                            label: filter.deliveriesOnly
                                ? l10n.deliveriesOnly
                                : l10n.filterTypeChip(
                                    l10n.entryTypeName(filter.type!),
                                  ),
                            onRemove: () => context.read<LedgerBloc>().add(
                              ApplyLedgerFilter(
                                filter.copyWith(clearType: true),
                              ),
                            ),
                          ),
                        ],
                        if (filter.dateFrom != null ||
                            filter.dateTo != null) ...[
                          const SizedBox(width: 6),
                          _ActiveChip(
                            label: _dateRangeLabel(l10n, filter),
                            onRemove: () => context.read<LedgerBloc>().add(
                              ApplyLedgerFilter(
                                filter.copyWith(clearDates: true),
                              ),
                            ),
                          ),
                        ],
                        if (filter.amountMin != null ||
                            filter.amountMax != null) ...[
                          const SizedBox(width: 6),
                          _ActiveChip(
                            label: _amountLabel(filter),
                            onRemove: () => context.read<LedgerBloc>().add(
                              ApplyLedgerFilter(
                                filter.copyWith(clearAmount: true),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => context.read<LedgerBloc>().add(
                            const ClearLedgerFilter(),
                          ),
                          child: Text(
                            l10n.clearAllFilters,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _dateRangeLabel(AppLocalizations l10n, LedgerFilter f) {
    final fmt = DateFormat('d MMM');
    if (f.dateFrom != null && f.dateTo != null) {
      return '${fmt.format(f.dateFrom!)}–${fmt.format(f.dateTo!)}';
    }
    if (f.dateFrom != null) {
      return l10n.fromDateLabel(fmt.format(f.dateFrom!));
    }
    return l10n.toDateLabel(fmt.format(f.dateTo!));
  }

  String _amountLabel(LedgerFilter f) {
    if (f.amountMin != null && f.amountMax != null) {
      return '₹${f.amountMin!.toInt()}–₹${f.amountMax!.toInt()}';
    }
    if (f.amountMin != null) return '≥₹${f.amountMin!.toInt()}';
    return '≤₹${f.amountMax!.toInt()}';
  }

  void _showFilterSheet(BuildContext context, LedgerFilter current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _FilterSheet(
        current: current,
        onApply: (f) => context.read<LedgerBloc>().add(ApplyLedgerFilter(f)),
        onReset: () =>
            context.read<LedgerBloc>().add(const ClearLedgerFilter()),
      ),
    );
  }
}

// ─── Active chip (dismissible) ────────────────────────────────────────────────

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Default status chip ──────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;
  const _StatusChip({
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? c : c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : c,
          ),
        ),
      ),
    );
  }
}

// ─── Filter bottom sheet ──────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final LedgerFilter current;
  final void Function(LedgerFilter) onApply;
  final VoidCallback onReset;

  const _FilterSheet({
    required this.current,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late EntryStatus? _status;
  late EntryType? _type;
  late bool _deliveriesOnly;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _status = widget.current.status;
    _type = widget.current.type;
    _deliveriesOnly = widget.current.deliveriesOnly;
    _dateFrom = widget.current.dateFrom;
    _dateTo = widget.current.dateTo;
    _minCtrl = TextEditingController(
      text: widget.current.amountMin?.toStringAsFixed(0) ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.current.amountMax?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(l10n.filterEntriesTitle, style: AppTypography.h3),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onReset();
                    },
                    child: Text(l10n.resetLabel),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status
              Text(l10n.statusLabel.toUpperCase(),
                  style: _sectionStyle(context)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _OptionChip(
                    label: l10n.filterAll,
                    selected: _status == null,
                    onTap: () => setState(() => _status = null),
                  ),
                  _OptionChip(
                    label: l10n.statusPending,
                    selected: _status == EntryStatus.pending,
                    color: AppColors.warning,
                    onTap: () => setState(
                      () => _status = _status == EntryStatus.pending
                          ? null
                          : EntryStatus.pending,
                    ),
                  ),
                  _OptionChip(
                    label: l10n.statusConfirmed,
                    selected: _status == EntryStatus.confirmed,
                    color: AppColors.success,
                    onTap: () => setState(
                      () => _status = _status == EntryStatus.confirmed
                          ? null
                          : EntryStatus.confirmed,
                    ),
                  ),
                  _OptionChip(
                    label: l10n.statusDisputed,
                    selected: _status == EntryStatus.disputed,
                    color: AppColors.error,
                    onTap: () => setState(
                      () => _status = _status == EntryStatus.disputed
                          ? null
                          : EntryStatus.disputed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Type
              Text(l10n.typeLabel.toUpperCase(),
                  style: _sectionStyle(context)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _OptionChip(
                    label: l10n.filterAll,
                    selected: _type == null && !_deliveriesOnly,
                    onTap: () => setState(() {
                      _type = null;
                      _deliveriesOnly = false;
                    }),
                  ),
                  _OptionChip(
                    label: l10n.creditLabel,
                    selected: _type == EntryType.credit,
                    onTap: () => setState(() {
                      _type = _type == EntryType.credit
                          ? null
                          : EntryType.credit;
                      _deliveriesOnly = false;
                    }),
                  ),
                  _OptionChip(
                    label: l10n.paymentLabel,
                    selected: _type == EntryType.payment,
                    onTap: () => setState(() {
                      _type = _type == EntryType.payment
                          ? null
                          : EntryType.payment;
                      _deliveriesOnly = false;
                    }),
                  ),
                  _OptionChip(
                    label: l10n.advanceSingle,
                    selected: _type == EntryType.advance,
                    onTap: () => setState(() {
                      _type = _type == EntryType.advance
                          ? null
                          : EntryType.advance;
                      _deliveriesOnly = false;
                    }),
                  ),
                  _OptionChip(
                    label: l10n.deliveriesOnly,
                    selected: _deliveriesOnly,
                    onTap: () => setState(() {
                      _deliveriesOnly = !_deliveriesOnly;
                      if (_deliveriesOnly) _type = null;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date range
              Text(l10n.dateRangeLabel, style: _sectionStyle(context)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DateButton(
                      label: _dateFrom == null
                          ? l10n.fromLabel
                          : DateFormat('d MMM').format(_dateFrom!),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dateFrom ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: _dateTo ?? DateTime.now(),
                        );
                        if (picked != null) setState(() => _dateFrom = picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateButton(
                      label: _dateTo == null
                          ? l10n.toLabel
                          : DateFormat('d MMM').format(_dateTo!),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dateTo ?? DateTime.now(),
                          firstDate: _dateFrom ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _dateTo = picked);
                      },
                    ),
                  ),
                  if (_dateFrom != null || _dateTo != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => setState(() {
                        _dateFrom = null;
                        _dateTo = null;
                      }),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Amount range
              Text(l10n.amountRangeLabel, style: _sectionStyle(context)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '₹',
                        hintText: l10n.minLabel,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '₹',
                        hintText: l10n.maxLabel,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(
                      LedgerFilter(
                        status: _status,
                        type: _type,
                        deliveriesOnly: _deliveriesOnly,
                        dateFrom: _dateFrom,
                        dateTo: _dateTo,
                        amountMin: double.tryParse(_minCtrl.text),
                        amountMax: double.tryParse(_maxCtrl.text),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    l10n.applyFilterButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _sectionStyle(BuildContext context) =>
      AppTypography.bodySmall.copyWith(
        color: AppColors.textHint,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      );
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c : c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : c,
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DateButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}
