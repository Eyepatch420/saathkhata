import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/vendor/domain/repositories/vendor_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/reports_dashboard_cubit.dart';
import 'reports_screen/widgets/revenue_chart_card.dart';
import 'reports_screen/widgets/summary_card.dart';
import 'reports_screen/widgets/top_customer_item.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReportsDashboardCubit(getIt<VendorRepository>())..loadDashboard(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.businessReports)),
      body: SafeArea(
        child: BlocBuilder<ReportsDashboardCubit, ReportsDashboardState>(
          builder: (context, state) {
            if (state is ReportsDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReportsDashboardError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.error),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ReportsDashboardCubit>()
                          .loadDashboard(),
                      child: Text(l10n.retryButton),
                    ),
                  ],
                ),
              );
            }
            if (state is ReportsDashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ReportsDashboardCubit>().loadDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).viewPadding.bottom + 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RevenueChartCard(state: state),
                      const SizedBox(height: 24),
                      Text(l10n.collectionSummary,
                          style: AppTypography.h3),
                      const SizedBox(height: 16),
                      ReportsSummaryCard(
                        label: l10n.totalOutstanding,
                        value:
                            '₹${state.summary.totalOutstanding.toStringAsFixed(0)}',
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 12),
                      ReportsSummaryCard(
                        label: l10n.totalCollected,
                        value:
                            '₹${state.summary.totalCollectedThisMonth.toStringAsFixed(0)}',
                        color: AppColors.success,
                        subtitle: l10n.thisMonthSubtitle,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.topCustomers, style: AppTypography.h3),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRouter.allCustomersReport),
                            child: Text(l10n.seeAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (state.summary.topCustomers.isEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(l10n.noCustomersYet,
                                style: AppTypography.bodySmall
                                    .copyWith(color: AppColors.textHint)),
                          ),
                        )
                      else
                        ...state.summary.topCustomers.map(
                          (c) => TopCustomerItem(
                            name: c.customerName,
                            balance: c.balance,
                            linkId: c.linkId,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
