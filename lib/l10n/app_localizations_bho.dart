// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bhojpuri (`bho`).
class AppLocalizationsBho extends AppLocalizations {
  AppLocalizationsBho([String locale = 'bho']) : super(locale);

  @override
  String get appTitle => 'साथखाता';

  @override
  String get tagline => 'एगो खाता, दूनों के';

  @override
  String get onboarding1Title => 'दू तरफा साझा खाता';

  @override
  String get onboarding1Subtitle =>
      'विक्रेता आ ग्राहक दूनों खातिर एके खाता। दूनों एके सच देखेलें।';

  @override
  String get onboarding2Title => 'आवाज आ बिल OCR';

  @override
  String get onboarding2Subtitle =>
      '12 भाषा में तुरंत एंट्री बनावे खातिर बोलीं भा बिल स्कैन करीं।';

  @override
  String get onboarding3Title => 'एक टैप UPI भुगतान';

  @override
  String get onboarding3Subtitle => 'UPI से एक टैप में महीना के बाकी चुका दीं।';

  @override
  String get getStarted => 'शुरू करीं';

  @override
  String get next => 'अगिला';

  @override
  String get skip => 'छोड़ीं';

  @override
  String get chooseLanguage => 'आपन भाषा चुनीं';

  @override
  String get continueButton => 'जारी राखीं';

  @override
  String get chooseRole => 'आपन भूमिका चुनीं';

  @override
  String get vendor => 'विक्रेता';

  @override
  String get customer => 'ग्राहक';

  @override
  String get welcomeToSaathKhata => 'साथखाता में रउआ के स्वागत बा';

  @override
  String get tellUsHowYouUse => 'बताईं रउआ ऐप के इस्तेमाल कइसे करब';

  @override
  String get vendorRoleTitle => 'हम एगो विक्रेता बानी';

  @override
  String get vendorRoleSubtitle =>
      'बेपार के खाता, कर्मचारी संभालीं आ भुगतान लीं।';

  @override
  String get customerRoleTitle => 'हम एगो ग्राहक बानी';

  @override
  String get customerRoleSubtitle =>
      'विक्रेता लोग के साथे खाता देखीं आ UPI से भुगतान करीं।';

  @override
  String get loginTitle => 'साथखाता में लॉगिन करीं';

  @override
  String get enterMobile => 'आगे बढ़े खातिर जानकारी भरीं';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get sendOtp => 'OTP भेजीं';

  @override
  String get verifyOtp => 'OTP जाँचीं';

  @override
  String get verifyAndContinue => 'जाँचीं आ जारी राखीं';

  @override
  String get changePhoneNumber => 'फोन नंबर बदलीं';

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
  String get loginButton => 'लॉगिन करीं';

  @override
  String get noAccount => 'खाता नइखे?';

  @override
  String get signUp => 'साइन अप करीं';

  @override
  String get pleaseEnterCredentials => 'ईमेल और पासवर्ड दर्ज करें';

  @override
  String get fillRequiredFields => 'नाम, ईमेल और पासवर्ड भरें';

  @override
  String get passwordMinChars => 'कम से कम 8 अक्षर';

  @override
  String get completeProfile => 'प्रोफ़ाइल पूरा करीं';

  @override
  String get enterYourName => 'आपन नाम भरीं';

  @override
  String get egBusinessName => 'e.g. Krishna Dairy';

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
  String get myVendors => 'हमार विक्रेता';

  @override
  String get outstanding => 'बाकी';

  @override
  String get collectedToday => 'आज के वसूली';

  @override
  String get quickActions => 'झटपट काम';

  @override
  String get scanBill => 'बिल स्कैन करीं';

  @override
  String get remindAll => 'सभके याद दिआईं';

  @override
  String get addNew => 'नया जोड़ीं';

  @override
  String get recentCustomers => 'हाल के ग्राहक';

  @override
  String get viewAll => 'सभ देखीं';

