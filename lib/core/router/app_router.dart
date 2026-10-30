import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/animations/rive/app_rive_icon.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/phone_entry_screen.dart';
import '../../features/auth/presentation/screens/email_login_screen.dart';
import '../../features/auth/presentation/screens/email_signup_screen.dart';
import '../../features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../../features/vendor/presentation/bloc/vendor_bloc.dart';
import '../../features/vendor/presentation/bloc/vendor_event.dart';
import '../../features/vendor/presentation/screens/vendor_dashboard.dart';
import '../../features/customer/presentation/screens/customer_dashboard.dart';
import '../../features/staff_portal/presentation/screens/staff_shell.dart';
import '../../features/staff_portal/presentation/screens/staff_home_screen.dart';
import '../../features/staff_portal/presentation/screens/staff_customers_screen.dart';
import '../../features/staff_portal/presentation/screens/staff_pay_screen.dart';
import '../../features/staff_portal/presentation/screens/staff_quick_delivery_screen.dart';
import '../../features/staff_portal/presentation/screens/staff_deliveries_screen.dart';

import '../../features/shared_ledger/presentation/screens/shared_ledger_screen.dart';

import '../../features/staff/presentation/screens/staff_management_screen.dart';

import '../../features/reports/presentation/screens/reports_screen.dart';

import '../../features/settings/presentation/screens/settings_screen.dart';

import '../../features/customer/presentation/screens/my_khatas_screen.dart';
import '../../features/customer/presentation/screens/payments_screen.dart';
import '../../features/customer/presentation/screens/customer_profile_screen.dart';

import '../../features/reports/presentation/screens/all_customers_report_screen.dart';
import '../../features/vendor/presentation/screens/all_customers_screen.dart';
import '../../features/vendor/presentation/screens/customer_detail_screen.dart';
import '../../shared/models/link_model.dart';
import '../../features/vendor/presentation/screens/outstanding_list_screen.dart';
import '../../features/vendor/presentation/screens/collected_today_screen.dart';
import '../../features/reports/presentation/screens/customer_detail_report_screen.dart';

import '../../features/bill_ocr/presentation/screens/scan_bill_screen.dart';
import '../../features/bill_ocr/presentation/screens/bill_details_form_screen.dart';

import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/booking/presentation/screens/vendor_bookings_screen.dart';
import '../../features/booking/presentation/screens/vendor_schedule_setup_screen.dart';
import '../../features/booking/presentation/screens/customer_bookings_screen.dart';
import '../../features/booking/presentation/screens/book_appointment_screen.dart';
import '../../features/location/presentation/screens/location_picker_screen.dart';
import '../../shared/models/location_model.dart';
import '../../features/payments/presentation/screens/upi_payment_screen.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/upi_management_screen.dart';
import '../../features/settings/presentation/screens/policy_screen.dart';
import '../../features/search/presentation/screens/vendor_search_screen.dart';
import '../../features/search/presentation/screens/vendor_profile_screen.dart';
import '../../features/search/domain/models/vendor_search_result.dart';
import '../../features/link_requests/presentation/screens/vendor_link_request_screen.dart';
import '../../features/link_requests/presentation/screens/customer_link_request_screen.dart';
import '../../features/link_requests/domain/repositories/link_request_repository.dart';
import '../../shared/widgets/app_toast.dart';
import '../../core/constants/app_typography.dart';
import '../../features/memberships/presentation/screens/membership_plans_screen.dart';
import '../../features/memberships/presentation/screens/members_dashboard_screen.dart';
import '../../features/memberships/presentation/screens/membership_requests_screen.dart';
import '../../features/bulk_charge/presentation/screens/bulk_charge_screen.dart';
import '../../features/orders/presentation/screens/vendor_orders_screen.dart';
import '../../features/orders/presentation/screens/customer_orders_screen.dart';
import '../../features/orders/presentation/screens/staff_orders_screen.dart';
import '../../features/orders/presentation/screens/place_order_screen.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/settings/presentation/screens/ledger_preferences_screen.dart';
import '../../features/schedule/presentation/screens/vendor_services_screen.dart';
import '../../features/schedule/presentation/screens/customer_subscriptions_screen.dart';
import '../../features/schedule/presentation/cubit/schedule_cubit.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';
import '../di/injection.dart';
import 'auth_state_notifier.dart';

