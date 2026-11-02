import 'package:equatable/equatable.dart';
import '../../../../shared/models/booking_model.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadVendorBookings extends BookingEvent {
  final DateTime date;
  const LoadVendorBookings(this.date);
  @override
  List<Object?> get props => [date];
}

class LoadCustomerBookings extends BookingEvent {}

class LoadAvailableSlots extends BookingEvent {
  final String vendorId;
  final DateTime date;
  const LoadAvailableSlots({required this.vendorId, required this.date});
  @override
  List<Object?> get props => [vendorId, date];
}

class CreateBooking extends BookingEvent {
  final BookingModel booking;
  const CreateBooking(this.booking);
  @override
  List<Object?> get props => [booking];
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  const CancelBooking(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class UpdateBookingStatus extends BookingEvent {
  final String bookingId;
  final BookingStatus status;
  const UpdateBookingStatus({required this.bookingId, required this.status});
  @override
  List<Object?> get props => [bookingId, status];
}

class SelectBookingDate extends BookingEvent {
  final DateTime date;
  const SelectBookingDate(this.date);
  @override
  List<Object?> get props => [date];
}

// ─── Schedule / Config events ─────────────────────────────────────────────────

class LoadBookingConfig extends BookingEvent {}

class SaveBookingConfig extends BookingEvent {
  final BookingConfig config;
  const SaveBookingConfig(this.config);
  @override
  List<Object?> get props => [config];
}

class ToggleSlotFull extends BookingEvent {
  final int dayOfWeek;
  final String startTime;
  final bool isFull;
  const ToggleSlotFull({required this.dayOfWeek, required this.startTime, required this.isFull});
  @override
  List<Object?> get props => [dayOfWeek, startTime, isFull];
}

// ─── Per-date override events ─────────────────────────────────────────────────

class LoadDateSlots extends BookingEvent {
  final String date;
  const LoadDateSlots(this.date);
  @override
  List<Object?> get props => [date];
}

class SaveDateSlots extends BookingEvent {
  final String date;
  final List<DaySlot> slots;
  const SaveDateSlots(this.date, this.slots);
  @override
  List<Object?> get props => [date, slots];
}

class SetDateClosed extends BookingEvent {
  final String date;
  final bool closed;
  const SetDateClosed(this.date, this.closed);
  @override
  List<Object?> get props => [date, closed];
}

class DeleteDateSlots extends BookingEvent {
  final String date;
  const DeleteDateSlots(this.date);
  @override
  List<Object?> get props => [date];
}

class ReplicateSlots extends BookingEvent {
  final String? sourceDate;
  final int? sourceDayOfWeek;
  final String targetType;
  final String startDate;
  final int? monthsCount;
  const ReplicateSlots({
    this.sourceDate,
    this.sourceDayOfWeek,
    required this.targetType,
    required this.startDate,
    this.monthsCount,
  });
  @override
  List<Object?> get props => [sourceDate, sourceDayOfWeek, targetType, startDate, monthsCount];
}

class MergeSlots extends BookingEvent {
  final String? date;
  final int? dayOfWeek;
  final List<int> slotIndexes;
  final int? mergedCapacity;
  const MergeSlots({
    this.date,
    this.dayOfWeek,
    required this.slotIndexes,
    this.mergedCapacity,
  });
  @override
  List<Object?> get props => [date, dayOfWeek, slotIndexes, mergedCapacity];
}
