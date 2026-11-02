import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/report_models.dart';
import '../../../bloc/reports_dashboard_cubit.dart';

class RevenueChartCard extends StatelessWidget {
  final ReportsDashboardLoaded state;
  const RevenueChartCard({super.key, required this.state});

  List<_MonthBar> _buildBars(MonthlyRevenueReport report) {
    final map = <int, double>{};
    for (final m in report.months) {
      final idx = int.tryParse(m.month.substring(5)) ?? 0;
      if (idx >= 1 && idx <= 12) map[idx] = m.totalCollected;
    }
    return List.generate(
      12,
      (i) => _MonthBar(
        label: DateFormat('MMM').format(DateTime(2020, i + 1)),
        amount: map[i + 1] ?? 0,
        isCurrentMonth: (i + 1) == DateTime.now().month &&
            report.year == DateTime.now().year,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReportsDashboardCubit>();
    final bars = _buildBars(state.monthlyRevenue);
    final maxAmount = bars.map((b) => b.amount).reduce(max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.revenueTrend,
                style:
                    AppTypography.bodySmall.copyWith(color: Colors.white70),
              ),
              Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: Colors.white70, size: 20),
                    onPressed: state.yearChanging
                        ? null
                        : () => cubit.changeYear(state.year - 1),
                  ),
                  state.yearChanging
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white70),
                        )
                      : Text(
                          '${state.year}',
                          style: AppTypography.labelLarge
                              .copyWith(color: Colors.white),
                        ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    icon: const Icon(Icons.chevron_right_rounded,
                        color: Colors.white70, size: 20),
                    onPressed: state.yearChanging ||
                            state.year >= DateTime.now().year
                        ? null
                        : () => cubit.changeYear(state.year + 1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars.map((bar) {
                final fraction =
                    maxAmount > 0 ? (bar.amount / maxAmount) : 0.0;
                final barH = bar.amount > 0
                    ? (fraction * 80).clamp(4.0, 80.0)
                    : 0.0;
                return Tooltip(
                  message: '₹${bar.amount.toStringAsFixed(0)}',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 16,
                        height: barH,
                        decoration: BoxDecoration(
                          color: bar.isCurrentMonth
                              ? Colors.white
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bars
                .map((bar) => SizedBox(
                      width: 16,
                      child: Text(
                        bar.label.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: bar.isCurrentMonth
                              ? Colors.white
                              : Colors.white54,
                          fontSize: 9,
                          fontWeight: bar.isCurrentMonth
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MonthBar {
  final String label;
  final double amount;
  final bool isCurrentMonth;
  const _MonthBar({
    required this.label,
    required this.amount,
    required this.isCurrentMonth,
  });
}
