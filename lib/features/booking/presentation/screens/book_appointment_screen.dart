import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/booking_confirmation_sheet.dart';

class BookAppointmentScreen extends StatelessWidget {
  final String vendorId;
  final String vendorName;

  const BookAppointmentScreen({
    super.key,
    required this.vendorId,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(getIt()),
      child: _BookAppointmentBody(vendorId: vendorId, vendorName: vendorName),
    );
  }
}

class _BookAppointmentBody extends StatefulWidget {
  final String vendorId;
  final String vendorName;

  const _BookAppointmentBody({
    required this.vendorId,
    required this.vendorName,
  });

  @override
  State<_BookAppointmentBody> createState() => _BookAppointmentBodyState();
}

class _BookAppointmentBodyState extends State<_BookAppointmentBody> {
  late DateTime _selectedDate;
  String? _lastAttemptedSlotTime;
  static const _daysToShow = 14;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    context
        .read<BookingBloc>()
        .add(LoadAvailableSlots(vendorId: widget.vendorId, date: _selectedDate));
  }

  void _selectDate(DateTime date) {
    if (_sameDay(_selectedDate, date)) return;
    setState(() => _selectedDate = date);
    context
        .read<BookingBloc>()
        .add(LoadAvailableSlots(vendorId: widget.vendorId, date: date));
  }

  void _onSlotTapped(AppointmentSlot slot) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    setState(() => _lastAttemptedSlotTime = slot.startTime);

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingBloc>(),
        child: BookingConfirmationSheet(
          slot: slot,
          date: _selectedDate,
          vendorId: widget.vendorId,
          vendorName: widget.vendorName,
          customerId: authState.user.id,
          customerName: authState.user.name,
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dates = List.generate(_daysToShow, (i) => today.add(Duration(days: i)));

    return BlocListener<BookingBloc, BookingState>(
      listenWhen: (_, c) => c is BookingCreated || c is BookingError || c is BookingCreateError,
      listener: (context, state) {
        if (state is BookingCreated) {
          AppToast.show(context, AppLocalizations.of(context)!.bookingConfirmedToast, type: ToastType.success);
          context.go(AppRouter.customerBookings);
        } else if (state is BookingCreateError) {
          AppToast.show(context, state.message, type: ToastType.error);
        } else if (state is BookingError) {
          AppToast.show(context, state.message, type: ToastType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.vendorName, style: AppTypography.h3),
              Text(
                AppLocalizations.of(context)!.bookAnAppointment,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          titleSpacing: 0,
        ),
        body: SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateStrip(
              dates: dates,
              selectedDate: _selectedDate,
              onDateSelected: _selectDate,
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BookingError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => context.read<BookingBloc>().add(
                            LoadAvailableSlots(
                              vendorId: widget.vendorId,
                              date: _selectedDate,
                            ),
                          ),
                    );
                  }
                  // Booking failed — keep slot grid visible, mark attempted slot
                  if (state is BookingCreateError) {
                    if (state.slots.isEmpty) {
                      final l10n = AppLocalizations.of(context)!;
                      return EmptyStateWidget(
                        icon: Icons.event_busy_rounded,
                        title: l10n.noSlotsAvailable,
                        subtitle: l10n.noSlotsVendorMayBeClosed,
                      );
                    }
                    final bookedTime = _lastAttemptedSlotTime;
                    final updatedSlots = bookedTime == null
                        ? state.slots
                        : state.slots
                            .map((s) => s.startTime == bookedTime
                                ? s.copyWith(isAlreadyBooked: true)
                                : s)
                            .toList();
                    return _SlotGrid(slots: updatedSlots, onSlotTapped: _onSlotTapped);
                  }
                  if (state is SlotsLoaded) {
                    if (state.slots.isEmpty) {
                      final l10n = AppLocalizations.of(context)!;
                      return EmptyStateWidget(
                        icon: Icons.event_busy_rounded,
                        title: l10n.noSlotsAvailable,
                        subtitle: l10n.noSlotsVendorMayBeClosed,
                      );
                    }
                    return _SlotGrid(
                      slots: state.slots,
                      onSlotTapped: _onSlotTapped,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// ─── Date Strip ───────────────────────────────────────────────────────────────

class _DateStrip extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DateStrip({
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: dates.map((day) {
            final isSelected = _isSameDay(day, selectedDate);
            final isToday = _isSameDay(day, DateTime.now());
            return GestureDetector(
              onTap: () => onDateSelected(day),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
}

// ─── Slot Grid ────────────────────────────────────────────────────────────────

class _SlotGrid extends StatelessWidget {
  final List<AppointmentSlot> slots;
  final ValueChanged<AppointmentSlot> onSlotTapped;

  const _SlotGrid({required this.slots, required this.onSlotTapped});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.availableSlots,
            style: AppTypography.labelLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: slots
                .map((s) => _SlotChip(slot: s, onTap: () => onSlotTapped(s)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

String _to12h(String hhmm, BuildContext context) {
  final p = hhmm.split(':');
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1])),
    alwaysUse24HourFormat: false,
  );
}

class _SlotChip extends StatelessWidget {
  final AppointmentSlot slot;
  final VoidCallback onTap;

  const _SlotChip({required this.slot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final atCapacity = slot.maxCapacity > 0 && slot.bookingCount >= slot.maxCapacity;
    final isFull = slot.isFull || atCapacity;
    final isBooked = slot.isAlreadyBooked;
    final isDisabled = isFull || isBooked;
    final overCapacity = slot.overCapacityBy > 0;

    final borderColor = isBooked
        ? AppColors.primary.withValues(alpha: 0.3)
        : isFull
            ? AppColors.warning.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.4);
    final textColor = isDisabled ? AppColors.textHint : AppColors.primary;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDisabled
              ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _to12h(slot.startTime, context),
              style: AppTypography.labelLarge.copyWith(
                color: textColor,
                decoration: isDisabled ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            if (isBooked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppLocalizations.of(context)!.alreadyBookedLabel,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.primary.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else if (isFull)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppLocalizations.of(context)!.slotsFull,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else if (slot.maxCapacity > 1)
              Text(
                AppLocalizations.of(context)!
                    .bookedOfCapacity(slot.bookingCount, slot.maxCapacity),
                style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
              )
            else if (slot.durationMinutes > 0)
              Text(
                AppLocalizations.of(context)!.durationMinutes(slot.durationMinutes),
                style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
              ),
            if (overCapacity)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.error),
                    const SizedBox(width: 2),
                    Text(
                      AppLocalizations.of(context)!.overCapacityWarning(slot.overCapacityBy),
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 9,
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
