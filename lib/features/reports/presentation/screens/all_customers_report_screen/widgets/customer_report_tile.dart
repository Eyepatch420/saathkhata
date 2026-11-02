import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/router/app_router.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/report_models.dart';

class CustomerReportTile extends StatelessWidget {
  final CustomerReportItem customer;
  const CustomerReportTile({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        AppRouter.customerDetailReport,
        extra: {'linkId': customer.linkId, 'name': customer.customerName},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                customer.customerName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.customerName,
                      style: AppTypography.labelLarge),
                  if (customer.customerPhone != null)
                    Text(
                      customer.customerPhone!,
                      style: AppTypography.bodySmall,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${customer.balance.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(
                    color: customer.balance > 0
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
                if (customer.collectedThisMonth > 0)
                  Text(
                    AppLocalizations.of(context)!.collectedThisMonthShort(customer.collectedThisMonth.toStringAsFixed(0)),
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.success),
                  ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
