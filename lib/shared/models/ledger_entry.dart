import 'package:equatable/equatable.dart';

enum EntryType { credit, payment, advance, adjustment }

enum EntryStatus { pending, confirmed, disputed, autoConfirmed }

extension EntryTypeX on EntryType {
  String toJson() => name; // credit, payment, advance, adjustment — all match
}

extension EntryStatusX on EntryStatus {
  String toJson() =>
      this == EntryStatus.autoConfirmed ? 'auto_confirmed' : name;
}

EntryType _entryTypeFromJson(String v) => EntryType.values.firstWhere(
  (e) => e.name == v,
  orElse: () => EntryType.credit,
);

EntryStatus _entryStatusFromJson(String v) {
  if (v == 'auto_confirmed') return EntryStatus.autoConfirmed;
  return EntryStatus.values.firstWhere(
    (e) => e.name == v,
    orElse: () => EntryStatus.pending,
  );
}

class LedgerEntry extends Equatable {
  final String id;
  final String linkId;
  final String? vendorId;
  final String? customerId;
  final double amount;
  final EntryType type;
  final DateTime date;
  final String? description;
  final double? quantity;
  final String? unit;
  final EntryStatus status;
  final DateTime? confirmedAt;
  final bool isLocked;
  final String? disputeReason;
  final String? attachmentUrl;
  final String createdBy;
  final String? parentEntryId;
  final bool isParent;
  final int childCount;
  final String sourceType;
  final String? scheduledDeliveryId;
  final List<LedgerEntry> children;

  const LedgerEntry({
    required this.id,
    required this.linkId,
    this.vendorId,
    this.customerId,
    required this.amount,
    required this.type,
    required this.date,
    this.description,
    this.quantity,
    this.unit,
    required this.status,
    this.confirmedAt,
    this.isLocked = false,
    this.disputeReason,
    this.attachmentUrl,
    required this.createdBy,
    this.parentEntryId,
    this.isParent = false,
    this.childCount = 0,
    this.sourceType = 'manual',
    this.scheduledDeliveryId,
    this.children = const [],
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => LedgerEntry(
    id: json['id'] as String,
    linkId: json['linkId'] as String,
    vendorId: json['vendorId'] as String?,
    customerId: json['customerId'] as String?,
    amount: (json['amount'] as num).toDouble(),
    type: _entryTypeFromJson(json['type'] as String),
    date: DateTime.parse(json['date'] as String).toLocal(),
    description: json['description'] as String?,
    quantity: json['quantity'] != null
        ? (json['quantity'] as num).toDouble()
        : null,
    unit: json['unit'] as String?,
    status: _entryStatusFromJson(json['status'] as String),
    confirmedAt: json['confirmedAt'] != null
        ? DateTime.parse(json['confirmedAt'] as String).toLocal()
        : null,
    isLocked: json['isLocked'] as bool? ?? false,
    disputeReason: json['disputeReason'] as String?,
    attachmentUrl: json['attachmentUrl'] as String?,
    createdBy: json['createdBy'] as String? ?? '',
    parentEntryId: json['parentEntryId'] as String?,
    isParent: json['isParent'] as bool? ?? false,
    childCount: json['childCount'] as int? ?? 0,
    sourceType: json['sourceType'] as String? ?? 'manual',
    scheduledDeliveryId: json['scheduledDeliveryId'] as String?,
    children:
        (json['children'] as List<dynamic>?)
            ?.map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );

  LedgerEntry copyWith({
    EntryStatus? status,
    bool? isLocked,
    DateTime? confirmedAt,
    String? disputeReason,
    List<LedgerEntry>? children,
    int? childCount,
  }) {
    return LedgerEntry(
      id: id,
      linkId: linkId,
      vendorId: vendorId,
      customerId: customerId,
      amount: amount,
      type: type,
      date: date,
      description: description,
      quantity: quantity,
      unit: unit,
      status: status ?? this.status,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      isLocked: isLocked ?? this.isLocked,
      disputeReason: disputeReason ?? this.disputeReason,
      attachmentUrl: attachmentUrl,
      createdBy: createdBy,
      parentEntryId: parentEntryId,
      isParent: isParent,
      childCount: childCount ?? this.childCount,
      sourceType: sourceType,
      scheduledDeliveryId: scheduledDeliveryId,
      children: children ?? this.children,
    );
  }

  /// True for any entry auto-created from a delivery — either the order
  /// flow ("Order delivery (by vendor|staff)" description) or the schedule
  /// flow (sourceType == 'schedule_delivery', description is just the
  /// service name so it can't be string-matched the same way).
  bool get isDelivery =>
      (description ?? '').toLowerCase().startsWith('order delivery') ||
      sourceType == 'schedule_delivery';

  /// "vendor" / "staff" parsed from the delivery description, else null.
  /// Only meaningful for order-flow entries — schedule-flow entries don't
  /// encode this in the description (see [LedgerEntry.deliveryLabel]).
  String? get deliveredByRole {
    final d = description ?? '';
    final m = RegExp(
      r'\(by (vendor|staff)\)',
      caseSensitive: false,
    ).firstMatch(d);
    return m?.group(1)?.toLowerCase();
  }

  /// Friendly attribution label, e.g. "Delivered by vendor".
  String get deliveryLabel {
    final role = deliveredByRole;
    return role != null ? 'Delivered by $role' : 'Delivered';
  }

  /// True only for entries awaiting confirmation by the other party.
  bool get isPendingConfirmation => status == EntryStatus.pending && !isLocked;

  @override
  List<Object?> get props => [
    id,
    linkId,
    vendorId,
    customerId,
    amount,
    type,
    date,
    description,
    quantity,
    unit,
    status,
    confirmedAt,
    isLocked,
    disputeReason,
    attachmentUrl,
    createdBy,
    parentEntryId,
    isParent,
    childCount,
    sourceType,
    scheduledDeliveryId,
    children,
  ];
}
