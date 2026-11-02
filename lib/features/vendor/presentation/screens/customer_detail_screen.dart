import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/ledger_socket_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/models/link_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../memberships/domain/repositories/membership_repository.dart';
import '../../../memberships/presentation/bloc/membership_cubit.dart';
import '../../../memberships/presentation/widgets/membership_banner.dart';
import '../../../memberships/presentation/widgets/membership_plan_badge.dart';
import '../../../shared_ledger/presentation/bloc/ledger_bloc.dart';
import '../../../shared_ledger/presentation/bloc/ledger_event.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/balance_header.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/filter_bar.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_actions.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/ledger_list.dart';
import '../../../shared_ledger/presentation/screens/monthly_settlement_screen.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/screens/place_order_screen.dart';
import '../../../orders/domain/repositories/order_repository.dart';
import '../bloc/vendor_bloc.dart';
import '../bloc/vendor_event.dart';
import '../widgets/customer_defaults_sheet.dart';


class CustomerDetailScreen extends StatefulWidget {
  final CustomerLinkItem customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  static const _m = 'CustomerDetail';

  late final LedgerBloc _bloc;
  late final MembershipCubit _membershipCubit;
  late final LedgerSocketService _socket;
  late final TabController _tabController;

  // Mutable local copy so the Info tab can update immediately after save.
  late CustomerLinkItem _customer;

  bool _showDeliveryTab = false;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    _bloc = LedgerBloc(getIt())..add(LoadLedger(widget.customer.linkId));
    _membershipCubit =
        MembershipCubit(getIt<MembershipRepository>(), widget.customer.linkId)
          ..load();
    _socket = getIt<LedgerSocketService>();
    _socket.joinLedger(widget.customer.linkId);

    _socket.onEntryAdded((data) {
      try {
        final entry =
            LedgerEntry.fromJson(data['entry'] as Map<String, dynamic>);
        _bloc.add(SocketLedgerEntryAdded(entry));
      } catch (e) {
        AppLogger.e(_m, 'Socket entry_added parse failed', e);
      }
    });

    _socket.onEntryUpdated((data) {
      try {
        final entry =
            LedgerEntry.fromJson(data['entry'] as Map<String, dynamic>);
        _bloc.add(SocketLedgerEntryUpdated(entry));
      } catch (e) {
        AppLogger.e(_m, 'Socket entry_updated parse failed', e);
      }
    });

    _socket.onMembershipUpdated((_) => _membershipCubit.reload());

    // Always show the Deliveries tab — it's the consolidated view of orders
    // delivered to this customer (separate from in-person ledger entries).
    _showDeliveryTab = true;

    final tabCount = _showDeliveryTab ? 4 : 3;
    _tabController = TabController(length: tabCount, vsync: this);
  }

  void _onDefaultsSaved({
    required String? product,
    required String? unit,
    required double? qty,
    required double? price,
  }) {
    setState(() {
      _customer = _customer.copyWith(
        defaultProduct: product,
        defaultUnit: unit,
        defaultQty: qty,
        defaultPricePerUnit: price,
        clearDefaultProduct: product == null,
        clearDefaultUnit: unit == null,
        clearDefaultQty: qty == null,
        clearDefaultPrice: price == null,
      );
    });
    // Keep the global customer list in sync.
    context.read<VendorBloc>().add(LoadVendorDashboard());
  }

  @override
  void dispose() {
    _socket.leaveLedger(widget.customer.linkId);
    _socket.off('ledger:entry_added');
    _socket.off('ledger:entry_updated');
    _socket.off('membership:updated');
    _membershipCubit.close();
    _bloc.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _membershipCubit),
      ],
      child: _CustomerDetailView(
        customer: _customer,
        tabController: _tabController,
        showDeliveryTab: _showDeliveryTab,
        onDefaultsSaved: _onDefaultsSaved,
      ),
    );
  }
}

class _CustomerDetailView extends StatelessWidget {
  final CustomerLinkItem customer;
  final TabController tabController;
  final bool showDeliveryTab;
  final void Function({
    required String? product,
    required String? unit,
    required double? qty,
    required double? price,
  }) onDefaultsSaved;

  const _CustomerDetailView({
    required this.customer,
    required this.tabController,
    required this.showDeliveryTab,
    required this.onDefaultsSaved,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : '';

    final tabs = [
      Tab(text: l10n.historyTab),
      Tab(text: l10n.duesTab),
      if (showDeliveryTab) Tab(text: l10n.deliveryLabel),
      Tab(text: l10n.infoTab),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.displayName, style: AppTypography.h3),
                  if (customer.subName != null)
                    Text(customer.subName!,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (customer.tierName != null) ...[
              const SizedBox(width: 8),
              MembershipPlanBadge(name: customer.tierName!),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_outlined),
            tooltip: l10n.newOrderForCustomerTooltip,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => OrderBloc(getIt<OrderRepository>()),
                  child: PlaceOrderForCustomerScreen(
                    linkId: customer.linkId,
                    customerName: customer.displayName,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
          labelStyle: AppTypography.labelLarge.copyWith(fontSize: 13),
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // History tab — full ledger list with actions
          _HistoryTab(
            customer: customer,
            currentUserId: currentUserId,
          ),
          // Dues tab — pending entries only + summary
          _DuesTab(
            customer: customer,
            currentUserId: currentUserId,
          ),
          // Delivery tab (only for dairy/tiffin/etc vendors)
          if (showDeliveryTab)
            _DeliveryTab(customer: customer, currentUserId: currentUserId),
          // Info tab — customer details + set defaults
          _InfoTab(customer: customer, onDefaultsSaved: onDefaultsSaved),
        ],
      ),
    );
  }
}

