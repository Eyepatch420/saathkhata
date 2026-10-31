import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/payment_transaction.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(getIt())..add(const LoadPayments('c1')),
      child: const _PaymentsView(),
    );
  }
}

class _PaymentsView extends StatelessWidget {
  const _PaymentsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.payments)),
      body: SafeArea(child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<PaymentBloc>().add(const LoadPayments('c1')),
            );
          }
          if (state is PaymentLoaded) {
            return _PaymentsContent(state: state);
          }
          return const SizedBox();
        },
      ),
      ),
    );
  }
}

class _PaymentsContent extends StatelessWidget {
  final PaymentLoaded state;
  const _PaymentsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(totalPaid: state.totalPaid, totalPending: state.totalPending),
          const SizedBox(height: 24),
          _QuickPayCard(),
          const SizedBox(height: 24),
          Text(l10n.transactionHistory, style: AppTypography.h3),
          const SizedBox(height: 16),
          if (state.transactions.isEmpty)
            EmptyStateWidget(
              icon: Icons.receipt_long_rounded,
              title: l10n.noTransactionsTitle,
              subtitle: l10n.noTransactionsSubtitle,
            )
          else
            ...state.transactions.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PaymentTile(transaction: t),
                )),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double totalPaid;
  final double totalPending;
  const _SummaryRow({required this.totalPaid, required this.totalPending});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _SummaryStat(
            label: l10n.totalPaid,
            value: '₹${totalPaid.toStringAsFixed(0)}',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryStat(
            label: l10n.pending,
            value: '₹${totalPending.toStringAsFixed(0)}',
            icon: Icons.pending_rounded,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall),
              Text(value, style: AppTypography.labelLarge.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickPayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_scanner_rounded, size: 56, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(l10n.quickPay, style: AppTypography.labelLarge),
          const SizedBox(height: 4),
          Text(
            l10n.scanUpiDesc,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push(
                    AppRouter.upiPayment,
                    extra: {
                      'amount': 0.0,
                      'recipientName': l10n.vendor,
                      'upiId': null,
                    },
                  ),
                  icon: const Icon(Icons.qr_code_rounded, size: 18),
                  label: Text(l10n.scanAndPay),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentTransaction transaction;
  const _PaymentTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isSuccess = transaction.status == PaymentStatus.success;
    final statusColor = switch (transaction.status) {
      PaymentStatus.success => AppColors.success,
      PaymentStatus.pending => AppColors.warning,
      PaymentStatus.failed => AppColors.error,
      PaymentStatus.refunded => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.1),
            child: Icon(
              isSuccess ? Icons.payment_rounded : Icons.pending_rounded,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.vendorName ?? AppLocalizations.of(context)!.vendor,
                    style: AppTypography.labelLarge),
                Text(
                  DateFormat('dd MMM yyyy').format(DateTime.parse(transaction.createdAt)),
                  style: AppTypography.bodySmall,
                ),
                if (transaction.note != null && transaction.note!.isNotEmpty)
                  Text(
                    transaction.note!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${transaction.amount.toStringAsFixed(0)}',
                style: AppTypography.labelLarge.copyWith(color: statusColor),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusLabel(transaction.status, AppLocalizations.of(context)!),
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(PaymentStatus s, AppLocalizations l10n) => switch (s) {
        PaymentStatus.success => l10n.paymentStatusPaid,
        PaymentStatus.pending => l10n.pending,
        PaymentStatus.failed => l10n.paymentStatusFailed,
        PaymentStatus.refunded => l10n.paymentStatusRefunded,
      };
}
