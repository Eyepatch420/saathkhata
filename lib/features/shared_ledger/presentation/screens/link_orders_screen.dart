import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/order_model.dart';
import '../../../orders/domain/repositories/order_repository.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../../../orders/presentation/widgets/order_card.dart';

/// Orders placed by this specific customer through this vendor link only —
/// distinct from the vendor-wide Orders screen and from the Delivery tab
/// (which shows schedule/subscription deliveries, not order-based ones).
class LinkOrdersScreen extends StatelessWidget {
  final String linkId;
  final String customerName;

  const LinkOrdersScreen({
    super.key,
    required this.linkId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderBloc(getIt<OrderRepository>())
            ..add(LoadVendorOrders(linkId: linkId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.ordersTitle),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderError) {
              return Center(child: Text(state.message));
            }
            final orders = switch (state) {
              OrderLoaded(orders: final o) => o,
              OrderActionLoading(orders: final o) => o,
              _ => <Order>[],
            };
            if (orders.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noOrdersYet),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderBloc>().add(LoadVendorOrders(linkId: linkId));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, i) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) =>
                    OrderCard(order: orders[i], isVendor: true),
              ),
            );
          },
        ),
      ),
    );
  }
}
