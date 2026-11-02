// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'સાથખાતા';

  @override
  String get tagline => 'એક ખાતું, બંનેનું';

  @override
  String get onboarding1Title => 'બે-તરફી શેર ખાતું';

  @override
  String get onboarding1Subtitle =>
      'વિક્રેતા અને ગ્રાહક બંને માટે એક ખાતું. બંને એક જ સત્ય જુએ છે.';

  @override
  String get onboarding2Title => 'વૉઇસ અને બિલ OCR';

  @override
  String get onboarding2Subtitle =>
      '12 ભાષાઓમાં તરત જ એન્ટ્રી બનાવવા માટે બોલો અથવા બિલ સ્કૅન કરો.';

  @override
  String get onboarding3Title => 'એક ટૅપમાં UPI ચુકવણી';

  @override
  String get onboarding3Subtitle => 'UPI દ્વારા એક ટૅપમાં મહિનાની બાકી ચુકવો.';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get next => 'આગળ';

  @override
  String get skip => 'છોડો';

  @override
  String get chooseLanguage => 'તમારી ભાષા પસંદ કરો';

  @override
  String get continueButton => 'ચાલુ રાખો';

  @override
  String get chooseRole => 'તમારી ભૂમિકા પસંદ કરો';

  @override
  String get vendor => 'વિક્રેતા';

  @override
  String get customer => 'ગ્રાહક';

  @override
  String get welcomeToSaathKhata => 'સાથખાતામાં આપનું સ્વાગત છે';

  @override
  String get tellUsHowYouUse => 'અમને જણાવો તમે ઍપ કેવી રીતે વાપરશો';

  @override
  String get vendorRoleTitle => 'હું વિક્રેતા છું';

  @override
  String get vendorRoleSubtitle =>
      'વ્યવસાયનું ખાતું, કર્મચારીઓ સંચાલિત કરો અને ચુકવણી લો.';

  @override
  String get customerRoleTitle => 'હું ગ્રાહક છું';

  @override
  String get customerRoleSubtitle =>
      'વિક્રેતા સાથે ખાતું ટ્રૅક કરો અને UPI દ્વારા ચૂકવો.';

  @override
  String get loginTitle => 'સાથખાતામાં લૉગ ઇન કરો';

  @override
  String get enterMobile => 'ચાલુ રાખવા માટે તમારી માહિતી દાખલ કરો';

  @override
  String get mobileNumber => 'મોબાઇલ નંબર';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get verifyOtp => 'OTP ચકાસો';

  @override
  String get verifyAndContinue => 'ચકાસો અને ચાલુ રાખો';

  @override
  String get changePhoneNumber => 'ફોન નંબર બદલો';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumber પર મોકલેલ 6 અંકનો કોડ દાખલ કરો';
  }

  @override
  String get email => 'ઈ-મેઇલ';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get passwordHint => 'પાસવર્ડ દાખલ કરો';

  @override
  String get loginButton => 'લૉગ ઇન';

  @override
  String get noAccount => 'ખાતું નથી?';

  @override
  String get signUp => 'નોંધણી કરો';

  @override
  String get pleaseEnterCredentials => 'ઈ-મેઇલ અને પાસવર્ડ દાખલ કરો';

  @override
  String get fillRequiredFields => 'નામ, ઈ-મેઇલ અને પાસવર્ડ ભરો';

  @override
  String get passwordMinChars => 'ઓછામાં ઓછા 8 અક્ષરો';

  @override
  String get completeProfile => 'પ્રોફાઇલ પૂર્ણ કરો';

  @override
  String get enterYourName => 'તમારું નામ દાખલ કરો';

  @override
  String get egBusinessName => 'દા.ત. કૃષ્ણ ડેરી';

  @override
  String get selectCategory => 'શ્રેણી પસંદ કરો';

  @override
  String get enterAddress => 'વિસ્તાર અથવા સંપૂર્ણ સરનામું દાખલ કરો';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'પૂરું નામ';

  @override
  String get businessName => 'વ્યવસાયનું નામ';

  @override
  String get businessCategory => 'વ્યવસાય શ્રેણી';

  @override
  String get businessAddress => 'વ્યવસાયનું સરનામું (વૈકલ્પિક)';

  @override
  String get upiId => 'UPI ID (ચુકવણી માટે)';

  @override
  String get vendorDashboard => 'વિક્રેતા ડૅશબોર્ડ';

  @override
  String get customerDashboard => 'ગ્રાહક ડૅશબોર્ડ';

  @override
  String get customerMode => 'ગ્રાહક મોડ';

  @override
  String get myVendors => 'મારા વિક્રેતા';

  @override
  String get outstanding => 'બાકી';

  @override
  String get collectedToday => 'આજે ઉઘરાણું';

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get scanBill => 'બિલ સ્કૅન કરો';

  @override
  String get remindAll => 'બધાને યાદ કરાવો';

  @override
  String get addNew => 'નવું ઉમેરો';

  @override
  String get recentCustomers => 'તાજેતરના ગ્રાહકો';

  @override
  String get viewAll => 'બધું જુઓ';

  @override
  String customerAddedSnackbar(String name) {
    return '$name ઉમેરાયો';
  }

  @override
  String get sharedLedger => 'શેર ખાતું';

  @override
  String get totalBalance => 'કુલ બૅલૅન્સ';

  @override
  String get statement => 'નિવેદન';

  @override
  String get giveCredit => 'ઉધાર આપો';

  @override
  String get recordPayment => 'ચુકવણી નોંધો';

  @override
  String get giveCreditSheet => 'ઉધાર આપો';

  @override
  String get recordPaymentSheet => 'ચુકવણી નોંધો';

  @override
  String get filterAll => 'બધું';

  @override
  String get balanceCustomerOwes => 'ગ્રાહકની બાકી';

  @override
  String get balanceYouOwe => 'તમારી બાકી';

  @override
  String get balanceSettled => 'ચૂકતે';

  @override
  String get balanceYouOweVendor => 'તમારે વ્યાપારીને ચૂકવવાનું છે';

  @override
  String get balanceVendorOwesYou => 'વ્યાપારી તમને ચૂકવશે';

  @override
  String get ledgerInfoTitle => 'આ ખાતું કેવી રીતે કામ કરે છે';

  @override
  String get statusConfirmed => 'પુષ્ટિ થઈ';

  @override
  String get statusConfirmedDesc =>
      'બંને પક્ષ સહમત. એન્ટ્રી લૉક છે અને બદલી શકાય નહીં.';

  @override
  String get statusPending => 'બાકી';

  @override
  String get statusPendingDesc =>
      'ગ્રાહકની પુષ્ટિ માટે રાહ. 72 કલાકમાં આપોઆપ પુષ્ટિ.';

  @override
  String get statusDisputed => 'વિવાદિત';

  @override
  String get statusDisputedDesc =>
      'ગ્રાહકે વિવાદ ઉઠાવ્યો. વિક્રેતાની સમીક્ષા જરૂરી.';

  @override
  String get statusAutoConfirmed => 'આપોઆપ પુષ્ટિ';

  @override
  String get entryTypeCreditLabel => 'ઉધાર એન્ટ્રી';

  @override
  String get entryTypePaymentLabel => 'ચુકવણી મળી';

  @override
  String get entryDetails => 'એન્ટ્રી વિગત';

  @override
  String get entryAmount => 'રકમ';

  @override
  String get entryType => 'પ્રકાર';

  @override
  String get entryTypeCreditGiven => 'ઉધાર (આપ્યું)';

  @override
  String get entryTypePaymentReceived => 'ચુકવણી (મળ્યું)';

  @override
  String get entryDate => 'તારીખ';

  @override
  String get entryDescription => 'વર્ણન';

  @override
  String get entryQuantity => 'જથ્થો';

  @override
  String get entryConfirmedAt => 'પુષ્ટિ તારીખ';

  @override
  String get entryDisputeReason => 'વિવાદનું કારણ';

  @override
  String entryFor(String name) {
    return '$name માટે';
  }

  @override
  String get description => 'વર્ણન';

  @override
  String get descriptionOptional => 'વર્ણન (વૈકલ્પિક)';

  @override
  String get quantityOptional => 'જથ્થો (વૈકલ્પિક)';

  @override
  String get descriptionHint => 'દા.ત. 2L દૂધ, મહિના કરિયાણું';

  @override
  String get quantityHint => 'દા.ત. 2';

  @override
  String get addCreditEntry => 'ઉધાર એન્ટ્રી ઉમેરો';

  @override
  String get noLedgerTransactions => 'હજુ કોઈ વ્યવહાર નથી';

  @override
  String get noLedgerTransactionsSubtitle =>
      'શરૂ કરવા ઉધાર અથવા ચુકવણી એન્ટ્રી ઉમેરો.';

  @override
  String get confirmEntryTitle => 'એન્ટ્રી પુષ્ટિ કરો';

  @override
  String confirmEntryMessage(String amount) {
    return '₹$amount ની એન્ટ્રી પુષ્ટિ કરવી છે? આ પૂર્વવત્ ન થઈ શકે.';
  }

  @override
  String get dispute => 'વિવાદ';

  @override
  String get raiseDisputeTitle => 'વિવાદ ઉઠાવો';

  @override
  String get raiseDisputeSubtitle => 'આ એન્ટ્રીમાં શું ખોટું છે તે સમજાવો.';

  @override
  String get raiseDisputeHint => 'દા.ત. રકમ ₹50 હોવી જોઈએ, ₹60 નહીં';

  @override
  String get submitDispute => 'વિવાદ સબમિટ કરો';

  @override
  String get staffAndLabour => 'કર્મચારી અને મજૂર';

  @override
  String get addStaff => 'કર્મચારી ઉમેરો';

  @override
  String get presentToday => 'આજે હાજર';

  @override
  String get unpaidSalary => 'ન ચૂકવેલ પગાર';

  @override
  String get paySalary => 'પગાર આપો';

  @override
  String get noStaffAdded => 'હજુ કોઈ કર્મચારી નથી';

  @override
  String get noStaffAddedSubtitle => 'પ્રથમ કર્મચારી ઉમેરવા નીચેનું બટન દબાવો.';

  @override
  String get present => 'હાજર';

  @override
  String get absent => 'ગેરહાજર';

  @override
  String get halfDay => 'અડધો દિવસ';

  @override
  String get paySalaryTitle => 'પગાર આપો';

  @override
  String unpaidLabel(String amount) {
    return 'ન ચૂકવેલ: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI વ્યવહાર ID (વૈકલ્પિક)';

  @override
  String get noDues => 'કોઈ બાકી નથી';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount આપો';
  }

  @override
  String staffJoined(String date) {
    return '$date ના રોજ જોડાયા';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/દિવસ';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/મહિનો';
  }

  @override
  String get staffPayButton => 'ચુકવણી';

  @override
  String get businessReports => 'વ્યવસાય અહેવાલ';

  @override
  String get revenueTrend => 'આવક વલણ';

  @override
  String get collectionSummary => 'ઉઘરાણું સારાંશ';

  @override
  String get totalOutstanding => 'કુલ બાકી';

  @override
  String get totalCollected => 'કુલ ઉઘરાણું';

  @override
  String get topCustomers => 'ટોચના ગ્રાહકો';

  @override
  String get seeAll => 'બધું જુઓ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get appLanguage => 'ઍપ ભાષા';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String get settingsManagePayments => 'ચુકવણી ખાતા સંચાલિત કરો';

  @override
  String get settingsManageAlerts => 'ચેતવણી અને રિમાઇન્ડર સંચાલિત કરો';

  @override
  String get settingsAppPinFingerprint => 'ઍપ પિન અને ફિંગરપ્રિન્ટ';

  @override
  String get settingsFaqsContact => 'સહાય અને સંપર્ક';

  @override
  String settingsVersion(String version) {
    return 'આવૃત્તિ $version';
  }

  @override
  String get myUpiIds => 'મારા UPI ID';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get security => 'સુરક્ષા';

  @override
  String get helpSupport => 'સહાય';

  @override
  String get logout => 'લૉગ આઉટ';

  @override
  String get markAllRead => 'બધું વાંચ્યું ગણો';

  @override
  String get noNotificationsTitle => 'હજુ કોઈ સૂચનાઓ નથી';

  @override
  String get noNotificationsSubtitle =>
      'અહીં ખાતા અપડેટ, ચુકવણી ચેતવણી અને રિમાઇન્ડર દેખાશે.';

  @override
  String get today => 'આજે';

  @override
  String get yesterday => 'ગઈ કાલે';

  @override
  String minutesAgo(int count) {
    return '$count મિનિટ પહેલાં';
  }

  @override
  String hoursAgo(int count) {
    return '$count કલાક પહેલાં';
  }

  @override
  String get payments => 'ચુકવણી';

  @override
  String get transactionHistory => 'વ્યવહાર ઇતિહાસ';

  @override
  String get totalPaid => 'કુલ ચૂકવ્યું';

  @override
  String get pending => 'બાકી';

  @override
  String get quickPay => 'ઝડપી ચુકવણી';

  @override
  String get scanAndPay => 'સ્કૅન કરો અને ચૂકવો';

  @override
  String get scanUpiDesc => 'વિક્રેતાને ચૂકવવા UPI QR સ્કૅન કરો';

  @override
  String get noTransactionsTitle => 'હજુ કોઈ વ્યવહાર નથી';

  @override
  String get noTransactionsSubtitle => 'તમારો ચુકવણી ઇતિહાસ અહીં દેખાશે.';

  @override
  String get paymentStatusPaid => 'ચૂક્વ્યું';

  @override
  String get paymentStatusFailed => 'નિષ્ફળ';

  @override
  String get paymentStatusRefunded => 'પાછું';

  @override
  String get appointments => 'મુલાકાત';

  @override
  String get myAppointments => 'મારી મુલાકાત';

  @override
  String get upcoming => 'આગામી';

  @override
  String get past => 'ભૂતકાળ';

  @override
  String get cancelBooking => 'બુકિંગ રદ કરો';

  @override
  String get keepBooking => 'રાખો';

  @override
  String get noBookingsToday => 'આજે કોઈ બુકિંગ નથી';

  @override
  String get noBookingsTodaySubtitle =>
      'ગ્રાહકો ઍપ દ્વારા મુલાકાત બુક કરી શકે છે.';

  @override
  String get noAppointmentsTitle => 'હજુ કોઈ મુલાકાત નથી';

  @override
  String get noAppointmentsSubtitle =>
      'શરૂ કરવા તમારા વિક્રેતા સાથે મુલાકાત બુક કરો.';

  @override
  String get cancelAppointmentTitle => 'મુલાકાત રદ કરવી?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date ના $time ની મુલાકાત રદ કરવી?';
  }

  @override
  String get bookingStatusConfirmed => 'પુષ્ટિ થઈ';

  @override
  String get bookingStatusPending => 'બાકી';

  @override
  String get bookingStatusCancelled => 'રદ';

  @override
  String get bookingStatusCompleted => 'પૂર્ણ';

  @override
  String get bookingStatusDone => 'પૂર્ણ';

  @override
  String get upiPayment => 'UPI ચુકવણી';

  @override
  String get amountToPay => 'ચૂકવવાની રકમ';

  @override
  String get securedByUpi => 'UPI દ્વારા સુરક્ષિત';

  @override
  String get paymentSuccessful => 'ચુકવણી સફળ!';

  @override
  String get paymentFailed => 'ચુકવણી નિષ્ફળ';

  @override
  String get retryPayment => 'ફરી પ્રયાસ કરો';

  @override
  String get enterUpiId => 'UPI ID દાખલ કરો';

  @override
  String get addNoteOptional => 'નોંધ ઉમેરો (વૈકલ્પિક)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount ચૂકવો';
  }

  @override
  String get done => 'થઈ ગયું';

  @override
  String get paymentSomethingWentWrong => 'કંઈક ખોટું થયું. ફરી પ્રયાસ કરો.';

  @override
  String upiAppComingSoon(String app) {
    return '$app ટૂંક સમયમાં આવે છે';
  }

  @override
  String get pleaseEnterUpiId => 'UPI ID દાખલ કરો';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $name ને ચૂક્વ્યું';
  }

  @override
  String get orDivider => 'અથવા';

  @override
  String get addNewCustomer => 'નવો ગ્રાહક ઉમેરો';

  @override
  String get customerName => 'ગ્રાહકનું નામ';

  @override
  String get mobileNo => 'મોબાઇલ નંબર';

  @override
  String get addCustomer => 'ગ્રાહક ઉમેરો';

  @override
  String get paymentConfirmed => 'ચુકવણી પુષ્ટિ કરો';

  @override
  String get addAdvance => 'આગોતરું ઉમેરો';

  @override
  String get addAdvanceTitle => 'આગોતરું ઉમેરો';

  @override
  String get attendanceTitle => 'હાજરી';

  @override
  String get salaryTitle => 'પગાર સારાંશ';

  @override
  String get rate => 'દર';

  @override
  String get daysPresent => 'હાજરીના દિવસો';

  @override
  String get earned => 'કમાયું';

  @override
  String get unpaid => 'ન ચૂકવેલ';

  @override
  String get advanceTaken => 'લીધેલ આગોતરું';

  @override
  String get active => 'સક્રિય';

  @override
  String get inactive => 'નિષ્ક્રિય';

  @override
  String get joined => 'જોડાયા';

  @override
  String get noPhone => 'ફોન નથી';

  @override
  String get addNewStaff => 'નવો કર્મચારી ઉમેરો';

  @override
  String get fullNameLabel => 'પૂરું નામ';

  @override
  String get phoneNumber => 'ફોન નંબર';

  @override
  String get role => 'ભૂમિકા';

  @override
  String get salaryType => 'પગારનો પ્રકાર';

  @override
  String get dailyWage => 'દૈનિક મજૂરી';

  @override
  String get monthlySalary => 'માસિક પગાર';

  @override
  String get dailyWageAmount => 'દૈનિક મજૂરી (₹)';

  @override
  String get monthlySalaryAmount => 'માસિક પગાર (₹)';

  @override
  String get addStaffButton => 'કર્મચારી ઉમેરો';

  @override
  String get noteOptional => 'નોંધ (વૈકલ્પિક)';

  @override
  String get amountRupees => 'રકમ (₹)';

  @override
  String get cancel => 'રદ';

  @override
  String get confirm => 'પુષ્ટિ';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get alignBillInFrame => 'બિલ ફ્રેમમાં ગોઠવો';

  @override
  String get verifyAndLogin => 'ચકાસો અને લૉગ ઇન કરો';

  @override
  String get voiceListening => 'સાંભળી રહ્યો છું...';

  @override
  String get voiceThinking => 'વિચારી રહ્યો છું...';

  @override
  String get voiceDetectedEntry => 'શોધેલ એન્ટ્રી';

  @override
  String get voiceConfirmEntry => 'એન્ટ્રી પુષ્ટિ કરો';

  @override
  String get item => 'વસ્તુ';

  @override
  String get totalOutstandingBalance => 'કુલ બાકી રકમ';

  @override
  String get payAllDues => 'બધી બાકી ચૂકવો';

  @override
  String get myKhatas => 'મારા ખાતા';

  @override
  String get noVendorsFound => 'કોઈ વિક્રેતા મળ્યા નહીં';

  @override
  String get verifyBillDetails => 'બિલ વિગત ચકાસો';

  @override
  String get scannedBillPreview => 'સ્કૅન કરેલ બિલ';

  @override
  String get descriptionItemDetails => 'વર્ણન / વસ્તુ વિગત';

  @override
  String get selectCustomer => 'ગ્રાહક પસંદ કરો';

  @override
  String get searchCustomerHint => 'ગ્રાહક શોધો અથવા પસંદ કરો';

  @override
  String get saveToKhata => 'ખાતામાં સૅવ કરો';

  @override
  String get allCustomersReport => 'બધા ગ્રાહકોનો અહેવાલ';

  @override
  String collectedInMonth(String month) {
    return '$monthમાં ઉઘરાણું';
  }

  @override
  String get notificationSettings => 'સૂચના સેટિંગ્સ';

  @override
  String get securityPin => 'સુરક્ષા અને પિન';

  @override
  String get editProfile => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get changePassword => 'પાસવર્ડ બદલો';

  @override
  String get termsAndConditions => 'નિયમો અને શરતો';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get accountSettings => 'ખાતા સેટિંગ્સ';

  @override
  String get legalInfo => 'કાનૂની';

  @override
  String get currentPassword => 'વર્તમાન પાસવર્ડ';

  @override
  String get newPassword => 'નવો પાસવર્ડ';

  @override
  String get confirmNewPassword => 'નવો પાસવર્ડ પુષ્ટિ કરો';

  @override
  String get passwordsDoNotMatch => 'પાસવર્ડ મળતા નથી';

  @override
  String get changePasswordButton => 'પાસવર્ડ બદલો';

  @override
  String get passwordChangedSuccess => 'પાસવર્ડ સફળતાપૂર્વક બદલાયો';

  @override
  String get loadingContent => 'લોડ થઈ રહ્યું છે...';

  @override
  String get failedToLoad => 'સામગ્રી લોડ કરવામાં નિષ્ફળ. ફરી પ્રયાસ કરો.';

  @override
  String get bookingActions => 'બુકિંગ ક્રિયાઓ';

  @override
  String get confirmBooking => 'બુકિંગ પુષ્ટિ કરો';

  @override
  String get markComplete => 'પૂર્ણ ગણો';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer ની $date ના $time ની મુલાકાત પુષ્ટિ કરવી?';
  }

  @override
  String get bookingUpdated => 'બુકિંગ સફળતાપૂર્વક અપડેટ થઈ';

  @override
  String get bookingUpdateFailed => 'બુકિંગ અપડેટ કરવામાં નિષ્ફળ';

  @override
  String markAttendanceFor(String date) {
    return 'હાજરી નોંધો — $date';
  }

  @override
  String get allCustomers => 'બધા ગ્રાહકો';

  @override
  String get noCustomersYet => 'હજુ કોઈ ગ્રાહક નથી';

  @override
  String get noCustomersYetSubtitle => 'શરૂ કરવા પ્રથમ ગ્રાહક ઉમેરો';

  @override
  String get invalidPhone =>
      '6–9 થી શરૂ થતો 10 અંકનો માન્ય મોબાઇલ નંબર દાખલ કરો';

  @override
  String accrueMonthSalary(String amount) {
    return 'મહિનો પગાર ઉમેરો (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'મહિનો પગાર ઉમેરો';

  @override
  String get removeStaffTitle => 'કર્મચારી દૂર કરો';

  @override
  String removeStaffConfirm(String name) {
    return '$name ને તમારા સ્ટાફમાંથી હટાવવા? આ ઍપ ઍક્સેસ તરત જ રદ કરી દેશે.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name ની બાકીમાં આ મહિને ₹$amount ઉમેરવું?';
  }

  @override
  String get accountInformation => 'ખાતા માહિતી';

  @override
  String get updateProfileDetails => 'તમારું નામ, ફોટો અને વિગત અપડેટ કરો';

  @override
  String get updateAccountPassword => 'તમારો ખાતા પાસવર્ડ અપડેટ કરો';

  @override
  String get deleteAccount => 'ખાતું ભૂંસો';

  @override
  String get deleteAccountSubtitle => 'ખાતું અને બધો ડેટા કાયમ માટે ભૂંસો';

  @override
  String get deleteAccountConfirmation => 'ખાતું ભૂંસવું?';

  @override
  String get deleteAccountConfirmationMessage =>
      'આ તમારું ખાતું અને બધો ડેટા કાયમ માટે ભૂંસી નાખશે. આ ક્રિયા ઉલટાવી શકાશે નહીં.';

  @override
  String get deleteAccountStaffWarning =>
      'આ તમારું ખાતું કાયમ માટે ભૂંસી નાખશે. આ ઉલટાવી શકાશે નહીં.';

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
  String get deleteForever => 'કાયમ માટે ભૂંસો';

  @override
  String get delete => 'ભૂંસો';

  @override
  String get readTermsOfService => 'અમારી સેવા શરતો વાંચો';

  @override
  String get privacyPolicyDescription => 'અમે તમારો ડેટા કેવી રીતે સંભાળીએ છીએ';

  @override
  String get confirmLogout => 'શું તમે ખરેખર લૉગ આઉટ કરવા માંગો છો?';

  @override
  String get membershipTiers => 'સભ્યપદ સ્તર';

  @override
  String get membershipTiersDescription =>
      'સ્તરોનું નામ બદલો અને સભ્ય ડિસ્કાઉન્ટ સેટ કરો';

  @override
  String get logIn => 'લૉગ ઇન';

  @override
  String get enterPhoneNumberToContinue => 'ચાલુ રાખવા ફોન નંબર દાખલ કરો';

  @override
  String get havingTrouble => 'મુશ્કેલી છે?';

  @override
  String get useEmailInstead => 'ઈ-મેઇલ દ્વારા લૉગ ઇન →';

  @override
  String get logInWithEmail => 'ઈ-મેઇલ દ્વારા લૉગ ઇન';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get enterYourPassword => 'પાસવર્ડ દાખલ કરો';

  @override
  String get takePhoto => 'ફોટો લો';

  @override
  String get chooseFromGallery => 'ગેલેરીમાંથી પસંદ કરો';

  @override
  String get removePhoto => 'ફોટો દૂર કરો';

  @override
  String get tapToAddProfilePhoto => 'પ્રોફાઇલ ફોટો ઉમેરવા ટૅપ કરો';

  @override
  String get camera => 'કૅમેરા';

  @override
  String get gallery => 'ગેલેરી';

  @override
  String get add => 'ઉમેરો';

  @override
  String get addUpiId => 'UPI ID ઉમેરો';

  @override
  String get save => 'સૅવ કરો';

  @override
  String get close => 'બંધ કરો';

  @override
  String get ok => 'ઠીક છે';

  @override
  String get remove => 'દૂર કરો';

  @override
  String get approve => 'મંજૂર કરો';

  @override
  String get decline => 'નકારો';

  @override
  String get none => 'કોઈ નહીં';

  @override
  String get percent => 'ટકા';

  @override
  String get profile => 'પ્રોફાઇલ';

  @override
  String get paymentVerification => 'ચુકવણી ચકાસણી';

  @override
  String get verifyingPayment => 'ચુકવણી ચકાસાઈ રહી છે';

  @override
  String get paymentConfirmedExclamation => 'ચુકવણી પુષ્ટિ!';

  @override
  String get verificationTimedOut => 'ચકાસણીનો સમય સમાપ્ત';

  @override
  String get goBack => 'પાછળ જાઓ';

  @override
  String get payDues => 'બાકી ચૂકવો';

  @override
  String get skipForNow => 'હમણા છોડો';

  @override
  String get allDone => 'બધું થઈ ગયું!';

  @override
  String get noUpcomingAppointments => 'કોઈ આગામી મુલાકાત નથી';

  @override
  String get myPay => 'મારો પગાર';

  @override
  String get myPaymentQr => 'મારો ચુકવણી QR';

  @override
  String get showMyQr => 'મારો QR બતાવો';

  @override
  String get noPaymentsYet => 'હજુ કોઈ ચુકવણી નથી';

  @override
  String get paymentHistory => 'ચુકવણી ઇતિહાસ';

  @override
  String get paymentHistory6Months => 'ચુકવણી ઇતિહાસ (6 મહિના)';

  @override
  String get connectionRequest => 'કનેક્શન વિનંતી';

  @override
  String get vendorWantsToConnect => 'એક વિક્રેતા જોડવા ઇચ્છે છે';

  @override
  String get acceptRequest => 'સ્વીકારો';

  @override
  String get declineRequest => 'નકારો';

  @override
  String get messageLabel => 'સંદેશ';

  @override
  String get sendRequest => 'વિનંતી મોકલો';

  @override
  String get requestSentNotification =>
      'વિનંતી મોકલી! તેમને પુષ્ટિ માટે જાણ કરાશે.';

  @override
  String get awaitingAcceptance => 'સ્વીકૃતિ રાહ';

  @override
  String get addAVendor => 'વિક્રેતા ઉમેરો';

  @override
  String get findByPhoneOrEmail => 'ફોન નંબર અથવા ઈ-મેઇલ દ્વારા શોધો';

  @override
  String get phoneOrEmail => 'ફોન અથવા ઈ-મેઇલ';

  @override
  String get phoneOrEmailHint => '10 અંક મોબાઇલ અથવા ઈ-મેઇલ સરનામું';

  @override
  String get nicknameOptional => 'ઉપનામ (વૈકલ્પિક)';

  @override
  String get howYouKnowVendor => 'તમે આ વિક્રેતાને કેવી રીતે ઓળખો છો';

  @override
  String get bookingNoteExample => 'દા.ત. આજે વધારાનું દૂધ જોઈએ';

  @override
  String get confirmLocation => 'સ્થાન પુષ્ટિ કરો';

  @override
  String get moveMapToSelectLocation => 'સ્થાન પસંદ કરવા નકશો ખસેડો';

  @override
  String get searchPlaceHint => 'કોઈ સ્થળ શોધો…';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get searchVendorsHint => 'વિક્રેતા શોધો…';

  @override
  String get somethingWentWrong => 'કંઈક ખોટું ગયું';

  @override
  String get payViaUpi => 'UPI થી ચૂકવો';

  @override
  String get connectWithVendor => 'જોડો';

  @override
  String get requestConnection => 'કનેક્શન વિનંતી';

  @override
  String get addVendor => 'વિક્રેતા ઉમેરો';

  @override
  String get noOutstandingBalances => 'કોઈ બાકી રકમ નથી';

  @override
  String get allCustomersSettledUp => 'બધા ગ્રાહકોનો હિસાબ ચૂકતો છે.';

  @override
  String get nothingCollectedToday => 'આજે કંઈ ઉઘરાયું નથી';

  @override
  String get paymentsWillAppearHere => 'આજે મળેલ ચુકવણી અહીં દેખાશે.';

  @override
  String get customerReport => 'ગ્રાહક અહેવાલ';

  @override
  String get overview => 'ઝલક';

  @override
  String get tapToStop => 'થોભવા ટૅપ કરો';

  @override
  String get itemName => 'વસ્તુનું નામ';

  @override
  String get itemNameExample => 'દા.ત. દૂધ';

  @override
  String get unitPrice => 'પ્રતિ એકમ ભાવ ₹';

  @override
  String get deliverTo => 'ડિલિવરી કરો';

  @override
  String get bulkCharge => 'બલ્ક ચાર્જ';

  @override
  String get newProduct => 'નવી વસ્તુ';

  @override
  String get editProduct => 'વસ્તુ સંપાદિત કરો';

  @override
  String get newProductService => 'નવી વસ્તુ / સેવા';

  @override
  String get updateProductDetails => 'નામ, એકમ અથવા ભાવ અપડેટ કરો';

  @override
  String get defineProduct => 'તમે શું વેચો છો અને તેનો ભાવ નક્કી કરો';

  @override
  String get productName => 'વસ્તુનું નામ';

  @override
  String get productNameExample => 'દા.ત. સવારનું દૂધ';

  @override
  String get unit => 'એકમ';

  @override
  String get unitExample => 'લીટર / કિલો / ટુકડો';

  @override
  String get pricePerUnit => 'પ્રતિ એકમ ભાવ (₹)';

  @override
  String get deleteProduct => 'વસ્તુ ભૂંસો';

  @override
  String get deleteProductConfirmation => 'વસ્તુ ભૂંસવી?';

  @override
  String removeProductConfirmation(String name) {
    return 'Remove \"$name\" from your product list?';
  }

  @override
  String get noProductsYet => 'હજુ કોઈ વસ્તુ નથી';

  @override
  String get addFirstProduct => 'પ્રથમ વસ્તુ ઉમેરો';

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
  String get renameTier => 'સ્તરનું નામ બદલો';

  @override
  String get tierName => 'સ્તરનું નામ';

  @override
  String tierLevel(int level) {
    return 'Level $level';
  }

  @override
  String get memberDiscount => 'સભ્ય ડિસ્કાઉન્ટ';

  @override
  String discountFor(String tier) {
    return 'Discount for $tier';
  }

  @override
  String get flatAmount => 'ફ્લૅટ ₹';

  @override
  String get discountPercent => 'ડિસ્કાઉન્ટ %';

  @override
  String get discountAmount => 'ડિસ્કાઉન્ટ રકમ (₹)';

  @override
  String get percentExample => 'દા.ત. 5';

  @override
  String get amountExample => 'દા.ત. 50';

  @override
  String get maxDiscountPerDue => 'પ્રતિ બાકી મહત્તમ ડિસ્કાઉન્ટ (₹) — વૈકલ્પિક';

  @override
  String get maxDiscountExample => 'દા.ત. 100 (મર્યાદા ન હોય તો ખાલી છોડો)';

  @override
  String get saveDiscount => 'ડિસ્કાઉન્ટ સૅવ કરો';

  @override
  String get membership => 'સભ્યપદ';

  @override
  String get setTier => 'સેટ કરો';

  @override
  String get changeTier => 'બદલો';

  @override
  String get applyMembership => 'લાગુ કરો';

  @override
  String get removeMembership => 'સભ્યપદ દૂર કરો';

  @override
  String get removeLedgerConfirmation => 'ખાતું દૂર કરવું?';

  @override
  String get exportStatement => 'સ્ટેટમેન્ટ નિકાસ કરો';

  @override
  String get appAccess => 'ઍપ ઍક્સેસ';

  @override
  String get invalidPhoneNumber => 'માન્ય 10 અંકનો ભારતીય મોબાઇલ નંબર દાખલ કરો';

  @override
  String get enterAll6Digits => 'બધા 6 અંક દાખલ કરો';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress => 'માન્ય ઈ-મેઇલ સરનામું દાખલ કરો';

  @override
  String get passwordRequired => 'કૃપા કરી તમારો પાસવર્ડ દાખલ કરો';

  @override
  String get nameRequired => 'નામ જરૂરી છે';

  @override
  String get required => 'જરૂરી';

  @override
  String get invalidUpiFormat => 'અમાન્ય UPI ID ફોર્મેટ (દા.ત. name@upi)';

  @override
  String get upiIdAlreadyAdded => 'આ UPI ID પહેલેથી ઉમેરાયો છે';

  @override
  String get verifyButton => 'ચકાસો';

  @override
  String get createAccountButton => 'ખાતું બનાવો';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'પાસવર્ડ દાખલ કરો';

  @override
  String get mobileNumberLabel => 'મોબાઇલ નંબર';

  @override
  String get personalInfo => 'વ્યક્તિગત માહિતી';

  @override
  String get businessInfo => 'વ્યવસાયની માહિતી';

  @override
  String get enterOtpTitle => 'OTP દાખલ કરો';

  @override
  String get sentToLabel => 'મોકલ્યો';

  @override
  String get noOtpReceived => 'OTP ન મળ્યો?';

  @override
  String get resendOtp => 'OTP ફરી મોકલો';

  @override
  String get uploadingPhotoLabel => 'ફોટો અપલોડ થઈ રહ્યો છે...';

  @override
  String get phoneNumberLabel => 'ફોન નંબર';

  @override
  String get iAmA => 'હું છું';

  @override
  String get dualRoleExplanation =>
      'તમે મુખ્યત્વે વિક્રેતા ઍક્સ્પીરિયન્સ વાપરશો. તમારો ગ્રાહક ખાતો અલગ ઍક્સેસ કરી શકાય છે.';

  @override
  String get profileSavedPhotoFailed =>
      'પ્રોફાઇલ સૅવ થઈ — ફોટો હમણા અપલોડ ન થઈ શક્યો';

  @override
  String get profileUpdatedSuccess => 'પ્રોફાઇલ સફળતાપૂર્વક અપડેટ થઈ';

  @override
  String get addUpiIdTitle => 'UPI ID ઉમેરો';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'રદ';

  @override
  String get primaryUpiInfo => 'પ્રાઇમરી UPI ID';

  @override
  String get primaryUpiDescription =>
      'પ્રાઇમરી ID ગ્રાહકો સાથે ચૂકવણી માટે શેર થાય છે. કયો પ્રાઇમરી છે તે બદલવા સ્ટાર ટૅપ કરો.';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI IDs';
  }

  @override
  String get primaryUpiIdTooltip => 'પ્રાઇમરી UPI ID';

  @override
  String get setAsPrimaryTooltip => 'પ્રાઇમરી તરીકે સેટ કરો';

  @override
  String get primaryLabel => 'પ્રાઇમરી';

  @override
  String get removeButtonLabel => 'દૂર કરો';

  @override
  String get noUpiIdsEmpty => 'હજુ કોઈ UPI ID નથી';

  @override
  String get upiEmptyDescription =>
      '5 UPI IDs સુધી ઉમેરો. તમારો પ્રાઇમરી ID ચૂકવણી માટે ગ્રાહકો સાથે શેર થશે.';

  @override
  String get changePasswordSubtitle =>
      'તમારો વર્તમાન પાસવર્ડ દાખલ કરો અને નવો પસંદ કરો.';

  @override
  String get alreadyHaveAccount => 'પહેલેથી ખાતું છે?';

  @override
  String get goBackButton => 'પાછળ જાઓ';

  @override
  String get saveButton => 'સૅવ';

  @override
  String get language => 'ભાષા';

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
      'આ વાપરવા ખાતા પર પાસવર્ડ સેટ હોવો જોઈએ.\nસેટિંગ્સ → પાસવર્ડ બદલોમાંથી સેટ કરો.';

  @override
  String get usePhoneInstead => 'ફોન નંબર વાપરો →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'સ્વ-ક્ષય. કૃપા કરી ફરી ફોન ચકાસો.';

  @override
  String get upiIdsSavedSuccessfully => 'UPI IDs સફળતાપૂર્વક સૅવ થઈ';

  @override
  String get chooseYourLanguageHindi => 'તમારી ભાષા પસંદ કરો';

  @override
  String get unknownLanguage => 'અજ્ઞાત';

  @override
  String get businessCategoryMilkDairy => 'દૂધ / ડેરી';

  @override
  String get businessCategoryPressDhobi => 'પ્રેસ / ધોબી';

  @override
  String get businessCategoryMaidCook => 'બાઈ / રસોઇ';

  @override
  String get businessCategoryNewspaper => 'છાપું';

  @override
  String get businessCategoryWaterCan => 'પાણીની કૅન';

  @override
  String get businessCategoryTiffinFood => 'ટિફિન / ભોજન';

  @override
  String get businessCategoryKiranaGrocery => 'કિરાણું / ગ્રોસરી';

  @override
  String get businessCategorySalonParlour => 'સૅલૉન / પાર્લર';

  @override
  String get businessCategoryConstructionLabour => 'બાંધકામ મજૂર';

  @override
  String get businessCategoryTransportAuto => 'પ્રવાસ / ઑટો';

  @override
  String get businessCategoryOther => 'અન્ય';

  @override
  String get bookAnAppointment => 'મુલાકાત બુક કરો';

  @override
  String get noSlotsAvailable => 'કોઈ સ્લૉટ ઉપલબ્ધ નથી';

  @override
  String get trySelectingDifferentDate => 'જુદી તારીખ પ્રયાસ કરો';

  @override
  String get availableSlots => 'ઉપલબ્ધ સ્લૉટ';

  @override
  String get bookingConfirmedToast => 'બુકિંગ પુષ્ટિ!';

  @override
  String get date => 'તારીખ';

  @override
  String get time => 'સમય';

  @override
  String get notesOptional => 'નોંધ (વૈકલ્પિક)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes મિ.';
  }

  @override
  String get saveChanges => 'ફેરફાર સૅવ કરો';

  @override
  String get saveProduct => 'વસ્તુ સૅવ કરો';

  @override
  String get editProductMenuItem => 'વસ્તુ સંપાદિત કરો';

  @override
  String get deleteProductMenuItem => 'વસ્તુ ભૂંસો';

  @override
  String get noProductsYetDescription =>
      'તમે શું વેચો છો — દૂધ, પનીર, વગેરે — એક વાર ઉમેરો, પછી રોજ વાપરો.';

  @override
  String get selectProductToAssignQty => 'જથ્થો સોંપવા ઉપર વસ્તુ પસંદ કરો';

  @override
  String get noCustomersLinked => 'હજુ કોઈ ગ્રાહક જોડાયો નથી';

  @override
  String get chargeAll => 'બધાને ચાર્જ';

  @override
  String chargedSuccessfully(int count) {
    return '$count ગ્રાહક સફળતાપૂર્વક ચાર્જ થયો';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return '$count ગ્રાહકો સફળતાપૂર્વક ચાર્જ થયા';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok ચાર્જ, $fail નિષ્ફળ';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count ગ્રાહક  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count ગ્રાહકો  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return '₹$amount કુલ';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'આગળ: $vendorName · $date ના $time';
  }

  @override
  String get outstandingShortLabel => 'બાકી';

  @override
  String payViaUpiAmount(String amount) {
    return '₹$amount UPI થી ચૂકવો';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return '$count વ્યાપારીઓ ચૂકવ્યા, $skipped છોડ્યા.';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return '$count વ્યાપારી ચૂકવ્યો, $skipped છોડ્યો.';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'બધા $count વ્યાપારીઓ ચૂકવ્યા.';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'બધા $count વ્યાપારી ચૂકવ્યા.';
  }

  @override
  String get tapToAcceptOrDecline => 'સ્વીકારવા અથવા નકારવા ટૅપ કરો';

  @override
  String get helpSupportContactPrefix => 'કોઈ સહાય માટે અમારો સંપર્ક કરો:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'બુક';

  @override
  String waitingForVendorAcceptance(String name) {
    return '$name ની સ્વીકૃતિ રાહ.';
  }

  @override
  String get vendorWantsToConnectAsCustomer => 'એક વ્યાપારી જોડવા ઇચ્છે છે';

  @override
  String get vendorWantsToConnectDesc =>
      'તેઓ તમને ગ્રાહક તરીકે ઉમેરી ખાતું ટ્રૅક કરવા ઇચ્છે છે.';

  @override
  String get someoneWantsToConnect => 'કોઈ જોડવા ઇચ્છે છે';

  @override
  String get someoneWantsToConnectDesc =>
      'તેઓ તમારા ખાતામાં ગ્રાહક તરીકે ઉમેરાશે.';

  @override
  String requestedTimeAgo(String time) {
    return '$time પહેલાં વિનંતી';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'જોડાયા! $name હવે તમારા ખાતા સાથે લિંક છે.';
  }

  @override
  String requestDeclinedFrom(String name) {
    return '$name ની વિનંતી નકારી.';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'જોડાયા! $name હવે તમારા વ્યવસાય સાથે લિંક છે.';
  }

  @override
  String get processing => 'પ્રક્રિયા થઈ રહી છે…';

  @override
  String get retryButton => 'ફરી પ્રયાસ';

  @override
  String get memberDiscountDescription =>
      'આ સ્તરના સભ્યોને બાકી પર આ ડિસ્કાઉન્ટ મળે છે.';

  @override
  String get discountValueInvalid => '0 થી વધુ માન્ય રકમ દાખલ કરો';

  @override
  String get percentageExceedsMax => 'ટકા 100 થી વધી શકે નહીં';

  @override
  String levelLabel(int level) {
    return 'સ્તર $level';
  }

  @override
  String get rename => 'નામ બદલો';

  @override
  String get membershipLabel => 'સભ્યપદ';

  @override
  String get noMembership => 'સભ્યપદ નથી';

  @override
  String get applyForMembership => 'સભ્યપદ માટે અરજી';

  @override
  String get setMembershipTier => 'સભ્યપદ સ્તર સેટ કરો';

  @override
  String get chooseTierToRequestFromVendor => 'આ વ્યાપારી પાસેથી સ્તર પસંદ કરો';

  @override
  String chooseTierFor(String customerName) {
    return '$customerName માટે સ્તર પસંદ કરો';
  }

  @override
  String get setButton => 'સેટ';

  @override
  String get changeButton => 'બદલો';

  @override
  String get applyButton => 'અરજી';

  @override
  String get approveButton => 'મંજૂર';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName એ $tierName માટે વિનંતી કરી';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return '$tierName ની વિનંતી — મંજૂરી રાહ';
  }

  @override
  String get verificationConnecting => 'બૅન્ક સાથે જોડાઈ રહ્યા છીએ…';

  @override
  String get verificationVerifying => 'વ્યવહાર ચકાસાઈ રહ્યો છે…';

  @override
  String get verificationWaiting => 'પુષ્ટિ રાહ…';

  @override
  String get verificationAlmostThere => 'થોડીવારમાં…';

  @override
  String get verificationDoNotClose => 'આ સ્ક્રીન બંધ ન કરો';

  @override
  String verificationElapsed(int seconds) {
    return '${seconds}s  •  આ સ્ક્રીન બંધ ન કરો';
  }

  @override
  String txnLabel(String txnId) {
    return 'Txn: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '₹$amount $name ને ચૂકવ્યા';
  }

  @override
  String get verificationTimeoutBody =>
      '30 સેકન્ડમાં ચૂકવણી ચકાસી ન શક્યા. તમારા પૈસા કદાચ ગયા નથી — ફરી પ્રયાસ કરતા પહેલાં બૅન્ક સ્ટેટમેન્ટ તપાસો.';

  @override
  String get ifDebitedContactSupport =>
      'ડૅબિટ થયું હોય, Txn ID સાથે સહાયનો સંપર્ક કરો.';

  @override
  String get thisMonthSubtitle => 'આ મહિનો';

  @override
  String get billedNet => 'બિલ (ચોખ્ખું)';

  @override
  String get exclDisputed => 'વિવાદ સિવાય';

  @override
  String get receivedLabel => 'મળ્યું';

  @override
  String get paymentsAndAdj => 'ચૂકવણી અને ગોઠવણ';

  @override
  String get currentBalance => 'વર્તમાન બૅલૅન્સ';

  @override
  String paymentCount(int count) {
    return '$count ચૂકવણી';
  }

  @override
  String paymentCountPlural(int count) {
    return '$count ચૂકવણીઓ';
  }

  @override
  String customersCount(int count) {
    return '$count ગ્રાહક';
  }

  @override
  String get rankedByOutstanding => 'બાકી બૅલૅન્સ પ્રમાણે ક્રમ';

  @override
  String collectedThisMonth(String amount) {
    return '₹$amount આ મહિનો';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return '₹$amount આ મહિ.';
  }

  @override
  String get categoryAll => 'બધું';

  @override
  String get findVendorsNearYou => 'નજીકના વ્યાપારી શોધો';

  @override
  String get searchByNameOrCategory =>
      'નામ, વ્યવસાયના નામ,\nઅથવા ઉપર શ્રેણી પસંદ કરી શોધો.';

  @override
  String noResultsForQuery(String query) {
    return '\"$query\" માટે કોઈ પરિણામ નહીં.\nજુદું નામ અથવા શ્રેણી અજમાવો.';
  }

  @override
  String get addressLabel => 'સરનામું';

  @override
  String get emailLabel => 'ઈ-મેઇલ';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiEmailLabel => 'UPI / ઈ-મેઇલ';

  @override
  String get couldNotLoadRetry => 'લોડ ન થઈ — ફરી પ્રયાસ ટૅપ કરો';

  @override
  String labelCopied(String label) {
    return '$label કૉપી!';
  }

  @override
  String get upiIdCopied => 'UPI ID કૉપી!';

  @override
  String get requestSentButton => 'વિનંતી મોકલી';

  @override
  String get alreadyConnected => 'પહેલેથી જોડાયેલ';

  @override
  String get sendingEllipsis => 'મોકલી રહ્યા છીએ…';

  @override
  String get sendConnectionRequest => 'કનેક્શન વિનંતી મોકલો';

  @override
  String get copyUpiIdToPay => 'ચૂકવવા UPI ID કૉપી કરો';

  @override
  String requestSentToVendor(String name) {
    return 'વિનંતી મોકલી! $name ને જાણ કરાશે.';
  }

  @override
  String byOwnerName(String name) {
    return '$name દ્વારા';
  }

  @override
  String get logOut => 'લૉગ આઉટ';

  @override
  String get confirmLogoutTitle => 'લૉગ આઉટ';

  @override
  String get areYouSureLogout => 'શું તમે ખરેખર લૉગ આઉટ કરવા ઇચ્છો છો?';

  @override
  String get showQrToCollect => 'ગ્રાહકને સીધા ચૂકવણી લેવા આ QR બતાવો.';

  @override
  String get uploadQr => 'QR અપલોડ';

  @override
  String get replaceQr => 'બદલો';

  @override
  String get qrUploaded => 'QR અપલોડ થઈ';

  @override
  String scanToPayName(String name) {
    return '$name ને ચૂકવવા સ્કૅન કરો';
  }

  @override
  String get salarySingle => 'પગાર';

  @override
  String get advanceSingle => 'આગોતરું';

  @override
  String get customersTitle => 'ગ્રાહકો';

  @override
  String balanceDue(String balance) {
    return '₹$balance બાકી';
  }

  @override
  String get recordDeliveryTooltip => 'ડિલિવરી નોંધો';

  @override
  String get viewLedgerTooltip => 'ખાતું જુઓ';

  @override
  String staffRoleSubtitle(String name) {
    return 'સ્ટાફ · $name';
  }

  @override
  String get recordDelivery => 'ઉધાર દીધો';

  @override
  String get recordDeliverySubtitle => 'ગ્રાહકે માલ લીધો — ખાતામાં ઉમેરો';

  @override
  String get collectPayment => 'પૈસા મળ્યા';

  @override
  String get collectPaymentSubtitle => 'ગ્રાહકે ચૂકવ્યું — ખાતામાં ઘટાડો';

  @override
  String get viewAll2 => 'બધું જુઓ';

  @override
  String get noCustomersStaff => 'હજુ કોઈ ગ્રાહક નથી';

  @override
  String get myVendorsSection => 'મારા વ્યાપારી';

  @override
  String get shopsYouBuyFrom => 'તમે જ્યાંથી ખરીદો તે દુકાનો';

  @override
  String get awaitingAcceptanceTitle => 'સ્વીકૃતિ રાહ';

  @override
  String get customersHaventConfirmed => 'આ ગ્રાહકોએ હજુ પુષ્ટિ નથી કરી';

  @override
  String get pendingBadge => 'બાકી';

  @override
  String get notifyCustomersWithDues => 'બાકી ધરાવતા ગ્રાહકોને જણાવો';

  @override
  String get linkANewCustomer => 'નવો ગ્રાહક જોડો';

  @override
  String get dailyCharge => 'દૈનિક ચાર્જ';

  @override
  String get dailyChargeSubtitle => 'જથ્થો સેટ કરો અને એક સાથે ચાર્જ';

  @override
  String get findByPhoneOrEmailHint => 'ફોન નંબર અથવા ઈ-મેઇલ દ્વારા શોધો';

  @override
  String get phoneOrEmailLabel => 'ફોન અથવા ઈ-મેઇલ';

  @override
  String get phoneMobileOrEmail => '10 અંક મોબાઇલ અથવા ઈ-મેઇલ સરનામું';

  @override
  String get nicknameOptionalLabel => 'ઉપનામ (વૈકલ્પિક)';

  @override
  String get howYouKnowCustomer => 'તમે આ ગ્રાહકને કેવી રીતે ઓળખો';

  @override
  String get requestSentWillBeNotified =>
      'વિનંતી મોકલી! પુષ્ટિ માટે તેઓને જાણ કરાશે.';

  @override
  String get outstandingTitle => 'બાકી';

  @override
  String customersWithDues(int count) {
    return '$count+ ગ્રાહકો બાકી';
  }

  @override
  String get dueLabel => 'બાકી';

  @override
  String get collectedTodayTitle => 'આજે ઉઘરાણું';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ ચૂકવણી';
  }

  @override
  String get noPaymentsYetSubtitle => 'હજુ કોઈ ચૂકવણી નથી';

  @override
  String removeLedgerVendorContent(String name) {
    return 'આ $name સાથેનો સંબંધ નિષ્ક્રિય કરશે. બંને પક્ષ આ ખાતાની ઍક્સેસ ગુમાવશે.';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'આ $name સાથેનું કનેક્શન દૂર કરશે.';
  }

  @override
  String get offlineUpdatesPaused => 'ઑફ્લાઇન — અપડેટ અટક્યા';

  @override
  String get exportStatementTitle => 'સ્ટેટમેન્ટ નિકાસ';

  @override
  String get chooseExportDateRange => 'PDF માં સમાવિષ્ટ તારીખ શ્રેણી પસંદ કરો.';

  @override
  String get last7DaysRange => 'છેલ્લા 7 દિવસની એન્ટ્રી';

  @override
  String get last30DaysRange => 'છેલ્લા 30 દિવસની એન્ટ્રી';

  @override
  String get last3MonthsRange => 'છેલ્લા 3 મહિનાની એન્ટ્રી';

  @override
  String get completeLedgerHistory => 'સંપૂર્ણ ખાતા ઇતિહાસ';

  @override
  String appAccessActive(String phone) {
    return 'સક્રિય · $phone';
  }

  @override
  String get appAccessDisabled => 'બંધ';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name હવે $phone થી લૉગ ઇન કરી શકે છે';
  }

  @override
  String appAccessRevoked(String name) {
    return '$name ની ઍપ ઍક્સેસ રદ';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'ચાલુ હોય ત્યારે, $name પોતાના નંબર ($phone) થી લૉગ ઇન કરી ડિલિવરી-ચૂકવણી નોંધી શકે અને QR બતાવી શકે — પણ હાજરી, ગ્રાહક ઉમેરવા, અથવા બીજા સ્ટાફ જોઈ શકે નહીં.';
  }

  @override
  String get paymentHistoryTitle => 'ચૂકવણી ઇતિહાસ';

  @override
  String get couldNotLoadPaymentHistory => 'ચૂકવણી ઇતિહાસ લોડ ન થઈ';

  @override
  String get voicePleaseCheck => 'કૃપા કરી ચકાસો';

  @override
  String get navHome => 'હોમ';

  @override
  String get qty => 'જથ્થો';

  @override
  String totalRupees(String amount) {
    return 'કુલ: ₹$amount';
  }

  @override
  String get selectCustomerFirst => 'પહેલા ગ્રાહક પસંદ કરો';

  @override
  String get enterValidAmount => 'માન્ય રકમ દાખલ કરો';

  @override
  String get addsCredit => 'ગ્રાહકે માલ લીધો — ખાતામાં ઉમેરો';

  @override
  String get recordsCash => 'ગ્રાહકે ચૂકવ્યું — ખાતામાં ઘટાડો';

  @override
  String deliveryRecordedFor(String name) {
    return '$name ની ડિલિવરી નોંધી';
  }

  @override
  String paymentCollectedFrom(String name) {
    return '$name પાસેથી ચૂકવણી';
  }

  @override
  String get manageSchedule => 'સમયપત્રક સંચાલિત કરો';

  @override
  String get bookingsTab => 'બુકિંગ';

  @override
  String get bySlotTab => 'સ્લૉટ પ્રમાણે';

  @override
  String get scheduleSaved => 'સમયપત્રક સૅવ!';

  @override
  String get addSlot => 'સ્લૉટ ઉમેરો';

  @override
  String noSlotsForDay(String day) {
    return '$day માટે કોઈ સ્લૉટ નથી';
  }

  @override
  String get tapAddSlotHint => 'ઉપલબ્ધતા સેટ કરવા \"સ્લૉટ ઉમેરો\" ટૅપ કરો';

  @override
  String get slotAvailable => 'ઉપલબ્ધ';

  @override
  String get slotsFull => 'સ્લૉટ ભરાઈ ગયો';

  @override
  String get slotFullHint => 'આ સ્લૉટ ભરેલો ગણો';

  @override
  String get enableSlotFirst => 'પહેલા સ્લૉટ ચાલુ કરો';

  @override
  String get deleteSlotTitle => 'સ્લૉટ ભૂંસો';

  @override
  String deleteSlotConfirm(String time) {
    return '$time ના સ્લૉટ ભૂંસવો?';
  }

  @override
  String get endTimeAfterStart => 'સમાપ્તિ સમય શરૂ સમય પછી હોવો જોઈએ';

  @override
  String get slotOverlaps => 'આ સ્લૉટ હાલના સ્લૉટ સાથે ઓવરલૅપ થાય છે';

  @override
  String get addTimeSlot => 'સ્લૉટ ઉમેરો';

  @override
  String get editTimeSlot => 'સ્લૉટ સંપાદિત કરો';

  @override
  String get selectTimeHint =>
      '12 કલાકના ફોર્મેટમાં શરૂ અને સમાપ્તિ સમય પસંદ કરો';

  @override
  String get startLabel => 'શરૂ';

  @override
  String get endLabel => 'અંત';

  @override
  String get update => 'અપડેટ';

  @override
  String get notifTabAll => 'બધું';

  @override
  String get notifTabBookings => 'બુકિંગ';

  @override
  String get noBookingNotifications => 'કોઈ બુકિંગ સૂચના નથી';

  @override
  String get noBookingNotificationsSubtitle =>
      'બુકિંગ વિનંતી અને અપડેટ અહીં દેખાશે';

  @override
  String get bookingPillLabel => 'બુકિંગ';

  @override
  String get slotDetailTitle => 'સ્લૉટ વિગત';

  @override
  String bookingsCount(int count) {
    return '$count બુકિંગ';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$count બુકિંગ';
  }

  @override
  String pendingCountLabel(int count) {
    return '$count બાકી';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'રાખો';

  @override
  String get deleteButton => 'ભૂંસો';

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
  String get membershipPlansTitle => 'સભ્યપદ યોજના';

  @override
  String get newPlanButton => 'નવી યોજના';

  @override
  String get deletePlanTitle => 'યોજના ભૂંસવી?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" દૂર કરાશે. આ ઉલટાવી ન શકાય.';
  }

  @override
  String get inactiveLabel => 'નિષ્ક્રિય';

  @override
  String get noBenefitsAdded => 'કોઈ લાભ ઉમેર્યો નથી.';

  @override
  String get noMembershipPlans => 'હજુ કોઈ સભ્યપદ યોજના નથી';

  @override
  String get tapNewPlanHint => 'પ્રથમ યોજના બનાવવા \"નવી યોજના\" ટૅપ કરો.';

  @override
  String get membershipRequestsTitle => 'સભ્યપદ વિનંતી';

  @override
  String get noPendingRequests => 'કોઈ બાકી વિનંતી નથી';

  @override
  String get customersCanApplyHint =>
      'ગ્રાહકો ખાતા સ્ક્રીનમાંથી\nસભ્યપદ માટે અરજી કરી શકે છે.';

  @override
  String get membersTitle => 'સભ્યો';

  @override
  String get noMembersYet => 'હજુ કોઈ સભ્ય નથી';

  @override
  String get activeStat => 'સક્રિય';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'સમાપ્ત';

  @override
  String get allPlansFilter => 'બધી યોજના';

  @override
  String daysLeft(int count) {
    return '$countદ. બાકી';
  }

  @override
  String daysLeftFull(int count) {
    return '$count દિવસ';
  }

  @override
  String get planNameLabel => 'યોજનાનું નામ';

  @override
  String get planNameHint => 'દા.ત. ગોલ્ડ સભ્યપદ';

  @override
  String get durationDaysLabel => 'અવધિ (દિવસ)';

  @override
  String get priceRupeesLabel => 'ભાવ ₹';

  @override
  String get addBenefitButton => 'લાભ ઉમેરો';

  @override
  String get customLabel => 'કસ્ટમ';

  @override
  String get customAdvanceLabel => 'કસ્ટમ આગોતરું ₹';

  @override
  String get benefitLabel => 'લાભ';

  @override
  String get benefitHint => 'દા.ત. 4 હૅરકટ';

  @override
  String get planDetailsSection => 'યોજના વિગત';

  @override
  String get benefitsSection => 'લાભ';

  @override
  String get advanceRequiredSection => 'જરૂરી આગોતરું';

  @override
  String get editPlanTitle => 'યોજના સંપાદિત';

  @override
  String get createPlanTitle => 'સભ્યપદ યોજના બનાવો';

  @override
  String get publishPlanButton => 'યોજના પ્રકાશિત';

  @override
  String get planUpdatedToast => 'યોજના અપડેટ';

  @override
  String get planPublishedToast => 'યોજના પ્રકાશિત';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · યોજના';
  }

  @override
  String get noPlansAvailable => 'હજુ કોઈ યોજના ઉપલબ્ધ નથી';

  @override
  String get vendorNoPlansHint => 'આ વ્યાપારીએ હજુ કોઈ સભ્યપદ યોજના બનાવી નથી.';

  @override
  String applyForPlan(String planName) {
    return '$planName માટે અરજી';
  }

  @override
  String get messageToVendorOptional => 'વ્યાપારીને સંદેશ (વૈકલ્પિક)';

  @override
  String get messageToVendorHint => 'દા.ત. કૃપા કરી આ મહિને નોંધો';

  @override
  String get sendRequestButton => 'વિનંતી મોકલો';

  @override
  String get activeLabel => 'સક્રિય';

  @override
  String get noAdditionalBenefits => 'કોઈ વધારાના લાભ નથી';

  @override
  String get currentPlanLabel => 'વર્તમાન યોજના';

  @override
  String get requestPendingLabel => 'વિનંતી બાકી';

  @override
  String get applyLabel => 'અરજી';

  @override
  String requestSentToName(String name) {
    return '$name ને વિનંતી મોકલી';
  }

  @override
  String get membershipDialogTitle => 'સભ્યપદ';

  @override
  String pendingPlanPrefix(String planName) {
    return 'બાકી: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return '$name ને નોંધો';
  }

  @override
  String get choosePlanHint => 'સભ્યપદ શરૂ કરવા યોજના પસંદ કરો.';

  @override
  String get noActivePlansHint =>
      'કોઈ સક્રિય યોજના નથી. સભ્યપદ → યોજનામાં પ્રથમ બનાવો.';

  @override
  String get enrollLabel => 'નોંધો';

  @override
  String get changeLabel => 'બદલો';

  @override
  String get usedLabel => 'વાપર્યું';

  @override
  String get useLabel => 'વાપરો';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count દિવસ બાકી';
  }

  @override
  String get orderPlacedSuccess => 'ઑર્ડર સફળતાપૂર્વક આપ્યો!';

  @override
  String orderFromVendor(String vendorName) {
    return '$vendorName નો ઑર્ડર';
  }

  @override
  String get addItemButton => 'વસ્તુ ઉમેરો';

  @override
  String get orderNoteOptional => 'ઑર્ડર નોંધ (વૈકલ્પિક)';

  @override
  String get totalLabel => 'કુલ';

  @override
  String get placeOrderButton => 'ઑર્ડર આપો';

  @override
  String get itemNameRequired => 'વસ્તુનું નામ *';

  @override
  String get unitLabel => 'એકમ';

  @override
  String get unitHint => 'kg, L…';

  @override
  String get unitPriceLabel => 'એકમ ₹';

  @override
  String itemNumber(int number) {
    return 'વસ્તુ $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'પેટા-કુલ: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'ઑર્ડર વિગત';

  @override
  String get proofPhotoLabel => 'પ્રૂફ ફોટો';

  @override
  String get tapToViewFullScreen => 'ફૂલ સ્ક્રીન જોવા ટૅપ કરો';

  @override
  String get rejectButton => 'નકારો';

  @override
  String get confirmButton => 'પુષ્ટિ';

  @override
  String get markAsDeliveredButton => 'ડિલિવર્ડ ગણો';

  @override
  String get confirmDeliveryTitle => 'ડિલિવરી પુષ્ટિ';

  @override
  String get deliveryNoteOptional => 'ડિલિવરી નોંધ (વૈકલ્પિક)';

  @override
  String get retakeLabel => 'ફરી ફોટો';

  @override
  String photoUploadFailed(String error) {
    return 'ફોટો અપલોડ નિષ્ફળ: $error';
  }

  @override
  String get orderNoteLabel => 'ઑર્ડર નોંધ';

  @override
  String get customerLabel => 'ગ્રાહક';

  @override
  String get ordersTitle => 'ઑર્ડર';

  @override
  String get noOrdersYet => 'હજુ કોઈ ઑર્ડર નથી';

  @override
  String get markDeliveredButton => 'ડિલિવર્ડ ગણો';

  @override
  String get myOrdersTitle => 'મારા ઑર્ડર';

  @override
  String get deliverButton => 'ડિલિવર';

  @override
  String get noPendingDeliveries => 'કોઈ બાકી ડિલિવરી નથી';

  @override
  String get deliveriesTitle => 'ડિલિવરી';

  @override
  String get monthlyStatementTitle => 'માસિક સ્ટેટમેન્ટ';

  @override
  String get deliveryProofLabel => 'ડિલિવરી પ્રૂફ';

  @override
  String get replacePhotoButton => 'ફોટો બદલો';

  @override
  String get attachProofButton => 'પ્રૂફ જોડો';

  @override
  String get uploadingLabel => 'અપલોડ...';

  @override
  String get proofLockedHint => 'આ પ્રૂફ લૉક છે અને બદલી ન શકાય';

  @override
  String get proofAttachedToast => 'પ્રૂફ જોડ્યો';

  @override
  String itemLabel(int number) {
    return 'વસ્તુ $number';
  }

  @override
  String get amountRequired => 'રકમ *';

  @override
  String get addItemLabel => 'વસ્તુ ઉમેરો';

  @override
  String get totalAmountLabel => 'કુલ';

  @override
  String get deactivate => 'નિષ્ક્રિય';

  @override
  String get activate => 'સક્રિય';

  @override
  String get activeStatLabel => 'સક્રિય';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'સમાપ્ત';

  @override
  String get closeLabel => 'બંધ';

  @override
  String pendingPlanLabel(String name) {
    return 'બાકી: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer એ $plan ની વિનંતી કરી';
  }

  @override
  String itemsCount(int count) {
    return 'વસ્તુ ($count)';
  }

  @override
  String get deliveryLabel => 'ડિલિવરી';

  @override
  String markedDeliveredBy(String role) {
    return '$role દ્વારા ડિલિવર્ડ';
  }

  @override
  String get deliveriesHint =>
      'ઑર્ડર દ્વારા ડિલિવ૨ થયેલ વસ્તુ. વિગત જોવા ટૅપ કરો.';

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
