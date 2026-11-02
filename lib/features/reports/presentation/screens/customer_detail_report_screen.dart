import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/vendor/domain/repositories/vendor_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/report_models.dart';
import '../bloc/customer_detail_cubit.dart';
import 'customer_detail_report_screen/widgets/balance_check.dart';
import 'customer_detail_report_screen/widgets/balance_hero.dart';
import 'customer_detail_report_screen/widgets/entry_counts_row.dart';
import 'customer_detail_report_screen/widgets/monthly_row.dart';
import 'customer_detail_report_screen/widgets/stat_card.dart';

class CustomerDetailReportScreen extends StatelessWidget {
  final String linkId;
  final String customerName;

  const CustomerDetailReportScreen({
    super.key,
    required this.linkId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CustomerDetailCubit(getIt<VendorRepository>())..load(linkId),
      child:
          _CustomerDetailView(linkId: linkId, customerName: customerName),
    );
  }
}

class _CustomerDetailView extends StatelessWidget {
  final String linkId;
  final String customerName;
  const _CustomerDetailView(
      {required this.linkId, required this.customerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customerName, style: AppTypography.h3),
            Text(AppLocalizations.of(context)!.customerReport,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.primary)),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
          builder: (context, state) {
            if (state is CustomerDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CustomerDetailError) {
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
                      onPressed: () =>
                          context.read<CustomerDetailCubit>().load(linkId),
                      child: Text(AppLocalizations.of(context)!.retryButton),
                    ),
                  ],
                ),
              );
            }
            if (state is CustomerDetailLoaded) {
              return _DetailBody(detail: state.detail);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final CustomerDetailReport detail;
  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewPadding.bottom + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceHero(balance: detail.balance),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.overview, style: AppTypography.h3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ReportsStatCard(
                  title: AppLocalizations.of(context)!.billedNet,
                  subtitle: AppLocalizations.of(context)!.exclDisputed,
                  value: '₹${detail.totalCredit.toStringAsFixed(0)}',
                  color: AppColors.error,
                  icon: Icons.receipt_long_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ReportsStatCard(
                  title: AppLocalizations.of(context)!.receivedLabel,
                  subtitle: AppLocalizations.of(context)!.paymentsAndAdj,
                  value: '₹${detail.totalPaid.toStringAsFixed(0)}',
                  color: AppColors.success,
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BalanceCheck(
            billed: detail.totalCredit,
            received: detail.totalPaid,
            balance: detail.balance,
          ),
          const SizedBox(height: 4),
          EntryCountsRow(
            pending: detail.pendingCount,
            confirmed: detail.confirmedCount,
            disputed: detail.disputedCount,
          ),
          if (detail.monthlyBreakdown.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.paymentHistory6Months, style: AppTypography.h3),
            const SizedBox(height: 12),
            ...detail.monthlyBreakdown.map((m) => MonthlyRow(data: m)),
          ],
        ],
      ),
    );
  }
}
