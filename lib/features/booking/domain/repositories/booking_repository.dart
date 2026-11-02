import '../../../../shared/models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getVendorBookings(String date);
  Future<List<BookingModel>> getCustomerBookings();
  Future<List<AppointmentSlot>> getAvailableSlots(String vendorId, String date);
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> updateBookingStatus(String bookingId, BookingStatus status);
  Future<BookingConfig> saveBookingConfig(BookingConfig config);
  Future<BookingConfig?> getBookingConfig();
  Future<BookingConfig> toggleSlotFull({
    required int dayOfWeek,
    required String startTime,
    required bool isFull,
  });

  // ─── Per-date overrides / capacity / replicate / merge ─────────────────────
  Future<DateSlotOverride> getDateSlots(String date);
  Future<DateSlotOverride> saveDateSlots(String date, List<DaySlot> slots);
  Future<DateSlotOverride> setDateClosed(String date, bool closed);
  Future<DateSlotOverride> deleteDateSlots(String date);
  Future<ReplicateResult> replicateSlots({
    String? sourceDate,
    int? sourceDayOfWeek,
    required String targetType,
    required String startDate,
    int? monthsCount,
  });
  Future<DateSlotOverride> mergeSlots({
    String? date,
    int? dayOfWeek,
    required List<int> slotIndexes,
    int? mergedCapacity,
  });
}