  @override
  String customerAddedSnackbar(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String get sharedLedger => 'साझा खाता';

  @override
  String get totalBalance => 'कुल बाकी';

  @override
  String get statement => 'स्टेटमेंट';

  @override
  String get giveCredit => 'उधार दीं';

  @override
  String get recordPayment => 'भुगतान दर्ज करीं';

  @override
  String get giveCreditSheet => 'उधार दीं';

  @override
  String get recordPaymentSheet => 'भुगतान दर्ज करीं';

  @override
  String get filterAll => 'सभ';

  @override
  String get balanceCustomerOwes => 'ग्राहक पर बाकी बा';

  @override
  String get balanceYouOwe => 'रउआ पर बाकी बा';

  @override
  String get balanceSettled => 'चुकता';

  @override
  String get balanceYouOweVendor => 'रउआ व्यापारी के देवे के बा';

  @override
  String get balanceVendorOwesYou => 'व्यापारी रउआ के देवे के बा';

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
  String get addCreditEntry => 'उधार एंट्री जोड़ीं';

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
  String get submitDispute => 'विवाद दर्ज करीं';

  @override
  String get staffAndLabour => 'स्टाफ और लेबर';

  @override
  String get addStaff => 'स्टाफ जोड़ीं';

  @override
  String get presentToday => 'आज उपस्थित';

  @override
  String get unpaidSalary => 'अवैतनिक वेतन';

  @override
  String get paySalary => 'तनख्वाह दीं';

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
  String get seeAll => 'सभ देखीं';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appLanguage => 'ऐप भाषा';

  @override
  String get selectLanguage => 'भाषा चुनीं';

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
  String get markAllRead => 'सभके पढ़ल मार्क करीं';

  @override
  String get noNotificationsTitle => 'अभी तक कोई सूचना नहीं';

  @override
  String get noNotificationsSubtitle =>
      'यहाँ खाता अपडेट, भुगतान अलर्ट और रिमाइंडर दिखेंगे।';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल्ह';

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
  String get pending => 'बाकी';

  @override
  String get quickPay => 'झटपट भुगतान';

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
  String get done => 'हो गइल';

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
  String get addNewCustomer => 'नया ग्राहक जोड़ीं';

  @override
  String get customerName => 'ग्राहक के नाम';

  @override
  String get mobileNo => 'मोबाइल नंबर';

  @override
  String get addCustomer => 'ग्राहक जोड़ीं';

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
  String get cancel => 'रद्द करीं';

  @override
  String get confirm => 'पक्का करीं';

  @override
  String get tryAgain => 'फेर से कोसिस करीं';

  @override
  String get alignBillInFrame => 'बिल को फ्रेम में रखें';

  @override
  String get verifyAndLogin => 'सत्यापित करें और लॉगिन करें';

  @override
  String get voiceListening => 'सुनत बानी...';

  @override
  String get voiceThinking => 'सोचत बानी...';

  @override
  String get voiceDetectedEntry => 'पहचानी गई एंट्री';

  @override
  String get voiceConfirmEntry => 'एंट्री पक्का करीं';

  @override
  String get item => 'वस्तु';

  @override
  String get totalOutstandingBalance => 'कुल बकाया राशि';

  @override
  String get payAllDues => 'सभ बाकी चुका दीं';

  @override
  String get myKhatas => 'हमार खाता';

  @override
  String get noVendorsFound => 'कवनो विक्रेता ना मिलल';

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
  String get editProfile => 'प्रोफ़ाइल बदलीं';

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
  String get allCustomers => 'सभ ग्राहक';

  @override
  String get noCustomersYet => 'अबले कवनो ग्राहक ना';

  @override
  String get noCustomersYetSubtitle => 'शुरू करे खातिर आपन पहिला ग्राहक जोड़ीं';

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
  String get removeStaffTitle => 'Remove Staff Member';

  @override
  String removeStaffConfirm(String name) {
    return 'Remove $name from your staff? This will revoke their app access immediately.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name के बकाया में इस महीने ₹$amount जोड़ें?';
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
    return '\"$name\" के उत्पाद सूची से हटाईं?';
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
    return 'स्तर $level';
  }

  @override
  String get memberDiscount => 'Member discount';

  @override
  String discountFor(String tier) {
    return '$tier खातिर छूट';
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

  @override
  String get scheduledServicesTitle => 'Scheduled Services';

  @override
  String get servicesTab => 'Services';

  @override
  String get todaysDeliveriesTab => 'Today\'s Deliveries';

  @override
  String get newService => 'New Service';

  @override
  String get noServicesYet => 'No services yet';

  @override
  String get tapPlusToCreateService => 'Tap + to create a scheduled service';

  @override
  String subscriberCountLabel(int count) {
    return '$count subs';
  }

  @override
  String get noDeliveriesToday => 'No deliveries today';

  @override
  String get noDeliveriesMatchFilters => 'No deliveries match your filters';

  @override
  String get mySubscriptionsTitle => 'My Subscriptions';

  @override
  String get deliveriesTab => 'Deliveries';

  @override
  String get noActiveSubscriptions => 'No active subscriptions';

  @override
  String get noDeliveriesYet => 'No deliveries yet';

  @override
  String get serviceNameLabel => 'Service Name *';

  @override
  String get serviceTypeLabel => 'Service Type';

  @override
  String get scheduleLabel => 'Schedule';

  @override
  String get deliveryDaysLabel => 'Delivery Days';

  @override
  String get itemsLabel => 'Items';

  @override
  String get autoCreateLedgerEntry => 'Auto-create ledger entry';

  @override
  String get addToKhataAutomatically =>
      'Add to khata automatically on delivery';

  @override
  String get createServiceButton => 'Create Service';

  @override
  String get selectAtLeastOneDeliveryDay => 'Select at least one delivery day';

  @override
  String get fillNameUnitPriceEveryItem =>
      'Fill in name, unit and price for every item';

  @override
  String get itemNameLabel => 'Item name';

  @override
  String get priceRupeeLabel => 'Price (₹)';

  @override
  String get subscribersTitle => 'Subscribers';

  @override
  String get addCustomerButton => 'Add Customer';

  @override
  String get noSubscribersYet => 'No subscribers yet';

  @override
  String get deactivateServiceTitle => 'Deactivate Service';

  @override
  String get deactivateServiceMessage =>
      'This will stop all future deliveries. Active subscriptions will be unaffected until manually removed.';

  @override
  String get typeLabel => 'Type';

  @override
  String get autoLedgerEntryLabel => 'Auto Ledger Entry';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String subscriptionStartsOn(String summary, String date) {
    return '$summary · starts $date';
  }

  @override
  String amountPerDelivery(String amount) {
    return '₹$amount / delivery';
  }

  @override
  String get pausedLabel => 'Paused';

  @override
  String get resumeLabel => 'Resume';

  @override
  String get pauseLabel => 'Pause';

  @override
  String get deliveryDetailsTitle => 'Delivery Details';

  @override
  String deliveryDueAt(String time) {
    return 'Due at $time';
  }

  @override
  String deliveryDeliveredAt(String time) {
    return 'Delivered at $time';
  }

  @override
  String deliveryDeliveredBy(String name) {
    return 'Delivered by $name';
  }

  @override
  String get deliveryPhotoTitle => 'Delivery Photo';

  @override
  String get skipDeliveryTitle => 'Skip Delivery';

  @override
  String get skipDeliveryMessage => 'Mark this delivery as skipped today?';

  @override
  String get confirmDeliveryButton => 'Confirm Delivery';

  @override
  String get couldNotConfirmDelivery => 'Could not confirm delivery';

  @override
  String get dateTimeLabel => 'Date & time';

  @override
  String get amountToAddToLedger => 'Amount to add to ledger';

  @override
  String get deliveryAutoLedgerNote =>
      'This delivery will be added to the ledger automatically when confirmed — no need to add it again.';

  @override
  String get deliveryPhotoRequired => 'DELIVERY PHOTO (REQUIRED)';

  @override
  String get addSubscriberTitle => 'Add Subscriber';

  @override
  String get selectCustomerLabel => 'Select customer';

  @override
  String get selectACustomerHint => 'Select a customer';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get setQuantityForOneItem => 'Set a quantity for at least one item';

  @override
  String get customPriceQuestion => 'Custom price?';

  @override
  String get customPriceOptionalLabel => 'Custom Price (₹, optional)';

  @override
  String get allDeliveriesFilter => 'All deliveries';

  @override
  String get clearAllFilters => 'Clear all';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get couldNotGetCurrentLocation => 'Couldn\'t get current location';

  @override
  String get filterDeliveriesTitle => 'Filter Deliveries';

  @override
  String get filterCustomerServiceName => 'CUSTOMER / SERVICE NAME';

  @override
  String get filterSearchByName => 'Search by name';

  @override
  String get filterAnyDate => 'Any date';

  @override
  String get filterRadiusFromLocation => 'RADIUS FROM MY LOCATION';

  @override
  String get applyFilterButton => 'Apply Filter';

  @override
  String withinKmLabel(String km) {
    return 'Within $km km';
  }

  @override
  String kmLabel(String km) {
    return '$km km';
  }

  @override
  String get serviceTypeProduct => 'Product';

  @override
  String get serviceTypeSession => 'Session';

  @override
  String get scheduleTypeDaily => 'Daily';

  @override
  String get scheduleTypeWeekly => 'Weekly';

  @override
  String get scheduleTypeCustomDays => 'Custom Days';

  @override
  String get deliveryStatusScheduled => 'Scheduled';

  @override
  String get deliveryStatusDelivered => 'Delivered';

  @override
  String get deliveryStatusSkipped => 'Skipped';

  @override
  String get deliveryStatusFailed => 'Failed';

  @override
  String get scheduleTypeCustom => 'Custom';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusRejected => 'Rejected';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get weekdayShortSun => 'Sun';

  @override
  String get weekdayShortMon => 'Mon';

  @override
  String get weekdayShortTue => 'Tue';

  @override
  String get weekdayShortWed => 'Wed';

  @override
  String get weekdayShortThu => 'Thu';

  @override
  String get weekdayShortFri => 'Fri';

  @override
  String get weekdayShortSat => 'Sat';

  @override
  String subscriptionItemsAmount(String summary, String amount) {
    return '$summary · ₹$amount';
  }

  @override
  String subscriptionNextDelivery(String date) {
    return 'Next: $date';
  }

  @override
  String subscriptionDeliverySubtitle(String date, String summary) {
    return '$date · $summary';
  }

  @override
  String get statusLabel => 'Status';

  @override
  String get callLabel => 'Call';

  @override
  String get subscribeButton => 'Subscribe';

  @override
  String get invalidValueLabel => 'Invalid';

  @override
  String get resetLabel => 'Reset';

  @override
  String itemPriceWithUnit(String name, String unit, String price) {
    return '$name ($unit) · ₹$price';
  }

  @override
  String forCustomerName(String name) {
    return 'for $name';
  }

  @override
  String get deliveredByLabel => 'Delivered by';

  @override
  String get staffQuickDelivery => 'Quick Delivery';

  @override
  String get staffQuickDeliverySubtitle => 'Pre-filled with customer defaults';

  @override
  String get staffOrdersSubtitle => 'Confirmed orders awaiting delivery';

  @override
  String get noResults => 'No results';

  @override
  String get noDefaultSet => 'No default set';

  @override
  String get photoUploadFailedNoError => 'Photo upload failed';

  @override
  String get deliverAndCharge => 'Deliver & Charge';

  @override
  String staffPaySummary(String role, String salaryType, String amount) {
    return '$role · $salaryType ₹$amount';
  }

  @override
  String itemsCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String noteWithValue(String note) {
    return 'Note: $note';
  }

  @override
  String orderPlacedOn(String date) {
    return 'Placed $date';
  }

  @override
  String get couldNotAccessCamera =>
      'Could not access camera. Check app permissions.';

  @override
  String get couldNotAccessGallery =>
      'Could not access gallery. Check app permissions.';

  @override
  String amountAddedToCustomerDue(String amount) {
    return '₹$amount will be added to the customer\'s due.';
  }

  @override
  String moreItemsCount(int count) {
    return '+ $count more';
  }

  @override
  String orderTotalAmount(String amount) {
    return 'Total ₹$amount';
  }

  @override
  String get orderStatusLabelAll => 'All';

  @override
  String get minimumValueOne => 'Min 1';

  @override
  String planPricePerDuration(String price, int days) {
    return '₹$price / $days days';
  }

  @override
  String planDurationSuffix(int days) {
    return ' / $days days';
  }

  @override
  String planPriceAndDuration(String price, int days) {
    return '₹$price · $days days';
  }

  @override
  String benefitQuotaTimes(int quota) {
    return '×$quota';
  }

  @override
  String advanceAmountLabel(String amount) {
    return 'Advance: ₹$amount';
  }

  @override
  String advanceAmountSuffix(String amount) {
    return ' · advance ₹$amount';
  }

  @override
  String activeMembersCount(int count) {
    return '$count active';
  }

  @override
  String usedOfQuota(int used, int quota) {
    return '$used/$quota';
  }

  @override
  String daysLeftWithWarning(int count) {
    return '${count}d left ⚠';
  }

  @override
  String get aPlanLabel => 'a plan';

  @override
  String get planFallbackLabel => 'Plan';

  @override
  String planWithExpiry(String plan, String date) {
    return '$plan · $date';
  }

  @override
  String planPriceAndDaysLeft(String price, int days) {
    return '₹$price · $days days left';
  }

  @override
  String get ledgerPreferences => 'Ledger Preferences';

  @override
  String get autoConfirmEntries => 'Auto-Confirm Entries';

  @override
  String get doneLabel => 'Done';

  @override
  String get categoryShortDairy => 'Dairy';

  @override
  String get categoryShortPress => 'Press';

  @override
  String get categoryShortMaid => 'Maid';

  @override
  String get categoryShortNews => 'News';

  @override
  String get categoryShortWater => 'Water';

  @override
  String get categoryShortTiffin => 'Tiffin';

  @override
  String get categoryShortKirana => 'Kirana';

  @override
  String get categoryShortSalon => 'Salon';

  @override
  String get categoryShortLabour => 'Labour';

  @override
  String get categoryShortTransport => 'Transport';

  @override
  String get categoryShortGym => 'Gym';

  @override
  String categoryWithCount(String category, int count) {
    return '$category ($count)';
  }

  @override
  String pageIndexOfTotal(int index, int total) {
    return '$index of $total';
  }

  @override
  String get orderButtonLabel => 'Order';

  @override
  String get historyTab => 'History';

  @override
  String get duesTab => 'Dues';

  @override
  String get infoTab => 'Info';

  @override
  String get nameLabel => 'Name';

  @override
  String get yourNicknameLabel => 'Your nickname';

  @override
  String get linkedSinceLabel => 'Linked since';

  @override
  String get defaultDeliveryTitle => 'Default Delivery';

  @override
  String get editLabel => 'Edit';

  @override
  String get productLabel => 'Product';

  @override
  String get pricePerUnitShort => 'Price/unit';

  @override
  String get noDefaultDeliveryHint =>
      'No default set. Staff Quick Delivery will ask each time.';

  @override
  String get tierLabel => 'Tier';

  @override
  String get newOrderForCustomerTooltip => 'New order for customer';

  @override
  String get viewMonthlyStatement => 'View Monthly Statement';

  @override
  String get customerDeliveriesHint =>
      'Orders delivered to this customer. Tap an entry to see items.';

  @override
  String remindersSentTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reminders sent to $count customers',
      one: 'Reminder sent to 1 customer',
    );
    return '$_temp0';
  }

