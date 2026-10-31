import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../cubit/schedule_cubit.dart';
import 'subscribe_sheet.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ScheduledService service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionsCubit>().loadForService(widget.service.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final svc = widget.service;
    return Scaffold(
      appBar: AppBar(
        title: Text(svc.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (svc.isActive)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'deactivate') _deactivate(context);
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'deactivate', child: Text(l10n.deactivate)),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(service: svc),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subscribersTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showSubscribeSheet(context),
                icon: const Icon(Icons.person_add, size: 16),
                label: Text(l10n.addCustomerButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
            builder: (context, state) {
              if (state is SubscriptionsLoading) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ));
              }
              if (state is SubscriptionsError) {
                return Text(state.message,
                    style: const TextStyle(color: AppColors.error));
              }
              final subs = (state as SubscriptionsLoaded).subscriptions;
              if (subs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(l10n.noSubscribersYet,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                );
              }
              return Column(
                children: subs
                    .map((s) => _SubscriberTile(sub: s))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSubscribeSheet(BuildContext context) {
    final cubit = context.read<SubscriptionsCubit>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SubscribeSheet(service: widget.service),
      ),
    );
  }

  void _deactivate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final servicesCubit = context.read<ServicesCubit>();
    bool submitting = false;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.deactivateServiceTitle),
          content: Text(l10n.deactivateServiceMessage),
          actions: [
            TextButton(
                onPressed: submitting
                    ? null
                    : () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: submitting
                  ? null
                  : () async {
                      setDialogState(() => submitting = true);
                      final ok = await servicesCubit.deactivate(
                        widget.service.id,
                      );
                      if (!dialogContext.mounted) return;
                      Navigator.pop(dialogContext);
                      if (ok && context.mounted) Navigator.pop(context);
                    },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.deactivate,
                      style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ScheduledService service;
  const _InfoCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service.description != null) ...[
              Text(service.description!,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
            ],
            _row(l10n.typeLabel, l10n.serviceTypeName(service.serviceType)),
            _row(l10n.scheduleLabel, l10n.serviceScheduleName(service)),
            _row(l10n.autoLedgerEntryLabel,
                service.autoCreateLedgerEntry ? l10n.yesLabel : l10n.noLabel),
            _row(l10n.statusLabel,
                service.isActive ? l10n.active : l10n.inactive),
            const SizedBox(height: 8),
            Text(l10n.itemsLabel,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            ...service.items.map((i) => _row(
                  i.name,
                  '₹${i.defaultPricePerUnit.toStringAsFixed(2)} / ${i.unit}',
                )),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 130,
                child: Text(label,
                    style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
      );
}

class _SubscriberTile extends StatelessWidget {
  final ServiceSubscription sub;
  const _SubscriberTile({required this.sub});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat('d MMM');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sub.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    l10n.subscriptionStartsOn(
                      sub.itemsSummary,
                      fmt.format(sub.startDate),
                    ),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Text(
                    l10n.amountPerDelivery(
                      sub.totalAmount.toStringAsFixed(0),
                    ),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  if (sub.isPaused)
                    Text(l10n.pausedLabel,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.warning)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) => _onAction(context, v),
              itemBuilder: (_) => [
                if (sub.isPaused)
                  PopupMenuItem(
                      value: 'resume', child: Text(l10n.resumeLabel))
                else
                  PopupMenuItem(value: 'pause', child: Text(l10n.pauseLabel)),
                PopupMenuItem(
                    value: 'remove', child: Text(l10n.remove)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onAction(BuildContext context, String action) {
    final cubit = context.read<SubscriptionsCubit>();
    switch (action) {
      case 'pause':
        cubit.pause(sub.id);
        break;
      case 'resume':
        cubit.resume(sub.id);
        break;
      case 'remove':
        cubit.remove(sub.id);
        break;
    }
  }
}
