import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../cubit/staff_portal_cubit.dart';
import '../widgets/record_entry_sheet.dart';

class StaffCustomersScreen extends StatelessWidget {
  const StaffCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customersTitle)),
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
            if (state.customers.isEmpty) {
              return Center(
                child: Text(l10n.noCustomersStaff,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textHint)),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<StaffPortalCubit>().load(),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                    16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
                itemCount: state.customers.length,
                separatorBuilder: (_, i) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final c = state.customers[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          child: Text(c.displayName[0].toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.displayName,
                                  style: AppTypography.labelLarge,
                                  overflow: TextOverflow.ellipsis),
                              Text(l10n.balanceDue(c.balance.toStringAsFixed(0)),
                                  style: AppTypography.bodySmall
                                      .copyWith(color: AppColors.error)),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.recordDeliveryTooltip,
                          icon: const Icon(Icons.local_shipping_rounded,
                              color: AppColors.error),
                          onPressed: () {
                            final cubit = context.read<StaffPortalCubit>();
                            showRecordEntrySheet(
                              context,
                              type: EntryType.credit,
                              customers: state.customers,
                              preselected: c,
                            ).then((added) {
                              if (added == true) cubit.load();
                            });
                          },
                        ),
                        IconButton(
                          tooltip: l10n.viewLedgerTooltip,
                          icon: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textHint),
                          onPressed: () => context.push(
                            AppRouter.sharedLedger,
                            extra: {
                              'linkId': c.linkId,
                              'name': c.displayName,
                              'isVendorView': true,
                              'isStaffView': true,
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
