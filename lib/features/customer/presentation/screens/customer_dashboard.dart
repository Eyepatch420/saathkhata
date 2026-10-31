import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/models/link_model.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../booking/presentation/bloc/booking_event.dart';
import '../../../booking/presentation/bloc/booking_state.dart';
import '../../../payments/presentation/screens/upi_payment_screen.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/total_due_card.dart';
import '../widgets/vendor_tile.dart';
import '../../../../shared/widgets/search_bar_pill.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_state.dart';
import '../../../link_requests/domain/models/link_request_model.dart';
import '../../../link_requests/domain/repositories/link_request_repository.dart';
import '../../../search/presentation/screens/vendor_search_screen.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CustomerBloc>()..add(LoadCustomerDashboard()),
      child: const CustomerDashboardView(),
    );
  }
}

class CustomerDashboardView extends StatelessWidget {
  const CustomerDashboardView({super.key});

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
              l10n.customerMode,
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
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerLoaded) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<CustomerBloc>().add(LoadCustomerDashboard()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SearchBarPill(viewAs: SearchViewAs.customer),
                      const SizedBox(height: 16),
                      const _PendingVendorRequestsBanner(),
                      TotalDueCard(
                        amount: state.totalDue,
                        onPayAllDues: state.totalDue > 0
                            ? () => _showPayAllDuesSheet(context, state.vendors)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const _UpcomingAppointmentsCard(),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.push(AppRouter.customerOrders),
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: Text(l10n.myOrdersTitle),
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.myVendors, style: AppTypography.h3),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.vendors.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final vendor = state.vendors[index];
                          return VendorTile(vendor: vendor);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showPayAllDuesSheet(
    BuildContext context,
    List<VendorLinkItem> vendors,
  ) {
    final pending = vendors.where((v) => v.balance > 0).toList();
    if (pending.isEmpty) return;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PayAllDuesSheet(vendors: pending),
    );
  }
}

class _UpcomingAppointmentsCard extends StatelessWidget {
  const _UpcomingAppointmentsCard();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(getIt())..add(LoadCustomerBookings()),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final int upcoming;
          final BookingModel? next;

          if (state is BookingLoaded) {
            final active =
                state.bookings
                    .where(
                      (b) =>
                          b.status == BookingStatus.pending ||
                          b.status == BookingStatus.confirmed,
                    )
                    .toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
            upcoming = active.length;
            next = active.isNotEmpty ? active.first : null;
          } else {
            upcoming = 0;
            next = null;
          }

          final surface = Theme.of(context).colorScheme.surface;

          return InkWell(
            onTap: () => context.go(AppRouter.customerBookings),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myAppointments,
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 2),
                        if (state is BookingLoading)
                          Text(
                            AppLocalizations.of(context)!.loadingContent,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          )
                        else if (next != null)
                          Text(
                            AppLocalizations.of(context)!.appointmentNext(
                              next.vendorName,
                              _fmtDate(next.date),
                              next.startTime,
                            ),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.noUpcomingAppointments,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (upcoming > 0)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$upcoming',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmtDate(String dateStr) {
    final dt = DateTime.parse(dateStr);
    return DateFormat('d MMM').format(dt);
  }
}

class _PayAllDuesSheet extends StatefulWidget {
  final List<VendorLinkItem> vendors;
  const _PayAllDuesSheet({required this.vendors});

  @override
  State<_PayAllDuesSheet> createState() => _PayAllDuesSheetState();
}

class _PayAllDuesSheetState extends State<_PayAllDuesSheet> {
  int _currentIndex = 0;
  int _paidCount = 0;

  bool get _isDone => _currentIndex >= widget.vendors.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isDone) return _buildDoneView(context);

    final vendor = widget.vendors[_currentIndex];
    final info = vendor.vendor;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.payDues,
                style: AppTypography.h3,
              ),
              Text(
                l10n.pageIndexOfTotal(
                  _currentIndex + 1,
                  widget.vendors.length,
                ),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _currentIndex / widget.vendors.length,
              minHeight: 6,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    info.name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info.name, style: AppTypography.labelLarge),
                      if (info.businessName != null)
                        Text(
                          info.businessName!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${vendor.balance.toStringAsFixed(0)}',
                      style: AppTypography.h3.copyWith(color: AppColors.error),
                    ),
                    Text(
                      AppLocalizations.of(context)!.outstandingShortLabel,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textHint,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _payViaUpi(context, vendor),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(
                Icons.payment_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                AppLocalizations.of(
                  context,
                )!.payViaUpiAmount(vendor.balance.toStringAsFixed(0)),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _skip,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textHint,
                side: BorderSide(
                  color: AppColors.textHint.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(AppLocalizations.of(context)!.skipForNow),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDoneView(BuildContext context) {
    final skipped = widget.vendors.length - _paidCount;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.allDone, style: AppTypography.h3),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              final String summary;
              if (skipped > 0) {
                summary = _paidCount == 1
                    ? l10n.paymentSummarySkippedSingular(_paidCount, skipped)
                    : l10n.paymentSummarySkipped(_paidCount, skipped);
              } else {
                summary = _paidCount == 1
                    ? l10n.paymentSummaryCompleteSingular(_paidCount)
                    : l10n.paymentSummaryComplete(_paidCount);
              }
              return Text(
                summary,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                AppLocalizations.of(context)!.done,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _payViaUpi(BuildContext context, VendorLinkItem vendor) async {
    final result = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder: (_) => UpiPaymentScreen(
          amount: vendor.balance,
          recipientName: vendor.vendor.name,
          upiId: vendor.vendor.upiId,
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) _paidCount++;
    setState(() => _currentIndex++);
  }

  void _skip() => setState(() => _currentIndex++);
}

// ─── Pending Vendor Requests Banner ──────────────────────────────────────────

class _PendingVendorRequestsBanner extends StatefulWidget {
  const _PendingVendorRequestsBanner();

  @override
  State<_PendingVendorRequestsBanner> createState() =>
      _PendingVendorRequestsBannerState();
}

class _PendingVendorRequestsBannerState
    extends State<_PendingVendorRequestsBanner> {
  late Future<List<LinkRequestModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<LinkRequestRepository>().getPendingForCustomer();
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...pending.map(
              (req) => _VendorRequestBannerTile(
                request: req,
                onResponded: () => setState(() {
                  _future = getIt<LinkRequestRepository>()
                      .getPendingForCustomer();
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _VendorRequestBannerTile extends StatelessWidget {
  final LinkRequestModel request;
  final VoidCallback onResponded;

  const _VendorRequestBannerTile({
    required this.request,
    required this.onResponded,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context.push(
          AppRouter.customerLinkRequestDetail,
          extra: request.id,
        );
        onResponded();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.customerAccent.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.customerAccent.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.customerAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.customerAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.vendorWantsToConnect,
                    style: AppTypography.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.tapToAcceptOrDecline,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
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