class AppRouter {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String phoneEntry = '/phone-entry';
  static const String otpVerify = '/otp-verify';
  static const String login = '/login';
  static const String profileSetup = '/profile-setup';
  static const String vendorHome = '/vendor';
  static const String customerHome = '/customer';
  static const String staffHome = '/staff-home';
  static const String staffCustomers = '/staff-home/customers';
  static const String staffPay = '/staff-home/pay';
  static const String staffQuickDelivery = '/staff-home/quick-delivery';
  static const String staffDeliveries = '/staff-home/deliveries';
  static const String customerKhatas = '/customer/khatas';
  static const String customerPayments = '/customer/payments';
  static const String customerProfile = '/customer/profile';
  static const String sharedLedger = '/ledger';
  static const String scanBill = '/scan-bill';
  static const String billDetailsForm = '/bill-details';
  static const String staffManagement = '/staff';
  static const String notifications = '/notifications';
  static const String vendorBookings = '/booking';
  static const String vendorScheduleSetup = '/booking/schedule';
  static const String customerBookings = '/customer/booking';
  static const String upiPayment = '/upi-payment';
  static const String reports = '/reports';
  static const String allCustomers = '/vendor/customers';
  static const String customerDetail = '/vendor/customer-detail';
  static const String outstandingList = '/vendor/outstanding';
  static const String collectedToday = '/vendor/collected-today';
  static const String allCustomersReport = '/reports/all-customers';
  static const String customerDetailReport = '/reports/customer-detail';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String bookAppointment = '/book-appointment';
  static const String locationPicker = '/location-picker';
  static const String changePassword = '/change-password';
  static const String policy = '/policy';
  static const String upiManagement = '/upi-management';
  static const String vendorSearch = '/vendor-search';
  static const String vendorProfile = '/vendor-profile';
  static const String linkRequestDetail = '/link-request';
  static const String customerLinkRequestDetail = '/customer-link-request';
  static const String membershipPlans = '/membership-plans';
  static const String membersDashboard = '/membership-members';
  static const String membershipRequests = '/membership-requests';
  static const String bulkCharge = '/bulk-charge';
  static const String emailLogin = '/email-login';
  static const String emailSignup = '/email-signup';
  static const String vendorOrders = '/vendor/orders';
  static const String customerOrders = '/customer/orders';
  static const String staffOrders = '/staff-home/orders';
  static const String placeOrder = '/place-order';
  static const String ledgerPreferences = '/settings/ledger-preferences';
  static const String vendorSchedule = '/vendor/schedule';
  static const String customerSchedule = '/customer/schedule';

