import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/models/delivery_filter.dart';
import '../cubit/schedule_cubit.dart';
import '../widgets/delivery_card.dart';
import '../widgets/delivery_filter_bar.dart';
import 'create_service_sheet.dart';
import 'service_detail_screen.dart';

class VendorServicesScreen extends StatefulWidget {
  const VendorServicesScreen({super.key});

  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen>
    with TickerProviderStateMixin {
  late TabController _tabs;
  int _tabIndex = 0;

  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  late final Animation<double> _fabOpacity;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.index != _tabIndex) setState(() => _tabIndex = _tabs.index);
    });
    context.read<ServicesCubit>().load();
    context.read<DeliveriesCubit>().load();

    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
    _fabOpacity = _fabAnim;
  }

  @override
  void dispose() {
    _tabs.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _fabVisible) {
        _fabVisible = false;
        _fabAnim.reverse();
      } else if (delta < 0 && !_fabVisible) {
        _fabVisible = true;
        _fabAnim.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scheduledServicesTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.servicesTab),
            Tab(text: l10n.todaysDeliveriesTab),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: TabBarView(
          controller: _tabs,
          children: const [_ServicesTab(), _DeliveriesTab()],
        ),
      ),
      // "New Service" only makes sense on the Services tab. Shell uses
      // extendBody, so padding.bottom carries the pill nav height — lift the
      // FAB above it like the dashboard FAB, and fade/scale it out on scroll.
      floatingActionButton: _tabIndex != 0
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: FadeTransition(
                opacity: _fabOpacity,
                child: ScaleTransition(
                  scale: _fabScale,
                  child: BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, state) {
                      return FloatingActionButton.extended(
                        onPressed: () => _showCreateSheet(context),
                        backgroundColor: AppColors.primary,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(
                          l10n.newService,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    final cubit = context.read<ServicesCubit>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const CreateServiceSheet()),
    );
  }
}

class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ServicesError) {
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
                  onPressed: () => context.read<ServicesCubit>().load(),
                  child: Text(l10n.retryButton),
                ),
              ],
            ),
          );
        }
        final services = (state as ServicesLoaded).services;
        if (services.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.noServicesYet,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tapPlusToCreateService,
                  style: const TextStyle(color: AppColors.textHint, fontSize: 13),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<ServicesCubit>().load(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: services.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _ServiceCard(service: services[i]),
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ScheduledService service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ServicesCubit>()),
                BlocProvider.value(value: context.read<SubscriptionsCubit>()),
              ],
              child: ServiceDetailScreen(service: service),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _TypeIcon(type: service.serviceType),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.serviceScheduleName(service),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    if (service.items.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        service.itemsSummary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.subscriberCountLabel(service.subscriberCount),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!service.isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l10n.inactive,
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final ServiceType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final icon = type == ServiceType.product
        ? Icons.inventory_2_outlined
        : Icons.event_available_outlined;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}

class _DeliveriesTab extends StatefulWidget {
  const _DeliveriesTab();

  @override
  State<_DeliveriesTab> createState() => _DeliveriesTabState();
}

class _DeliveriesTabState extends State<_DeliveriesTab> {
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
    return Column(
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
                        onPressed: () => context.read<DeliveriesCubit>().load(),
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
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<DeliveriesCubit>().load(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
    );
  }
}
