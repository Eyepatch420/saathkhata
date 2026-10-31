import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../cubit/schedule_cubit.dart';
import 'delivery_detail_screen.dart';

class CustomerSubscriptionsScreen extends StatefulWidget {
  const CustomerSubscriptionsScreen({super.key});

  @override
  State<CustomerSubscriptionsScreen> createState() =>
      _CustomerSubscriptionsScreenState();
}

class _CustomerSubscriptionsScreenState
    extends State<CustomerSubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    context.read<MySubscriptionsCubit>().load();
    context.read<DeliveriesCubit>().load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mySubscriptionsTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.active),
            Tab(text: l10n.deliveriesTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_ActiveSubsTab(), _MyDeliveriesTab()],
      ),
    );
  }
}

class _ActiveSubsTab extends StatelessWidget {
  const _ActiveSubsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MySubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        if (state is SubscriptionsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SubscriptionsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<MySubscriptionsCubit>().load(),
                  child: Text(l10n.retryButton),
                ),
              ],
            ),
          );
        }
        final subs = (state as SubscriptionsLoaded).subscriptions;
        if (subs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.subscriptions_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.noActiveSubscriptions,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<MySubscriptionsCubit>().load(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: subs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _SubCard(sub: subs[i]),
          ),
        );
      },
    );
  }
}

class _SubCard extends StatelessWidget {
  final ServiceSubscription sub;
  const _SubCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat('d MMM');
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    sub.serviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (sub.isPaused)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.pausedLabel,
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              sub.vendorName,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subscriptionItemsAmount(
                sub.itemsSummary,
                sub.totalAmount.toStringAsFixed(0),
              ),
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
            if (sub.nextDeliveryDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.subscriptionNextDelivery(
                      fmt.format(sub.nextDeliveryDate!),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MyDeliveriesTab extends StatelessWidget {
  const _MyDeliveriesTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DeliveriesCubit, DeliveriesState>(
      builder: (context, state) {
        if (state is DeliveriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DeliveriesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }
        final deliveries = (state as DeliveriesLoaded).deliveries;
        if (deliveries.isEmpty) {
          return Center(
            child: Text(
              l10n.noDeliveriesYet,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<DeliveriesCubit>().load(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: deliveries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _DeliveryTile(delivery: deliveries[i]),
          ),
        );
      },
    );
  }
}

class _DeliveryTile extends StatelessWidget {
  final ScheduledDelivery delivery;
  const _DeliveryTile({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat('d MMM');
    final statusColor = switch (delivery.status) {
      DeliveryStatus.scheduled => AppColors.warning,
      DeliveryStatus.delivered => AppColors.success,
      DeliveryStatus.skipped => AppColors.textSecondary,
      DeliveryStatus.failed => AppColors.error,
    };
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeliveryDetailScreen(delivery: delivery),
          ),
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            delivery.status == DeliveryStatus.delivered
                ? Icons.check_circle_outline
                : delivery.status == DeliveryStatus.skipped
                ? Icons.skip_next
                : Icons.schedule,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          delivery.serviceName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          l10n.subscriptionDeliverySubtitle(
            fmt.format(delivery.scheduledDate),
            delivery.itemsSummary,
          ),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            l10n.deliveryStatusName(delivery.status),
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