  // Routes accessible without authentication
  static const _publicRoutes = {
    splash,
    languageSelection,
    onboarding,
    roleSelection,
    phoneEntry,
    otpVerify,
    login,
    emailLogin,
    emailSignup,
    profileSetup,
    locationPicker,
  };

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: getIt<AuthStateNotifier>(),
    redirect: (context, state) {
      final authState = getIt<AuthStateNotifier>().authState;
      final location = state.uri.path;
      final isPublic =
          _publicRoutes.contains(location) || location.startsWith(profileSetup);

      if (authState is AuthAuthenticated) {
        // Redirect authenticated users off any public/auth screen
        if (isPublic) {
          final user = authState.user;
          if (user.isStaff) return staffHome;
          return user.isVendor ? vendorHome : customerHome;
        }
      }

      if (authState is AuthUnauthenticated) {
        // Block protected routes for unauthenticated users
        if (!isPublic) return roleSelection;
      }

      return null; // no redirect
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: phoneEntry,
        builder: (context, state) {
          final role = state.extra as String? ?? 'vendor';
          return PhoneEntryScreen(role: role);
        },
      ),
      GoRoute(
        path: otpVerify,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpVerifyScreen(
            phone: extra['phone'] as String? ?? '',
            role: extra['role'] as String? ?? 'vendor',
            resendAfterSeconds: (extra['resendAfterSeconds'] as num?)?.toInt() ?? 30,
            codeLength: (extra['codeLength'] as num?)?.toInt() ?? 5,
          );
        },
      ),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: emailLogin,
        builder: (context, state) {
          final role = state.extra as String? ?? 'vendor';
          return EmailLoginScreen(role: role);
        },
      ),
      GoRoute(
        path: emailSignup,
        builder: (context, state) {
          final role = state.extra as String? ?? 'vendor';
          return EmailSignupScreen(role: role);
        },
      ),
      GoRoute(
        path: profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      // Vendor Flow with ShellRoute
      ShellRoute(
        builder: (context, state, child) {
          return VendorMainWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: vendorHome,
            builder: (context, state) => const VendorDashboard(),
          ),
          GoRoute(
            path: reports,
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: staffManagement,
            builder: (context, state) => const StaffManagementScreen(),
          ),
          GoRoute(
            path: vendorBookings,
            builder: (context, state) => const VendorBookingsScreen(),
          ),
          GoRoute(
            path: vendorSchedule,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      ServicesCubit(getIt<ScheduleRepository>())..load(),
                ),
                BlocProvider(
                  create: (_) =>
                      SubscriptionsCubit(getIt<ScheduleRepository>()),
                ),
                BlocProvider(
                  create: (_) =>
                      DeliveriesCubit(getIt<ScheduleRepository>())..load(),
                ),
              ],
              child: const VendorServicesScreen(),
            ),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Customer Flow with ShellRoute
      ShellRoute(
        builder: (context, state, child) {
          return CustomerMainWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: customerHome,
            builder: (context, state) => const CustomerDashboard(),
          ),
          GoRoute(
            path: customerKhatas,
            builder: (context, state) => const MyKhatasScreen(),
          ),
          GoRoute(
            path: customerPayments,
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: customerProfile,
            builder: (context, state) => const CustomerProfileScreen(),
          ),
          GoRoute(
            path: customerBookings,
            builder: (context, state) => const CustomerBookingsScreen(),
          ),
          GoRoute(
            path: customerSchedule,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      MySubscriptionsCubit(getIt<ScheduleRepository>())..load(),
                ),
                BlocProvider(
                  create: (_) => DeliveriesCubit(
                    getIt<ScheduleRepository>(),
                    isCustomer: true,
                  )..load(),
                ),
              ],
              child: const CustomerSubscriptionsScreen(),
            ),
          ),
        ],
      ),
      // Staff (labour) Flow with ShellRoute
      ShellRoute(
        builder: (context, state, child) => StaffMainWrapper(child: child),
        routes: [
          GoRoute(
            path: staffHome,
            builder: (context, state) => const StaffHomeScreen(),
          ),
          GoRoute(
            path: staffCustomers,
            builder: (context, state) => const StaffCustomersScreen(),
          ),
          GoRoute(
            path: staffPay,
            builder: (context, state) => const StaffPayScreen(),
          ),
          GoRoute(
            path: staffQuickDelivery,
            builder: (context, state) => const StaffQuickDeliveryScreen(),
          ),
          GoRoute(
            path: staffDeliveries,
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  DeliveriesCubit(getIt<ScheduleRepository>())..load(),
              child: const StaffDeliveriesScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: outstandingList,
        builder: (context, state) => const OutstandingListScreen(),
      ),
      GoRoute(
        path: collectedToday,
        builder: (context, state) => const CollectedTodayScreen(),
      ),
      GoRoute(
        path: allCustomers,
        builder: (context, state) => const AllCustomersScreen(),
      ),
      GoRoute(
        path: customerDetail,
        builder: (context, state) {
          final customer = state.extra as CustomerLinkItem;
          return CustomerDetailScreen(customer: customer);
        },
      ),
      GoRoute(
        path: vendorOrders,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderBloc(getIt<OrderRepository>()),
          child: const VendorOrdersScreen(),
        ),
      ),
      GoRoute(
        path: customerOrders,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderBloc(getIt<OrderRepository>()),
          child: const CustomerOrdersScreen(),
        ),
      ),
      GoRoute(
        path: staffOrders,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderBloc(getIt<OrderRepository>()),
          child: const StaffOrdersScreen(),
        ),
      ),
      GoRoute(
        path: placeOrder,
        builder: (context, state) {
          final vendor = state.extra as VendorLinkItem;
          return BlocProvider(
            create: (_) => OrderBloc(getIt<OrderRepository>()),
            child: PlaceOrderScreen(vendor: vendor),
          );
        },
      ),
      GoRoute(
        path: allCustomersReport,
        builder: (context, state) => const AllCustomersReportScreen(),
      ),
      GoRoute(
        path: bulkCharge,
        builder: (context, state) => const BulkChargeScreen(),
      ),
      GoRoute(
        path: sharedLedger,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return SharedLedgerScreen(
            linkId: extras['linkId'] as String,
            customerName: extras['name'] as String,
            isVendorView: extras['isVendorView'] as bool? ?? true,
            isStaffView: extras['isStaffView'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: customerDetailReport,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return CustomerDetailReportScreen(
            linkId: extras['linkId'] as String,
            customerName: extras['name'] as String,
          );
        },
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: upiPayment,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return UpiPaymentScreen(
            amount: (extras['amount'] as num).toDouble(),
            recipientName: extras['recipientName'] as String,
            upiId: extras['upiId'] as String?,
          );
        },
      ),
      GoRoute(
        path: scanBill,
        builder: (context, state) => const ScanBillScreen(),
      ),
      GoRoute(
        path: billDetailsForm,
        builder: (context, state) => const BillDetailsFormScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) {
          final user = state.extra as UserModel;
          return EditProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: policy,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return PolicyScreen(
            title: extras['title'] as String,
            endpoint: extras['endpoint'] as String,
          );
        },
      ),
      GoRoute(
        path: vendorScheduleSetup,
        builder: (context, state) => const VendorScheduleSetupScreen(),
      ),
      GoRoute(
        path: bookAppointment,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return BookAppointmentScreen(
            vendorId: extras['vendorId'] as String,
            vendorName: extras['vendorName'] as String,
          );
        },
      ),
      GoRoute(
        path: locationPicker,
        builder: (context, state) =>
            LocationPickerScreen(initialLocation: state.extra as LocationData?),
      ),
      GoRoute(
        path: upiManagement,
        builder: (context, state) {
          final user = state.extra as UserModel;
          return UpiManagementScreen(user: user);
        },
      ),
      GoRoute(
        path: ledgerPreferences,
        builder: (context, state) => const LedgerPreferencesScreen(),
      ),
      GoRoute(
        path: vendorSearch,
        builder: (context, state) {
          final viewAs = state.extra as SearchViewAs? ?? SearchViewAs.vendor;
          return VendorSearchScreen(viewAs: viewAs);
        },
      ),
      GoRoute(
        path: vendorProfile,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return VendorProfileScreen(
            preview: extras['result'] as VendorSearchResult,
            viewAs: extras['viewAs'] as SearchViewAs,
          );
        },
      ),
      GoRoute(
        path: linkRequestDetail,
        builder: (context, state) {
          final requestId = state.extra as String;
          return VendorLinkRequestScreen(requestId: requestId);
        },
      ),
      GoRoute(
        path: customerLinkRequestDetail,
        builder: (context, state) {
          final requestId = state.extra as String;
          return CustomerLinkRequestScreen(requestId: requestId);
        },
      ),
      GoRoute(
        path: membershipPlans,
        builder: (context, state) => const MembershipPlansScreen(),
      ),
      GoRoute(
        path: membersDashboard,
        builder: (context, state) => const MembersDashboardScreen(),
      ),
      GoRoute(
        path: membershipRequests,
        builder: (context, state) => const MembershipRequestsScreen(),
      ),
    ],
  );
}

