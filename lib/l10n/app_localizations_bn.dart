// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'সাথখাতা';

  @override
  String get tagline => 'এক খাতা, দুজনের';

  @override
  String get onboarding1Title => 'দুই পক্ষের ভাগ করা খাতা';

  @override
  String get onboarding1Subtitle =>
      'বিক্রেতা ও ক্রেতা উভয়ের জন্য একটি খাতা। দুজনেই একই সত্য দেখেন।';

  @override
  String get onboarding2Title => 'ভয়েস ও বিল OCR';

  @override
  String get onboarding2Subtitle =>
      '১২টি ভাষায় তাৎক্ষণিক এন্ট্রি করতে বলুন বা বিল স্ক্যান করুন।';

  @override
  String get onboarding3Title => 'এক ট্যাপে UPI পেমেন্ট';

  @override
  String get onboarding3Subtitle =>
      'UPI দিয়ে এক ট্যাপেই মাসের বকেয়া মিটিয়ে দিন।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get next => 'পরবর্তী';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get chooseLanguage => 'আপনার ভাষা বেছে নিন';

  @override
  String get continueButton => 'চালিয়ে যান';

  @override
  String get chooseRole => 'আপনার ভূমিকা বেছে নিন';

  @override
  String get vendor => 'বিক্রেতা';

  @override
  String get customer => 'ক্রেতা';

  @override
  String get welcomeToSaathKhata => 'সাথখাতায় স্বাগতম';

  @override
  String get tellUsHowYouUse => 'বলুন আপনি অ্যাপটি কীভাবে ব্যবহার করবেন';

  @override
  String get vendorRoleTitle => 'আমি একজন বিক্রেতা';

  @override
  String get vendorRoleSubtitle =>
      'ব্যবসার খাতা, কর্মী পরিচালনা করুন এবং পেমেন্ট নিন।';

  @override
  String get customerRoleTitle => 'আমি একজন ক্রেতা';

  @override
  String get customerRoleSubtitle =>
      'বিক্রেতাদের সাথে খাতা ট্র্যাক করুন এবং UPI দিয়ে পেমেন্ট করুন।';

  @override
  String get loginTitle => 'সাথখাতায় লগইন করুন';

  @override
  String get enterMobile => 'চালিয়ে যেতে তথ্য দিন';

  @override
  String get mobileNumber => 'মোবাইল নম্বর';

  @override
  String get sendOtp => 'OTP পাঠান';

  @override
  String get verifyOtp => 'OTP যাচাই করুন';

  @override
  String get verifyAndContinue => 'যাচাই করে চালিয়ে যান';

  @override
  String get changePhoneNumber => 'ফোন নম্বর পরিবর্তন করুন';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumber নম্বরে পাঠানো ৬ সংখ্যার কোড দিন';
  }

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get passwordHint => 'পাসওয়ার্ড দিন';

  @override
  String get loginButton => 'লগইন';

  @override
  String get noAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get signUp => 'নিবন্ধন করুন';

  @override
  String get pleaseEnterCredentials => 'ইমেইল ও পাসওয়ার্ড দিন';

  @override
  String get fillRequiredFields => 'নাম, ইমেইল ও পাসওয়ার্ড পূরণ করুন';

  @override
  String get passwordMinChars => 'কমপক্ষে ৮ অক্ষর';

  @override
  String get completeProfile => 'প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get enterYourName => 'আপনার নাম দিন';

  @override
  String get egBusinessName => 'যেমন: কৃষ্ণ ডেইরি';

  @override
  String get selectCategory => 'বিভাগ বেছে নিন';

  @override
  String get enterAddress => 'এলাকা বা পূর্ণ ঠিকানা দিন';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get businessName => 'ব্যবসার নাম';

  @override
  String get businessCategory => 'ব্যবসার বিভাগ';

  @override
  String get businessAddress => 'ব্যবসার ঠিকানা (ঐচ্ছিক)';

  @override
  String get upiId => 'UPI আইডি (পেমেন্টের জন্য)';

  @override
  String get vendorDashboard => 'বিক্রেতা ড্যাশবোর্ড';

  @override
  String get customerDashboard => 'ক্রেতা ড্যাশবোর্ড';

  @override
  String get customerMode => 'ক্রেতা মোড';

  @override
  String get myVendors => 'আমার বিক্রেতা';

  @override
  String get outstanding => 'বকেয়া';

  @override
  String get collectedToday => 'আজকের সংগ্রহ';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get scanBill => 'বিল স্ক্যান করুন';

  @override
  String get remindAll => 'সবাইকে মনে করিয়ে দিন';

  @override
  String get addNew => 'নতুন যোগ করুন';

  @override
  String get recentCustomers => 'সাম্প্রতিক ক্রেতা';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String customerAddedSnackbar(String name) {
    return '$name যোগ হয়েছে';
  }

  @override
  String get sharedLedger => 'ভাগ করা খাতা';

  @override
  String get totalBalance => 'মোট ব্যালেন্স';

  @override
  String get statement => 'বিবৃতি';

  @override
  String get giveCredit => 'বাকি দিন';

  @override
  String get recordPayment => 'পেমেন্ট রেকর্ড করুন';

  @override
  String get giveCreditSheet => 'বাকি দিন';

  @override
  String get recordPaymentSheet => 'পেমেন্ট রেকর্ড করুন';

  @override
  String get filterAll => 'সব';

  @override
  String get balanceCustomerOwes => 'ক্রেতার বকেয়া';

  @override
  String get balanceYouOwe => 'আপনার বকেয়া';

  @override
  String get balanceSettled => 'নিষ্পত্তি হয়েছে';

  @override
  String get balanceYouOweVendor => 'বিক্রেতার বকেয়া আপনার';

  @override
  String get balanceVendorOwesYou => 'বিক্রেতার কাছে আপনার পাওনা';

  @override
  String get ledgerInfoTitle => 'এই খাতা কীভাবে কাজ করে';

  @override
  String get statusConfirmed => 'নিশ্চিত';

  @override
  String get statusConfirmedDesc =>
      'উভয় পক্ষ সম্মত। এন্ট্রি লক এবং পরিবর্তন করা যাবে না।';

  @override
  String get statusPending => 'অপেক্ষমান';

  @override
  String get statusPendingDesc =>
      'ক্রেতার নিশ্চিতের অপেক্ষা। ৭২ ঘণ্টায় স্বয়ংক্রিয় নিশ্চিত।';

  @override
  String get statusDisputed => 'বিতর্কিত';

  @override
  String get statusDisputedDesc =>
      'ক্রেতা আপত্তি জানিয়েছে। বিক্রেতার পর্যালোচনা প্রয়োজন।';

  @override
  String get statusAutoConfirmed => 'স্বয়ংক্রিয় নিশ্চিত';

  @override
  String get entryTypeCreditLabel => 'বাকি এন্ট্রি';

  @override
  String get entryTypePaymentLabel => 'পেমেন্ট প্রাপ্ত';

  @override
  String get entryDetails => 'এন্ট্রির বিবরণ';

  @override
  String get entryAmount => 'পরিমাণ';

  @override
  String get entryType => 'ধরন';

  @override
  String get entryTypeCreditGiven => 'বাকি (দেওয়া)';

  @override
  String get entryTypePaymentReceived => 'পেমেন্ট (প্রাপ্ত)';

  @override
  String get entryDate => 'তারিখ';

  @override
  String get entryDescription => 'বিবরণ';

  @override
  String get entryQuantity => 'পরিমাণ';

  @override
  String get entryConfirmedAt => 'নিশ্চিতের তারিখ';

  @override
  String get entryDisputeReason => 'আপত্তির কারণ';

  @override
  String entryFor(String name) {
    return '$name-এর জন্য';
  }

  @override
  String get description => 'বিবরণ';

  @override
  String get descriptionOptional => 'বিবরণ (ঐচ্ছিক)';

  @override
  String get quantityOptional => 'পরিমাণ (ঐচ্ছিক)';

  @override
  String get descriptionHint => 'যেমন: ২L দুধ, মাসিক মুদিখানা';

  @override
  String get quantityHint => 'যেমন: ২';

  @override
  String get addCreditEntry => 'বাকি এন্ট্রি যোগ করুন';

  @override
  String get noLedgerTransactions => 'এখনও কোনো লেনদেন নেই';

  @override
  String get noLedgerTransactionsSubtitle =>
      'শুরু করতে বাকি বা পেমেন্ট এন্ট্রি যোগ করুন।';

  @override
  String get confirmEntryTitle => 'এন্ট্রি নিশ্চিত করুন';

  @override
  String confirmEntryMessage(String amount) {
    return 'আপনি কি ₹$amount-এর এন্ট্রি নিশ্চিত করতে চান? এটি পূর্বাবস্থায় ফেরানো যাবে না।';
  }

  @override
  String get dispute => 'আপত্তি';

  @override
  String get raiseDisputeTitle => 'আপত্তি জানান';

  @override
  String get raiseDisputeSubtitle => 'এই এন্ট্রিতে কী ভুল তা বলুন।';

  @override
  String get raiseDisputeHint => 'যেমন: পরিমাণ ₹৫০ হওয়া উচিত, ₹৬০ নয়';

  @override
  String get submitDispute => 'আপত্তি জমা দিন';

  @override
  String get staffAndLabour => 'কর্মী ও শ্রমিক';

  @override
  String get addStaff => 'কর্মী যোগ করুন';

  @override
  String get presentToday => 'আজ উপস্থিত';

  @override
  String get unpaidSalary => 'অপরিশোধিত বেতন';

  @override
  String get paySalary => 'বেতন দিন';

  @override
  String get noStaffAdded => 'এখনও কোনো কর্মী নেই';

  @override
  String get noStaffAddedSubtitle => 'প্রথম কর্মী যোগ করতে নিচের বোতামে চাপুন।';

  @override
  String get present => 'উপস্থিত';

  @override
  String get absent => 'অনুপস্থিত';

  @override
  String get halfDay => 'অর্ধদিন';

  @override
  String get paySalaryTitle => 'বেতন দিন';

  @override
  String unpaidLabel(String amount) {
    return 'অপরিশোধিত: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI লেনদেন আইডি (ঐচ্ছিক)';

  @override
  String get noDues => 'কোনো বকেয়া নেই';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount দিন';
  }

  @override
  String staffJoined(String date) {
    return '$date-এ যোগ দিয়েছে';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/দিন';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/মাস';
  }

  @override
  String get staffPayButton => 'পেমেন্ট';

  @override
  String get businessReports => 'ব্যবসার রিপোর্ট';

  @override
  String get revenueTrend => 'আয়ের ধারা';

  @override
  String get collectionSummary => 'সংগ্রহের সারাংশ';

  @override
  String get totalOutstanding => 'মোট বকেয়া';

  @override
  String get totalCollected => 'মোট সংগ্রহ';

  @override
  String get topCustomers => 'শীর্ষ ক্রেতা';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get appLanguage => 'অ্যাপের ভাষা';

  @override
  String get selectLanguage => 'ভাষা বেছে নিন';

  @override
  String get settingsManagePayments => 'পেমেন্ট অ্যাকাউন্ট পরিচালনা করুন';

  @override
  String get settingsManageAlerts => 'অ্যালার্ট ও রিমাইন্ডার পরিচালনা করুন';

  @override
  String get settingsAppPinFingerprint => 'অ্যাপ পিন ও ফিঙ্গারপ্রিন্ট';

  @override
  String get settingsFaqsContact => 'সহায়তা ও যোগাযোগ';

  @override
  String settingsVersion(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get myUpiIds => 'আমার UPI আইডি';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get helpSupport => 'সহায়তা';

  @override
  String get logout => 'লগআউট';

  @override
  String get markAllRead => 'সব পড়া হয়েছে চিহ্নিত করুন';

  @override
  String get noNotificationsTitle => 'এখনও কোনো বিজ্ঞপ্তি নেই';

  @override
  String get noNotificationsSubtitle =>
      'এখানে খাতা আপডেট, পেমেন্ট অ্যালার্ট ও রিমাইন্ডার দেখাবে।';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String minutesAgo(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgo(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String get payments => 'পেমেন্ট';

  @override
  String get transactionHistory => 'লেনদেনের ইতিহাস';

  @override
  String get totalPaid => 'মোট পরিশোধ';

  @override
  String get pending => 'অপেক্ষমান';

  @override
  String get quickPay => 'দ্রুত পেমেন্ট';

  @override
  String get scanAndPay => 'স্ক্যান করে পেমেন্ট করুন';

  @override
  String get scanUpiDesc => 'বিক্রেতাকে পেমেন্ট করতে UPI QR স্ক্যান করুন';

  @override
  String get noTransactionsTitle => 'এখনও কোনো লেনদেন নেই';

  @override
  String get noTransactionsSubtitle => 'আপনার পেমেন্টের ইতিহাস এখানে দেখাবে।';

  @override
  String get paymentStatusPaid => 'পরিশোধ হয়েছে';

  @override
  String get paymentStatusFailed => 'ব্যর্থ';

  @override
  String get paymentStatusRefunded => 'ফেরত';

  @override
  String get appointments => 'অ্যাপয়েন্টমেন্ট';

  @override
  String get myAppointments => 'আমার অ্যাপয়েন্টমেন্ট';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String get past => 'আগের';

  @override
  String get cancelBooking => 'বুকিং বাতিল করুন';

  @override
  String get keepBooking => 'রাখুন';

  @override
  String get noBookingsToday => 'আজ কোনো বুকিং নেই';

  @override
  String get noBookingsTodaySubtitle =>
      'ক্রেতারা অ্যাপ থেকে অ্যাপয়েন্টমেন্ট বুক করতে পারবেন।';

  @override
  String get noAppointmentsTitle => 'এখনও কোনো অ্যাপয়েন্টমেন্ট নেই';

  @override
  String get noAppointmentsSubtitle =>
      'শুরু করতে আপনার বিক্রেতার সাথে অ্যাপয়েন্টমেন্ট বুক করুন।';

  @override
  String get cancelAppointmentTitle => 'অ্যাপয়েন্টমেন্ট বাতিল করবেন?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$date তারিখে $time-এর অ্যাপয়েন্টমেন্ট বাতিল করবেন?';
  }

  @override
  String get bookingStatusConfirmed => 'নিশ্চিত';

  @override
  String get bookingStatusPending => 'অপেক্ষমান';

  @override
  String get bookingStatusCancelled => 'বাতিল';

  @override
  String get bookingStatusCompleted => 'সম্পন্ন';

  @override
  String get bookingStatusDone => 'সম্পন্ন';

  @override
  String get upiPayment => 'UPI পেমেন্ট';

  @override
  String get amountToPay => 'পেমেন্টের পরিমাণ';

  @override
  String get securedByUpi => 'UPI দ্বারা সুরক্ষিত';

  @override
  String get paymentSuccessful => 'পেমেন্ট সফল!';

  @override
  String get paymentFailed => 'পেমেন্ট ব্যর্থ';

  @override
  String get retryPayment => 'আবার চেষ্টা করুন';

  @override
  String get enterUpiId => 'UPI আইডি দিন';

  @override
  String get addNoteOptional => 'নোট যোগ করুন (ঐচ্ছিক)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount পেমেন্ট করুন';
  }

  @override
  String get done => 'সম্পন্ন';

  @override
  String get paymentSomethingWentWrong => 'কিছু ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String upiAppComingSoon(String app) {
    return '$app শীঘ্রই আসছে';
  }

  @override
  String get pleaseEnterUpiId => 'UPI আইডি দিন';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $name-কে পরিশোধ হয়েছে';
  }

  @override
  String get orDivider => 'অথবা';

  @override
  String get addNewCustomer => 'নতুন ক্রেতা যোগ করুন';

  @override
  String get customerName => 'ক্রেতার নাম';

  @override
  String get mobileNo => 'মোবাইল নম্বর';

  @override
  String get addCustomer => 'ক্রেতা যোগ করুন';

  @override
  String get paymentConfirmed => 'পেমেন্ট নিশ্চিত করুন';

  @override
  String get addAdvance => 'অগ্রিম যোগ করুন';

  @override
  String get addAdvanceTitle => 'অগ্রিম যোগ করুন';

  @override
  String get attendanceTitle => 'উপস্থিতি';

  @override
  String get salaryTitle => 'বেতনের সারাংশ';

  @override
  String get rate => 'হার';

  @override
  String get daysPresent => 'উপস্থিত দিন';

  @override
  String get earned => 'উপার্জিত';

  @override
  String get unpaid => 'অপরিশোধিত';

  @override
  String get advanceTaken => 'নেওয়া অগ্রিম';

  @override
  String get active => 'সক্রিয়';

  @override
  String get inactive => 'নিষ্ক্রিয়';

  @override
  String get joined => 'যোগ দিয়েছে';

  @override
  String get noPhone => 'ফোন নেই';

  @override
  String get addNewStaff => 'নতুন কর্মী যোগ করুন';

  @override
  String get fullNameLabel => 'পুরো নাম';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get role => 'ভূমিকা';

  @override
  String get salaryType => 'বেতনের ধরন';

  @override
  String get dailyWage => 'দৈনিক মজুরি';

  @override
  String get monthlySalary => 'মাসিক বেতন';

  @override
  String get dailyWageAmount => 'দৈনিক মজুরি (₹)';

  @override
  String get monthlySalaryAmount => 'মাসিক বেতন (₹)';

  @override
  String get addStaffButton => 'কর্মী যোগ করুন';

  @override
  String get noteOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get amountRupees => 'পরিমাণ (₹)';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get alignBillInFrame => 'বিল ফ্রেমে রাখুন';

  @override
  String get verifyAndLogin => 'যাচাই করে লগইন করুন';

  @override
  String get voiceListening => 'শুনছি...';

  @override
  String get voiceThinking => 'ভাবছি...';

  @override
  String get voiceDetectedEntry => 'শনাক্ত করা এন্ট্রি';

  @override
  String get voiceConfirmEntry => 'এন্ট্রি নিশ্চিত করুন';

  @override
  String get item => 'আইটেম';

  @override
  String get totalOutstandingBalance => 'মোট বকেয়া পরিমাণ';

  @override
  String get payAllDues => 'সব বকেয়া পরিশোধ করুন';

  @override
  String get myKhatas => 'আমার খাতা';

  @override
  String get noVendorsFound => 'কোনো বিক্রেতা পাওয়া যায়নি';

  @override
  String get verifyBillDetails => 'বিলের বিবরণ যাচাই করুন';

  @override
  String get scannedBillPreview => 'স্ক্যান করা বিল';

  @override
  String get descriptionItemDetails => 'বিবরণ / পণ্যের তথ্য';

  @override
  String get selectCustomer => 'ক্রেতা বেছে নিন';

  @override
  String get searchCustomerHint => 'ক্রেতা খুঁজুন বা বেছে নিন';

  @override
  String get saveToKhata => 'খাতায় সেভ করুন';

  @override
  String get allCustomersReport => 'সব ক্রেতার রিপোর্ট';

  @override
  String collectedInMonth(String month) {
    return '$month-এ সংগ্রহ';
  }

  @override
  String get notificationSettings => 'বিজ্ঞপ্তি সেটিংস';

  @override
  String get securityPin => 'নিরাপত্তা ও পিন';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get termsAndConditions => 'শর্তাবলী';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get accountSettings => 'অ্যাকাউন্ট সেটিংস';

  @override
  String get legalInfo => 'আইনি';

  @override
  String get currentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get newPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get confirmNewPassword => 'নতুন পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মেলে না';

  @override
  String get changePasswordButton => 'পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get passwordChangedSuccess => 'পাসওয়ার্ড সফলভাবে পরিবর্তিত হয়েছে';

  @override
  String get loadingContent => 'লোড হচ্ছে...';

  @override
  String get failedToLoad => 'সামগ্রী লোড করতে ব্যর্থ। আবার চেষ্টা করুন।';

  @override
  String get bookingActions => 'বুকিং কার্যক্রম';

  @override
  String get confirmBooking => 'বুকিং নিশ্চিত করুন';

  @override
  String get markComplete => 'সম্পন্ন চিহ্নিত করুন';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customer-এর $date তারিখে $time-এর অ্যাপয়েন্টমেন্ট নিশ্চিত করবেন?';
  }

  @override
  String get bookingUpdated => 'বুকিং সফলভাবে আপডেট হয়েছে';

  @override
  String get bookingUpdateFailed => 'বুকিং আপডেট করতে ব্যর্থ';

  @override
  String markAttendanceFor(String date) {
    return 'উপস্থিতি চিহ্নিত করুন — $date';
  }

  @override
  String get allCustomers => 'সব ক্রেতা';

  @override
  String get noCustomersYet => 'এখনও কোনো ক্রেতা নেই';

  @override
  String get noCustomersYetSubtitle => 'শুরু করতে প্রথম ক্রেতা যোগ করুন';

  @override
  String get invalidPhone => '৬–৯ দিয়ে শুরু ১০ সংখ্যার বৈধ মোবাইল নম্বর দিন';

  @override
  String accrueMonthSalary(String amount) {
    return 'মাসের বেতন যোগ করুন (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'মাসের বেতন যোগ করুন';

  @override
  String get removeStaffTitle => 'কর্মী সরান';

  @override
  String removeStaffConfirm(String name) {
    return '$name-কে আপনার কর্মী থেকে সরাবেন? তাদের অ্যাপ অ্যাক্সেস তাৎক্ষণিক বাতিল হবে।';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$name-এর বকেয়ায় এই মাসে ₹$amount যোগ করবেন?';
  }

  @override
  String get accountInformation => 'অ্যাকাউন্ট তথ্য';

  @override
  String get updateProfileDetails => 'আপনার নাম, ছবি ও তথ্য আপডেট করুন';

  @override
  String get updateAccountPassword => 'আপনার অ্যাকাউন্ট পাসওয়ার্ড আপডেট করুন';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountSubtitle => 'অ্যাকাউন্ট ও সব ডেটা স্থায়ীভাবে মুছুন';

  @override
  String get deleteAccountConfirmation => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteAccountConfirmationMessage =>
      'এটি আপনার অ্যাকাউন্ট ও সব ডেটা স্থায়ীভাবে মুছে ফেলবে। এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get deleteAccountStaffWarning =>
      'এটি আপনার অ্যাকাউন্ট স্থায়ীভাবে মুছে ফেলবে। এটি পূর্বাবস্থায় ফেরানো যাবে না।';

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
  String get deleteForever => 'চিরতরে মুছুন';

  @override
  String get delete => 'মুছুন';

  @override
  String get readTermsOfService => 'আমাদের সেবার শর্তাবলী পড়ুন';

  @override
  String get privacyPolicyDescription => 'আমরা আপনার ডেটা কীভাবে পরিচালনা করি';

  @override
  String get confirmLogout => 'আপনি কি সত্যিই লগআউট করতে চান?';

  @override
  String get membershipTiers => 'সদস্যপদ স্তর';

  @override
  String get membershipTiersDescription =>
      'স্তরের নাম পরিবর্তন করুন ও সদস্য ছাড় সেট করুন';

  @override
  String get logIn => 'লগইন করুন';

  @override
  String get enterPhoneNumberToContinue => 'চালিয়ে যেতে ফোন নম্বর দিন';

  @override
  String get havingTrouble => 'সমস্যা হচ্ছে?';

  @override
  String get useEmailInstead => 'ইমেইল দিয়ে লগইন করুন →';

  @override
  String get logInWithEmail => 'ইমেইল দিয়ে লগইন করুন';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get enterYourPassword => 'পাসওয়ার্ড দিন';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get removePhoto => 'ছবি সরান';

  @override
  String get tapToAddProfilePhoto => 'প্রোফাইল ছবি যোগ করতে ট্যাপ করুন';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get add => 'যোগ করুন';

  @override
  String get addUpiId => 'UPI আইডি যোগ করুন';

  @override
  String get save => 'সেভ করুন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get remove => 'সরান';

  @override
  String get approve => 'অনুমোদন করুন';

  @override
  String get decline => 'প্রত্যাখ্যান করুন';

  @override
  String get none => 'কিছু না';

  @override
  String get percent => 'শতাংশ';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get paymentVerification => 'পেমেন্ট যাচাই';

  @override
  String get verifyingPayment => 'পেমেন্ট যাচাই হচ্ছে';

  @override
  String get paymentConfirmedExclamation => 'পেমেন্ট নিশ্চিত!';

  @override
  String get verificationTimedOut => 'যাচাইয়ের সময় শেষ';

  @override
  String get goBack => 'ফিরে যান';

  @override
  String get payDues => 'বকেয়া পরিশোধ করুন';

  @override
  String get skipForNow => 'এখনের মতো এড়িয়ে যান';

  @override
  String get allDone => 'সব হয়েছে!';

  @override
  String get noUpcomingAppointments => 'কোনো আসন্ন অ্যাপয়েন্টমেন্ট নেই';

  @override
  String get myPay => 'আমার বেতন';

  @override
  String get myPaymentQr => 'আমার পেমেন্ট QR';

  @override
  String get showMyQr => 'আমার QR দেখান';

  @override
  String get noPaymentsYet => 'এখনও কোনো পেমেন্ট নেই';

  @override
  String get paymentHistory => 'পেমেন্টের ইতিহাস';

  @override
  String get paymentHistory6Months => 'পেমেন্টের ইতিহাস (৬ মাস)';

  @override
  String get connectionRequest => 'সংযোগ অনুরোধ';

  @override
  String get vendorWantsToConnect => 'একজন বিক্রেতা সংযুক্ত হতে চান';

  @override
  String get acceptRequest => 'গ্রহণ করুন';

  @override
  String get declineRequest => 'প্রত্যাখ্যান করুন';

  @override
  String get messageLabel => 'বার্তা';

  @override
  String get sendRequest => 'অনুরোধ পাঠান';

  @override
  String get requestSentNotification =>
      'অনুরোধ পাঠানো হয়েছে! তাদের নিশ্চিত করতে জানানো হবে।';

  @override
  String get awaitingAcceptance => 'গ্রহণের অপেক্ষায়';

  @override
  String get addAVendor => 'বিক্রেতা যোগ করুন';

  @override
  String get findByPhoneOrEmail => 'ফোন নম্বর বা ইমেইলে খুঁজুন';

  @override
  String get phoneOrEmail => 'ফোন বা ইমেইল';

  @override
  String get phoneOrEmailHint => '১০ সংখ্যার মোবাইল বা ইমেইল ঠিকানা';

  @override
  String get nicknameOptional => 'ডাকনাম (ঐচ্ছিক)';

  @override
  String get howYouKnowVendor => 'আপনি এই বিক্রেতাকে কীভাবে চেনেন';

  @override
  String get bookingNoteExample => 'যেমন: আজ অতিরিক্ত দুধ দরকার';

  @override
  String get confirmLocation => 'অবস্থান নিশ্চিত করুন';

  @override
  String get moveMapToSelectLocation => 'অবস্থান বেছে নিতে মানচিত্র সরান';

  @override
  String get searchPlaceHint => 'একটি স্থান খুঁজুন…';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get searchVendorsHint => 'বিক্রেতা খুঁজুন…';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get payViaUpi => 'UPI দিয়ে পেমেন্ট';

  @override
  String get connectWithVendor => 'সংযুক্ত হন';

  @override
  String get requestConnection => 'সংযোগ অনুরোধ';

  @override
  String get addVendor => 'বিক্রেতা যোগ করুন';

  @override
  String get noOutstandingBalances => 'কোনো বকেয়া শেষ নেই';

  @override
  String get allCustomersSettledUp => 'সব ক্রেতার হিসাব মিটে গেছে।';

  @override
  String get nothingCollectedToday => 'আজ কিছু সংগ্রহ হয়নি';

  @override
  String get paymentsWillAppearHere => 'আজকের প্রাপ্ত পেমেন্ট এখানে দেখাবে।';

  @override
  String get customerReport => 'ক্রেতার রিপোর্ট';

  @override
  String get overview => 'সারসংক্ষেপ';

  @override
  String get tapToStop => 'থামাতে ট্যাপ করুন';

  @override
  String get itemName => 'পণ্যের নাম';

  @override
  String get itemNameExample => 'যেমন: দুধ';

  @override
  String get unitPrice => 'প্রতি ইউনিট মূল্য ₹';

  @override
  String get deliverTo => 'ডেলিভারি করুন';

  @override
  String get bulkCharge => 'বাল্ক চার্জ';

  @override
  String get newProduct => 'নতুন পণ্য';

  @override
  String get editProduct => 'পণ্য সম্পাদনা করুন';

  @override
  String get newProductService => 'নতুন পণ্য / সেবা';

  @override
  String get updateProductDetails => 'নাম, ইউনিট বা মূল্য আপডেট করুন';

  @override
  String get defineProduct => 'আপনি কী বিক্রি করেন ও মূল্য নির্ধারণ করুন';

  @override
  String get productName => 'পণ্যের নাম';

  @override
  String get productNameExample => 'যেমন: সকালের দুধ';

  @override
  String get unit => 'ইউনিট';

  @override
  String get unitExample => 'লিটার / কেজি / পিস';

  @override
  String get pricePerUnit => 'প্রতি ইউনিট মূল্য (₹)';

  @override
  String get deleteProduct => 'পণ্য মুছুন';

  @override
  String get deleteProductConfirmation => 'পণ্য মুছবেন?';

  @override
  String removeProductConfirmation(String name) {
    return 'Remove \"$name\" from your product list?';
  }

  @override
  String get noProductsYet => 'এখনও কোনো পণ্য নেই';

  @override
  String get addFirstProduct => 'প্রথম পণ্য যোগ করুন';

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
  String get renameTier => 'স্তরের নাম পরিবর্তন করুন';

  @override
  String get tierName => 'স্তরের নাম';

  @override
  String tierLevel(int level) {
    return 'Level $level';
  }

  @override
  String get memberDiscount => 'সদস্য ছাড়';

  @override
  String discountFor(String tier) {
    return 'Discount for $tier';
  }

  @override
  String get flatAmount => 'ফ্ল্যাট ₹';

  @override
  String get discountPercent => 'ছাড় %';

  @override
  String get discountAmount => 'ছাড়ের পরিমাণ (₹)';

  @override
  String get percentExample => 'যেমন: ৫';

  @override
  String get amountExample => 'যেমন: ৫০';

  @override
  String get maxDiscountPerDue => 'প্রতি বকেয়ায় সর্বোচ্চ ছাড় (₹) — ঐচ্ছিক';

  @override
  String get maxDiscountExample => 'যেমন: ১০০ (সীমা না থাকলে খালি রাখুন)';

  @override
  String get saveDiscount => 'ছাড় সেভ করুন';

  @override
  String get membership => 'সদস্যপদ';

  @override
  String get setTier => 'সেট করুন';

  @override
  String get changeTier => 'পরিবর্তন করুন';

  @override
  String get applyMembership => 'প্রয়োগ করুন';

  @override
  String get removeMembership => 'সদস্যপদ সরান';

  @override
  String get removeLedgerConfirmation => 'খাতা সরাবেন?';

  @override
  String get exportStatement => 'স্টেটমেন্ট এক্সপোর্ট করুন';

  @override
  String get appAccess => 'অ্যাপ অ্যাক্সেস';

  @override
  String get invalidPhoneNumber => 'বৈধ ১০ সংখ্যার ভারতীয় মোবাইল নম্বর দিন';

  @override
  String get enterAll6Digits => '৬টি সংখ্যাই দিন';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress => 'বৈধ ইমেইল ঠিকানা দিন';

  @override
  String get passwordRequired => 'পাসওয়ার্ড দিন';

  @override
  String get nameRequired => 'নাম আবশ্যক';

  @override
  String get required => 'আবশ্যক';

  @override
  String get invalidUpiFormat => 'UPI আইডি ফরম্যাট ভুল (যেমন: name@upi)';

  @override
  String get upiIdAlreadyAdded => 'এই UPI আইডি আগেই যোগ করা আছে';

  @override
  String get verifyButton => 'যাচাই করুন';

  @override
  String get createAccountButton => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'পাসওয়ার্ড দিন';

  @override
  String get mobileNumberLabel => 'মোবাইল নম্বর';

  @override
  String get personalInfo => 'ব্যক্তিগত তথ্য';

  @override
  String get businessInfo => 'ব্যবসার তথ্য';

  @override
  String get enterOtpTitle => 'OTP দিন';

  @override
  String get sentToLabel => 'পাঠানো হয়েছে';

  @override
  String get noOtpReceived => 'OTP পাননি?';

  @override
  String get resendOtp => 'OTP পুনরায় পাঠান';

  @override
  String get uploadingPhotoLabel => 'ছবি আপলোড হচ্ছে...';

  @override
  String get phoneNumberLabel => 'ফোন নম্বর';

  @override
  String get iAmA => 'আমি একজন';

  @override
  String get dualRoleExplanation =>
      'আপনি মূলত বিক্রেতা হিসেবে ব্যবহার করবেন। ক্রেতা অ্যাকাউন্ট আলাদাভাবে অ্যাক্সেস করা যাবে।';

  @override
  String get profileSavedPhotoFailed =>
      'প্রোফাইল সেভ হয়েছে — ছবি এখন আপলোড করা যায়নি';

  @override
  String get profileUpdatedSuccess => 'প্রোফাইল সফলভাবে আপডেট হয়েছে';

  @override
  String get addUpiIdTitle => 'UPI আইডি যোগ করুন';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'বাতিল';

  @override
  String get primaryUpiInfo => 'প্রাথমিক UPI আইডি';

  @override
  String get primaryUpiDescription =>
      'প্রাথমিক আইডি ক্রেতাদের সাথে পেমেন্টের জন্য শেয়ার হয়। কোনটি প্রাথমিক হবে তা বদলাতে তারকায় ট্যাপ করুন।';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI আইডি';
  }

  @override
  String get primaryUpiIdTooltip => 'প্রাথমিক UPI আইডি';

  @override
  String get setAsPrimaryTooltip => 'প্রাথমিক হিসেবে সেট করুন';

  @override
  String get primaryLabel => 'প্রাথমিক';

  @override
  String get removeButtonLabel => 'সরান';

  @override
  String get noUpiIdsEmpty => 'এখনও কোনো UPI আইডি নেই';

  @override
  String get upiEmptyDescription =>
      'সর্বোচ্চ ৫টি UPI আইডি যোগ করুন। প্রাথমিক আইডি ক্রেতাদের পেমেন্টের জন্য শেয়ার হবে।';

  @override
  String get changePasswordSubtitle =>
      'বর্তমান পাসওয়ার্ড দিন এবং নতুন পাসওয়ার্ড বেছে নিন।';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get goBackButton => 'ফিরে যান';

  @override
  String get saveButton => 'সেভ করুন';

  @override
  String get language => 'ভাষা';

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
      'এটি ব্যবহার করতে আপনার অ্যাকাউন্টে পাসওয়ার্ড সেট করতে হবে।\nসেটিংস → পাসওয়ার্ড পরিবর্তন থেকে সেট করুন।';

  @override
  String get usePhoneInstead => 'বরং ফোন নম্বর ব্যবহার করুন →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'সেশন শেষ হয়েছে। আবার ফোন যাচাই করুন।';

  @override
  String get upiIdsSavedSuccessfully => 'UPI আইডি সফলভাবে সেভ হয়েছে';

  @override
  String get chooseYourLanguageHindi => 'আপনার ভাষা বেছে নিন';

  @override
  String get unknownLanguage => 'অজানা';

  @override
  String get businessCategoryMilkDairy => 'দুধ / ডেইরি';

  @override
  String get businessCategoryPressDhobi => 'প্রেস / ধোবি';

  @override
  String get businessCategoryMaidCook => 'কাজের বুয়া / রাঁধুনি';

  @override
  String get businessCategoryNewspaper => 'সংবাদপত্র';

  @override
  String get businessCategoryWaterCan => 'পানির ক্যান';

  @override
  String get businessCategoryTiffinFood => 'টিফিন / খাবার';

  @override
  String get businessCategoryKiranaGrocery => 'কিরানা / মুদিখানা';

  @override
  String get businessCategorySalonParlour => 'সেলুন / পার্লার';

  @override
  String get businessCategoryConstructionLabour => 'নির্মাণ শ্রমিক';

  @override
  String get businessCategoryTransportAuto => 'পরিবহন / অটো';

  @override
  String get businessCategoryOther => 'অন্যান্য';

  @override
  String get bookAnAppointment => 'অ্যাপয়েন্টমেন্ট বুক করুন';

  @override
  String get noSlotsAvailable => 'কোনো স্লট নেই';

  @override
  String get trySelectingDifferentDate => 'অন্য তারিখ বেছে নিন';

  @override
  String get availableSlots => 'উপলব্ধ স্লট';

  @override
  String get bookingConfirmedToast => 'বুকিং নিশ্চিত!';

  @override
  String get date => 'তারিখ';

  @override
  String get time => 'সময়';

  @override
  String get notesOptional => 'নোট (ঐচ্ছিক)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get saveChanges => 'পরিবর্তন সেভ করুন';

  @override
  String get saveProduct => 'পণ্য সেভ করুন';

  @override
  String get editProductMenuItem => 'পণ্য সম্পাদনা';

  @override
  String get deleteProductMenuItem => 'পণ্য মুছুন';

  @override
  String get noProductsYetDescription =>
      'আপনি যা বিক্রি করেন — দুধ, পনির ইত্যাদি — একবার সংজ্ঞায়িত করুন, তারপর প্রতিদিন ব্যবহার করুন।';

  @override
  String get selectProductToAssignQty =>
      'পরিমাণ নির্ধারণ করতে উপরে পণ্য বেছে নিন';

  @override
  String get noCustomersLinked => 'এখনও কোনো ক্রেতা যুক্ত নেই';

  @override
  String get chargeAll => 'সবাইকে চার্জ করুন';

  @override
  String chargedSuccessfully(int count) {
    return '$count জন ক্রেতাকে সফলভাবে চার্জ করা হয়েছে';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return '$count জন ক্রেতাকে সফলভাবে চার্জ করা হয়েছে';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok জন চার্জ হয়েছে, $fail জন ব্যর্থ';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count জন ক্রেতা  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count জন ক্রেতা  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return 'মোট ₹$amount';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'পরবর্তী: $vendorName · $date তারিখে $time-এ';
  }

  @override
  String get outstandingShortLabel => 'বকেয়া';

  @override
  String payViaUpiAmount(String amount) {
    return 'UPI-তে ₹$amount পেমেন্ট করুন';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return '$count জন বিক্রেতাকে পেমেন্ট হয়েছে, $skipped জন বাদ।';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return '$count জন বিক্রেতাকে পেমেন্ট হয়েছে, $skipped জন বাদ।';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'সব $count জন বিক্রেতাকে পেমেন্ট হয়েছে।';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'সব $count জন বিক্রেতাকে পেমেন্ট হয়েছে।';
  }

  @override
  String get tapToAcceptOrDecline => 'গ্রহণ বা প্রত্যাখ্যান করতে ট্যাপ করুন';

  @override
  String get helpSupportContactPrefix =>
      'যেকোনো সাহায্যের জন্য আমাদের সাথে যোগাযোগ করুন:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'বুক করুন';

  @override
  String waitingForVendorAcceptance(String name) {
    return '$name-এর গ্রহণের অপেক্ষায় আছি।';
  }

  @override
  String get vendorWantsToConnectAsCustomer => 'একজন বিক্রেতা সংযুক্ত হতে চান';

  @override
  String get vendorWantsToConnectDesc =>
      'তারা আপনাকে ক্রেতা হিসেবে যোগ করে আপনার অ্যাকাউন্ট ট্র্যাক করতে চান।';

  @override
  String get someoneWantsToConnect => 'কেউ সংযুক্ত হতে চান';

  @override
  String get someoneWantsToConnectDesc =>
      'তারা আপনার অ্যাকাউন্টে ক্রেতা হিসেবে যোগ হবেন।';

  @override
  String requestedTimeAgo(String time) {
    return '$time আগে অনুরোধ করা হয়েছে';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'সংযুক্ত! $name এখন আপনার অ্যাকাউন্টের সাথে যুক্ত।';
  }

  @override
  String requestDeclinedFrom(String name) {
    return '$name-এর অনুরোধ প্রত্যাখ্যান করা হয়েছে।';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'সংযুক্ত! $name এখন আপনার ব্যবসার সাথে যুক্ত।';
  }

  @override
  String get processing => 'প্রক্রিয়া হচ্ছে…';

  @override
  String get retryButton => 'আবার চেষ্টা করুন';

  @override
  String get memberDiscountDescription =>
      'এই স্তরের সদস্যরা তাদের বকেয়ায় এই ছাড় পান।';

  @override
  String get discountValueInvalid => '০-এর বেশি বৈধ পরিমাণ দিন';

  @override
  String get percentageExceedsMax => 'শতাংশ ১০০-এর বেশি হতে পারবে না';

  @override
  String levelLabel(int level) {
    return 'স্তর $level';
  }

  @override
  String get rename => 'নাম পরিবর্তন করুন';

  @override
  String get membershipLabel => 'সদস্যপদ';

  @override
  String get noMembership => 'কোনো সদস্যপদ নেই';

  @override
  String get applyForMembership => 'সদস্যপদের আবেদন করুন';

  @override
  String get setMembershipTier => 'সদস্যপদ স্তর সেট করুন';

  @override
  String get chooseTierToRequestFromVendor =>
      'এই বিক্রেতার কাছে কোন স্তর চান তা বেছে নিন';

  @override
  String chooseTierFor(String customerName) {
    return '$customerName-এর জন্য স্তর বেছে নিন';
  }

  @override
  String get setButton => 'সেট করুন';

  @override
  String get changeButton => 'পরিবর্তন করুন';

  @override
  String get applyButton => 'আবেদন করুন';

  @override
  String get approveButton => 'অনুমোদন করুন';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName $tierName চেয়েছেন';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return '$tierName চাওয়া হয়েছে — অনুমোদনের অপেক্ষায়';
  }

  @override
  String get verificationConnecting => 'ব্যাংকের সাথে সংযুক্ত হচ্ছে…';

  @override
  String get verificationVerifying => 'লেনদেন যাচাই হচ্ছে…';

  @override
  String get verificationWaiting => 'নিশ্চিতের অপেক্ষায়…';

  @override
  String get verificationAlmostThere => 'প্রায় হয়ে গেছে…';

  @override
  String get verificationDoNotClose => 'এই স্ক্রিন বন্ধ করবেন না';

  @override
  String verificationElapsed(int seconds) {
    return '$secondsসেকেন্ড  •  এই স্ক্রিন বন্ধ করবেন না';
  }

  @override
  String txnLabel(String txnId) {
    return 'Txn: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '$name-কে ₹$amount পরিশোধ হয়েছে';
  }

  @override
  String get verificationTimeoutBody =>
      '৩০ সেকেন্ডের মধ্যে পেমেন্ট নিশ্চিত করা যায়নি। আপনার টাকা কাটা নাও হতে পারে — আবার চেষ্টা করার আগে ব্যাংক স্টেটমেন্ট দেখুন।';

  @override
  String get ifDebitedContactSupport =>
      'টাকা কাটা গেলে, Txn আইডি সহ সহায়তায় যোগাযোগ করুন।';

  @override
  String get thisMonthSubtitle => 'এই মাস';

  @override
  String get billedNet => 'বিল (নেট)';

  @override
  String get exclDisputed => 'বিতর্কিত বাদে';

  @override
  String get receivedLabel => 'প্রাপ্ত';

  @override
  String get paymentsAndAdj => 'পেমেন্ট ও সমন্বয়';

  @override
  String get currentBalance => 'বর্তমান ব্যালেন্স';

  @override
  String paymentCount(int count) {
    return '$countটি পেমেন্ট';
  }

  @override
  String paymentCountPlural(int count) {
    return '$countটি পেমেন্ট';
  }

  @override
  String customersCount(int count) {
    return '$count জন ক্রেতা';
  }

  @override
  String get rankedByOutstanding => 'বকেয়া অনুযায়ী ক্রম';

  @override
  String collectedThisMonth(String amount) {
    return 'এই মাসে ₹$amount';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return 'এই মাসে ₹$amount';
  }

  @override
  String get categoryAll => 'সব';

  @override
  String get findVendorsNearYou => 'কাছের বিক্রেতা খুঁজুন';

  @override
  String get searchByNameOrCategory =>
      'নাম, ব্যবসার নামে খুঁজুন\nবা উপরে বিভাগ বেছে নিন।';

  @override
  String noResultsForQuery(String query) {
    return '\"$query\" এর কোনো ফলাফল নেই।\nঅন্য নাম বা বিভাগ চেষ্টা করুন।';
  }

  @override
  String get addressLabel => 'ঠিকানা';

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI আইডি';

  @override
  String get upiEmailLabel => 'UPI / ইমেইল';

  @override
  String get couldNotLoadRetry => 'লোড হয়নি — পুনরায় চেষ্টা করতে ট্যাপ করুন';

  @override
  String labelCopied(String label) {
    return '$label কপি হয়েছে!';
  }

  @override
  String get upiIdCopied => 'UPI আইডি কপি হয়েছে!';

  @override
  String get requestSentButton => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get alreadyConnected => 'ইতিমধ্যে সংযুক্ত';

  @override
  String get sendingEllipsis => 'পাঠানো হচ্ছে…';

  @override
  String get sendConnectionRequest => 'সংযোগ অনুরোধ পাঠান';

  @override
  String get copyUpiIdToPay => 'পেমেন্টের জন্য UPI আইডি কপি করুন';

  @override
  String requestSentToVendor(String name) {
    return 'অনুরোধ পাঠানো হয়েছে! $name-কে জানানো হবে।';
  }

  @override
  String byOwnerName(String name) {
    return '$name কর্তৃক';
  }

  @override
  String get logOut => 'লগআউট';

  @override
  String get confirmLogoutTitle => 'লগআউট';

  @override
  String get areYouSureLogout => 'আপনি কি সত্যিই লগআউট করতে চান?';

  @override
  String get showQrToCollect => 'সরাসরি পেমেন্ট নিতে ক্রেতাকে এই QR দেখান।';

  @override
  String get uploadQr => 'QR আপলোড করুন';

  @override
  String get replaceQr => 'বদলান';

  @override
  String get qrUploaded => 'QR আপলোড হয়েছে';

  @override
  String scanToPayName(String name) {
    return '$name-কে পেমেন্ট করতে স্ক্যান করুন';
  }

  @override
  String get salarySingle => 'বেতন';

  @override
  String get advanceSingle => 'অগ্রিম';

  @override
  String get customersTitle => 'ক্রেতা';

  @override
  String balanceDue(String balance) {
    return '₹$balance বকেয়া';
  }

  @override
  String get recordDeliveryTooltip => 'ডেলিভারি রেকর্ড করুন';

  @override
  String get viewLedgerTooltip => 'খাতা দেখুন';

  @override
  String staffRoleSubtitle(String name) {
    return 'কর্মী · $name';
  }

  @override
  String get recordDelivery => 'উধার দিয়া';

  @override
  String get recordDeliverySubtitle =>
      'ক্রেতা মাল নিয়েছে — তার খাতায় যোগ করুন';

  @override
  String get collectPayment => 'পয়সা মিলা';

  @override
  String get collectPaymentSubtitle => 'ক্রেতা পেমেন্ট করেছে — তার খাতা কমান';

  @override
  String get viewAll2 => 'সব দেখুন';

  @override
  String get noCustomersStaff => 'এখনও কোনো ক্রেতা নেই';

  @override
  String get myVendorsSection => 'আমার বিক্রেতা';

  @override
  String get shopsYouBuyFrom => 'আপনি যেখান থেকে কেনেন';

  @override
  String get awaitingAcceptanceTitle => 'গ্রহণের অপেক্ষায়';

  @override
  String get customersHaventConfirmed => 'এই ক্রেতারা এখনও নিশ্চিত করেননি';

  @override
  String get pendingBadge => 'অপেক্ষমান';

  @override
  String get notifyCustomersWithDues => 'বকেয়া ক্রেতাদের জানান';

  @override
  String get linkANewCustomer => 'নতুন ক্রেতা যুক্ত করুন';

  @override
  String get dailyCharge => 'দৈনিক চার্জ';

  @override
  String get dailyChargeSubtitle =>
      'পরিমাণ সেট করুন ও একসাথে সবাইকে চার্জ করুন';

  @override
  String get findByPhoneOrEmailHint => 'ফোন নম্বর বা ইমেইলে খুঁজুন';

  @override
  String get phoneOrEmailLabel => 'ফোন বা ইমেইল';

  @override
  String get phoneMobileOrEmail => '১০ সংখ্যার মোবাইল বা ইমেইল ঠিকানা';

  @override
  String get nicknameOptionalLabel => 'ডাকনাম (ঐচ্ছিক)';

  @override
  String get howYouKnowCustomer => 'আপনি এই ক্রেতাকে কীভাবে চেনেন';

  @override
  String get requestSentWillBeNotified =>
      'অনুরোধ পাঠানো হয়েছে! নিশ্চিত করতে তাদের জানানো হবে।';

  @override
  String get outstandingTitle => 'বকেয়া';

  @override
  String customersWithDues(int count) {
    return '$count+ জন ক্রেতার বকেয়া আছে';
  }

  @override
  String get dueLabel => 'বকেয়া';

  @override
  String get collectedTodayTitle => 'আজকের সংগ্রহ';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ পেমেন্ট';
  }

  @override
  String get noPaymentsYetSubtitle => 'এখনও কোনো পেমেন্ট নেই';

  @override
  String removeLedgerVendorContent(String name) {
    return 'এটি $name-এর সাথে আপনার লিঙ্ক নিষ্ক্রিয় করবে। উভয় পক্ষ এই ভাগ করা খাতায় আর প্রবেশ করতে পারবেন না।';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'এটি $name-এর সাথে আপনার সংযোগ সরিয়ে দেবে।';
  }

  @override
  String get offlineUpdatesPaused => 'অফলাইন — আপডেট বন্ধ';

  @override
  String get exportStatementTitle => 'স্টেটমেন্ট এক্সপোর্ট';

  @override
  String get chooseExportDateRange =>
      'PDF-এ কোন তারিখ পর্যন্ত অন্তর্ভুক্ত করবেন তা বেছে নিন।';

  @override
  String get last7DaysRange => 'গত ৭ দিনের এন্ট্রি';

  @override
  String get last30DaysRange => 'গত ৩০ দিনের এন্ট্রি';

  @override
  String get last3MonthsRange => 'গত ৩ মাসের এন্ট্রি';

  @override
  String get completeLedgerHistory => 'সম্পূর্ণ খাতার ইতিহাস';

  @override
  String appAccessActive(String phone) {
    return 'সক্রিয় · $phone';
  }

  @override
  String get appAccessDisabled => 'অক্ষম';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name এখন $phone দিয়ে লগইন করতে পারবেন';
  }

  @override
  String appAccessRevoked(String name) {
    return '$name-এর অ্যাপ অ্যাক্সেস বাতিল করা হয়েছে';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'চালু থাকলে, $name তাদের নিজের নম্বর ($phone) দিয়ে লগইন করতে পারবেন এবং ডেলিভারি ও পেমেন্ট রেকর্ড করতে ও নিজের QR দেখাতে পারবেন — তবে উপস্থিতি পরিবর্তন, ক্রেতা যোগ বা অন্য কর্মী দেখতে পারবেন না।';
  }

  @override
  String get paymentHistoryTitle => 'পেমেন্টের ইতিহাস';

  @override
  String get couldNotLoadPaymentHistory => 'পেমেন্টের ইতিহাস লোড করা যায়নি';

  @override
  String get voicePleaseCheck => 'দয়া করে দেখুন';

  @override
  String get navHome => 'হোম';

  @override
  String get qty => 'পরিমাণ';

  @override
  String totalRupees(String amount) {
    return 'মোট: ₹$amount';
  }

  @override
  String get selectCustomerFirst => 'প্রথমে ক্রেতা বেছে নিন';

  @override
  String get enterValidAmount => 'বৈধ পরিমাণ দিন';

  @override
  String get addsCredit => 'ক্রেতা মাল নিয়েছে — তার খাতায় যোগ করুন';

  @override
  String get recordsCash => 'ক্রেতা পেমেন্ট করেছে — তার খাতা কমান';

  @override
  String deliveryRecordedFor(String name) {
    return '$name-এর জন্য ডেলিভারি রেকর্ড হয়েছে';
  }

  @override
  String paymentCollectedFrom(String name) {
    return '$name-এর কাছ থেকে পেমেন্ট সংগ্রহ হয়েছে';
  }

  @override
  String get manageSchedule => 'সময়সূচি পরিচালনা করুন';

  @override
  String get bookingsTab => 'বুকিং';

  @override
  String get bySlotTab => 'স্লট অনুযায়ী';

  @override
  String get scheduleSaved => 'সময়সূচি সেভ হয়েছে!';

  @override
  String get addSlot => 'স্লট যোগ করুন';

  @override
  String noSlotsForDay(String day) {
    return '$day-এ কোনো স্লট নেই';
  }

  @override
  String get tapAddSlotHint =>
      'আপনার উপলব্ধতা সেট করতে \"স্লট যোগ করুন\" ট্যাপ করুন';

  @override
  String get slotAvailable => 'উপলব্ধ';

  @override
  String get slotsFull => 'স্লট পূর্ণ';

  @override
  String get slotFullHint => 'এই স্লটটি সম্পূর্ণ বুকড চিহ্নিত করুন';

  @override
  String get enableSlotFirst => 'প্রথমে স্লট চালু করুন';

  @override
  String get deleteSlotTitle => 'স্লট মুছুন';

  @override
  String deleteSlotConfirm(String time) {
    return '$time স্লটটি সরাবেন?';
  }

  @override
  String get endTimeAfterStart => 'শেষ সময় শুরু সময়ের পরে হতে হবে';

  @override
  String get slotOverlaps => 'এই স্লট বিদ্যমান একটির সাথে মিলে যায়';

  @override
  String get addTimeSlot => 'সময় স্লট যোগ করুন';

  @override
  String get editTimeSlot => 'সময় স্লট সম্পাদনা করুন';

  @override
  String get selectTimeHint => '১২ ঘণ্টা ফরম্যাটে শুরু ও শেষ সময় বেছে নিন';

  @override
  String get startLabel => 'শুরু';

  @override
  String get endLabel => 'শেষ';

  @override
  String get update => 'আপডেট করুন';

  @override
  String get notifTabAll => 'সব';

  @override
  String get notifTabBookings => 'বুকিং';

  @override
  String get noBookingNotifications => 'কোনো বুকিং বিজ্ঞপ্তি নেই';

  @override
  String get noBookingNotificationsSubtitle =>
      'বুকিং অনুরোধ ও আপডেট এখানে দেখাবে';

  @override
  String get bookingPillLabel => 'বুকিং';

  @override
  String get slotDetailTitle => 'স্লটের বিবরণ';

  @override
  String bookingsCount(int count) {
    return '$countটি বুকিং';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$countটি বুকিং';
  }

  @override
  String pendingCountLabel(int count) {
    return '$countটি অপেক্ষমান';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'রাখুন';

  @override
  String get deleteButton => 'মুছুন';

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
  String get membershipPlansTitle => 'সদস্যপদ পরিকল্পনা';

  @override
  String get newPlanButton => 'নতুন পরিকল্পনা';

  @override
  String get deletePlanTitle => 'পরিকল্পনা মুছবেন?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" সরিয়ে দেওয়া হবে। এটি পূর্বাবস্থায় ফেরানো যাবে না।';
  }

  @override
  String get inactiveLabel => 'নিষ্ক্রিয়';

  @override
  String get noBenefitsAdded => 'কোনো সুবিধা যোগ হয়নি।';

  @override
  String get noMembershipPlans => 'এখনও কোনো সদস্যপদ পরিকল্পনা নেই';

  @override
  String get tapNewPlanHint =>
      'প্রথমটি তৈরি করতে \"নতুন পরিকল্পনা\" ট্যাপ করুন।';

  @override
  String get membershipRequestsTitle => 'সদস্যপদ অনুরোধ';

  @override
  String get noPendingRequests => 'কোনো অপেক্ষমান অনুরোধ নেই';

  @override
  String get customersCanApplyHint =>
      'ক্রেতারা তাদের খাতা স্ক্রিন থেকে\nসদস্যপদের জন্য আবেদন করতে পারবেন।';

  @override
  String get membersTitle => 'সদস্য';

  @override
  String get noMembersYet => 'এখনও কোনো সদস্য নেই';

  @override
  String get activeStat => 'সক্রিয়';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'মেয়াদ শেষ';

  @override
  String get allPlansFilter => 'সব পরিকল্পনা';

  @override
  String daysLeft(int count) {
    return '$countদি বাকি';
  }

  @override
  String daysLeftFull(int count) {
    return '$count দিন';
  }

  @override
  String get planNameLabel => 'পরিকল্পনার নাম';

  @override
  String get planNameHint => 'যেমন: গোল্ড মেম্বারশিপ';

  @override
  String get durationDaysLabel => 'মেয়াদ (দিন)';

  @override
  String get priceRupeesLabel => 'মূল্য ₹';

  @override
  String get addBenefitButton => 'সুবিধা যোগ করুন';

  @override
  String get customLabel => 'কাস্টম';

  @override
  String get customAdvanceLabel => 'কাস্টম অগ্রিম ₹';

  @override
  String get benefitLabel => 'সুবিধা';

  @override
  String get benefitHint => 'যেমন: ৪টি হেয়ারকাট';

  @override
  String get planDetailsSection => 'পরিকল্পনার বিবরণ';

  @override
  String get benefitsSection => 'সুবিধাসমূহ';

  @override
  String get advanceRequiredSection => 'প্রয়োজনীয় অগ্রিম';

  @override
  String get editPlanTitle => 'পরিকল্পনা সম্পাদনা করুন';

  @override
  String get createPlanTitle => 'সদস্যপদ পরিকল্পনা তৈরি করুন';

  @override
  String get publishPlanButton => 'পরিকল্পনা প্রকাশ করুন';

  @override
  String get planUpdatedToast => 'পরিকল্পনা আপডেট হয়েছে';

  @override
  String get planPublishedToast => 'পরিকল্পনা প্রকাশিত হয়েছে';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · পরিকল্পনা';
  }

  @override
  String get noPlansAvailable => 'এখনও কোনো পরিকল্পনা নেই';

  @override
  String get vendorNoPlansHint =>
      'এই বিক্রেতা এখনও কোনো সদস্যপদ পরিকল্পনা তৈরি করেননি।';

  @override
  String applyForPlan(String planName) {
    return '$planName-এর জন্য আবেদন করুন';
  }

  @override
  String get messageToVendorOptional => 'বিক্রেতাকে বার্তা (ঐচ্ছিক)';

  @override
  String get messageToVendorHint => 'যেমন: এই মাসে আমাকে নথিভুক্ত করুন';

  @override
  String get sendRequestButton => 'অনুরোধ পাঠান';

  @override
  String get activeLabel => 'সক্রিয়';

  @override
  String get noAdditionalBenefits => 'কোনো অতিরিক্ত সুবিধা নেই';

  @override
  String get currentPlanLabel => 'বর্তমান পরিকল্পনা';

  @override
  String get requestPendingLabel => 'অনুরোধ অপেক্ষমান';

  @override
  String get applyLabel => 'আবেদন করুন';

  @override
  String requestSentToName(String name) {
    return '$name-কে অনুরোধ পাঠানো হয়েছে';
  }

  @override
  String get membershipDialogTitle => 'সদস্যপদ';

  @override
  String pendingPlanPrefix(String planName) {
    return 'অপেক্ষমান: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return '$name-কে নথিভুক্ত করুন';
  }

  @override
  String get choosePlanHint =>
      'তাদের সদস্যপদ শুরু করতে একটি পরিকল্পনা বেছে নিন।';

  @override
  String get noActivePlansHint =>
      'কোনো সক্রিয় পরিকল্পনা নেই। প্রথমে সদস্যপদ → পরিকল্পনায় তৈরি করুন।';

  @override
  String get enrollLabel => 'নথিভুক্ত করুন';

  @override
  String get changeLabel => 'পরিবর্তন করুন';

  @override
  String get usedLabel => 'ব্যবহৃত';

  @override
  String get useLabel => 'ব্যবহার করুন';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count দিন বাকি';
  }

  @override
  String get orderPlacedSuccess => 'অর্ডার সফলভাবে দেওয়া হয়েছে!';

  @override
  String orderFromVendor(String vendorName) {
    return '$vendorName-এর কাছ থেকে অর্ডার';
  }

  @override
  String get addItemButton => 'আইটেম যোগ করুন';

  @override
  String get orderNoteOptional => 'অর্ডার নোট (ঐচ্ছিক)';

  @override
  String get totalLabel => 'মোট';

  @override
  String get placeOrderButton => 'অর্ডার দিন';

  @override
  String get itemNameRequired => 'আইটেমের নাম *';

  @override
  String get unitLabel => 'ইউনিট';

  @override
  String get unitHint => 'কেজি, লিটার…';

  @override
  String get unitPriceLabel => 'ইউনিট ₹';

  @override
  String itemNumber(int number) {
    return 'আইটেম $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'সাবটোটাল: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'অর্ডারের বিবরণ';

  @override
  String get proofPhotoLabel => 'প্রমাণের ছবি';

  @override
  String get tapToViewFullScreen => 'পূর্ণ পর্দায় দেখতে ট্যাপ করুন';

  @override
  String get rejectButton => 'প্রত্যাখ্যান করুন';

  @override
  String get confirmButton => 'নিশ্চিত করুন';

  @override
  String get markAsDeliveredButton => 'ডেলিভারড চিহ্নিত করুন';

  @override
  String get confirmDeliveryTitle => 'ডেলিভারি নিশ্চিত করুন';

  @override
  String get deliveryNoteOptional => 'ডেলিভারি নোট (ঐচ্ছিক)';

  @override
  String get retakeLabel => 'আবার তুলুন';

  @override
  String photoUploadFailed(String error) {
    return 'ছবি আপলোড ব্যর্থ: $error';
  }

  @override
  String get orderNoteLabel => 'অর্ডার নোট';

  @override
  String get customerLabel => 'ক্রেতা';

  @override
  String get ordersTitle => 'অর্ডার';

  @override
  String get noOrdersYet => 'এখনও কোনো অর্ডার নেই';

  @override
  String get markDeliveredButton => 'ডেলিভারড চিহ্নিত করুন';

  @override
  String get myOrdersTitle => 'আমার অর্ডার';

  @override
  String get deliverButton => 'ডেলিভার করুন';

  @override
  String get noPendingDeliveries => 'কোনো বিচারাধীন ডেলিভারি নেই';

  @override
  String get deliveriesTitle => 'ডেলিভারি';

  @override
  String get monthlyStatementTitle => 'মাসিক স্টেটমেন্ট';

  @override
  String get deliveryProofLabel => 'ডেলিভারির প্রমাণ';

  @override
  String get replacePhotoButton => 'ছবি বদলান';

  @override
  String get attachProofButton => 'প্রমাণ যুক্ত করুন';

  @override
  String get uploadingLabel => 'আপলোড হচ্ছে...';

  @override
  String get proofLockedHint => 'এই প্রমাণ লক করা এবং পরিবর্তন করা যাবে না';

  @override
  String get proofAttachedToast => 'প্রমাণ যুক্ত হয়েছে';

  @override
  String itemLabel(int number) {
    return 'আইটেম $number';
  }

  @override
  String get amountRequired => 'পরিমাণ *';

  @override
  String get addItemLabel => 'আইটেম যোগ করুন';

  @override
  String get totalAmountLabel => 'মোট';

  @override
  String get deactivate => 'নিষ্ক্রিয় করুন';

  @override
  String get activate => 'সক্রিয় করুন';

  @override
  String get activeStatLabel => 'সক্রিয়';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'মেয়াদ শেষ';

  @override
  String get closeLabel => 'বন্ধ করুন';

  @override
  String pendingPlanLabel(String name) {
    return 'অপেক্ষমান: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer $plan চেয়েছেন';
  }

  @override
  String itemsCount(int count) {
    return 'আইটেম ($count)';
  }

  @override
  String get deliveryLabel => 'ডেলিভারি';

  @override
  String markedDeliveredBy(String role) {
    return '$role কর্তৃক ডেলিভারড চিহ্নিত';
  }

  @override
  String get deliveriesHint =>
      'অর্ডারের মাধ্যমে ডেলিভারি হওয়া আইটেম। আইটেম দেখতে একটি এন্ট্রিতে ট্যাপ করুন।';
}
