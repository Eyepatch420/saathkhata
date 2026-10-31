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
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

// 24h 'HH:MM' → 12h display
String _to12h(String hhmm, BuildContext context) {
  final p = hhmm.split(':');
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1])),
    alwaysUse24HourFormat: false,
  );
}

class VendorBookingsScreen extends StatelessWidget {
  const VendorBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(getIt())..add(LoadVendorBookings(DateTime.now())),
      child: const _VendorBookingsView(),
    );
  }
}

class _VendorBookingsView extends StatefulWidget {
  const _VendorBookingsView();

  @override
  State<_VendorBookingsView> createState() => _VendorBookingsViewState();
}

class _VendorBookingsViewState extends State<_VendorBookingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appointments, style: AppTypography.h3),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.vendorScheduleSetup),
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: AppLocalizations.of(context)!.manageSchedule,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.bookingsTab),
            Tab(text: AppLocalizations.of(context)!.bySlotTab),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingActionError) {
              AppToast.show(context, state.message, type: ToastType.error);
            }
          },
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BookingError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () =>
                    context.read<BookingBloc>().add(LoadVendorBookings(DateTime.now())),
              );
            }

            final bookingState = state is BookingLoaded
                ? state
                : state is BookingActionError
                    ? BookingLoaded(
                        bookings: state.bookings,
                        selectedDate: state.selectedDate,
                      )
                    : null;

            if (bookingState == null) return const SizedBox();

            return TabBarView(
              controller: _tabController,
              children: [
                _BookingsTab(state: bookingState),
                _BySlotTab(state: bookingState),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Bookings Tab (flat list by date) ─────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  final BookingLoaded state;
  const _BookingsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _DateSelector(selected: state.selectedDate),
        Expanded(
          child: state.bookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.event_available_rounded,
                  title: l10n.noBookingsToday,
                  subtitle: l10n.noBookingsTodaySubtitle,
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
                  itemCount: state.bookings.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) =>
                      _BookingCard(booking: state.bookings[i]),
                ),
        ),
      ],
    );
  }
}

// ─── By Slot Tab (group customers under each slot) ────────────────────────────

class _BySlotTab extends StatelessWidget {
  final BookingLoaded state;
  const _BySlotTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _DateSelector(selected: state.selectedDate),
        Expanded(
          child: state.bookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.event_available_rounded,
                  title: l10n.noBookingsToday,
                  subtitle: l10n.noBookingsTodaySubtitle,
                )
              : _SlotGroupedList(bookings: state.bookings),
        ),
      ],
    );
  }
}

class _SlotGroupedList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _SlotGroupedList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Group bookings by startTime
    final grouped = <String, List<BookingModel>>{};
    for (final b in bookings) {
      grouped.putIfAbsent(b.startTime, () => []).add(b);
    }
    final slotTimes = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      itemCount: slotTimes.length,
      itemBuilder: (context, i) {
        final time = slotTimes[i];
        final slotBookings = grouped[time]!;
        return _SlotGroup(slotTime: time, bookings: slotBookings);
      },
    );
  }
}

class _SlotGroup extends StatefulWidget {
  final String slotTime;
  final List<BookingModel> bookings;
  const _SlotGroup({required this.slotTime, required this.bookings});

  @override
  State<_SlotGroup> createState() => _SlotGroupState();
}

class _SlotGroupState extends State<_SlotGroup> {
  bool _expanded = true;

