import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/utils/app_logger.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../bloc/ledger_bloc.dart';
import '../../../bloc/ledger_event.dart';
import 'date_picker_row.dart';

class MultiItemEntrySheet extends StatefulWidget {
  final String linkId;
  final String customerName;

  const MultiItemEntrySheet({
    super.key,
    required this.linkId,
    required this.customerName,
  });

  @override
  State<MultiItemEntrySheet> createState() => _MultiItemEntrySheetState();
}

class _MultiItemEntrySheetState extends State<MultiItemEntrySheet> {
  static const _m = 'MultiItemEntrySheet';
  final List<_ItemRowState> _rows = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _rows.add(_ItemRowState());
  }

  double get _total => _rows.fold(0.0, (sum, r) => sum + r.subtotal);

  bool get _isValid =>
      _rows.isNotEmpty &&
      _rows.every(
        (r) =>
            r.descCtrl.text.trim().isNotEmpty &&
            (double.tryParse(r.amountCtrl.text) ?? 0) > 0,
      );

  void _addRow() => setState(() => _rows.add(_ItemRowState()));

  void _removeRow(int index) {
    if (_rows.length == 1) return;
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  void _submit() {
    if (!_isValid) {
      AppLogger.w(
        _m,
        'Submit blocked — validation failed (rows: ${_rows.length})',
      );
      return;
    }
    final bloc = context.read<LedgerBloc>();
    final items = _rows
        .map(
          (r) => ItemRow(
            description: r.descCtrl.text.trim(),
            // amount is the line's total (price/unit × qty), not the raw
            // price-per-unit the user typed — see _ItemRowState.subtotal.
            amount: r.subtotal,
            quantity: double.tryParse(r.qtyCtrl.text),
            unit: r.unitCtrl.text.trim().isEmpty
                ? null
                : r.unitCtrl.text.trim(),
          ),
        )
        .toList();
    AppLogger.i(
      _m,
      'Submitting ${items.length} item(s), total ₹${_total.toStringAsFixed(2)}',
    );
    Navigator.pop(context);
    bloc.add(AddMultiItemLedgerEntry(
      linkId: widget.linkId,
      items: items,
      date: _selectedDate,
    ));
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed — both are needed so the
        // sheet never sits under either.
        bottom: mq.viewInsets.bottom + mq.viewPadding.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.giveCreditSheet, style: AppTypography.h3),
                      Text(
                        l10n.entryFor(widget.customerName),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                for (int i = 0; i < _rows.length; i++)
                  _ItemRowWidget(
                    key: ValueKey(i),
                    row: _rows[i],
                    index: i,
                    canRemove: _rows.length > 1,
                    onRemove: () => _removeRow(i),
                    onChanged: () => setState(() {}),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
              label: Text(l10n.addItemLabel),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            LedgerDatePickerRow(
              selectedDate: _selectedDate,
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? now,
                  firstDate: DateTime(now.year - 1, now.month, now.day),
                  lastDate: now,
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.totalAmountLabel, style: AppTypography.labelLarge),
                Text(
                  '₹${_total.toStringAsFixed(2)}',
                  style: AppTypography.h3.copyWith(color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.addCreditEntry,
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
    );
  }
}

class _ItemRowState {
  final descCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final unitCtrl = TextEditingController();

  /// Amount is price-per-unit; quantity defaults to 1 when left blank so a
  /// single flat-amount item (no quantity) still totals correctly.
  double get subtotal {
    final amount = double.tryParse(amountCtrl.text) ?? 0;
    final qty = double.tryParse(qtyCtrl.text);
    return amount * (qty ?? 1);
  }

  void dispose() {
    descCtrl.dispose();
    amountCtrl.dispose();
    qtyCtrl.dispose();
    unitCtrl.dispose();
  }
}

class _ItemRowWidget extends StatelessWidget {
  final _ItemRowState row;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _ItemRowWidget({
    super.key,
    required this.row,
    required this.index,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.itemLabel(index + 1),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (canRemove)
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 18,
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: row.descCtrl,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              labelText: l10n.itemNameRequired,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: row.amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => onChanged(),
                  decoration: InputDecoration(
                    labelText: l10n.amountRequired,
                    hintText: l10n.perUnitLabel,
                    prefixText: '₹ ',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: row.qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => onChanged(),
                  decoration: InputDecoration(
                    labelText: l10n.qty,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: row.unitCtrl,
                  onChanged: (_) => onChanged(),
                  decoration: InputDecoration(
                    labelText: l10n.unitLabel,
                    isDense: true,
                    hintText: l10n.unitHint,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              l10n.subtotalAmountLabel(
                row.subtotal.toStringAsFixed(2),
              ),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