  @override
  String get remindersNoOutstanding => 'No customers with outstanding balance';

  @override
  String get remindersFailed => 'Failed to send reminders. Please try again.';

  @override
  String get ordersSubtitle => 'View and manage customer orders';

  @override
  String get defaultDeliverySaved => 'Default delivery saved';

  @override
  String defaultDeliveryPrefillHint(String name) {
    return 'Pre-fills staff Quick Delivery screen for $name';
  }

  @override
  String get fullCreamMilkExample => 'e.g. Full Cream Milk';

  @override
  String get defaultQtyLabel => 'Default qty';

  @override
  String get unitExampleHint => 'L, kg…';

  @override
  String get saveDefaultsButton => 'Save Defaults';

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String byName(String name) {
    return 'by $name';
  }

  @override
  String get latLabel => 'LAT';

  @override
  String get lngLabel => 'LNG';

  @override
  String get noLinkedVendorsYet => 'No linked vendors yet';

  @override
  String get autoConfirmingVendorEntries => 'Auto-confirming vendor entries';

  @override
  String get manualConfirmationRequired => 'Manual confirmation required';

  @override
  String get updatePreferenceFailed => 'Failed to update preference';

  @override
  String get membershipsLabel => 'Memberships';

  @override
  String get membershipPlansSubtitle => 'Create and manage your plans';

