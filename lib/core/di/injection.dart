import 'package:get_it/get_it.dart';
import '../utils/app_logger.dart';

import '../../features/vendor/data/repositories/vendor_repository_impl.dart';
import '../../features/vendor/domain/repositories/vendor_repository.dart';

import '../../features/customer/data/repositories/customer_repository_impl.dart';
import '../../features/customer/domain/repositories/customer_repository.dart';

import '../../features/shared_ledger/data/repositories/ledger_repository_impl.dart';
import '../../features/shared_ledger/domain/repositories/ledger_repository.dart';

import '../../features/staff/data/repositories/staff_repository_impl.dart';
import '../../features/staff/domain/repositories/staff_repository.dart';
import '../../features/staff_portal/data/staff_portal_repository.dart';

import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';

import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';

import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';

import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/presentation/bloc/search_cubit.dart';

import '../../features/link_requests/data/repositories/link_request_repository_impl.dart';
import '../../features/link_requests/domain/repositories/link_request_repository.dart';
import '../../features/link_requests/presentation/bloc/link_request_cubit.dart';

import '../../features/memberships/data/repositories/membership_repository_impl.dart';
import '../../features/memberships/domain/repositories/membership_repository.dart';

import '../../features/voice_entry/data/repositories/voice_repository_impl.dart';
import '../../features/voice_entry/domain/repositories/voice_repository.dart';
import '../services/speech_service.dart';
import '../../features/bulk_charge/data/repositories/template_repository.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';

import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';

// Auth + network
import '../services/storage_service.dart';
import '../services/ledger_attachment_service.dart';
import '../services/ledger_socket_service.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../router/auth_state_notifier.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/vendor/presentation/bloc/vendor_bloc.dart';
import '../../features/customer/presentation/bloc/customer_bloc.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../services/push_notification_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  const module = 'DI';

  AppLogger.i(module, 'Registering StorageService...');
  final storage = StorageService();
  await storage.init();
  getIt.registerSingleton<StorageService>(storage);
  AppLogger.i(module, 'StorageService ready');

  AppLogger.i(module, 'Registering Auth services');
  final authStateNotifier = AuthStateNotifier();
  getIt.registerSingleton<AuthStateNotifier>(authStateNotifier);

  AppLogger.i(module, 'Registering ApiClient (base: ${ApiEndpoints.baseUrl})');
  final apiClient = ApiClient(storage, authStateNotifier);
  getIt.registerSingleton<ApiClient>(apiClient);

  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(apiClient));
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      storage: getIt<StorageService>(),
    ),
  );

  AppLogger.i(module, 'Registering feature repositories');
  getIt.registerLazySingleton<VendorRepository>(() => VendorRepositoryImpl(apiClient));
  getIt.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(apiClient));
  getIt.registerLazySingleton<LedgerRepository>(() => LedgerRepositoryImpl(apiClient));
  getIt.registerLazySingleton<LedgerAttachmentService>(() => LedgerAttachmentService(apiClient));
  getIt.registerLazySingleton<StaffRepository>(() => StaffRepositoryImpl(apiClient));
  getIt.registerLazySingleton<StaffPortalRepository>(() => StaffPortalRepository(apiClient));
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(apiClient));
  getIt.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(apiClient));
  getIt.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(apiClient));
  getIt.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(apiClient));
  getIt.registerLazySingleton<LinkRequestRepository>(
      () => LinkRequestRepositoryImpl(apiClient));
  getIt.registerLazySingleton<MembershipRepository>(
      () => MembershipRepositoryImpl(apiClient));
  getIt.registerLazySingleton<VoiceRepository>(
      () => VoiceRepositoryImpl(apiClient));
  getIt.registerLazySingleton<SpeechService>(() => SpeechService());
  getIt.registerLazySingleton<TemplateRepository>(() => TemplateRepository(apiClient));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(apiClient));
  getIt.registerLazySingleton<ScheduleRepository>(() => ScheduleRepositoryImpl(apiClient));
  AppLogger.i(module, 'All repositories registered (13 lazy singletons + SpeechService)');

  // SearchCubit — factory: fresh instance + debounce per screen
  getIt.registerFactory<SearchCubit>(() => SearchCubit(getIt<SearchRepository>()));

  // SendLinkRequestCubit — factory: one per vendor profile screen open
  getIt.registerFactory<SendLinkRequestCubit>(
      () => SendLinkRequestCubit(getIt<LinkRequestRepository>()));

  // LinkRequestCubit — factory: one per vendor approval screen
  getIt.registerFactory<LinkRequestCubit>(
      () => LinkRequestCubit(getIt<LinkRequestRepository>()));

  getIt.registerLazySingleton<VendorBloc>(() => VendorBloc(getIt<VendorRepository>()));
  getIt.registerLazySingleton<CustomerBloc>(() => CustomerBloc(getIt<CustomerRepository>()));

  // PushNotificationService depends on LedgerSocketService for the WebSocket notification stream.
  getIt.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(getIt<LedgerSocketService>()),
  );

  // NotificationBloc is a singleton so all screens share the same unread count
  // and notification list — updates propagate to both the badge and the screen.
  getIt.registerLazySingleton<NotificationBloc>(
    () => NotificationBloc(
      getIt<NotificationRepository>(),
      getIt<PushNotificationService>(),
    ),
  );

  AppLogger.i(module, 'Registering LedgerSocketService');
  getIt.registerLazySingleton<LedgerSocketService>(() => LedgerSocketService());
  AppLogger.i(module, 'DI setup complete');
}
