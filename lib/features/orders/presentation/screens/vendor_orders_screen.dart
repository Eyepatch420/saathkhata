import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/order_model.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_card.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  static const _statuses = ['all', 'pending', 'confirmed', 'delivered'];
  static const _labels = ['All', 'Pending', 'Confirmed', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _statuses.length, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        final s = _statuses[_tabs.index];
        context.read<OrderBloc>().add(
          LoadVendorOrders(statusFilter: s == 'all' ? null : s),
        );
      }
    });
    context.read<OrderBloc>().add(const LoadVendorOrders());
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ordersTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
        ),
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
              final s = _statuses[_tabs.index];
              context.read<OrderBloc>().add(
                LoadVendorOrders(statusFilter: s == 'all' ? null : s),
              );
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
    );
  }
}
