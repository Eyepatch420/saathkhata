// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'സാഥ്ഖാതാ';

  @override
  String get tagline => 'ഒരു ഖാതാ, ഇരുവർക്കും';

  @override
  String get onboarding1Title => 'ഇരുകക്ഷി പങ്കിട്ട ലെഡ്ജർ';

  @override
  String get onboarding1Subtitle =>
      'വ്യാപാരിക്കും ഉപഭോക്താവിനും ഒരേ ഖാതാ. ഇരുവരും ഒരേ സത്യം കാണുന്നു.';

  @override
  String get onboarding2Title => 'വോയ്‌സ് & ബിൽ OCR';

  @override
  String get onboarding2Subtitle =>
      '12 ഭാഷകളിൽ ഉടൻ എൻട്രികൾ ഉണ്ടാക്കാൻ സംസാരിക്കുക അല്ലെങ്കിൽ ബിൽ സ്കാൻ ചെയ്യുക.';

  @override
  String get onboarding3Title => 'ഒരു ടാപ്പിൽ UPI പേയ്‌മെന്റ്';

  @override
  String get onboarding3Subtitle =>
      'UPI വഴി ഒരു ടാപ്പിൽ മാസത്തെ കുടിശ്ശിക അടയ്ക്കുക.';

  @override
  String get getStarted => 'ആരംഭിക്കൂ';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get skip => 'ഒഴിവാക്കുക';

  @override
  String get chooseLanguage => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get continueButton => 'തുടരുക';

  @override
  String get chooseRole => 'നിങ്ങളുടെ റോൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get vendor => 'വ്യാപാരി';

  @override
  String get customer => 'ഉപഭോക്താവ്';

  @override
  String get welcomeToSaathKhata => 'സാഥ്ഖാതയിലേക്ക് സ്വാഗതം';

  @override
  String get tellUsHowYouUse => 'ആപ്പ് എങ്ങനെ ഉപയോഗിക്കുമെന്ന് പറയൂ';

  @override
  String get vendorRoleTitle => 'ഞാൻ ഒരു വ്യാപാരിയാണ്';

  @override
  String get vendorRoleSubtitle =>
      'ബിസിനസ് ഖാതാ, ജീവനക്കാരെ നിയന്ത്രിക്കൂ, പേയ്‌മെന്റ് സ്വീകരിക്കൂ.';

  @override
  String get customerRoleTitle => 'ഞാൻ ഒരു ഉപഭോക്താവാണ്';

  @override
  String get customerRoleSubtitle =>
      'വ്യാപാരികളുമായി ഖാതാ ട്രാക്ക് ചെയ്യൂ, UPI വഴി പണം നൽകൂ.';

  @override
  String get loginTitle => 'സാഥ്ഖാതയിൽ ലോഗിൻ ചെയ്യൂ';

  @override
  String get enterMobile => 'തുടരാൻ വിവരങ്ങൾ നൽകൂ';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get sendOtp => 'OTP അയക്കൂ';

  @override
  String get verifyOtp => 'OTP സ്ഥിരീകരിക്കൂ';

  @override
  String get verifyAndContinue => 'സ്ഥിരീകരിച്ച് തുടരൂ';

  @override
  String get changePhoneNumber => 'ഫോൺ നമ്പർ മാറ്റൂ';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumber ലേക്ക് അയച്ച 6 അക്ക കോഡ് നൽകൂ';
  }

  @override
  String get email => 'ഇ-മെയിൽ';

  @override
  String get password => 'പാസ്‌വേഡ്';

  @override
  String get passwordHint => 'പാസ്‌വേഡ് നൽകൂ';

  @override
  String get loginButton => 'ലോഗിൻ';

  @override
  String get noAccount => 'അക്കൗണ്ട് ഇല്ലേ?';

  @override
  String get signUp => 'രജിസ്റ്റർ ചെയ്യൂ';

  @override
  String get pleaseEnterCredentials => 'ഇ-മെയിലും പാസ്‌വേഡും നൽകൂ';

  @override
  String get fillRequiredFields => 'പേര്, ഇ-മെയിൽ, പാസ്‌വേഡ് നൽകൂ';

  @override
  String get passwordMinChars => 'കുറഞ്ഞത് 8 അക്ഷരങ്ങൾ';

  @override
  String get completeProfile => 'പ്രൊഫൈൽ പൂർത്തിയാക്കൂ';

  @override
  String get enterYourName => 'നിങ്ങളുടെ പേര് നൽകൂ';

  @override
  String get egBusinessName => 'ഉദാ. കൃഷ്ണ ഡെയറി';

  @override
  String get selectCategory => 'വിഭാഗം തിരഞ്ഞെടുക്കൂ';

  @override
  String get enterAddress => 'പ്രദേശം അല്ലെങ്കിൽ പൂർണ്ണ വിലാസം നൽകൂ';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'പൂർണ്ണ പേര്';

  @override
  String get businessName => 'ബിസിനസ് പേര്';

  @override
  String get businessCategory => 'ബിസിനസ് വിഭാഗം';

  @override
  String get businessAddress => 'ബിസിനസ് വിലാസം (ഐച്ഛികം)';

  @override
  String get upiId => 'UPI ID (പേയ്‌മെന്റുകൾക്ക്)';

  @override
  String get vendorDashboard => 'വ്യാപാരി ഡാഷ്‌ബോർഡ്';

  @override
  String get customerDashboard => 'ഉപഭോക്താവ് ഡാഷ്‌ബോർഡ്';

  @override
  String get customerMode => 'ഉപഭോക്തൃ മോഡ്';

  @override
  String get myVendors => 'എന്റെ വ്യാപാരികൾ';

  @override
  String get outstanding => 'കുടിശ്ശിക';

  @override
  String get collectedToday => 'ഇന്ന് ശേഖരിച്ചത്';

  @override
  String get quickActions => 'വേഗ പ്രവർത്തനങ്ങൾ';

  @override
  String get scanBill => 'ബിൽ സ്കാൻ ചെയ്യൂ';

  @override
  String get remindAll => 'എല്ലാവരെയും ഓർമ്മിപ്പിക്കൂ';

  @override
  String get addNew => 'പുതിയത് ചേർക്കൂ';

  @override
  String get recentCustomers => 'സമീപകാല ഉപഭോക്താക്കൾ';

  @override
  String get viewAll => 'എല്ലാം കാണൂ';

  @override
  String customerAddedSnackbar(String name) {
    return '$name ചേർത്തു';
  }

  @override
  String get sharedLedger => 'പങ്കിട്ട ഖാതാ';

  @override
  String get totalBalance => 'മൊത്തം ബാലൻസ്';

  @override
  String get statement => 'സ്റ്റേറ്റ്‌മെന്റ്';

  @override
  String get giveCredit => 'കടം നൽകൂ';

  @override
  String get recordPayment => 'പേയ്‌മെന്റ് രേഖപ്പെടുത്തൂ';

  @override
  String get giveCreditSheet => 'കടം നൽകൂ';

  @override
  String get recordPaymentSheet => 'പേയ്‌മെന്റ് രേഖപ്പെടുത്തൂ';

  @override
  String get filterAll => 'എല്ലാം';

  @override
  String get balanceCustomerOwes => 'ഉപഭോക്താവിന്റെ കുടിശ്ശിക';

  @override
  String get balanceYouOwe => 'നിങ്ങളുടെ കുടിശ്ശിക';

  @override
  String get balanceSettled => 'തീർപ്പാക്കി';

  @override
  String get balanceYouOweVendor => 'നിങ്ങൾ വ്യാപാരിക്ക് കൊടുക്കാനുണ്ട്';

  @override
  String get balanceVendorOwesYou => 'വ്യാപാരി നിങ്ങൾക്ക് കൊടുക്കാനുണ്ട്';

  @override
  String get ledgerInfoTitle => 'ഈ ഖാതാ എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get statusConfirmed => 'സ്ഥിരീകരിച്ചു';

  @override
  String get statusConfirmedDesc =>
      'ഇരുകക്ഷിയും സമ്മതിച്ചു. എൻട്രി ലോക്ക് ചെയ്തു, മാറ്റാനാകില്ല.';

  @override
  String get statusPending => 'കാത്തിരിക്കുന്നു';

  @override
  String get statusPendingDesc =>
      'ഉപഭോക്താവിന്റെ സ്ഥിരീകരണം കാക്കുന്നു. 72 മണിക്കൂറിൽ സ്വയം സ്ഥിരീകരിക്കും.';

  @override
  String get statusDisputed => 'തർക്കത്തിൽ';

  @override
  String get statusDisputedDesc =>
      'ഉപഭോക്താവ് തർക്കമുന്നയിച്ചു. വ്യാപാരി അവലോകനം ആവശ്യം.';

  @override
  String get statusAutoConfirmed => 'സ്വയം സ്ഥിരീകരണം';

  @override
  String get entryTypeCreditLabel => 'കടം എൻട്രി';

  @override
  String get entryTypePaymentLabel => 'പേയ്‌മെന്റ് ലഭിച്ചു';

  @override
  String get entryDetails => 'എൻട്രി വിവരങ്ങൾ';

  @override
  String get entryAmount => 'തുക';

  @override
  String get entryType => 'തരം';

  @override
  String get entryTypeCreditGiven => 'കടം (നൽകിയത്)';

  @override
  String get entryTypePaymentReceived => 'പേയ്‌മെന്റ് (ലഭിച്ചത്)';

  @override
  String get entryDate => 'തീയതി';

  @override
  String get entryDescription => 'വിവരണം';

  @override
  String get entryQuantity => 'അളവ്';

  @override
  String get entryConfirmedAt => 'സ്ഥിരീകരണ തീയതി';

  @override
  String get entryDisputeReason => 'തർക്കത്തിന്റെ കാരണം';

  @override
  String entryFor(String name) {
    return '$name ന് വേണ്ടി';
  }

  @override
  String get description => 'വിവരണം';

  @override
  String get descriptionOptional => 'വിവരണം (ഐച്ഛികം)';

  @override
  String get quantityOptional => 'അളവ് (ഐച്ഛികം)';

  @override
  String get descriptionHint => 'ഉദാ. 2L പാൽ, മാസ കിരാണ';

  @override
  String get quantityHint => 'ഉദാ. 2';

  @override
  String get addCreditEntry => 'കടം എൻട്രി ചേർക്കൂ';

  @override
  String get noLedgerTransactions => 'ഇനിയും ഇടപാടുകൾ ഇല്ല';

  @override
  String get noLedgerTransactionsSubtitle =>
      'ആരംഭിക്കാൻ കടം അല്ലെങ്കിൽ പേയ്‌മെന്റ് എൻട്രി ചേർക്കൂ.';

  @override
  String get confirmEntryTitle => 'എൻട്രി സ്ഥിരീകരിക്കൂ';

  @override
  String confirmEntryMessage(String amount) {
    return '₹$amount എൻട്രി സ്ഥിരീകരിക്കണോ? ഇത് മാറ്റാനാകില്ല.';
  }

  @override
  String get dispute => 'തർക്കം';

  @override
  String get raiseDisputeTitle => 'തർക്കം ഉന്നയിക്കൂ';

  @override
  String get raiseDisputeSubtitle =>
      'ഈ എൻട്രിയിൽ എന്ത് തെറ്റാണെന്ന് വിശദീകരിക്കൂ.';

  @override
  String get raiseDisputeHint => 'ഉദാ. തുക ₹50 ആകണം, ₹60 അല്ല';

  @override
  String get submitDispute => 'തർക്കം സമർപ്പിക്കൂ';

  @override
  String get staffAndLabour => 'ജീവനക്കാരും തൊഴിലാളികളും';

  @override
  String get addStaff => 'ജീവനക്കാരനെ ചേർക്കൂ';

  @override
  String get presentToday => 'ഇന്ന് ഹാജർ';

  @override
  String get unpaidSalary => 'നൽകാത്ത ശമ്പളം';

  @override
  String get paySalary => 'ശമ്പളം നൽകൂ';

  @override
  String get noStaffAdded => 'ഇനിയും ജീവനക്കാർ ഇല്ല';

  @override
  String get noStaffAddedSubtitle =>
      'ആദ്യ ജീവനക്കാരനെ ചേർക്കാൻ താഴെ ബട്ടൺ അമർത്തൂ.';

  @override
  String get present => 'ഹാജർ';

  @override
  String get absent => 'ഗൈർഹാജർ';

  @override
  String get halfDay => 'അർദ്ധ ദിവസം';

  @override
  String get paySalaryTitle => 'ശമ്പളം നൽകൂ';

  @override
  String unpaidLabel(String amount) {
    return 'നൽകാത്തത്: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI ഇടപാട് ID (ഐച്ഛികം)';

  @override
  String get noDues => 'കുടിശ്ശിക ഇല്ല';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount നൽകൂ';
  }

  @override
  String staffJoined(String date) {
    return '$date ന് ചേർന്നു';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/ദിവസം';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/മാസം';
  }

  @override
  String get staffPayButton => 'പേയ്‌മെന്റ്';

  @override
  String get businessReports => 'ബിസിനസ് റിപ്പോർട്ടുകൾ';

  @override
  String get revenueTrend => 'വരുമാന പ്രവണത';

  @override
  String get collectionSummary => 'ശേഖരണ സംഗ്രഹം';

  @override
  String get totalOutstanding => 'മൊത്തം കുടിശ്ശിക';

  @override
  String get totalCollected => 'മൊത്തം ശേഖരിച്ചത്';

  @override
  String get topCustomers => 'മികച്ച ഉപഭോക്താക്കൾ';

  @override
  String get seeAll => 'എല്ലാം കാണൂ';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get appLanguage => 'ആപ്പ് ഭാഷ';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കൂ';

  @override
  String get settingsManagePayments => 'പേയ്‌മെന്റ് അക്കൗണ്ടുകൾ നിയന്ത്രിക്കൂ';

  @override
  String get settingsManageAlerts =>
      'അലർട്ടുകളും ഓർമ്മിപ്പിക്കലുകളും നിയന്ത്രിക്കൂ';

  @override
  String get settingsAppPinFingerprint => 'ആപ്പ് പിൻ, വിരലടയാളം';

  @override
  String get settingsFaqsContact => 'സഹായവും ബന്ധപ്പെടലും';

  @override
  String settingsVersion(String version) {
    return 'പതിപ്പ് $version';
  }

  @override
  String get myUpiIds => 'എന്റെ UPI IDകൾ';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get security => 'സുരക്ഷ';

  @override
  String get helpSupport => 'സഹായം';

  @override
  String get logout => 'ലോഗ് ഔട്ട്';

  @override
  String get markAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തൂ';

  @override
  String get noNotificationsTitle => 'ഇനിയും അറിയിപ്പുകൾ ഇല്ല';

  @override
  String get noNotificationsSubtitle =>
      'ഇവിടെ ഖാതാ അപ്‌ഡേറ്റുകൾ, പേയ്‌മെന്റ് അലർട്ടുകൾ, ഓർമ്മിപ്പിക്കലുകൾ കാണും.';

  @override
  String get today => 'ഇന്ന്';

  @override
  String get yesterday => 'ഇന്നലെ';

  @override
  String minutesAgo(int count) {
    return '$count മിനിറ്റ് മുമ്പ്';
  }

  @override
  String hoursAgo(int count) {
    return '$count മണിക്കൂർ മുമ്പ്';
  }

  @override
  String get payments => 'പേയ്‌മെന്റുകൾ';

  @override
  String get transactionHistory => 'ഇടപാട് ചരിത്രം';

  @override
  String get totalPaid => 'മൊത്തം അടച്ചത്';

  @override
  String get pending => 'കാത്തിരിക്കുന്നു';

  @override
  String get quickPay => 'വേഗ പേയ്‌മെന്റ്';

  @override
  String get scanAndPay => 'സ്കാൻ ചെയ്ത് അടയ്ക്കൂ';

  @override
  String get scanUpiDesc => 'വ്യാപാരിക്ക് നൽകാൻ UPI QR സ്കാൻ ചെയ്യൂ';

  @override
  String get noTransactionsTitle => 'ഇനിയും ഇടപാടുകൾ ഇല്ല';

  @override
  String get noTransactionsSubtitle =>
      'നിങ്ങളുടെ പേയ്‌മെന്റ് ചരിത്രം ഇവിടെ കാണും.';

  @override
  String get paymentStatusPaid => 'അടച്ചു';

  @override
  String get paymentStatusFailed => 'പരാജയം';

  @override
  String get paymentStatusRefunded => 'തിരിച്ചു';

  @override
  String get appointments => 'അപ്പോയിന്റ്‌മെന്റുകൾ';

  @override
  String get myAppointments => 'എന്റെ അപ്പോയിന്റ്‌മെന്റുകൾ';

  @override
  String get upcoming => 'വരാനിരിക്കുന്നത്';

  @override
  String get past => 'കഴിഞ്ഞത്';

  @override
  String get cancelBooking => 'ബുക്കിംഗ് റദ്ദ് ചെയ്യൂ';

  @override
  String get keepBooking => 'നിലനിർത്തൂ';

  @override
  String get noBookingsToday => 'ഇന്ന് ബുക്കിംഗുകൾ ഇല്ല';

  @override
  String get noBookingsTodaySubtitle =>
      'ഉപഭോക്താക്കൾക്ക് ആപ്പ് വഴി അപ്പോയിന്റ്‌മെന്റ് ബുക്ക് ചെയ്യാം.';

  @override
  String get noAppointmentsTitle => 'ഇനിയും അപ്പോയിന്റ്‌മെന്റുകൾ ഇല്ല';

  @override
  String get noAppointmentsSubtitle =>
      'ആരംഭിക്കാൻ നിങ്ങളുടെ വ്യാപാരിയുമായി അപ്പോയിന്റ്‌മെന്റ് ബുക്ക് ചെയ്യൂ.';

  @override
  String get cancelAppointmentTitle => 'അപ്പോയിന്റ്‌മെന്റ് റദ്ദ് ചെയ്യണോ?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date ന് $time ന് ഉള്ള അപ്പോയിന്റ്‌മെന്റ് റദ്ദ് ചെയ്യണോ?';
  }

  @override
  String get bookingStatusConfirmed => 'സ്ഥിരീകരിച്ചു';

  @override
  String get bookingStatusPending => 'കാത്തിരിക്കുന്നു';

  @override
  String get bookingStatusCancelled => 'റദ്ദ്';

  @override
  String get bookingStatusCompleted => 'പൂർണ്ണം';

  @override
  String get bookingStatusDone => 'പൂർണ്ണം';

  @override
  String get upiPayment => 'UPI പേയ്‌മെന്റ്';

  @override
  String get amountToPay => 'അടയ്ക്കേണ്ട തുക';

  @override
  String get securedByUpi => 'UPI വഴി സുരക്ഷിതം';

  @override
  String get paymentSuccessful => 'പേയ്‌മെന്റ് വിജയകരം!';

  @override
  String get paymentFailed => 'പേയ്‌മെന്റ് പരാജയം';

  @override
  String get retryPayment => 'വീണ്ടും ശ്രമിക്കൂ';

  @override
  String get enterUpiId => 'UPI ID നൽകൂ';

  @override
  String get addNoteOptional => 'കുറിപ്പ് ചേർക്കൂ (ഐച്ഛികം)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount അടയ്ക്കൂ';
  }

  @override
  String get done => 'ആയി';

  @override
  String get paymentSomethingWentWrong => 'എന്തോ തകരാർ. വീണ്ടും ശ്രമിക്കൂ.';

  @override
  String upiAppComingSoon(String app) {
    return '$app ഉടൻ വരുന്നു';
  }

  @override
  String get pleaseEnterUpiId => 'UPI ID നൽകൂ';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $name ന് അടച്ചു';
  }

  @override
  String get orDivider => 'അല്ലെങ്കിൽ';

  @override
  String get addNewCustomer => 'പുതിയ ഉപഭോക്താവിനെ ചേർക്കൂ';

  @override
  String get customerName => 'ഉപഭോക്താവിന്റെ പേര്';

  @override
  String get mobileNo => 'മൊബൈൽ നമ്പർ';

  @override
  String get addCustomer => 'ഉപഭോക്താവിനെ ചേർക്കൂ';

  @override
  String get paymentConfirmed => 'പേയ്‌മെന്റ് സ്ഥിരീകരിക്കൂ';

  @override
  String get addAdvance => 'അഡ്വാൻസ് ചേർക്കൂ';

  @override
  String get addAdvanceTitle => 'അഡ്വാൻസ് ചേർക്കൂ';

  @override
  String get attendanceTitle => 'ഹാജർ';

  @override
  String get salaryTitle => 'ശമ്പള സംഗ്രഹം';

  @override
  String get rate => 'നിരക്ക്';

  @override
  String get daysPresent => 'ഹാജർ ദിവസങ്ങൾ';

  @override
  String get earned => 'സമ്പാദിച്ചത്';

  @override
  String get unpaid => 'നൽകാത്തത്';

  @override
  String get advanceTaken => 'എടുത്ത അഡ്വാൻസ്';

  @override
  String get active => 'സജീവം';

  @override
  String get inactive => 'നിഷ്‌ക്രിയം';

  @override
  String get joined => 'ചേർന്നു';

  @override
  String get noPhone => 'ഫോൺ ഇല്ല';

  @override
  String get addNewStaff => 'പുതിയ ജീവനക്കാരനെ ചേർക്കൂ';

  @override
  String get fullNameLabel => 'പൂർണ്ണ പേര്';

  @override
  String get phoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get role => 'റോൾ';

  @override
  String get salaryType => 'ശമ്പള തരം';

  @override
  String get dailyWage => 'ദൈനംദിന കൂലി';

  @override
  String get monthlySalary => 'മാസ ശമ്പളം';

  @override
  String get dailyWageAmount => 'ദൈനംദിന കൂലി (₹)';

  @override
  String get monthlySalaryAmount => 'മാസ ശമ്പളം (₹)';

  @override
  String get addStaffButton => 'ജീവനക്കാരനെ ചേർക്കൂ';

  @override
  String get noteOptional => 'കുറിപ്പ് (ഐച്ഛികം)';

  @override
  String get amountRupees => 'തുക (₹)';

  @override
  String get cancel => 'റദ്ദ്';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കൂ';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കൂ';

  @override
  String get alignBillInFrame => 'ബിൽ ഫ്രേമിൽ വയ്ക്കൂ';

  @override
  String get verifyAndLogin => 'സ്ഥിരീകരിച്ച് ലോഗിൻ ചെയ്യൂ';

  @override
  String get voiceListening => 'കേൾക്കുന്നു...';

  @override
  String get voiceThinking => 'ചിന്തിക്കുന്നു...';

  @override
  String get voiceDetectedEntry => 'കണ്ടെത്തിയ എൻട്രി';

  @override
  String get voiceConfirmEntry => 'എൻട്രി സ്ഥിരീകരിക്കൂ';

  @override
  String get item => 'ഇനം';

  @override
  String get totalOutstandingBalance => 'മൊത്തം കുടിശ്ശിക തുക';

  @override
  String get payAllDues => 'എല്ലാ കുടിശ്ശികയും അടയ്ക്കൂ';

  @override
  String get myKhatas => 'എന്റെ ഖാതകൾ';

  @override
  String get noVendorsFound => 'വ്യാപാരികളെ കണ്ടെത്തിയില്ല';

  @override
  String get verifyBillDetails => 'ബിൽ വിവരങ്ങൾ സ്ഥിരീകരിക്കൂ';

  @override
  String get scannedBillPreview => 'സ്കാൻ ചെയ്ത ബിൽ';

  @override
  String get descriptionItemDetails => 'വിവരണം / ഇനം വിശദാംശങ്ങൾ';

  @override
  String get selectCustomer => 'ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കൂ';

  @override
  String get searchCustomerHint =>
      'ഉപഭോക്താവിനെ തിരയൂ അല്ലെങ്കിൽ തിരഞ്ഞെടുക്കൂ';

  @override
  String get saveToKhata => 'ഖാതയിൽ സേവ് ചെയ്യൂ';

  @override
  String get allCustomersReport => 'എല്ലാ ഉപഭോക്താക്കളുടെ റിപ്പോർട്ട്';

  @override
  String collectedInMonth(String month) {
    return '$month ൽ ശേഖരിച്ചത്';
  }

  @override
  String get notificationSettings => 'അറിയിപ്പ് ക്രമീകരണങ്ങൾ';

  @override
  String get securityPin => 'സുരക്ഷയും പിൻ';

  @override
  String get editProfile => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യൂ';

  @override
  String get changePassword => 'പാസ്‌വേഡ് മാറ്റൂ';

  @override
  String get termsAndConditions => 'നിബന്ധനകളും വ്യവസ്ഥകളും';

  @override
  String get privacyPolicy => 'സ്വകാര്യതാ നയം';

  @override
  String get accountSettings => 'അക്കൗണ്ട് ക്രമീകരണങ്ങൾ';

  @override
  String get legalInfo => 'നിയമ';

  @override
  String get currentPassword => 'നിലവിലെ പാസ്‌വേഡ്';

  @override
  String get newPassword => 'പുതിയ പാസ്‌വേഡ്';

  @override
  String get confirmNewPassword => 'പുതിയ പാസ്‌വേഡ് സ്ഥിരീകരിക്കൂ';

  @override
  String get passwordsDoNotMatch => 'പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get changePasswordButton => 'പാസ്‌വേഡ് മാറ്റൂ';

  @override
  String get passwordChangedSuccess => 'പാസ്‌വേഡ് വിജയകരമായി മാറ്റി';

  @override
  String get loadingContent => 'ലോഡ് ചെയ്യുന്നു...';

  @override
  String get failedToLoad =>
      'ഉള്ളടക്കം ലോഡ് ചെയ്യുന്നതിൽ പരാജയം. വീണ്ടും ശ്രമിക്കൂ.';

  @override
  String get bookingActions => 'ബുക്കിംഗ് പ്രവർത്തനങ്ങൾ';

  @override
  String get confirmBooking => 'ബുക്കിംഗ് സ്ഥിരീകരിക്കൂ';

  @override
  String get markComplete => 'പൂർണ്ണമായി അടയാളപ്പെടുത്തൂ';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer ന്റെ $date ന് $time ന് ഉള്ള അപ്പോയിന്റ്‌മെന്റ് സ്ഥിരീകരിക്കണോ?';
  }

  @override
  String get bookingUpdated => 'ബുക്കിംഗ് വിജയകരമായി അപ്‌ഡേറ്റ് ചെയ്തു';

  @override
  String get bookingUpdateFailed => 'ബുക്കിംഗ് അപ്‌ഡേറ്റ് ചെയ്യൽ പരാജയം';

  @override
  String markAttendanceFor(String date) {
    return 'ഹാജർ അടയാളപ്പെടുത്തൂ — $date';
  }

  @override
  String get allCustomers => 'എല്ലാ ഉപഭോക്താക്കളും';

  @override
  String get noCustomersYet => 'ഇനിയും ഉപഭോക്താക്കൾ ഇല്ല';

  @override
  String get noCustomersYetSubtitle => 'ആരംഭിക്കാൻ ആദ്യ ഉപഭോക്താവിനെ ചേർക്കൂ';

  @override
  String get invalidPhone => '6–9 ൽ തുടങ്ങുന്ന 10 അക്ക മൊബൈൽ നമ്പർ നൽകൂ';

  @override
  String accrueMonthSalary(String amount) {
    return 'മാസ ശമ്പളം ചേർക്കൂ (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'മാസ ശമ്പളം ചേർക്കൂ';

  @override
  String get removeStaffTitle => 'Remove Staff Member';

  @override
  String removeStaffConfirm(String name) {
    return 'Remove $name from your staff? This will revoke their app access immediately.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name ന്റെ കുടിശ്ശികയിൽ ഈ മാസം ₹$amount ചേർക്കണോ?';
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
