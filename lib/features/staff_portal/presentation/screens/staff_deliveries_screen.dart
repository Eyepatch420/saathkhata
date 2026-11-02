import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../schedule/domain/models/delivery_filter.dart';
import '../../../schedule/presentation/cubit/schedule_cubit.dart';
import '../../../schedule/presentation/widgets/delivery_card.dart';
import '../../../schedule/presentation/widgets/delivery_filter_bar.dart';
import '../../../../shared/models/schedule_model.dart';

/// Today's deliveries for the vendor, as seen by a staff (delivery) member.
/// Reuses [DeliveriesCubit] scoped to the owner vendor via effectiveVendorId
/// on the backend, and the same [DeliveryCard] the vendor's Schedule tab uses.
class StaffDeliveriesScreen extends StatefulWidget {
  const StaffDeliveriesScreen({super.key});

  @override
  State<StaffDeliveriesScreen> createState() => _StaffDeliveriesScreenState();
}

class _StaffDeliveriesScreenState extends State<StaffDeliveriesScreen> {
  DeliveryFilter _filter = const DeliveryFilter();

  void _applyFilter(DeliveryFilter filter) {
    setState(() => _filter = filter);
    context.read<DeliveriesCubit>().load(
      status: filter.status?.name,
      date: filter.date?.toIso8601String().split('T').first,
    );
  }

  List<ScheduledDelivery> _filtered(List<ScheduledDelivery> deliveries) {
    var result = deliveries;
    final q = _filter.nameQuery?.toLowerCase();
    if (q != null && q.isNotEmpty) {
      result = result
          .where(
            (d) =>
                d.customerName.toLowerCase().contains(q) ||
                d.serviceName.toLowerCase().contains(q),
          )
          .toList();
    }
    if (_filter.radiusKm != null &&
        _filter.centerLat != null &&
        _filter.centerLng != null) {
      result = result.where((d) {
        if (d.customerLatitude == null || d.customerLongitude == null) {
          return false;
        }
        final distanceMeters = Geolocator.distanceBetween(
          _filter.centerLat!,
          _filter.centerLng!,
          d.customerLatitude!,
          d.customerLongitude!,
        );
        return distanceMeters <= _filter.radiusKm! * 1000;
      }).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.todaysDeliveriesTab)),
      body: SafeArea(
        child: Column(
          children: [
            DeliveryFilterBar(filter: _filter, onChanged: _applyFilter),
            Expanded(
              child: BlocConsumer<DeliveriesCubit, DeliveriesState>(
                listenWhen: (prev, curr) =>
                    curr is DeliveriesLoaded && curr.actionError != null,
                listener: (context, state) {
                  if (state is DeliveriesLoaded && state.actionError != null) {
                    AppToast.show(
                      context,
                      state.actionError!,
                      type: ToastType.error,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is DeliveriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DeliveriesError) {
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
                            onPressed: () =>
                                context.read<DeliveriesCubit>().load(),
                            child: Text(l10n.retryButton),
                          ),
                        ],
                      ),
                    );
                  }
                  final deliveries = _filtered(
                    (state as DeliveriesLoaded).deliveries,
                  );
                  if (deliveries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _filter.isEmpty
                                ? l10n.noDeliveriesToday
                                : l10n.noDeliveriesMatchFilters,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<DeliveriesCubit>().load(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: deliveries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) =>
                          DeliveryCard(delivery: deliveries[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