// ─── History Tab ──────────────────────────────────────────────────────────────

class _HistoryTab extends StatelessWidget {
  final CustomerLinkItem customer;
  final String currentUserId;

  const _HistoryTab({required this.customer, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LedgerBalanceHeader(
          linkId: customer.linkId,
          customerName: customer.displayName,
          isVendorView: true,
        ),
        MembershipBanner(
          customerName: customer.displayName,
          isVendorView: true,
        ),
        const LedgerFilterBar(),
        Expanded(
          child: LedgerList(
            linkId: customer.linkId,
            customerName: customer.displayName,
            currentUserId: currentUserId,
            isVendorView: true,
          ),
        ),
        LedgerActions(
          linkId: customer.linkId,
          customerName: customer.displayName,
          isVendorView: true,
        ),
      ],
    );
  }
}

// ─── Dues Tab ─────────────────────────────────────────────────────────────────

class _DuesTab extends StatelessWidget {
  final CustomerLinkItem customer;
  final String currentUserId;

  const _DuesTab({required this.customer, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        LedgerBalanceHeader(
          linkId: customer.linkId,
          customerName: customer.displayName,
          isVendorView: true,
        ),
        Expanded(
          child: LedgerList(
            linkId: customer.linkId,
            customerName: customer.displayName,
            currentUserId: currentUserId,
            isVendorView: true,
            filterStatus: EntryStatus.pending,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<LedgerBloc>(),
                    child: MonthlySettlementScreen(
                      customerName: customer.displayName,
                      isVendorView: true,
                    ),
                  ),
                ),
              ),
              icon: const Icon(Icons.calendar_month_rounded, size: 16),
              label: Text(l10n.viewMonthlyStatement),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Delivery Tab ─────────────────────────────────────────────────────────────

class _DeliveryTab extends StatelessWidget {
  final CustomerLinkItem customer;
  final String currentUserId;

  const _DeliveryTab({required this.customer, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DeliveriesHeader(),
        Expanded(
          child: LedgerList(
            linkId: customer.linkId,
            customerName: customer.displayName,
            currentUserId: currentUserId,
            isVendorView: true,
            filterDeliveriesOnly: true,
          ),
        ),
        LedgerActions(
          linkId: customer.linkId,
          customerName: customer.displayName,
          isVendorView: true,
        ),
      ],
    );
  }
}

/// Small banner explaining the deliveries view — shown above the filtered list.
class _DeliveriesHeader extends StatelessWidget {
  const _DeliveriesHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_rounded,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.customerDeliveriesHint,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Tab ─────────────────────────────────────────────────────────────────

class _InfoTab extends StatelessWidget {
  final CustomerLinkItem customer;
  final void Function({
    required String? product,
    required String? unit,
    required double? qty,
    required double? price,
  }) onDefaultsSaved;

  const _InfoTab({required this.customer, required this.onDefaultsSaved});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = customer.customer;
    final hasDefaults = customer.defaultProduct != null;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoSection(
          title: l10n.customer,
          children: [
            _InfoRow(l10n.nameLabel, c.name),
            if (c.mobile != null)
              _InfoRow(l10n.mobileNumber, c.mobile!),
            if (customer.nickname != null)
              _InfoRow(l10n.yourNicknameLabel, customer.nickname!),
            _InfoRow(
                l10n.linkedSinceLabel, _formatDate(customer.createdAt)),
          ],
        ),
        const SizedBox(height: 20),
        _InfoSection(
          title: l10n.defaultDeliveryTitle,
          trailing: TextButton(
            onPressed: () => _showDefaultsSheet(context),
            child: Text(hasDefaults ? l10n.editLabel : l10n.setButton),
          ),
          children: hasDefaults
              ? [
                  if (customer.defaultProduct != null)
                    _InfoRow(l10n.productLabel, customer.defaultProduct!),
                  if (customer.defaultQty != null)
                    _InfoRow(
                        l10n.qty,
                        '${customer.defaultQty!.toStringAsFixed(customer.defaultQty! % 1 == 0 ? 0 : 2)}'
                        ' ${customer.defaultUnit ?? ''}'),
                  if (customer.defaultPricePerUnit != null)
                    _InfoRow(l10n.pricePerUnitShort,
                        '₹${customer.defaultPricePerUnit!.toStringAsFixed(2)}'),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      l10n.noDefaultDeliveryHint,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textHint),
                    ),
                  ),
                ],
        ),
        if (customer.tierName != null) ...[
          const SizedBox(height: 20),
          _InfoSection(
            title: l10n.membership,
            children: [
              _InfoRow(l10n.tierLabel, customer.tierName!),
            ],
          ),
        ],
      ],
    );
  }

  void _showDefaultsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CustomerDefaultsSheet(
        customer: customer,
        onSaved: onDefaultsSaved,
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('d MMM yyyy').format(dt);
    } catch (_) {
      return iso;
    }
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const _InfoSection({
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.textSecondary)),
              if (trailing != null) trailing as Widget,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textHint)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}
