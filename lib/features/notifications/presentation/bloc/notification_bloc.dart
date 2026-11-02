import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/notification_model.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/presentation/bloc/customer_event.dart';
import '../../../vendor/presentation/bloc/vendor_bloc.dart';
import '../../../vendor/presentation/bloc/vendor_event.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../../../../core/utils/app_logger.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription? _pushSub;

  static const _m = 'Notif';

  NotificationBloc(this._repository, PushNotificationService pushService)
      : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<MarkNotificationRead>(_onMarkRead);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
    on<NotificationArrived>(_onArrived);
    on<LoadUnreadCount>(_onLoadUnreadCount);

    // Subscribe to foreground notifications arriving via WebSocket.
    // Decoupled: PushNotificationService is the single source of truth.
    _pushSub = pushService.notifications.listen(
      (notification) => add(NotificationArrived(notification)),
    );
  }

  @override
  Future<void> close() async {
    await _pushSub?.cancel();
    return super.close();
  }

  Future<void> _onLoad(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    AppLogger.i(_m, 'Loading notifications...');
    emit(NotificationLoading());
    try {
      final notifications = await _repository.getNotifications();
      final unread = notifications.where((n) => !n.isRead).length;
      AppLogger.i(_m,
          'Loaded ${notifications.length} notifications, $unread unread');
      emit(NotificationLoaded(notifications: notifications, unreadCount: unread));
    } catch (e) {
      AppLogger.e(_m, 'Load notifications failed', e);
      emit(const NotificationError('Failed to load notifications'));
    }
  }

  Future<void> _onMarkRead(
      MarkNotificationRead event, Emitter<NotificationState> emit) async {
    AppLogger.v(_m, 'Marking read — id:${event.notificationId}');
    final current = state;
    if (current is! NotificationLoaded) return;
    await _repository.markAsRead(event.notificationId);
    final updated = current.notifications
        .map((n) =>
            n.id == event.notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    emit(current.copyWith(
      notifications: updated,
      unreadCount: updated.where((n) => !n.isRead).length,
    ));
  }

  Future<void> _onMarkAllRead(
      MarkAllNotificationsRead event, Emitter<NotificationState> emit) async {
    AppLogger.i(_m, 'Marking all as read');
    final current = state;
    if (current is! NotificationLoaded) return;
    await _repository.markAllAsRead();
    final updated = current.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(current.copyWith(notifications: updated, unreadCount: 0));
  }

  // A new notification arrived while the app is open — prepend it to the list
  // so the user sees it immediately if the screen is visible, then trigger the
  // appropriate dashboard reload so data is fresh without any manual pull-to-refresh.
  Future<void> _onArrived(
      NotificationArrived event, Emitter<NotificationState> emit) async {
    final notif = event.notification;
    AppLogger.i(_m, 'New notification arrived: ${notif.title}');
    final current = state;
    if (current is NotificationLoaded) {
      emit(current.copyWith(
        notifications: [notif, ...current.notifications],
        unreadCount: current.unreadCount + 1,
      ));
    } else {
      emit(NotificationLoaded(
        notifications: [notif],
        unreadCount: 1,
      ));
    }

    _refreshDashboardForNotification(notif.type);
  }

  // Reload the relevant dashboard singleton when a socket notification arrives
  // so the UI reflects the new state without requiring manual navigation.
  void _refreshDashboardForNotification(NotificationType type) {
    switch (type) {
      // Vendor received a customer link request → refresh vendor dashboard
      case NotificationType.linkRequestReceived:
        getIt<VendorBloc>().add(LoadVendorDashboard());
        break;
      // Customer received a vendor-initiated link request → refresh customer dashboard
      case NotificationType.vendorLinkRequestReceived:
        getIt<CustomerBloc>().add(LoadCustomerDashboard());
        break;
      // Vendor accepted the customer's request → customer dashboard gains a new vendor
      case NotificationType.linkRequestAccepted:
        getIt<CustomerBloc>().add(LoadCustomerDashboard());
        break;
      // Vendor declined → no data change, no reload needed
      case NotificationType.linkRequestDeclined:
        break;
      // Ledger entry added/confirmed/disputed → vendor dashboard stats may change
      case NotificationType.entryAdded:
      case NotificationType.entryConfirmed:
      case NotificationType.entryDisputed:
        getIt<VendorBloc>().add(LoadVendorDashboard());
        break;
      case NotificationType.entryAutoConfirmed:
        getIt<CustomerBloc>().add(LoadCustomerDashboard());
        break;
      default:
        break;
    }
  }

  // Lightweight refresh of the badge count — called at startup.
  Future<void> _onLoadUnreadCount(
      LoadUnreadCount event, Emitter<NotificationState> emit) async {
    try {
      final count = await _repository.getUnreadCount();
      final current = state;
      if (current is NotificationLoaded) {
        emit(current.copyWith(unreadCount: count));
      } else {
        emit(NotificationLoaded(notifications: const [], unreadCount: count));
      }
    } catch (e) {
      AppLogger.w(_m, 'Load unread count failed: $e');
    }
  }
}
