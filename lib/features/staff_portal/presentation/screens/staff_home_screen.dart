import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/staff_portal_cubit.dart';
import '../widgets/record_entry_sheet.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final isStaff = user?.isStaff ?? false;
    // `effectiveBusinessName` resolves to the OWNER VENDOR's business name for a
    // staff login. It used to be the AppBar title, so a staff member saw the
    // shop's name up top and assumed the wrong account had loaded. Lead with the
    // signed-in person's own name and keep the business as the second line.
    final business = user?.effectiveBusinessName ?? 'SaathKhata';
    final title = isStaff ? (user?.name ?? business) : business;
    final subtitle = l10n.staffRoleSubtitle(isStaff ? business : (user?.name ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.h3),
            Text(subtitle,
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<StaffPortalCubit, StaffPortalState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return ErrorStateWidget(
                message: state.error!,
                onRetry: () => context.read<StaffPortalCubit>().load(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<StaffPortalCubit>().load(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.of(context).padding.bottom + 24),
                children: [
                  _ActionButton(
                    icon: Icons.flash_on_rounded,
                    label: l10n.staffQuickDelivery,
                    subtitle: l10n.staffQuickDeliverySubtitle,
                    color: AppColors.primary,
                    onTap: () => context.push(AppRouter.staffQuickDelivery),
                  ),
                  const SizedBox(height: 14),
                  _ActionButton(
                    icon: Icons.shopping_bag_outlined,
                    label: l10n.ordersTitle,
                    subtitle: l10n.staffOrdersSubtitle,
                    color: const Color(0xFFFF6B35),
                    onTap: () => context.push(AppRouter.staffOrders),
                  ),
                  const SizedBox(height: 14),
                  _ActionButton(
                    icon: Icons.local_shipping_rounded,
                    label: l10n.recordDelivery,
                    subtitle: l10n.recordDeliverySubtitle,
                    color: AppColors.error,
                    onTap: () => _record(context, EntryType.credit),
                  ),
                  const SizedBox(height: 14),
                  _ActionButton(
                    icon: Icons.payments_rounded,
                    label: l10n.collectPayment,
                    subtitle: l10n.collectPaymentSubtitle,
                    color: AppColors.success,
                    onTap: () => _record(context, EntryType.payment),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.customersTitle, style: AppTypography.h3),
                      TextButton(
                        onPressed: () => context.go(AppRouter.staffCustomers),
                        child: Text(l10n.viewAll2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (state.customers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(l10n.noCustomersStaff,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textHint)),
                      ),
                    )
                  else
                    ...state.customers.take(5).map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CustomerRow(
                            name: c.displayName,
                            balance: c.balance,
                            onTap: () => context.push(
                              AppRouter.sharedLedger,
                              extra: {
                                'linkId': c.linkId,
                                'name': c.displayName,
                                'isVendorView': true,
                                'isStaffView': true,
                              },
                            ),
                          ),
                        )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _record(BuildContext context, EntryType type) {
    final cubit = context.read<StaffPortalCubit>();
    final customers = cubit.state.customers;
    if (customers.isEmpty) return;
    showRecordEntrySheet(context, type: type, customers: customers)
        .then((added) {
      if (added == true) cubit.load();
    });
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppTypography.labelLarge.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerRow extends StatelessWidget {
  final String name;
  final double balance;
  final VoidCallback onTap;

  const _CustomerRow({
    required this.name,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(name[0].toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(name,
                  style: AppTypography.labelLarge,
                  overflow: TextOverflow.ellipsis),
            ),
            Text('₹${balance.toStringAsFixed(0)}',
                style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}
