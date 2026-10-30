// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'साथखाता';

  @override
  String get tagline => 'एक खाता, दोनों का';

  @override
  String get onboarding1Title => 'दो तरफा साझा खाता';

  @override
  String get onboarding1Subtitle =>
      'विक्रेता और ग्राहक दोनों के लिए एक ही खाता। दोनों एक ही सच देखते हैं।';

  @override
  String get onboarding2Title => 'वॉइस और बिल OCR';

  @override
  String get onboarding2Subtitle =>
      '12 भाषाओं में तुरंत एंट्री बनाने के लिए बोलें या बिल स्कैन करें।';

  @override
  String get onboarding3Title => 'एक टैप UPI भुगतान';

  @override
  String get onboarding3Subtitle => 'UPI से एक टैप में महीने का बकाया चुकाएं।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get next => 'अगला';

  @override
  String get skip => 'छोड़ें';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get chooseRole => 'अपनी भूमिका चुनें';

  @override
  String get vendor => 'विक्रेता';

  @override
  String get customer => 'ग्राहक';

  @override
  String get welcomeToSaathKhata => 'साथखाता में आपका स्वागत है';

  @override
  String get tellUsHowYouUse => 'बताएं आप ऐप का उपयोग कैसे करेंगे';

  @override
  String get vendorRoleTitle => 'मैं एक विक्रेता हूँ';

  @override
  String get vendorRoleSubtitle =>
      'व्यापार का खाता, कर्मचारी प्रबंधित करें और भुगतान लें।';

  @override
  String get customerRoleTitle => 'मैं एक ग्राहक हूँ';

  @override
  String get customerRoleSubtitle =>
      'विक्रेताओं के साथ खाता ट्रैक करें और UPI से भुगतान करें।';

  @override
  String get loginTitle => 'साथखाता में लॉगिन करें';

  @override
  String get enterMobile => 'जारी रखने के लिए जानकारी दर्ज करें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get verifyOtp => 'OTP सत्यापित करें';

  @override
  String get verifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get changePhoneNumber => 'फोन नंबर बदलें';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumber पर भेजे गए 6 अंक दर्ज करें';
  }

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'पासवर्ड दर्ज करें';

  @override
  String get loginButton => 'लॉगिन करें';

  @override
  String get noAccount => 'खाता नहीं है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get pleaseEnterCredentials => 'ईमेल और पासवर्ड दर्ज करें';

  @override
  String get fillRequiredFields => 'नाम, ईमेल और पासवर्ड भरें';

  @override
  String get passwordMinChars => 'कम से कम 8 अक्षर';

  @override
  String get completeProfile => 'प्रोफ़ाइल पूरी करें';

  @override
  String get enterYourName => 'अपना नाम दर्ज करें';

  @override
  String get egBusinessName => 'जैसे: कृष्णा डेयरी';

  @override
  String get selectCategory => 'श्रेणी चुनें';

  @override
  String get enterAddress => 'क्षेत्र या पूरा पता दर्ज करें';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get businessName => 'व्यवसाय का नाम';

  @override
  String get businessCategory => 'व्यवसाय श्रेणी';

  @override
  String get businessAddress => 'व्यवसाय का पता (वैकल्पिक)';

  @override
  String get upiId => 'UPI आईडी (भुगतान के लिए)';

  @override
  String get vendorDashboard => 'विक्रेता डैशबोर्ड';

  @override
  String get customerDashboard => 'ग्राहक डैशबोर्ड';

  @override
  String get customerMode => 'ग्राहक मोड';

  @override
  String get myVendors => 'मेरे विक्रेता';

  @override
  String get outstanding => 'बकाया';

  @override
  String get collectedToday => 'आज का संग्रह';

  @override
  String get quickActions => 'त्वरित क्रिया';

  @override
  String get scanBill => 'बिल स्कैन करें';

  @override
  String get remindAll => 'सभी को याद दिलाएं';

  @override
  String get addNew => 'नया जोड़ें';

  @override
  String get recentCustomers => 'हाल के ग्राहक';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String customerAddedSnackbar(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String get sharedLedger => 'साझा खाता';

  @override
  String get totalBalance => 'कुल शेष';

  @override
  String get statement => 'स्टेटमेंट';

  @override
  String get giveCredit => 'उधार दें';

  @override
  String get recordPayment => 'भुगतान रिकॉर्ड करें';

  @override
  String get giveCreditSheet => 'उधार दें';

  @override
  String get recordPaymentSheet => 'भुगतान रिकॉर्ड करें';

  @override
  String get filterAll => 'सभी';

  @override
  String get balanceCustomerOwes => 'ग्राहक पर बकाया है';

  @override
  String get balanceYouOwe => 'आप पर बकाया है';

  @override
  String get balanceSettled => 'चुकता';

  @override
  String get balanceYouOweVendor => 'आप पर दुकानदार का बकाया है';

  @override
  String get balanceVendorOwesYou => 'दुकानदार पर आपका बकाया है';

  @override
  String get ledgerInfoTitle => 'यह खाता कैसे काम करता है';

  @override
  String get statusConfirmed => 'पुष्टि हुई';

  @override
  String get statusConfirmedDesc =>
      'दोनों पक्षों की सहमति। एंट्री लॉक है और बदली नहीं जा सकती।';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusPendingDesc =>
      'ग्राहक की पुष्टि का इंतज़ार। 72 घंटे में स्वतः पुष्टि।';

  @override
  String get statusDisputed => 'विवादित';

  @override
  String get statusDisputedDesc =>
      'ग्राहक ने विवाद उठाया। विक्रेता की समीक्षा आवश्यक।';

  @override
  String get statusAutoConfirmed => 'स्वतः पुष्टि';

  @override
  String get entryTypeCreditLabel => 'उधार एंट्री';

  @override
  String get entryTypePaymentLabel => 'भुगतान प्राप्त';

  @override
  String get entryDetails => 'एंट्री विवरण';

  @override
  String get entryAmount => 'राशि';

  @override
  String get entryType => 'प्रकार';

  @override
  String get entryTypeCreditGiven => 'उधार (दिया)';

  @override
  String get entryTypePaymentReceived => 'भुगतान (प्राप्त)';

  @override
  String get entryDate => 'तारीख';

  @override
  String get entryDescription => 'विवरण';

  @override
  String get entryQuantity => 'मात्रा';

  @override
  String get entryConfirmedAt => 'पुष्टि तारीख';

  @override
  String get entryDisputeReason => 'विवाद कारण';

  @override
  String entryFor(String name) {
    return '$name के लिए';
  }

  @override
  String get description => 'विवरण';

  @override
  String get descriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get quantityOptional => 'मात्रा (वैकल्पिक)';

  @override
  String get descriptionHint => 'जैसे: 2L दूध, मासिक राशन';

  @override
  String get quantityHint => 'जैसे: 2';

  @override
  String get addCreditEntry => 'उधार एंट्री जोड़ें';

  @override
  String get noLedgerTransactions => 'अभी तक कोई लेनदेन नहीं';

  @override
  String get noLedgerTransactionsSubtitle =>
      'शुरू करने के लिए उधार या भुगतान एंट्री जोड़ें।';

  @override
  String get confirmEntryTitle => 'एंट्री की पुष्टि करें';

  @override
  String confirmEntryMessage(String amount) {
    return 'क्या आप ₹$amount की एंट्री की पुष्टि करना चाहते हैं? यह पूर्ववत नहीं होगा।';
  }

  @override
  String get dispute => 'विवाद';

  @override
  String get raiseDisputeTitle => 'विवाद उठाएं';

  @override
  String get raiseDisputeSubtitle => 'बताएं इस एंट्री में क्या गलत है।';

  @override
  String get raiseDisputeHint => 'जैसे: राशि ₹50 होनी चाहिए, ₹60 नहीं';

  @override
  String get submitDispute => 'विवाद दर्ज करें';

  @override
  String get staffAndLabour => 'स्टाफ और लेबर';

  @override
  String get addStaff => 'स्टाफ जोड़ें';

  @override
  String get presentToday => 'आज उपस्थित';

  @override
  String get unpaidSalary => 'अवैतनिक वेतन';

  @override
  String get paySalary => 'वेतन दें';

  @override
  String get noStaffAdded => 'अभी तक कोई स्टाफ नहीं';

  @override
  String get noStaffAddedSubtitle => 'पहला स्टाफ जोड़ने के लिए नीचे दबाएं।';

  @override
  String get present => 'उपस्थित';

  @override
  String get absent => 'अनुपस्थित';

  @override
  String get halfDay => 'आधा दिन';

  @override
  String get paySalaryTitle => 'वेतन दें';

  @override
  String unpaidLabel(String amount) {
    return 'अवैतनिक: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI लेनदेन आईडी (वैकल्पिक)';

  @override
  String get noDues => 'कोई बकाया नहीं';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount दें';
  }

  @override
  String staffJoined(String date) {
    return '$date को जुड़े';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/दिन';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/माह';
  }

  @override
  String get staffPayButton => 'भुगतान';

  @override
  String get businessReports => 'व्यापार रिपोर्ट';

  @override
  String get revenueTrend => 'राजस्व रुझान';

  @override
  String get collectionSummary => 'संग्रह सारांश';

  @override
  String get totalOutstanding => 'कुल बकाया';

  @override
  String get totalCollected => 'कुल संग्रह';

  @override
  String get topCustomers => 'शीर्ष ग्राहक';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appLanguage => 'ऐप भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get settingsManagePayments => 'भुगतान खाते प्रबंधित करें';

  @override
  String get settingsManageAlerts => 'अलर्ट और रिमाइंडर सेट करें';

  @override
  String get settingsAppPinFingerprint => 'ऐप पिन और फिंगरप्रिंट';

  @override
  String get settingsFaqsContact => 'सहायता और संपर्क';

  @override
  String settingsVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get myUpiIds => 'मेरी UPI आईडी';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get security => 'सुरक्षा';

  @override
  String get helpSupport => 'सहायता';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get markAllRead => 'सभी पढ़ा हुआ मार्क करें';

  @override
  String get noNotificationsTitle => 'अभी तक कोई सूचना नहीं';

  @override
  String get noNotificationsSubtitle =>
      'यहाँ खाता अपडेट, भुगतान अलर्ट और रिमाइंडर दिखेंगे।';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String minutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String hoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String get payments => 'भुगतान';

  @override
  String get transactionHistory => 'लेनदेन इतिहास';

  @override
  String get totalPaid => 'कुल भुगतान';

  @override
  String get pending => 'लंबित';

  @override
  String get quickPay => 'त्वरित भुगतान';

  @override
  String get scanAndPay => 'स्कैन और भुगतान';

  @override
  String get scanUpiDesc => 'विक्रेता को भुगतान के लिए UPI QR स्कैन करें';

  @override
  String get noTransactionsTitle => 'अभी तक कोई लेनदेन नहीं';

  @override
  String get noTransactionsSubtitle => 'आपका भुगतान इतिहास यहाँ दिखेगा।';

  @override
  String get paymentStatusPaid => 'भुगतान हुआ';

  @override
  String get paymentStatusFailed => 'विफल';

  @override
  String get paymentStatusRefunded => 'वापस';

  @override
  String get appointments => 'अपॉइंटमेंट';

  @override
  String get myAppointments => 'मेरे अपॉइंटमेंट';

  @override
  String get upcoming => 'आगामी';

  @override
  String get past => 'पिछले';

  @override
  String get cancelBooking => 'बुकिंग रद्द करें';

  @override
  String get keepBooking => 'रखें';

  @override
  String get noBookingsToday => 'आज कोई बुकिंग नहीं';

  @override
  String get noBookingsTodaySubtitle =>
      'ग्राहक ऐप से अपॉइंटमेंट बुक कर सकते हैं।';

  @override
  String get noAppointmentsTitle => 'अभी तक कोई अपॉइंटमेंट नहीं';

  @override
  String get noAppointmentsSubtitle =>
      'शुरुआत के लिए विक्रेता से अपॉइंटमेंट बुक करें।';

  @override
  String get cancelAppointmentTitle => 'अपॉइंटमेंट रद्द करें?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date को $time बजे का अपॉइंटमेंट रद्द करें?';
  }

  @override
  String get bookingStatusConfirmed => 'पुष्टि हुई';

  @override
  String get bookingStatusPending => 'लंबित';

  @override
  String get bookingStatusCancelled => 'रद्द';

  @override
  String get bookingStatusCompleted => 'पूर्ण';

  @override
  String get bookingStatusDone => 'पूर्ण';

  @override
  String get upiPayment => 'UPI भुगतान';

  @override
  String get amountToPay => 'भुगतान की राशि';

  @override
  String get securedByUpi => 'UPI द्वारा सुरक्षित';

  @override
  String get paymentSuccessful => 'भुगतान सफल!';

  @override
  String get paymentFailed => 'भुगतान विफल';

  @override
  String get retryPayment => 'फिर प्रयास करें';

  @override
  String get enterUpiId => 'UPI आईडी दर्ज करें';

  @override
  String get addNoteOptional => 'नोट जोड़ें (वैकल्पिक)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount भुगतान करें';
  }

  @override
  String get done => 'हो गया';

  @override
  String get paymentSomethingWentWrong => 'कुछ गलत हुआ। फिर से प्रयास करें।';

  @override
  String upiAppComingSoon(String app) {
    return '$app जल्द आ रहा है';
  }

  @override
  String get pleaseEnterUpiId => 'UPI आईडी दर्ज करें';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount, $name को भुगतान हुआ';
  }

  @override
  String get orDivider => 'या';

  @override
  String get addNewCustomer => 'नया ग्राहक जोड़ें';

  @override
  String get customerName => 'ग्राहक का नाम';

  @override
  String get mobileNo => 'मोबाइल नंबर';

  @override
  String get addCustomer => 'ग्राहक जोड़ें';

  @override
  String get paymentConfirmed => 'भुगतान की पुष्टि करें';

  @override
  String get addAdvance => 'अग्रिम जोड़ें';

  @override
  String get addAdvanceTitle => 'अग्रिम जोड़ें';

  @override
  String get attendanceTitle => 'उपस्थिति';

  @override
  String get salaryTitle => 'वेतन सारांश';

  @override
  String get rate => 'दर';

  @override
  String get daysPresent => 'उपस्थित दिन';

  @override
  String get earned => 'अर्जित';

  @override
  String get unpaid => 'अवैतनिक';

  @override
  String get advanceTaken => 'लिया गया अग्रिम';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get joined => 'जुड़े';

  @override
  String get noPhone => 'कोई फ़ोन नहीं';

  @override
  String get addNewStaff => 'नया स्टाफ जोड़ें';

  @override
  String get fullNameLabel => 'पूरा नाम';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get role => 'भूमिका';

  @override
  String get salaryType => 'वेतन प्रकार';

  @override
  String get dailyWage => 'दैनिक मजदूरी';

  @override
  String get monthlySalary => 'मासिक वेतन';

  @override
  String get dailyWageAmount => 'दैनिक मजदूरी (₹)';

  @override
  String get monthlySalaryAmount => 'मासिक वेतन (₹)';

  @override
  String get addStaffButton => 'स्टाफ जोड़ें';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String get amountRupees => 'राशि (₹)';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get tryAgain => 'फिर से प्रयास करें';

  @override
  String get alignBillInFrame => 'बिल को फ्रेम में रखें';

  @override
  String get verifyAndLogin => 'सत्यापित करें और लॉगिन करें';

  @override
  String get voiceListening => 'सुन रहा हूँ...';

  @override
  String get voiceThinking => 'सोच रहा हूँ...';

  @override
  String get voiceDetectedEntry => 'पहचानी गई एंट्री';

  @override
  String get voiceConfirmEntry => 'एंट्री कन्फर्म करें';

  @override
  String get item => 'वस्तु';

  @override
  String get totalOutstandingBalance => 'कुल बकाया राशि';

  @override
  String get payAllDues => 'सभी बकाया भुगतान करें';

  @override
  String get myKhatas => 'मेरे खाते';

  @override
  String get noVendorsFound => 'कोई विक्रेता नहीं मिला';

  @override
  String get verifyBillDetails => 'बिल विवरण सत्यापित करें';

  @override
  String get scannedBillPreview => 'स्कैन किया बिल';

  @override
  String get descriptionItemDetails => 'विवरण / वस्तु की जानकारी';

  @override
  String get selectCustomer => 'ग्राहक चुनें';

  @override
  String get searchCustomerHint => 'ग्राहक खोजें या चुनें';

  @override
  String get saveToKhata => 'खाते में सेव करें';

  @override
  String get allCustomersReport => 'सभी ग्राहक रिपोर्ट';

  @override
  String collectedInMonth(String month) {
    return '$month में संग्रह';
  }

  @override
  String get notificationSettings => 'नोटिफिकेशन सेटिंग';

  @override
  String get securityPin => 'सुरक्षा और पिन';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get accountSettings => 'खाता सेटिंग';

  @override
  String get legalInfo => 'कानूनी';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नया पासवर्ड दोबारा दर्ज करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get changePasswordButton => 'पासवर्ड बदलें';

  @override
  String get passwordChangedSuccess => 'पासवर्ड सफलतापूर्वक बदला गया';

  @override
  String get loadingContent => 'लोड हो रहा है...';

  @override
  String get failedToLoad =>
      'सामग्री लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get bookingActions => 'बुकिंग कार्रवाई';

  @override
  String get confirmBooking => 'बुकिंग कन्फर्म करें';

  @override
  String get markComplete => 'पूरा हुआ';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer की $date को $time बजे अपॉइंटमेंट कन्फर्म करें?';
  }

  @override
  String get bookingUpdated => 'बुकिंग सफलतापूर्वक अपडेट हुई';

  @override
  String get bookingUpdateFailed => 'बुकिंग अपडेट करने में विफल';

  @override
  String markAttendanceFor(String date) {
    return 'उपस्थिति दर्ज करें — $date';
  }

  @override
  String get allCustomers => 'सभी ग्राहक';

  @override
  String get noCustomersYet => 'अभी तक कोई ग्राहक नहीं';

  @override
  String get noCustomersYetSubtitle =>
      'शुरू करने के लिए अपना पहला ग्राहक जोड़ें';

  @override
  String get invalidPhone =>
      '6–9 से शुरू होने वाला 10 अंकों का वैध मोबाइल नंबर दर्ज करें';

  @override
  String accrueMonthSalary(String amount) {
    return 'माह की तनख्वाह जोड़ें (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'माह की तनख्वाह जोड़ें';

  @override
  String get removeStaffTitle => 'स्टाफ सदस्य हटाएं';

  @override
  String removeStaffConfirm(String name) {
    return '$name को स्टाफ से हटाएं? उनका ऐप एक्सेस तुरंत रद्द हो जाएगा।';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name के बकाया में इस महीने ₹$amount जोड़ें?';
  }

  @override
  String get accountInformation => 'खाता जानकारी';

  @override
  String get updateProfileDetails => 'अपना नाम, फ़ोटो और जानकारी अपडेट करें';

  @override
  String get updateAccountPassword => 'अपना खाता पासवर्ड अपडेट करें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountSubtitle => 'खाता और सारा डेटा स्थायी रूप से हटाएं';

  @override
  String get deleteAccountConfirmation => 'खाता हटाएं?';

  @override
  String get deleteAccountConfirmationMessage =>
      'यह आपका खाता और सारा डेटा स्थायी रूप से हटा देगा। यह कार्रवाई पूर्ववत नहीं होगी।';

  @override
  String get deleteAccountStaffWarning =>
      'यह आपका खाता स्थायी रूप से हटा देगा। यह पूर्ववत नहीं होगा।';

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
  String get deleteForever => 'हमेशा के लिए हटाएं';

  @override
  String get delete => 'हटाएं';

  @override
  String get readTermsOfService => 'हमारी सेवा शर्तें पढ़ें';

  @override
  String get privacyPolicyDescription => 'हम आपका डेटा कैसे संभालते हैं';

  @override
  String get confirmLogout => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get membershipTiers => 'सदस्यता स्तर';

  @override
  String get membershipTiersDescription =>
      'स्तरों का नाम बदलें और सदस्य छूट सेट करें';

  @override
  String get logIn => 'लॉगिन करें';

  @override
  String get enterPhoneNumberToContinue =>
      'जारी रखने के लिए फ़ोन नंबर दर्ज करें';

  @override
  String get havingTrouble => 'कोई समस्या है?';

  @override
  String get useEmailInstead => 'ईमेल से लॉगिन करें →';

  @override
  String get logInWithEmail => 'ईमेल से लॉगिन करें';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get enterYourPassword => 'पासवर्ड दर्ज करें';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएं';

  @override
  String get tapToAddProfilePhoto => 'प्रोफ़ाइल फ़ोटो जोड़ने के लिए टैप करें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get add => 'जोड़ें';

  @override
  String get addUpiId => 'UPI आईडी जोड़ें';

  @override
  String get save => 'सेव करें';

  @override
  String get close => 'बंद करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get remove => 'हटाएं';

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get none => 'कोई नहीं';

  @override
  String get percent => 'प्रतिशत';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get paymentVerification => 'भुगतान सत्यापन';

  @override
  String get verifyingPayment => 'भुगतान सत्यापित हो रहा है';

  @override
  String get paymentConfirmedExclamation => 'भुगतान की पुष्टि!';

  @override
  String get verificationTimedOut => 'सत्यापन समय समाप्त';

  @override
  String get goBack => 'वापस जाएं';

  @override
  String get payDues => 'बकाया चुकाएं';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get allDone => 'सब हो गया!';

  @override
  String get noUpcomingAppointments => 'कोई आगामी अपॉइंटमेंट नहीं';

  @override
  String get myPay => 'मेरा वेतन';

  @override
  String get myPaymentQr => 'मेरा भुगतान QR';

  @override
  String get showMyQr => 'मेरा QR दिखाएं';

  @override
  String get noPaymentsYet => 'अभी तक कोई भुगतान नहीं';

  @override
  String get paymentHistory => 'भुगतान इतिहास';

  @override
  String get paymentHistory6Months => 'भुगतान इतिहास (6 महीने)';

  @override
  String get connectionRequest => 'कनेक्शन अनुरोध';

  @override
  String get vendorWantsToConnect => 'एक विक्रेता जुड़ना चाहता है';

  @override
  String get acceptRequest => 'स्वीकार करें';

  @override
  String get declineRequest => 'अस्वीकार करें';

  @override
  String get messageLabel => 'संदेश';

  @override
  String get sendRequest => 'अनुरोध भेजें';

  @override
  String get requestSentNotification =>
      'अनुरोध भेज दिया! उन्हें सूचित किया जाएगा।';

  @override
  String get awaitingAcceptance => 'स्वीकृति की प्रतीक्षा';

  @override
  String get addAVendor => 'विक्रेता जोड़ें';

  @override
  String get findByPhoneOrEmail => 'फ़ोन नंबर या ईमेल से खोजें';

  @override
  String get phoneOrEmail => 'फ़ोन या ईमेल';

  @override
  String get phoneOrEmailHint => '10 अंक मोबाइल या ईमेल पता';

  @override
  String get nicknameOptional => 'उपनाम (वैकल्पिक)';

  @override
  String get howYouKnowVendor => 'आप इस विक्रेता को कैसे जानते हैं';

  @override
  String get bookingNoteExample => 'जैसे: आज अतिरिक्त दूध चाहिए';

  @override
  String get confirmLocation => 'स्थान की पुष्टि करें';

  @override
  String get moveMapToSelectLocation => 'स्थान चुनने के लिए मैप हिलाएं';

  @override
  String get searchPlaceHint => 'कोई स्थान खोजें…';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get searchVendorsHint => 'विक्रेता खोजें…';

  @override
  String get somethingWentWrong => 'कुछ गलत हुआ';

  @override
  String get payViaUpi => 'UPI से भुगतान';

  @override
  String get connectWithVendor => 'जुड़ें';

  @override
  String get requestConnection => 'कनेक्शन अनुरोध';

  @override
  String get addVendor => 'विक्रेता जोड़ें';

  @override
  String get noOutstandingBalances => 'कोई बकाया शेष नहीं';

  @override
  String get allCustomersSettledUp => 'सभी ग्राहकों का हिसाब बराबर है।';

  @override
  String get nothingCollectedToday => 'आज कुछ नहीं उगाया';

  @override
  String get paymentsWillAppearHere => 'आज प्राप्त भुगतान यहाँ दिखेंगे।';

  @override
  String get customerReport => 'ग्राहक रिपोर्ट';

  @override
  String get overview => 'अवलोकन';

  @override
  String get tapToStop => 'रोकने के लिए टैप करें';

  @override
  String get itemName => 'वस्तु का नाम';

  @override
  String get itemNameExample => 'जैसे: दूध';

  @override
  String get unitPrice => 'प्रति इकाई मूल्य ₹';

  @override
  String get deliverTo => 'डिलीवरी करें';

  @override
  String get bulkCharge => 'बल्क चार्ज';

  @override
  String get newProduct => 'नया उत्पाद';

  @override
  String get editProduct => 'उत्पाद संपादित करें';

  @override
  String get newProductService => 'नया उत्पाद / सेवा';

  @override
  String get updateProductDetails => 'नाम, इकाई या मूल्य अपडेट करें';

  @override
  String get defineProduct => 'बताएं आप क्या बेचते हैं और उसकी कीमत';

  @override
  String get productName => 'उत्पाद का नाम';

  @override
  String get productNameExample => 'जैसे: सुबह का दूध';

  @override
  String get unit => 'इकाई';

  @override
  String get unitExample => 'लीटर / किलो / टुकड़ा';

  @override
  String get pricePerUnit => 'प्रति इकाई मूल्य (₹)';

  @override
  String get deleteProduct => 'उत्पाद हटाएं';

  @override
  String get deleteProductConfirmation => 'उत्पाद हटाएं?';

  @override
  String removeProductConfirmation(String name) {
    return '\"$name\" को उत्पाद सूची से हटाएं?';
  }

  @override
  String get noProductsYet => 'अभी तक कोई उत्पाद नहीं';

  @override
  String get addFirstProduct => 'पहला उत्पाद जोड़ें';

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
  String get renameTier => 'स्तर का नाम बदलें';

  @override
  String get tierName => 'स्तर का नाम';

  @override
  String tierLevel(int level) {
    return 'स्तर $level';
  }

  @override
  String get memberDiscount => 'सदस्य छूट';

  @override
  String discountFor(String tier) {
    return '$tier के लिए छूट';
  }

  @override
  String get flatAmount => 'फ्लैट ₹';

  @override
  String get discountPercent => 'छूट %';

  @override
  String get discountAmount => 'छूट राशि (₹)';

  @override
  String get percentExample => 'जैसे: 5';

  @override
  String get amountExample => 'जैसे: 50';

  @override
  String get maxDiscountPerDue => 'अधिकतम छूट प्रति बकाया (₹) — वैकल्पिक';

  @override
  String get maxDiscountExample => 'जैसे: 100 (सीमा नहीं चाहिए तो खाली छोड़ें)';

  @override
  String get saveDiscount => 'छूट सेव करें';

  @override
  String get membership => 'सदस्यता';

  @override
  String get setTier => 'सेट करें';

  @override
  String get changeTier => 'बदलें';

  @override
  String get applyMembership => 'लागू करें';

  @override
  String get removeMembership => 'सदस्यता हटाएं';

  @override
  String get removeLedgerConfirmation => 'खाता हटाएं?';

  @override
  String get exportStatement => 'स्टेटमेंट एक्सपोर्ट करें';

  @override
  String get appAccess => 'ऐप एक्सेस';

  @override
  String get invalidPhoneNumber =>
      'सही 10 अंकों का भारतीय मोबाइल नंबर दर्ज करें';

  @override
  String get enterAll6Digits => 'सभी 6 अंक दर्ज करें';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress => 'सही ईमेल पता दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड दर्ज करें';

  @override
  String get nameRequired => 'नाम जरूरी है';

  @override
  String get required => 'जरूरी';

  @override
  String get invalidUpiFormat => 'UPI आईडी का फॉर्मेट गलत है (जैसे: name@upi)';

  @override
  String get upiIdAlreadyAdded => 'यह UPI आईडी पहले से जुड़ी है';

  @override
  String get verifyButton => 'सत्यापित करें';

  @override
  String get createAccountButton => 'खाता बनाएं';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get mobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get personalInfo => 'व्यक्तिगत जानकारी';

  @override
  String get businessInfo => 'व्यवसाय की जानकारी';

  @override
  String get enterOtpTitle => 'OTP दर्ज करें';

  @override
  String get sentToLabel => 'भेजा गया';

  @override
  String get noOtpReceived => 'OTP नहीं मिला?';

  @override
  String get resendOtp => 'OTP दोबारा भेजें';

  @override
  String get uploadingPhotoLabel => 'फ़ोटो अपलोड हो रही है...';

  @override
  String get phoneNumberLabel => 'फ़ोन नंबर';

  @override
  String get iAmA => 'मैं एक हूँ';

  @override
  String get dualRoleExplanation =>
      'आप मुख्यतः विक्रेता अनुभव का उपयोग करेंगे। आपका ग्राहक खाता अलग से एक्सेस किया जा सकता है।';

  @override
  String get profileSavedPhotoFailed =>
      'प्रोफ़ाइल सेव हुई — फ़ोटो अभी अपलोड नहीं हो सकी';

  @override
  String get profileUpdatedSuccess => 'प्रोफ़ाइल सफलतापूर्वक अपडेट हुई';

  @override
  String get addUpiIdTitle => 'UPI आईडी जोड़ें';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get primaryUpiInfo => 'मुख्य UPI आईडी';

  @override
  String get primaryUpiDescription =>
      'मुख्य आईडी ग्राहकों के साथ भुगतान के लिए साझा होती है। मुख्य बदलने के लिए स्टार पर टैप करें।';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI आईडी';
  }

  @override
  String get primaryUpiIdTooltip => 'मुख्य UPI आईडी';

  @override
  String get setAsPrimaryTooltip => 'मुख्य के रूप में सेट करें';

  @override
  String get primaryLabel => 'मुख्य';

  @override
  String get removeButtonLabel => 'हटाएं';

  @override
  String get noUpiIdsEmpty => 'अभी कोई UPI आईडी नहीं';

  @override
  String get upiEmptyDescription =>
      '5 तक UPI आईडी जोड़ें। मुख्य आईडी ग्राहकों को भुगतान के लिए साझा होगी।';

  @override
  String get changePasswordSubtitle =>
      'अपना मौजूदा पासवर्ड और नया पासवर्ड दर्ज करें।';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get goBackButton => 'वापस जाएं';

  @override
  String get saveButton => 'सेव करें';

  @override
  String get language => 'भाषा';

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
      'इसे इस्तेमाल करने के लिए आपके खाते में पासवर्ड होना जरूरी है।\nसेटिंग्स → पासवर्ड बदलें से सेट करें।';

  @override
  String get usePhoneInstead => 'फ़ोन नंबर से लॉगिन करें →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'सत्र समाप्त हो गया। कृपया फ़ोन दोबारा सत्यापित करें।';

  @override
  String get upiIdsSavedSuccessfully => 'UPI आईडी सफलतापूर्वक सेव हुई';

  @override
  String get chooseYourLanguageHindi => 'आपकी भाषा चुनें';

  @override
  String get unknownLanguage => 'अज्ञात';

  @override
  String get businessCategoryMilkDairy => 'दूध / डेयरी';

  @override
  String get businessCategoryPressDhobi => 'प्रेस / धोबी';

  @override
  String get businessCategoryMaidCook => 'बाई / कुक';

  @override
  String get businessCategoryNewspaper => 'अखबार';

  @override
  String get businessCategoryWaterCan => 'वाटर कैन';

  @override
  String get businessCategoryTiffinFood => 'टिफ़िन / खाना';

  @override
  String get businessCategoryKiranaGrocery => 'किराना / ग्रोसरी';

  @override
  String get businessCategorySalonParlour => 'सैलून / पार्लर';

  @override
  String get businessCategoryConstructionLabour => 'निर्माण मजदूर';

  @override
  String get businessCategoryTransportAuto => 'ट्रांसपोर्ट / ऑटो';

  @override
  String get businessCategoryOther => 'अन्य';

  @override
  String get bookAnAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get noSlotsAvailable => 'कोई स्लॉट उपलब्ध नहीं';

  @override
  String get trySelectingDifferentDate => 'कोई अलग तारीख चुनें';

  @override
  String get availableSlots => 'उपलब्ध स्लॉट';

  @override
  String get bookingConfirmedToast => 'बुकिंग कन्फर्म हुई!';

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get notesOptional => 'नोट (वैकल्पिक)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get saveChanges => 'बदलाव सेव करें';

  @override
  String get saveProduct => 'उत्पाद सेव करें';

  @override
  String get editProductMenuItem => 'उत्पाद संपादित करें';

  @override
  String get deleteProductMenuItem => 'उत्पाद हटाएं';

  @override
  String get noProductsYetDescription =>
      'जो सामान आप बेचते हैं — दूध, पनीर आदि — एक बार दर्ज करें, फिर रोज काम में लें।';

  @override
  String get selectProductToAssignQty =>
      'मात्रा तय करने के लिए ऊपर से उत्पाद चुनें';

  @override
  String get noCustomersLinked => 'अभी कोई ग्राहक नहीं जुड़ा';

  @override
  String get chargeAll => 'सभी को चार्ज करें';

  @override
  String chargedSuccessfully(int count) {
    return '$count ग्राहक को चार्ज किया गया';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return '$count ग्राहकों को चार्ज किया गया';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok चार्ज हुए, $fail विफल';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count ग्राहक  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count ग्राहक  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return '₹$amount कुल';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'अगला: $vendorName · $date को $time बजे';
  }

  @override
  String get outstandingShortLabel => 'बकाया';

  @override
  String payViaUpiAmount(String amount) {
    return '₹$amount UPI से चुकाएं';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return '$count विक्रेताओं को भुगतान हुआ, $skipped छोड़े।';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return '$count विक्रेता को भुगतान हुआ, $skipped छोड़े।';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'सभी $count विक्रेताओं को भुगतान हुआ।';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'सभी $count विक्रेता को भुगतान हुआ।';
  }

  @override
  String get tapToAcceptOrDecline => 'स्वीकार या अस्वीकार करने के लिए टैप करें';

  @override
  String get helpSupportContactPrefix =>
      'किसी भी सहायता के लिए हमसे संपर्क करें:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'बुक करें';

  @override
  String waitingForVendorAcceptance(String name) {
    return '$name के स्वीकार करने का इंतज़ार है।';
  }

  @override
  String get vendorWantsToConnectAsCustomer => 'एक विक्रेता जुड़ना चाहता है';

  @override
  String get vendorWantsToConnectDesc =>
      'वे आपको ग्राहक के रूप में जोड़ना और आपका खाता ट्रैक करना चाहते हैं।';

  @override
  String get someoneWantsToConnect => 'कोई जुड़ना चाहता है';

  @override
  String get someoneWantsToConnectDesc =>
      'उन्हें आपके खाते में ग्राहक के रूप में जोड़ा जाएगा।';

  @override
  String requestedTimeAgo(String time) {
    return '$time पहले अनुरोध किया';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'जुड़ गए! $name अब आपके खाते से जुड़ा है।';
  }

  @override
  String requestDeclinedFrom(String name) {
    return '$name का अनुरोध अस्वीकार किया।';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'जुड़ गए! $name अब आपके व्यवसाय से जुड़ा है।';
  }

  @override
  String get processing => 'प्रोसेस हो रहा है…';

  @override
  String get retryButton => 'फिर प्रयास करें';

  @override
  String get memberDiscountDescription =>
      'इस स्तर के सदस्यों को उनके बकाये पर यह छूट मिलेगी।';

  @override
  String get discountValueInvalid => '0 से अधिक की वैध राशि दर्ज करें';

  @override
  String get percentageExceedsMax => 'प्रतिशत 100 से अधिक नहीं हो सकता';

  @override
  String levelLabel(int level) {
    return 'स्तर $level';
  }

  @override
  String get rename => 'नाम बदलें';

  @override
  String get membershipLabel => 'सदस्यता';

  @override
  String get noMembership => 'कोई सदस्यता नहीं';

  @override
  String get applyForMembership => 'सदस्यता के लिए आवेदन करें';

  @override
  String get setMembershipTier => 'सदस्यता स्तर सेट करें';

  @override
  String get chooseTierToRequestFromVendor =>
      'विक्रेता से अनुरोध के लिए स्तर चुनें';

  @override
  String chooseTierFor(String customerName) {
    return '$customerName के लिए स्तर चुनें';
  }

  @override
  String get setButton => 'सेट करें';

  @override
  String get changeButton => 'बदलें';

  @override
  String get applyButton => 'लागू करें';

  @override
  String get approveButton => 'मंजूर करें';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName ने $tierName मांगा';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return '$tierName का अनुरोध — स्वीकृति बाकी';
  }

  @override
  String get verificationConnecting => 'बैंक से जोड़ रहे हैं…';

  @override
  String get verificationVerifying => 'लेनदेन सत्यापित हो रहा है…';

  @override
  String get verificationWaiting => 'पुष्टि का इंतज़ार है…';

  @override
  String get verificationAlmostThere => 'बस थोड़ा और…';

  @override
  String get verificationDoNotClose => 'यह स्क्रीन बंद न करें';

  @override
  String verificationElapsed(int seconds) {
    return '${seconds}s  •  यह स्क्रीन बंद न करें';
  }

  @override
  String txnLabel(String txnId) {
    return 'Txn: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '₹$amount $name को भुगतान हुआ';
  }

  @override
  String get verificationTimeoutBody =>
      '30 सेकंड में भुगतान की पुष्टि नहीं हो सकी। आपके खाते से पैसे नहीं कटे होंगे — दोबारा प्रयास से पहले बैंक स्टेटमेंट जांचें।';

  @override
  String get ifDebitedContactSupport =>
      'कटे हों तो Txn ID के साथ सपोर्ट से संपर्क करें।';

  @override
  String get thisMonthSubtitle => 'इस महीने';

  @override
  String get billedNet => 'बिल (नेट)';

  @override
  String get exclDisputed => 'विवादित छोड़कर';

  @override
  String get receivedLabel => 'प्राप्त';

  @override
  String get paymentsAndAdj => 'भुगतान और समायोजन';

  @override
  String get currentBalance => 'मौजूदा शेष';

  @override
  String paymentCount(int count) {
    return '$count भुगतान';
  }

  @override
  String paymentCountPlural(int count) {
    return '$count भुगतान';
  }

  @override
  String customersCount(int count) {
    return '$count ग्राहक';
  }

  @override
  String get rankedByOutstanding => 'बकाया राशि के अनुसार क्रम';

  @override
  String collectedThisMonth(String amount) {
    return '₹$amount इस महीने';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return '₹$amount इस मो.';
  }

  @override
  String get categoryAll => 'सभी';

  @override
  String get findVendorsNearYou => 'अपने पास विक्रेता खोजें';

  @override
  String get searchByNameOrCategory =>
      'नाम, व्यवसाय के नाम से खोजें,\nया ऊपर से श्रेणी चुनें।';

  @override
  String noResultsForQuery(String query) {
    return '\"$query\" के लिए कोई नतीजा नहीं।\nकोई अलग नाम या श्रेणी आज़माएं।';
  }

  @override
  String get addressLabel => 'पता';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI आईडी';

  @override
  String get upiEmailLabel => 'UPI / ईमेल';

  @override
  String get couldNotLoadRetry =>
      'लोड नहीं हो सका — दोबारा प्रयास के लिए टैप करें';

  @override
  String labelCopied(String label) {
    return '$label कॉपी हुआ!';
  }

  @override
  String get upiIdCopied => 'UPI आईडी कॉपी हुई!';

  @override
  String get requestSentButton => 'अनुरोध भेजा';

  @override
  String get alreadyConnected => 'पहले से जुड़े हैं';

  @override
  String get sendingEllipsis => 'भेज रहे हैं…';

  @override
  String get sendConnectionRequest => 'कनेक्शन अनुरोध भेजें';

  @override
  String get copyUpiIdToPay => 'भुगतान के लिए UPI आईडी कॉपी करें';

  @override
  String requestSentToVendor(String name) {
    return 'अनुरोध भेजा! $name को सूचित किया जाएगा।';
  }

  @override
  String byOwnerName(String name) {
    return '$name द्वारा';
  }

  @override
  String get logOut => 'लॉगआउट';

  @override
  String get confirmLogoutTitle => 'लॉगआउट';

  @override
  String get areYouSureLogout => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get showQrToCollect =>
      'सीधे भुगतान पाने के लिए यह QR ग्राहक को दिखाएं।';

  @override
  String get uploadQr => 'QR अपलोड करें';

  @override
  String get replaceQr => 'बदलें';

  @override
  String get qrUploaded => 'QR अपलोड हुआ';

  @override
  String scanToPayName(String name) {
    return '$name को स्कैन करके चुकाएं';
  }

  @override
  String get salarySingle => 'वेतन';

  @override
  String get advanceSingle => 'अग्रिम';

  @override
  String get customersTitle => 'ग्राहक';

  @override
  String balanceDue(String balance) {
    return '₹$balance बकाया';
  }

  @override
  String get recordDeliveryTooltip => 'डिलीवरी दर्ज करें';

  @override
  String get viewLedgerTooltip => 'खाता देखें';

  @override
  String staffRoleSubtitle(String name) {
    return 'स्टाफ · $name';
  }

  @override
  String get recordDelivery => 'उधार दिया';

  @override
  String get recordDeliverySubtitle => 'ग्राहक ने सामान लिया — खाते में जोड़ें';

  @override
  String get collectPayment => 'पैसा मिला';

  @override
  String get collectPaymentSubtitle => 'ग्राहक ने भुगतान किया — खाते से घटाएं';

  @override
  String get viewAll2 => 'सभी देखें';

  @override
  String get noCustomersStaff => 'अभी कोई ग्राहक नहीं';

  @override
  String get myVendorsSection => 'मेरे विक्रेता';

  @override
  String get shopsYouBuyFrom => 'जिन दुकानों से आप खरीदते हैं';

  @override
  String get awaitingAcceptanceTitle => 'स्वीकृति बाकी';

  @override
  String get customersHaventConfirmed => 'इन ग्राहकों ने अभी पुष्टि नहीं की';

  @override
  String get pendingBadge => 'लंबित';

  @override
  String get notifyCustomersWithDues => 'बकाया ग्राहकों को सूचित करें';

  @override
  String get linkANewCustomer => 'नया ग्राहक जोड़ें';

  @override
  String get dailyCharge => 'रोज़ का चार्ज';

  @override
  String get dailyChargeSubtitle =>
      'मात्रा सेट करें और एक साथ सभी को चार्ज करें';

  @override
  String get findByPhoneOrEmailHint => 'फ़ोन नंबर या ईमेल से खोजें';

  @override
  String get phoneOrEmailLabel => 'फ़ोन या ईमेल';

  @override
  String get phoneMobileOrEmail => '10 अंकों का मोबाइल या ईमेल पता';

  @override
  String get nicknameOptionalLabel => 'उपनाम (वैकल्पिक)';

  @override
  String get howYouKnowCustomer => 'आप इस ग्राहक को कैसे जानते हैं';

  @override
  String get requestSentWillBeNotified =>
      'अनुरोध भेजा! पुष्टि के लिए उन्हें सूचित किया जाएगा।';

  @override
  String get outstandingTitle => 'बकाया';

  @override
  String customersWithDues(int count) {
    return '$count+ ग्राहकों का बकाया';
  }

  @override
  String get dueLabel => 'बकाया';

  @override
  String get collectedTodayTitle => 'आज का संग्रह';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ भुगतान';
  }

  @override
  String get noPaymentsYetSubtitle => 'अभी कोई भुगतान नहीं';

  @override
  String removeLedgerVendorContent(String name) {
    return 'इससे $name के साथ आपका लिंक निष्क्रिय हो जाएगा। दोनों पक्षों का साझा खाते तक एक्सेस हट जाएगा।';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'इससे $name के साथ आपका कनेक्शन हट जाएगा।';
  }

  @override
  String get offlineUpdatesPaused => 'ऑफलाइन — अपडेट रुके हैं';

  @override
  String get exportStatementTitle => 'स्टेटमेंट एक्सपोर्ट करें';

  @override
  String get chooseExportDateRange =>
      'PDF में शामिल करने के लिए तारीख की सीमा चुनें।';

  @override
  String get last7DaysRange => 'पिछले 7 दिनों की एंट्री';

  @override
  String get last30DaysRange => 'पिछले 30 दिनों की एंट्री';

  @override
  String get last3MonthsRange => 'पिछले 3 महीनों की एंट्री';

  @override
  String get completeLedgerHistory => 'पूरा खाता इतिहास';

  @override
  String appAccessActive(String phone) {
    return 'सक्रिय · $phone';
  }

  @override
  String get appAccessDisabled => 'अक्षम';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name अब $phone से लॉगिन कर सकते हैं';
  }

  @override
  String appAccessRevoked(String name) {
    return '$name का ऐप एक्सेस रद्द किया';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'चालू होने पर, $name अपने नंबर ($phone) से लॉगिन करके डिलीवरी और भुगतान दर्ज कर सकते हैं और अपना QR दिखा सकते हैं — लेकिन उपस्थिति नहीं बदल सकते, ग्राहक नहीं जोड़ सकते, या बाकी स्टाफ को नहीं देख सकते।';
  }

  @override
  String get paymentHistoryTitle => 'भुगतान इतिहास';

  @override
  String get couldNotLoadPaymentHistory => 'भुगतान इतिहास लोड नहीं हो सका';

  @override
  String get voicePleaseCheck => 'कृपया जांचें';

  @override
  String get navHome => 'होम';

  @override
  String get qty => 'मात्रा';

  @override
  String totalRupees(String amount) {
    return 'कुल: ₹$amount';
  }

  @override
  String get selectCustomerFirst => 'पहले ग्राहक चुनें';

  @override
  String get enterValidAmount => 'सही राशि दर्ज करें';

  @override
  String get addsCredit => 'ग्राहक ने सामान लिया — खाते में जोड़ें';

  @override
  String get recordsCash => 'ग्राहक ने भुगतान किया — खाते से घटाएं';

  @override
  String deliveryRecordedFor(String name) {
    return '$name की डिलीवरी दर्ज हुई';
  }

  @override
  String paymentCollectedFrom(String name) {
    return '$name से भुगतान मिला';
  }

  @override
  String get manageSchedule => 'शेड्यूल प्रबंधित करें';

  @override
  String get bookingsTab => 'बुकिंग';

  @override
  String get bySlotTab => 'स्लॉट अनुसार';

  @override
  String get scheduleSaved => 'शेड्यूल सेव हुआ!';

  @override
  String get addSlot => 'स्लॉट जोड़ें';

  @override
  String noSlotsForDay(String day) {
    return '$day के लिए कोई स्लॉट नहीं';
  }

  @override
  String get tapAddSlotHint =>
      'अपनी उपलब्धता सेट करने के लिए \"स्लॉट जोड़ें\" दबाएं';

  @override
  String get slotAvailable => 'उपलब्ध';

  @override
  String get slotsFull => 'स्लॉट भरा';

  @override
  String get slotFullHint => 'इस स्लॉट को पूरा भरा मार्क करें';

  @override
  String get enableSlotFirst => 'पहले स्लॉट चालू करें';

  @override
  String get deleteSlotTitle => 'स्लॉट हटाएं';

  @override
  String deleteSlotConfirm(String time) {
    return '$time का स्लॉट हटाएं?';
  }

  @override
  String get endTimeAfterStart => 'समाप्ति समय शुरुआत के बाद होना चाहिए';

  @override
  String get slotOverlaps => 'यह स्लॉट किसी मौजूदा स्लॉट से टकराता है';

  @override
  String get addTimeSlot => 'समय स्लॉट जोड़ें';

  @override
  String get editTimeSlot => 'समय स्लॉट संपादित करें';

  @override
  String get selectTimeHint =>
      '12-घंटे फॉर्मेट में शुरुआत और समाप्ति समय चुनें';

  @override
  String get startLabel => 'शुरुआत';

  @override
  String get endLabel => 'समाप्ति';

  @override
  String get update => 'अपडेट करें';

  @override
  String get notifTabAll => 'सभी';

  @override
  String get notifTabBookings => 'बुकिंग';

  @override
  String get noBookingNotifications => 'कोई बुकिंग सूचना नहीं';

  @override
  String get noBookingNotificationsSubtitle =>
      'बुकिंग अनुरोध और अपडेट यहाँ दिखेंगे';

  @override
  String get bookingPillLabel => 'बुकिंग';

  @override
  String get slotDetailTitle => 'स्लॉट विवरण';

  @override
  String bookingsCount(int count) {
    return '$count बुकिंग';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$count बुकिंग';
  }

  @override
  String pendingCountLabel(int count) {
    return '$count लंबित';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'रखें';

  @override
  String get deleteButton => 'हटाएं';

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
  String get membershipPlansTitle => 'सदस्यता प्लान';

  @override
  String get newPlanButton => 'नया प्लान';

  @override
  String get deletePlanTitle => 'प्लान हटाएं?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" हटा दिया जाएगा। यह पूर्ववत नहीं होगा।';
  }

  @override
  String get inactiveLabel => 'निष्क्रिय';

  @override
  String get noBenefitsAdded => 'कोई लाभ नहीं जोड़ा गया।';

  @override
  String get noMembershipPlans => 'अभी कोई सदस्यता प्लान नहीं';

  @override
  String get tapNewPlanHint => 'पहला प्लान बनाने के लिए \"नया प्लान\" दबाएं।';

  @override
  String get membershipRequestsTitle => 'सदस्यता अनुरोध';

  @override
  String get noPendingRequests => 'कोई लंबित अनुरोध नहीं';

  @override
  String get customersCanApplyHint =>
      'ग्राहक अपनी खाता स्क्रीन से\nसदस्यता के लिए आवेदन कर सकते हैं।';

  @override
  String get membersTitle => 'सदस्य';

  @override
  String get noMembersYet => 'अभी कोई सदस्य नहीं';

  @override
  String get activeStat => 'सक्रिय';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'समाप्त होने वाले';

  @override
  String get allPlansFilter => 'सभी प्लान';

  @override
  String daysLeft(int count) {
    return '$countदिन बाकी';
  }

  @override
  String daysLeftFull(int count) {
    return '$count दिन';
  }

  @override
  String get planNameLabel => 'प्लान का नाम';

  @override
  String get planNameHint => 'जैसे: गोल्ड मेंबरशिप';

  @override
  String get durationDaysLabel => 'अवधि (दिन)';

  @override
  String get priceRupeesLabel => 'कीमत ₹';

  @override
  String get addBenefitButton => 'लाभ जोड़ें';

  @override
  String get customLabel => 'कस्टम';

  @override
  String get customAdvanceLabel => 'कस्टम अग्रिम ₹';

  @override
  String get benefitLabel => 'लाभ';

  @override
  String get benefitHint => 'जैसे: 4 बाल कटाई';

  @override
  String get planDetailsSection => 'प्लान विवरण';

  @override
  String get benefitsSection => 'लाभ';

  @override
  String get advanceRequiredSection => 'जरूरी अग्रिम';

  @override
  String get editPlanTitle => 'प्लान संपादित करें';

  @override
  String get createPlanTitle => 'सदस्यता प्लान बनाएं';

  @override
  String get publishPlanButton => 'प्लान प्रकाशित करें';

  @override
  String get planUpdatedToast => 'प्लान अपडेट हुआ';

  @override
  String get planPublishedToast => 'प्लान प्रकाशित हुआ';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · प्लान';
  }

  @override
  String get noPlansAvailable => 'अभी कोई प्लान उपलब्ध नहीं';

  @override
  String get vendorNoPlansHint =>
      'इस विक्रेता ने कोई सदस्यता प्लान नहीं बनाया।';

  @override
  String applyForPlan(String planName) {
    return '$planName के लिए आवेदन करें';
  }

  @override
  String get messageToVendorOptional => 'विक्रेता को संदेश (वैकल्पिक)';

  @override
  String get messageToVendorHint =>
      'जैसे: कृपया मुझे इस महीने के लिए दर्ज करें';

  @override
  String get sendRequestButton => 'अनुरोध भेजें';

  @override
  String get activeLabel => 'सक्रिय';

  @override
  String get noAdditionalBenefits => 'कोई अतिरिक्त लाभ नहीं';

  @override
  String get currentPlanLabel => 'मौजूदा प्लान';

  @override
  String get requestPendingLabel => 'अनुरोध लंबित';

  @override
  String get applyLabel => 'आवेदन करें';

  @override
  String requestSentToName(String name) {
    return '$name को अनुरोध भेजा';
  }

  @override
  String get membershipDialogTitle => 'सदस्यता';

  @override
  String pendingPlanPrefix(String planName) {
    return 'लंबित: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return '$name को दर्ज करें';
  }

  @override
  String get choosePlanHint => 'सदस्यता शुरू करने के लिए प्लान चुनें।';

  @override
  String get noActivePlansHint =>
      'कोई सक्रिय प्लान नहीं। पहले सदस्यता → प्लान में बनाएं।';

  @override
  String get enrollLabel => 'दर्ज करें';

  @override
  String get changeLabel => 'बदलें';

  @override
  String get usedLabel => 'इस्तेमाल हुआ';

  @override
  String get useLabel => 'इस्तेमाल करें';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count दिन बाकी';
  }

  @override
  String get orderPlacedSuccess => 'ऑर्डर सफलतापूर्वक दिया गया!';

  @override
  String orderFromVendor(String vendorName) {
    return '$vendorName से ऑर्डर';
  }

  @override
  String get addItemButton => 'आइटम जोड़ें';

  @override
  String get orderNoteOptional => 'ऑर्डर नोट (वैकल्पिक)';

  @override
  String get totalLabel => 'कुल';

  @override
  String get placeOrderButton => 'ऑर्डर दें';

  @override
  String get itemNameRequired => 'आइटम का नाम *';

  @override
  String get unitLabel => 'इकाई';

  @override
  String get unitHint => 'kg, L…';

  @override
  String get unitPriceLabel => 'इकाई ₹';

  @override
  String itemNumber(int number) {
    return 'आइटम $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'उप-कुल: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'ऑर्डर विवरण';

  @override
  String get proofPhotoLabel => 'प्रमाण फ़ोटो';

  @override
  String get tapToViewFullScreen => 'पूर्ण स्क्रीन में देखने के लिए टैप करें';

  @override
  String get rejectButton => 'अस्वीकार करें';

  @override
  String get confirmButton => 'पुष्टि करें';

  @override
  String get markAsDeliveredButton => 'डिलीवर हुआ मार्क करें';

  @override
  String get confirmDeliveryTitle => 'डिलीवरी की पुष्टि करें';

  @override
  String get deliveryNoteOptional => 'डिलीवरी नोट (वैकल्पिक)';

  @override
  String get retakeLabel => 'दोबारा लें';

  @override
  String photoUploadFailed(String error) {
    return 'फ़ोटो अपलोड विफल: $error';
  }

  @override
  String get orderNoteLabel => 'ऑर्डर नोट';

  @override
  String get customerLabel => 'ग्राहक';

  @override
  String get ordersTitle => 'ऑर्डर';

  @override
  String get noOrdersYet => 'अभी कोई ऑर्डर नहीं';

  @override
  String get markDeliveredButton => 'डिलीवर हुआ मार्क करें';

  @override
  String get myOrdersTitle => 'मेरे ऑर्डर';

  @override
  String get deliverButton => 'डिलीवर करें';

  @override
  String get noPendingDeliveries => 'कोई लंबित डिलीवरी नहीं';

  @override
  String get deliveriesTitle => 'डिलीवरी';

  @override
  String get monthlyStatementTitle => 'मासिक स्टेटमेंट';

  @override
  String get deliveryProofLabel => 'डिलीवरी प्रमाण';

  @override
  String get replacePhotoButton => 'फ़ोटो बदलें';

  @override
  String get attachProofButton => 'प्रमाण जोड़ें';

  @override
  String get uploadingLabel => 'अपलोड हो रहा है...';

  @override
  String get proofLockedHint => 'यह प्रमाण लॉक है और बदला नहीं जा सकता';

  @override
  String get proofAttachedToast => 'प्रमाण जोड़ा गया';

  @override
  String itemLabel(int number) {
    return 'आइटम $number';
  }

  @override
  String get amountRequired => 'राशि *';

  @override
  String get addItemLabel => 'आइटम जोड़ें';

  @override
  String get totalAmountLabel => 'कुल';

  @override
  String get deactivate => 'निष्क्रिय करें';

  @override
  String get activate => 'सक्रिय करें';

  @override
  String get activeStatLabel => 'सक्रिय';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'समाप्त होने वाले';

  @override
  String get closeLabel => 'बंद करें';

  @override
  String pendingPlanLabel(String name) {
    return 'लंबित: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer ने $plan मांगा';
  }

  @override
  String itemsCount(int count) {
    return 'आइटम ($count)';
  }

  @override
  String get deliveryLabel => 'डिलीवरी';

  @override
  String markedDeliveredBy(String role) {
    return '$role द्वारा डिलीवर हुआ मार्क किया';
  }

  @override
  String get deliveriesHint =>
      'ऑर्डर के जरिए डिलीवर हुए आइटम। एंट्री टैप करके आइटम देखें।';
}
