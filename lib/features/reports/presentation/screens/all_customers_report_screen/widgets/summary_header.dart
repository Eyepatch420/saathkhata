import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/report_models.dart';

class CustomersSummaryHeader extends StatelessWidget {
  final List<CustomerReportItem> customers;
  const CustomersSummaryHeader({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    final totalOutstanding = customers.fold(
      0.0,
      (s, c) => s + (c.balance > 0 ? c.balance : 0),
    );
    final totalCollected = customers.fold(
      0.0,
      (s, c) => s + c.collectedThisMonth,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.customersCount(customers.length),
                  style: AppTypography.labelLarge,
                ),
                Text(
                  AppLocalizations.of(context)!.rankedByOutstanding,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${totalOutstanding.toStringAsFixed(0)}',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.error),
              ),
              Text(
                AppLocalizations.of(context)!.collectedThisMonth(totalCollected.toStringAsFixed(0)),
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
