import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

extension BookingStatusX on BookingStatus {
  String toJson() => name;
}

BookingStatus _bookingStatusFromJson(String v) =>
    BookingStatus.values.firstWhere((e) => e.name == v,
        orElse: () => BookingStatus.pending);

// ─── Per-day slot definition (mirrors backend DaySlot) ───────────────────────

class DaySlot extends Equatable {
  final String startTime; // 'HH:MM' 24h
  final String endTime;
  final bool isEnabled;
  final bool isFull;
  final int maxCapacity;

  const DaySlot({
    required this.startTime,
    required this.endTime,
    this.isEnabled = true,
    this.isFull = false,
    this.maxCapacity = 1,
  });

  factory DaySlot.fromJson(Map<String, dynamic> json) => DaySlot(
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        isEnabled: json['isEnabled'] as bool? ?? true,
        isFull: json['isFull'] as bool? ?? false,
        maxCapacity: json['maxCapacity'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'isEnabled': isEnabled,
        'isFull': isFull,
        'maxCapacity': maxCapacity,
      };

  DaySlot copyWith({
    String? startTime,
    String? endTime,
    bool? isEnabled,
    bool? isFull,
    int? maxCapacity,
  }) =>
      DaySlot(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isEnabled: isEnabled ?? this.isEnabled,
        isFull: isFull ?? this.isFull,
        maxCapacity: maxCapacity ?? this.maxCapacity,
      );

  @override
  List<Object?> get props => [startTime, endTime, isEnabled, isFull, maxCapacity];
}

// ─── Date override (per-date slot exception, mirrors backend EffectiveDateSlots) ─

class DateSlotOverride extends Equatable {
  final String date; // 'YYYY-MM-DD'
  final List<DaySlot> slots;
  final bool isOverride;
  final bool closed;

  const DateSlotOverride({
    required this.date,
    required this.slots,
    required this.isOverride,
    required this.closed,
  });

  factory DateSlotOverride.fromJson(Map<String, dynamic> json) => DateSlotOverride(
        date: json['date'] as String,
        slots: (json['slots'] as List? ?? [])
            .map((e) => DaySlot.fromJson(e as Map<String, dynamic>))
            .toList(),
        isOverride: json['isOverride'] as bool? ?? false,
        closed: json['closed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'slots': slots.map((s) => s.toJson()).toList(),
        'isOverride': isOverride,
        'closed': closed,
      };

  DateSlotOverride copyWith({
    String? date,
    List<DaySlot>? slots,
    bool? isOverride,
    bool? closed,
  }) =>
      DateSlotOverride(
        date: date ?? this.date,
        slots: slots ?? this.slots,
        isOverride: isOverride ?? this.isOverride,
        closed: closed ?? this.closed,
      );

  @override
  List<Object?> get props => [date, slots, isOverride, closed];
}

// ─── Replicate result ────────────────────────────────────────────────────────

class ReplicateResult extends Equatable {
  final List<String> appliedDates;
  final List<String> skippedDates;
  final List<String> failedDates;

  const ReplicateResult({
    required this.appliedDates,
    required this.skippedDates,
    required this.failedDates,
  });

  factory ReplicateResult.fromJson(Map<String, dynamic> json) => ReplicateResult(
        appliedDates: (json['appliedDates'] as List? ?? []).map((e) => e as String).toList(),
        skippedDates: (json['skippedDates'] as List? ?? []).map((e) => e as String).toList(),
        failedDates: (json['failedDates'] as List? ?? []).map((e) => e as String).toList(),
      );

  @override
  List<Object?> get props => [appliedDates, skippedDates, failedDates];
}

// ─── Booking config (per-day slot map) ───────────────────────────────────────

class BookingConfig extends Equatable {
  /// key = day-of-week as string ('0'=Sun … '6'=Sat)
  final Map<String, List<DaySlot>> slots;

  const BookingConfig({required this.slots});

  factory BookingConfig.empty() => const BookingConfig(slots: {});

  factory BookingConfig.fromJson(Map<String, dynamic> json) {
    final raw = json['slots'] as Map<String, dynamic>? ?? {};
    final slots = raw.map((k, v) {
      final list = (v as List).map((e) => DaySlot.fromJson(e as Map<String, dynamic>)).toList();
      return MapEntry(k, list);
    });
    return BookingConfig(slots: slots);
  }

