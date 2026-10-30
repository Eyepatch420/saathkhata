class ApiEndpoints {
  /// Base URL for every API call.
  ///
  /// Defaults to the Android-emulator loopback alias (`10.0.2.2` = the host
  /// machine). Override at build time for a physical device on the same Wi-Fi
  /// or for a released build:
  ///
  ///   flutter build apk --dart-define=API_BASE_URL=http://192.168.0.107:3001/api/v1
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3001/api/v1',
  );

  // Auth — OTP
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';

  // Auth
  static const String signup = '/auth/signup';
  static const String login = '/auth/login'; // kept for legacy reference only
  static const String emailLogin = '/auth/email-login';
  static const String emailSignup = '/auth/email-signup';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/profile';
  static const String uploadPhoto = '/auth/profile/photo';
  static const String changePassword = '/auth/change-password';
  static const String deleteAccount = '/auth/account';
  static const String deleteAccountOtp = '/auth/account/delete-otp';

  // Content (public)
  static const String termsAndConditions = '/content/terms';
  static const String privacyPolicy = '/content/privacy';

  // Links
  static const String myCustomers = '/links/customers';
  static const String myVendors = '/links/vendors';
  static const String remindAll = '/links/remind-all';
  static String linkById(String id) => '/links/$id';
  static String vendorCustomerByLinkId(String linkId) => '/links/$linkId/customer-item';
  static String linkNickname(String id) => '/links/$id/nickname';
  static String linkDefaults(String id) => '/links/$id/defaults';
  static String linkAutoConfirm(String id) => '/links/$id/auto-confirm';

  // Ledger (nested under link)
  static String linkEntries(String linkId) => '/links/$linkId/entries';
  static String linkBalance(String linkId) => '/links/$linkId/entries/balance';
  static String confirmEntry(String linkId, String entryId) =>
      '/links/$linkId/entries/$entryId/confirm';
  static String disputeEntry(String linkId, String entryId) =>
      '/links/$linkId/entries/$entryId/dispute';
  static String attachToEntry(String linkId, String entryId) =>
      '/links/$linkId/entries/$entryId/attachment';

  // Voice entry (nested under link) — LLM-normalized ledger draft
  static String parseVoice(String linkId) => '/links/$linkId/voice/parse';

  // Payments (nested under link)
  static String linkPayments(String linkId) => '/links/$linkId/payments';
  static String settleLink(String linkId) => '/links/$linkId/payments/settle';

  // Notifications
  static const String notifications = '/notifications';
  static const String notifUnreadCount = '/notifications/unread-count';
  static const String notifReadAll = '/notifications/read-all';
  static String notifReadOne(String id) => '/notifications/$id/read';

  // Staff (vendor-only)
  static const String staff = '/staff';
  static String staffById(String id) => '/staff/$id';
  static String staffAttendance(String id) => '/staff/$id/attendance';
  static String staffPay(String id) => '/staff/$id/pay';
  static String staffAdvance(String id) => '/staff/$id/advance';
  static String staffAccrue(String id) => '/staff/$id/accrue';
  static String staffSalaryHistory(String id) => '/staff/$id/salary-history';
  static String staffAccess(String id) => '/staff/$id/access';
  // Staff self-service (logged-in staff member)
  static const String staffMe = '/staff/me';
  static const String staffMeSalaryHistory = '/staff/me/salary-history';
  static const String staffMeQr = '/staff/me/qr';

  // Bookings
  static const String bookings = '/bookings';
  static const String bookingConfig = '/bookings/config';
  static const String bookingSlotFull = '/bookings/config/slot-full';
  static String publicSlots(String vendorId) => '/bookings/slots/$vendorId';
  static const String vendorBookings = '/bookings/vendor';
  static const String customerBookings = '/bookings/customer';
  static String bookingById(String id) => '/bookings/$id';
  // Per-date slot overrides / capacity / replicate / merge
  static String dateSlots(String date) => '/bookings/date-slots/$date';
  static String dateSlotsClosed(String date) => '/bookings/date-slots/$date/closed';
  static const String replicateDateSlots = '/bookings/date-slots/replicate';
  static const String mergeDateSlots = '/bookings/date-slots/merge';

  // Device tokens (push notifications)
  static const String registerDevice = '/devices/token';

  // Link Requests
  static const String linkRequests = '/link-requests';
  static const String vendorSendLinkRequest = '/link-requests/vendor-send';
  static const String customerSendLinkRequest = '/link-requests/customer-send';
  static const String pendingLinkRequests = '/link-requests/pending';
  static const String pendingCustomerLinkRequests = '/link-requests/pending-customer';
  static const String sentLinkRequests = '/link-requests/sent';
  static const String vendorSentLinkRequests = '/link-requests/vendor-sent';
  static String linkRequestById(String id) => '/link-requests/$id';
  static String acceptLinkRequest(String id) => '/link-requests/$id/accept';
  static String declineLinkRequest(String id) => '/link-requests/$id/decline';

  // Memberships (Phase 3 — plans)
  static const String membershipPlans = '/memberships/plans';
  static String membershipPlanById(String id) => '/memberships/plans/$id';
  static const String membersDashboard = '/memberships/members';
  static String useBenefit(String membershipId) =>
      '/memberships/members/$membershipId/use-benefit';
  static String decrementBenefit(String membershipId) =>
      '/memberships/members/$membershipId/decrement-benefit';
  static String membershipStatus(String linkId) => '/memberships/links/$linkId';
  static String enrollMember(String linkId) => '/memberships/links/$linkId/enroll';
  static String requestMembership(String linkId) => '/memberships/links/$linkId/request';
  static const String pendingMembershipRequests = '/memberships/requests/pending';
  static String approveMembershipRequest(String id) =>
      '/memberships/requests/$id/approve';
  static String declineMembershipRequest(String id) =>
      '/memberships/requests/$id/decline';

  // Product Templates (vendor + staff)
  static const String productTemplates = '/templates';
  static String productTemplateById(String id) => '/templates/$id';
  static const String bulkCharge = '/templates/bulk-charge';

  // Search (authenticated — both roles)
  static const String searchVendors = '/search/vendors';
  static String vendorPublicProfile(String vendorId) => '/search/vendors/$vendorId';

  // Orders
  static const String placeOrder = '/orders';
  static const String placeOrderForCustomer = '/orders/vendor';
  static const String vendorOrders = '/orders/vendor';
  static const String customerOrders = '/orders/customer';
  static const String staffOrders = '/orders/staff';
  static String updateOrderStatus(String id) => '/orders/$id/status';

  // Reports (vendor-only)
  static const String reportSummary = '/reports/summary';
  static const String reportCustomers = '/reports/customers';
  static String reportCustomerDetail(String linkId) => '/reports/customers/$linkId';
  static const String reportOutstanding = '/reports/outstanding';
  static const String reportCollectedToday = '/reports/collected-today';
  static const String reportMonthly = '/reports/monthly';

  // Schedule (F005)
  static const String scheduleServices = '/schedule/services';
  static String scheduleServiceById(String id) => '/schedule/services/$id';
  static String scheduleServiceSubscriptions(String serviceId) =>
      '/schedule/services/$serviceId/subscriptions';
  static const String scheduleSubscriptions = '/schedule/subscriptions';
  static String scheduleSubscriptionById(String id) => '/schedule/subscriptions/$id';
  static String scheduleSubscriptionPause(String id) => '/schedule/subscriptions/$id/pause';
  static String scheduleSubscriptionResume(String id) => '/schedule/subscriptions/$id/resume';
  static const String scheduleDeliveries = '/schedule/deliveries';
  static String scheduleDeliveryDeliver(String id) => '/schedule/deliveries/$id/deliver';
  static String scheduleDeliverySkip(String id) => '/schedule/deliveries/$id/skip';
  static const String scheduleMySubscriptions = '/schedule/my/subscriptions';
  static const String scheduleMyDeliveries = '/schedule/my/deliveries';
}