  void _showSlotDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SlotDetailSheet(
        slotTime: widget.slotTime,
        bookings: widget.bookings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final confirmedCount =
        widget.bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final pendingCount =
        widget.bookings.where((b) => b.status == BookingStatus.pending).length;
    final total = widget.bookings.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Slot header — tap to see full details ─────────────────────────
          InkWell(
            onTap: () => _showSlotDetail(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.access_time_rounded,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _to12h(widget.slotTime, context),
                          style: AppTypography.labelLarge,
                        ),
                        Text(
                          '${total == 1 ? l10n.bookingsCount(total) : l10n.bookingsCountPlural(total)}'
                          '${pendingCount > 0 ? '  •  ${l10n.pendingCountLabel(pendingCount)}' : ''}',
                          style: AppTypography.bodySmall.copyWith(
                            color: pendingCount > 0
                                ? AppColors.warning
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Confirmed / pending summary chips
                  if (confirmedCount > 0)
                    _MiniChip(label: '$confirmedCount ✓', color: AppColors.success),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    _MiniChip(label: '$pendingCount ⏳', color: AppColors.warning),
                  ],
                  const SizedBox(width: 6),
                  // Expand/collapse toggle (separate from sheet-open tap)
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Customer list ─────────────────────────────────────────────────
          if (_expanded) ...[
            Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.15)),
            ...widget.bookings.asMap().entries.map((entry) {
              final isLast = entry.key == widget.bookings.length - 1;
              return Column(
                children: [
                  _CustomerBookingRow(booking: entry.value),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: colorScheme.outline.withValues(alpha: 0.1)),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ─── Slot Detail Bottom Sheet ─────────────────────────────────────────────────

class _SlotDetailSheet extends StatelessWidget {
  final String slotTime;
  final List<BookingModel> bookings;
  const _SlotDetailSheet({required this.slotTime, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final total = bookings.length;
    final confirmedCount = bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final pendingCount = bookings.where((b) => b.status == BookingStatus.pending).length;
    final cancelledCount = bookings.where((b) => b.status == BookingStatus.cancelled).length;
    final completedCount = bookings.where((b) => b.status == BookingStatus.completed).length;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle + header
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time_rounded,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_to12h(slotTime, context), style: AppTypography.h3),
                        Text(
                          total == 1
                              ? l10n.bookingsCount(total)
                              : l10n.bookingsCountPlural(total),
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Summary chips row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (pendingCount > 0) ...[
                        _MiniChip(
                            label: l10n.pendingCountLabel(pendingCount),
                            color: AppColors.warning),
                        const SizedBox(width: 8),
                      ],
                      if (confirmedCount > 0) ...[
                        _MiniChip(
                            label: l10n.confirmedCountLabel(confirmedCount),
                            color: AppColors.success),
                        const SizedBox(width: 8),
                      ],
                      if (completedCount > 0) ...[
                        _MiniChip(
                            label: l10n.doneCountLabel(completedCount),
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      if (cancelledCount > 0)
                        _MiniChip(
                            label: l10n.cancelledCountLabel(cancelledCount),
                            color: AppColors.error),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.15)),
              ],
            ),
          ),
          // Customer list
          Expanded(
            child: ListView.separated(
              controller: scrollCtrl,
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
              itemCount: bookings.length,
              separatorBuilder: (_, i) => Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
              itemBuilder: (ctx, i) => _SlotCustomerTile(booking: bookings[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCustomerTile extends StatelessWidget {
  final BookingModel booking;
  const _SlotCustomerTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isActionable = booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.confirmed;

    return InkWell(
      onTap: isActionable
          ? () {
              Navigator.pop(context);
              _showBookingActionSheet(context, booking);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                booking.customerName.isNotEmpty
                    ? booking.customerName[0].toUpperCase()
                    : '?',
                style: AppTypography.h3.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.customerName, style: AppTypography.labelLarge),
                  const SizedBox(height: 2),
                  if (booking.serviceType != null)
                    Text(
                      booking.serviceType!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.notes_rounded,
                            size: 13, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            booking.notes!,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.textHint),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    '${_to12h(booking.startTime, context)} – ${_to12h(booking.endTime, context)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: booking.status),
                if (isActionable) ...[
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right_rounded,
                      size: 16, color: AppColors.textHint),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CustomerBookingRow extends StatelessWidget {
  final BookingModel booking;
  const _CustomerBookingRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isActionable = booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.confirmed;

    return InkWell(
      onTap: isActionable ? () => _showBookingActionSheet(context, booking) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                booking.customerName.isNotEmpty
                    ? booking.customerName[0].toUpperCase()
                    : '?',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.customerName, style: AppTypography.labelLarge),
                  if (booking.serviceType != null)
                    Text(booking.serviceType!,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textHint)),
                  if (booking.notes != null && booking.notes!.isNotEmpty)
                    Text(
                      booking.notes!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            _StatusBadge(status: booking.status),
            if (isActionable) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppColors.textHint),
            ],
          ],
        ),
      ),
    );
  }

}

// ─── Shared action sheet (used by both _BookingCard and _CustomerBookingRow) ──

void _showBookingActionSheet(BuildContext context, BookingModel booking) {
  final l10n = AppLocalizations.of(context)!;
  final bloc = context.read<BookingBloc>();
  final dateStr =
      '${DateTime.parse(booking.date).day}/${DateTime.parse(booking.date).month}';

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(booking.customerName, style: AppTypography.h3),
            Text(
              booking.serviceType != null
                  ? l10n.bookingDateTimeWithService(
                      l10n.bookingDateTimeShort(
                        dateStr,
                        _to12h(booking.startTime, context),
                      ),
                      booking.serviceType!,
                    )
                  : l10n.bookingDateTimeShort(
                      dateStr,
                      _to12h(booking.startTime, context),
                    ),
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            if (booking.status == BookingStatus.pending) ...[
              _ActionTile(
                icon: Icons.check_circle_outline_rounded,
                label: l10n.confirmBooking,
                color: AppColors.success,
                onTap: () {
                  Navigator.pop(ctx);
                  bloc.add(UpdateBookingStatus(
                    bookingId: booking.id,
                    status: BookingStatus.confirmed,
                  ));
                },
              ),
              const SizedBox(height: 8),
            ],
            if (booking.status == BookingStatus.confirmed) ...[
              _ActionTile(
                icon: Icons.task_alt_rounded,
                label: l10n.markComplete,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  bloc.add(UpdateBookingStatus(
                    bookingId: booking.id,
                    status: BookingStatus.completed,
                  ));
                },
              ),
              const SizedBox(height: 8),
            ],
            _ActionTile(
              icon: Icons.cancel_outlined,
              label: l10n.cancelBooking,
              color: AppColors.error,
              onTap: () {
                Navigator.pop(ctx);
                _showCancelConfirmDialog(context, bloc, booking, dateStr, l10n);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

void _showCancelConfirmDialog(
  BuildContext context,
  BookingBloc bloc,
  BookingModel booking,
  String dateStr,
  AppLocalizations l10n,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.cancelAppointmentTitle),
      content: Text(l10n.cancelAppointmentMessage(
          dateStr, _to12h(booking.startTime, context))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.keepBooking),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            bloc.add(UpdateBookingStatus(
              bookingId: booking.id,
              status: BookingStatus.cancelled,
            ));
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(l10n.cancelBooking),
        ),
      ],
    ),
  );
}

// ─── Date Selector ────────────────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  final DateTime selected;
  const _DateSelector({required this.selected});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final days = List.generate(14, (i) => now.add(Duration(days: i - 2)));

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: days.map((day) {
            final isSelected = _isSameDay(day, selected);
            final isToday = _isSameDay(day, now);
            return GestureDetector(
              onTap: () =>
                  context.read<BookingBloc>().add(SelectBookingDate(day)),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday && !isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('E', locale).format(day),
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: AppTypography.labelLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─── Flat booking card (Bookings tab) ─────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(booking.status);
    final isActionable = booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.confirmed;

    return GestureDetector(
      onTap: isActionable
          ? () => _showBookingActionSheet(context, booking)
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_to12h(booking.startTime, context),
                    style: AppTypography.h3.copyWith(fontSize: 16)),
                Text(
                  '${DateTime.parse(booking.date).day}/${DateTime.parse(booking.date).month}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(width: 1, height: 44, color: AppColors.divider),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.customerName, style: AppTypography.labelLarge),
                  if (booking.serviceType != null)
                    Text(booking.serviceType!, style: AppTypography.bodySmall),
                  if (booking.notes != null && booking.notes!.isNotEmpty)
                    Text(
                      booking.notes!,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusBadge(status: booking.status),
                if (isActionable) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.textHint),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BookingStatus s) => switch (s) {
        BookingStatus.confirmed => AppColors.success,
        BookingStatus.pending => AppColors.warning,
        BookingStatus.cancelled => AppColors.error,
        BookingStatus.completed => AppColors.primary,
      };
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.labelLarge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (status) {
      BookingStatus.confirmed => (l10n.bookingStatusConfirmed, AppColors.success),
      BookingStatus.pending => (l10n.bookingStatusPending, AppColors.warning),
      BookingStatus.cancelled => (l10n.bookingStatusCancelled, AppColors.error),
      BookingStatus.completed => (l10n.bookingStatusDone, AppColors.primary),
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