  Map<String, dynamic> toJson() => {
        'slots': slots.map((k, v) => MapEntry(k, v.map((s) => s.toJson()).toList())),
      };

  List<DaySlot> slotsForDay(int dayOfWeek) => slots[dayOfWeek.toString()] ?? [];

  BookingConfig withUpdatedDay(int dayOfWeek, List<DaySlot> daySlots) {
    final updated = Map<String, List<DaySlot>>.from(slots);
    updated[dayOfWeek.toString()] = daySlots;
    return BookingConfig(slots: updated);
  }

  @override
  List<Object?> get props => [slots];
}

// ─── AppointmentSlot (what customers see) ────────────────────────────────────

class AppointmentSlot extends Equatable {
  final String id;
  final String vendorId;
  final String startTime; // 'HH:MM' 24h
  final String endTime;
  final int durationMinutes;
  final bool isAvailable;
  final bool isFull;          // vendor marked full — show "Slots Full" badge
  final int bookingCount;     // how many bookings exist for this slot
  final bool isAlreadyBooked; // customer already has a booking for this slot
  final int maxCapacity;
  final int overCapacityBy;

  const AppointmentSlot({
    required this.id,
    required this.vendorId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.isAvailable = true,
    this.isFull = false,
    this.bookingCount = 0,
    this.isAlreadyBooked = false,
    this.maxCapacity = 1,
    this.overCapacityBy = 0,
  });

  AppointmentSlot copyWith({
    bool? isAlreadyBooked,
    bool? isFull,
    int? maxCapacity,
    int? overCapacityBy,
  }) =>
      AppointmentSlot(
        id: id,
        vendorId: vendorId,
        startTime: startTime,
        endTime: endTime,
        durationMinutes: durationMinutes,
        isAvailable: isAvailable,
        isFull: isFull ?? this.isFull,
        bookingCount: bookingCount,
        isAlreadyBooked: isAlreadyBooked ?? this.isAlreadyBooked,
        maxCapacity: maxCapacity ?? this.maxCapacity,
        overCapacityBy: overCapacityBy ?? this.overCapacityBy,
      );

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) => AppointmentSlot(
        id: json['id'] as String,
        vendorId: json['vendorId'] as String,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        durationMinutes: json['durationMinutes'] as int,
        isAvailable: json['isAvailable'] as bool? ?? true,
        isFull: json['isFull'] as bool? ?? false,
        bookingCount: json['bookingCount'] as int? ?? 0,
        maxCapacity: json['maxCapacity'] as int? ?? 1,
        overCapacityBy: json['overCapacityBy'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        vendorId,
        startTime,
        endTime,
        durationMinutes,
        isAvailable,
        isFull,
        bookingCount,
        isAlreadyBooked,
        maxCapacity,
        overCapacityBy,
      ];
}

// ─── BookingModel ─────────────────────────────────────────────────────────────

class BookingModel extends Equatable {
  final String id;
  final String vendorId;
  final String vendorName;
  final String customerId;
  final String customerName;
  final String? slotId;
  final String date;       // 'YYYY-MM-DD'
  final String startTime;  // 'HH:MM'
  final String endTime;
  final String? serviceType;
  final BookingStatus status;
  final String? notes;
  final String createdAt;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] as String,
        vendorId: json['vendorId'] as String,
        vendorName: json['vendorName'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        slotId: json['slotId'] as String?,
        date: json['date'] as String,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        serviceType: json['serviceType'] as String?,
        status: _bookingStatusFromJson(json['status'] as String),
        notes: json['notes'] as String?,
        createdAt: json['createdAt'] as String,
      );

  const BookingModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.customerId,
    required this.customerName,
    this.slotId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.serviceType,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  BookingModel copyWith({BookingStatus? status}) {
    return BookingModel(
      id: id,
      vendorId: vendorId,
      vendorName: vendorName,
      customerId: customerId,
      customerName: customerName,
      slotId: slotId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      serviceType: serviceType,
      status: status ?? this.status,
      notes: notes,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, vendorId, vendorName, customerId, customerName,
        slotId, date, startTime, endTime, serviceType, status, notes, createdAt,
      ];
}
