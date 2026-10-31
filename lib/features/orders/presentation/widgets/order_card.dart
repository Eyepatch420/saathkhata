import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/order_model.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../screens/order_detail_screen.dart';

/// Order summary card shared by the vendor-wide orders list and the
/// per-customer orders view on the shared ledger screen.
class OrderCard extends StatelessWidget {
  final Order order;
  final bool isVendor;

  const OrderCard({super.key, required this.order, required this.isVendor});

  Color _statusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.warning,
    OrderStatus.confirmed => Colors.blue,
    OrderStatus.delivered => AppColors.success,
    OrderStatus.rejected => AppColors.error,
    OrderStatus.cancelled => AppColors.textSecondary,
  };

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<OrderBloc>(),
          child: OrderDetailScreen(order: order, role: 'vendor'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName ?? l10n.customer,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.orderStatusName(order.status),
                      style: TextStyle(
                        color: _statusColor(order.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...order.items
                  .take(3)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.qty != null)
                            Text(
                              '${item.qty}${item.unit != null ? ' ${item.unit}' : ''}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              if (order.items.length > 3)
                Text(
                  l10n.moreItemsCount(order.items.length - 3),
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.orderTotalAmount(order.total.toStringAsFixed(0)),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (isVendor && order.status == OrderStatus.pending) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.read<OrderBloc>().add(
                          UpdateOrderStatus(
                            orderId: order.id,
                            status: OrderStatus.rejected,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: Builder(
                          builder: (ctx) =>
                              Text(AppLocalizations.of(ctx)!.rejectButton),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.read<OrderBloc>().add(
                          UpdateOrderStatus(
                            orderId: order.id,
                            status: OrderStatus.confirmed,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Builder(
                          builder: (ctx) =>
                              Text(AppLocalizations.of(ctx)!.confirmButton),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (isVendor && order.status == OrderStatus.confirmed) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    // Route through detail so vendor self-delivery gets the
                    // confirmation + optional proof (note/photo) flow.
                    onPressed: () => _openDetail(context),
                    icon: const Icon(Icons.local_shipping_outlined, size: 18),
                    label: Builder(
                      builder: (ctx) =>
                          Text(AppLocalizations.of(ctx)!.markDeliveredButton),
                    ),
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
