import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen>
    with WidgetsBindingObserver {
  late final BookingBloc _bloc;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = BookingBloc(getIt())..add(LoadCustomerBookings());
    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    // Refresh every 15 seconds while screen is visible so vendor status changes
    // appear without the customer needing to pull-to-refresh.
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) _bloc.add(LoadCustomerBookings());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc.add(LoadCustomerBookings());
      _startPolling();
    } else if (state == AppLifecycleState.paused) {
      _pollTimer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.myAppointments)),
        body: SafeArea(child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BookingError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => _bloc.add(LoadCustomerBookings()),
              );
            }
            if (state is BookingLoaded) {
              if (state.bookings.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async => _bloc.add(LoadCustomerBookings()),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: EmptyStateWidget(
                          icon: Icons.calendar_today_rounded,
                          title: l10n.noAppointmentsTitle,
                          subtitle: l10n.noAppointmentsSubtitle,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => _bloc.add(LoadCustomerBookings()),
                child: _BookingsList(bookings: state.bookings),
              );
            }
            return const SizedBox();
          },
        ),
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingsList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final upcoming = bookings
        .where((b) =>
            b.status != BookingStatus.cancelled &&
            b.status != BookingStatus.completed)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final past = bookings
        .where((b) =>
            b.status == BookingStatus.cancelled ||
            b.status == BookingStatus.completed)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      children: [
        if (upcoming.isNotEmpty) ...[
          Text(AppLocalizations.of(context)!.upcoming,
              style: AppTypography.labelLarge),
          const SizedBox(height: 12),
          ...upcoming.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CustomerBookingCard(booking: b),
              )),
        ],
        if (past.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.past,
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...past.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CustomerBookingCard(booking: b),
              )),
        ],
      ],
    );
  }
}

class _CustomerBookingCard extends StatelessWidget {
  final BookingModel booking;
  const _CustomerBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isUpcoming = booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.confirmed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_today_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.vendorName, style: AppTypography.labelLarge),
                    if (booking.serviceType != null)
                      Text(booking.serviceType!, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              _StatusChip(status: booking.status),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.bookingDateAtTime(
                  _formatDate(booking.date),
                  booking.startTime,
                ),
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.notes_rounded,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking.notes!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (isUpcoming) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _confirmCancel(context, booking),
                icon: const Icon(Icons.cancel_outlined, size: 16),
                label:
                    Text(AppLocalizations.of(context)!.cancelBooking),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, BookingModel booking) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelAppointmentTitle),
        content: Text(l10n.cancelAppointmentMessage(
            _formatDate(booking.date), booking.startTime)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.keepBooking),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookingBloc>().add(CancelBooking(booking.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.cancelBooking),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final dt = DateTime.parse(dateStr);
    return DateFormat('d MMM').format(dt);
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (status) {
      BookingStatus.confirmed => (l10n.bookingStatusConfirmed, AppColors.success),
      BookingStatus.pending => (l10n.bookingStatusPending, AppColors.warning),
      BookingStatus.cancelled => (l10n.bookingStatusCancelled, AppColors.error),
      BookingStatus.completed => (l10n.bookingStatusCompleted, AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