  @override
  String get membersSubtitle => 'Active members, MRR, expiring soon';

  @override
  String get autoConfirmSettingsSubtitle =>
      'Manage per-vendor auto-confirm settings';

  @override
  String pendingRequestsSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending requests',
      one: '1 pending request',
    );
    return '$_temp0';
  }

  @override
  String get totalBilledLabel => 'Total Billed';

  @override
  String get totalDuesLabel => 'Total Dues';

  @override
  String get netDueLabel => 'Net Due';

  @override
  String get noTransactionsThisMonth => 'No transactions this month';

  @override
  String get creditLabel => 'Credit';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get entryTypeAdjustmentLabel => 'Adjustment';

  @override
  String get liveUpdatesOn => 'Live — real-time updates on';

  @override
  String get proofLocked => 'Proof Locked';

  @override
  String get paymentProofTitle => 'Payment Proof';

  @override
  String get couldNotLoadImage => 'Could not load image';

  @override
  String get generatingStatement => 'Generating statement…';

  @override
  String get failedToGeneratePdf => 'Failed to generate PDF';

  @override
  String get pastDateLabel => 'Past date';

  @override
  String get deliveriesOnly => 'Deliveries only';

  @override
  String get filterEntriesTitle => 'Filter Entries';

  @override
  String get dateRangeLabel => 'DATE RANGE';

  @override
  String get amountRangeLabel => 'AMOUNT RANGE';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String filterStatusChip(String value) {
    return 'Status: $value';
  }

  @override
  String filterTypeChip(String value) {
    return 'Type: $value';
  }

  @override
  String fromDateLabel(String date) {
    return 'From $date';
  }

  @override
  String toDateLabel(String date) {
    return 'To $date';
  }

  @override
  String get loadMoreButton => 'Load more';

  @override
  String get perUnitLabel => 'per unit';

  @override
  String subtotalAmountLabel(String amount) {
    return 'Subtotal: ₹$amount';
  }

  @override
  String get amLabel => 'AM';

  @override
  String get pmLabel => 'PM';

  @override
  String get alreadyBookedLabel => 'Already Booked';

  @override
  String bookingDateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String confirmedCountLabel(int count) {
    return '$count confirmed';
  }

  @override
  String doneCountLabel(int count) {
    return '$count done';
  }

  @override
  String cancelledCountLabel(int count) {
    return '$count cancelled';
  }

  @override
  String bookingDateTimeShort(String date, String time) {
    return '$date  •  $time';
  }

  @override
  String bookingDateTimeWithService(String base, String service) {
    return '$base  •  $service';
  }

  @override
  String get deliveryAddressLabel => 'Delivery Address';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get upiIdOptionalLabel => 'UPI ID (optional)';

  @override
  String get passwordOptionalHint => 'Confirm Password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get customCategoryOptionalLabel => 'Custom category (optional)';

  @override
  String get ayurvedicMedicineExample => 'e.g. Ayurvedic Medicine';

  @override
  String get customCategoryHelper => 'Add your own if not listed above';

  @override
  String get signUpEmailSubtitle => 'Sign up with your email address';

  @override
  String passwordWithMinHint(String label) {
    return '$label (min 8 chars)';
  }

  @override
  String customCategoryCountLabel(int count) {
    return '$count/3';
  }

  @override
  String get upiIdExampleHint => 'e.g. name@upi';

  @override
  String get businessCategoryGymFitness => 'Gym / Fitness';

  @override
  String get bulkChargePickOneItem =>
      'This service has multiple items — pick one to charge';

  @override
  String pricePerUnitValue(String price, String unit) {
    return '₹$price / $unit';
  }

  @override
  String get navStaff => 'Staff';

  @override
  String get navBooking => 'Booking';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navReports => 'Reports';

  @override
  String get removeStaffTooltip => 'Remove staff';

  @override
  String get searchVendorsByCategoryHint =>
      'Search vendors by name or category…';

  @override
  String latLngValue(String lat, String lng) {
    return 'Lat $lat  ·  Lng $lng';
  }

  @override
  String get tapToPickOnMap => 'Tap to pick on map';

  @override
  String deliveredByRoleLabel(String role) {
    return 'Delivered by $role';
  }

  @override
  String get deliveredOnlyLabel => 'Delivered';
}
