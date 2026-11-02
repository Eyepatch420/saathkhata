import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/report_models.dart';

class MonthlyRow extends StatelessWidget {
  final MonthlyPaymentData data;
  const MonthlyRow({super.key, required this.data});

  String _formatMonth(String yyyyMm) {
    final parts = yyyyMm.split('-');
    if (parts.length != 2) return yyyyMm;
    final m = int.tryParse(parts[1]) ?? 0;
    final y = parts[0];
    if (m < 1 || m > 12) return y;
    return DateFormat('MMM yyyy')
        .format(DateTime(int.tryParse(y) ?? DateTime.now().year, m));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.payments_rounded,
                  color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatMonth(data.month),
                      style: AppTypography.labelLarge),
                  Text(
                    data.transactionCount == 1
                        ? AppLocalizations.of(context)!.paymentCount(data.transactionCount)
                        : AppLocalizations.of(context)!.paymentCountPlural(data.transactionCount),
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Text(
              '₹${data.totalPaid.toStringAsFixed(0)}',
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
