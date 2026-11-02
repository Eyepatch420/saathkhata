import '../../domain/repositories/booking_repository.dart';
import '../../../../shared/models/booking_model.dart';

class MockBookingRepository implements BookingRepository {
  BookingConfig _config = BookingConfig(slots: {
    '1': [
      const DaySlot(startTime: '09:00', endTime: '10:00', isEnabled: true, isFull: false),
      const DaySlot(startTime: '11:00', endTime: '12:00', isEnabled: true, isFull: false),
      const DaySlot(startTime: '14:00', endTime: '15:00', isEnabled: true, isFull: false),
    ],
    '3': [
      const DaySlot(startTime: '10:00', endTime: '11:00', isEnabled: true, isFull: false),
      const DaySlot(startTime: '15:00', endTime: '16:00', isEnabled: true, isFull: false),
    ],
    '5': [
      const DaySlot(startTime: '09:00', endTime: '10:00', isEnabled: true, isFull: false),
    ],
  });

  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'b1',
      vendorId: 'v1',
      vendorName: 'Krishna Salon',
      customerId: 'c1',
      customerName: 'Sujeet Kumar',
      date: '2026-06-27',
      startTime: '09:00',
      endTime: '10:00',
      serviceType: 'Haircut',
      status: BookingStatus.confirmed,
      notes: 'Regular trim',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    ),
    BookingModel(
      id: 'b2',
      vendorId: 'v1',
      vendorName: 'Krishna Salon',
      customerId: 'c2',
      customerName: 'Anjali Sharma',
      date: '2026-06-27',
      startTime: '09:00',
      endTime: '10:00',
      serviceType: 'Facial',
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    ),
  ];

  @override
  Future<List<BookingModel>> getVendorBookings(String date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings.where((b) => b.date == date).toList();
  }

  @override
  Future<List<BookingModel>> getCustomerBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_bookings)..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<AppointmentSlot>> getAvailableSlots(String vendorId, String date) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final parts = date.split('-').map(int.parse).toList();
    final dayOfWeek = DateTime(parts[0], parts[1], parts[2]).weekday % 7;
    final daySlots = _config.slotsForDay(dayOfWeek);

    final bookingCounts = <String, int>{};
    for (final b in _bookings) {
      if (b.vendorId == vendorId && b.date == date && b.status != BookingStatus.cancelled) {
        bookingCounts[b.startTime] = (bookingCounts[b.startTime] ?? 0) + 1;
      }
    }

    return daySlots
        .where((s) => s.isEnabled)
        .map((s) {
          final duration = _minutesDiff(s.startTime, s.endTime);
          return AppointmentSlot(
            id: '${vendorId}_${date}_${s.startTime}',
            vendorId: vendorId,
            startTime: s.startTime,
            endTime: s.endTime,
            durationMinutes: duration,
            isAvailable: !s.isFull,
            isFull: s.isFull,
            bookingCount: bookingCounts[s.startTime] ?? 0,
          );
        })
        .toList();
  }

  int _minutesDiff(String start, String end) {
    int toMins(String t) {
      final p = t.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    }
    return toMins(end) - toMins(start);
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newBooking = BookingModel(
      id: 'b${_bookings.length + 1}',
      vendorId: booking.vendorId,
      vendorName: booking.vendorName,
      customerId: booking.customerId,
      customerName: booking.customerName,
      slotId: booking.slotId,
      date: booking.date,
      startTime: booking.startTime,
      endTime: booking.endTime,
      serviceType: booking.serviceType,
      status: BookingStatus.pending,
      notes: booking.notes,
      createdAt: DateTime.now().toIso8601String(),
    );
    _bookings.add(newBooking);
    return newBooking;
  }

  @override
  Future<BookingModel> updateBookingStatus(String bookingId, BookingStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) throw Exception('Booking not found');
    _bookings[index] = _bookings[index].copyWith(status: status);
    return _bookings[index];
  }

  @override
  Future<BookingConfig> saveBookingConfig(BookingConfig config) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _config = config;
    return config;
  }

  @override
  Future<BookingConfig?> getBookingConfig() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _config;
  }

  @override
  Future<BookingConfig> toggleSlotFull({
    required int dayOfWeek,
    required String startTime,
    required bool isFull,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final daySlots = List<DaySlot>.from(_config.slotsForDay(dayOfWeek));
    final idx = daySlots.indexWhere((s) => s.startTime == startTime);
    if (idx == -1) throw Exception('Slot not found');
    daySlots[idx] = daySlots[idx].copyWith(isFull: isFull);
    _config = _config.withUpdatedDay(dayOfWeek, daySlots);
    return _config;
  }

  // ─── Per-date overrides / capacity / replicate / merge (mock stubs) ────────

  final Map<String, DateSlotOverride> _dateOverrides = {};

  @override
  Future<DateSlotOverride> getDateSlots(String date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final existing = _dateOverrides[date];
    if (existing != null) return existing;
    final parts = date.split('-').map(int.parse).toList();
    final dayOfWeek = DateTime(parts[0], parts[1], parts[2]).weekday % 7;
    return DateSlotOverride(
      date: date,
      slots: _config.slotsForDay(dayOfWeek),
      isOverride: false,
      closed: false,
    );
  }

  @override
  Future<DateSlotOverride> saveDateSlots(String date, List<DaySlot> slots) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final override = DateSlotOverride(date: date, slots: slots, isOverride: true, closed: false);
    _dateOverrides[date] = override;
    return override;
  }

  @override
  Future<DateSlotOverride> setDateClosed(String date, bool closed) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (closed) {
      final override = DateSlotOverride(date: date, slots: const [], isOverride: true, closed: true);
      _dateOverrides[date] = override;
      return override;
    }
    return deleteDateSlots(date);
  }

  @override
  Future<DateSlotOverride> deleteDateSlots(String date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _dateOverrides.remove(date);
    return getDateSlots(date);
  }

  @override
  Future<ReplicateResult> replicateSlots({
    String? sourceDate,
    int? sourceDayOfWeek,
    required String targetType,
    required String startDate,
    int? monthsCount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ReplicateResult(appliedDates: [], skippedDates: [], failedDates: []);
  }

  @override
  Future<DateSlotOverride> mergeSlots({
    String? date,
    int? dayOfWeek,
    required List<int> slotIndexes,
    int? mergedCapacity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (date != null) {
      return getDateSlots(date);
    }
    return DateSlotOverride(
      date: '',
      slots: dayOfWeek != null ? _config.slotsForDay(dayOfWeek) : const [],
      isOverride: false,
      closed: false,
    );
  }
}
