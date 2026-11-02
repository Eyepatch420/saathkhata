import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../memberships/presentation/widgets/membership_plan_badge.dart';
import '../bloc/vendor_bloc.dart';
import '../bloc/vendor_event.dart';
import '../bloc/vendor_state.dart';

class AllCustomersScreen extends StatelessWidget {
  const AllCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the singleton VendorBloc provided by VendorMainWrapper — no fresh load needed.
    return BlocProvider.value(
      value: getIt<VendorBloc>(),
      child: const _AllCustomersView(),
    );
  }
}

class _AllCustomersView extends StatelessWidget {
  const _AllCustomersView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.allCustomers, style: AppTypography.h3),
            Text(
              l10n.sharedLedger,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
      body: SafeArea(child: BlocBuilder<VendorBloc, VendorState>(
        builder: (context, state) {
          if (state is VendorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VendorError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<VendorBloc>().add(LoadVendorDashboard()),
            );
          }
          if (state is VendorLoaded) {
            if (state.customers.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.people_outline_rounded,
                title: l10n.noCustomersYet,
                subtitle: l10n.noCustomersYetSubtitle,
              );
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<VendorBloc>().add(LoadVendorDashboard()),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
                itemCount: state.customers.length,
                separatorBuilder: (_, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = state.customers[index];
                  return _CustomerTile(customer: customer);
                },
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

class _CustomerTile extends StatelessWidget {
  final dynamic customer;
  const _CustomerTile({required this.customer});

  @override
  Widget build(BuildContext context) {
    final displayName = customer.displayName as String;
    final subName = customer.subName as String?;
    return InkWell(
      onTap: () => context.push(AppRouter.customerDetail, extra: customer),
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
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(displayName,
                            style: AppTypography.labelLarge,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (customer.tierName != null) ...[
                        const SizedBox(width: 8),
                        MembershipPlanBadge(name: customer.tierName!),
                      ],
                    ],
                  ),
                  if (subName != null)
                    Text(subName,
                        style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${customer.balance.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.error),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
