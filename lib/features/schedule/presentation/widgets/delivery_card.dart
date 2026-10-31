import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart';
import '../cubit/schedule_cubit.dart';
import '../screens/confirm_delivery_screen.dart';
import '../screens/delivery_detail_screen.dart';

/// Delivery card shared by the vendor and staff "today's deliveries" views.
/// Shows the customer's contact details so whoever is delivering can call or
/// navigate to the address without leaving the app.
class DeliveryCard extends StatelessWidget {
  final ScheduledDelivery delivery;
  const DeliveryCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isScheduled = delivery.status == DeliveryStatus.scheduled;
    // "Upcoming" = scheduled but not due yet per the service's delivery_time
    // (e.g. a 6pm delivery seen at 9am) — shown as pending, not actionable,
    // so it's never confused with a delivery that's actually due right now.
    final isUpcoming = isScheduled && !delivery.isDue;
    final statusColor = switch (delivery.status) {
      DeliveryStatus.scheduled =>
        isUpcoming ? AppColors.textHint : AppColors.warning,
      DeliveryStatus.delivered => AppColors.success,
      DeliveryStatus.skipped => AppColors.textSecondary,
      DeliveryStatus.failed => AppColors.error,
    };
    final statusLabel = isUpcoming
        ? l10n.upcoming
        : l10n.deliveryStatusName(delivery.status);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      delivery.serviceName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                delivery.customerName,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                delivery.itemsSummary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
              if (delivery.customerAddress != null ||
                  delivery.customerPhone != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (delivery.customerPhone != null)
                      _ContactChip(
                        icon: Icons.call_outlined,
                        label: l10n.callLabel,
                        onTap: () => _launch(
                          Uri(scheme: 'tel', path: delivery.customerPhone),
                        ),
                      ),
                    if (delivery.customerPhone != null &&
                        delivery.customerAddress != null)
                      const SizedBox(width: 8),
                    if (delivery.customerAddress != null)
                      Expanded(
                        child: _ContactChip(
                          icon: Icons.location_on_outlined,
                          label: delivery.customerAddress!,
                          onTap: () => _launch(
                            Uri.https('www.google.com', '/maps/search/', {
                              'api': '1',
                              'query': delivery.customerAddress!,
                            }),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              if (isScheduled && isUpcoming) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.deliveryDueAt(delivery.deliveryTime ?? ''),
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              if (delivery.photoUrl != null) ...[
                const SizedBox(height: 8),
                LedgerAttachmentSection(
                  attachmentUrl: delivery.photoUrl,
                  isLocked: true,
                  heroTag: 'delivery_photo_card_${delivery.id}',
                ),
              ],
              if (isScheduled && !isUpcoming) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _skip(context),
                        icon: const Icon(Icons.skip_next, size: 16),
                        label: Text(l10n.skip),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _deliver(context),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(l10n.deliveryStatusDelivered),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    final cubit = context.read<DeliveriesCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: DeliveryDetailScreen(delivery: delivery, showActions: true),
        ),
      ),
    );
  }

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _deliver(BuildContext context) {
    final cubit = context.read<DeliveriesCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: ConfirmDeliveryScreen(delivery: delivery),
        ),
      ),
    );
  }

  void _skip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.skipDeliveryTitle),
        content: Text(l10n.skipDeliveryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DeliveriesCubit>().skip(delivery.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.skip,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
