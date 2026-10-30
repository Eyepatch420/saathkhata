// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಸಾಥ್‌ಖಾತಾ';

  @override
  String get tagline => 'ಒಂದು ಖಾತೆ, ಇಬ್ಬರಿಗೂ';

  @override
  String get onboarding1Title => 'ಎರಡು ಕಡೆಯ ಹಂಚಿಕೆ ಖಾತೆ';

  @override
  String get onboarding1Subtitle =>
      'ಮಾರಾಟಗಾರ ಮತ್ತು ಗ್ರಾಹಕ ಇಬ್ಬರಿಗೂ ಒಂದೇ ಖಾತೆ. ಇಬ್ಬರೂ ಒಂದೇ ಸತ್ಯ ನೋಡುತ್ತಾರೆ.';

  @override
  String get onboarding2Title => 'ವಾಯ್ಸ್ ಮತ್ತು ಬಿಲ್ OCR';

  @override
  String get onboarding2Subtitle =>
      '12 ಭಾಷೆಗಳಲ್ಲಿ ತಕ್ಷಣ ನಮೂದುಗಳನ್ನು ರಚಿಸಲು ಮಾತನಾಡಿ ಅಥವಾ ಬಿಲ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ.';

  @override
  String get onboarding3Title => 'ಒಂದೇ ಟ್ಯಾಪ್‌ನಲ್ಲಿ UPI ಪಾವತಿ';

  @override
  String get onboarding3Subtitle =>
      'UPI ಮೂಲಕ ಒಂದೇ ಟ್ಯಾಪ್‌ನಲ್ಲಿ ತಿಂಗಳ ಬಾಕಿ ತೀರಿಸಿ.';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get skip => 'ಬಿಡಿ';

  @override
  String get chooseLanguage => 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get continueButton => 'ಮುಂದುವರಿಸಿ';

  @override
  String get chooseRole => 'ನಿಮ್ಮ ಪಾತ್ರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get vendor => 'ಮಾರಾಟಗಾರ';

  @override
  String get customer => 'ಗ್ರಾಹಕ';

  @override
  String get welcomeToSaathKhata => 'ಸಾಥ್‌ಖಾತಾಗೆ ಸ್ವಾಗತ';

  @override
  String get tellUsHowYouUse => 'ನೀವು ಅಪ್ ಅನ್ನು ಹೇಗೆ ಬಳಸುತ್ತೀರಿ ಎಂದು ಹೇಳಿ';

  @override
  String get vendorRoleTitle => 'ನಾನು ಮಾರಾಟಗಾರ';

  @override
  String get vendorRoleSubtitle =>
      'ವ್ಯವಹಾರ ಖಾತೆ, ಉದ್ಯೋಗಿಗಳನ್ನು ನಿರ್ವಹಿಸಿ ಮತ್ತು ಪಾವತಿ ಪಡೆಯಿರಿ.';

  @override
  String get customerRoleTitle => 'ನಾನು ಗ್ರಾಹಕ';

  @override
  String get customerRoleSubtitle =>
      'ಮಾರಾಟಗಾರರೊಂದಿಗೆ ಖಾತೆ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ ಮತ್ತು UPI ಮೂಲಕ ಪಾವತಿಸಿ.';

  @override
  String get loginTitle => 'ಸಾಥ್‌ಖಾತಾಗೆ ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get enterMobile => 'ಮುಂದುವರಿಯಲು ನಿಮ್ಮ ವಿವರಗಳನ್ನು ನಮೂದಿಸಿ';

  @override
  String get mobileNumber => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get sendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get verifyOtp => 'OTP ಪರಿಶೀಲಿಸಿ';

  @override
  String get verifyAndContinue => 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮುಂದುವರಿಸಿ';

  @override
  String get changePhoneNumber => 'ಫೋನ್ ಸಂಖ್ಯೆ ಬದಲಿಸಿ';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumberಗೆ ಕಳುಹಿಸಿದ 6 ಅಂಕಿ ಕೋಡ್ ನಮೂದಿಸಿ';
  }

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get passwordHint => 'ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get loginButton => 'ಲಾಗಿನ್';

  @override
  String get noAccount => 'ಖಾತೆ ಇಲ್ಲವೇ?';

  @override
  String get signUp => 'ನೋಂದಣಿ ಮಾಡಿ';

  @override
  String get pleaseEnterCredentials => 'ಇಮೇಲ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get fillRequiredFields => 'ಹೆಸರು, ಇಮೇಲ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ ತುಂಬಿಸಿ';

  @override
  String get passwordMinChars => 'ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳು';

  @override
  String get completeProfile => 'ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get enterYourName => 'ನಿಮ್ಮ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get egBusinessName => 'ಉದಾ. ಕೃಷ್ಣ ಡೈರಿ';

  @override
  String get selectCategory => 'ವರ್ಗ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get enterAddress => 'ಪ್ರದೇಶ ಅಥವಾ ಪೂರ್ಣ ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get businessName => 'ವ್ಯವಹಾರದ ಹೆಸರು';

  @override
  String get businessCategory => 'ವ್ಯವಹಾರ ವರ್ಗ';

  @override
  String get businessAddress => 'ವ್ಯವಹಾರ ವಿಳಾಸ (ಐಚ್ಛಿಕ)';

  @override
  String get upiId => 'UPI ID (ಪಾವತಿಗಳಿಗಾಗಿ)';

  @override
  String get vendorDashboard => 'ಮಾರಾಟಗಾರ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get customerDashboard => 'ಗ್ರಾಹಕ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get customerMode => 'ಗ್ರಾಹಕ ಮೋಡ್';

  @override
  String get myVendors => 'ನನ್ನ ಮಾರಾಟಗಾರರು';

  @override
  String get outstanding => 'ಬಾಕಿ';

  @override
  String get collectedToday => 'ಇಂದು ಸಂಗ್ರಹ';

  @override
  String get quickActions => 'ತ್ವರಿತ ಕ್ರಮಗಳು';

  @override
  String get scanBill => 'ಬಿಲ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get remindAll => 'ಎಲ್ಲರಿಗೂ ನೆನಪಿಸಿ';

  @override
  String get addNew => 'ಹೊಸದು ಸೇರಿಸಿ';

  @override
  String get recentCustomers => 'ಇತ್ತೀಚಿನ ಗ್ರಾಹಕರು';

  @override
  String get viewAll => 'ಎಲ್ಲ ನೋಡಿ';

  @override
  String customerAddedSnackbar(String name) {
    return '$name ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get sharedLedger => 'ಹಂಚಿಕೆ ಖಾತೆ';

  @override
  String get totalBalance => 'ಒಟ್ಟು ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String get statement => 'ಹೇಳಿಕೆ';

  @override
  String get giveCredit => 'ಸಾಲ ನೀಡಿ';

  @override
  String get recordPayment => 'ಪಾವತಿ ದಾಖಲಿಸಿ';

  @override
  String get giveCreditSheet => 'ಸಾಲ ನೀಡಿ';

  @override
  String get recordPaymentSheet => 'ಪಾವತಿ ದಾಖಲಿಸಿ';

  @override
  String get filterAll => 'ಎಲ್ಲ';

  @override
  String get balanceCustomerOwes => 'ಗ್ರಾಹಕರ ಬಾಕಿ';

  @override
  String get balanceYouOwe => 'ನಿಮ್ಮ ಬಾಕಿ';

  @override
  String get balanceSettled => 'ತೀರಿಸಲಾಗಿದೆ';

  @override
  String get balanceYouOweVendor => 'ವ್ಯಾಪಾರಿಗೆ ನಿಮ್ಮ ಬಾಕಿ';

  @override
  String get balanceVendorOwesYou => 'ವ್ಯಾಪಾರಿಯ ಬಾಕಿ ನಿಮಗೆ';

  @override
  String get ledgerInfoTitle => 'ಈ ಖಾತೆ ಹೇಗೆ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ';

  @override
  String get statusConfirmed => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get statusConfirmedDesc =>
      'ಎರಡೂ ಕಡೆ ಒಪ್ಪಿಗೆ ಇದೆ. ನಮೂದು ಲಾಕ್ ಆಗಿದೆ ಮತ್ತು ಬದಲಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get statusPending => 'ಬಾಕಿ';

  @override
  String get statusPendingDesc =>
      'ಗ್ರಾಹಕರ ದೃಢೀಕರಣಕ್ಕಾಗಿ ಕಾಯಲಾಗುತ್ತಿದೆ. 72 ಗಂಟೆಗಳಲ್ಲಿ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ದೃಢೀಕರಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get statusDisputed => 'ವಿವಾದಿತ';

  @override
  String get statusDisputedDesc =>
      'ಗ್ರಾಹಕರು ವಿವಾದ ಎತ್ತಿದ್ದಾರೆ. ಮಾರಾಟಗಾರರ ಪರಿಶೀಲನೆ ಅಗತ್ಯ.';

  @override
  String get statusAutoConfirmed => 'ಸ್ವಯಂ ದೃಢೀಕರಣ';

  @override
  String get entryTypeCreditLabel => 'ಸಾಲ ನಮೂದು';

  @override
  String get entryTypePaymentLabel => 'ಪಾವತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get entryDetails => 'ನಮೂದಿನ ವಿವರಗಳು';

  @override
  String get entryAmount => 'ಮೊತ್ತ';

  @override
  String get entryType => 'ಪ್ರಕಾರ';

  @override
  String get entryTypeCreditGiven => 'ಸಾಲ (ನೀಡಿದ)';

  @override
  String get entryTypePaymentReceived => 'ಪಾವತಿ (ಸ್ವೀಕರಿಸಿದ)';

  @override
  String get entryDate => 'ದಿನಾಂಕ';

  @override
  String get entryDescription => 'ವಿವರಣೆ';

  @override
  String get entryQuantity => 'ಪ್ರಮಾಣ';

  @override
  String get entryConfirmedAt => 'ದೃಢೀಕರಣ ದಿನಾಂಕ';

  @override
  String get entryDisputeReason => 'ವಿವಾದದ ಕಾರಣ';

  @override
  String entryFor(String name) {
    return '$name ಗಾಗಿ';
  }

  @override
  String get description => 'ವಿವರಣೆ';

  @override
  String get descriptionOptional => 'ವಿವರಣೆ (ಐಚ್ಛಿಕ)';

  @override
  String get quantityOptional => 'ಪ್ರಮಾಣ (ಐಚ್ಛಿಕ)';

  @override
  String get descriptionHint => 'ಉದಾ. 2L ಹಾಲು, ತಿಂಗಳ ದಿನಸಿ';

  @override
  String get quantityHint => 'ಉದಾ. 2';

  @override
  String get addCreditEntry => 'ಸಾಲ ನಮೂದು ಸೇರಿಸಿ';

  @override
  String get noLedgerTransactions => 'ಇನ್ನೂ ವ್ಯವಹಾರಗಳಿಲ್ಲ';

  @override
  String get noLedgerTransactionsSubtitle =>
      'ಪ್ರಾರಂಭಿಸಲು ಸಾಲ ಅಥವಾ ಪಾವತಿ ನಮೂದು ಸೇರಿಸಿ.';

  @override
  String get confirmEntryTitle => 'ನಮೂದು ದೃಢೀಕರಿಸಿ';

  @override
  String confirmEntryMessage(String amount) {
    return '₹$amount ನಮೂದನ್ನು ದೃಢೀಕರಿಸಲು ಬಯಸುವಿರಾ? ಇದನ್ನು ರದ್ದು ಮಾಡಲಾಗುವುದಿಲ್ಲ.';
  }

  @override
  String get dispute => 'ವಿವಾದ';

  @override
  String get raiseDisputeTitle => 'ವಿವಾದ ಎತ್ತಿ';

  @override
  String get raiseDisputeSubtitle => 'ಈ ನಮೂದಿನಲ್ಲಿ ಏನು ತಪ್ಪಿದೆ ಎಂದು ವಿವರಿಸಿ.';

  @override
  String get raiseDisputeHint => 'ಉದಾ. ಮೊತ್ತ ₹50 ಆಗಿರಬೇಕು, ₹60 ಅಲ್ಲ';

  @override
  String get submitDispute => 'ವಿವಾದ ಸಲ್ಲಿಸಿ';

  @override
  String get staffAndLabour => 'ಸಿಬ್ಬಂದಿ ಮತ್ತು ಕಾರ್ಮಿಕರು';

  @override
  String get addStaff => 'ಸಿಬ್ಬಂದಿ ಸೇರಿಸಿ';

  @override
  String get presentToday => 'ಇಂದು ಹಾಜರು';

  @override
  String get unpaidSalary => 'ಪಾವತಿ ಆಗದ ಸಂಬಳ';

  @override
  String get paySalary => 'ಸಂಬಳ ಕೊಡಿ';

  @override
  String get noStaffAdded => 'ಇನ್ನೂ ಸಿಬ್ಬಂದಿ ಇಲ್ಲ';

  @override
  String get noStaffAddedSubtitle =>
      'ಮೊದಲ ಸಿಬ್ಬಂದಿ ಸೇರಿಸಲು ಕೆಳಗಿನ ಗುಂಡಿ ಒತ್ತಿ.';

  @override
  String get present => 'ಹಾಜರು';

  @override
  String get absent => 'ಗೈರುಹಾಜರು';

  @override
  String get halfDay => 'ಅರ್ಧ ದಿನ';

  @override
  String get paySalaryTitle => 'ಸಂಬಳ ಕೊಡಿ';

  @override
  String unpaidLabel(String amount) {
    return 'ಪಾವತಿ ಆಗಿಲ್ಲ: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI ವ್ಯವಹಾರ ID (ಐಚ್ಛಿಕ)';

  @override
  String get noDues => 'ಬಾಕಿ ಇಲ್ಲ';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount ಕೊಡಿ';
  }

  @override
  String staffJoined(String date) {
    return '$date ರಂದು ಸೇರಿದರು';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/ದಿನ';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/ತಿಂಗಳು';
  }

  @override
  String get staffPayButton => 'ಪಾವತಿ';

  @override
  String get businessReports => 'ವ್ಯವಹಾರ ವರದಿಗಳು';

  @override
  String get revenueTrend => 'ಆದಾಯ ಪ್ರವೃತ್ತಿ';

  @override
  String get collectionSummary => 'ಸಂಗ್ರಹ ಸಾರಾಂಶ';

  @override
  String get totalOutstanding => 'ಒಟ್ಟು ಬಾಕಿ';

  @override
  String get totalCollected => 'ಒಟ್ಟು ಸಂಗ್ರಹ';

  @override
  String get topCustomers => 'ಮೇಲ್ಮಟ್ಟದ ಗ್ರಾಹಕರು';

  @override
  String get seeAll => 'ಎಲ್ಲ ನೋಡಿ';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get appLanguage => 'ಅಪ್ ಭಾಷೆ';

  @override
  String get selectLanguage => 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get settingsManagePayments => 'ಪಾವತಿ ಖಾತೆಗಳನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get settingsManageAlerts => 'ಎಚ್ಚರಿಕೆಗಳು ಮತ್ತು ಜ್ಞಾಪಕಗಳನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get settingsAppPinFingerprint => 'ಅಪ್ ಪಿನ್ ಮತ್ತು ಬೆರಳಚ್ಚು';

  @override
  String get settingsFaqsContact => 'ಸಹಾಯ ಮತ್ತು ಸಂಪರ್ಕ';

  @override
  String settingsVersion(String version) {
    return 'ಆವೃತ್ತಿ $version';
  }

  @override
  String get myUpiIds => 'ನನ್ನ UPI IDಗಳು';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get security => 'ಭದ್ರತೆ';

  @override
  String get helpSupport => 'ಸಹಾಯ';

  @override
  String get logout => 'ಲಾಗ್‌ಔಟ್';

  @override
  String get markAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಿದಂತೆ ಗುರುತಿಸಿ';

  @override
  String get noNotificationsTitle => 'ಇನ್ನೂ ಅಧಿಸೂಚನೆಗಳಿಲ್ಲ';

  @override
  String get noNotificationsSubtitle =>
      'ಇಲ್ಲಿ ಖಾತೆ ನವೀಕರಣಗಳು, ಪಾವತಿ ಎಚ್ಚರಿಕೆಗಳು ಮತ್ತು ಜ್ಞಾಪಕಗಳು ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get today => 'ಇಂದು';

  @override
  String get yesterday => 'ನಿನ್ನೆ';

  @override
  String minutesAgo(int count) {
    return '$count ನಿಮಿಷಗಳ ಹಿಂದೆ';
  }

  @override
  String hoursAgo(int count) {
    return '$count ಗಂಟೆಗಳ ಹಿಂದೆ';
  }

  @override
  String get payments => 'ಪಾವತಿಗಳು';

  @override
  String get transactionHistory => 'ವ್ಯವಹಾರ ಇತಿಹಾಸ';

  @override
  String get totalPaid => 'ಒಟ್ಟು ಪಾವತಿ';

  @override
  String get pending => 'ಬಾಕಿ';

  @override
  String get quickPay => 'ತ್ವರಿತ ಪಾವತಿ';

  @override
  String get scanAndPay => 'ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಮತ್ತು ಪಾವತಿಸಿ';

  @override
  String get scanUpiDesc => 'ಮಾರಾಟಗಾರರಿಗೆ ಪಾವತಿಸಲು UPI QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get noTransactionsTitle => 'ಇನ್ನೂ ವ್ಯವಹಾರಗಳಿಲ್ಲ';

  @override
  String get noTransactionsSubtitle => 'ನಿಮ್ಮ ಪಾವತಿ ಇತಿಹಾಸ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get paymentStatusPaid => 'ಪಾವತಿ ಆಗಿದೆ';

  @override
  String get paymentStatusFailed => 'ವಿಫಲ';

  @override
  String get paymentStatusRefunded => 'ಮರಳಿ ನೀಡಲಾಗಿದೆ';

  @override
  String get appointments => 'ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಳು';

  @override
  String get myAppointments => 'ನನ್ನ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಳು';

  @override
  String get upcoming => 'ಮುಂಬರುವ';

  @override
  String get past => 'ಹಿಂದಿನ';

  @override
  String get cancelBooking => 'ಬುಕಿಂಗ್ ರದ್ದು ಮಾಡಿ';

  @override
  String get keepBooking => 'ಇರಲಿ';

  @override
  String get noBookingsToday => 'ಇಂದು ಬುಕಿಂಗ್‌ಗಳಿಲ್ಲ';

  @override
  String get noBookingsTodaySubtitle =>
      'ಗ್ರಾಹಕರು ಅಪ್ ಮೂಲಕ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಳನ್ನು ಬುಕ್ ಮಾಡಬಹುದು.';

  @override
  String get noAppointmentsTitle => 'ಇನ್ನೂ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಳಿಲ್ಲ';

  @override
  String get noAppointmentsSubtitle =>
      'ಪ್ರಾರಂಭಿಸಲು ನಿಮ್ಮ ಮಾರಾಟಗಾರರೊಂದಿಗೆ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್ ಬುಕ್ ಮಾಡಿ.';

  @override
  String get cancelAppointmentTitle => 'ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್ ರದ್ದು ಮಾಡುವಿರಾ?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date ರಂದು $time ಗೆ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್ ರದ್ದು ಮಾಡುವಿರಾ?';
  }

  @override
  String get bookingStatusConfirmed => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get bookingStatusPending => 'ಬಾಕಿ';

  @override
  String get bookingStatusCancelled => 'ರದ್ದು';

  @override
  String get bookingStatusCompleted => 'ಪೂರ್ಣ';

  @override
  String get bookingStatusDone => 'ಪೂರ್ಣ';

  @override
  String get upiPayment => 'UPI ಪಾವತಿ';

  @override
  String get amountToPay => 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ';

  @override
  String get securedByUpi => 'UPI ಮೂಲಕ ಸುರಕ್ಷಿತ';

  @override
  String get paymentSuccessful => 'ಪಾವತಿ ಯಶಸ್ವಿ!';

  @override
  String get paymentFailed => 'ಪಾವತಿ ವಿಫಲ';

  @override
  String get retryPayment => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get enterUpiId => 'UPI ID ನಮೂದಿಸಿ';

  @override
  String get addNoteOptional => 'ಟಿಪ್ಪಣಿ ಸೇರಿಸಿ (ಐಚ್ಛಿಕ)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount ಪಾವತಿಸಿ';
  }

  @override
  String get done => 'ಮುಗಿಯಿತು';

  @override
  String get paymentSomethingWentWrong => 'ಏನೋ ತಪ್ಪಾಯಿತು. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String upiAppComingSoon(String app) {
    return '$app ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ';
  }

  @override
  String get pleaseEnterUpiId => 'UPI ID ನಮೂದಿಸಿ';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $nameಗೆ ಪಾವತಿಸಲಾಗಿದೆ';
  }

  @override
  String get orDivider => 'ಅಥವಾ';

  @override
  String get addNewCustomer => 'ಹೊಸ ಗ್ರಾಹಕರನ್ನು ಸೇರಿಸಿ';

  @override
  String get customerName => 'ಗ್ರಾಹಕರ ಹೆಸರು';

  @override
  String get mobileNo => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get addCustomer => 'ಗ್ರಾಹಕರನ್ನು ಸೇರಿಸಿ';

  @override
  String get paymentConfirmed => 'ಪಾವತಿ ದೃಢೀಕರಿಸಿ';

  @override
  String get addAdvance => 'ಮುಂಗಡ ಸೇರಿಸಿ';

  @override
  String get addAdvanceTitle => 'ಮುಂಗಡ ಸೇರಿಸಿ';

  @override
  String get attendanceTitle => 'ಹಾಜರಾತಿ';

  @override
  String get salaryTitle => 'ಸಂಬಳ ಸಾರಾಂಶ';

  @override
  String get rate => 'ದರ';

  @override
  String get daysPresent => 'ಹಾಜರಾದ ದಿನಗಳು';

  @override
  String get earned => 'ಗಳಿಸಿದ';

  @override
  String get unpaid => 'ಪಾವತಿ ಆಗಿಲ್ಲ';

  @override
  String get advanceTaken => 'ತೆಗೆದ ಮುಂಗಡ';

  @override
  String get active => 'ಸಕ್ರಿಯ';

  @override
  String get inactive => 'ನಿಷ್ಕ್ರಿಯ';

  @override
  String get joined => 'ಸೇರಿದ';

  @override
  String get noPhone => 'ಫೋನ್ ಇಲ್ಲ';

  @override
  String get addNewStaff => 'ಹೊಸ ಸಿಬ್ಬಂದಿ ಸೇರಿಸಿ';

  @override
  String get fullNameLabel => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get phoneNumber => 'ಫೋನ್ ಸಂಖ್ಯೆ';

  @override
  String get role => 'ಪಾತ್ರ';

  @override
  String get salaryType => 'ಸಂಬಳ ಪ್ರಕಾರ';

  @override
  String get dailyWage => 'ದಿನಗೂಲಿ';

  @override
  String get monthlySalary => 'ತಿಂಗಳ ಸಂಬಳ';

  @override
  String get dailyWageAmount => 'ದಿನಗೂಲಿ (₹)';

  @override
  String get monthlySalaryAmount => 'ತಿಂಗಳ ಸಂಬಳ (₹)';

  @override
  String get addStaffButton => 'ಸಿಬ್ಬಂದಿ ಸೇರಿಸಿ';

  @override
  String get noteOptional => 'ಟಿಪ್ಪಣಿ (ಐಚ್ಛಿಕ)';

  @override
  String get amountRupees => 'ಮೊತ್ತ (₹)';

  @override
  String get cancel => 'ರದ್ದು';

  @override
  String get confirm => 'ದೃಢೀಕರಿಸಿ';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get alignBillInFrame => 'ಬಿಲ್ ಅನ್ನು ಫ್ರೇಮ್‌ನಲ್ಲಿ ಇರಿಸಿ';

  @override
  String get verifyAndLogin => 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get voiceListening => 'ಕೇಳುತ್ತಿದ್ದೇನೆ...';

  @override
  String get voiceThinking => 'ಯೋಚಿಸುತ್ತಿದ್ದೇನೆ...';

  @override
  String get voiceDetectedEntry => 'ಪತ್ತೆ ಹಚ್ಚಿದ ನಮೂದು';

  @override
  String get voiceConfirmEntry => 'ನಮೂದು ದೃಢೀಕರಿಸಿ';

  @override
  String get item => 'ವಸ್ತು';

  @override
  String get totalOutstandingBalance => 'ಒಟ್ಟು ಬಾಕಿ ಮೊತ್ತ';

  @override
  String get payAllDues => 'ಎಲ್ಲ ಬಾಕಿ ಪಾವತಿಸಿ';

  @override
  String get myKhatas => 'ನನ್ನ ಖಾತೆಗಳು';

  @override
  String get noVendorsFound => 'ಮಾರಾಟಗಾರರು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get verifyBillDetails => 'ಬಿಲ್ ವಿವರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get scannedBillPreview => 'ಸ್ಕ್ಯಾನ್ ಮಾಡಿದ ಬಿಲ್';

  @override
  String get descriptionItemDetails => 'ವಿವರಣೆ / ವಸ್ತು ವಿವರಗಳು';

  @override
  String get selectCustomer => 'ಗ್ರಾಹಕರನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get searchCustomerHint => 'ಗ್ರಾಹಕರನ್ನು ಹುಡುಕಿ ಅಥವಾ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get saveToKhata => 'ಖಾತೆಗೆ ಉಳಿಸಿ';

  @override
  String get allCustomersReport => 'ಎಲ್ಲ ಗ್ರಾಹಕರ ವರದಿ';

  @override
  String collectedInMonth(String month) {
    return '$monthನಲ್ಲಿ ಸಂಗ್ರಹ';
  }

  @override
  String get notificationSettings => 'ಅಧಿಸೂಚನೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get securityPin => 'ಭದ್ರತೆ ಮತ್ತು ಪಿನ್';

  @override
  String get editProfile => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get changePassword => 'ಪಾಸ್‌ವರ್ಡ್ ಬದಲಿಸಿ';

  @override
  String get termsAndConditions => 'ನಿಯಮಗಳು ಮತ್ತು ಷರತ್ತುಗಳು';

  @override
  String get privacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get accountSettings => 'ಖಾತೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get legalInfo => 'ಕಾನೂನು';

  @override
  String get currentPassword => 'ಪ್ರಸ್ತುತ ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get newPassword => 'ಹೊಸ ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get confirmNewPassword => 'ಹೊಸ ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get passwordsDoNotMatch => 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುವುದಿಲ್ಲ';

  @override
  String get changePasswordButton => 'ಪಾಸ್‌ವರ್ಡ್ ಬದಲಿಸಿ';

  @override
  String get passwordChangedSuccess => 'ಪಾಸ್‌ವರ್ಡ್ ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ';

  @override
  String get loadingContent => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get failedToLoad => 'ವಿಷಯ ಲೋಡ್ ಮಾಡಲು ವಿಫಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get bookingActions => 'ಬುಕಿಂಗ್ ಕ್ರಮಗಳು';

  @override
  String get confirmBooking => 'ಬುಕಿಂಗ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get markComplete => 'ಪೂರ್ಣ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer ರ $date ರಂದು $time ಗೆ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್ ದೃಢೀಕರಿಸುವಿರಾ?';
  }

  @override
  String get bookingUpdated => 'ಬುಕಿಂಗ್ ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get bookingUpdateFailed => 'ಬುಕಿಂಗ್ ನವೀಕರಿಸಲು ವಿಫಲ';

  @override
  String markAttendanceFor(String date) {
    return 'ಹಾಜರಾತಿ ಗುರುತಿಸಿ — $date';
  }

  @override
  String get allCustomers => 'ಎಲ್ಲ ಗ್ರಾಹಕರು';

  @override
  String get noCustomersYet => 'ಇನ್ನೂ ಗ್ರಾಹಕರಿಲ್ಲ';

  @override
  String get noCustomersYetSubtitle => 'ಪ್ರಾರಂಭಿಸಲು ಮೊದಲ ಗ್ರಾಹಕರನ್ನು ಸೇರಿಸಿ';

  @override
  String get invalidPhone =>
      '6–9 ರಿಂದ ಪ್ರಾರಂಭವಾಗುವ 10 ಅಂಕಿ ಮಾನ್ಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String accrueMonthSalary(String amount) {
    return 'ತಿಂಗಳ ಸಂಬಳ ಸೇರಿಸಿ (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'ತಿಂಗಳ ಸಂಬಳ ಸೇರಿಸಿ';

  @override
  String get removeStaffTitle => 'Remove Staff Member';

  @override
  String removeStaffConfirm(String name) {
    return 'Remove $name from your staff? This will revoke their app access immediately.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name ರ ಬಾಕಿಗೆ ಈ ತಿಂಗಳು ₹$amount ಸೇರಿಸುವಿರಾ?';
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
  String get recordDelivery => 'Udhaar Diya';

  @override
  String get recordDeliverySubtitle =>
      'Customer took goods — add to their khata';

  @override
  String get collectPayment => 'Paisa Mila';

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
