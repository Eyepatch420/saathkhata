import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/statement_pdf_service.dart';
import '../../../../l10n/app_localizations.dart';

/// Shows a bottom sheet for picking a statement date range.
/// Returns the selected [StatementDateRange] or null if dismissed.
Future<StatementDateRange?> showDateRangePickerSheet(BuildContext context) {
  return showModalBottomSheet<StatementDateRange>(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _DateRangeSheet(),
  );
}

class _DateRangeSheet extends StatelessWidget {
  const _DateRangeSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.exportStatementTitle, style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.chooseExportDateRange,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ...StatementDateRange.values.map(
              (range) => _RangeOption(range: range),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeOption extends StatelessWidget {
  final StatementDateRange range;
  const _RangeOption({required this.range});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (icon, subtitle) = switch (range) {
      StatementDateRange.last7Days => (
          Icons.calendar_view_week_rounded,
          l10n.last7DaysRange,
        ),
      StatementDateRange.last30Days => (
          Icons.calendar_month_rounded,
          l10n.last30DaysRange,
        ),
      StatementDateRange.last3Months => (
          Icons.date_range_rounded,
          l10n.last3MonthsRange,
        ),
      StatementDateRange.allTime => (
          Icons.all_inclusive_rounded,
          l10n.completeLedgerHistory,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Navigator.pop(context, range),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(range.label, style: AppTypography.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
