import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../staff_portal/domain/models/staff_self.dart';
import '../../../../domain/repositories/staff_repository.dart';

/// Vendor-side payment history for a single staff member — salary payments and
/// advances, newest first. Shown under the attendance calendar on the staff
/// detail screen.
class SalaryHistorySection extends StatefulWidget {
  final String staffId;

  /// Changes whenever the staff's unpaid/advance balances change, forcing a
  /// re-fetch so a just-made payment or advance shows up immediately.
  final String refreshKey;

  const SalaryHistorySection({
    super.key,
    required this.staffId,
    required this.refreshKey,
  });

  @override
  State<SalaryHistorySection> createState() => _SalaryHistorySectionState();
}

class _SalaryHistorySectionState extends State<SalaryHistorySection> {
  late Future<List<StaffPayTransaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<StaffRepository>().getSalaryHistory(widget.staffId);
  }

  @override
  void didUpdateWidget(covariant SalaryHistorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshKey != widget.refreshKey) {
      _future = getIt<StaffRepository>().getSalaryHistory(widget.staffId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.paymentHistoryTitle, style: AppTypography.labelLarge),
        const SizedBox(height: 12),
        FutureBuilder<List<StaffPayTransaction>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Could not load payment history',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textHint),
                ),
              );
            }
            final txs = snapshot.data ?? [];
            if (txs.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'No payments yet',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textHint),
                  ),
                ),
              );
            }
            return Column(
              children: txs
                  .map((t) =>
                      _SalaryHistoryTile(tx: t, locale: locale, l10n: l10n))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SalaryHistoryTile extends StatelessWidget {
  final StaffPayTransaction tx;
  final String locale;
  final AppLocalizations l10n;

  const _SalaryHistoryTile({
    required this.tx,
    required this.locale,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isSalary = tx.type == 'salary';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isSalary ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSalary
                  ? Icons.account_balance_wallet_rounded
                  : Icons.south_west_rounded,
              color: isSalary ? AppColors.success : AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSalary ? l10n.salaryTitle : l10n.advanceTaken,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('d MMM yyyy, h:mm a', locale).format(tx.createdAt),
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textHint),
                ),
                if (tx.note != null && tx.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    tx.note!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isSalary ? '+' : '−'} ₹${tx.amount.toStringAsFixed(0)}',
            style: AppTypography.labelLarge.copyWith(
              color: isSalary ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