class VendorMainWrapper extends StatefulWidget {
  final Widget child;
  const VendorMainWrapper({super.key, required this.child});

  @override
  State<VendorMainWrapper> createState() => _VendorMainWrapperState();
}

class _VendorMainWrapperState extends State<VendorMainWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  late final Animation<double> _fabOpacity;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    getIt<VendorBloc>().add(LoadVendorDashboard());
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
    _fabOpacity = _fabAnim;
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _fabVisible) {
        // scrolling down — hide
        _fabVisible = false;
        _fabAnim.reverse();
      } else if (delta < 0 && !_fabVisible) {
        // scrolling up — show
        _fabVisible = true;
        _fabAnim.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<VendorBloc>(),
      child: Builder(
        builder: (ctx) {
          final location = GoRouterState.of(ctx).uri.path;
          final isHome = location == AppRouter.vendorHome;
          final bottomInset = MediaQuery.of(ctx).padding.bottom;
          // Pill nav: 64 height + 16 bottom padding + 8 top padding = 88
          const navHeight = 88.0;

          return Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: widget.child,
                ),
                // FAB positioned above the floating pill nav bar
                if (isHome)
                  Positioned(
                    right: 16,
                    bottom: navHeight + bottomInset + 12,
                    child: FadeTransition(
                      opacity: _fabOpacity,
                      child: ScaleTransition(
                        scale: _fabScale,
                        child: FloatingActionButton.extended(
                          onPressed: () => showVendorAddCustomerSheet(ctx),
                          backgroundColor: AppColors.primary,
                          icon: const Icon(
                            Icons.person_add_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'ADD CUSTOMER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: _calculateSelectedIndex(ctx),
              onTap: (index) => _onTap(ctx, index),
              items: const [
                AppNavItem(riveIcon: AppRiveIcon.home, label: 'Home'),
                AppNavItem(riveIcon: AppRiveIcon.user, label: 'Staff'),
                AppNavItem(riveIcon: AppRiveIcon.zap, label: 'Booking'),
                AppNavItem(riveIcon: AppRiveIcon.clock, label: 'Schedule'),
                AppNavItem(riveIcon: AppRiveIcon.stars, label: 'Reports'),
                AppNavItem(riveIcon: AppRiveIcon.gear, label: 'Settings'),
              ],
            ),
          );
        },
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == AppRouter.vendorHome) return 0;
    if (location == AppRouter.staffManagement) return 1;
    if (location == AppRouter.vendorBookings) return 2;
    if (location == AppRouter.vendorSchedule) return 3;
    if (location.startsWith(AppRouter.reports)) return 4;
    if (location == AppRouter.settings) return 5;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.vendorHome);
        break;
      case 1:
        context.go(AppRouter.staffManagement);
        break;
      case 2:
        context.go(AppRouter.vendorBookings);
        break;
      case 3:
        context.go(AppRouter.vendorSchedule);
        break;
      case 4:
        context.go(AppRouter.reports);
        break;
      case 5:
        context.go(AppRouter.settings);
        break;
    }
  }
}

