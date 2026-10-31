import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/link_model.dart';
import '../cubit/staff_portal_cubit.dart';
import '../widgets/record_entry_sheet.dart';
import '../../../../shared/models/ledger_entry.dart';

/// Staff quick delivery: pick a customer → sheet pre-fills default product/qty.
class StaffQuickDeliveryScreen extends StatefulWidget {
  const StaffQuickDeliveryScreen({super.key});

  @override
  State<StaffQuickDeliveryScreen> createState() =>
      _StaffQuickDeliveryScreenState();
}

class _StaffQuickDeliveryScreenState extends State<StaffQuickDeliveryScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CustomerLinkItem> _filtered(List<CustomerLinkItem> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((c) =>
            c.displayName.toLowerCase().contains(q) ||
            (c.customer.mobile?.contains(q) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.staffQuickDelivery),
      ),
      body: BlocBuilder<StaffPortalCubit, StaffPortalState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Text(state.error!,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.error)),
            );
          }

          final customers = _filtered(state.customers);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.searchCustomerHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => _searchCtrl.clear(),
                          )
                        : null,
                    isDense: true,
                  ),
                ),
              ),
              if (customers.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      _query.isEmpty ? l10n.noCustomersStaff : l10n.noResults,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textHint),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: customers.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) =>
                        _CustomerDeliveryTile(customer: customers[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomerDeliveryTile extends StatelessWidget {
  final CustomerLinkItem customer;

  const _CustomerDeliveryTile({required this.customer});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasDefault = customer.defaultProduct != null;
    final defaultLabel = hasDefault
        ? '${customer.defaultQty != null ? '${customer.defaultQty!.toStringAsFixed(customer.defaultQty! % 1 == 0 ? 0 : 2)} ${customer.defaultUnit ?? ''} ' : ''}${customer.defaultProduct}'
        : l10n.noDefaultSet;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openDeliverySheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  customer.displayName.isNotEmpty
                      ? customer.displayName[0].toUpperCase()
                      : '?',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.displayName, style: AppTypography.labelLarge),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          hasDefault
                              ? Icons.inventory_2_outlined
                              : Icons.add_circle_outline_rounded,
                          size: 12,
                          color: hasDefault
                              ? AppColors.textSecondary
                              : AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          defaultLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: hasDefault
                                ? AppColors.textSecondary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDeliverySheet(BuildContext context) {
    final cubit = context.read<StaffPortalCubit>();
    showRecordEntrySheet(
      context,
      type: EntryType.credit,
      customers: [customer],
      preselected: customer,
    ).then((added) {
      if (added == true) cubit.load();
    });
  }
}
