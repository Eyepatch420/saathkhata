import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/ledger_socket_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../memberships/domain/repositories/membership_repository.dart';
import '../../../memberships/presentation/bloc/membership_cubit.dart';
import '../../../memberships/presentation/widgets/membership_banner.dart';
import '../../../memberships/presentation/widgets/membership_appbar_chip.dart';
import '../../../vendor/domain/repositories/vendor_repository.dart';
import '../../../voice_entry/presentation/widgets/voice_entry_sheet.dart';
import '../bloc/ledger_bloc.dart';
import '../bloc/ledger_event.dart';
import '../bloc/ledger_state.dart';
import 'monthly_settlement_screen.dart';
import 'deliveries_screen.dart';
import 'link_orders_screen.dart';
import 'shared_ledger_screen/widgets/balance_header.dart';
import 'shared_ledger_screen/widgets/filter_bar.dart';
import 'shared_ledger_screen/widgets/info_row.dart';
import 'shared_ledger_screen/widgets/ledger_actions.dart';
import 'shared_ledger_screen/widgets/ledger_list.dart';

class SharedLedgerScreen extends StatefulWidget {
  final String linkId;
  final String customerName;
  final bool isVendorView;
  final bool isStaffView;

  const SharedLedgerScreen({
    super.key,
    required this.linkId,
    required this.customerName,
    this.isVendorView = true,
    this.isStaffView = false,
  });

  @override
  State<SharedLedgerScreen> createState() => _SharedLedgerScreenState();
}

class _SharedLedgerScreenState extends State<SharedLedgerScreen> {
  static const _m = 'LedgerScreen';
  late final LedgerBloc _bloc;
  late final MembershipCubit _membershipCubit;
  late final LedgerSocketService _socket;

  @override
  void initState() {
    super.initState();
    _bloc = LedgerBloc(getIt())..add(LoadLedger(widget.linkId));
    _membershipCubit = MembershipCubit(
      getIt<MembershipRepository>(),
      widget.linkId,
    )..load();
    _socket = getIt<LedgerSocketService>();
    _socket.joinLedger(widget.linkId);

    _socket.onMembershipUpdated((_) {
      AppLogger.v(_m, 'Socket membership:updated received');
      _membershipCubit.reload();
    });

    _socket.onEntryAdded((data) {
      try {
        final entry = LedgerEntry.fromJson(
          data['entry'] as Map<String, dynamic>,
        );
        AppLogger.v(_m, 'Socket entry_added received id:${entry.id}');
        _bloc.add(SocketLedgerEntryAdded(entry));
      } catch (e) {
        AppLogger.e(_m, 'Failed to parse socket entry_added', e);
      }
    });

    _socket.onEntryUpdated((data) {
      try {
        final entry = LedgerEntry.fromJson(
          data['entry'] as Map<String, dynamic>,
        );
        AppLogger.v(_m, 'Socket entry_updated received id:${entry.id}');
        _bloc.add(SocketLedgerEntryUpdated(entry));
      } catch (e) {
        AppLogger.e(_m, 'Failed to parse socket entry_updated', e);
      }
    });
  }

  @override
  void dispose() {
    _socket.leaveLedger(widget.linkId);
    _socket.off('ledger:entry_added');
    _socket.off('ledger:entry_updated');
    _socket.off('membership:updated');
    _membershipCubit.close();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _membershipCubit),
      ],
      child: SharedLedgerView(
        customerName: widget.customerName,
        linkId: widget.linkId,
        isVendorView: widget.isVendorView,
        isStaffView: widget.isStaffView,
      ),
    );
  }
}

// ─── Main View ────────────────────────────────────────────────────────────────

class SharedLedgerView extends StatefulWidget {
  final String customerName;
  final String linkId;
  final bool isVendorView;
  final bool isStaffView;

  const SharedLedgerView({
    super.key,
    required this.customerName,
    required this.linkId,
    this.isVendorView = true,
    this.isStaffView = false,
  });

  @override
  State<SharedLedgerView> createState() => _SharedLedgerViewState();
}

