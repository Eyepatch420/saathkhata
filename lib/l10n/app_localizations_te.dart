// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'సాథ్‌ఖాతా';

  @override
  String get tagline => 'ఒక ఖాతా, ఇద్దరికీ';

  @override
  String get onboarding1Title => 'రెండు వైపుల భాగస్వామ్య లెడ్జర్';

  @override
  String get onboarding1Subtitle =>
      'వ్యాపారి మరియు కస్టమర్ ఇద్దరికీ ఒకే ఖాతా. ఇద్దరూ ఒకే నిజాన్ని చూస్తారు.';

  @override
  String get onboarding2Title => 'వాయిస్ & బిల్ OCR';

  @override
  String get onboarding2Subtitle =>
      '12 భాషల్లో వెంటనే ఎంట్రీలు చేయడానికి మాట్లాడండి లేదా బిల్లులు స్కాన్ చేయండి.';

  @override
  String get onboarding3Title => 'ఒక్క ట్యాప్‌లో UPI చెల్లింపు';

  @override
  String get onboarding3Subtitle =>
      'UPI ద్వారా ఒక్క ట్యాప్‌లో నెల బకాయిలు తీర్చండి.';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String get next => 'తదుపరి';

  @override
  String get skip => 'దాటవేయి';

  @override
  String get chooseLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get continueButton => 'కొనసాగించు';

  @override
  String get chooseRole => 'మీ పాత్రను ఎంచుకోండి';

  @override
  String get vendor => 'వ్యాపారి';

  @override
  String get customer => 'కస్టమర్';

  @override
  String get welcomeToSaathKhata => 'సాథ్‌ఖాతాకు స్వాగతం';

  @override
  String get tellUsHowYouUse => 'మీరు యాప్‌ను ఎలా వాడతారో చెప్పండి';

  @override
  String get vendorRoleTitle => 'నేను ఒక వ్యాపారిని';

  @override
  String get vendorRoleSubtitle =>
      'వ్యాపార ఖాతా, ఉద్యోగులను నిర్వహించండి మరియు చెల్లింపులు స్వీకరించండి.';

  @override
  String get customerRoleTitle => 'నేను ఒక కస్టమర్‌ని';

  @override
  String get customerRoleSubtitle =>
      'వ్యాపారులతో ఖాతాను ట్రాక్ చేయండి మరియు UPI ద్వారా చెల్లించండి.';

  @override
  String get loginTitle => 'సాథ్‌ఖాతాలో లాగిన్ అవ్వండి';

  @override
  String get enterMobile => 'కొనసాగించడానికి మీ వివరాలు నమోదు చేయండి';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get verifyOtp => 'OTP ధృవీకరించండి';

  @override
  String get verifyAndContinue => 'ధృవీకరించి కొనసాగించు';

  @override
  String get changePhoneNumber => 'ఫోన్ నంబర్ మార్చండి';

  @override
  String otpSentTo(String phoneNumber) {
    return '+91 $phoneNumberకు పంపిన 6 అంకెల కోడ్ నమోదు చేయండి';
  }

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get passwordHint => 'పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get loginButton => 'లాగిన్';

  @override
  String get noAccount => 'ఖాతా లేదా?';

  @override
  String get signUp => 'నమోదు చేయండి';

  @override
  String get pleaseEnterCredentials => 'ఇమెయిల్ మరియు పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get fillRequiredFields => 'పేరు, ఇమెయిల్ మరియు పాస్‌వర్డ్ నింపండి';

  @override
  String get passwordMinChars => 'కనీసం 8 అక్షరాలు';

  @override
  String get completeProfile => 'ప్రొఫైల్ పూర్తి చేయండి';

  @override
  String get enterYourName => 'మీ పేరు నమోదు చేయండి';

  @override
  String get egBusinessName => 'ఉదా. కృష్ణ డెయిరీ';

  @override
  String get selectCategory => 'వర్గాన్ని ఎంచుకోండి';

  @override
  String get enterAddress => 'ప్రాంతం లేదా పూర్తి చిరునామా నమోదు చేయండి';

  @override
  String get upiHint => 'yourname@upi';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get businessName => 'వ్యాపార పేరు';

  @override
  String get businessCategory => 'వ్యాపార వర్గం';

  @override
  String get businessAddress => 'వ్యాపార చిరునామా (ఐచ్ఛికం)';

  @override
  String get upiId => 'UPI ID (చెల్లింపులకు)';

  @override
  String get vendorDashboard => 'వ్యాపారి డాష్‌బోర్డ్';

  @override
  String get customerDashboard => 'కస్టమర్ డాష్‌బోర్డ్';

  @override
  String get customerMode => 'కస్టమర్ మోడ్';

  @override
  String get myVendors => 'నా వ్యాపారులు';

  @override
  String get outstanding => 'బాకీ';

  @override
  String get collectedToday => 'నేడు వసూలు';

  @override
  String get quickActions => 'త్వరిత చర్యలు';

  @override
  String get scanBill => 'బిల్ స్కాన్ చేయండి';

  @override
  String get remindAll => 'అందరికీ గుర్తు చేయండి';

  @override
  String get addNew => 'కొత్తది జోడించు';

  @override
  String get recentCustomers => 'ఇటీవలి కస్టమర్లు';

  @override
  String get viewAll => 'అన్నీ చూడు';

  @override
  String customerAddedSnackbar(String name) {
    return '$name జోడించబడింది';
  }

  @override
  String get sharedLedger => 'భాగస్వామ్య ఖాతా';

  @override
  String get totalBalance => 'మొత్తం బ్యాలెన్స్';

  @override
  String get statement => 'స్టేట్‌మెంట్';

  @override
  String get giveCredit => 'అప్పు ఇవ్వు';

  @override
  String get recordPayment => 'చెల్లింపు నమోదు చేయండి';

  @override
  String get giveCreditSheet => 'అప్పు ఇవ్వు';

  @override
  String get recordPaymentSheet => 'చెల్లింపు నమోదు చేయండి';

  @override
  String get filterAll => 'అన్నీ';

  @override
  String get balanceCustomerOwes => 'కస్టమర్ బాకీ';

  @override
  String get balanceYouOwe => 'మీ బాకీ';

  @override
  String get balanceSettled => 'తీర్చబడింది';

  @override
  String get balanceYouOweVendor => 'మీరు వ్యాపారికి చెల్లించాలి';

  @override
  String get balanceVendorOwesYou => 'వ్యాపారి మీకు చెల్లించాలి';

  @override
  String get ledgerInfoTitle => 'ఈ ఖాతా ఎలా పనిచేస్తుంది';

  @override
  String get statusConfirmed => 'నిర్ధారించబడింది';

  @override
  String get statusConfirmedDesc =>
      'ఇరు పక్షాలూ అంగీకరించారు. ఎంట్రీ లాక్ చేయబడింది మరియు మార్చలేరు.';

  @override
  String get statusPending => 'పెండింగ్';

  @override
  String get statusPendingDesc =>
      'కస్టమర్ నిర్ధారణ కోసం వేచి ఉంది. 72 గంటల్లో స్వయంచాలకంగా నిర్ధారించబడుతుంది.';

  @override
  String get statusDisputed => 'వివాదాస్పదం';

  @override
  String get statusDisputedDesc =>
      'కస్టమర్ వివాదం లేవనెత్తారు. వ్యాపారి సమీక్ష అవసరం.';

  @override
  String get statusAutoConfirmed => 'స్వయంచాలక నిర్ధారణ';

  @override
  String get entryTypeCreditLabel => 'అప్పు ఎంట్రీ';

  @override
  String get entryTypePaymentLabel => 'చెల్లింపు స్వీకరించబడింది';

  @override
  String get entryDetails => 'ఎంట్రీ వివరాలు';

  @override
  String get entryAmount => 'మొత్తం';

  @override
  String get entryType => 'రకం';

  @override
  String get entryTypeCreditGiven => 'అప్పు (ఇచ్చినది)';

  @override
  String get entryTypePaymentReceived => 'చెల్లింపు (స్వీకరించినది)';

  @override
  String get entryDate => 'తేదీ';

  @override
  String get entryDescription => 'వివరణ';

  @override
  String get entryQuantity => 'పరిమాణం';

  @override
  String get entryConfirmedAt => 'నిర్ధారణ తేదీ';

  @override
  String get entryDisputeReason => 'వివాద కారణం';

  @override
  String entryFor(String name) {
    return '$name కోసం';
  }

  @override
  String get description => 'వివరణ';

  @override
  String get descriptionOptional => 'వివరణ (ఐచ్ఛికం)';

  @override
  String get quantityOptional => 'పరిమాణం (ఐచ్ఛికం)';

  @override
  String get descriptionHint => 'ఉదా. 2L పాలు, నెల కిరాణా';

  @override
  String get quantityHint => 'ఉదా. 2';

  @override
  String get addCreditEntry => 'అప్పు ఎంట్రీ జోడించు';

  @override
  String get noLedgerTransactions => 'ఇంకా లావాదేవీలు లేవు';

  @override
  String get noLedgerTransactionsSubtitle =>
      'ప్రారంభించడానికి అప్పు లేదా చెల్లింపు ఎంట్రీ జోడించండి.';

  @override
  String get confirmEntryTitle => 'ఎంట్రీని నిర్ధారించండి';

  @override
  String confirmEntryMessage(String amount) {
    return '₹$amount ఎంట్రీని నిర్ధారించాలా? ఇది తిరిగి మార్చలేరు.';
  }

  @override
  String get dispute => 'వివాదం';

  @override
  String get raiseDisputeTitle => 'వివాదం లేవనెత్తండి';

  @override
  String get raiseDisputeSubtitle => 'ఈ ఎంట్రీలో ఏమి తప్పు ఉందో వివరించండి.';

  @override
  String get raiseDisputeHint => 'ఉదా. మొత్తం ₹50 ఉండాలి, ₹60 కాదు';

  @override
  String get submitDispute => 'వివాదం సమర్పించండి';

  @override
  String get staffAndLabour => 'సిబ్బంది మరియు కార్మికులు';

  @override
  String get addStaff => 'సిబ్బందిని జోడించు';

  @override
  String get presentToday => 'నేడు హాజరు';

  @override
  String get unpaidSalary => 'చెల్లింపు కాని జీతం';

  @override
  String get paySalary => 'జీతం చెల్లించు';

  @override
  String get noStaffAdded => 'ఇంకా సిబ్బంది లేరు';

  @override
  String get noStaffAddedSubtitle =>
      'మొదటి సిబ్బందిని జోడించడానికి దిగువ బటన్ నొక్కండి.';

  @override
  String get present => 'హాజరు';

  @override
  String get absent => 'గైర్హాజరు';

  @override
  String get halfDay => 'అర్థ రోజు';

  @override
  String get paySalaryTitle => 'జీతం చెల్లించు';

  @override
  String unpaidLabel(String amount) {
    return 'చెల్లింపు కానిది: ₹$amount';
  }

  @override
  String get upiTransactionIdOptional => 'UPI లావాదేవీ ID (ఐచ్ఛికం)';

  @override
  String get noDues => 'బాకీలు లేవు';

  @override
  String staffPayAmount(String amount) {
    return '₹$amount చెల్లించు';
  }

  @override
  String staffJoined(String date) {
    return '$dateన చేరారు';
  }

  @override
  String staffSalaryPerDay(String amount) {
    return '₹$amount/రోజు';
  }

  @override
  String staffSalaryPerMonth(String amount) {
    return '₹$amount/నెల';
  }

  @override
  String get staffPayButton => 'చెల్లించు';

  @override
  String get businessReports => 'వ్యాపార నివేదికలు';

  @override
  String get revenueTrend => 'ఆదాయ ధోరణి';

  @override
  String get collectionSummary => 'వసూలు సారాంశం';

  @override
  String get totalOutstanding => 'మొత్తం బాకీ';

  @override
  String get totalCollected => 'మొత్తం వసూలు';

  @override
  String get topCustomers => 'అగ్రశ్రేణి కస్టమర్లు';

  @override
  String get seeAll => 'అన్నీ చూడు';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get appLanguage => 'యాప్ భాష';

  @override
  String get selectLanguage => 'భాష ఎంచుకోండి';

  @override
  String get settingsManagePayments => 'చెల్లింపు ఖాతాలు నిర్వహించండి';

  @override
  String get settingsManageAlerts => 'హెచ్చరికలు మరియు రిమైండర్లు నిర్వహించండి';

  @override
  String get settingsAppPinFingerprint => 'యాప్ పిన్ మరియు వేలిముద్ర';

  @override
  String get settingsFaqsContact => 'సహాయం మరియు సంప్రదింపు';

  @override
  String settingsVersion(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get myUpiIds => 'నా UPI IDలు';

  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get security => 'భద్రత';

  @override
  String get helpSupport => 'సహాయం';

  @override
  String get logout => 'లాగ్ అవుట్';

  @override
  String get markAllRead => 'అన్నీ చదివినట్లు గుర్తించు';

  @override
  String get noNotificationsTitle => 'ఇంకా నోటిఫికేషన్లు లేవు';

  @override
  String get noNotificationsSubtitle =>
      'ఇక్కడ ఖాతా అప్‌డేట్లు, చెల్లింపు హెచ్చరికలు మరియు రిమైండర్లు కనిపిస్తాయి.';

  @override
  String get today => 'నేడు';

  @override
  String get yesterday => 'నిన్న';

  @override
  String minutesAgo(int count) {
    return '$count నిమిషాల క్రితం';
  }

  @override
  String hoursAgo(int count) {
    return '$count గంటల క్రితం';
  }

  @override
  String get payments => 'చెల్లింపులు';

  @override
  String get transactionHistory => 'లావాదేవీల చరిత్ర';

  @override
  String get totalPaid => 'మొత్తం చెల్లించబడింది';

  @override
  String get pending => 'పెండింగ్';

  @override
  String get quickPay => 'త్వరిత చెల్లింపు';

  @override
  String get scanAndPay => 'స్కాన్ చేసి చెల్లించు';

  @override
  String get scanUpiDesc => 'వ్యాపారికి చెల్లించడానికి UPI QR స్కాన్ చేయండి';

  @override
  String get noTransactionsTitle => 'ఇంకా లావాదేవీలు లేవు';

  @override
  String get noTransactionsSubtitle =>
      'మీ చెల్లింపుల చరిత్ర ఇక్కడ కనిపిస్తుంది.';

  @override
  String get paymentStatusPaid => 'చెల్లించబడింది';

  @override
  String get paymentStatusFailed => 'విఫలమైంది';

  @override
  String get paymentStatusRefunded => 'తిరిగి ఇవ్వబడింది';

  @override
  String get appointments => 'అపాయింట్‌మెంట్లు';

  @override
  String get myAppointments => 'నా అపాయింట్‌మెంట్లు';

  @override
  String get upcoming => 'రాబోయే';

  @override
  String get past => 'గత';

  @override
  String get cancelBooking => 'బుకింగ్ రద్దు చేయండి';

  @override
  String get keepBooking => 'ఉంచు';

  @override
  String get noBookingsToday => 'నేడు బుకింగ్‌లు లేవు';

  @override
  String get noBookingsTodaySubtitle =>
      'కస్టమర్లు యాప్ ద్వారా అపాయింట్‌మెంట్లు బుక్ చేయవచ్చు.';

  @override
  String get noAppointmentsTitle => 'ఇంకా అపాయింట్‌మెంట్లు లేవు';

  @override
  String get noAppointmentsSubtitle =>
      'ప్రారంభించడానికి మీ వ్యాపారితో అపాయింట్‌మెంట్ బుక్ చేయండి.';

  @override
  String get cancelAppointmentTitle => 'అపాయింట్‌మెంట్ రద్దు చేయాలా?';

  @override
  String cancelAppointmentMessage(String date, String time) {
    return '$dateన $timeకి అపాయింట్‌మెంట్ రద్దు చేయాలా?';
  }

  @override
  String get bookingStatusConfirmed => 'నిర్ధారించబడింది';

  @override
  String get bookingStatusPending => 'పెండింగ్';

  @override
  String get bookingStatusCancelled => 'రద్దు చేయబడింది';

  @override
  String get bookingStatusCompleted => 'పూర్తయింది';

  @override
  String get bookingStatusDone => 'పూర్తయింది';

  @override
  String get upiPayment => 'UPI చెల్లింపు';

  @override
  String get amountToPay => 'చెల్లించాల్సిన మొత్తం';

  @override
  String get securedByUpi => 'UPI ద్వారా సురక్షితం';

  @override
  String get paymentSuccessful => 'చెల్లింపు విజయవంతం!';

  @override
  String get paymentFailed => 'చెల్లింపు విఫలమైంది';

  @override
  String get retryPayment => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get enterUpiId => 'UPI ID నమోదు చేయండి';

  @override
  String get addNoteOptional => 'నోట్ జోడించు (ఐచ్ఛికం)';

  @override
  String payAmountButton(String amount) {
    return '₹$amount చెల్లించు';
  }

  @override
  String get done => 'పూర్తయింది';

  @override
  String get paymentSomethingWentWrong =>
      'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String upiAppComingSoon(String app) {
    return '$app త్వరలో వస్తుంది';
  }

  @override
  String get pleaseEnterUpiId => 'UPI ID నమోదు చేయండి';

  @override
  String paidToRecipient(String amount, String name) {
    return '₹$amount $nameకి చెల్లించబడింది';
  }

  @override
  String get orDivider => 'లేదా';

  @override
  String get addNewCustomer => 'కొత్త కస్టమర్‌ని జోడించు';

  @override
  String get customerName => 'కస్టమర్ పేరు';

  @override
  String get mobileNo => 'మొబైల్ నంబర్';

  @override
  String get addCustomer => 'కస్టమర్‌ని జోడించు';

  @override
  String get paymentConfirmed => 'చెల్లింపు నిర్ధారించు';

  @override
  String get addAdvance => 'అడ్వాన్స్ జోడించు';

  @override
  String get addAdvanceTitle => 'అడ్వాన్స్ జోడించు';

  @override
  String get attendanceTitle => 'హాజరు';

  @override
  String get salaryTitle => 'జీతం సారాంశం';

  @override
  String get rate => 'రేటు';

  @override
  String get daysPresent => 'హాజరు రోజులు';

  @override
  String get earned => 'సంపాదించినది';

  @override
  String get unpaid => 'చెల్లింపు కానిది';

  @override
  String get advanceTaken => 'తీసుకున్న అడ్వాన్స్';

  @override
  String get active => 'చురుకుగా';

  @override
  String get inactive => 'నిష్క్రియంగా';

  @override
  String get joined => 'చేరారు';

  @override
  String get noPhone => 'ఫోన్ లేదు';

  @override
  String get addNewStaff => 'కొత్త సిబ్బందిని జోడించు';

  @override
  String get fullNameLabel => 'పూర్తి పేరు';

  @override
  String get phoneNumber => 'ఫోన్ నంబర్';

  @override
  String get role => 'పాత్ర';

  @override
  String get salaryType => 'జీతం రకం';

  @override
  String get dailyWage => 'రోజువారీ కూలి';

  @override
  String get monthlySalary => 'నెలవారీ జీతం';

  @override
  String get dailyWageAmount => 'రోజువారీ కూలి (₹)';

  @override
  String get monthlySalaryAmount => 'నెలవారీ జీతం (₹)';

  @override
  String get addStaffButton => 'సిబ్బందిని జోడించు';

  @override
  String get noteOptional => 'నోట్ (ఐచ్ఛికం)';

  @override
  String get amountRupees => 'మొత్తం (₹)';

  @override
  String get cancel => 'రద్దు';

  @override
  String get confirm => 'నిర్ధారించు';

  @override
  String get tryAgain => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get alignBillInFrame => 'బిల్‌ని ఫ్రేమ్‌లో పెట్టండి';

  @override
  String get verifyAndLogin => 'ధృవీకరించి లాగిన్ అవ్వండి';

  @override
  String get voiceListening => 'వింటున్నాను...';

  @override
  String get voiceThinking => 'ఆలోచిస్తున్నాను...';

  @override
  String get voiceDetectedEntry => 'గుర్తించిన ఎంట్రీ';

  @override
  String get voiceConfirmEntry => 'ఎంట్రీని నిర్ధారించు';

  @override
  String get item => 'వస్తువు';

  @override
  String get totalOutstandingBalance => 'మొత్తం బాకీ మొత్తం';

  @override
  String get payAllDues => 'అన్ని బాకీలు చెల్లించు';

  @override
  String get myKhatas => 'నా ఖాతాలు';

  @override
  String get noVendorsFound => 'వ్యాపారులు కనుగొనబడలేదు';

  @override
  String get verifyBillDetails => 'బిల్ వివరాలను ధృవీకరించండి';

  @override
  String get scannedBillPreview => 'స్కాన్ చేసిన బిల్';

  @override
  String get descriptionItemDetails => 'వివరణ / వస్తు వివరాలు';

  @override
  String get selectCustomer => 'కస్టమర్‌ని ఎంచుకోండి';

  @override
  String get searchCustomerHint => 'కస్టమర్‌ని వెతకండి లేదా ఎంచుకోండి';

  @override
  String get saveToKhata => 'ఖాతాలో సేవ్ చేయండి';

  @override
  String get allCustomersReport => 'అన్ని కస్టమర్ల నివేదిక';

  @override
  String collectedInMonth(String month) {
    return '$monthలో వసూలు';
  }

  @override
  String get notificationSettings => 'నోటిఫికేషన్ సెట్టింగ్‌లు';

  @override
  String get securityPin => 'భద్రత మరియు పిన్';

  @override
  String get editProfile => 'ప్రొఫైల్ సవరించు';

  @override
  String get changePassword => 'పాస్‌వర్డ్ మార్చు';

  @override
  String get termsAndConditions => 'నిబంధనలు మరియు షరతులు';

  @override
  String get privacyPolicy => 'గోప్యతా విధానం';

  @override
  String get accountSettings => 'ఖాతా సెట్టింగ్‌లు';

  @override
  String get legalInfo => 'చట్టపరమైన';

  @override
  String get currentPassword => 'ప్రస్తుత పాస్‌వర్డ్';

  @override
  String get newPassword => 'కొత్త పాస్‌వర్డ్';

  @override
  String get confirmNewPassword => 'కొత్త పాస్‌వర్డ్ నిర్ధారించు';

  @override
  String get passwordsDoNotMatch => 'పాస్‌వర్డ్‌లు సరిపోలడం లేదు';

  @override
  String get changePasswordButton => 'పాస్‌వర్డ్ మార్చు';

  @override
  String get passwordChangedSuccess => 'పాస్‌వర్డ్ విజయవంతంగా మార్చబడింది';

  @override
  String get loadingContent => 'లోడ్ అవుతోంది...';

  @override
  String get failedToLoad =>
      'కంటెంట్ లోడ్ చేయడం విఫలమైంది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get bookingActions => 'బుకింగ్ చర్యలు';

  @override
  String get confirmBooking => 'బుకింగ్ నిర్ధారించు';

  @override
  String get markComplete => 'పూర్తయిందిగా గుర్తించు';

  @override
  String confirmBookingMessage(String date, String time, String customer) {
    return '$customerకి $dateన $timeకి అపాయింట్‌మెంట్ నిర్ధారించాలా?';
  }

  @override
  String get bookingUpdated => 'బుకింగ్ విజయవంతంగా అప్‌డేట్ అయింది';

  @override
  String get bookingUpdateFailed => 'బుకింగ్ అప్‌డేట్ చేయడం విఫలమైంది';

  @override
  String markAttendanceFor(String date) {
    return 'హాజరు గుర్తించు — $date';
  }

  @override
  String get allCustomers => 'అందరు కస్టమర్లు';

  @override
  String get noCustomersYet => 'ఇంకా కస్టమర్లు లేరు';

  @override
  String get noCustomersYetSubtitle =>
      'ప్రారంభించడానికి మొదటి కస్టమర్‌ని జోడించండి';

  @override
  String get invalidPhone =>
      '6–9తో ప్రారంభమయ్యే 10 అంకెల చెల్లుబాటు అయ్యే మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String accrueMonthSalary(String amount) {
    return 'నెల జీతం జోడించు (₹$amount)';
  }

  @override
  String get accrueMonthSalaryTitle => 'నెల జీతం జోడించు';

  @override
  String get removeStaffTitle => 'సిబ్బందిని తొలగించు';

  @override
  String removeStaffConfirm(String name) {
    return '$nameని మీ సిబ్బంది నుండి తొలగించాలా? వారి యాప్ యాక్సెస్ వెంటనే రద్దు అవుతుంది.';
  }

  @override
  String accrueMonthSalaryConfirm(String name, String amount) {
    return '$nameకి ఈ నెల ₹$amount బాకీకి జోడించాలా?';
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
      'చెల్లుబాటు అయ్యే 10 అంకెల భారతీయ మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get enterAll6Digits => '6 అంకెలు పూర్తిగా నమోదు చేయండి';

  @override
  String enterAllDigits(int count) {
    return 'Enter all $count digits';
  }

  @override
  String get invalidEmailAddress =>
      'చెల్లుబాటు అయ్యే ఇమెయిల్ చిరునామా నమోదు చేయండి';

  @override
  String get passwordRequired => 'పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get nameRequired => 'పేరు అవసరం';

  @override
  String get required => 'అవసరం';

  @override
  String get invalidUpiFormat => 'చెల్లని UPI ID ఫార్మాట్ (ఉదా. name@upi)';

  @override
  String get upiIdAlreadyAdded => 'ఈ UPI ID ఇప్పటికే జోడించబడింది';

  @override
  String get verifyButton => 'ధృవీకరించు';

  @override
  String get createAccountButton => 'ఖాతా తెరవండి';

  @override
  String get phonePlaceholder => 'XXXXX XXXXX';

  @override
  String get enterPassword => 'పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get mobileNumberLabel => 'మొబైల్ నంబర్';

  @override
  String get personalInfo => 'వ్యక్తిగత వివరాలు';

  @override
  String get businessInfo => 'వ్యాపార వివరాలు';

  @override
  String get enterOtpTitle => 'OTP నమోదు చేయండి';

  @override
  String get sentToLabel => 'పంపిన నంబర్';

  @override
  String get noOtpReceived => 'OTP రాలేదా?';

  @override
  String get resendOtp => 'OTP మళ్ళీ పంపు';

  @override
  String get uploadingPhotoLabel => 'ఫోటో అప్‌లోడ్ అవుతోంది...';

  @override
  String get phoneNumberLabel => 'ఫోన్ నంబర్';

  @override
  String get iAmA => 'నేను ఒక';

  @override
  String get dualRoleExplanation =>
      'మీరు ప్రధానంగా వ్యాపారి అనుభవాన్ని ఉపయోగిస్తారు. మీ కస్టమర్ ఖాతాను వేరుగా యాక్సెస్ చేయవచ్చు.';

  @override
  String get profileSavedPhotoFailed =>
      'ప్రొఫైల్ సేవ్ అయింది — ఇప్పుడు ఫోటో అప్‌లోడ్ చేయలేకపోయింది';

  @override
  String get profileUpdatedSuccess => 'ప్రొఫైల్ విజయవంతంగా అప్‌డేట్ అయింది';

  @override
  String get addUpiIdTitle => 'UPI ID జోడించు';

  @override
  String get upiIdHint => 'yourname@upi';

  @override
  String get cancelButton => 'రద్దు';

  @override
  String get primaryUpiInfo => 'ప్రాథమిక UPI ID';

  @override
  String get primaryUpiDescription =>
      'ప్రాథమిక ID కస్టమర్లతో చెల్లింపు కోసం షేర్ చేయబడుతుంది. స్టార్ నొక్కి ప్రాథమికాన్ని మార్చండి.';

  @override
  String upiIdCounter(int count, int max) {
    return '$count / $max UPI IDలు';
  }

  @override
  String get primaryUpiIdTooltip => 'ప్రాథమిక UPI ID';

  @override
  String get setAsPrimaryTooltip => 'ప్రాథమికంగా సెట్ చేయి';

  @override
  String get primaryLabel => 'ప్రాథమికం';

  @override
  String get removeButtonLabel => 'తొలగించు';

  @override
  String get noUpiIdsEmpty => 'ఇంకా UPI IDలు లేవు';

  @override
  String get upiEmptyDescription =>
      'గరిష్టంగా 5 UPI IDలు జోడించవచ్చు. ప్రాథమిక ID చెల్లింపుల కోసం కస్టమర్లతో షేర్ అవుతుంది.';

  @override
  String get changePasswordSubtitle =>
      'మీ ప్రస్తుత పాస్‌వర్డ్ నమోదు చేసి కొత్తది ఎంచుకోండి.';

  @override
  String get alreadyHaveAccount => 'ఇప్పటికే ఖాతా ఉందా?';

  @override
  String get goBackButton => 'వెనక్కి వెళ్ళు';

  @override
  String get saveButton => 'సేవ్ చేయి';

  @override
  String get language => 'భాష';

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
      'ఇది వాడాలంటే మీ ఖాతాలో పాస్‌వర్డ్ సెట్ అయి ఉండాలి.\nసెట్టింగ్స్ → పాస్‌వర్డ్ మార్చు నుండి సెట్ చేయండి.';

  @override
  String get usePhoneInstead => 'ఫోన్ నంబర్ ఉపయోగించు →';

  @override
  String get sessionExpiredVerifyPhoneAgain =>
      'సెషన్ గడువు తీరింది. మళ్ళీ ఫోన్ ధృవీకరించండి.';

  @override
  String get upiIdsSavedSuccessfully => 'UPI IDలు విజయవంతంగా సేవ్ అయ్యాయి';

  @override
  String get chooseYourLanguageHindi => 'మీ భాషను ఎంచుకోండి';

  @override
  String get unknownLanguage => 'తెలియని భాష';

  @override
  String get businessCategoryMilkDairy => 'పాలు / డెయిరీ';

  @override
  String get businessCategoryPressDhobi => 'ప్రెస్ / ధోబి';

  @override
  String get businessCategoryMaidCook => 'పనిమనిషి / వంట';

  @override
  String get businessCategoryNewspaper => 'న్యూస్‌పేపర్';

  @override
  String get businessCategoryWaterCan => 'వాటర్ క్యాన్';

  @override
  String get businessCategoryTiffinFood => 'టిఫిన్ / తిండి';

  @override
  String get businessCategoryKiranaGrocery => 'కిరాణా';

  @override
  String get businessCategorySalonParlour => 'సెలూన్ / పార్లర్';

  @override
  String get businessCategoryConstructionLabour => 'నిర్మాణ కార్మికులు';

  @override
  String get businessCategoryTransportAuto => 'రవాణా / ఆటో';

  @override
  String get businessCategoryOther => 'ఇతర';

  @override
  String get bookAnAppointment => 'అపాయింట్‌మెంట్ బుక్ చేయండి';

  @override
  String get noSlotsAvailable => 'స్లాట్‌లు లేవు';

  @override
  String get trySelectingDifferentDate => 'వేరే తేదీ ఎంచుకోండి';

  @override
  String get availableSlots => 'అందుబాటులో ఉన్న స్లాట్‌లు';

  @override
  String get bookingConfirmedToast => 'బుకింగ్ నిర్ధారించబడింది!';

  @override
  String get date => 'తేదీ';

  @override
  String get time => 'సమయం';

  @override
  String get notesOptional => 'నోట్స్ (ఐచ్ఛికం)';

  @override
  String durationMinutes(int minutes) {
    return '$minutes నిమిషాలు';
  }

  @override
  String get saveChanges => 'మార్పులు సేవ్ చేయి';

  @override
  String get saveProduct => 'ఉత్పత్తి సేవ్ చేయి';

  @override
  String get editProductMenuItem => 'ఉత్పత్తి సవరించు';

  @override
  String get deleteProductMenuItem => 'ఉత్పత్తి తొలగించు';

  @override
  String get noProductsYetDescription =>
      'మీరు అమ్మే వస్తువులు — పాలు, పనీర్ మొదలైనవి — ఒకసారి నిర్వచించండి, తర్వాత రోజూ వాడండి.';

  @override
  String get selectProductToAssignQty =>
      'పరిమాణం నిర్ణయించడానికి పై నుండి ఉత్పత్తి ఎంచుకోండి';

  @override
  String get noCustomersLinked => 'ఇంకా కస్టమర్లు లింక్ కాలేదు';

  @override
  String get chargeAll => 'అందరికీ చార్జ్ చేయి';

  @override
  String chargedSuccessfully(int count) {
    return '$count కస్టమర్‌కు విజయవంతంగా చార్జ్ చేయబడింది';
  }

  @override
  String chargedSuccessfullyPlural(int count) {
    return '$count కస్టమర్లకు విజయవంతంగా చార్జ్ చేయబడింది';
  }

  @override
  String chargedPartial(int ok, int fail) {
    return '$ok చార్జ్ అయ్యారు, $fail విఫలమైంది';
  }

  @override
  String bulkSummaryLine(int count, String qty, String unit) {
    return '$count కస్టమర్  •  $qty $unit';
  }

  @override
  String bulkSummaryLinePlural(int count, String qty, String unit) {
    return '$count కస్టమర్లు  •  $qty $unit';
  }

  @override
  String totalAmount(String amount) {
    return '₹$amount మొత్తం';
  }

  @override
  String appointmentNext(String vendorName, String date, String time) {
    return 'తదుపరి: $vendorName · $date $timeకి';
  }

  @override
  String get outstandingShortLabel => 'బాకీ';

  @override
  String payViaUpiAmount(String amount) {
    return 'UPI ద్వారా ₹$amount చెల్లించు';
  }

  @override
  String paymentSummarySkipped(int count, int skipped) {
    return '$count వ్యాపారులకు చెల్లించారు, $skipped దాటవేశారు.';
  }

  @override
  String paymentSummarySkippedSingular(int count, int skipped) {
    return '$count వ్యాపారికి చెల్లించారు, $skipped దాటవేశారు.';
  }

  @override
  String paymentSummaryComplete(int count) {
    return 'అందరు $count వ్యాపారులకూ చెల్లించారు.';
  }

  @override
  String paymentSummaryCompleteSingular(int count) {
    return 'అందరు $count వ్యాపారికీ చెల్లించారు.';
  }

  @override
  String get tapToAcceptOrDecline =>
      'అంగీకరించడానికి లేదా తిరస్కరించడానికి నొక్కండి';

  @override
  String get helpSupportContactPrefix =>
      'ఏదైనా సహాయం కావాలంటే మాకు సంప్రదించండి:';

  @override
  String get supportEmail => 'igurus@info.in';

  @override
  String get bookButton => 'బుక్ చేయి';

  @override
  String waitingForVendorAcceptance(String name) {
    return '$name మీ అభ్యర్థనను అంగీకరించడానికి వేచి ఉంది.';
  }

  @override
  String get vendorWantsToConnectAsCustomer =>
      'ఒక వ్యాపారి కనెక్ట్ కావాలనుకుంటున్నారు';

  @override
  String get vendorWantsToConnectDesc =>
      'వారు మిమ్మల్ని కస్టమర్‌గా జోడించి మీ ఖాతాను ట్రాక్ చేయాలనుకుంటున్నారు.';

  @override
  String get someoneWantsToConnect => 'ఎవరో కనెక్ట్ కావాలనుకుంటున్నారు';

  @override
  String get someoneWantsToConnectDesc =>
      'వారు మీ ఖాతాకు కస్టమర్‌గా జోడించబడతారు.';

  @override
  String requestedTimeAgo(String time) {
    return '$time క్రితం అభ్యర్థించారు';
  }

  @override
  String connectedVendorLinked(String name) {
    return 'కనెక్ట్ అయింది! $name మీ ఖాతాకు లింక్ అయ్యారు.';
  }

  @override
  String requestDeclinedFrom(String name) {
    return '$name అభ్యర్థన తిరస్కరించబడింది.';
  }

  @override
  String connectedCustomerLinked(String name) {
    return 'కనెక్ట్ అయింది! $name మీ వ్యాపారానికి లింక్ అయ్యారు.';
  }

  @override
  String get processing => 'ప్రాసెస్ అవుతోంది…';

  @override
  String get retryButton => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get memberDiscountDescription =>
      'ఈ స్థాయిలోని సభ్యులకు వారి బాకీపై ఈ తగ్గింపు వర్తిస్తుంది.';

  @override
  String get discountValueInvalid =>
      '0 కంటే ఎక్కువ చెల్లుబాటు అయ్యే మొత్తం నమోదు చేయండి';

  @override
  String get percentageExceedsMax => 'శాతం 100 దాటకూడదు';

  @override
  String levelLabel(int level) {
    return 'స్థాయి $level';
  }

  @override
  String get rename => 'పేరు మార్చు';

  @override
  String get membershipLabel => 'సభ్యత్వం';

  @override
  String get noMembership => 'సభ్యత్వం లేదు';

  @override
  String get applyForMembership => 'సభ్యత్వానికి దరఖాస్తు చేయి';

  @override
  String get setMembershipTier => 'సభ్యత్వ స్థాయి సెట్ చేయి';

  @override
  String get chooseTierToRequestFromVendor =>
      'ఈ వ్యాపారి నుండి అభ్యర్థించడానికి స్థాయి ఎంచుకోండి';

  @override
  String chooseTierFor(String customerName) {
    return '$customerName కోసం స్థాయి ఎంచుకోండి';
  }

  @override
  String get setButton => 'సెట్ చేయి';

  @override
  String get changeButton => 'మార్చు';

  @override
  String get applyButton => 'అప్లై చేయి';

  @override
  String get approveButton => 'ఆమోదించు';

  @override
  String customerRequestedTier(String customerName, String tierName) {
    return '$customerName $tierName అభ్యర్థించారు';
  }

  @override
  String requestedTierAwaiting(String tierName) {
    return '$tierName అభ్యర్థించబడింది — ఆమోదం కోసం వేచి ఉంది';
  }

  @override
  String get verificationConnecting => 'మీ బ్యాంక్‌కు కనెక్ట్ అవుతోంది…';

  @override
  String get verificationVerifying => 'లావాదేవీ ధృవీకరిస్తోంది…';

  @override
  String get verificationWaiting => 'నిర్ధారణ కోసం వేచి ఉంది…';

  @override
  String get verificationAlmostThere => 'దాదాపు అయింది…';

  @override
  String get verificationDoNotClose => 'ఈ స్క్రీన్ మూయకండి';

  @override
  String verificationElapsed(int seconds) {
    return '${seconds}s  •  ఈ స్క్రీన్ మూయకండి';
  }

  @override
  String txnLabel(String txnId) {
    return 'Txn: $txnId';
  }

  @override
  String paidAmountToRecipient(String amount, String name) {
    return '₹$amount $nameకి చెల్లించబడింది';
  }

  @override
  String get verificationTimeoutBody =>
      '30 సెకన్లలో మీ చెల్లింపు నిర్ధారించలేకపోయాం. మీ డబ్బు డెబిట్ కాకపోవచ్చు — మళ్ళీ ప్రయత్నించే ముందు మీ బ్యాంక్ స్టేట్‌మెంట్ తనిఖీ చేయండి.';

  @override
  String get ifDebitedContactSupport =>
      'డెబిట్ అయినట్లయితే, Txn ID తో సపోర్ట్ సంప్రదించండి.';

  @override
  String get thisMonthSubtitle => 'ఈ నెల';

  @override
  String get billedNet => 'బిల్ (నెట్)';

  @override
  String get exclDisputed => 'వివాదాస్పదం మినహా';

  @override
  String get receivedLabel => 'స్వీకరించినది';

  @override
  String get paymentsAndAdj => 'చెల్లింపులు & సర్దుబాటు';

  @override
  String get currentBalance => 'ప్రస్తుత బ్యాలెన్స్';

  @override
  String paymentCount(int count) {
    return '$count చెల్లింపు';
  }

  @override
  String paymentCountPlural(int count) {
    return '$count చెల్లింపులు';
  }

  @override
  String customersCount(int count) {
    return '$count కస్టమర్లు';
  }

  @override
  String get rankedByOutstanding => 'బాకీ మొత్తం ఆధారంగా క్రమబద్ధం చేయబడింది';

  @override
  String collectedThisMonth(String amount) {
    return 'ఈ నెల ₹$amount';
  }

  @override
  String collectedThisMonthShort(String amount) {
    return '₹$amount ఈ నె.';
  }

  @override
  String get categoryAll => 'అన్నీ';

  @override
  String get findVendorsNearYou => 'మీ దగ్గర వ్యాపారులను వెతకండి';

  @override
  String get searchByNameOrCategory =>
      'పేరు, వ్యాపార పేరు ద్వారా వెతకండి\nలేదా పై నుండి వర్గం ఎంచుకోండి.';

  @override
  String noResultsForQuery(String query) {
    return '\"$query\" కు ఫలితాలు లేవు.\nవేరే పేరు లేదా వర్గం ప్రయత్నించండి.';
  }

  @override
  String get addressLabel => 'చిరునామా';

  @override
  String get emailLabel => 'ఇమెయిల్';

  @override
  String get upiLabel => 'UPI';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiEmailLabel => 'UPI / ఇమెయిల్';

  @override
  String get couldNotLoadRetry => 'లోడ్ కాలేదు — రీట్రై చేయడానికి నొక్కండి';

  @override
  String labelCopied(String label) {
    return '$label కాపీ చేయబడింది!';
  }

  @override
  String get upiIdCopied => 'UPI ID కాపీ చేయబడింది!';

  @override
  String get requestSentButton => 'అభ్యర్థన పంపబడింది';

  @override
  String get alreadyConnected => 'ఇప్పటికే కనెక్ట్ అయింది';

  @override
  String get sendingEllipsis => 'పంపుతోంది…';

  @override
  String get sendConnectionRequest => 'కనెక్షన్ అభ్యర్థన పంపు';

  @override
  String get copyUpiIdToPay => 'చెల్లించడానికి UPI ID కాపీ చేయి';

  @override
  String requestSentToVendor(String name) {
    return 'అభ్యర్థన పంపబడింది! $nameకు నోటిఫికేషన్ వస్తుంది.';
  }

  @override
  String byOwnerName(String name) {
    return '$name ద్వారా';
  }

  @override
  String get logOut => 'లాగ్ అవుట్';

  @override
  String get confirmLogoutTitle => 'లాగ్ అవుట్';

  @override
  String get areYouSureLogout => 'మీరు నిజంగా లాగ్ అవుట్ కావాలా?';

  @override
  String get showQrToCollect =>
      'నేరుగా చెల్లింపు స్వీకరించడానికి ఈ QR కస్టమర్‌కు చూపించండి.';

  @override
  String get uploadQr => 'QR అప్‌లోడ్ చేయి';

  @override
  String get replaceQr => 'మార్చు';

  @override
  String get qrUploaded => 'QR అప్‌లోడ్ అయింది';

  @override
  String scanToPayName(String name) {
    return '$nameకు చెల్లించడానికి స్కాన్ చేయి';
  }

  @override
  String get salarySingle => 'జీతం';

  @override
  String get advanceSingle => 'అడ్వాన్స్';

  @override
  String get customersTitle => 'కస్టమర్లు';

  @override
  String balanceDue(String balance) {
    return '₹$balance బాకీ';
  }

  @override
  String get recordDeliveryTooltip => 'డెలివరీ నమోదు చేయి';

  @override
  String get viewLedgerTooltip => 'ఖాతా చూడు';

  @override
  String staffRoleSubtitle(String name) {
    return 'సిబ్బంది · $name';
  }

  @override
  String get recordDelivery => 'అప్పు ఇచ్చారు';

  @override
  String get recordDeliverySubtitle =>
      'కస్టమర్ వస్తువులు తీసుకున్నారు — వారి ఖాతాలో జోడించు';

  @override
  String get collectPayment => 'పైసా వచ్చింది';

  @override
  String get collectPaymentSubtitle =>
      'కస్టమర్ చెల్లించారు — వారి ఖాతా తగ్గించు';

  @override
  String get viewAll2 => 'అన్నీ చూడు';

  @override
  String get noCustomersStaff => 'ఇంకా కస్టమర్లు లేరు';

  @override
  String get myVendorsSection => 'నా వ్యాపారులు';

  @override
  String get shopsYouBuyFrom => 'మీరు కొనే దుకాణాలు';

  @override
  String get awaitingAcceptanceTitle => 'అంగీకారం కోసం వేచి ఉంది';

  @override
  String get customersHaventConfirmed => 'ఈ కస్టమర్లు ఇంకా నిర్ధారించలేదు';

  @override
  String get pendingBadge => 'పెండింగ్';

  @override
  String get notifyCustomersWithDues => 'బాకీ ఉన్న కస్టమర్లకు గుర్తు చేయి';

  @override
  String get linkANewCustomer => 'కొత్త కస్టమర్‌ని లింక్ చేయి';

  @override
  String get dailyCharge => 'రోజువారీ చార్జ్';

  @override
  String get dailyChargeSubtitle => 'పరిమాణాలు సెట్ చేసి ఒకేసారి చార్జ్ చేయి';

  @override
  String get findByPhoneOrEmailHint => 'ఫోన్ నంబర్ లేదా ఇమెయిల్ ద్వారా వెతకండి';

  @override
  String get phoneOrEmailLabel => 'ఫోన్ లేదా ఇమెయిల్';

  @override
  String get phoneMobileOrEmail => '10 అంకెల మొబైల్ లేదా ఇమెయిల్ చిరునామా';

  @override
  String get nicknameOptionalLabel => 'మారుపేరు (ఐచ్ఛికం)';

  @override
  String get howYouKnowCustomer => 'మీకు ఈ కస్టమర్ ఎలా తెలుసు';

  @override
  String get requestSentWillBeNotified =>
      'అభ్యర్థన పంపబడింది! నిర్ధారించడానికి వారికి నోటిఫికేషన్ వస్తుంది.';

  @override
  String get outstandingTitle => 'బాకీ';

  @override
  String customersWithDues(int count) {
    return '$count+ కస్టమర్లకు బాకీ ఉంది';
  }

  @override
  String get dueLabel => 'బాకీ';

  @override
  String get collectedTodayTitle => 'నేడు వసూలు';

  @override
  String paymentsCountSubtitle(int count) {
    return '$count+ చెల్లింపులు';
  }

  @override
  String get noPaymentsYetSubtitle => 'ఇంకా చెల్లింపులు లేవు';

  @override
  String removeLedgerVendorContent(String name) {
    return 'ఇది $nameతో మీ లింక్ నిష్క్రియం చేస్తుంది. ఇరు పక్షాలూ ఈ భాగస్వామ్య ఖాతాకు యాక్సెస్ కోల్పోతారు.';
  }

  @override
  String removeLedgerCustomerContent(String name) {
    return 'ఇది $nameతో మీ కనెక్షన్ తొలగిస్తుంది.';
  }

  @override
  String get offlineUpdatesPaused => 'ఆఫ్‌లైన్ — అప్‌డేట్‌లు నిలిపివేయబడ్డాయి';

  @override
  String get exportStatementTitle => 'స్టేట్‌మెంట్ ఎగుమతి చేయి';

  @override
  String get chooseExportDateRange =>
      'PDF లో చేర్చడానికి తేదీ పరిధి ఎంచుకోండి.';

  @override
  String get last7DaysRange => 'గత 7 రోజుల ఎంట్రీలు';

  @override
  String get last30DaysRange => 'గత 30 రోజుల ఎంట్రీలు';

  @override
  String get last3MonthsRange => 'గత 3 నెలల ఎంట్రీలు';

  @override
  String get completeLedgerHistory => 'పూర్తి ఖాతా చరిత్ర';

  @override
  String appAccessActive(String phone) {
    return 'చురుకుగా · $phone';
  }

  @override
  String get appAccessDisabled => 'నిష్క్రియం';

  @override
  String appAccessGranted(String name, String phone) {
    return '$name ఇప్పుడు $phone తో లాగిన్ చేయవచ్చు';
  }

  @override
  String appAccessRevoked(String name) {
    return '$name యాప్ యాక్సెస్ రద్దు చేయబడింది';
  }

  @override
  String appAccessDescription(String name, String phone) {
    return 'ఆన్ చేస్తే $name తమ స్వంత నంబర్ ($phone) తో లాగిన్ చేసి డెలివరీలు & చెల్లింపులు నమోదు చేయవచ్చు, వారి QR చూపించవచ్చు — కానీ హాజరు మార్చలేరు, కస్టమర్లు జోడించలేరు, ఇతర సిబ్బందిని చూడలేరు.';
  }

  @override
  String get paymentHistoryTitle => 'చెల్లింపుల చరిత్ర';

  @override
  String get couldNotLoadPaymentHistory => 'చెల్లింపుల చరిత్ర లోడ్ కాలేదు';

  @override
  String get voicePleaseCheck => 'దయచేసి తనిఖీ చేయండి';

  @override
  String get navHome => 'హోమ్';

  @override
  String get qty => 'పరిమాణం';

  @override
  String totalRupees(String amount) {
    return 'మొత్తం: ₹$amount';
  }

  @override
  String get selectCustomerFirst => 'ముందు కస్టమర్‌ని ఎంచుకోండి';

  @override
  String get enterValidAmount => 'చెల్లుబాటు అయ్యే మొత్తం నమోదు చేయండి';

  @override
  String get addsCredit =>
      'కస్టమర్ వస్తువులు తీసుకున్నారు — వారి ఖాతాలో జోడించు';

  @override
  String get recordsCash => 'కస్టమర్ చెల్లించారు — వారి ఖాతా తగ్గించు';

  @override
  String deliveryRecordedFor(String name) {
    return '$name కోసం డెలివరీ నమోదు చేయబడింది';
  }

  @override
  String paymentCollectedFrom(String name) {
    return '$name నుండి చెల్లింపు వసూలు చేయబడింది';
  }

  @override
  String get manageSchedule => 'షెడ్యూల్ నిర్వహించు';

  @override
  String get bookingsTab => 'బుకింగ్‌లు';

  @override
  String get bySlotTab => 'స్లాట్ వారీగా';

  @override
  String get scheduleSaved => 'షెడ్యూల్ సేవ్ అయింది!';

  @override
  String get addSlot => 'స్లాట్ జోడించు';

  @override
  String noSlotsForDay(String day) {
    return '$dayకి స్లాట్‌లు లేవు';
  }

  @override
  String get tapAddSlotHint =>
      'మీ అందుబాటు సెట్ చేయడానికి \"స్లాట్ జోడించు\" నొక్కండి';

  @override
  String get slotAvailable => 'అందుబాటులో ఉంది';

  @override
  String get slotsFull => 'స్లాట్‌లు నిండాయి';

  @override
  String get slotFullHint => 'ఈ స్లాట్ పూర్తిగా బుక్ అయినట్లు గుర్తించు';

  @override
  String get enableSlotFirst => 'ముందు స్లాట్ ఎనేబుల్ చేయండి';

  @override
  String get deleteSlotTitle => 'స్లాట్ తొలగించు';

  @override
  String deleteSlotConfirm(String time) {
    return '$time స్లాట్ తొలగించాలా?';
  }

  @override
  String get endTimeAfterStart => 'ముగింపు సమయం ప్రారంభ సమయం తర్వాత ఉండాలి';

  @override
  String get slotOverlaps => 'ఈ స్లాట్ ఇప్పటికే ఉన్న స్లాట్‌తో అతివ్యాపించింది';

  @override
  String get addTimeSlot => 'సమయ స్లాట్ జోడించు';

  @override
  String get editTimeSlot => 'సమయ స్లాట్ సవరించు';

  @override
  String get selectTimeHint =>
      '12 గంటల ఫార్మాట్‌లో ప్రారంభ మరియు ముగింపు సమయం ఎంచుకోండి';

  @override
  String get startLabel => 'ప్రారంభం';

  @override
  String get endLabel => 'ముగింపు';

  @override
  String get update => 'అప్‌డేట్ చేయి';

  @override
  String get notifTabAll => 'అన్నీ';

  @override
  String get notifTabBookings => 'బుకింగ్‌లు';

  @override
  String get noBookingNotifications => 'బుకింగ్ నోటిఫికేషన్లు లేవు';

  @override
  String get noBookingNotificationsSubtitle =>
      'బుకింగ్ అభ్యర్థనలు మరియు అప్‌డేట్‌లు ఇక్కడ కనిపిస్తాయి';

  @override
  String get bookingPillLabel => 'బుకింగ్';

  @override
  String get slotDetailTitle => 'స్లాట్ వివరాలు';

  @override
  String bookingsCount(int count) {
    return '$count బుకింగ్';
  }

  @override
  String bookingsCountPlural(int count) {
    return '$count బుకింగ్‌లు';
  }

  @override
  String pendingCountLabel(int count) {
    return '$count పెండింగ్';
  }

  @override
  String slotTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get keepButton => 'ఉంచు';

  @override
  String get deleteButton => 'తొలగించు';

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
  String get membershipPlansTitle => 'సభ్యత్వ ప్లాన్‌లు';

  @override
  String get newPlanButton => 'కొత్త ప్లాన్';

  @override
  String get deletePlanTitle => 'ప్లాన్ తొలగించాలా?';

  @override
  String deletePlanConfirm(String name) {
    return '\"$name\" తొలగించబడుతుంది. ఇది చేయవీలు కాదు.';
  }

  @override
  String get inactiveLabel => 'నిష్క్రియం';

  @override
  String get noBenefitsAdded => 'ప్రయోజనాలు జోడించలేదు.';

  @override
  String get noMembershipPlans => 'ఇంకా సభ్యత్వ ప్లాన్‌లు లేవు';

  @override
  String get tapNewPlanHint =>
      'మీ మొదటి ప్లాన్ తయారు చేయడానికి \"కొత్త ప్లాన్\" నొక్కండి.';

  @override
  String get membershipRequestsTitle => 'సభ్యత్వ అభ్యర్థనలు';

  @override
  String get noPendingRequests => 'పెండింగ్ అభ్యర్థనలు లేవు';

  @override
  String get customersCanApplyHint =>
      'కస్టమర్లు వారి ఖాతా స్క్రీన్ నుండి\nసభ్యత్వానికి దరఖాస్తు చేయవచ్చు.';

  @override
  String get membersTitle => 'సభ్యులు';

  @override
  String get noMembersYet => 'ఇంకా సభ్యులు లేరు';

  @override
  String get activeStat => 'చురుకుగా';

  @override
  String get mrrStat => 'MRR';

  @override
  String get expiringStat => 'గడువు తీరుతోంది';

  @override
  String get allPlansFilter => 'అన్ని ప్లాన్‌లు';

  @override
  String daysLeft(int count) {
    return '$countరో మిగిలింది';
  }

  @override
  String daysLeftFull(int count) {
    return '$count రోజులు';
  }

  @override
  String get planNameLabel => 'ప్లాన్ పేరు';

  @override
  String get planNameHint => 'ఉదా. గోల్డ్ మెంబర్‌షిప్';

  @override
  String get durationDaysLabel => 'వ్యవధి (రోజులు)';

  @override
  String get priceRupeesLabel => 'ధర ₹';

  @override
  String get addBenefitButton => 'ప్రయోజనం జోడించు';

  @override
  String get customLabel => 'అనుకూలం';

  @override
  String get customAdvanceLabel => 'అనుకూల అడ్వాన్స్ ₹';

  @override
  String get benefitLabel => 'ప్రయోజనం';

  @override
  String get benefitHint => 'ఉదా. 4 హెయిర్‌కట్‌లు';

  @override
  String get planDetailsSection => 'ప్లాన్ వివరాలు';

  @override
  String get benefitsSection => 'ప్రయోజనాలు';

  @override
  String get advanceRequiredSection => 'అవసరమైన అడ్వాన్స్';

  @override
  String get editPlanTitle => 'ప్లాన్ సవరించు';

  @override
  String get createPlanTitle => 'సభ్యత్వ ప్లాన్ తయారు చేయి';

  @override
  String get publishPlanButton => 'ప్లాన్ ప్రచురించు';

  @override
  String get planUpdatedToast => 'ప్లాన్ అప్‌డేట్ అయింది';

  @override
  String get planPublishedToast => 'ప్లాన్ ప్రచురించబడింది';

  @override
  String vendorPlansTitle(String vendorName) {
    return '$vendorName · ప్లాన్‌లు';
  }

  @override
  String get noPlansAvailable => 'ఇంకా ప్లాన్‌లు అందుబాటులో లేవు';

  @override
  String get vendorNoPlansHint =>
      'ఈ వ్యాపారి ఇంకా ఏ సభ్యత్వ ప్లాన్‌లూ తయారు చేయలేదు.';

  @override
  String applyForPlan(String planName) {
    return '$planName కోసం దరఖాస్తు చేయి';
  }

  @override
  String get messageToVendorOptional => 'వ్యాపారికి సందేశం (ఐచ్ఛికం)';

  @override
  String get messageToVendorHint => 'ఉదా. దయచేసి ఈ నెల నన్ను నమోదు చేయండి';

  @override
  String get sendRequestButton => 'అభ్యర్థన పంపు';

  @override
  String get activeLabel => 'చురుకుగా';

  @override
  String get noAdditionalBenefits => 'అదనపు ప్రయోజనాలు లేవు';

  @override
  String get currentPlanLabel => 'ప్రస్తుత ప్లాన్';

  @override
  String get requestPendingLabel => 'అభ్యర్థన పెండింగ్‌లో ఉంది';

  @override
  String get applyLabel => 'దరఖాస్తు చేయి';

  @override
  String requestSentToName(String name) {
    return '$nameకు అభ్యర్థన పంపబడింది';
  }

  @override
  String get membershipDialogTitle => 'సభ్యత్వం';

  @override
  String pendingPlanPrefix(String planName) {
    return 'పెండింగ్: $planName';
  }

  @override
  String enrollCustomer(String name) {
    return '$nameని నమోదు చేయి';
  }

  @override
  String get choosePlanHint =>
      'వారి సభ్యత్వం ప్రారంభించడానికి ఒక ప్లాన్ ఎంచుకోండి.';

  @override
  String get noActivePlansHint =>
      'చురుకైన ప్లాన్‌లు లేవు. ముందు సభ్యత్వాలు → ప్లాన్‌లలో ఒకటి తయారు చేయండి.';

  @override
  String get enrollLabel => 'నమోదు చేయి';

  @override
  String get changeLabel => 'మార్చు';

  @override
  String get usedLabel => 'వాడారు';

  @override
  String get useLabel => 'వాడు';

  @override
  String get decreaseLabel => 'Decrease usage count';

  @override
  String daysLeftLabel(int count) {
    return '$count రోజులు మిగిలాయి';
  }

  @override
  String get orderPlacedSuccess => 'ఆర్డర్ విజయవంతంగా పెట్టబడింది!';

  @override
  String orderFromVendor(String vendorName) {
    return '$vendorName నుండి ఆర్డర్';
  }

  @override
  String get addItemButton => 'వస్తువు జోడించు';

  @override
  String get orderNoteOptional => 'ఆర్డర్ నోట్ (ఐచ్ఛికం)';

  @override
  String get totalLabel => 'మొత్తం';

  @override
  String get placeOrderButton => 'ఆర్డర్ పెట్టు';

  @override
  String get itemNameRequired => 'వస్తువు పేరు *';

  @override
  String get unitLabel => 'యూనిట్';

  @override
  String get unitHint => 'కేజీ, లీ…';

  @override
  String get unitPriceLabel => 'యూనిట్ ₹';

  @override
  String itemNumber(int number) {
    return 'వస్తువు $number';
  }

  @override
  String subtotalLabel(String amount) {
    return 'సబ్‌టోటల్: ₹$amount';
  }

  @override
  String get orderDetailsTitle => 'ఆర్డర్ వివరాలు';

  @override
  String get proofPhotoLabel => 'రుజువు ఫోటో';

  @override
  String get tapToViewFullScreen => 'పూర్తి స్క్రీన్‌లో చూడటానికి నొక్కండి';

  @override
  String get rejectButton => 'తిరస్కరించు';

  @override
  String get confirmButton => 'నిర్ధారించు';

  @override
  String get markAsDeliveredButton => 'డెలివరీ అయినట్లు గుర్తించు';

  @override
  String get confirmDeliveryTitle => 'డెలివరీ నిర్ధారించు';

  @override
  String get deliveryNoteOptional => 'డెలివరీ నోట్ (ఐచ్ఛికం)';

  @override
  String get retakeLabel => 'మళ్ళీ తీయి';

  @override
  String photoUploadFailed(String error) {
    return 'ఫోటో అప్‌లోడ్ విఫలమైంది: $error';
  }

  @override
  String get orderNoteLabel => 'ఆర్డర్ నోట్';

  @override
  String get customerLabel => 'కస్టమర్';

  @override
  String get ordersTitle => 'ఆర్డర్‌లు';

  @override
  String get noOrdersYet => 'ఇంకా ఆర్డర్‌లు లేవు';

  @override
  String get markDeliveredButton => 'డెలివరీ గుర్తించు';

  @override
  String get myOrdersTitle => 'నా ఆర్డర్‌లు';

  @override
  String get deliverButton => 'డెలివర్ చేయి';

  @override
  String get noPendingDeliveries => 'పెండింగ్ డెలివరీలు లేవు';

  @override
  String get deliveriesTitle => 'డెలివరీలు';

  @override
  String get monthlyStatementTitle => 'నెలవారీ స్టేట్‌మెంట్';

  @override
  String get deliveryProofLabel => 'డెలివరీ రుజువు';

  @override
  String get replacePhotoButton => 'ఫోటో మార్చు';

  @override
  String get attachProofButton => 'రుజువు జతచేయి';

  @override
  String get uploadingLabel => 'అప్‌లోడ్ అవుతోంది...';

  @override
  String get proofLockedHint => 'ఈ రుజువు లాక్ చేయబడింది, మార్చలేరు';

  @override
  String get proofAttachedToast => 'రుజువు జతచేయబడింది';

  @override
  String itemLabel(int number) {
    return 'వస్తువు $number';
  }

  @override
  String get amountRequired => 'మొత్తం *';

  @override
  String get addItemLabel => 'వస్తువు జోడించు';

  @override
  String get totalAmountLabel => 'మొత్తం';

  @override
  String get deactivate => 'నిష్క్రియం చేయి';

  @override
  String get activate => 'చురుకు చేయి';

  @override
  String get activeStatLabel => 'చురుకుగా';

  @override
  String get mrrStatLabel => 'MRR';

  @override
  String get expiringStatLabel => 'గడువు తీరుతోంది';

  @override
  String get closeLabel => 'మూయి';

  @override
  String pendingPlanLabel(String name) {
    return 'పెండింగ్: $name';
  }

  @override
  String customerRequestedPlan(String customer, String plan) {
    return '$customer $plan అభ్యర్థించారు';
  }

  @override
  String itemsCount(int count) {
    return 'వస్తువులు ($count)';
  }

  @override
  String get deliveryLabel => 'డెలివరీ';

  @override
  String markedDeliveredBy(String role) {
    return '$role డెలివరీ అయినట్లు గుర్తించారు';
  }

  @override
  String get deliveriesHint =>
      'ఆర్డర్ల ద్వారా చేసిన డెలివరీలు. వస్తువులు చూడటానికి ఒక ఎంట్రీ నొక్కండి.';

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
