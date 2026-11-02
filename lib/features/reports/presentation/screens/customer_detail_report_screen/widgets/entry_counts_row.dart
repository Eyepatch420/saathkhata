import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';

class EntryCountsRow extends StatelessWidget {
  final int pending;
  final int confirmed;
  final int disputed;

  const EntryCountsRow({
    super.key,
    required this.pending,
    required this.confirmed,
    required this.disputed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _CountChip(label: AppLocalizations.of(context)!.statusPending, count: pending, color: Colors.orange),
          _VerticalDivider(),
          _CountChip(label: AppLocalizations.of(context)!.statusConfirmed, count: confirmed, color: AppColors.success),
          _VerticalDivider(),
          _CountChip(label: AppLocalizations.of(context)!.statusDisputed, count: disputed, color: AppColors.error),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountChip(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: AppTypography.h3.copyWith(color: color)),
        Text(label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textHint)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: 36,
        color: AppColors.textHint.withValues(alpha: 0.2));
  }
}