class _SharedLedgerViewState extends State<SharedLedgerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  void _showMonthlySettlement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LedgerBloc>(),
          child: MonthlySettlementScreen(
            customerName: widget.customerName,
            isVendorView: widget.isVendorView,
          ),
        ),
      ),
    );
  }

  void _showOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkOrdersScreen(
          linkId: widget.linkId,
          customerName: widget.customerName,
        ),
      ),
    );
  }

  void _showDeliveries(BuildContext context, String currentUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LedgerBloc>(),
          child: DeliveriesScreen(
            linkId: widget.linkId,
            customerName: widget.customerName,
            currentUserId: currentUserId,
            isVendorView: widget.isVendorView,
            isStaffView: widget.isStaffView,
          ),
        ),
      ),
    );
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
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.customerName,
              style: AppTypography.h3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    l10n.sharedLedger,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                _LiveDot(socket: getIt<LedgerSocketService>()),
              ],
            ),
          ],
        ),
        actions: [
          MembershipAppBarChip(
            role: widget.isStaffView
                ? 'staff'
                : widget.isVendorView
                ? 'vendor'
                : 'customer',
            vendorName: widget.customerName,
          ),
          IconButton(
            onPressed: () => _showDeliveries(context, currentUserId),
            icon: const Icon(Icons.local_shipping_outlined),
            tooltip: AppLocalizations.of(context)!.deliveriesTitle,
            visualDensity: VisualDensity.compact,
          ),
          if (widget.isVendorView)
            IconButton(
              onPressed: () => _showOrders(context),
              icon: const Icon(Icons.shopping_bag_outlined),
              tooltip: AppLocalizations.of(context)!.ordersTitle,
              visualDensity: VisualDensity.compact,
            ),
          if (!widget.isStaffView)
            IconButton(
              onPressed: () => _showMonthlySettlement(context),
              icon: const Icon(Icons.calendar_month_rounded),
              tooltip: AppLocalizations.of(context)!.monthlyStatementTitle,
              visualDensity: VisualDensity.compact,
            ),
          IconButton(
            onPressed: () => _confirmDeleteLink(context, l10n),
            icon: const Icon(Icons.link_off_rounded),
            tooltip: l10n.removeLedgerConfirmation,
            color: AppColors.error,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () => _showLedgerInfo(context, l10n),
            icon: const Icon(Icons.info_outline_rounded),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
      body: BlocListener<LedgerBloc, LedgerState>(
        listenWhen: (prev, curr) => curr is LedgerError,
        listener: (context, state) {
          if (state is LedgerError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
          }
        },
        child: Column(
          children: [
            // Balance + membership header (fixed)
            LedgerBalanceHeader(
              linkId: widget.linkId,
              customerName: widget.customerName,
              isVendorView: widget.isVendorView,
            ),
            // Vendor keeps the body banner (their assign/approve surface).
            // Customer & staff see membership only via the AppBar chip.
            if (widget.isVendorView && !widget.isStaffView)
              MembershipBanner(
                customerName: widget.customerName,
                isVendorView: widget.isVendorView,
                isStaffView: widget.isStaffView,
              ),
            // Filter bar (fixed)
            const LedgerFilterBar(),
            // Scrollable entry list — drives the FAB hide/show animation
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: LedgerList(
                  linkId: widget.linkId,
                  customerName: widget.customerName,
                  currentUserId: currentUserId,
                  isVendorView: widget.isVendorView,
                  isStaffView: widget.isStaffView,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: _fabAnim,
        child: ScaleTransition(
          scale: _fabScale,
          child: Builder(
            builder: (innerContext) => FloatingActionButton(
              heroTag: 'voiceEntryFab',
              backgroundColor: AppColors.primary,
              tooltip: l10n.voiceConfirmEntry,
              onPressed: () => showVoiceEntrySheet(
                innerContext,
                linkId: widget.linkId,
                isVendorView: widget.isVendorView,
                language: innerContext
                    .read<LocaleProvider>()
                    .locale
                    .languageCode,
                ledgerBloc: innerContext.read<LedgerBloc>(),
              ),
              child: const Icon(Icons.mic_rounded, color: Colors.white),
            ),
          ),
        ),
      ),
      // "Dues" is just the pending-status filter chip on this same screen —
      // it's meant to be a read-only filtered view, so hide the add-entry
      // actions while it's active instead of letting them add more entries.
      bottomNavigationBar: BlocBuilder<LedgerBloc, LedgerState>(
        buildWhen: (prev, curr) =>
            prev is LedgerLoaded &&
                curr is LedgerLoaded &&
                prev.filter.status != curr.filter.status ||
            curr is! LedgerLoaded,
        builder: (context, state) {
          final isDuesFilter =
              state is LedgerLoaded &&
              state.filter.status == EntryStatus.pending;
          if (isDuesFilter) return const SizedBox.shrink();
          return LedgerActions(
            linkId: widget.linkId,
            customerName: widget.customerName,
            isVendorView: widget.isVendorView,
          );
        },
      ),
    );
  }

  // ── Delete link ───────────────────────────────────────────────────────────

  void _confirmDeleteLink(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.removeLedgerConfirmation),
        content: Text(
          widget.isVendorView
              ? l10n.removeLedgerVendorContent(widget.customerName)
              : l10n.removeLedgerCustomerContent(widget.customerName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              try {
                if (widget.isVendorView) {
                  await getIt<VendorRepository>().deactivateLink(widget.linkId);
                } else {
                  await getIt<CustomerRepository>().deactivateLink(
                    widget.linkId,
                  );
                }
                if (context.mounted) context.pop();
              } catch (e) {
                if (context.mounted) {
                  AppToast.show(
                    context,
                    e.toString().replaceFirst('Exception: ', ''),
                    type: ToastType.error,
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.removeButtonLabel),
          ),
        ],
      ),
    );
  }

  void _showLedgerInfo(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewPadding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.ledgerInfoTitle, style: AppTypography.h3),
            const SizedBox(height: 16),
            LedgerInfoRow(
              icon: Icons.lock_rounded,
              color: AppColors.success,
              label: l10n.statusConfirmed,
              desc: l10n.statusConfirmedDesc,
            ),
            LedgerInfoRow(
              icon: Icons.access_time_rounded,
              color: AppColors.warning,
              label: l10n.statusPending,
              desc: l10n.statusPendingDesc,
            ),
            LedgerInfoRow(
              icon: Icons.warning_amber_rounded,
              color: AppColors.error,
              label: l10n.statusDisputed,
              desc: l10n.statusDisputedDesc,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Live connection indicator ────────────────────────────────────────────────

class _LiveDot extends StatefulWidget {
  final LedgerSocketService socket;
  const _LiveDot({required this.socket});

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  late bool _isLive;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _isLive = widget.socket.isConnected;

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _sub = widget.socket.connectionStream.listen((connected) {
      if (mounted) setState(() => _isLive = connected);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLive) {
      return Tooltip(
        message: AppLocalizations.of(context)!.offlineUpdatesPaused,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.textHint,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Tooltip(
      message: AppLocalizations.of(context)!.liveUpdatesOn,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
