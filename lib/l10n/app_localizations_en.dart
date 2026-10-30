// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Saath Khata';

  @override
  String get tagline => 'Ek Khata, Dono Ka';

  @override
  String get onboarding1Title => 'Two-Sided Shared Ledger';

  @override
  String get onboarding1Subtitle =>
      'One Ledger for both Vendor and Customer. Both see the same truth.';

  @override
  String get onboarding2Title => 'Voice & Bill OCR';

  @override
  String get onboarding2Subtitle =>
      'Speak or scan bills to create entries instantly in 12 languages.';

  @override
  String get onboarding3Title => 'One-Tap UPI Payment';

  @override
  String get onboarding3Subtitle =>
      'Settle your month-end dues with a single tap via UPI.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get chooseLanguage => 'Choose Your Language';

  @override
  String get continueButton => 'Continue';

  @override
  String get chooseRole => 'Choose Your Role';

  @override
  String get vendor => 'Vendor';

  @override
  String get customer => 'Customer';

  @override
  String get welcomeToSaathKhata => 'Welcome to SaathKhata';

  @override
  String get tellUsHowYouUse => 'Tell us how you will use the app';

  @override
  String get vendorRoleTitle => 'I am a Vendor / Seller';

  @override
  String get vendorRoleSubtitle =>
      'Manage my business ledger, staff, and collect payments.';

  @override
  String get customerRoleTitle => 'I am a Customer / Buyer';

  @override
  String get customerRoleSubtitle =>
      'Track my khata with local vendors and pay via UPI.';

  @override
  String get loginTitle => 'Login to SaathKhata';

  @override
  String get enterMobile => 'Enter your credentials to continue';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get verifyAndContinue => 'Verify & Continue';

  @override
  String get changePhoneNumber => 'Change Phone Number';

  @override
  String otpSentTo(String phoneNumber) {
    return 'Enter the code sent to +91 $phoneNumber';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get pleaseEnterCredentials => 'Please enter email and password';

  @override
  String get fillRequiredFields => 'Please fill in name, email and password';

  @override
  String get passwordMinChars => 'Minimum 8 characters';

  @override
  String get completeProfile => 'Complete Profile';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get egBusinessName => 'e.g. Krishna Dairy';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get enterAddress => 'Enter area or full address';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'Full Name';

  @override
  String get businessName => 'Business Name';

  @override
  String get businessCategory => 'Business Category';

  @override
  String get businessAddress => 'Business Address (Optional)';

  @override
  String get upiId => 'UPI ID (For Payments)';

  @override
  String get vendorDashboard => 'Vendor Dashboard';

  @override
  String get customerDashboard => 'Customer Dashboard';

  @override
  String get customerMode => 'Customer Mode';

  @override
  String get myVendors => 'My Vendors';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get collectedToday => 'Collected Today';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get scanBill => 'Scan Bill';

  @override
  String get remindAll => 'Remind All';

  @override
  String get addNew => 'Add New';

  @override
  String get recentCustomers => 'Recent Customers';

  @override
  String get viewAll => 'View All';

  @override
  String customerAddedSnackbar(String name) {
    return '$name added';
  }

  @override
  String get sharedLedger => 'Shared Ledger';

  @override
  String get totalBalance => 'TOTAL BALANCE';

  @override
  String get statement => 'Statement';

  @override
  String get giveCredit => 'AMOUNT PENDING';

  @override
  String get recordPayment => 'AMOUNT RECEIVED';

  @override
  String get giveCreditSheet => 'Amount Pending';

  @override
  String get recordPaymentSheet => 'Amount Received';

  @override
  String get filterAll => 'All';

  @override
  String get balanceCustomerOwes => 'Customer owes you';

  @override
  String get balanceYouOwe => 'You owe customer';

  @override
  String get balanceSettled => 'Settled';

  @override
  String get balanceYouOweVendor => 'You owe vendor';

  @override
  String get balanceVendorOwesYou => 'Vendor owes you';

  @override
  String get ledgerInfoTitle => 'How this ledger works';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusConfirmedDesc =>
      'Both parties agreed. Entry is locked and cannot be changed.';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusPendingDesc =>
      'Awaiting customer confirmation. Auto-confirmed after 72 hours.';

  @override
  String get statusDisputed => 'Disputed';

  @override
  String get statusDisputedDesc =>
      'Customer raised a dispute. Vendor review required.';

  @override
  String get statusAutoConfirmed => 'Auto-Confirmed';

  @override
  String get entryTypeCreditLabel => 'Credit Entry';

  @override
  String get entryTypePaymentLabel => 'Payment Received';

  @override
  String get entryDetails => 'Entry Details';

  @override
  String get entryAmount => 'Amount';

  @override
  String get entryType => 'Type';

  @override
  String get entryTypeCreditGiven => 'Credit (Given)';

  @override
  String get entryTypePaymentReceived => 'Payment (Received)';

  @override
  String get entryDate => 'Date';

  @override
  String get entryDescription => 'Description';

  @override
  String get entryQuantity => 'Quantity';

  @override
  String get entryConfirmedAt => 'Confirmed At';

  @override
  String get entryDisputeReason => 'Dispute Reason';

  @override
  String entryFor(String name) {
    return 'for $name';
  }

  @override
  String get description => 'Description';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get quantityOptional => 'Quantity (optional)';

  @override
  String get descriptionHint => 'e.g. 2L Milk, Monthly groceries';

  @override
  String get quantityHint => 'e.g. 2';

  @override
  String get addCreditEntry => 'ADD CREDIT ENTRY';

  @override
  String get noLedgerTransactions => 'No transactions yet';

  @override
  String get noLedgerTransactionsSubtitle =>
      'Add a credit or payment entry to get started.';

  @override
  String get confirmEntryTitle => 'Confirm Entry';

  @override
  String confirmEntryMessage(String amount) {
    return 'Are you sure you want to confirm ₹$amount entry? This action cannot be undone.';
  }

  @override
  String get dispute => 'Dispute';

  @override
  String get raiseDisputeTitle => 'Raise a Dispute';

  @override
  String get raiseDisputeSubtitle =>
      'Describe what is incorrect about this entry.';

  @override
  String get raiseDisputeHint => 'e.g. Amount should be ₹50, not ₹60';

  @override
  String get submitDispute => 'Submit Dispute';

  @override
  String get staffAndLabour => 'Staff & Labour';

  @override
  String get addStaff => 'Add Staff';

  @override
  String get presentToday => 'Present Today';

  @override
  String get unpaidSalary => 'Unpaid Salary';

  @override
  String get paySalary => 'Pay Salary';

  @override
  String get noStaffAdded => 'No staff added yet';

  @override
  String get noStaffAddedSubtitle =>
      'Tap the button below to add your first staff member.';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get halfDay => 'Half Day';

  @override
  String get paySalaryTitle => 'Pay Salary';

  @override
  String unpaidLabel(String amount) {
    return 'Unpaid: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI Transaction ID (optional)';

  @override
  String get noDues => 'No Dues';

  @override
  String staffPayAmount(String amount) {
    return 'Pay ₹$amount';
  }

  @override
  String staffJoined(String date) {
    return 'Joined $date';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/day';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/month';
  }

  @override
  String get staffPayButton => 'Pay';

  @override
  String get businessReports => 'Business Reports';

  @override
  String get revenueTrend => 'Revenue Trend';

  @override
  String get collectionSummary => 'Collection Summary';

  @override
  String get totalOutstanding => 'Total Outstanding';

  @override
  String get totalCollected => 'Total Collected';

  @override
  String get topCustomers => 'Top Customers';

  @override
  String get seeAll => 'See All';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get settingsManagePayments => 'Manage payment accounts';

  @override
  String get settingsManageAlerts => 'Manage alerts and reminders';

  @override
  String get settingsAppPinFingerprint => 'App PIN and Fingerprint';

  @override
  String get settingsFaqsContact => 'FAQs and Contact Us';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get myUpiIds => 'My UPI IDs';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get logout => 'Logout';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotificationsTitle => 'No notifications yet';

  @override
  String get noNotificationsSubtitle =>
      'You will see ledger updates, payment alerts and reminders here.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get payments => 'Payments';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get pending => 'Pending';

  @override
  String get quickPay => 'Quick Pay';

  @override
  String get scanAndPay => 'SCAN & PAY';

  @override
  String get scanUpiDesc => 'Scan any UPI QR to pay your vendor';

  @override
  String get noTransactionsTitle => 'No transactions yet';

  @override
  String get noTransactionsSubtitle => 'Your payment history will appear here.';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusFailed => 'Failed';

  @override
  String get paymentStatusRefunded => 'Refunded';

  @override
  String get appointments => 'Appointments';

  @override
  String get myAppointments => 'My Appointments';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get keepBooking => 'Keep';

  @override
  String get noBookingsToday => 'No bookings for this day';

  @override
  String get noBookingsTodaySubtitle =>
      'Customers can book appointments through the app.';

  @override
  String get noAppointmentsTitle => 'No appointments yet';

  @override
  String get noAppointmentsSubtitle =>
      'Book an appointment with your vendor to get started.';

  @override
  String get cancelAppointmentTitle => 'Cancel Appointment?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return 'Cancel your appointment on $date at $time?';
  }

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusDone => 'Done';

  @override
  String get upiPayment => 'UPI Payment';

  @override
  String get amountToPay => 'Amount to pay';

  @override
  String get securedByUpi => 'Secured by UPI';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String get retryPayment => 'Retry';

  @override
  String get enterUpiId => 'Enter UPI ID';

  @override
  String get addNoteOptional => 'Add a note (optional)';

  @override
  String payAmountButton(String amount) {
    return 'PAY ₹$amount';
  }

  @override
  String get done => 'DONE';

  @override
  String get paymentSomethingWentWrong =>
      'Something went wrong. Please try again.';

  @override
  String upiAppComingSoon(String app) {
    return '$app integration coming soon';
  }

  @override
  String get pleaseEnterUpiId => 'Please enter a UPI ID';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount paid to $name';
  }

  @override
  String get orDivider => 'OR';

  @override
  String get addNewCustomer => 'Add New Customer';

  @override
  String get customerName => 'Customer Name';

  @override
  String get mobileNo => 'Mobile Number';

  @override
  String get addCustomer => 'ADD CUSTOMER';

  @override
  String get paymentConfirmed => 'CONFIRM PAYMENT';

  @override
  String get addAdvance => 'Add Advance';

  @override
  String get addAdvanceTitle => 'ADD ADVANCE';

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get salaryTitle => 'Salary Summary';

  @override
  String get rate => 'Rate';

  @override
  String get daysPresent => 'Days Present';

  @override
  String get earned => 'Earned';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get advanceTaken => 'Advance Taken';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get joined => 'Joined';

  @override
  String get noPhone => 'No phone';

  @override
  String get addNewStaff => 'Add New Staff';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get role => 'Role';

  @override
  String get salaryType => 'Salary Type';

  @override
  String get dailyWage => 'Daily Wage';

  @override
  String get monthlySalary => 'Monthly Salary';

  @override
  String get dailyWageAmount => 'Daily Wage (₹)';

  @override
  String get monthlySalaryAmount => 'Monthly Salary (₹)';

  @override
  String get addStaffButton => 'ADD STAFF';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get amountRupees => 'Amount (₹)';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get alignBillInFrame => 'Align bill within the frame';

  @override
  String get verifyAndLogin => 'Verify & Login';

  @override
  String get voiceListening => 'Listening...';

  @override
  String get voiceThinking => 'Thinking...';

  @override
  String get voiceDetectedEntry => 'Detected Entry';

  @override
  String get voiceConfirmEntry => 'CONFIRM ENTRY';

  @override
  String get item => 'Item';

  @override
  String get totalOutstandingBalance => 'Total Outstanding Balance';

  @override
  String get payAllDues => 'PAY ALL DUES';

  @override
  String get myKhatas => 'My Khatas';

  @override
  String get noVendorsFound => 'No vendors found';

  @override
  String get verifyBillDetails => 'Verify Bill Details';

  @override
  String get scannedBillPreview => 'Scanned Bill Preview';

  @override
  String get descriptionItemDetails => 'Description / Item Details';

  @override
  String get selectCustomer => 'Select Customer';

  @override
  String get searchCustomerHint => 'Search or select customer';

  @override
  String get saveToKhata => 'SAVE TO KHATA';

  @override
  String get allCustomersReport => 'All Customers Report';

  @override
  String collectedInMonth(String month) {
    return 'Collected in $month';
  }

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get securityPin => 'Security & PIN';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get legalInfo => 'Legal';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get changePasswordButton => 'CHANGE PASSWORD';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get loadingContent => 'Loading...';

  @override
  String get failedToLoad => 'Failed to load content. Please try again.';

  @override
  String get bookingActions => 'Booking Actions';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get markComplete => 'Mark as Complete';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return 'Confirm the appointment on $date at $time for $customer?';
  }

  @override
  String get bookingUpdated => 'Booking updated successfully';

  @override
  String get bookingUpdateFailed => 'Failed to update booking';

  @override
  String markAttendanceFor(String date) {
    return 'Mark Attendance — $date';
  }

  @override
  String get allCustomers => 'All Customers';

  @override
  String get noCustomersYet => 'No customers yet';

  @override
  String get noCustomersYetSubtitle => 'Add your first customer to get started';

  @override
  String get invalidPhone =>
      'Enter a valid 10-digit mobile number starting with 6–9';

  @override
  String accrueMonthSalary(String amount) {
    return 'Add Month\'s Salary (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'Add Month\'s Salary';

  @override
  String get removeStaffTitle => 'Remove Staff Member';

  @override
  String removeStaffConfirm(String name) {
    return 'Remove $name from your staff? This will revoke their app access immediately.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return 'Add ₹$amount to $name\'s unpaid balance for this month?';
  }

  @override
  String get accountInformation => 'Account Information';

  @override
  String get updateProfileDetails => 'Update your name, photo and details';

  @override
  String get updateAccountPassword => 'Update your account password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently delete your account and all data';

  @override
  String get deleteAccountConfirmation => 'Delete Account?';

  @override
  String get deleteAccountConfirmationMessage =>
      'This will permanently delete your account and all your data. This action cannot be undone.';

  @override
  String get deleteAccountStaffWarning =>
      'This will permanently delete your account. This cannot be undone.';

  @override
  String get deleteAccountStrongWarning =>
      'Deleting your account is permanent and cannot be undone. Please read carefully before continuing:';

  @override
  String get deleteAccountWarningLoginRemoved =>
      'You will immediately lose the ability to log in.';

  @override
  String get deleteAccountWarningIrreversible =>
      'This action cannot be reversed — there is no way to recover your account afterward.';

  @override
  String get deleteAccountWarningRecordsKept =>
      'Your ledger entries, payments, delivery proofs and statements are kept for financial record-keeping and legal/audit purposes — they are never deleted.';

  @override
  String get deleteAccountWarningVendorBlockers =>
      'You must settle all outstanding balances, remove or pay staff, and resolve pending orders/deliveries and subscriptions before you can delete your account.';

  @override
  String get deleteAccountWarningStaffBlockers =>
      'You must have no unpaid salary, outstanding advance, or unfinished assigned work before you can delete your account.';

  @override
  String get deleteAccountWarningCustomerBlockers =>
      'You must settle all outstanding balances and have no active orders before you can delete your account.';

  @override
  String get iUnderstandContinue => 'I Understand, Continue';

  @override
  String get deleteAccountTypeToConfirmTitle => 'Type DELETE to confirm';

  @override
  String get deleteAccountTypeToConfirmMessage =>
      'To confirm you want to permanently delete your account, type DELETE below.';

  @override
  String get deleteAccountEnterOtpTitle => 'Enter OTP';

  @override
  String get deleteAccountEnterOtpMessage =>
      'We sent a 6-digit OTP to your registered phone number. Enter it to confirm account deletion.';

  @override
  String get deleteAccountEnterPasswordTitle => 'Enter your password';

  @override
  String get deleteAccountEnterPasswordMessage =>
      'Enter your account password to confirm account deletion.';

  @override
  String get deleteAccountBlockedTitle => 'Can\'t Delete Account Yet';

  @override
  String get deleteAccountBlockedMessage =>
      'Please resolve the following before deleting your account:';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get delete => 'Delete';

  @override
  String get readTermsOfService => 'Read our terms of service';

  @override
  String get privacyPolicyDescription => 'How we handle your data';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get membershipTiers => 'Membership Tiers';

  @override
  String get membershipTiersDescription =>
      'Rename tiers and set member discounts';

  @override
  String get logIn => 'Log in';

  @override
  String get enterPhoneNumberToContinue =>
      'Enter your phone number to continue';

  @override
  String get havingTrouble => 'Having trouble?';

  @override
  String get useEmailInstead => 'Use email instead →';

  @override
  String get logInWithEmail => 'Log in with email';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get tapToAddProfilePhoto => 'Tap to add profile photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get add => 'Add';

  @override
  String get addUpiId => 'Add UPI ID';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get remove => 'Remove';

  @override
  String get approve => 'Approve';

  @override
  String get decline => 'Decline';

  @override
  String get none => 'None';

  @override
  String get percent => 'Percent';

  @override
  String get profile => 'Profile';

  @override
  String get paymentVerification => 'Payment Verification';

  @override
  String get verifyingPayment => 'Verifying Payment';

  @override
  String get paymentConfirmedExclamation => 'Payment Confirmed!';

  @override
  String get verificationTimedOut => 'Verification Timed Out';

  @override
  String get goBack => 'Go Back';

  @override
  String get payDues => 'Pay Dues';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get allDone => 'All Done!';

  @override
  String get noUpcomingAppointments => 'No upcoming appointments';

  @override
  String get myPay => 'My Pay';

  @override
  String get myPaymentQr => 'My Payment QR';

  @override
  String get showMyQr => 'Show my QR';

  @override
  String get noPaymentsYet => 'No payments yet';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get paymentHistory6Months => 'Payment History (6 months)';

  @override
  String get connectionRequest => 'Connection Request';

  @override
  String get vendorWantsToConnect => 'A vendor wants to connect';

  @override
  String get acceptRequest => 'Accept';

  @override
  String get declineRequest => 'Decline';

  @override
  String get messageLabel => 'Message';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get requestSentNotification =>
      'Request sent! They will be notified to confirm.';

  @override
  String get awaitingAcceptance => 'Awaiting Acceptance';

  @override
  String get addAVendor => 'Add a Vendor';

  @override
  String get findByPhoneOrEmail => 'Find by phone number or email';

  @override
  String get phoneOrEmail => 'Phone or email';

  @override
  String get phoneOrEmailHint => '10-digit mobile or email address';

  @override
  String get nicknameOptional => 'Nickname (optional)';

  @override
  String get howYouKnowVendor => 'How you know this vendor';

  @override
  String get bookingNoteExample => 'E.g. Need extra milk today';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get moveMapToSelectLocation => 'Move the map to select a location';

  @override
  String get searchPlaceHint => 'Search for a place…';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get searchVendorsHint => 'Search vendors…';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get payViaUpi => 'Pay via UPI';

  @override
  String get connectWithVendor => 'Connect';

  @override
  String get requestConnection => 'Request Connection';

  @override
  String get addVendor => 'Add Vendor';

  @override
  String get noOutstandingBalances => 'No outstanding balances';

  @override
  String get allCustomersSettledUp => 'All customers are settled up.';

  @override
  String get nothingCollectedToday => 'Nothing collected today';

  @override
  String get paymentsWillAppearHere =>
      'Payments received today will appear here.';

  @override
  String get customerReport => 'Customer Report';

  @override
  String get overview => 'Overview';

  @override
  String get tapToStop => 'Tap to stop';

  @override
  String get itemName => 'Item name';

  @override
  String get itemNameExample => 'e.g. Milk';

  @override
  String get unitPrice => 'Unit Price ₹';

  @override
  String get deliverTo => 'Deliver to';

  @override
  String get bulkCharge => 'Bulk Charge';

  @override
  String get newProduct => 'New product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get newProductService => 'New Product / Service';

  @override
  String get updateProductDetails => 'Update name, unit or price';

  @override
  String get defineProduct => 'Define what you sell and its base price';

  @override
  String get productName => 'Product name';

  @override
  String get productNameExample => 'e.g. Daily Morning Milk';

  @override
  String get unit => 'Unit';

  @override
  String get unitExample => 'litre / kg / piece';

  @override
  String get pricePerUnit => 'Price / unit (₹)';

  @override
  String get deleteProduct => 'Delete product';

  @override
  String get deleteProductConfirmation => 'Delete product?';

  @override
  String removeProductConfirmation(String name) {
    return 'Remove \"$name\" from your product list?';
  }

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get addFirstProduct => 'Add First Product';

  @override
  String setPriceToChargeTitle(String name) {
    return 'Set a price for $name';
  }

  @override
  String get setPriceToChargeSubtitle =>
      'This service has no unit or price set yet. Add them to charge customers for it.';

  @override
  String get setPrice => 'Set Price';

  @override
  String get renameTier => 'Rename tier';

  @override
  String get tierName => 'Tier name';

  @override
  String tierLevel(int level) {
    return 'Level $level';
  }

  @override
  String get memberDiscount => 'Member discount';

  @override
  String discountFor(String tier) {
    return 'Discount for $tier';
  }

  @override
  String get flatAmount => 'Flat ₹';

  @override
  String get discountPercent => 'Discount %';

  @override
  String get discountAmount => 'Discount amount (₹)';

  @override
  String get percentExample => 'e.g. 5';

  @override
  String get amountExample => 'e.g. 50';

  @override
  String get maxDiscountPerDue => 'Max discount per due (₹) — optional';

  @override
  String get maxDiscountExample => 'e.g. 100 (leave blank for no cap)';

  @override
  String get saveDiscount => 'Save discount';

  @override
  String get membership => 'Membership';

  @override
  String get setTier => 'Set';

  @override
  String get changeTier => 'Change';

  @override
  String get applyMembership => 'Apply';

  @override
  String get removeMembership => 'Remove membership';

  @override
  String get removeLedgerConfirmation => 'Remove ledger?';

  @override
  String get exportStatement => 'Export Statement';

  @override
  String get appAccess => 'App access';

  @override
  String get invalidPhoneNumber =>
      'Enter a valid 10-digit Indian mobile number';

  @override
  String get enterAll6Digits => 'Enter all 6 digits';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get required => 'Required';

  @override
  String get invalidUpiFormat => 'Invalid UPI ID format (e.g. name@upi)';

  @override
  String get upiIdAlreadyAdded => 'This UPI ID is already added';

  @override
  String get verifyButton => 'Verify';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get mobileNumberLabel => 'Mobile Number';

  @override
  String get personalInfo => 'Personal Info';

  @override
  String get businessInfo => 'Business Info';

  @override
  String get enterOtpTitle => 'Enter OTP';

  @override
  String get sentToLabel => 'Sent to';

  @override
  String get noOtpReceived => 'Didn\'t receive it?';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get uploadingPhotoLabel => 'Uploading photo...';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get iAmA => 'I am a';

  @override
  String get dualRoleExplanation =>
      'You\'ll primarily use the Vendor experience. Your Customer account can be accessed separately.';

  @override
  String get profileSavedPhotoFailed =>
      'Profile saved — photo could not be uploaded right now';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get addUpiIdTitle => 'Add UPI ID';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get primaryUpiInfo => 'PRIMARY UPI ID';

  @override
  String get primaryUpiDescription =>
      'The primary ID is shared with customers for payment. Tap the star to switch which one is primary.';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI IDs';
  }

  @override
  String get primaryUpiIdTooltip => 'Primary UPI ID';

  @override
  String get setAsPrimaryTooltip => 'Set as primary';

  @override
  String get primaryLabel => 'Primary';

  @override
  String get removeButtonLabel => 'Remove';

  @override
  String get noUpiIdsEmpty => 'No UPI IDs yet';

  @override
  String get upiEmptyDescription =>
      'Add up to 5 UPI IDs. Your primary ID will be shared with customers for payment.';

  @override
  String get changePasswordSubtitle =>
      'Enter your current password and choose a new one.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get goBackButton => 'Go back';

  @override
  String get saveButton => 'Save';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageBengali => 'Bengali';

  @override
  String get languageMarathi => 'Marathi';

  @override
  String get languageTamil => 'Tamil';

  @override
  String get languageTelugu => 'Telugu';

  @override
  String get languageKannada => 'Kannada';

  @override
  String get languageGujarati => 'Gujarati';

  @override
  String get languagePunjabi => 'Punjabi';

  @override
  String get languageMalayalam => 'Malayalam';

  @override
  String get languageBhojpuri => 'Bhojpuri';

  @override
  String get languageMaithili => 'Maithili';

  @override
  String get needPasswordForEmail =>
      'You need a password set on your account to use this.\nSet one from Settings → Change Password.';

  @override
  String get usePhoneInstead => 'Use phone number instead →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'Session expired. Please verify your phone again.';

  @override
  String get upiIdsSavedSuccessfully => 'UPI IDs saved successfully';

  @override
  String get chooseYourLanguageHindi => 'आपकी भाषा चुनें';

  @override
  String get unknownLanguage => 'Unknown';

  @override
  String get businessCategoryMilkDairy => 'Milk / Dairy';

  @override
  String get businessCategoryPressDhobi => 'Press / Dhobi';

  @override
  String get businessCategoryMaidCook => 'Maid / Cook';

  @override
  String get businessCategoryNewspaper => 'Newspaper';

  @override
  String get businessCategoryWaterCan => 'Water Can';

  @override
  String get businessCategoryTiffinFood => 'Tiffin / Food';

  @override
  String get businessCategoryKiranaGrocery => 'Kirana / Grocery';

  @override
  String get businessCategorySalonParlour => 'Salon / Parlour';

  @override
  String get businessCategoryConstructionLabour => 'Construction Labour';

  @override
  String get businessCategoryTransportAuto => 'Transport / Auto';

  @override
  String get businessCategoryOther => 'Other';

  @override
  String get bookAnAppointment => 'Book an Appointment';

  @override
  String get noSlotsAvailable => 'No slots available';

  @override
  String get trySelectingDifferentDate => 'Try selecting a different date';

  @override
  String get availableSlots => 'Available Slots';

  @override
  String get bookingConfirmedToast => 'Booking confirmed!';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get editProductMenuItem => 'Edit product';

  @override
  String get deleteProductMenuItem => 'Delete product';

  @override
  String get noProductsYetDescription =>
      'Define the items you sell — milk, paneer, etc. — once, then use them every day.';

  @override
  String get selectProductToAssignQty =>
      'Select a product above to assign quantities';

  @override
  String get noCustomersLinked => 'No customers linked yet';

  @override
  String get chargeAll => 'Charge All';

  @override
  String chargedSuccessfully(int count) {
    return 'Charged $count customer successfully';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return 'Charged $count customers successfully';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok charged, $fail failed';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count customer  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count customers  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return '₹$amount total';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'Next: $vendorName · $date at $time';
  }

  @override
  String get outstandingShortLabel => 'outstanding';

  @override
  String payViaUpiAmount(String amount) {
    return 'Pay ₹$amount via UPI';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return 'Paid $count vendors, skipped $skipped.';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return 'Paid $count vendor, skipped $skipped.';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'Paid all $count vendors.';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'Paid all $count vendor.';
  }

  @override
  String get tapToAcceptOrDecline => 'Tap to accept or decline';

  @override
  String get helpSupportContactPrefix =>
      'For any assistance, reach out to us at:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'Book';

  @override
  String waitingForVendorAcceptance(String name) {
    return 'Waiting for $name to accept your request.';
  }

  @override
  String get vendorWantsToConnectAsCustomer => 'A vendor wants to connect';

  @override
  String get vendorWantsToConnectDesc =>
      'They want to add you as a customer and track your account.';

  @override
  String get someoneWantsToConnect => 'Someone wants to connect';

  @override
  String get someoneWantsToConnectDesc =>
      'They will be added as a customer to your account.';

  @override
  String requestedTimeAgo(String time) {
    return 'Requested $time';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'Connected! $name is now linked to your account.';
  }

  @override
  String requestDeclinedFrom(String name) {
    return 'Request from $name declined.';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'Connected! $name is now linked to your business.';
  }

  @override
  String get processing => 'Processing…';

  @override
  String get retryButton => 'Retry';

  @override
  String get memberDiscountDescription =>
      'Members on this tier get this discount on their dues.';

  @override
  String get discountValueInvalid => 'Enter a valid amount greater than 0';

  @override
  String get percentageExceedsMax => 'Percentage cannot exceed 100';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get rename => 'Rename';

  @override
  String get membershipLabel => 'Membership';

  @override
  String get noMembership => 'No membership';

  @override
  String get applyForMembership => 'Apply for membership';

  @override
  String get setMembershipTier => 'Set membership tier';

  @override
  String get chooseTierToRequestFromVendor =>
      'Choose a tier to request from this vendor';

  @override
  String chooseTierFor(String customerName) {
    return 'Choose a tier for $customerName';
  }

  @override
  String get setButton => 'Set';

  @override
  String get changeButton => 'Change';

  @override
  String get applyButton => 'Apply';

  @override
  String get approveButton => 'Approve';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName requested $tierName';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return 'Requested $tierName — awaiting approval';
  }

  @override
  String get verificationConnecting => 'Connecting to your bank…';

  @override
  String get verificationVerifying => 'Verifying transaction…';

  @override
  String get verificationWaiting => 'Waiting for confirmation…';

  @override
  String get verificationAlmostThere => 'Almost there…';

  @override
  String get verificationDoNotClose => 'Do not close this screen';

  @override
  String verificationElapsed(int seconds) {
    return '${seconds}s  •  Do not close this screen';
  }

  @override
  String txnLabel(String txnId) {
    return 'Txn: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '₹$amount paid to $name';
  }

  @override
  String get verificationTimeoutBody =>
      'We could not confirm your payment within 30 seconds. Your money may NOT have been debited — please check your bank statement before retrying.';

  @override
  String get ifDebitedContactSupport =>
      'If debited, contact support with Txn ID.';

  @override
  String get thisMonthSubtitle => 'This month';

  @override
  String get billedNet => 'Billed (net)';

  @override
  String get exclDisputed => 'excl. disputed';

  @override
  String get receivedLabel => 'Received';

  @override
  String get paymentsAndAdj => 'payments & adj.';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String paymentCount(int count) {
    return '$count payment';
  }

  @override
  String paymentCountPlural(int count) {
    return '$count payments';
  }

  @override
  String customersCount(int count) {
    return '$count customers';
  }

  @override
  String get rankedByOutstanding => 'Ranked by outstanding balance';

  @override
  String collectedThisMonth(String amount) {
    return '₹$amount this month';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return '₹$amount this mo.';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get findVendorsNearYou => 'Find vendors near you';

  @override
  String get searchByNameOrCategory =>
      'Search by name, business name,\nor select a category above.';

  @override
  String noResultsForQuery(String query) {
    return 'No results for \"$query\".\nTry a different name or category.';
  }

  @override
  String get addressLabel => 'Address';

  @override
  String get emailLabel => 'Email';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiEmailLabel => 'UPI / Email';

  @override
  String get couldNotLoadRetry => 'Could not load — tap to retry';

  @override
  String labelCopied(String label) {
    return '$label copied!';
  }

  @override
  String get upiIdCopied => 'UPI ID copied!';

  @override
  String get requestSentButton => 'Request Sent';

  @override
  String get alreadyConnected => 'Already Connected';

  @override
  String get sendingEllipsis => 'Sending…';

  @override
  String get sendConnectionRequest => 'Send Connection Request';

  @override
  String get copyUpiIdToPay => 'Copy UPI ID to Pay';

  @override
  String requestSentToVendor(String name) {
    return 'Request sent! $name will be notified.';
  }

  @override
  String byOwnerName(String name) {
    return 'by $name';
  }

  @override
  String get logOut => 'Log out';

  @override
  String get confirmLogoutTitle => 'Log out';

  @override
  String get areYouSureLogout => 'Are you sure you want to log out?';

  @override
  String get showQrToCollect =>
      'Show this QR to a customer to collect payment directly to you.';

  @override
  String get uploadQr => 'Upload QR';

  @override
  String get replaceQr => 'Replace';

  @override
  String get qrUploaded => 'QR uploaded';

  @override
  String scanToPayName(String name) {
    return 'Scan to pay $name';
  }

  @override
  String get salarySingle => 'Salary';

  @override
  String get advanceSingle => 'Advance';

  @override
  String get customersTitle => 'Customers';

  @override
  String balanceDue(String balance) {
    return '₹$balance due';
  }

  @override
  String get recordDeliveryTooltip => 'Record delivery';

  @override
  String get viewLedgerTooltip => 'View ledger';

  @override
  String staffRoleSubtitle(String name) {
    return 'Staff · $name';
  }

  @override
  String get recordDelivery => 'Amount Pending';

  @override
  String get recordDeliverySubtitle =>
      'Customer took goods — add to their khata';

  @override
  String get collectPayment => 'Amount Received';

  @override
  String get collectPaymentSubtitle => 'Customer paid — reduce their khata';

  @override
  String get viewAll2 => 'View all';

  @override
  String get noCustomersStaff => 'No customers yet';

  @override
  String get myVendorsSection => 'My Vendors';

  @override
  String get shopsYouBuyFrom => 'Shops you buy from';

  @override
  String get awaitingAcceptanceTitle => 'Awaiting Acceptance';

  @override
  String get customersHaventConfirmed =>
      'These customers haven\'t confirmed yet';

  @override
  String get pendingBadge => 'Pending';

  @override
  String get notifyCustomersWithDues => 'Notify customers with dues';

  @override
  String get linkANewCustomer => 'Link a new customer';

  @override
  String get dailyCharge => 'Daily Charge';

  @override
  String get dailyChargeSubtitle => 'Set quantities & charge all at once';

  @override
  String get findByPhoneOrEmailHint => 'Find by phone number or email';

  @override
  String get phoneOrEmailLabel => 'Phone or email';

  @override
  String get phoneMobileOrEmail => '10-digit mobile or email address';

  @override
  String get nicknameOptionalLabel => 'Nickname (optional)';

  @override
  String get howYouKnowCustomer => 'How you know this customer';

  @override
  String get requestSentWillBeNotified =>
      'Request sent! They will be notified to confirm.';

  @override
  String get outstandingTitle => 'Outstanding';

  @override
  String customersWithDues(int count) {
    return '$count+ customers with dues';
  }

  @override
  String get dueLabel => 'due';

  @override
  String get collectedTodayTitle => 'Collected Today';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ payments';
  }

  @override
  String get noPaymentsYetSubtitle => 'No payments yet';

  @override
  String removeLedgerVendorContent(String name) {
    return 'This will deactivate your link with $name. Both parties will lose access to this shared ledger.';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'This will remove your connection with $name.';
  }

  @override
  String get offlineUpdatesPaused => 'Offline — updates paused';

  @override
  String get exportStatementTitle => 'Export Statement';

  @override
  String get chooseExportDateRange =>
      'Choose the date range to include in the PDF.';

  @override
  String get last7DaysRange => 'Entries from the past 7 days';

  @override
  String get last30DaysRange => 'Entries from the past 30 days';

  @override
  String get last3MonthsRange => 'Entries from the past 3 months';

  @override
  String get completeLedgerHistory => 'Complete ledger history';

  @override
  String appAccessActive(String phone) {
    return 'Active · $phone';
  }

  @override
  String get appAccessDisabled => 'Disabled';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name can now log in with $phone';
  }

  @override
  String appAccessRevoked(String name) {
    return 'App access revoked for $name';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'When on, $name logs in with their own number ($phone) and can record deliveries & payments and show their own QR — but cannot change attendance, add customers, or see other staff.';
  }

  @override
  String get paymentHistoryTitle => 'Payment History';

  @override
  String get couldNotLoadPaymentHistory => 'Could not load payment history';

  @override
  String get voicePleaseCheck => 'Please check';

  @override
  String get navHome => 'Home';

  @override
  String get qty => 'Qty';

  @override
  String totalRupees(String amount) {
    return 'Total: ₹$amount';
  }

  @override
  String get selectCustomerFirst => 'Select a customer first';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get addsCredit => 'Customer took goods — add to their khata';

  @override
  String get recordsCash => 'Customer paid — reduce their khata';

  @override
  String deliveryRecordedFor(String name) {
    return 'Delivery recorded for $name';
  }

  @override
  String paymentCollectedFrom(String name) {
    return 'Payment collected from $name';
  }

  @override
  String get manageSchedule => 'Manage Schedule';

  @override
  String get bookingsTab => 'Bookings';

  @override
  String get bySlotTab => 'By Slot';

  @override
  String get scheduleSaved => 'Schedule saved!';

  @override
  String get addSlot => 'Add Slot';

  @override
  String noSlotsForDay(String day) {
    return 'No slots for $day';
  }

  @override
  String get tapAddSlotHint => 'Tap \"Add Slot\" to set your availability';

  @override
  String get slotAvailable => 'Available';

  @override
  String get slotsFull => 'Slots Full';

  @override
  String get slotFullHint => 'Mark this slot as fully booked';

  @override
  String get enableSlotFirst => 'Enable slot first';

  @override
  String get deleteSlotTitle => 'Delete Slot';

  @override
  String deleteSlotConfirm(String time) {
    return 'Remove the $time slot?';
  }

  @override
  String get endTimeAfterStart => 'End time must be after start time';

  @override
  String get slotOverlaps => 'This slot overlaps with an existing one';

  @override
  String get addTimeSlot => 'Add Time Slot';

  @override
  String get editTimeSlot => 'Edit Time Slot';

  @override
  String get selectTimeHint => 'Select start and end time in 12-hour format';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'End';

  @override
  String get update => 'Update';

  @override
  String get notifTabAll => 'All';

  @override
  String get notifTabBookings => 'Bookings';

  @override
  String get noBookingNotifications => 'No booking notifications';

  @override
  String get noBookingNotificationsSubtitle =>
      'Booking requests and updates will appear here';

  @override
  String get bookingPillLabel => 'Booking';

  @override
  String get slotDetailTitle => 'Slot Details';

  @override
  String bookingsCount(int count) {
    return '$count booking';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$count bookings';
  }

  @override
  String pendingCountLabel(int count) {
    return '$count pending';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'Keep';

  @override
  String get deleteButton => 'Delete';

  @override
  String get weeklyTemplateTab => 'Weekly Template';

  @override
  String get calendarTab => 'Calendar';

  @override
  String get usingWeeklyTemplate => 'Using weekly template';

  @override
  String get customForThisDate => 'Custom for this date';

  @override
  String get closedBadge => 'Closed';

  @override
  String get markAsClosed => 'Mark as closed';

  @override
  String get revertToTemplate => 'Revert to template';

  @override
  String get replicateToButton => 'Replicate to…';

  @override
  String get replicateTargetWeek => 'Week';

  @override
  String get replicateTargetMonth => 'Month';

  @override
  String get replicateTargetMultipleMonths => 'Multiple Months';

  @override
  String get replicateMonthsCount => 'Number of months';

  @override
  String get replicateStartDateLabel => 'Start date';

  @override
  String get applyReplicateButton => 'Apply';

  @override
  String replicateResultToast(int applied, int skipped, int failed) {
    return 'Applied to $applied dates, skipped $skipped already customized, $failed failed';
  }

  @override
  String get selectModeButton => 'Select';

  @override
  String get cancelSelectButton => 'Cancel';

  @override
  String get mergeSlotsButton => 'Merge';

  @override
  String get mergeNotContiguousHint =>
      'Selected slots must be contiguous (touching or overlapping) to merge';

  @override
  String get mergedCapacityLabel => 'Merged capacity';

  @override
  String get confirmMergeTitle => 'Merge slots?';

  @override
  String confirmMergeMessage(String start, String end) {
    return 'This will merge the selected slots into $start – $end.';
  }

  @override
  String get capacityLabel => 'Capacity';

  @override
  String get duplicateSlotExists =>
      'A slot with the exact same start and end time already exists';

  @override
  String bookedOfCapacity(int count, int capacity) {
    return '$count/$capacity booked';
  }

  @override
  String overCapacityWarning(int count) {
    return 'Over capacity by $count';
  }

  @override
  String get noSlotsVendorMayBeClosed =>
      'No slots available — vendor may be closed on this date';

  @override
  String get revertedToTemplateToast => 'Reverted to weekly template';

  @override
  String get dateSavedToast => 'Saved custom slots for this date';

  @override
  String get dateClosedToast => 'Date marked as closed';

  @override
  String get mergeSucceededToast => 'Slots merged — tap Save to apply';

  @override
  String get membershipPlansTitle => 'Membership Plans';

  @override
  String get newPlanButton => 'New Plan';

  @override
  String get deletePlanTitle => 'Delete plan?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" will be removed. This cannot be undone.';
  }

  @override
  String get inactiveLabel => 'Inactive';

  @override
  String get noBenefitsAdded => 'No benefits added.';

  @override
  String get noMembershipPlans => 'No membership plans yet';

  @override
  String get tapNewPlanHint => 'Tap \"New Plan\" to create your first one.';

  @override
  String get membershipRequestsTitle => 'Membership Requests';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get customersCanApplyHint =>
      'Customers can apply for membership\nfrom their ledger screen.';

  @override
  String get membersTitle => 'Members';

  @override
  String get noMembersYet => 'No members yet';

  @override
  String get activeStat => 'Active';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'Expiring';

  @override
  String get allPlansFilter => 'All Plans';

  @override
  String daysLeft(int count) {
    return '${count}d left';
  }

  @override
  String daysLeftFull(int count) {
    return '$count days';
  }

  @override
  String get planNameLabel => 'Plan name';

  @override
  String get planNameHint => 'e.g. Gold Membership';

  @override
  String get durationDaysLabel => 'Duration (days)';

  @override
  String get priceRupeesLabel => 'Price ₹';

  @override
  String get addBenefitButton => 'Add benefit';

  @override
  String get customLabel => 'Custom';

  @override
  String get customAdvanceLabel => 'Custom advance ₹';

  @override
  String get benefitLabel => 'Benefit';

  @override
  String get benefitHint => 'e.g. 4 haircuts';

  @override
  String get planDetailsSection => 'Plan details';

  @override
  String get benefitsSection => 'Benefits';

  @override
  String get advanceRequiredSection => 'Advance required';

  @override
  String get editPlanTitle => 'Edit Plan';

  @override
  String get createPlanTitle => 'Create Membership Plan';

  @override
  String get publishPlanButton => 'Publish Plan';

  @override
  String get planUpdatedToast => 'Plan updated';

  @override
  String get planPublishedToast => 'Plan published';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · Plans';
  }

  @override
  String get noPlansAvailable => 'No plans available yet';

  @override
  String get vendorNoPlansHint =>
      'This vendor hasn\'t created any membership plans.';

  @override
  String applyForPlan(String planName) {
    return 'Apply for $planName';
  }

  @override
  String get messageToVendorOptional => 'Message to vendor (optional)';

  @override
  String get messageToVendorHint => 'e.g. Please enroll me for this month';

  @override
  String get sendRequestButton => 'Send Request';

  @override
  String get activeLabel => 'Active';

  @override
  String get noAdditionalBenefits => 'No additional benefits';

  @override
  String get currentPlanLabel => 'Current Plan';

  @override
  String get requestPendingLabel => 'Request Pending';

  @override
  String get applyLabel => 'Apply';

  @override
  String requestSentToName(String name) {
    return 'Request sent to $name';
  }

  @override
  String get membershipDialogTitle => 'Membership';

  @override
  String pendingPlanPrefix(String planName) {
    return 'Pending: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return 'Enroll $name';
  }

  @override
  String get choosePlanHint => 'Choose a plan to start their membership.';

  @override
  String get noActivePlansHint =>
      'No active plans. Create one in Memberships → Plans first.';

  @override
  String get enrollLabel => 'Enroll';

  @override
  String get changeLabel => 'Change';

  @override
  String get usedLabel => 'Used';

  @override
  String get useLabel => 'Use';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count days left';
  }

  @override
  String get orderPlacedSuccess => 'Order placed successfully!';

  @override
  String orderFromVendor(String vendorName) {
    return 'Order from $vendorName';
  }

  @override
  String get addItemButton => 'Add item';

  @override
  String get orderNoteOptional => 'Order note (optional)';

  @override
  String get totalLabel => 'Total';

  @override
  String get placeOrderButton => 'Place Order';

  @override
  String get itemNameRequired => 'Item name *';

  @override
  String get unitLabel => 'Unit';

  @override
  String get unitHint => 'kg, L…';

  @override
  String get unitPriceLabel => 'Unit ₹';

  @override
  String itemNumber(int number) {
    return 'Item $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'Subtotal: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'Order Details';

  @override
  String get proofPhotoLabel => 'Proof photo';

  @override
  String get tapToViewFullScreen => 'Tap to view full screen';

  @override
  String get rejectButton => 'Reject';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get markAsDeliveredButton => 'Mark as Delivered';

  @override
  String get confirmDeliveryTitle => 'Confirm Delivery';

  @override
  String get deliveryNoteOptional => 'Delivery note (optional)';

  @override
  String get retakeLabel => 'Retake';

  @override
  String photoUploadFailed(String error) {
    return 'Photo upload failed: $error';
  }

  @override
  String get orderNoteLabel => 'Order note';

  @override
  String get customerLabel => 'Customer';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get markDeliveredButton => 'Mark Delivered';

  @override
  String get myOrdersTitle => 'My Orders';

  @override
  String get deliverButton => 'Deliver';

  @override
  String get noPendingDeliveries => 'No pending deliveries';

  @override
  String get deliveriesTitle => 'Deliveries';

  @override
  String get monthlyStatementTitle => 'Monthly Statement';

  @override
  String get deliveryProofLabel => 'Delivery proof';

  @override
  String get replacePhotoButton => 'Replace Photo';

  @override
  String get attachProofButton => 'Attach Proof';

  @override
  String get uploadingLabel => 'Uploading...';

  @override
  String get proofLockedHint => 'This proof is locked and cannot be changed';

  @override
  String get proofAttachedToast => 'Proof attached';

  @override
  String itemLabel(int number) {
    return 'Item $number';
  }

  @override
  String get amountRequired => 'Amount *';

  @override
  String get addItemLabel => 'Add Item';

  @override
  String get totalAmountLabel => 'Total';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get activate => 'Activate';

  @override
  String get activeStatLabel => 'Active';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'Expiring';

  @override
  String get closeLabel => 'Close';

  @override
  String pendingPlanLabel(String name) {
    return 'Pending: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer requested $plan';
  }

  @override
  String itemsCount(int count) {
    return 'Items ($count)';
  }

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String markedDeliveredBy(String role) {
    return 'Marked delivered by $role';
  }

  @override
  String get deliveriesHint =>
      'Items delivered through orders. Tap an entry to see the items.';
}