class CustomerMainWrapper extends StatefulWidget {
  final Widget child;
  const CustomerMainWrapper({super.key, required this.child});

  @override
  State<CustomerMainWrapper> createState() => _CustomerMainWrapperState();
}

class _CustomerMainWrapperState extends State<CustomerMainWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  late final Animation<double> _fabOpacity;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
    _fabOpacity = _fabAnim;
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _fabVisible) {
        _fabVisible = false;
        _fabAnim.reverse();
      } else if (delta < 0 && !_fabVisible) {
        _fabVisible = true;
        _fabAnim.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isHome = location == AppRouter.customerHome;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const navHeight = 88.0;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: widget.child,
          ),
          if (isHome)
            Positioned(
              right: 16,
              bottom: navHeight + bottomInset + 12,
              child: FadeTransition(
                opacity: _fabOpacity,
                child: ScaleTransition(
                  scale: _fabScale,
                  child: FloatingActionButton.extended(
                    onPressed: () => showCustomerAddVendorSheet(context),
                    backgroundColor: AppColors.customerAccent,
                    icon: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'ADD VENDOR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          AppNavItem(riveIcon: AppRiveIcon.home, label: 'Home'),
          AppNavItem(riveIcon: AppRiveIcon.message, label: 'My Khatas'),
          AppNavItem(riveIcon: AppRiveIcon.zap, label: 'Bookings'),
          AppNavItem(riveIcon: AppRiveIcon.clock, label: 'Schedule'),
          AppNavItem(riveIcon: AppRiveIcon.user, label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == AppRouter.customerHome) return 0;
    if (location == AppRouter.customerKhatas) return 1;
    if (location == AppRouter.customerBookings) return 2;
    if (location == AppRouter.customerSchedule) return 3;
    if (location == AppRouter.customerProfile) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.customerHome);
        break;
      case 1:
        context.go(AppRouter.customerKhatas);
        break;
      case 2:
        context.go(AppRouter.customerBookings);
        break;
      case 3:
        context.go(AppRouter.customerSchedule);
        break;
      case 4:
        context.go(AppRouter.customerProfile);
        break;
    }
  }
}

void showCustomerAddVendorSheet(BuildContext context) {
  final identifierCtrl = TextEditingController();
  final nicknameCtrl = TextEditingController();
  bool isLoading = false;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          // viewInsets clears the keyboard; viewPadding clears the gesture
          // bar / 3-button nav when the keyboard is closed.
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add a Vendor', style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              'Find by phone number or email',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: identifierCtrl,
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Phone or email',
                hintText: '10-digit mobile or email address',
                prefixIcon: Icon(Icons.storefront_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nicknameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
                hintText: 'How you know this vendor',
                prefixIcon: Icon(Icons.label_outline_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final identifier = identifierCtrl.text.trim();
                        if (identifier.isEmpty) return;
                        final nickname = nicknameCtrl.text.trim();
                        setSheetState(() => isLoading = true);
                        try {
                          await getIt<LinkRequestRepository>()
                              .customerSendByIdentifier(
                                vendorIdentifier: identifier,
                                nickname: nickname.isEmpty ? null : nickname,
                              );
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            AppToast.show(
                              context,
                              'Request sent! They will be notified to confirm.',
                              type: ToastType.success,
                            );
                          }
                        } catch (e) {
                          setSheetState(() => isLoading = false);
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              e.toString().replaceFirst('Exception: ', ''),
                              type: ToastType.error,
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customerAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Send Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
