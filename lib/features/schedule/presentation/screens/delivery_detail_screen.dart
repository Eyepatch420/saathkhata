import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart';
import '../cubit/schedule_cubit.dart';
import 'confirm_delivery_screen.dart';

/// Full detail view for a single [ScheduledDelivery]. Shared by the staff
/// "Today's Deliveries" list and the vendor/customer "My Subscriptions >
/// Deliveries" tab — [showActions] controls whether the Deliver/Skip buttons
/// are shown (only meaningful for the vendor/staff side, on a delivery that's
/// still scheduled and due).
class DeliveryDetailScreen extends StatelessWidget {
  final ScheduledDelivery delivery;
  final bool showActions;

  const DeliveryDetailScreen({
    super.key,
    required this.delivery,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isScheduled = delivery.status == DeliveryStatus.scheduled;
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deliveryDetailsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(delivery.serviceName, style: AppTypography.h2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Section(
              title: l10n.customer,
              children: [
                _DetailRow(
                  icon: Icons.person_outline,
                  label: delivery.customerName,
                ),
                if (delivery.customerPhone != null)
                  _DetailRow(
                    icon: Icons.call_outlined,
                    label: delivery.customerPhone!,
                    onTap: () => _launch(
                      Uri(scheme: 'tel', path: delivery.customerPhone),
                    ),
                  ),
                if (delivery.customerAddress != null)
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: delivery.customerAddress!,
                    onTap: () => _launch(
                      Uri.https('www.google.com', '/maps/search/', {
                        'api': '1',
                        'query':
                            delivery.customerLatitude != null &&
                                delivery.customerLongitude != null
                            ? '${delivery.customerLatitude},${delivery.customerLongitude}'
                            : delivery.customerAddress!,
                      }),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _Section(
              title: l10n.deliveryLabel,
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: DateFormat(
                    'EEE, d MMM yyyy',
                  ).format(delivery.scheduledDate),
                ),
                if (delivery.deliveryTime != null)
                  _DetailRow(
                    icon: Icons.schedule_rounded,
                    label: l10n.deliveryDueAt(delivery.deliveryTime!),
                  ),
                for (final item in delivery.items.where((i) => i.quantity > 0))
                  _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label:
                        '${item.name}: ${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1)} ${item.unit}',
                  ),
                if (delivery.totalAmount > 0)
                  _DetailRow(
                    icon: Icons.currency_rupee_rounded,
                    label: '₹${delivery.totalAmount.toStringAsFixed(2)}',
                  ),
                if (delivery.deliveredAt != null)
                  _DetailRow(
                    icon: Icons.check_circle_outline,
                    label: l10n.deliveryDeliveredAt(
                      DateFormat('d MMM, h:mm a').format(delivery.deliveredAt!),
                    ),
                  ),
                if (delivery.deliveredByName != null)
                  _DetailRow(
                    icon: Icons.badge_outlined,
                    label: l10n.deliveryDeliveredBy(delivery.deliveredByName!),
                  ),
                if (delivery.notes != null && delivery.notes!.isNotEmpty)
                  _DetailRow(icon: Icons.notes_rounded, label: delivery.notes!),
              ],
            ),
            if (delivery.photoUrl != null) ...[
              const SizedBox(height: 20),
              _Section(
                title: l10n.deliveryPhotoTitle,
                children: [
                  LedgerAttachmentSection(
                    attachmentUrl: delivery.photoUrl,
                    isLocked: true,
                    heroTag: 'delivery_photo_${delivery.id}',
                  ),
                ],
              ),
            ],
            if (showActions && isScheduled && !isUpcoming) ...[
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _skip(context),
                      icon: const Icon(Icons.skip_next, size: 16),
                      label: Text(l10n.skip),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _deliver(context),
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(l10n.deliveryStatusDelivered),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
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

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _deliver(BuildContext context) {
    final cubit = context.read<DeliveriesCubit>();
    Navigator.pushReplacement(
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
              Navigator.pop(context);
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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _DetailRow({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: onTap != null
                    ? AppColors.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: onTap != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: row,
    );
  }
}
