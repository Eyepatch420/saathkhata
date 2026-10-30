// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'சாத்கதா';

  @override
  String get tagline => 'ஒரு கணக்கு, இருவருக்கும்';

  @override
  String get onboarding1Title => 'இருதரப்பு பகிரப்பட்ட கணக்கு';

  @override
  String get onboarding1Subtitle =>
      'விற்பனையாளர் மற்றும் வாடிக்கையாளர் இருவருக்கும் ஒரே கணக்கு. இருவரும் ஒரே உண்மையை காண்கிறார்கள்.';

  @override
  String get onboarding2Title => 'குரல் மற்றும் பில் OCR';

  @override
  String get onboarding2Subtitle =>
      '12 மொழிகளில் உடனடியாக உள்ளீடுகளை உருவாக்க பேசுங்கள் அல்லது பில்களை ஸ்கேன் செய்யுங்கள்.';

  @override
  String get onboarding3Title => 'ஒரே தட்டில் UPI கட்டணம்';

  @override
  String get onboarding3Subtitle =>
      'UPI மூலம் ஒரே தட்டில் மாத நிலுவைகளை தீர்க்கவும்.';

  @override
  String get getStarted => 'தொடங்குங்கள்';

  @override
  String get next => 'அடுத்து';

  @override
  String get skip => 'தவிர்க்க';

  @override
  String get chooseLanguage => 'உங்கள் மொழியை தேர்ந்தெடுங்கள்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get chooseRole => 'உங்கள் பாத்திரத்தை தேர்ந்தெடுங்கள்';

  @override
  String get vendor => 'விற்பனையாளர்';

  @override
  String get customer => 'வாடிக்கையாளர்';

  @override
  String get welcomeToSaathKhata => 'சாத்கதாவிற்கு வரவேற்கிறோம்';

  @override
  String get tellUsHowYouUse =>
      'நீங்கள் ஆப்பை எவ்வாறு பயன்படுத்துவீர்கள் என்று சொல்லுங்கள்';

  @override
  String get vendorRoleTitle => 'நான் ஒரு விற்பனையாளர்';

  @override
  String get vendorRoleSubtitle =>
      'வணிகக் கணக்கு, ஊழியர்களை நிர்வகிக்கவும் மற்றும் கட்டணம் பெறவும்.';

  @override
  String get customerRoleTitle => 'நான் ஒரு வாடிக்கையாளர்';

  @override
  String get customerRoleSubtitle =>
      'விற்பனையாளர்களுடன் கணக்கை கண்காணிக்கவும் மற்றும் UPI மூலம் கட்டணம் செலுத்தவும்.';

  @override
  String get loginTitle => 'சாத்கதாவில் உள்நுழைக';

  @override
  String get enterMobile => 'தொடர உங்கள் விவரங்களை உள்ளிடுக';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get sendOtp => 'OTP அனுப்பு';

  @override
  String get verifyOtp => 'OTP சரிபார்க்க';

  @override
  String get verifyAndContinue => 'சரிபார்த்து தொடரவும்';

  @override
  String get changePhoneNumber => 'தொலைபேசி எண்ணை மாற்றவும்';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumber க்கு அனுப்பப்பட்ட 6 இலக்க குறியீட்டை உள்ளிடுக';
  }

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get passwordHint => 'கடவுச்சொல்லை உள்ளிடுக';

  @override
  String get loginButton => 'உள்நுழைக';

  @override
  String get noAccount => 'கணக்கு இல்லையா?';

  @override
  String get signUp => 'பதிவு செய்யவும்';

  @override
  String get pleaseEnterCredentials =>
      'மின்னஞ்சல் மற்றும் கடவுச்சொல்லை உள்ளிடுக';

  @override
  String get fillRequiredFields =>
      'பெயர், மின்னஞ்சல் மற்றும் கடவுச்சொல்லை நிரப்பவும்';

  @override
  String get passwordMinChars => 'குறைந்தது 8 எழுத்துக்கள்';

  @override
  String get completeProfile => 'சுயவிவரத்தை நிறைவு செய்யவும்';

  @override
  String get enterYourName => 'உங்கள் பெயரை உள்ளிடுக';

  @override
  String get egBusinessName => 'எ.கா. கிருஷ்ணா டெய்ரி';

  @override
  String get selectCategory => 'வகையை தேர்ந்தெடுக';

  @override
  String get enterAddress => 'பகுதி அல்லது முழு முகவரியை உள்ளிடுக';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get businessName => 'வணிகத்தின் பெயர்';

  @override
  String get businessCategory => 'வணிக வகை';

  @override
  String get businessAddress => 'வணிக முகவரி (விருப்பத்தேர்வு)';

  @override
  String get upiId => 'UPI ஐடி (கட்டணங்களுக்கு)';

  @override
  String get vendorDashboard => 'விற்பனையாளர் டாஷ்போர்டு';

  @override
  String get customerDashboard => 'வாடிக்கையாளர் டாஷ்போர்டு';

  @override
  String get customerMode => 'வாடிக்கையாளர் பயன்முறை';

  @override
  String get myVendors => 'என் விற்பனையாளர்கள்';

  @override
  String get outstanding => 'நிலுவை';

  @override
  String get collectedToday => 'இன்று சேகரிக்கப்பட்டது';

  @override
  String get quickActions => 'விரைவு செயல்கள்';

  @override
  String get scanBill => 'பில் ஸ்கேன் செய்யவும்';

  @override
  String get remindAll => 'அனைவரையும் நினைவூட்டுக';

  @override
  String get addNew => 'புதிதாக சேர்க்கவும்';

  @override
  String get recentCustomers => 'சமீபத்திய வாடிக்கையாளர்கள்';

  @override
  String get viewAll => 'அனைத்தையும் பார்க்க';

  @override
  String customerAddedSnackbar(String name) {
    return '$name சேர்க்கப்பட்டது';
  }

  @override
  String get sharedLedger => 'பகிரப்பட்ட கணக்கு';

  @override
  String get totalBalance => 'மொத்த இருப்பு';

  @override
  String get statement => 'அறிக்கை';

  @override
  String get giveCredit => 'கடன் கொடு';

  @override
  String get recordPayment => 'கட்டணத்தை பதிவு செய்யவும்';

  @override
  String get giveCreditSheet => 'கடன் கொடு';

  @override
  String get recordPaymentSheet => 'கட்டணத்தை பதிவு செய்யவும்';

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get balanceCustomerOwes => 'வாடிக்கையாளரின் நிலுவை';

  @override
  String get balanceYouOwe => 'உங்கள் நிலுவை';

  @override
  String get balanceSettled => 'தீர்க்கப்பட்டது';

  @override
  String get balanceYouOweVendor => 'நீங்கள் வணிகருக்கு கடன்பட்டிருக்கிறீர்கள்';

  @override
  String get balanceVendorOwesYou => 'வணிகர் உங்களுக்கு கடன்பட்டிருக்கிறார்';

  @override
  String get ledgerInfoTitle => 'இந்த கணக்கு எவ்வாறு செயல்படுகிறது';

  @override
  String get statusConfirmed => 'உறுதிப்படுத்தப்பட்டது';

  @override
  String get statusConfirmedDesc =>
      'இரு தரப்பும் ஒப்புக்கொண்டனர். உள்ளீடு பூட்டப்பட்டது மற்றும் மாற்ற முடியாது.';

  @override
  String get statusPending => 'நிலுவையில்';

  @override
  String get statusPendingDesc =>
      'வாடிக்கையாளர் உறுதிப்படுத்தலுக்காக காத்திருக்கிறது. 72 மணி நேரத்தில் தானாகவே உறுதிப்படுத்தப்படும்.';

  @override
  String get statusDisputed => 'சர்ச்சையில்';

  @override
  String get statusDisputedDesc =>
      'வாடிக்கையாளர் சர்ச்சை எழுப்பினார். விற்பனையாளர் மதிப்பாய்வு தேவை.';

  @override
  String get statusAutoConfirmed => 'தானியங்கி உறுதிப்படுத்தல்';

  @override
  String get entryTypeCreditLabel => 'கடன் உள்ளீடு';

  @override
  String get entryTypePaymentLabel => 'கட்டணம் பெறப்பட்டது';

  @override
  String get entryDetails => 'உள்ளீட்டு விவரங்கள்';

  @override
  String get entryAmount => 'தொகை';

  @override
  String get entryType => 'வகை';

  @override
  String get entryTypeCreditGiven => 'கடன் (கொடுத்தது)';

  @override
  String get entryTypePaymentReceived => 'கட்டணம் (பெறப்பட்டது)';

  @override
  String get entryDate => 'தேதி';

  @override
  String get entryDescription => 'விவரம்';

  @override
  String get entryQuantity => 'அளவு';

  @override
  String get entryConfirmedAt => 'உறுதிப்படுத்தல் தேதி';

  @override
  String get entryDisputeReason => 'சர்ச்சையின் காரணம்';

  @override
  String entryFor(String name) {
    return '$name க்காக';
  }

  @override
  String get description => 'விவரம்';

  @override
  String get descriptionOptional => 'விவரம் (விருப்பத்தேர்வு)';

  @override
  String get quantityOptional => 'அளவு (விருப்பத்தேர்வு)';

  @override
  String get descriptionHint => 'எ.கா. 2L பால், மாத மளிகை';

  @override
  String get quantityHint => 'எ.கா. 2';

  @override
  String get addCreditEntry => 'கடன் உள்ளீட்டை சேர்க்கவும்';

  @override
  String get noLedgerTransactions => 'இன்னும் பரிவர்த்தனைகள் இல்லை';

  @override
  String get noLedgerTransactionsSubtitle =>
      'தொடங்க கடன் அல்லது கட்டண உள்ளீட்டை சேர்க்கவும்.';

  @override
  String get confirmEntryTitle => 'உள்ளீட்டை உறுதிப்படுத்தவும்';

  @override
  String confirmEntryMessage(String amount) {
    return '₹$amount உள்ளீட்டை உறுதிப்படுத்த விரும்புகிறீர்களா? இதை மாற்ற முடியாது.';
  }

  @override
  String get dispute => 'சர்ச்சை';

  @override
  String get raiseDisputeTitle => 'சர்ச்சையை எழுப்பவும்';

  @override
  String get raiseDisputeSubtitle =>
      'இந்த உள்ளீட்டில் என்ன தவறு என்று விவரிக்கவும்.';

  @override
  String get raiseDisputeHint => 'எ.கா. தொகை ₹50 ஆக இருக்க வேண்டும், ₹60 அல்ல';

  @override
  String get submitDispute => 'சர்ச்சையை சமர்ப்பிக்கவும்';

  @override
  String get staffAndLabour => 'ஊழியர்கள் மற்றும் தொழிலாளர்கள்';

  @override
  String get addStaff => 'ஊழியரை சேர்க்கவும்';

  @override
  String get presentToday => 'இன்று வருகை';

  @override
  String get unpaidSalary => 'செலுத்தப்படாத சம்பளம்';

  @override
  String get paySalary => 'சம்பளம் கொடுக்கவும்';

  @override
  String get noStaffAdded => 'இன்னும் ஊழியர்கள் இல்லை';

  @override
  String get noStaffAddedSubtitle =>
      'முதல் ஊழியரை சேர்க்க கீழே உள்ள பொத்தானை அழுத்துங்கள்.';

  @override
  String get present => 'வருகை';

  @override
  String get absent => 'வருகை இல்லை';

  @override
  String get halfDay => 'அரை நாள்';

  @override
  String get paySalaryTitle => 'சம்பளம் கொடுக்கவும்';

  @override
  String unpaidLabel(String amount) {
    return 'செலுத்தப்படாதது: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional =>
      'UPI பரிவர்த்தனை ஐடி (விருப்பத்தேர்வு)';

  @override
  String get noDues => 'நிலுவைகள் இல்லை';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount கொடுக்கவும்';
  }

  @override
  String staffJoined(String date) {
    return '$date அன்று சேர்ந்தார்';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/நாள்';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/மாதம்';
  }

  @override
  String get staffPayButton => 'கட்டணம்';

  @override
  String get businessReports => 'வணிக அறிக்கைகள்';

  @override
  String get revenueTrend => 'வருவாய் போக்கு';

  @override
  String get collectionSummary => 'சேகரிப்பு சுருக்கம்';

  @override
  String get totalOutstanding => 'மொத்த நிலுவை';

  @override
  String get totalCollected => 'மொத்த சேகரிப்பு';

  @override
  String get topCustomers => 'சிறந்த வாடிக்கையாளர்கள்';

  @override
  String get seeAll => 'அனைத்தையும் பார்க்க';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get appLanguage => 'ஆப் மொழி';

  @override
  String get selectLanguage => 'மொழியை தேர்ந்தெடுக';

  @override
  String get settingsManagePayments => 'கட்டண கணக்குகளை நிர்வகிக்கவும்';

  @override
  String get settingsManageAlerts =>
      'எச்சரிக்கைகள் மற்றும் நினைவூட்டல்களை நிர்வகிக்கவும்';

  @override
  String get settingsAppPinFingerprint => 'ஆப் பின் மற்றும் கைரேகை';

  @override
  String get settingsFaqsContact => 'உதவி மற்றும் தொடர்பு';

  @override
  String settingsVersion(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get myUpiIds => 'என் UPI ஐடிகள்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get security => 'பாதுகாப்பு';

  @override
  String get helpSupport => 'உதவி';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get markAllRead => 'அனைத்தையும் படித்ததாக குறிக்கவும்';

  @override
  String get noNotificationsTitle => 'இன்னும் அறிவிப்புகள் இல்லை';

  @override
  String get noNotificationsSubtitle =>
      'இங்கே கணக்கு புதுப்பிப்புகள், கட்டண எச்சரிக்கைகள் மற்றும் நினைவூட்டல்கள் தெரியும்.';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String minutesAgo(int count) {
    return '$count நிமிடங்களுக்கு முன்';
  }

  @override
  String hoursAgo(int count) {
    return '$count மணி நேரத்திற்கு முன்';
  }

  @override
  String get payments => 'கட்டணங்கள்';

  @override
  String get transactionHistory => 'பரிவர்த்தனை வரலாறு';

  @override
  String get totalPaid => 'மொத்தம் செலுத்தப்பட்டது';

  @override
  String get pending => 'நிலுவையில்';

  @override
  String get quickPay => 'விரைவு கட்டணம்';

  @override
  String get scanAndPay => 'ஸ்கேன் செய்து கட்டணம் செலுத்தவும்';

  @override
  String get scanUpiDesc =>
      'விற்பனையாளருக்கு கட்டணம் செலுத்த UPI QR ஸ்கேன் செய்யவும்';

  @override
  String get noTransactionsTitle => 'இன்னும் பரிவர்த்தனைகள் இல்லை';

  @override
  String get noTransactionsSubtitle => 'உங்கள் கட்டண வரலாறு இங்கே தெரியும்.';

  @override
  String get paymentStatusPaid => 'செலுத்தப்பட்டது';

  @override
  String get paymentStatusFailed => 'தோல்வி';

  @override
  String get paymentStatusRefunded => 'திரும்பப்பெறப்பட்டது';

  @override
  String get appointments => 'சந்திப்புகள்';

  @override
  String get myAppointments => 'என் சந்திப்புகள்';

  @override
  String get upcoming => 'வரவிருக்கும்';

  @override
  String get past => 'கடந்த';

  @override
  String get cancelBooking => 'முன்பதிவை ரத்து செய்யவும்';

  @override
  String get keepBooking => 'வைத்திரு';

  @override
  String get noBookingsToday => 'இன்று முன்பதிவுகள் இல்லை';

  @override
  String get noBookingsTodaySubtitle =>
      'வாடிக்கையாளர்கள் ஆப் மூலம் சந்திப்புகளை முன்பதிவு செய்யலாம்.';

  @override
  String get noAppointmentsTitle => 'இன்னும் சந்திப்புகள் இல்லை';

  @override
  String get noAppointmentsSubtitle =>
      'தொடங்க உங்கள் விற்பனையாளருடன் சந்திப்பை முன்பதிவு செய்யவும்.';

  @override
  String get cancelAppointmentTitle => 'சந்திப்பை ரத்து செய்யவதா?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date அன்று $time மணிக்கான சந்திப்பை ரத்து செய்யவதா?';
  }

  @override
  String get bookingStatusConfirmed => 'உறுதிப்படுத்தப்பட்டது';

  @override
  String get bookingStatusPending => 'நிலுவையில்';

  @override
  String get bookingStatusCancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get bookingStatusCompleted => 'முடிந்தது';

  @override
  String get bookingStatusDone => 'முடிந்தது';

  @override
  String get upiPayment => 'UPI கட்டணம்';

  @override
  String get amountToPay => 'செலுத்த வேண்டிய தொகை';

  @override
  String get securedByUpi => 'UPI மூலம் பாதுகாக்கப்பட்டது';

  @override
  String get paymentSuccessful => 'கட்டணம் வெற்றிகரமாக!';

  @override
  String get paymentFailed => 'கட்டணம் தோல்வியடைந்தது';

  @override
  String get retryPayment => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get enterUpiId => 'UPI ஐடியை உள்ளிடுக';

  @override
  String get addNoteOptional => 'குறிப்பை சேர்க்கவும் (விருப்பத்தேர்வு)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount செலுத்தவும்';
  }

  @override
  String get done => 'முடிந்தது';

  @override
  String get paymentSomethingWentWrong =>
      'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String upiAppComingSoon(String app) {
    return '$app விரைவில் வருகிறது';
  }

  @override
  String get pleaseEnterUpiId => 'UPI ஐடியை உள்ளிடுக';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $name க்கு செலுத்தப்பட்டது';
  }

  @override
  String get orDivider => 'அல்லது';

  @override
  String get addNewCustomer => 'புதிய வாடிக்கையாளரை சேர்க்கவும்';

  @override
  String get customerName => 'வாடிக்கையாளர் பெயர்';

  @override
  String get mobileNo => 'மொபைல் எண்';

  @override
  String get addCustomer => 'வாடிக்கையாளரை சேர்க்கவும்';

  @override
  String get paymentConfirmed => 'கட்டணத்தை உறுதிப்படுத்தவும்';

  @override
  String get addAdvance => 'முன்பணம் சேர்க்கவும்';

  @override
  String get addAdvanceTitle => 'முன்பணம் சேர்க்கவும்';

  @override
  String get attendanceTitle => 'வருகை';

  @override
  String get salaryTitle => 'சம்பள சுருக்கம்';

  @override
  String get rate => 'விகிதம்';

  @override
  String get daysPresent => 'வருகை நாட்கள்';

  @override
  String get earned => 'சம்பாதித்தது';

  @override
  String get unpaid => 'செலுத்தப்படாதது';

  @override
  String get advanceTaken => 'எடுக்கப்பட்ட முன்பணம்';

  @override
  String get active => 'செயலில்';

  @override
  String get inactive => 'செயலற்றது';

  @override
  String get joined => 'சேர்ந்தார்';

  @override
  String get noPhone => 'தொலைபேசி இல்லை';

  @override
  String get addNewStaff => 'புதிய ஊழியரை சேர்க்கவும்';

  @override
  String get fullNameLabel => 'முழு பெயர்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get role => 'பாத்திரம்';

  @override
  String get salaryType => 'சம்பள வகை';

  @override
  String get dailyWage => 'தினசரி கூலி';

  @override
  String get monthlySalary => 'மாத சம்பளம்';

  @override
  String get dailyWageAmount => 'தினசரி கூலி (₹)';

  @override
  String get monthlySalaryAmount => 'மாத சம்பளம் (₹)';

  @override
  String get addStaffButton => 'ஊழியரை சேர்க்கவும்';

  @override
  String get noteOptional => 'குறிப்பு (விருப்பத்தேர்வு)';

  @override
  String get amountRupees => 'தொகை (₹)';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get tryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get alignBillInFrame => 'பில்லை சட்டகத்தில் வைக்கவும்';

  @override
  String get verifyAndLogin => 'சரிபார்த்து உள்நுழைக';

  @override
  String get voiceListening => 'கேட்கிறேன்...';

  @override
  String get voiceThinking => 'யோசிக்கிறேன்...';

  @override
  String get voiceDetectedEntry => 'கண்டறியப்பட்ட உள்ளீடு';

  @override
  String get voiceConfirmEntry => 'உள்ளீட்டை உறுதிப்படுத்தவும்';

  @override
  String get item => 'பொருள்';

  @override
  String get totalOutstandingBalance => 'மொத்த நிலுவை தொகை';

  @override
  String get payAllDues => 'அனைத்து நிலுவைகளையும் செலுத்தவும்';

  @override
  String get myKhatas => 'என் கணக்குகள்';

  @override
  String get noVendorsFound => 'விற்பனையாளர்கள் கிடைக்கவில்லை';

  @override
  String get verifyBillDetails => 'பில் விவரங்களை சரிபார்க்கவும்';

  @override
  String get scannedBillPreview => 'ஸ்கேன் செய்யப்பட்ட பில்';

  @override
  String get descriptionItemDetails => 'விவரம் / பொருள் விவரங்கள்';

  @override
  String get selectCustomer => 'வாடிக்கையாளரை தேர்ந்தெடுக';

  @override
  String get searchCustomerHint =>
      'வாடிக்கையாளரை தேடுங்கள் அல்லது தேர்ந்தெடுங்கள்';

  @override
  String get saveToKhata => 'கணக்கில் சேமிக்கவும்';

  @override
  String get allCustomersReport => 'அனைத்து வாடிக்கையாளர்கள் அறிக்கை';

  @override
  String collectedInMonth(String month) {
    return '$month இல் சேகரிக்கப்பட்டது';
  }

  @override
  String get notificationSettings => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get securityPin => 'பாதுகாப்பு மற்றும் பின்';

  @override
  String get editProfile => 'சுயவிவரத்தை திருத்தவும்';

  @override
  String get changePassword => 'கடவுச்சொல்லை மாற்றவும்';

  @override
  String get termsAndConditions => 'விதிமுறைகள் மற்றும் நிபந்தனைகள்';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get accountSettings => 'கணக்கு அமைப்புகள்';

  @override
  String get legalInfo => 'சட்டம்';

  @override
  String get currentPassword => 'தற்போதைய கடவுச்சொல்';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get confirmNewPassword => 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get changePasswordButton => 'கடவுச்சொல்லை மாற்றவும்';

  @override
  String get passwordChangedSuccess => 'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது';

  @override
  String get loadingContent => 'ஏற்றுகிறது...';

  @override
  String get failedToLoad =>
      'உள்ளடக்கத்தை ஏற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get bookingActions => 'முன்பதிவு செயல்கள்';

  @override
  String get confirmBooking => 'முன்பதிவை உறுதிப்படுத்தவும்';

  @override
  String get markComplete => 'முடிந்ததாக குறிக்கவும்';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer இன் $date அன்று $time மணி சந்திப்பை உறுதிப்படுத்தவதா?';
  }

  @override
  String get bookingUpdated => 'முன்பதிவு வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get bookingUpdateFailed => 'முன்பதிவை புதுப்பிக்க முடியவில்லை';

  @override
  String markAttendanceFor(String date) {
    return 'வருகையை குறிக்கவும் — $date';
  }

  @override
  String get allCustomers => 'அனைத்து வாடிக்கையாளர்கள்';

  @override
  String get noCustomersYet => 'இன்னும் வாடிக்கையாளர்கள் இல்லை';

  @override
  String get noCustomersYetSubtitle => 'தொடங்க முதல் வாடிக்கையாளரை சேர்க்கவும்';

  @override
  String get invalidPhone =>
      '6–9 இல் தொடங்கும் 10 இலக்க வலிய மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String accrueMonthSalary(String amount) {
    return 'மாத சம்பளத்தை சேர்க்கவும் (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'மாத சம்பளத்தை சேர்க்கவும்';

  @override
  String get removeStaffTitle => 'ஊழியரை நீக்கவும்';

  @override
  String removeStaffConfirm(String name) {
    return '$name ஐ உங்கள் ஊழியர் பட்டியலில் இருந்து நீக்கவதா? இவரின் ஆப் அணுகல் உடனடியாக ரத்து செய்யப்படும்.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name இன் நிலுவைக்கு இந்த மாதம் ₹$amount சேர்க்கவதா?';
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
      'சரியான 10 இலக்க இந்திய மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get enterAll6Digits => '6 இலக்கங்களையும் உள்ளிடவும்';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get passwordRequired => 'கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get nameRequired => 'பெயர் தேவை';

  @override
  String get required => 'தேவை';

  @override
  String get invalidUpiFormat => 'தவறான UPI ஐடி வடிவம் (எ.கா. name@upi)';

  @override
  String get upiIdAlreadyAdded => 'இந்த UPI ஐடி ஏற்கனவே சேர்க்கப்பட்டது';

  @override
  String get verifyButton => 'சரிபார்க்கவும்';

  @override
  String get createAccountButton => 'கணக்கு உருவாக்கவும்';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get mobileNumberLabel => 'மொபைல் எண்';

  @override
  String get personalInfo => 'தனிப்பட்ட தகவல்';

  @override
  String get businessInfo => 'வணிக தகவல்';

  @override
  String get enterOtpTitle => 'OTP உள்ளிடவும்';

  @override
  String get sentToLabel => 'அனுப்பப்பட்டது';

  @override
  String get noOtpReceived => 'OTP வரவில்லையா?';

  @override
  String get resendOtp => 'OTP மீண்டும் அனுப்பவும்';

  @override
  String get uploadingPhotoLabel => 'புகைப்படம் பதிவேற்றுகிறது...';

  @override
  String get phoneNumberLabel => 'தொலைபேசி எண்';

  @override
  String get iAmA => 'நான் ஒரு';

  @override
  String get dualRoleExplanation =>
      'நீங்கள் முதன்மையாக விற்பனையாளர் அனுபவத்தை பயன்படுத்துவீர்கள். வாடிக்கையாளர் கணக்கை தனியாக அணுகலாம்.';

  @override
  String get profileSavedPhotoFailed =>
      'சுயவிவரம் சேமிக்கப்பட்டது — புகைப்படத்தை இப்போது பதிவேற்ற முடியவில்லை';

  @override
  String get profileUpdatedSuccess =>
      'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get addUpiIdTitle => 'UPI ஐடி சேர்க்கவும்';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'ரத்து செய்';

  @override
  String get primaryUpiInfo => 'முதன்மை UPI ஐடி';

  @override
  String get primaryUpiDescription =>
      'முதன்மை ஐடி வாடிக்கையாளர்களிடம் கட்டணத்திற்காக பகிரப்படும். எது முதன்மையாக இருக்க வேண்டும் என்று மாற்ற நட்சத்திரத்தை தட்டவும்.';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI ஐடிகள்';
  }

  @override
  String get primaryUpiIdTooltip => 'முதன்மை UPI ஐடி';

  @override
  String get setAsPrimaryTooltip => 'முதன்மையாக அமை';

  @override
  String get primaryLabel => 'முதன்மை';

  @override
  String get removeButtonLabel => 'நீக்கவும்';

  @override
  String get noUpiIdsEmpty => 'இன்னும் UPI ஐடிகள் இல்லை';

  @override
  String get upiEmptyDescription =>
      '5 வரை UPI ஐடிகள் சேர்க்கலாம். முதன்மை ஐடி வாடிக்கையாளர்களிடம் கட்டணத்திற்காக பகிரப்படும்.';

  @override
  String get changePasswordSubtitle =>
      'தற்போதைய கடவுச்சொல்லை உள்ளிட்டு புதியதை தேர்வு செய்யவும்.';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு இருக்கிறதா?';

  @override
  String get goBackButton => 'திரும்பு';

  @override
  String get saveButton => 'சேமி';

  @override
  String get language => 'மொழி';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageKannada => 'ಕನ್ನಡ';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get languagePunjabi => 'ਪੰਜਾਬੀ';

  @override
  String get languageMalayalam => 'മലയാളം';

  @override
  String get languageBhojpuri => 'भोजपुरी';

  @override
  String get languageMaithili => 'मैथिली';

  @override
  String get needPasswordForEmail =>
      'இதை பயன்படுத்த உங்கள் கணக்கில் கடவுச்சொல் அமைக்கப்பட்டிருக்க வேண்டும்.\nஅமைப்புகள் → கடவுச்சொல் மாற்றவும் என்பதில் அமைக்கவும்.';

  @override
  String get usePhoneInstead => 'தொலைபேசி எண்ணை பயன்படுத்தவும் →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'அமர்வு காலாவதியானது. மீண்டும் தொலைபேசியை சரிபார்க்கவும்.';

  @override
  String get upiIdsSavedSuccessfully => 'UPI ஐடிகள் வெற்றிகரமாக சேமிக்கப்பட்டன';

  @override
  String get chooseYourLanguageHindi => 'உங்கள் மொழியை தேர்வு செய்யுங்கள்';

  @override
  String get unknownLanguage => 'தெரியாத மொழி';

  @override
  String get businessCategoryMilkDairy => 'பால் / டெய்ரி';

  @override
  String get businessCategoryPressDhobi => 'பிரஸ் / தோபி';

  @override
  String get businessCategoryMaidCook => 'வேலையாள் / சமையல்காரர்';

  @override
  String get businessCategoryNewspaper => 'செய்தித்தாள்';

  @override
  String get businessCategoryWaterCan => 'தண்ணீர் கேன்';

  @override
  String get businessCategoryTiffinFood => 'டிபன் / உணவு';

  @override
  String get businessCategoryKiranaGrocery => 'கிரானா / மளிகை';

  @override
  String get businessCategorySalonParlour => 'சலூன் / பார்லர்';

  @override
  String get businessCategoryConstructionLabour => 'கட்டுமான தொழிலாளி';

  @override
  String get businessCategoryTransportAuto => 'போக்குவரத்து / ஆட்டோ';

  @override
  String get businessCategoryOther => 'மற்றவை';

  @override
  String get bookAnAppointment => 'சந்திப்பை முன்பதிவு செய்யவும்';

  @override
  String get noSlotsAvailable => 'நேர வரிசைகள் இல்லை';

  @override
  String get trySelectingDifferentDate => 'வேறு தேதியை தேர்வு செய்து பாருங்கள்';

  @override
  String get availableSlots => 'கிடைக்கும் நேர வரிசைகள்';

  @override
  String get bookingConfirmedToast => 'முன்பதிவு உறுதிப்பட்டது!';

  @override
  String get date => 'தேதி';

  @override
  String get time => 'நேரம்';

  @override
  String get notesOptional => 'குறிப்புகள் (விருப்பத்தேர்வு)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes நிமிடம்';
  }

  @override
  String get saveChanges => 'மாற்றங்களை சேமி';

  @override
  String get saveProduct => 'பொருளை சேமி';

  @override
  String get editProductMenuItem => 'பொருளை திருத்தவும்';

  @override
  String get deleteProductMenuItem => 'பொருளை நீக்கவும்';

  @override
  String get noProductsYetDescription =>
      'பால், பனீர் போன்ற விற்கும் பொருட்களை ஒருமுறை வரையறுக்கவும், பிறகு தினமும் பயன்படுத்தவும்.';

  @override
  String get selectProductToAssignQty =>
      'அளவை நிர்ணயிக்க மேலே ஒரு பொருளை தேர்வு செய்யவும்';

  @override
  String get noCustomersLinked => 'இன்னும் வாடிக்கையாளர்கள் இணைக்கப்படவில்லை';

  @override
  String get chargeAll => 'அனைவரையும் வசூல்';

  @override
  String chargedSuccessfully(int count) {
    return '$count வாடிக்கையாளரிடம் வசூலிக்கப்பட்டது';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return '$count வாடிக்கையாளர்களிடம் வசூலிக்கப்பட்டது';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok வசூலிக்கப்பட்டது, $fail தோல்வி';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count வாடிக்கையாளர்  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count வாடிக்கையாளர்கள்  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return 'மொத்தம் ₹$amount';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'அடுத்தது: $vendorName · $date அன்று $time';
  }

  @override
  String get outstandingShortLabel => 'நிலுவை';

  @override
  String payViaUpiAmount(String amount) {
    return '₹$amount UPI மூலம் செலுத்தவும்';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return '$count விற்பனையாளர்களுக்கு செலுத்தப்பட்டது, $skipped தவிர்க்கப்பட்டது.';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return '$count விற்பனையாளருக்கு செலுத்தப்பட்டது, $skipped தவிர்க்கப்பட்டது.';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'அனைத்து $count விற்பனையாளர்களுக்கும் செலுத்தப்பட்டது.';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'அனைத்து $count விற்பனையாளருக்கும் செலுத்தப்பட்டது.';
  }

  @override
  String get tapToAcceptOrDecline => 'ஏற்க அல்லது நிராகரிக்க தட்டவும்';

  @override
  String get helpSupportContactPrefix =>
      'எந்த உதவிக்கும் எங்களை தொடர்பு கொள்ளுங்கள்:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'முன்பதிவு';

  @override
  String waitingForVendorAcceptance(String name) {
    return '$name உங்கள் கோரிக்கையை ஏற்கும் வரை காத்திருக்கிறோம்.';
  }

  @override
  String get vendorWantsToConnectAsCustomer =>
      'ஒரு விற்பனையாளர் இணைக்க விரும்புகிறார்';

  @override
  String get vendorWantsToConnectDesc =>
      'இவர் உங்களை வாடிக்கையாளராக சேர்த்து உங்கள் கணக்கை கண்காணிக்க விரும்புகிறார்.';

  @override
  String get someoneWantsToConnect => 'யாரோ இணைக்க விரும்புகிறார்';

  @override
  String get someoneWantsToConnectDesc =>
      'இவர் உங்கள் கணக்கில் வாடிக்கையாளராக சேர்க்கப்படுவார்.';

  @override
  String requestedTimeAgo(String time) {
    return '$time முன்பு கோரப்பட்டது';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'இணைக்கப்பட்டது! $name உங்கள் கணக்குடன் இணைக்கப்பட்டார்.';
  }

  @override
  String requestDeclinedFrom(String name) {
    return '$name இடமிருந்து வந்த கோரிக்கை நிராகரிக்கப்பட்டது.';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'இணைக்கப்பட்டது! $name உங்கள் வணிகத்துடன் இணைக்கப்பட்டார்.';
  }

  @override
  String get processing => 'செயலாக்குகிறது…';

  @override
  String get retryButton => 'மீண்டும் முயற்சி';

  @override
  String get memberDiscountDescription =>
      'இந்த நிலையில் உள்ள உறுப்பினர்களுக்கு அவர்களின் நிலுவையில் இந்த தள்ளுபடி கிடைக்கும்.';

  @override
  String get discountValueInvalid => '0 விட அதிகமான சரியான தொகையை உள்ளிடவும்';

  @override
  String get percentageExceedsMax => 'சதவீதம் 100 ஐ தாண்டக்கூடாது';

  @override
  String levelLabel(int level) {
    return 'நிலை $level';
  }

  @override
  String get rename => 'மறுபெயரிடு';

  @override
  String get membershipLabel => 'உறுப்பினர் திட்டம்';

  @override
  String get noMembership => 'உறுப்பினர் திட்டம் இல்லை';

  @override
  String get applyForMembership => 'உறுப்பினர் திட்டத்திற்கு விண்ணப்பிக்கவும்';

  @override
  String get setMembershipTier => 'உறுப்பினர் நிலை அமைக்கவும்';

  @override
  String get chooseTierToRequestFromVendor =>
      'இந்த விற்பனையாளரிடம் கோர ஒரு நிலை தேர்வு செய்யவும்';

  @override
  String chooseTierFor(String customerName) {
    return '$customerName க்கு ஒரு நிலை தேர்வு செய்யவும்';
  }

  @override
  String get setButton => 'அமை';

  @override
  String get changeButton => 'மாற்று';

  @override
  String get applyButton => 'விண்ணப்பி';

  @override
  String get approveButton => 'ஒப்புக்கொள்';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName $tierName கோரினார்';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return '$tierName கோரப்பட்டது — ஒப்புதல் காத்திருக்கிறது';
  }

  @override
  String get verificationConnecting => 'வங்கியுடன் இணைக்கிறது…';

  @override
  String get verificationVerifying => 'பரிவர்த்தனை சரிபார்க்கிறது…';

  @override
  String get verificationWaiting => 'உறுதிப்படுத்தலுக்காக காத்திருக்கிறது…';

  @override
  String get verificationAlmostThere => 'கிட்டத்தட்ட முடிந்தது…';

  @override
  String get verificationDoNotClose => 'இந்த திரையை மூடாதீர்கள்';

  @override
  String verificationElapsed(int seconds) {
    return '$seconds நி  •  இந்த திரையை மூடாதீர்கள்';
  }

  @override
  String txnLabel(String txnId) {
    return 'பரிவர்த்தனை: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '$name க்கு ₹$amount செலுத்தப்பட்டது';
  }

  @override
  String get verificationTimeoutBody =>
      '30 வினாடிகளுக்குள் உங்கள் கட்டணத்தை உறுதிப்படுத்த முடியவில்லை. உங்கள் பணம் கழிக்கப்படாமல் இருக்கலாம் — மீண்டும் முயற்சிக்கும் முன் உங்கள் வங்கி அறிக்கையை சரிபார்க்கவும்.';

  @override
  String get ifDebitedContactSupport =>
      'பணம் கழிக்கப்பட்டிருந்தால், பரிவர்த்தனை ஐடியுடன் ஆதரவை தொடர்பு கொள்ளவும்.';

  @override
  String get thisMonthSubtitle => 'இந்த மாதம்';

  @override
  String get billedNet => 'வசூலிக்கப்பட்டது (நிகர)';

  @override
  String get exclDisputed => 'சர்ச்சை தவிர்த்து';

  @override
  String get receivedLabel => 'பெறப்பட்டது';

  @override
  String get paymentsAndAdj => 'கட்டணங்கள் & சரிசெய்தல்';

  @override
  String get currentBalance => 'தற்போதைய இருப்பு';

  @override
  String paymentCount(int count) {
    return '$count கட்டணம்';
  }

  @override
  String paymentCountPlural(int count) {
    return '$count கட்டணங்கள்';
  }

  @override
  String customersCount(int count) {
    return '$count வாடிக்கையாளர்கள்';
  }

  @override
  String get rankedByOutstanding =>
      'நிலுவை தொகை அடிப்படையில் வரிசைப்படுத்தப்பட்டது';

  @override
  String collectedThisMonth(String amount) {
    return 'இந்த மாதம் ₹$amount';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return 'இம்மாதம் ₹$amount';
  }

  @override
  String get categoryAll => 'அனைத்தும்';

  @override
  String get findVendorsNearYou =>
      'அருகில் உள்ள விற்பனையாளர்களை கண்டுபிடிக்கவும்';

  @override
  String get searchByNameOrCategory =>
      'பெயர், வணிக பெயர் அல்லது மேலே உள்ள வகையை தேர்வு செய்து தேடவும்.';

  @override
  String noResultsForQuery(String query) {
    return '\"$query\" க்கு முடிவுகள் இல்லை.\nவேறு பெயர் அல்லது வகையை முயற்சிக்கவும்.';
  }

  @override
  String get addressLabel => 'முகவரி';

  @override
  String get emailLabel => 'மின்னஞ்சல்';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI ஐடி';

  @override
  String get upiEmailLabel => 'UPI / மின்னஞ்சல்';

  @override
  String get couldNotLoadRetry =>
      'ஏற்ற முடியவில்லை — மீண்டும் முயற்சிக்க தட்டவும்';

  @override
  String labelCopied(String label) {
    return '$label நகலெடுக்கப்பட்டது!';
  }

  @override
  String get upiIdCopied => 'UPI ஐடி நகலெடுக்கப்பட்டது!';

  @override
  String get requestSentButton => 'கோரிக்கை அனுப்பப்பட்டது';

  @override
  String get alreadyConnected => 'ஏற்கனவே இணைக்கப்பட்டது';

  @override
  String get sendingEllipsis => 'அனுப்புகிறது…';

  @override
  String get sendConnectionRequest => 'இணைப்பு கோரிக்கை அனுப்பவும்';

  @override
  String get copyUpiIdToPay => 'கட்டணத்திற்கு UPI ஐடியை நகலெடுக்கவும்';

  @override
  String requestSentToVendor(String name) {
    return 'கோரிக்கை அனுப்பப்பட்டது! $name க்கு அறிவிக்கப்படும்.';
  }

  @override
  String byOwnerName(String name) {
    return '$name மூலம்';
  }

  @override
  String get logOut => 'வெளியேறு';

  @override
  String get confirmLogoutTitle => 'வெளியேறு';

  @override
  String get areYouSureLogout => 'நீங்கள் வெளியேற விரும்புகிறீர்களா?';

  @override
  String get showQrToCollect =>
      'நேரடியாக கட்டணம் பெற வாடிக்கையாளரிடம் இந்த QR காட்டவும்.';

  @override
  String get uploadQr => 'QR பதிவேற்றவும்';

  @override
  String get replaceQr => 'மாற்றவும்';

  @override
  String get qrUploaded => 'QR பதிவேற்றப்பட்டது';

  @override
  String scanToPayName(String name) {
    return '$name க்கு கட்டணம் செலுத்த ஸ்கேன் செய்யவும்';
  }

  @override
  String get salarySingle => 'சம்பளம்';

  @override
  String get advanceSingle => 'முன்பணம்';

  @override
  String get customersTitle => 'வாடிக்கையாளர்கள்';

  @override
  String balanceDue(String balance) {
    return '₹$balance நிலுவை';
  }

  @override
  String get recordDeliveryTooltip => 'விநியோகத்தை பதிவு செய்யவும்';

  @override
  String get viewLedgerTooltip => 'கணக்கை பார்க்கவும்';

  @override
  String staffRoleSubtitle(String name) {
    return 'ஊழியர் · $name';
  }

  @override
  String get recordDelivery => 'உதார் கொடுத்தது';

  @override
  String get recordDeliverySubtitle =>
      'வாடிக்கையாளர் பொருள் எடுத்தார் — கணக்கில் சேர்க்கவும்';

  @override
  String get collectPayment => 'பணம் வந்தது';

  @override
  String get collectPaymentSubtitle =>
      'வாடிக்கையாளர் பணம் கொடுத்தார் — கணக்கில் குறைக்கவும்';

  @override
  String get viewAll2 => 'அனைத்தும் பார்க்க';

  @override
  String get noCustomersStaff => 'இன்னும் வாடிக்கையாளர்கள் இல்லை';

  @override
  String get myVendorsSection => 'என் விற்பனையாளர்கள்';

  @override
  String get shopsYouBuyFrom => 'நீங்கள் வாங்கும் கடைகள்';

  @override
  String get awaitingAcceptanceTitle => 'ஒப்புதல் காத்திருக்கிறது';

  @override
  String get customersHaventConfirmed =>
      'இந்த வாடிக்கையாளர்கள் இன்னும் உறுதிப்படுத்தவில்லை';

  @override
  String get pendingBadge => 'நிலுவையில்';

  @override
  String get notifyCustomersWithDues =>
      'நிலுவை உள்ள வாடிக்கையாளர்களுக்கு அறிவிக்கவும்';

  @override
  String get linkANewCustomer => 'புதிய வாடிக்கையாளரை இணைக்கவும்';

  @override
  String get dailyCharge => 'தினசரி வசூல்';

  @override
  String get dailyChargeSubtitle => 'அளவை அமைத்து ஒரே நேரத்தில் வசூலிக்கவும்';

  @override
  String get findByPhoneOrEmailHint =>
      'தொலைபேசி எண் அல்லது மின்னஞ்சல் மூலம் தேடவும்';

  @override
  String get phoneOrEmailLabel => 'தொலைபேசி அல்லது மின்னஞ்சல்';

  @override
  String get phoneMobileOrEmail => '10 இலக்க மொபைல் அல்லது மின்னஞ்சல் முகவரி';

  @override
  String get nicknameOptionalLabel => 'புனைப்பெயர் (விருப்பத்தேர்வு)';

  @override
  String get howYouKnowCustomer => 'இந்த வாடிக்கையாளரை எப்படி அறிவீர்கள்';

  @override
  String get requestSentWillBeNotified =>
      'கோரிக்கை அனுப்பப்பட்டது! உறுதிப்படுத்த அவர்களுக்கு அறிவிக்கப்படும்.';

  @override
  String get outstandingTitle => 'நிலுவை';

  @override
  String customersWithDues(int count) {
    return '$count+ நிலுவை உள்ள வாடிக்கையாளர்கள்';
  }

  @override
  String get dueLabel => 'நிலுவை';

  @override
  String get collectedTodayTitle => 'இன்று சேகரிக்கப்பட்டது';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ கட்டணங்கள்';
  }

  @override
  String get noPaymentsYetSubtitle => 'இன்னும் கட்டணங்கள் இல்லை';

  @override
  String removeLedgerVendorContent(String name) {
    return 'இது $name உடன் உங்கள் இணைப்பை செயலிழக்கும். இரு தரப்பும் இந்த பகிரப்பட்ட கணக்கை இழப்பார்கள்.';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'இது $name உடன் உங்கள் இணைப்பை நீக்கும்.';
  }

  @override
  String get offlineUpdatesPaused =>
      'இணைப்பு இல்லை — புதுப்பிப்புகள் நிறுத்தப்பட்டன';

  @override
  String get exportStatementTitle => 'அறிக்கையை ஏற்றுமதி செய்யவும்';

  @override
  String get chooseExportDateRange =>
      'PDF இல் சேர்க்க தேதி வரம்பை தேர்வு செய்யவும்.';

  @override
  String get last7DaysRange => 'கடந்த 7 நாட்களின் உள்ளீடுகள்';

  @override
  String get last30DaysRange => 'கடந்த 30 நாட்களின் உள்ளீடுகள்';

  @override
  String get last3MonthsRange => 'கடந்த 3 மாதங்களின் உள்ளீடுகள்';

  @override
  String get completeLedgerHistory => 'முழு கணக்கு வரலாறு';

  @override
  String appAccessActive(String phone) {
    return 'செயலில் · $phone';
  }

  @override
  String get appAccessDisabled => 'முடக்கப்பட்டது';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name இப்போது $phone மூலம் உள்நுழையலாம்';
  }

  @override
  String appAccessRevoked(String name) {
    return '$name இன் ஆப் அணுகல் ரத்து செய்யப்பட்டது';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'இயக்கும்போது, $name அவர்களின் சொந்த எண்ணில் ($phone) உள்நுழைந்து விநியோகங்களை பதிவு செய்யலாம், கட்டணங்களை பதிவு செய்யலாம், சொந்த QR காட்டலாம் — ஆனால் வருகையை மாற்றவோ, வாடிக்கையாளர்களை சேர்க்கவோ, மற்ற ஊழியர்களை பார்க்கவோ முடியாது.';
  }

  @override
  String get paymentHistoryTitle => 'கட்டண வரலாறு';

  @override
  String get couldNotLoadPaymentHistory => 'கட்டண வரலாற்றை ஏற்ற முடியவில்லை';

  @override
  String get voicePleaseCheck => 'சரிபார்க்கவும்';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get qty => 'அளவு';

  @override
  String totalRupees(String amount) {
    return 'மொத்தம்: ₹$amount';
  }

  @override
  String get selectCustomerFirst =>
      'முதலில் ஒரு வாடிக்கையாளரை தேர்வு செய்யவும்';

  @override
  String get enterValidAmount => 'சரியான தொகையை உள்ளிடவும்';

  @override
  String get addsCredit =>
      'வாடிக்கையாளர் பொருள் எடுத்தார் — கணக்கில் சேர்க்கவும்';

  @override
  String get recordsCash =>
      'வாடிக்கையாளர் பணம் கொடுத்தார் — கணக்கில் குறைக்கவும்';

  @override
  String deliveryRecordedFor(String name) {
    return '$name க்கு விநியோகம் பதிவு செய்யப்பட்டது';
  }

  @override
  String paymentCollectedFrom(String name) {
    return '$name இடமிருந்து கட்டணம் பெறப்பட்டது';
  }

  @override
  String get manageSchedule => 'அட்டவணையை நிர்வகிக்கவும்';

  @override
  String get bookingsTab => 'முன்பதிவுகள்';

  @override
  String get bySlotTab => 'நேர வரிசை வாரியாக';

  @override
  String get scheduleSaved => 'அட்டவணை சேமிக்கப்பட்டது!';

  @override
  String get addSlot => 'நேர வரிசை சேர்க்கவும்';

  @override
  String noSlotsForDay(String day) {
    return '$day க்கு நேர வரிசைகள் இல்லை';
  }

  @override
  String get tapAddSlotHint =>
      'கிடைக்கும் நேரத்தை அமைக்க \"நேர வரிசை சேர்க்கவும்\" தட்டவும்';

  @override
  String get slotAvailable => 'கிடைக்கும்';

  @override
  String get slotsFull => 'நிரம்பியது';

  @override
  String get slotFullHint =>
      'இந்த நேர வரிசையை முழுவதும் முன்பதிவு செய்யப்பட்டதாக குறிக்கவும்';

  @override
  String get enableSlotFirst => 'முதலில் நேர வரிசையை இயக்கவும்';

  @override
  String get deleteSlotTitle => 'நேர வரிசையை நீக்கவும்';

  @override
  String deleteSlotConfirm(String time) {
    return '$time நேர வரிசையை நீக்கவதா?';
  }

  @override
  String get endTimeAfterStart =>
      'முடிவு நேரம் தொடக்க நேரத்திற்கு பிறகு இருக்க வேண்டும்';

  @override
  String get slotOverlaps =>
      'இந்த நேர வரிசை ஏற்கனவே உள்ள ஒன்றுடன் மேல்பாடு ஆகிறது';

  @override
  String get addTimeSlot => 'நேர வரிசை சேர்க்கவும்';

  @override
  String get editTimeSlot => 'நேர வரிசையை திருத்தவும்';

  @override
  String get selectTimeHint =>
      '12 மணி நேர வடிவத்தில் தொடக்க மற்றும் முடிவு நேரத்தை தேர்வு செய்யவும்';

  @override
  String get startLabel => 'தொடக்கம்';

  @override
  String get endLabel => 'முடிவு';

  @override
  String get update => 'புதுப்பி';

  @override
  String get notifTabAll => 'அனைத்தும்';

  @override
  String get notifTabBookings => 'முன்பதிவுகள்';

  @override
  String get noBookingNotifications => 'முன்பதிவு அறிவிப்புகள் இல்லை';

  @override
  String get noBookingNotificationsSubtitle =>
      'முன்பதிவு கோரிக்கைகள் மற்றும் புதுப்பிப்புகள் இங்கே தெரியும்';

  @override
  String get bookingPillLabel => 'முன்பதிவு';

  @override
  String get slotDetailTitle => 'நேர வரிசை விவரங்கள்';

  @override
  String bookingsCount(int count) {
    return '$count முன்பதிவு';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$count முன்பதிவுகள்';
  }

  @override
  String pendingCountLabel(int count) {
    return '$count நிலுவையில்';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'வைத்திரு';

  @override
  String get deleteButton => 'நீக்கு';

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
  String get membershipPlansTitle => 'உறுப்பினர் திட்டங்கள்';

  @override
  String get newPlanButton => 'புதிய திட்டம்';

  @override
  String get deletePlanTitle => 'திட்டத்தை நீக்கவதா?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" நீக்கப்படும். இதை மீண்டும் மாற்ற முடியாது.';
  }

  @override
  String get inactiveLabel => 'செயலற்றது';

  @override
  String get noBenefitsAdded => 'நன்மைகள் சேர்க்கப்படவில்லை.';

  @override
  String get noMembershipPlans => 'இன்னும் உறுப்பினர் திட்டங்கள் இல்லை';

  @override
  String get tapNewPlanHint =>
      'முதல் திட்டத்தை உருவாக்க \"புதிய திட்டம்\" தட்டவும்.';

  @override
  String get membershipRequestsTitle => 'உறுப்பினர் கோரிக்கைகள்';

  @override
  String get noPendingRequests => 'நிலுவை கோரிக்கைகள் இல்லை';

  @override
  String get customersCanApplyHint =>
      'வாடிக்கையாளர்கள் தங்கள் கணக்கு திரையில் இருந்து\nஉறுப்பினர் திட்டத்திற்கு விண்ணப்பிக்கலாம்.';

  @override
  String get membersTitle => 'உறுப்பினர்கள்';

  @override
  String get noMembersYet => 'இன்னும் உறுப்பினர்கள் இல்லை';

  @override
  String get activeStat => 'செயலில்';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'காலாவதியாகும்';

  @override
  String get allPlansFilter => 'அனைத்து திட்டங்கள்';

  @override
  String daysLeft(int count) {
    return '$countநா மீதம்';
  }

  @override
  String daysLeftFull(int count) {
    return '$count நாட்கள்';
  }

  @override
  String get planNameLabel => 'திட்டத்தின் பெயர்';

  @override
  String get planNameHint => 'எ.கா. தங்க உறுப்பினர்';

  @override
  String get durationDaysLabel => 'கால அளவு (நாட்கள்)';

  @override
  String get priceRupeesLabel => 'விலை ₹';

  @override
  String get addBenefitButton => 'நன்மை சேர்க்கவும்';

  @override
  String get customLabel => 'தனிப்பயன்';

  @override
  String get customAdvanceLabel => 'தனிப்பயன் முன்பணம் ₹';

  @override
  String get benefitLabel => 'நன்மை';

  @override
  String get benefitHint => 'எ.கா. 4 முடி வெட்டு';

  @override
  String get planDetailsSection => 'திட்ட விவரங்கள்';

  @override
  String get benefitsSection => 'நன்மைகள்';

  @override
  String get advanceRequiredSection => 'தேவையான முன்பணம்';

  @override
  String get editPlanTitle => 'திட்டத்தை திருத்தவும்';

  @override
  String get createPlanTitle => 'உறுப்பினர் திட்டம் உருவாக்கவும்';

  @override
  String get publishPlanButton => 'திட்டத்தை வெளியிடவும்';

  @override
  String get planUpdatedToast => 'திட்டம் புதுப்பிக்கப்பட்டது';

  @override
  String get planPublishedToast => 'திட்டம் வெளியிடப்பட்டது';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · திட்டங்கள்';
  }

  @override
  String get noPlansAvailable => 'இன்னும் திட்டங்கள் இல்லை';

  @override
  String get vendorNoPlansHint =>
      'இந்த விற்பனையாளர் இன்னும் உறுப்பினர் திட்டங்கள் உருவாக்கவில்லை.';

  @override
  String applyForPlan(String planName) {
    return '$planName க்கு விண்ணப்பிக்கவும்';
  }

  @override
  String get messageToVendorOptional =>
      'விற்பனையாளருக்கு செய்தி (விருப்பத்தேர்வு)';

  @override
  String get messageToVendorHint => 'எ.கா. இந்த மாதம் என்னை சேர்க்கவும்';

  @override
  String get sendRequestButton => 'கோரிக்கை அனுப்பவும்';

  @override
  String get activeLabel => 'செயலில்';

  @override
  String get noAdditionalBenefits => 'கூடுதல் நன்மைகள் இல்லை';

  @override
  String get currentPlanLabel => 'தற்போதைய திட்டம்';

  @override
  String get requestPendingLabel => 'கோரிக்கை நிலுவையில்';

  @override
  String get applyLabel => 'விண்ணப்பி';

  @override
  String requestSentToName(String name) {
    return '$name க்கு கோரிக்கை அனுப்பப்பட்டது';
  }

  @override
  String get membershipDialogTitle => 'உறுப்பினர் திட்டம்';

  @override
  String pendingPlanPrefix(String planName) {
    return 'நிலுவையில்: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return '$name ஐ சேர்க்கவும்';
  }

  @override
  String get choosePlanHint =>
      'உறுப்பினர் திட்டத்தை தொடங்க ஒரு திட்டத்தை தேர்வு செய்யவும்.';

  @override
  String get noActivePlansHint =>
      'செயலில் திட்டங்கள் இல்லை. முதலில் உறுப்பினர் திட்டங்கள் → திட்டங்கள் இல் உருவாக்கவும்.';

  @override
  String get enrollLabel => 'சேர்';

  @override
  String get changeLabel => 'மாற்று';

  @override
  String get usedLabel => 'பயன்படுத்தப்பட்டது';

  @override
  String get useLabel => 'பயன்படுத்து';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count நாட்கள் மீதம்';
  }

  @override
  String get orderPlacedSuccess => 'ஆர்டர் வெற்றிகரமாக பதிவு செய்யப்பட்டது!';

  @override
  String orderFromVendor(String vendorName) {
    return '$vendorName இடமிருந்து ஆர்டர்';
  }

  @override
  String get addItemButton => 'பொருள் சேர்க்கவும்';

  @override
  String get orderNoteOptional => 'ஆர்டர் குறிப்பு (விருப்பத்தேர்வு)';

  @override
  String get totalLabel => 'மொத்தம்';

  @override
  String get placeOrderButton => 'ஆர்டர் செய்யவும்';

  @override
  String get itemNameRequired => 'பொருளின் பெயர் *';

  @override
  String get unitLabel => 'அலகு';

  @override
  String get unitHint => 'கிகி, லி…';

  @override
  String get unitPriceLabel => 'அலகு விலை ₹';

  @override
  String itemNumber(int number) {
    return 'பொருள் $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'துணை மொத்தம்: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'ஆர்டர் விவரங்கள்';

  @override
  String get proofPhotoLabel => 'ஆதார புகைப்படம்';

  @override
  String get tapToViewFullScreen => 'முழு திரையில் பார்க்க தட்டவும்';

  @override
  String get rejectButton => 'நிராகரி';

  @override
  String get confirmButton => 'உறுதிப்படுத்து';

  @override
  String get markAsDeliveredButton => 'விநியோகிக்கப்பட்டதாக குறிக்கவும்';

  @override
  String get confirmDeliveryTitle => 'விநியோகத்தை உறுதிப்படுத்தவும்';

  @override
  String get deliveryNoteOptional => 'விநியோக குறிப்பு (விருப்பத்தேர்வு)';

  @override
  String get retakeLabel => 'மீண்டும் எடு';

  @override
  String photoUploadFailed(String error) {
    return 'புகைப்படம் பதிவேற்றம் தோல்வி: $error';
  }

  @override
  String get orderNoteLabel => 'ஆர்டர் குறிப்பு';

  @override
  String get customerLabel => 'வாடிக்கையாளர்';

  @override
  String get ordersTitle => 'ஆர்டர்கள்';

  @override
  String get noOrdersYet => 'இன்னும் ஆர்டர்கள் இல்லை';

  @override
  String get markDeliveredButton => 'விநியோகிக்கப்பட்டதாக குறிக்கவும்';

  @override
  String get myOrdersTitle => 'என் ஆர்டர்கள்';

  @override
  String get deliverButton => 'விநியோகி';

  @override
  String get noPendingDeliveries => 'நிலுவை விநியோகங்கள் இல்லை';

  @override
  String get deliveriesTitle => 'விநியோகங்கள்';

  @override
  String get monthlyStatementTitle => 'மாத அறிக்கை';

  @override
  String get deliveryProofLabel => 'விநியோக ஆதாரம்';

  @override
  String get replacePhotoButton => 'புகைப்படத்தை மாற்றவும்';

  @override
  String get attachProofButton => 'ஆதாரத்தை இணைக்கவும்';

  @override
  String get uploadingLabel => 'பதிவேற்றுகிறது...';

  @override
  String get proofLockedHint =>
      'இந்த ஆதாரம் பூட்டப்பட்டது மற்றும் மாற்ற முடியாது';

  @override
  String get proofAttachedToast => 'ஆதாரம் இணைக்கப்பட்டது';

  @override
  String itemLabel(int number) {
    return 'பொருள் $number';
  }

  @override
  String get amountRequired => 'தொகை *';

  @override
  String get addItemLabel => 'பொருள் சேர்க்கவும்';

  @override
  String get totalAmountLabel => 'மொத்தம்';

  @override
  String get deactivate => 'முடக்கு';

  @override
  String get activate => 'இயக்கு';

  @override
  String get activeStatLabel => 'செயலில்';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'காலாவதியாகும்';

  @override
  String get closeLabel => 'மூடு';

  @override
  String pendingPlanLabel(String name) {
    return 'நிலுவையில்: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer $plan கோரினார்';
  }

  @override
  String itemsCount(int count) {
    return 'பொருட்கள் ($count)';
  }

  @override
  String get deliveryLabel => 'விநியோகம்';

  @override
  String markedDeliveredBy(String role) {
    return '$role மூலம் விநியோகிக்கப்பட்டதாக குறிக்கப்பட்டது';
  }

  @override
  String get deliveriesHint =>
      'ஆர்டர்கள் மூலம் விநியோகிக்கப்பட்ட பொருட்கள். உள்ளீட்டை தட்டி பொருட்களை பாருங்கள்.';
}
