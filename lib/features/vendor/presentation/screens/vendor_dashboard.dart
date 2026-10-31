import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../link_requests/domain/models/link_request_model.dart';
import '../../../link_requests/domain/repositories/link_request_repository.dart';
import '../bloc/vendor_bloc.dart';
import '../bloc/vendor_event.dart';
import '../bloc/vendor_state.dart';
import '../widgets/stat_card.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/search_bar_pill.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_state.dart';
import '../../../search/presentation/screens/vendor_search_screen.dart';
import '../../../memberships/presentation/widgets/membership_plan_badge.dart';
import '../../../../shared/models/link_model.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) => const VendorDashboardView();
}

class VendorDashboardView extends StatelessWidget {
  const VendorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appTitle, style: AppTypography.h3),
            Text(
              l10n.vendorDashboard,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            bloc: getIt<NotificationBloc>(),
            builder: (context, state) {
              final count = state is NotificationLoaded ? state.unreadCount : 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () => context.push(AppRouter.notifications),
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _NotifBadge(count: count),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<VendorBloc, VendorState>(
          listenWhen: (prev, curr) {
            if (prev is VendorLoaded && curr is VendorLoaded) {
              return prev.remindAllStatus != curr.remindAllStatus &&
                  curr.remindAllStatus != RemindAllStatus.loading;
            }
            return false;
          },
          listener: (context, state) {
            if (state is VendorLoaded) {
              if (state.remindAllStatus == RemindAllStatus.success) {
                final count = state.remindAllQueued;
                AppToast.show(
                  context,
                  count == 0
                      ? l10n.remindersNoOutstanding
                      : l10n.remindersSentTo(count),
                  type: ToastType.success,
                );
              } else if (state.remindAllStatus == RemindAllStatus.failure) {
                AppToast.show(
                  context,
                  l10n.remindersFailed,
                  type: ToastType.error,
                );
              }
            }
          },
          builder: (context, state) {
            if (state is VendorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VendorLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<VendorBloc>().add(LoadVendorDashboard());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchBarPill(viewAs: SearchViewAs.vendor),
                      const SizedBox(height: 24),
                      Text(l10n.collectionSummary, style: AppTypography.h3),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: l10n.outstanding,
                              value:
                                  '₹${state.totalOutstanding.toStringAsFixed(0)}',
                              color: AppColors.error,
                              icon: Icons.account_balance_wallet_rounded,
                              onTap: () =>
                                  context.push(AppRouter.outstandingList),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: l10n.collectedToday,
                              value:
                                  '₹${state.todayCollection.toStringAsFixed(0)}',
                              color: AppColors.success,
                              icon: Icons.payments_rounded,
                              onTap: () =>
                                  context.push(AppRouter.collectedToday),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.quickActions, style: AppTypography.h3),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.notifications_active_rounded,
                              label: l10n.remindAll,
                              subtitle: l10n.notifyCustomersWithDues,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C896), Color(0xFF00A878)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              isLoading:
                                  state.remindAllStatus ==
                                  RemindAllStatus.loading,
                              onTap: () => context.read<VendorBloc>().add(
                                RemindAllRequested(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.person_add_rounded,
                              label: l10n.addNew,
                              subtitle: l10n.linkANewCustomer,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A3A4A), Color(0xFF0F2027)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              isLoading: false,
                              onTap: () => showVendorAddCustomerSheet(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.bolt_rounded,
                        label: l10n.dailyCharge,
                        subtitle: l10n.dailyChargeSubtitle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B2FF7), Color(0xFF4A00E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        isLoading: false,
                        onTap: () => context.push(AppRouter.bulkCharge),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.shopping_bag_outlined,
                        label: l10n.ordersTitle,
                        subtitle: l10n.ordersSubtitle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFE84A1A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        isLoading: false,
                        onTap: () => context.push(AppRouter.vendorOrders),
                      ),
                      const SizedBox(height: 24),
                      _PendingRequestsSection(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.recentCustomers, style: AppTypography.h3),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRouter.allCustomers),
                            child: Text(l10n.viewAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.customers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final customer = state.customers[index];
                          return _CustomerTile(customer: customer);
                        },
                      ),
                      if (state.myVendors.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text(l10n.myVendorsSection, style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text(
                          l10n.shopsYouBuyFrom,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.myVendors.length,
                          separatorBuilder: (context, i) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _VendorTile(item: state.myVendors[index]),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is VendorError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}

// ─── Add Customer Bottom Sheet ────────────────────────────────────────────────

void showVendorAddCustomerSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final identifierCtrl = TextEditingController();
  final nicknameCtrl = TextEditingController();
  bool isLoading = false;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          // viewInsets clears the keyboard; viewPadding clears the gesture
          // bar / 3-button nav when the keyboard is closed.
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.addNewCustomer, style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              l10n.findByPhoneOrEmailHint,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: identifierCtrl,
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.phoneOrEmailLabel,
                hintText: l10n.phoneMobileOrEmail,
                prefixIcon: const Icon(Icons.person_search_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nicknameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.nicknameOptionalLabel,
                hintText: l10n.howYouKnowCustomer,
                prefixIcon: const Icon(Icons.label_outline_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final identifier = identifierCtrl.text.trim();
                        if (identifier.isEmpty) return;
                        final nickname = nicknameCtrl.text.trim();
                        setSheetState(() => isLoading = true);
                        try {
                          await getIt<LinkRequestRepository>()
                              .vendorSendRequest(
                                customerIdentifier: identifier,
                                nickname: nickname.isEmpty ? null : nickname,
                              );
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            AppToast.show(
                              context,
                              l10n.requestSentWillBeNotified,
                              type: ToastType.success,
                            );
                          }
                        } catch (e) {
                          setSheetState(() => isLoading = false);
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              e.toString().replaceFirst('Exception: ', ''),
                              type: ToastType.error,
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.addCustomer,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Action Card ──────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(icon, color: Colors.white, size: 22),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Customer Tile ────────────────────────────────────────────────────────────

class _CustomerTile extends StatelessWidget {
  final CustomerLinkItem customer;

  const _CustomerTile({required this.customer});

  @override
  Widget build(BuildContext context) {
    final displayName = customer.displayName;
    final subName = customer.subName;
    final surface = Theme.of(context).colorScheme.surface;
    return InkWell(
      onTap: () => context.push(AppRouter.customerDetail, extra: customer),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: AppTypography.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (customer.tierName != null) ...[
                        const SizedBox(width: 8),
                        MembershipPlanBadge(name: customer.tierName!),
                      ],
                    ],
                  ),
                  if (subName != null)
                    Text(
                      subName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${customer.balance.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Vendor Tile (shops where this vendor is the customer) ───────────────────

class _VendorTile extends StatelessWidget {
  final VendorLinkItem item;

  const _VendorTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final displayName = item.displayName;
    final subName = item.subName;
    final surface = Theme.of(context).colorScheme.surface;
    return InkWell(
      onTap: () => context.push(
        AppRouter.sharedLedger,
        extra: {
          'linkId': item.linkId,
          'name': displayName,
          'isVendorView': false,
        },
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.customerAccent.withValues(alpha: 0.15),
              child: Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.customerAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTypography.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subName != null)
                    Text(
                      subName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (item.vendor.businessCategory != null)
                    Text(
                      item.vendor.businessCategory!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.balance.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pending Requests Section (vendor-sent, awaiting customer accept) ────────

class _PendingRequestsSection extends StatefulWidget {
  const _PendingRequestsSection();

  @override
  State<_PendingRequestsSection> createState() =>
      _PendingRequestsSectionState();
}

class _PendingRequestsSectionState extends State<_PendingRequestsSection> {
  late Future<List<LinkRequestModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<LinkRequestRepository>().getVendorSentRequests();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LinkRequestModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final pending = snapshot.data!
            .where((r) => r.status == LinkRequestStatus.pending)
            .toList();
        if (pending.isEmpty) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.hourglass_top_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(l10n.awaitingAcceptanceTitle, style: AppTypography.h3),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.customersHaventConfirmed,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ...pending.map((req) => _PendingRequestTile(request: req)),
          ],
        );
      },
    );
  }
}

class _PendingRequestTile extends StatelessWidget {
  final LinkRequestModel request;
  const _PendingRequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final name = request.customer.name;
    final contact = request.customer.mobile ?? request.customer.email ?? '';
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.labelLarge),
                Text(
                  contact,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 12,
                  color: Color(0xFF856404),
                ),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.pendingBadge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF856404),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notification Badge ───────────────────────────────────────────────────────

class _NotifBadge extends StatelessWidget {
  final int count;
  const _NotifBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
