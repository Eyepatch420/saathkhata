import 'package:equatable/equatable.dart';

enum NotificationType {
  entryAdded,
  entryAutoConfirmed,
  entryConfirmed,
  entryDisputed,
  paymentReceived,
  bookingRequested,   // vendor: customer wants to book (new)
  bookingConfirmed,   // customer: vendor confirmed their booking
  bookingCancelled,
  salaryPaid,
  reminderDue,
  monthlySummary,
  linkRequestReceived,
  vendorLinkRequestReceived,
  linkRequestAccepted,
  linkRequestDeclined,
  membershipRequested,
  membershipChanged,
  membershipRequestDeclined,
  staffDeleted,
}

NotificationType _notifTypeFromJson(String v) {
  const map = {
    'entry_added': NotificationType.entryAdded,
    'entry_auto_confirmed': NotificationType.entryAutoConfirmed,
    'entry_confirmed': NotificationType.entryConfirmed,
    'entry_disputed': NotificationType.entryDisputed,
    'payment_received': NotificationType.paymentReceived,
    'booking_requested': NotificationType.bookingRequested,
    'booking_confirmed': NotificationType.bookingConfirmed,
    'booking_cancelled': NotificationType.bookingCancelled,
    'salary_paid': NotificationType.salaryPaid,
    'reminder_due': NotificationType.reminderDue,
    'monthly_summary': NotificationType.monthlySummary,
    'link_request_received': NotificationType.linkRequestReceived,
    'vendor_link_request_received': NotificationType.vendorLinkRequestReceived,
    'link_request_accepted': NotificationType.linkRequestAccepted,
    'link_request_declined': NotificationType.linkRequestDeclined,
    'membership_requested': NotificationType.membershipRequested,
    'membership_changed': NotificationType.membershipChanged,
    'membership_request_declined': NotificationType.membershipRequestDeclined,
    'staff_deleted': NotificationType.staffDeleted,
  };
  return map[v] ?? NotificationType.entryAdded;
}

class AppNotification extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        userId: json['userId'] as String,
        type: _notifTypeFromJson(json['type'] as String),
        title: json['title'] as String,
        body: json['body'] as String,
        data: json['data'] != null
            ? Map<String, dynamic>.from(json['data'] as Map)
            : null,
        isRead: json['isRead'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, type, title, body, data, isRead, createdAt];
}
