import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bho.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bho'),
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mai'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Saath Khata'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Ek Khata, Dono Ka'**
  String get tagline;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Two-Sided Shared Ledger'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'One Ledger for both Vendor and Customer. Both see the same truth.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Voice & Bill OCR'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak or scan bills to create entries instantly in 12 languages.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'One-Tap UPI Payment'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Settle your month-end dues with a single tap via UPI.'**
  String get onboarding3Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @chooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get chooseRole;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @welcomeToSaathKhata.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SaathKhata'**
  String get welcomeToSaathKhata;

  /// No description provided for @tellUsHowYouUse.
  ///
  /// In en, this message translates to:
  /// **'Tell us how you will use the app'**
  String get tellUsHowYouUse;

  /// No description provided for @vendorRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a Vendor / Seller'**
  String get vendorRoleTitle;

  /// No description provided for @vendorRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage my business ledger, staff, and collect payments.'**
  String get vendorRoleSubtitle;

  /// No description provided for @customerRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a Customer / Buyer'**
  String get customerRoleTitle;

  /// No description provided for @customerRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track my khata with local vendors and pay via UPI.'**
  String get customerRoleSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to SaathKhata'**
  String get loginTitle;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to continue'**
  String get enterMobile;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to +91 {phoneNumber}'**
  String otpSentTo(String phoneNumber);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @pleaseEnterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get pleaseEnterCredentials;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in name, email and password'**
  String get fillRequiredFields;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordMinChars;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @egBusinessName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Krishna Dairy'**
  String get egBusinessName;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter area or full address'**
  String get enterAddress;

  /// No description provided for @upiHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@upi'**
  String get upiHint;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @businessCategory.
  ///
  /// In en, this message translates to:
  /// **'Business Category'**
  String get businessCategory;

  /// No description provided for @businessAddress.
  ///
  /// In en, this message translates to:
  /// **'Business Address (Optional)'**
  String get businessAddress;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID (For Payments)'**
  String get upiId;

  /// No description provided for @vendorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Vendor Dashboard'**
  String get vendorDashboard;

  /// No description provided for @customerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Customer Dashboard'**
  String get customerDashboard;

  /// No description provided for @customerMode.
  ///
  /// In en, this message translates to:
  /// **'Customer Mode'**
  String get customerMode;

  /// No description provided for @myVendors.
  ///
  /// In en, this message translates to:
  /// **'My Vendors'**
  String get myVendors;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @collectedToday.
  ///
  /// In en, this message translates to:
  /// **'Collected Today'**
  String get collectedToday;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanBill.
  ///
  /// In en, this message translates to:
  /// **'Scan Bill'**
  String get scanBill;

  /// No description provided for @remindAll.
  ///
  /// In en, this message translates to:
  /// **'Remind All'**
  String get remindAll;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @recentCustomers.
  ///
  /// In en, this message translates to:
  /// **'Recent Customers'**
  String get recentCustomers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @customerAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String customerAddedSnackbar(String name);

  /// No description provided for @sharedLedger.
  ///
  /// In en, this message translates to:
  /// **'Shared Ledger'**
  String get sharedLedger;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BALANCE'**
  String get totalBalance;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @giveCredit.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT PENDING'**
  String get giveCredit;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT RECEIVED'**
  String get recordPayment;

  /// No description provided for @giveCreditSheet.
  ///
  /// In en, this message translates to:
  /// **'Amount Pending'**
  String get giveCreditSheet;

  /// No description provided for @recordPaymentSheet.
  ///
  /// In en, this message translates to:
  /// **'Amount Received'**
  String get recordPaymentSheet;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @balanceCustomerOwes.
  ///
  /// In en, this message translates to:
  /// **'Customer owes you'**
  String get balanceCustomerOwes;

  /// No description provided for @balanceYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe customer'**
  String get balanceYouOwe;

  /// No description provided for @balanceSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get balanceSettled;

  /// No description provided for @balanceYouOweVendor.
  ///
  /// In en, this message translates to:
  /// **'You owe vendor'**
  String get balanceYouOweVendor;

  /// No description provided for @balanceVendorOwesYou.
  ///
  /// In en, this message translates to:
  /// **'Vendor owes you'**
  String get balanceVendorOwesYou;

  /// No description provided for @ledgerInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How this ledger works'**
  String get ledgerInfoTitle;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusConfirmedDesc.
  ///
  /// In en, this message translates to:
  /// **'Both parties agreed. Entry is locked and cannot be changed.'**
  String get statusConfirmedDesc;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Awaiting customer confirmation. Auto-confirmed after 72 hours.'**
  String get statusPendingDesc;

  /// No description provided for @statusDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get statusDisputed;

  /// No description provided for @statusDisputedDesc.
  ///
  /// In en, this message translates to:
  /// **'Customer raised a dispute. Vendor review required.'**
  String get statusDisputedDesc;

  /// No description provided for @statusAutoConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Auto-Confirmed'**
  String get statusAutoConfirmed;

  /// No description provided for @entryTypeCreditLabel.
  ///
  /// In en, this message translates to:
  /// **'Credit Entry'**
  String get entryTypeCreditLabel;

  /// No description provided for @entryTypePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get entryTypePaymentLabel;

  /// No description provided for @entryDetails.
  ///
  /// In en, this message translates to:
  /// **'Entry Details'**
  String get entryDetails;

  /// No description provided for @entryAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get entryAmount;

  /// No description provided for @entryType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get entryType;

  /// No description provided for @entryTypeCreditGiven.
  ///
  /// In en, this message translates to:
  /// **'Credit (Given)'**
  String get entryTypeCreditGiven;

  /// No description provided for @entryTypePaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment (Received)'**
  String get entryTypePaymentReceived;

  /// No description provided for @entryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get entryDate;

  /// No description provided for @entryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get entryDescription;

  /// No description provided for @entryQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get entryQuantity;

  /// No description provided for @entryConfirmedAt.
  ///
  /// In en, this message translates to:
  /// **'Confirmed At'**
  String get entryConfirmedAt;

  /// No description provided for @entryDisputeReason.
  ///
  /// In en, this message translates to:
  /// **'Dispute Reason'**
  String get entryDisputeReason;

  /// No description provided for @entryFor.
  ///
  /// In en, this message translates to:
  /// **'for {name}'**
  String entryFor(String name);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @quantityOptional.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get quantityOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2L Milk, Monthly groceries'**
  String get descriptionHint;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2'**
  String get quantityHint;

  /// No description provided for @addCreditEntry.
  ///
  /// In en, this message translates to:
  /// **'ADD CREDIT ENTRY'**
  String get addCreditEntry;

  /// No description provided for @noLedgerTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noLedgerTransactions;

  /// No description provided for @noLedgerTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a credit or payment entry to get started.'**
  String get noLedgerTransactionsSubtitle;

  /// No description provided for @confirmEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Entry'**
  String get confirmEntryTitle;

  /// No description provided for @confirmEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm ₹{amount} entry? This action cannot be undone.'**
  String confirmEntryMessage(String amount);

  /// No description provided for @dispute.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get dispute;

  /// No description provided for @raiseDisputeTitle.
  ///
  /// In en, this message translates to:
  /// **'Raise a Dispute'**
  String get raiseDisputeTitle;

  /// No description provided for @raiseDisputeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe what is incorrect about this entry.'**
  String get raiseDisputeSubtitle;

  /// No description provided for @raiseDisputeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Amount should be ₹50, not ₹60'**
  String get raiseDisputeHint;

  /// No description provided for @submitDispute.
  ///
  /// In en, this message translates to:
  /// **'Submit Dispute'**
  String get submitDispute;

  /// No description provided for @staffAndLabour.
  ///
  /// In en, this message translates to:
  /// **'Staff & Labour'**
  String get staffAndLabour;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get addStaff;

  /// No description provided for @presentToday.
  ///
  /// In en, this message translates to:
  /// **'Present Today'**
  String get presentToday;

  /// No description provided for @unpaidSalary.
  ///
  /// In en, this message translates to:
  /// **'Unpaid Salary'**
  String get unpaidSalary;

  /// No description provided for @paySalary.
  ///
  /// In en, this message translates to:
  /// **'Pay Salary'**
  String get paySalary;

  /// No description provided for @noStaffAdded.
  ///
  /// In en, this message translates to:
  /// **'No staff added yet'**
  String get noStaffAdded;

  /// No description provided for @noStaffAddedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first staff member.'**
  String get noStaffAddedSubtitle;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @halfDay.
  ///
  /// In en, this message translates to:
  /// **'Half Day'**
  String get halfDay;

  /// No description provided for @paySalaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay Salary'**
  String get paySalaryTitle;

  /// No description provided for @unpaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Unpaid: ₹{amount}'**
  String unpaidLabel(String amount);

  /// No description provided for @upiTransactionIdOptional.
  ///
  /// In en, this message translates to:
  /// **'UPI Transaction ID (optional)'**
  String get upiTransactionIdOptional;

  /// No description provided for @noDues.
  ///
  /// In en, this message translates to:
  /// **'No Dues'**
  String get noDues;

  /// No description provided for @staffPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{amount}'**
  String staffPayAmount(String amount);

  /// No description provided for @staffJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String staffJoined(String date);

  /// No description provided for @staffSalaryPerDay.
  ///
  /// In en, this message translates to:
  /// **'₹{amount}/day'**
  String staffSalaryPerDay(String amount);

  /// No description provided for @staffSalaryPerMonth.
  ///
  /// In en, this message translates to:
  /// **'₹{amount}/month'**
  String staffSalaryPerMonth(String amount);

  /// No description provided for @staffPayButton.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get staffPayButton;

  /// No description provided for @businessReports.
  ///
  /// In en, this message translates to:
  /// **'Business Reports'**
  String get businessReports;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get revenueTrend;

  /// No description provided for @collectionSummary.
  ///
  /// In en, this message translates to:
  /// **'Collection Summary'**
  String get collectionSummary;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total Outstanding'**
  String get totalOutstanding;

  /// No description provided for @totalCollected.
  ///
  /// In en, this message translates to:
  /// **'Total Collected'**
  String get totalCollected;

  /// No description provided for @topCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get topCustomers;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @settingsManagePayments.
  ///
  /// In en, this message translates to:
  /// **'Manage payment accounts'**
  String get settingsManagePayments;

  /// No description provided for @settingsManageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts and reminders'**
  String get settingsManageAlerts;

  /// No description provided for @settingsAppPinFingerprint.
  ///
  /// In en, this message translates to:
  /// **'App PIN and Fingerprint'**
  String get settingsAppPinFingerprint;

  /// No description provided for @settingsFaqsContact.
  ///
  /// In en, this message translates to:
  /// **'FAQs and Contact Us'**
  String get settingsFaqsContact;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @myUpiIds.
  ///
  /// In en, this message translates to:
  /// **'My UPI IDs'**
  String get myUpiIds;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will see ledger updates, payment alerts and reminders here.'**
  String get noNotificationsSubtitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @quickPay.
  ///
  /// In en, this message translates to:
  /// **'Quick Pay'**
  String get quickPay;

  /// No description provided for @scanAndPay.
  ///
  /// In en, this message translates to:
  /// **'SCAN & PAY'**
  String get scanAndPay;

  /// No description provided for @scanUpiDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan any UPI QR to pay your vendor'**
  String get scanUpiDesc;

  /// No description provided for @noTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsTitle;

  /// No description provided for @noTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your payment history will appear here.'**
  String get noTransactionsSubtitle;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentStatusFailed;

  /// No description provided for @paymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentStatusRefunded;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepBooking;

  /// No description provided for @noBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'No bookings for this day'**
  String get noBookingsToday;

  /// No description provided for @noBookingsTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customers can book appointments through the app.'**
  String get noBookingsTodaySubtitle;

  /// No description provided for @noAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get noAppointmentsTitle;

  /// No description provided for @noAppointmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book an appointment with your vendor to get started.'**
  String get noAppointmentsSubtitle;

  /// No description provided for @cancelAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment?'**
  String get cancelAppointmentTitle;

  /// No description provided for @cancelAppointmentMessage.
  ///
  /// In en, this message translates to:
  /// **'Cancel your appointment on {date} at {time}?'**
  String cancelAppointmentMessage(String date, String time);

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get bookingStatusDone;

  /// No description provided for @upiPayment.
  ///
  /// In en, this message translates to:
  /// **'UPI Payment'**
  String get upiPayment;

  /// No description provided for @amountToPay.
  ///
  /// In en, this message translates to:
  /// **'Amount to pay'**
  String get amountToPay;

  /// No description provided for @securedByUpi.
  ///
  /// In en, this message translates to:
  /// **'Secured by UPI'**
  String get securedByUpi;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @retryPayment.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryPayment;

  /// No description provided for @enterUpiId.
  ///
  /// In en, this message translates to:
  /// **'Enter UPI ID'**
  String get enterUpiId;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addNoteOptional;

  /// No description provided for @payAmountButton.
  ///
  /// In en, this message translates to:
  /// **'PAY ₹{amount}'**
  String payAmountButton(String amount);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get done;

  /// No description provided for @paymentSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get paymentSomethingWentWrong;

  /// No description provided for @upiAppComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{app} integration coming soon'**
  String upiAppComingSoon(String app);

  /// No description provided for @pleaseEnterUpiId.
  ///
  /// In en, this message translates to:
  /// **'Please enter a UPI ID'**
  String get pleaseEnterUpiId;

  /// No description provided for @paidToRecipient.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} paid to {name}'**
  String paidToRecipient(String amount, String name);

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @addNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addNewCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @mobileNo.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNo;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'ADD CUSTOMER'**
  String get addCustomer;

  /// No description provided for @paymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PAYMENT'**
  String get paymentConfirmed;

  /// No description provided for @addAdvance.
  ///
  /// In en, this message translates to:
  /// **'Add Advance'**
  String get addAdvance;

  /// No description provided for @addAdvanceTitle.
  ///
  /// In en, this message translates to:
  /// **'ADD ADVANCE'**
  String get addAdvanceTitle;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @salaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary Summary'**
  String get salaryTitle;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @daysPresent.
  ///
  /// In en, this message translates to:
  /// **'Days Present'**
  String get daysPresent;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @advanceTaken.
  ///
  /// In en, this message translates to:
  /// **'Advance Taken'**
  String get advanceTaken;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get noPhone;

  /// No description provided for @addNewStaff.
  ///
  /// In en, this message translates to:
  /// **'Add New Staff'**
  String get addNewStaff;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @salaryType.
  ///
  /// In en, this message translates to:
  /// **'Salary Type'**
  String get salaryType;

  /// No description provided for @dailyWage.
  ///
  /// In en, this message translates to:
  /// **'Daily Wage'**
  String get dailyWage;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary'**
  String get monthlySalary;

  /// No description provided for @dailyWageAmount.
  ///
  /// In en, this message translates to:
  /// **'Daily Wage (₹)'**
  String get dailyWageAmount;

  /// No description provided for @monthlySalaryAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary (₹)'**
  String get monthlySalaryAmount;

  /// No description provided for @addStaffButton.
  ///
  /// In en, this message translates to:
  /// **'ADD STAFF'**
  String get addStaffButton;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @amountRupees.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get amountRupees;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @alignBillInFrame.
  ///
  /// In en, this message translates to:
  /// **'Align bill within the frame'**
  String get alignBillInFrame;

  /// No description provided for @verifyAndLogin.
  ///
  /// In en, this message translates to:
  /// **'Verify & Login'**
  String get verifyAndLogin;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get voiceListening;

  /// No description provided for @voiceThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get voiceThinking;

  /// No description provided for @voiceDetectedEntry.
  ///
  /// In en, this message translates to:
  /// **'Detected Entry'**
  String get voiceDetectedEntry;

  /// No description provided for @voiceConfirmEntry.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM ENTRY'**
  String get voiceConfirmEntry;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @totalOutstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Outstanding Balance'**
  String get totalOutstandingBalance;

  /// No description provided for @payAllDues.
  ///
  /// In en, this message translates to:
  /// **'PAY ALL DUES'**
  String get payAllDues;

  /// No description provided for @myKhatas.
  ///
  /// In en, this message translates to:
  /// **'My Khatas'**
  String get myKhatas;

  /// No description provided for @noVendorsFound.
  ///
  /// In en, this message translates to:
  /// **'No vendors found'**
  String get noVendorsFound;

  /// No description provided for @verifyBillDetails.
  ///
  /// In en, this message translates to:
  /// **'Verify Bill Details'**
  String get verifyBillDetails;

  /// No description provided for @scannedBillPreview.
  ///
  /// In en, this message translates to:
  /// **'Scanned Bill Preview'**
  String get scannedBillPreview;

  /// No description provided for @descriptionItemDetails.
  ///
  /// In en, this message translates to:
  /// **'Description / Item Details'**
  String get descriptionItemDetails;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get selectCustomer;

  /// No description provided for @searchCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Search or select customer'**
  String get searchCustomerHint;

  /// No description provided for @saveToKhata.
  ///
  /// In en, this message translates to:
  /// **'SAVE TO KHATA'**
  String get saveToKhata;

  /// No description provided for @allCustomersReport.
  ///
  /// In en, this message translates to:
  /// **'All Customers Report'**
  String get allCustomersReport;

  /// No description provided for @collectedInMonth.
  ///
  /// In en, this message translates to:
  /// **'Collected in {month}'**
  String collectedInMonth(String month);

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @securityPin.
  ///
  /// In en, this message translates to:
  /// **'Security & PIN'**
  String get securityPin;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @legalInfo.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalInfo;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'CHANGE PASSWORD'**
  String get changePasswordButton;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @loadingContent.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingContent;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load content. Please try again.'**
  String get failedToLoad;

  /// No description provided for @bookingActions.
  ///
  /// In en, this message translates to:
  /// **'Booking Actions'**
  String get bookingActions;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markComplete;

  /// No description provided for @confirmBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirm the appointment on {date} at {time} for {customer}?'**
  String confirmBookingMessage(String date, String time, String customer);

  /// No description provided for @bookingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Booking updated successfully'**
  String get bookingUpdated;

  /// No description provided for @bookingUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update booking'**
  String get bookingUpdateFailed;

  /// No description provided for @markAttendanceFor.
  ///
  /// In en, this message translates to:
  /// **'Mark Attendance — {date}'**
  String markAttendanceFor(String date);

  /// No description provided for @allCustomers.
  ///
  /// In en, this message translates to:
  /// **'All Customers'**
  String get allCustomers;

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersYet;

  /// No description provided for @noCustomersYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer to get started'**
  String get noCustomersYetSubtitle;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number starting with 6–9'**
  String get invalidPhone;

  /// No description provided for @accrueMonthSalary.
  ///
  /// In en, this message translates to:
  /// **'Add Month\'s Salary (₹{amount})'**
  String accrueMonthSalary(String amount);

  /// No description provided for @accrueMonthSalaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Month\'s Salary'**
  String get accrueMonthSalaryTitle;

  /// No description provided for @removeStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Staff Member'**
  String get removeStaffTitle;

  /// No description provided for @removeStaffConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from your staff? This will revoke their app access immediately.'**
  String removeStaffConfirm(String name);

  /// No description provided for @accrueMonthSalaryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add ₹{amount} to {name}\'s unpaid balance for this month?'**
  String accrueMonthSalaryConfirm(String name, String amount);

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @updateProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Update your name, photo and details'**
  String get updateProfileDetails;

  /// No description provided for @updateAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get updateAccountPassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteAccountConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all your data. This action cannot be undone.'**
  String get deleteAccountConfirmationMessage;

  /// No description provided for @deleteAccountStaffWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account. This cannot be undone.'**
  String get deleteAccountStaffWarning;

  /// No description provided for @deleteAccountStrongWarning.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account is permanent and cannot be undone. Please read carefully before continuing:'**
  String get deleteAccountStrongWarning;

  /// No description provided for @deleteAccountWarningLoginRemoved.
  ///
  /// In en, this message translates to:
  /// **'You will immediately lose the ability to log in.'**
  String get deleteAccountWarningLoginRemoved;

  /// No description provided for @deleteAccountWarningIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be reversed — there is no way to recover your account afterward.'**
  String get deleteAccountWarningIrreversible;

  /// No description provided for @deleteAccountWarningRecordsKept.
  ///
  /// In en, this message translates to:
  /// **'Your ledger entries, payments, delivery proofs and statements are kept for financial record-keeping and legal/audit purposes — they are never deleted.'**
  String get deleteAccountWarningRecordsKept;

  /// No description provided for @deleteAccountWarningVendorBlockers.
  ///
  /// In en, this message translates to:
  /// **'You must settle all outstanding balances, remove or pay staff, and resolve pending orders/deliveries and subscriptions before you can delete your account.'**
  String get deleteAccountWarningVendorBlockers;

  /// No description provided for @deleteAccountWarningStaffBlockers.
  ///
  /// In en, this message translates to:
  /// **'You must have no unpaid salary, outstanding advance, or unfinished assigned work before you can delete your account.'**
  String get deleteAccountWarningStaffBlockers;

  /// No description provided for @deleteAccountWarningCustomerBlockers.
  ///
  /// In en, this message translates to:
  /// **'You must settle all outstanding balances and have no active orders before you can delete your account.'**
  String get deleteAccountWarningCustomerBlockers;

  /// No description provided for @iUnderstandContinue.
  ///
  /// In en, this message translates to:
  /// **'I Understand, Continue'**
  String get iUnderstandContinue;

  /// No description provided for @deleteAccountTypeToConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get deleteAccountTypeToConfirmTitle;

  /// No description provided for @deleteAccountTypeToConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'To confirm you want to permanently delete your account, type DELETE below.'**
  String get deleteAccountTypeToConfirmMessage;

  /// No description provided for @deleteAccountEnterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get deleteAccountEnterOtpTitle;

  /// No description provided for @deleteAccountEnterOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit OTP to your registered phone number. Enter it to confirm account deletion.'**
  String get deleteAccountEnterOtpMessage;

  /// No description provided for @deleteAccountEnterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get deleteAccountEnterPasswordTitle;

  /// No description provided for @deleteAccountEnterPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your account password to confirm account deletion.'**
  String get deleteAccountEnterPasswordMessage;

  /// No description provided for @deleteAccountBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t Delete Account Yet'**
  String get deleteAccountBlockedTitle;

  /// No description provided for @deleteAccountBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please resolve the following before deleting your account:'**
  String get deleteAccountBlockedMessage;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @readTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readTermsOfService;

  /// No description provided for @privacyPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get privacyPolicyDescription;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @membershipTiers.
  ///
  /// In en, this message translates to:
  /// **'Membership Tiers'**
  String get membershipTiers;

  /// No description provided for @membershipTiersDescription.
  ///
  /// In en, this message translates to:
  /// **'Rename tiers and set member discounts'**
  String get membershipTiersDescription;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @enterPhoneNumberToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneNumberToContinue;

  /// No description provided for @havingTrouble.
  ///
  /// In en, this message translates to:
  /// **'Having trouble?'**
  String get havingTrouble;

  /// No description provided for @useEmailInstead.
  ///
  /// In en, this message translates to:
  /// **'Use email instead →'**
  String get useEmailInstead;

  /// No description provided for @logInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in with email'**
  String get logInWithEmail;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailPlaceholder;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @tapToAddProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add profile photo'**
  String get tapToAddProfilePhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addUpiId.
  ///
  /// In en, this message translates to:
  /// **'Add UPI ID'**
  String get addUpiId;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @paymentVerification.
  ///
  /// In en, this message translates to:
  /// **'Payment Verification'**
  String get paymentVerification;

  /// No description provided for @verifyingPayment.
  ///
  /// In en, this message translates to:
  /// **'Verifying Payment'**
  String get verifyingPayment;

  /// No description provided for @paymentConfirmedExclamation.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmed!'**
  String get paymentConfirmedExclamation;

  /// No description provided for @verificationTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Verification Timed Out'**
  String get verificationTimedOut;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @payDues.
  ///
  /// In en, this message translates to:
  /// **'Pay Dues'**
  String get payDues;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All Done!'**
  String get allDone;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noUpcomingAppointments;

  /// No description provided for @myPay.
  ///
  /// In en, this message translates to:
  /// **'My Pay'**
  String get myPay;

  /// No description provided for @myPaymentQr.
  ///
  /// In en, this message translates to:
  /// **'My Payment QR'**
  String get myPaymentQr;

  /// No description provided for @showMyQr.
  ///
  /// In en, this message translates to:
  /// **'Show my QR'**
  String get showMyQr;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPaymentsYet;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @paymentHistory6Months.
  ///
  /// In en, this message translates to:
  /// **'Payment History (6 months)'**
  String get paymentHistory6Months;

  /// No description provided for @connectionRequest.
  ///
  /// In en, this message translates to:
  /// **'Connection Request'**
  String get connectionRequest;

  /// No description provided for @vendorWantsToConnect.
  ///
  /// In en, this message translates to:
  /// **'A vendor wants to connect'**
  String get vendorWantsToConnect;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptRequest;

  /// No description provided for @declineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineRequest;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @requestSentNotification.
  ///
  /// In en, this message translates to:
  /// **'Request sent! They will be notified to confirm.'**
  String get requestSentNotification;

  /// No description provided for @awaitingAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Acceptance'**
  String get awaitingAcceptance;

  /// No description provided for @addAVendor.
  ///
  /// In en, this message translates to:
  /// **'Add a Vendor'**
  String get addAVendor;

  /// No description provided for @findByPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Find by phone number or email'**
  String get findByPhoneOrEmail;

  /// No description provided for @phoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmail;

  /// No description provided for @phoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile or email address'**
  String get phoneOrEmailHint;

  /// No description provided for @nicknameOptional.
  ///
  /// In en, this message translates to:
  /// **'Nickname (optional)'**
  String get nicknameOptional;

  /// No description provided for @howYouKnowVendor.
  ///
  /// In en, this message translates to:
  /// **'How you know this vendor'**
  String get howYouKnowVendor;

  /// No description provided for @bookingNoteExample.
  ///
  /// In en, this message translates to:
  /// **'E.g. Need extra milk today'**
  String get bookingNoteExample;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @moveMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Move the map to select a location'**
  String get moveMapToSelectLocation;

  /// No description provided for @searchPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a place…'**
  String get searchPlaceHint;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @searchVendorsHint.
  ///
  /// In en, this message translates to:
  /// **'Search vendors…'**
  String get searchVendorsHint;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @payViaUpi.
  ///
  /// In en, this message translates to:
  /// **'Pay via UPI'**
  String get payViaUpi;

  /// No description provided for @connectWithVendor.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectWithVendor;

  /// No description provided for @requestConnection.
  ///
  /// In en, this message translates to:
  /// **'Request Connection'**
  String get requestConnection;

  /// No description provided for @addVendor.
  ///
  /// In en, this message translates to:
  /// **'Add Vendor'**
  String get addVendor;

  /// No description provided for @noOutstandingBalances.
  ///
  /// In en, this message translates to:
  /// **'No outstanding balances'**
  String get noOutstandingBalances;

  /// No description provided for @allCustomersSettledUp.
  ///
  /// In en, this message translates to:
  /// **'All customers are settled up.'**
  String get allCustomersSettledUp;

  /// No description provided for @nothingCollectedToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing collected today'**
  String get nothingCollectedToday;

  /// No description provided for @paymentsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Payments received today will appear here.'**
  String get paymentsWillAppearHere;

  /// No description provided for @customerReport.
  ///
  /// In en, this message translates to:
  /// **'Customer Report'**
  String get customerReport;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tapToStop;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @itemNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milk'**
  String get itemNameExample;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price ₹'**
  String get unitPrice;

  /// No description provided for @deliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliverTo;

  /// No description provided for @bulkCharge.
  ///
  /// In en, this message translates to:
  /// **'Bulk Charge'**
  String get bulkCharge;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @newProductService.
  ///
  /// In en, this message translates to:
  /// **'New Product / Service'**
  String get newProductService;

  /// No description provided for @updateProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Update name, unit or price'**
  String get updateProductDetails;

  /// No description provided for @defineProduct.
  ///
  /// In en, this message translates to:
  /// **'Define what you sell and its base price'**
  String get defineProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @productNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Daily Morning Milk'**
  String get productNameExample;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @unitExample.
  ///
  /// In en, this message translates to:
  /// **'litre / kg / piece'**
  String get unitExample;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price / unit (₹)'**
  String get pricePerUnit;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete product?'**
  String get deleteProductConfirmation;

  /// No description provided for @removeProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your product list?'**
  String removeProductConfirmation(String name);

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// No description provided for @addFirstProduct.
  ///
  /// In en, this message translates to:
  /// **'Add First Product'**
  String get addFirstProduct;

  /// No description provided for @setPriceToChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a price for {name}'**
  String setPriceToChargeTitle(String name);

  /// No description provided for @setPriceToChargeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This service has no unit or price set yet. Add them to charge customers for it.'**
  String get setPriceToChargeSubtitle;

  /// No description provided for @setPrice.
  ///
  /// In en, this message translates to:
  /// **'Set Price'**
  String get setPrice;

  /// No description provided for @renameTier.
  ///
  /// In en, this message translates to:
  /// **'Rename tier'**
  String get renameTier;

  /// No description provided for @tierName.
  ///
  /// In en, this message translates to:
  /// **'Tier name'**
  String get tierName;

  /// No description provided for @tierLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String tierLevel(int level);

  /// No description provided for @memberDiscount.
  ///
  /// In en, this message translates to:
  /// **'Member discount'**
  String get memberDiscount;

  /// No description provided for @discountFor.
  ///
  /// In en, this message translates to:
  /// **'Discount for {tier}'**
  String discountFor(String tier);

  /// No description provided for @flatAmount.
  ///
  /// In en, this message translates to:
  /// **'Flat ₹'**
  String get flatAmount;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discountPercent;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount amount (₹)'**
  String get discountAmount;

  /// No description provided for @percentExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get percentExample;

  /// No description provided for @amountExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get amountExample;

  /// No description provided for @maxDiscountPerDue.
  ///
  /// In en, this message translates to:
  /// **'Max discount per due (₹) — optional'**
  String get maxDiscountPerDue;

  /// No description provided for @maxDiscountExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 100 (leave blank for no cap)'**
  String get maxDiscountExample;

  /// No description provided for @saveDiscount.
  ///
  /// In en, this message translates to:
  /// **'Save discount'**
  String get saveDiscount;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @setTier.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setTier;

  /// No description provided for @changeTier.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeTier;

  /// No description provided for @applyMembership.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyMembership;

  /// No description provided for @removeMembership.
  ///
  /// In en, this message translates to:
  /// **'Remove membership'**
  String get removeMembership;

  /// No description provided for @removeLedgerConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove ledger?'**
  String get removeLedgerConfirmation;

  /// No description provided for @exportStatement.
  ///
  /// In en, this message translates to:
  /// **'Export Statement'**
  String get exportStatement;

  /// No description provided for @appAccess.
  ///
  /// In en, this message translates to:
  /// **'App access'**
  String get appAccess;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit Indian mobile number'**
  String get invalidPhoneNumber;

  /// No description provided for @enterAll6Digits.
  ///
  /// In en, this message translates to:
  /// **'Enter all 6 digits'**
  String get enterAll6Digits;

  /// No description provided for @enterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter all {count} digits'**
  String enterAllDigits(int count);

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailAddress;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidUpiFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid UPI ID format (e.g. name@upi)'**
  String get invalidUpiFormat;

  /// No description provided for @upiIdAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This UPI ID is already added'**
  String get upiIdAlreadyAdded;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'XXXXX XXXXX'**
  String get phonePlaceholder;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumberLabel;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @businessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business Info'**
  String get businessInfo;

  /// No description provided for @enterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtpTitle;

  /// No description provided for @sentToLabel.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentToLabel;

  /// No description provided for @noOtpReceived.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it?'**
  String get noOtpReceived;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @uploadingPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo...'**
  String get uploadingPhotoLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @iAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a'**
  String get iAmA;

  /// No description provided for @dualRoleExplanation.
  ///
  /// In en, this message translates to:
  /// **'You\'ll primarily use the Vendor experience. Your Customer account can be accessed separately.'**
  String get dualRoleExplanation;

  /// No description provided for @profileSavedPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile saved — photo could not be uploaded right now'**
  String get profileSavedPhotoFailed;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @addUpiIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Add UPI ID'**
  String get addUpiIdTitle;

  /// No description provided for @upiIdHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@upi'**
  String get upiIdHint;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @primaryUpiInfo.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY UPI ID'**
  String get primaryUpiInfo;

  /// No description provided for @primaryUpiDescription.
  ///
  /// In en, this message translates to:
  /// **'The primary ID is shared with customers for payment. Tap the star to switch which one is primary.'**
  String get primaryUpiDescription;

  /// No description provided for @upiIdCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} / {max} UPI IDs'**
  String upiIdCounter(int count, int max);

  /// No description provided for @primaryUpiIdTooltip.
  ///
  /// In en, this message translates to:
  /// **'Primary UPI ID'**
  String get primaryUpiIdTooltip;

  /// No description provided for @setAsPrimaryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Set as primary'**
  String get setAsPrimaryTooltip;

  /// No description provided for @primaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryLabel;

  /// No description provided for @removeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeButtonLabel;

  /// No description provided for @noUpiIdsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No UPI IDs yet'**
  String get noUpiIdsEmpty;

  /// No description provided for @upiEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add up to 5 UPI IDs. Your primary ID will be shared with customers for payment.'**
  String get upiEmptyDescription;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new one.'**
  String get changePasswordSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @goBackButton.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBackButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// No description provided for @languageMarathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get languageMarathi;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamil;

  /// No description provided for @languageTelugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get languageTelugu;

  /// No description provided for @languageKannada.
  ///
  /// In en, this message translates to:
  /// **'Kannada'**
  String get languageKannada;

  /// No description provided for @languageGujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get languageGujarati;

  /// No description provided for @languagePunjabi.
  ///
  /// In en, this message translates to:
  /// **'Punjabi'**
  String get languagePunjabi;

  /// No description provided for @languageMalayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get languageMalayalam;

  /// No description provided for @languageBhojpuri.
  ///
  /// In en, this message translates to:
  /// **'Bhojpuri'**
  String get languageBhojpuri;

  /// No description provided for @languageMaithili.
  ///
  /// In en, this message translates to:
  /// **'Maithili'**
  String get languageMaithili;

  /// No description provided for @needPasswordForEmail.
  ///
  /// In en, this message translates to:
  /// **'You need a password set on your account to use this.\nSet one from Settings → Change Password.'**
  String get needPasswordForEmail;

  /// No description provided for @usePhoneInstead.
  ///
  /// In en, this message translates to:
  /// **'Use phone number instead →'**
  String get usePhoneInstead;

  /// No description provided for @sessionExpiredVerifyPhoneAgain.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please verify your phone again.'**
  String get sessionExpiredVerifyPhoneAgain;

  /// No description provided for @upiIdsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'UPI IDs saved successfully'**
  String get upiIdsSavedSuccessfully;

  /// No description provided for @chooseYourLanguageHindi.
  ///
  /// In en, this message translates to:
  /// **'आपकी भाषा चुनें'**
  String get chooseYourLanguageHindi;

  /// No description provided for @unknownLanguage.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLanguage;

  /// No description provided for @businessCategoryMilkDairy.
  ///
  /// In en, this message translates to:
  /// **'Milk / Dairy'**
  String get businessCategoryMilkDairy;

  /// No description provided for @businessCategoryPressDhobi.
  ///
  /// In en, this message translates to:
  /// **'Press / Dhobi'**
  String get businessCategoryPressDhobi;

  /// No description provided for @businessCategoryMaidCook.
  ///
  /// In en, this message translates to:
  /// **'Maid / Cook'**
  String get businessCategoryMaidCook;

  /// No description provided for @businessCategoryNewspaper.
  ///
  /// In en, this message translates to:
  /// **'Newspaper'**
  String get businessCategoryNewspaper;

  /// No description provided for @businessCategoryWaterCan.
  ///
  /// In en, this message translates to:
  /// **'Water Can'**
  String get businessCategoryWaterCan;

  /// No description provided for @businessCategoryTiffinFood.
  ///
  /// In en, this message translates to:
  /// **'Tiffin / Food'**
  String get businessCategoryTiffinFood;

  /// No description provided for @businessCategoryKiranaGrocery.
  ///
  /// In en, this message translates to:
  /// **'Kirana / Grocery'**
  String get businessCategoryKiranaGrocery;

  /// No description provided for @businessCategorySalonParlour.
  ///
  /// In en, this message translates to:
  /// **'Salon / Parlour'**
  String get businessCategorySalonParlour;

  /// No description provided for @businessCategoryConstructionLabour.
  ///
  /// In en, this message translates to:
  /// **'Construction Labour'**
  String get businessCategoryConstructionLabour;

  /// No description provided for @businessCategoryTransportAuto.
  ///
  /// In en, this message translates to:
  /// **'Transport / Auto'**
  String get businessCategoryTransportAuto;

  /// No description provided for @businessCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get businessCategoryOther;

  /// No description provided for @bookAnAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book an Appointment'**
  String get bookAnAppointment;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available'**
  String get noSlotsAvailable;

  /// No description provided for @trySelectingDifferentDate.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different date'**
  String get trySelectingDifferentDate;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Slots'**
  String get availableSlots;

  /// No description provided for @bookingConfirmedToast.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmedToast;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @editProductMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductMenuItem;

  /// No description provided for @deleteProductMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProductMenuItem;

  /// No description provided for @noProductsYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Define the items you sell — milk, paneer, etc. — once, then use them every day.'**
  String get noProductsYetDescription;

  /// No description provided for @selectProductToAssignQty.
  ///
  /// In en, this message translates to:
  /// **'Select a product above to assign quantities'**
  String get selectProductToAssignQty;

  /// No description provided for @noCustomersLinked.
  ///
  /// In en, this message translates to:
  /// **'No customers linked yet'**
  String get noCustomersLinked;

  /// No description provided for @chargeAll.
  ///
  /// In en, this message translates to:
  /// **'Charge All'**
  String get chargeAll;

  /// No description provided for @chargedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Charged {count} customer successfully'**
  String chargedSuccessfully(int count);

  /// No description provided for @chargedSuccessfullyPlural.
  ///
  /// In en, this message translates to:
  /// **'Charged {count} customers successfully'**
  String chargedSuccessfullyPlural(int count);

  /// No description provided for @chargedPartial.
  ///
  /// In en, this message translates to:
  /// **'{ok} charged, {fail} failed'**
  String chargedPartial(int ok, int fail);

  /// No description provided for @bulkSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'{count} customer  •  {qty} {unit}'**
  String bulkSummaryLine(int count, String qty, String unit);

  /// No description provided for @bulkSummaryLinePlural.
  ///
  /// In en, this message translates to:
  /// **'{count} customers  •  {qty} {unit}'**
  String bulkSummaryLinePlural(int count, String qty, String unit);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} total'**
  String totalAmount(String amount);

  /// No description provided for @appointmentNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {vendorName} · {date} at {time}'**
  String appointmentNext(String vendorName, String date, String time);

  /// No description provided for @outstandingShortLabel.
  ///
  /// In en, this message translates to:
  /// **'outstanding'**
  String get outstandingShortLabel;

  /// No description provided for @payViaUpiAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{amount} via UPI'**
  String payViaUpiAmount(String amount);

  /// No description provided for @paymentSummarySkipped.
  ///
  /// In en, this message translates to:
  /// **'Paid {count} vendors, skipped {skipped}.'**
  String paymentSummarySkipped(int count, int skipped);

  /// No description provided for @paymentSummarySkippedSingular.
  ///
  /// In en, this message translates to:
  /// **'Paid {count} vendor, skipped {skipped}.'**
  String paymentSummarySkippedSingular(int count, int skipped);

  /// No description provided for @paymentSummaryComplete.
  ///
  /// In en, this message translates to:
  /// **'Paid all {count} vendors.'**
  String paymentSummaryComplete(int count);

  /// No description provided for @paymentSummaryCompleteSingular.
  ///
  /// In en, this message translates to:
  /// **'Paid all {count} vendor.'**
  String paymentSummaryCompleteSingular(int count);

  /// No description provided for @tapToAcceptOrDecline.
  ///
  /// In en, this message translates to:
  /// **'Tap to accept or decline'**
  String get tapToAcceptOrDecline;

  /// No description provided for @helpSupportContactPrefix.
  ///
  /// In en, this message translates to:
  /// **'For any assistance, reach out to us at:'**
  String get helpSupportContactPrefix;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'igurus@info.in'**
  String get supportEmail;

  /// No description provided for @bookButton.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookButton;

  /// No description provided for @waitingForVendorAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to accept your request.'**
  String waitingForVendorAcceptance(String name);

  /// No description provided for @vendorWantsToConnectAsCustomer.
  ///
  /// In en, this message translates to:
  /// **'A vendor wants to connect'**
  String get vendorWantsToConnectAsCustomer;

  /// No description provided for @vendorWantsToConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'They want to add you as a customer and track your account.'**
  String get vendorWantsToConnectDesc;

  /// No description provided for @someoneWantsToConnect.
  ///
  /// In en, this message translates to:
  /// **'Someone wants to connect'**
  String get someoneWantsToConnect;

  /// No description provided for @someoneWantsToConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'They will be added as a customer to your account.'**
  String get someoneWantsToConnectDesc;

  /// No description provided for @requestedTimeAgo.
  ///
  /// In en, this message translates to:
  /// **'Requested {time}'**
  String requestedTimeAgo(String time);

  /// No description provided for @connectedVendorLinked.
  ///
  /// In en, this message translates to:
  /// **'Connected! {name} is now linked to your account.'**
  String connectedVendorLinked(String name);

  /// No description provided for @requestDeclinedFrom.
  ///
  /// In en, this message translates to:
  /// **'Request from {name} declined.'**
  String requestDeclinedFrom(String name);

  /// No description provided for @connectedCustomerLinked.
  ///
  /// In en, this message translates to:
  /// **'Connected! {name} is now linked to your business.'**
  String connectedCustomerLinked(String name);

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get processing;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @memberDiscountDescription.
  ///
  /// In en, this message translates to:
  /// **'Members on this tier get this discount on their dues.'**
  String get memberDiscountDescription;

  /// No description provided for @discountValueInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than 0'**
  String get discountValueInvalid;

  /// No description provided for @percentageExceedsMax.
  ///
  /// In en, this message translates to:
  /// **'Percentage cannot exceed 100'**
  String get percentageExceedsMax;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @membershipLabel.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membershipLabel;

  /// No description provided for @noMembership.
  ///
  /// In en, this message translates to:
  /// **'No membership'**
  String get noMembership;

  /// No description provided for @applyForMembership.
  ///
  /// In en, this message translates to:
  /// **'Apply for membership'**
  String get applyForMembership;

  /// No description provided for @setMembershipTier.
  ///
  /// In en, this message translates to:
  /// **'Set membership tier'**
  String get setMembershipTier;

  /// No description provided for @chooseTierToRequestFromVendor.
  ///
  /// In en, this message translates to:
  /// **'Choose a tier to request from this vendor'**
  String get chooseTierToRequestFromVendor;

  /// No description provided for @chooseTierFor.
  ///
  /// In en, this message translates to:
  /// **'Choose a tier for {customerName}'**
  String chooseTierFor(String customerName);

  /// No description provided for @setButton.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setButton;

  /// No description provided for @changeButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeButton;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @approveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveButton;

  /// No description provided for @customerRequestedTier.
  ///
  /// In en, this message translates to:
  /// **'{customerName} requested {tierName}'**
  String customerRequestedTier(String customerName, String tierName);

  /// No description provided for @requestedTierAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Requested {tierName} — awaiting approval'**
  String requestedTierAwaiting(String tierName);

  /// No description provided for @verificationConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to your bank…'**
  String get verificationConnecting;

  /// No description provided for @verificationVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying transaction…'**
  String get verificationVerifying;

  /// No description provided for @verificationWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for confirmation…'**
  String get verificationWaiting;

  /// No description provided for @verificationAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there…'**
  String get verificationAlmostThere;

  /// No description provided for @verificationDoNotClose.
  ///
  /// In en, this message translates to:
  /// **'Do not close this screen'**
  String get verificationDoNotClose;

  /// No description provided for @verificationElapsed.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s  •  Do not close this screen'**
  String verificationElapsed(int seconds);

  /// No description provided for @txnLabel.
  ///
  /// In en, this message translates to:
  /// **'Txn: {txnId}'**
  String txnLabel(String txnId);

  /// No description provided for @paidAmountToRecipient.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} paid to {name}'**
  String paidAmountToRecipient(String amount, String name);

  /// No description provided for @verificationTimeoutBody.
  ///
  /// In en, this message translates to:
  /// **'We could not confirm your payment within 30 seconds. Your money may NOT have been debited — please check your bank statement before retrying.'**
  String get verificationTimeoutBody;

  /// No description provided for @ifDebitedContactSupport.
  ///
  /// In en, this message translates to:
  /// **'If debited, contact support with Txn ID.'**
  String get ifDebitedContactSupport;

  /// No description provided for @thisMonthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonthSubtitle;

  /// No description provided for @billedNet.
  ///
  /// In en, this message translates to:
  /// **'Billed (net)'**
  String get billedNet;

  /// No description provided for @exclDisputed.
  ///
  /// In en, this message translates to:
  /// **'excl. disputed'**
  String get exclDisputed;

  /// No description provided for @receivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get receivedLabel;

  /// No description provided for @paymentsAndAdj.
  ///
  /// In en, this message translates to:
  /// **'payments & adj.'**
  String get paymentsAndAdj;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @paymentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} payment'**
  String paymentCount(int count);

  /// No description provided for @paymentCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} payments'**
  String paymentCountPlural(int count);

  /// No description provided for @customersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} customers'**
  String customersCount(int count);

  /// No description provided for @rankedByOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Ranked by outstanding balance'**
  String get rankedByOutstanding;

  /// No description provided for @collectedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} this month'**
  String collectedThisMonth(String amount);

  /// No description provided for @collectedThisMonthShort.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} this mo.'**
  String collectedThisMonthShort(String amount);

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @findVendorsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find vendors near you'**
  String get findVendorsNearYou;

  /// No description provided for @searchByNameOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Search by name, business name,\nor select a category above.'**
  String get searchByNameOrCategory;

  /// No description provided for @noResultsForQuery.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\".\nTry a different name or category.'**
  String noResultsForQuery(String query);

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @upiLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upiLabel;

  /// No description provided for @upiIdLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiIdLabel;

  /// No description provided for @upiEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI / Email'**
  String get upiEmailLabel;

  /// No description provided for @couldNotLoadRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load — tap to retry'**
  String get couldNotLoadRetry;

  /// No description provided for @labelCopied.
  ///
  /// In en, this message translates to:
  /// **'{label} copied!'**
  String labelCopied(String label);

  /// No description provided for @upiIdCopied.
  ///
  /// In en, this message translates to:
  /// **'UPI ID copied!'**
  String get upiIdCopied;

  /// No description provided for @requestSentButton.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSentButton;

  /// No description provided for @alreadyConnected.
  ///
  /// In en, this message translates to:
  /// **'Already Connected'**
  String get alreadyConnected;

  /// No description provided for @sendingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sendingEllipsis;

  /// No description provided for @sendConnectionRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Connection Request'**
  String get sendConnectionRequest;

  /// No description provided for @copyUpiIdToPay.
  ///
  /// In en, this message translates to:
  /// **'Copy UPI ID to Pay'**
  String get copyUpiIdToPay;

  /// No description provided for @requestSentToVendor.
  ///
  /// In en, this message translates to:
  /// **'Request sent! {name} will be notified.'**
  String requestSentToVendor(String name);

  /// No description provided for @byOwnerName.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String byOwnerName(String name);

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get confirmLogoutTitle;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @showQrToCollect.
  ///
  /// In en, this message translates to:
  /// **'Show this QR to a customer to collect payment directly to you.'**
  String get showQrToCollect;

  /// No description provided for @uploadQr.
  ///
  /// In en, this message translates to:
  /// **'Upload QR'**
  String get uploadQr;

  /// No description provided for @replaceQr.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceQr;

  /// No description provided for @qrUploaded.
  ///
  /// In en, this message translates to:
  /// **'QR uploaded'**
  String get qrUploaded;

  /// No description provided for @scanToPayName.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay {name}'**
  String scanToPayName(String name);

  /// No description provided for @salarySingle.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salarySingle;

  /// No description provided for @advanceSingle.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advanceSingle;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @balanceDue.
  ///
  /// In en, this message translates to:
  /// **'₹{balance} due'**
  String balanceDue(String balance);

  /// No description provided for @recordDeliveryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Record delivery'**
  String get recordDeliveryTooltip;

  /// No description provided for @viewLedgerTooltip.
  ///
  /// In en, this message translates to:
  /// **'View ledger'**
  String get viewLedgerTooltip;

  /// No description provided for @staffRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staff · {name}'**
  String staffRoleSubtitle(String name);

  /// No description provided for @recordDelivery.
  ///
  /// In en, this message translates to:
  /// **'Amount Pending'**
  String get recordDelivery;

  /// No description provided for @recordDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer took goods — add to their khata'**
  String get recordDeliverySubtitle;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Amount Received'**
  String get collectPayment;

  /// No description provided for @collectPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer paid — reduce their khata'**
  String get collectPaymentSubtitle;

  /// No description provided for @viewAll2.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll2;

  /// No description provided for @noCustomersStaff.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersStaff;

  /// No description provided for @myVendorsSection.
  ///
  /// In en, this message translates to:
  /// **'My Vendors'**
  String get myVendorsSection;

  /// No description provided for @shopsYouBuyFrom.
  ///
  /// In en, this message translates to:
  /// **'Shops you buy from'**
  String get shopsYouBuyFrom;

  /// No description provided for @awaitingAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Acceptance'**
  String get awaitingAcceptanceTitle;

  /// No description provided for @customersHaventConfirmed.
  ///
  /// In en, this message translates to:
  /// **'These customers haven\'t confirmed yet'**
  String get customersHaventConfirmed;

  /// No description provided for @pendingBadge.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingBadge;

  /// No description provided for @notifyCustomersWithDues.
  ///
  /// In en, this message translates to:
  /// **'Notify customers with dues'**
  String get notifyCustomersWithDues;

  /// No description provided for @linkANewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Link a new customer'**
  String get linkANewCustomer;

  /// No description provided for @dailyCharge.
  ///
  /// In en, this message translates to:
  /// **'Daily Charge'**
  String get dailyCharge;

  /// No description provided for @dailyChargeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set quantities & charge all at once'**
  String get dailyChargeSubtitle;

  /// No description provided for @findByPhoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Find by phone number or email'**
  String get findByPhoneOrEmailHint;

  /// No description provided for @phoneOrEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmailLabel;

  /// No description provided for @phoneMobileOrEmail.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile or email address'**
  String get phoneMobileOrEmail;

  /// No description provided for @nicknameOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname (optional)'**
  String get nicknameOptionalLabel;

  /// No description provided for @howYouKnowCustomer.
  ///
  /// In en, this message translates to:
  /// **'How you know this customer'**
  String get howYouKnowCustomer;

  /// No description provided for @requestSentWillBeNotified.
  ///
  /// In en, this message translates to:
  /// **'Request sent! They will be notified to confirm.'**
  String get requestSentWillBeNotified;

  /// No description provided for @outstandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstandingTitle;

  /// No description provided for @customersWithDues.
  ///
  /// In en, this message translates to:
  /// **'{count}+ customers with dues'**
  String customersWithDues(int count);

  /// No description provided for @dueLabel.
  ///
  /// In en, this message translates to:
  /// **'due'**
  String get dueLabel;

  /// No description provided for @collectedTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Collected Today'**
  String get collectedTodayTitle;

  /// No description provided for @paymentsCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count}+ payments'**
  String paymentsCountSubtitle(int count);

  /// No description provided for @noPaymentsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPaymentsYetSubtitle;

  /// No description provided for @removeLedgerVendorContent.
  ///
  /// In en, this message translates to:
  /// **'This will deactivate your link with {name}. Both parties will lose access to this shared ledger.'**
  String removeLedgerVendorContent(String name);

  /// No description provided for @removeLedgerCustomerContent.
  ///
  /// In en, this message translates to:
  /// **'This will remove your connection with {name}.'**
  String removeLedgerCustomerContent(String name);

  /// No description provided for @offlineUpdatesPaused.
  ///
  /// In en, this message translates to:
  /// **'Offline — updates paused'**
  String get offlineUpdatesPaused;

  /// No description provided for @exportStatementTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Statement'**
  String get exportStatementTitle;

  /// No description provided for @chooseExportDateRange.
  ///
  /// In en, this message translates to:
  /// **'Choose the date range to include in the PDF.'**
  String get chooseExportDateRange;

  /// No description provided for @last7DaysRange.
  ///
  /// In en, this message translates to:
  /// **'Entries from the past 7 days'**
  String get last7DaysRange;

  /// No description provided for @last30DaysRange.
  ///
  /// In en, this message translates to:
  /// **'Entries from the past 30 days'**
  String get last30DaysRange;

  /// No description provided for @last3MonthsRange.
  ///
  /// In en, this message translates to:
  /// **'Entries from the past 3 months'**
  String get last3MonthsRange;

  /// No description provided for @completeLedgerHistory.
  ///
  /// In en, this message translates to:
  /// **'Complete ledger history'**
  String get completeLedgerHistory;

  /// No description provided for @appAccessActive.
  ///
  /// In en, this message translates to:
  /// **'Active · {phone}'**
  String appAccessActive(String phone);

  /// No description provided for @appAccessDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get appAccessDisabled;

  /// No description provided for @appAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'{name} can now log in with {phone}'**
  String appAccessGranted(String name, String phone);

  /// No description provided for @appAccessRevoked.
  ///
  /// In en, this message translates to:
  /// **'App access revoked for {name}'**
  String appAccessRevoked(String name);

  /// No description provided for @appAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'When on, {name} logs in with their own number ({phone}) and can record deliveries & payments and show their own QR — but cannot change attendance, add customers, or see other staff.'**
  String appAccessDescription(String name, String phone);

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistoryTitle;

  /// No description provided for @couldNotLoadPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load payment history'**
  String get couldNotLoadPaymentHistory;

  /// No description provided for @voicePleaseCheck.
  ///
  /// In en, this message translates to:
  /// **'Please check'**
  String get voicePleaseCheck;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @totalRupees.
  ///
  /// In en, this message translates to:
  /// **'Total: ₹{amount}'**
  String totalRupees(String amount);

  /// No description provided for @selectCustomerFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a customer first'**
  String get selectCustomerFirst;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @addsCredit.
  ///
  /// In en, this message translates to:
  /// **'Customer took goods — add to their khata'**
  String get addsCredit;

  /// No description provided for @recordsCash.
  ///
  /// In en, this message translates to:
  /// **'Customer paid — reduce their khata'**
  String get recordsCash;

  /// No description provided for @deliveryRecordedFor.
  ///
  /// In en, this message translates to:
  /// **'Delivery recorded for {name}'**
  String deliveryRecordedFor(String name);

  /// No description provided for @paymentCollectedFrom.
  ///
  /// In en, this message translates to:
  /// **'Payment collected from {name}'**
  String paymentCollectedFrom(String name);

  /// No description provided for @manageSchedule.
  ///
  /// In en, this message translates to:
  /// **'Manage Schedule'**
  String get manageSchedule;

  /// No description provided for @bookingsTab.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTab;

  /// No description provided for @bySlotTab.
  ///
  /// In en, this message translates to:
  /// **'By Slot'**
  String get bySlotTab;

  /// No description provided for @scheduleSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved!'**
  String get scheduleSaved;

  /// No description provided for @addSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Slot'**
  String get addSlot;

  /// No description provided for @noSlotsForDay.
  ///
  /// In en, this message translates to:
  /// **'No slots for {day}'**
  String noSlotsForDay(String day);

  /// No description provided for @tapAddSlotHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Slot\" to set your availability'**
  String get tapAddSlotHint;

  /// No description provided for @slotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get slotAvailable;

  /// No description provided for @slotsFull.
  ///
  /// In en, this message translates to:
  /// **'Slots Full'**
  String get slotsFull;

  /// No description provided for @slotFullHint.
  ///
  /// In en, this message translates to:
  /// **'Mark this slot as fully booked'**
  String get slotFullHint;

  /// No description provided for @enableSlotFirst.
  ///
  /// In en, this message translates to:
  /// **'Enable slot first'**
  String get enableSlotFirst;

  /// No description provided for @deleteSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Slot'**
  String get deleteSlotTitle;

  /// No description provided for @deleteSlotConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove the {time} slot?'**
  String deleteSlotConfirm(String time);

  /// No description provided for @endTimeAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeAfterStart;

  /// No description provided for @slotOverlaps.
  ///
  /// In en, this message translates to:
  /// **'This slot overlaps with an existing one'**
  String get slotOverlaps;

  /// No description provided for @addTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get addTimeSlot;

  /// No description provided for @editTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Edit Time Slot'**
  String get editTimeSlot;

  /// No description provided for @selectTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Select start and end time in 12-hour format'**
  String get selectTimeHint;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endLabel;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @notifTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifTabAll;

  /// No description provided for @notifTabBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get notifTabBookings;

  /// No description provided for @noBookingNotifications.
  ///
  /// In en, this message translates to:
  /// **'No booking notifications'**
  String get noBookingNotifications;

  /// No description provided for @noBookingNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Booking requests and updates will appear here'**
  String get noBookingNotificationsSubtitle;

  /// No description provided for @bookingPillLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingPillLabel;

  /// No description provided for @slotDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Slot Details'**
  String get slotDetailTitle;

  /// No description provided for @bookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} booking'**
  String bookingsCount(int count);

  /// No description provided for @bookingsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} bookings'**
  String bookingsCountPlural(int count);

  /// No description provided for @pendingCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCountLabel(int count);

  /// No description provided for @slotTimeRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String slotTimeRange(String start, String end);

  /// No description provided for @keepButton.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @weeklyTemplateTab.
  ///
  /// In en, this message translates to:
  /// **'Weekly Template'**
  String get weeklyTemplateTab;

  /// No description provided for @calendarTab.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTab;

  /// No description provided for @usingWeeklyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Using weekly template'**
  String get usingWeeklyTemplate;

  /// No description provided for @customForThisDate.
  ///
  /// In en, this message translates to:
  /// **'Custom for this date'**
  String get customForThisDate;

  /// No description provided for @closedBadge.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedBadge;

  /// No description provided for @markAsClosed.
  ///
  /// In en, this message translates to:
  /// **'Mark as closed'**
  String get markAsClosed;

  /// No description provided for @revertToTemplate.
  ///
  /// In en, this message translates to:
  /// **'Revert to template'**
  String get revertToTemplate;

  /// No description provided for @replicateToButton.
  ///
  /// In en, this message translates to:
  /// **'Replicate to…'**
  String get replicateToButton;

  /// No description provided for @replicateTargetWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get replicateTargetWeek;

  /// No description provided for @replicateTargetMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get replicateTargetMonth;

  /// No description provided for @replicateTargetMultipleMonths.
  ///
  /// In en, this message translates to:
  /// **'Multiple Months'**
  String get replicateTargetMultipleMonths;

  /// No description provided for @replicateMonthsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of months'**
  String get replicateMonthsCount;

  /// No description provided for @replicateStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get replicateStartDateLabel;

  /// No description provided for @applyReplicateButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyReplicateButton;

  /// No description provided for @replicateResultToast.
  ///
  /// In en, this message translates to:
  /// **'Applied to {applied} dates, skipped {skipped} already customized, {failed} failed'**
  String replicateResultToast(int applied, int skipped, int failed);

  /// No description provided for @selectModeButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectModeButton;

  /// No description provided for @cancelSelectButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelSelectButton;

  /// No description provided for @mergeSlotsButton.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get mergeSlotsButton;

  /// No description provided for @mergeNotContiguousHint.
  ///
  /// In en, this message translates to:
  /// **'Selected slots must be contiguous (touching or overlapping) to merge'**
  String get mergeNotContiguousHint;

  /// No description provided for @mergedCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Merged capacity'**
  String get mergedCapacityLabel;

  /// No description provided for @confirmMergeTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge slots?'**
  String get confirmMergeTitle;

  /// No description provided for @confirmMergeMessage.
  ///
  /// In en, this message translates to:
  /// **'This will merge the selected slots into {start} – {end}.'**
  String confirmMergeMessage(String start, String end);

  /// No description provided for @capacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacityLabel;

  /// No description provided for @duplicateSlotExists.
  ///
  /// In en, this message translates to:
  /// **'A slot with the exact same start and end time already exists'**
  String get duplicateSlotExists;

  /// No description provided for @bookedOfCapacity.
  ///
  /// In en, this message translates to:
  /// **'{count}/{capacity} booked'**
  String bookedOfCapacity(int count, int capacity);

  /// No description provided for @overCapacityWarning.
  ///
  /// In en, this message translates to:
  /// **'Over capacity by {count}'**
  String overCapacityWarning(int count);

  /// No description provided for @noSlotsVendorMayBeClosed.
  ///
  /// In en, this message translates to:
  /// **'No slots available — vendor may be closed on this date'**
  String get noSlotsVendorMayBeClosed;

  /// No description provided for @revertedToTemplateToast.
  ///
  /// In en, this message translates to:
  /// **'Reverted to weekly template'**
  String get revertedToTemplateToast;

  /// No description provided for @dateSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved custom slots for this date'**
  String get dateSavedToast;

  /// No description provided for @dateClosedToast.
  ///
  /// In en, this message translates to:
  /// **'Date marked as closed'**
  String get dateClosedToast;

  /// No description provided for @mergeSucceededToast.
  ///
  /// In en, this message translates to:
  /// **'Slots merged — tap Save to apply'**
  String get mergeSucceededToast;

  /// No description provided for @membershipPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership Plans'**
  String get membershipPlansTitle;

  /// No description provided for @newPlanButton.
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get newPlanButton;

  /// No description provided for @deletePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete plan?'**
  String get deletePlanTitle;

  /// No description provided for @deletePlanConfirm.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed. This cannot be undone.'**
  String deletePlanConfirm(String name);

  /// No description provided for @inactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveLabel;

  /// No description provided for @noBenefitsAdded.
  ///
  /// In en, this message translates to:
  /// **'No benefits added.'**
  String get noBenefitsAdded;

  /// No description provided for @noMembershipPlans.
  ///
  /// In en, this message translates to:
  /// **'No membership plans yet'**
  String get noMembershipPlans;

  /// No description provided for @tapNewPlanHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New Plan\" to create your first one.'**
  String get tapNewPlanHint;

  /// No description provided for @membershipRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership Requests'**
  String get membershipRequestsTitle;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @customersCanApplyHint.
  ///
  /// In en, this message translates to:
  /// **'Customers can apply for membership\nfrom their ledger screen.'**
  String get customersCanApplyHint;

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get noMembersYet;

  /// No description provided for @activeStat.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStat;

  /// No description provided for @mrrStat.
  ///
  /// In en, this message translates to:
  /// **'MRR'**
  String get mrrStat;

  /// No description provided for @expiringStat.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get expiringStat;

  /// No description provided for @allPlansFilter.
  ///
  /// In en, this message translates to:
  /// **'All Plans'**
  String get allPlansFilter;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count}d left'**
  String daysLeft(int count);

  /// No description provided for @daysLeftFull.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysLeftFull(int count);

  /// No description provided for @planNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get planNameLabel;

  /// No description provided for @planNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Gold Membership'**
  String get planNameHint;

  /// No description provided for @durationDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (days)'**
  String get durationDaysLabel;

  /// No description provided for @priceRupeesLabel.
  ///
  /// In en, this message translates to:
  /// **'Price ₹'**
  String get priceRupeesLabel;

  /// No description provided for @addBenefitButton.
  ///
  /// In en, this message translates to:
  /// **'Add benefit'**
  String get addBenefitButton;

  /// No description provided for @customLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customLabel;

  /// No description provided for @customAdvanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom advance ₹'**
  String get customAdvanceLabel;

  /// No description provided for @benefitLabel.
  ///
  /// In en, this message translates to:
  /// **'Benefit'**
  String get benefitLabel;

  /// No description provided for @benefitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4 haircuts'**
  String get benefitHint;

  /// No description provided for @planDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get planDetailsSection;

  /// No description provided for @benefitsSection.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefitsSection;

  /// No description provided for @advanceRequiredSection.
  ///
  /// In en, this message translates to:
  /// **'Advance required'**
  String get advanceRequiredSection;

  /// No description provided for @editPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get editPlanTitle;

  /// No description provided for @createPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Membership Plan'**
  String get createPlanTitle;

  /// No description provided for @publishPlanButton.
  ///
  /// In en, this message translates to:
  /// **'Publish Plan'**
  String get publishPlanButton;

  /// No description provided for @planUpdatedToast.
  ///
  /// In en, this message translates to:
  /// **'Plan updated'**
  String get planUpdatedToast;

  /// No description provided for @planPublishedToast.
  ///
  /// In en, this message translates to:
  /// **'Plan published'**
  String get planPublishedToast;

  /// No description provided for @vendorPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'{vendorName} · Plans'**
  String vendorPlansTitle(String vendorName);

  /// No description provided for @noPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plans available yet'**
  String get noPlansAvailable;

  /// No description provided for @vendorNoPlansHint.
  ///
  /// In en, this message translates to:
  /// **'This vendor hasn\'t created any membership plans.'**
  String get vendorNoPlansHint;

  /// No description provided for @applyForPlan.
  ///
  /// In en, this message translates to:
  /// **'Apply for {planName}'**
  String applyForPlan(String planName);

  /// No description provided for @messageToVendorOptional.
  ///
  /// In en, this message translates to:
  /// **'Message to vendor (optional)'**
  String get messageToVendorOptional;

  /// No description provided for @messageToVendorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Please enroll me for this month'**
  String get messageToVendorHint;

  /// No description provided for @sendRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequestButton;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @noAdditionalBenefits.
  ///
  /// In en, this message translates to:
  /// **'No additional benefits'**
  String get noAdditionalBenefits;

  /// No description provided for @currentPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlanLabel;

  /// No description provided for @requestPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Pending'**
  String get requestPendingLabel;

  /// No description provided for @applyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyLabel;

  /// No description provided for @requestSentToName.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {name}'**
  String requestSentToName(String name);

  /// No description provided for @membershipDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membershipDialogTitle;

  /// No description provided for @pendingPlanPrefix.
  ///
  /// In en, this message translates to:
  /// **'Pending: {planName}'**
  String pendingPlanPrefix(String planName);

  /// No description provided for @enrollCustomer.
  ///
  /// In en, this message translates to:
  /// **'Enroll {name}'**
  String enrollCustomer(String name);

  /// No description provided for @choosePlanHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan to start their membership.'**
  String get choosePlanHint;

  /// No description provided for @noActivePlansHint.
  ///
  /// In en, this message translates to:
  /// **'No active plans. Create one in Memberships → Plans first.'**
  String get noActivePlansHint;

  /// No description provided for @enrollLabel.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get enrollLabel;

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLabel;

  /// No description provided for @usedLabel.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get usedLabel;

  /// No description provided for @useLabel.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get useLabel;

  /// No description provided for @decreaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease usage count'**
  String get decreaseLabel;

  /// No description provided for @daysLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeftLabel(int count);

  /// No description provided for @orderPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderPlacedSuccess;

  /// No description provided for @orderFromVendor.
  ///
  /// In en, this message translates to:
  /// **'Order from {vendorName}'**
  String orderFromVendor(String vendorName);

  /// No description provided for @addItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemButton;

  /// No description provided for @orderNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Order note (optional)'**
  String get orderNoteOptional;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @placeOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrderButton;

  /// No description provided for @itemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Item name *'**
  String get itemNameRequired;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @unitHint.
  ///
  /// In en, this message translates to:
  /// **'kg, L…'**
  String get unitHint;

  /// No description provided for @unitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit ₹'**
  String get unitPriceLabel;

  /// No description provided for @itemNumber.
  ///
  /// In en, this message translates to:
  /// **'Item {number}'**
  String itemNumber(int number);

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal: ₹{amount}'**
  String subtotalLabel(String amount);

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @proofPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Proof photo'**
  String get proofPhotoLabel;

  /// No description provided for @tapToViewFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Tap to view full screen'**
  String get tapToViewFullScreen;

  /// No description provided for @rejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @markAsDeliveredButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markAsDeliveredButton;

  /// No description provided for @confirmDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDeliveryTitle;

  /// No description provided for @deliveryNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Delivery note (optional)'**
  String get deliveryNoteOptional;

  /// No description provided for @retakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakeLabel;

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Photo upload failed: {error}'**
  String photoUploadFailed(String error);

  /// No description provided for @orderNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Order note'**
  String get orderNoteLabel;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @markDeliveredButton.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get markDeliveredButton;

  /// No description provided for @myOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrdersTitle;

  /// No description provided for @deliverButton.
  ///
  /// In en, this message translates to:
  /// **'Deliver'**
  String get deliverButton;

  /// No description provided for @noPendingDeliveries.
  ///
  /// In en, this message translates to:
  /// **'No pending deliveries'**
  String get noPendingDeliveries;

  /// No description provided for @deliveriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get deliveriesTitle;

  /// No description provided for @monthlyStatementTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Statement'**
  String get monthlyStatementTitle;

  /// No description provided for @deliveryProofLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery proof'**
  String get deliveryProofLabel;

  /// No description provided for @replacePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Replace Photo'**
  String get replacePhotoButton;

  /// No description provided for @attachProofButton.
  ///
  /// In en, this message translates to:
  /// **'Attach Proof'**
  String get attachProofButton;

  /// No description provided for @uploadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingLabel;

  /// No description provided for @proofLockedHint.
  ///
  /// In en, this message translates to:
  /// **'This proof is locked and cannot be changed'**
  String get proofLockedHint;

  /// No description provided for @proofAttachedToast.
  ///
  /// In en, this message translates to:
  /// **'Proof attached'**
  String get proofAttachedToast;

  /// No description provided for @itemLabel.
  ///
  /// In en, this message translates to:
  /// **'Item {number}'**
  String itemLabel(int number);

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount *'**
  String get amountRequired;

  /// No description provided for @addItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItemLabel;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAmountLabel;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activeStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatLabel;

  /// No description provided for @mrrStatLabel.
  ///
  /// In en, this message translates to:
  /// **'MRR'**
  String get mrrStatLabel;

  /// No description provided for @expiringStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get expiringStatLabel;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @pendingPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending: {name}'**
  String pendingPlanLabel(String name);

  /// No description provided for @customerRequestedPlan.
  ///
  /// In en, this message translates to:
  /// **'{customer} requested {plan}'**
  String customerRequestedPlan(String customer, String plan);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String itemsCount(int count);

  /// No description provided for @deliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryLabel;

  /// No description provided for @markedDeliveredBy.
  ///
  /// In en, this message translates to:
  /// **'Marked delivered by {role}'**
  String markedDeliveredBy(String role);

  /// No description provided for @deliveriesHint.
  ///
  /// In en, this message translates to:
  /// **'Items delivered through orders. Tap an entry to see the items.'**
  String get deliveriesHint;

  /// No description provided for @scheduledServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Services'**
  String get scheduledServicesTitle;

  /// No description provided for @servicesTab.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// No description provided for @todaysDeliveriesTab.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Deliveries'**
  String get todaysDeliveriesTab;

  /// No description provided for @newService.
  ///
  /// In en, this message translates to:
  /// **'New Service'**
  String get newService;

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get noServicesYet;

  /// No description provided for @tapPlusToCreateService.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create a scheduled service'**
  String get tapPlusToCreateService;

  /// No description provided for @subscriberCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} subs'**
  String subscriberCountLabel(int count);

  /// No description provided for @noDeliveriesToday.
  ///
  /// In en, this message translates to:
  /// **'No deliveries today'**
  String get noDeliveriesToday;

  /// No description provided for @noDeliveriesMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No deliveries match your filters'**
  String get noDeliveriesMatchFilters;

  /// No description provided for @mySubscriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptionsTitle;

  /// No description provided for @deliveriesTab.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get deliveriesTab;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @noDeliveriesYet.
  ///
  /// In en, this message translates to:
  /// **'No deliveries yet'**
  String get noDeliveriesYet;

  /// No description provided for @serviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Name *'**
  String get serviceNameLabel;

  /// No description provided for @serviceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceTypeLabel;

  /// No description provided for @scheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleLabel;

  /// No description provided for @deliveryDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Days'**
  String get deliveryDaysLabel;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @autoCreateLedgerEntry.
  ///
  /// In en, this message translates to:
  /// **'Auto-create ledger entry'**
  String get autoCreateLedgerEntry;

  /// No description provided for @addToKhataAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Add to khata automatically on delivery'**
  String get addToKhataAutomatically;

  /// No description provided for @createServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get createServiceButton;

  /// No description provided for @selectAtLeastOneDeliveryDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one delivery day'**
  String get selectAtLeastOneDeliveryDay;

  /// No description provided for @fillNameUnitPriceEveryItem.
  ///
  /// In en, this message translates to:
  /// **'Fill in name, unit and price for every item'**
  String get fillNameUnitPriceEveryItem;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemNameLabel;

  /// No description provided for @priceRupeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get priceRupeeLabel;

  /// No description provided for @subscribersTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get subscribersTitle;

  /// No description provided for @addCustomerButton.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomerButton;

  /// No description provided for @noSubscribersYet.
  ///
  /// In en, this message translates to:
  /// **'No subscribers yet'**
  String get noSubscribersYet;

  /// No description provided for @deactivateServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Service'**
  String get deactivateServiceTitle;

  /// No description provided for @deactivateServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'This will stop all future deliveries. Active subscriptions will be unaffected until manually removed.'**
  String get deactivateServiceMessage;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @autoLedgerEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto Ledger Entry'**
  String get autoLedgerEntryLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @subscriptionStartsOn.
  ///
  /// In en, this message translates to:
  /// **'{summary} · starts {date}'**
  String subscriptionStartsOn(String summary, String date);

  /// No description provided for @amountPerDelivery.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} / delivery'**
  String amountPerDelivery(String amount);

  /// No description provided for @pausedLabel.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get pausedLabel;

  /// No description provided for @resumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeLabel;

  /// No description provided for @pauseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseLabel;

  /// No description provided for @deliveryDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetailsTitle;

  /// No description provided for @deliveryDueAt.
  ///
  /// In en, this message translates to:
  /// **'Due at {time}'**
  String deliveryDueAt(String time);

  /// No description provided for @deliveryDeliveredAt.
  ///
  /// In en, this message translates to:
  /// **'Delivered at {time}'**
  String deliveryDeliveredAt(String time);

  /// No description provided for @deliveryDeliveredBy.
  ///
  /// In en, this message translates to:
  /// **'Delivered by {name}'**
  String deliveryDeliveredBy(String name);

  /// No description provided for @deliveryPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Photo'**
  String get deliveryPhotoTitle;

  /// No description provided for @skipDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip Delivery'**
  String get skipDeliveryTitle;

  /// No description provided for @skipDeliveryMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark this delivery as skipped today?'**
  String get skipDeliveryMessage;

  /// No description provided for @confirmDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDeliveryButton;

  /// No description provided for @couldNotConfirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm delivery'**
  String get couldNotConfirmDelivery;

  /// No description provided for @dateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get dateTimeLabel;

  /// No description provided for @amountToAddToLedger.
  ///
  /// In en, this message translates to:
  /// **'Amount to add to ledger'**
  String get amountToAddToLedger;

  /// No description provided for @deliveryAutoLedgerNote.
  ///
  /// In en, this message translates to:
  /// **'This delivery will be added to the ledger automatically when confirmed — no need to add it again.'**
  String get deliveryAutoLedgerNote;

  /// No description provided for @deliveryPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'DELIVERY PHOTO (REQUIRED)'**
  String get deliveryPhotoRequired;

  /// No description provided for @addSubscriberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Subscriber'**
  String get addSubscriberTitle;

  /// No description provided for @selectCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get selectCustomerLabel;

  /// No description provided for @selectACustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Select a customer'**
  String get selectACustomerHint;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @setQuantityForOneItem.
  ///
  /// In en, this message translates to:
  /// **'Set a quantity for at least one item'**
  String get setQuantityForOneItem;

  /// No description provided for @customPriceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Custom price?'**
  String get customPriceQuestion;

  /// No description provided for @customPriceOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Price (₹, optional)'**
  String get customPriceOptionalLabel;

  /// No description provided for @allDeliveriesFilter.
  ///
  /// In en, this message translates to:
  /// **'All deliveries'**
  String get allDeliveriesFilter;

  /// No description provided for @clearAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllFilters;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @couldNotGetCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get current location'**
  String get couldNotGetCurrentLocation;

  /// No description provided for @filterDeliveriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Deliveries'**
  String get filterDeliveriesTitle;

  /// No description provided for @filterCustomerServiceName.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER / SERVICE NAME'**
  String get filterCustomerServiceName;

  /// No description provided for @filterSearchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get filterSearchByName;

  /// No description provided for @filterAnyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get filterAnyDate;

  /// No description provided for @filterRadiusFromLocation.
  ///
  /// In en, this message translates to:
  /// **'RADIUS FROM MY LOCATION'**
  String get filterRadiusFromLocation;

  /// No description provided for @applyFilterButton.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilterButton;

  /// No description provided for @withinKmLabel.
  ///
  /// In en, this message translates to:
  /// **'Within {km} km'**
  String withinKmLabel(String km);

  /// No description provided for @kmLabel.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String kmLabel(String km);

  /// No description provided for @serviceTypeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get serviceTypeProduct;

  /// No description provided for @serviceTypeSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get serviceTypeSession;

  /// No description provided for @scheduleTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get scheduleTypeDaily;

  /// No description provided for @scheduleTypeWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get scheduleTypeWeekly;

  /// No description provided for @scheduleTypeCustomDays.
  ///
  /// In en, this message translates to:
  /// **'Custom Days'**
  String get scheduleTypeCustomDays;

  /// No description provided for @deliveryStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get deliveryStatusScheduled;

  /// No description provided for @deliveryStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveryStatusDelivered;

  /// No description provided for @deliveryStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get deliveryStatusSkipped;

  /// No description provided for @deliveryStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get deliveryStatusFailed;

  /// No description provided for @scheduleTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get scheduleTypeCustom;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get orderStatusRejected;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @weekdayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShortSun;

  /// No description provided for @weekdayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShortSat;

  /// No description provided for @subscriptionItemsAmount.
  ///
  /// In en, this message translates to:
  /// **'{summary} · ₹{amount}'**
  String subscriptionItemsAmount(String summary, String amount);

  /// No description provided for @subscriptionNextDelivery.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String subscriptionNextDelivery(String date);

  /// No description provided for @subscriptionDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{date} · {summary}'**
  String subscriptionDeliverySubtitle(String date, String summary);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @callLabel.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callLabel;

  /// No description provided for @subscribeButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribeButton;

  /// No description provided for @invalidValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidValueLabel;

  /// No description provided for @resetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetLabel;

  /// No description provided for @itemPriceWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{name} ({unit}) · ₹{price}'**
  String itemPriceWithUnit(String name, String unit, String price);

  /// No description provided for @forCustomerName.
  ///
  /// In en, this message translates to:
  /// **'for {name}'**
  String forCustomerName(String name);

  /// No description provided for @deliveredByLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered by'**
  String get deliveredByLabel;

  /// No description provided for @staffQuickDelivery.
  ///
  /// In en, this message translates to:
  /// **'Quick Delivery'**
  String get staffQuickDelivery;

  /// No description provided for @staffQuickDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled with customer defaults'**
  String get staffQuickDeliverySubtitle;

  /// No description provided for @staffOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmed orders awaiting delivery'**
  String get staffOrdersSubtitle;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @noDefaultSet.
  ///
  /// In en, this message translates to:
  /// **'No default set'**
  String get noDefaultSet;

  /// No description provided for @photoUploadFailedNoError.
  ///
  /// In en, this message translates to:
  /// **'Photo upload failed'**
  String get photoUploadFailedNoError;

  /// No description provided for @deliverAndCharge.
  ///
  /// In en, this message translates to:
  /// **'Deliver & Charge'**
  String get deliverAndCharge;

  /// No description provided for @staffPaySummary.
  ///
  /// In en, this message translates to:
  /// **'{role} · {salaryType} ₹{amount}'**
  String staffPaySummary(String role, String salaryType, String amount);

  /// No description provided for @itemsCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemsCountShort(int count);

  /// No description provided for @noteWithValue.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteWithValue(String note);

  /// No description provided for @orderPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed {date}'**
  String orderPlacedOn(String date);

  /// No description provided for @couldNotAccessCamera.
  ///
  /// In en, this message translates to:
  /// **'Could not access camera. Check app permissions.'**
  String get couldNotAccessCamera;

  /// No description provided for @couldNotAccessGallery.
  ///
  /// In en, this message translates to:
  /// **'Could not access gallery. Check app permissions.'**
  String get couldNotAccessGallery;

  /// No description provided for @amountAddedToCustomerDue.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} will be added to the customer\'s due.'**
  String amountAddedToCustomerDue(String amount);

  /// No description provided for @moreItemsCount.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String moreItemsCount(int count);

  /// No description provided for @orderTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total ₹{amount}'**
  String orderTotalAmount(String amount);

  /// No description provided for @orderStatusLabelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get orderStatusLabelAll;

  /// No description provided for @minimumValueOne.
  ///
  /// In en, this message translates to:
  /// **'Min 1'**
  String get minimumValueOne;

  /// No description provided for @planPricePerDuration.
  ///
  /// In en, this message translates to:
  /// **'₹{price} / {days} days'**
  String planPricePerDuration(String price, int days);

  /// No description provided for @planDurationSuffix.
  ///
  /// In en, this message translates to:
  /// **' / {days} days'**
  String planDurationSuffix(int days);

  /// No description provided for @planPriceAndDuration.
  ///
  /// In en, this message translates to:
  /// **'₹{price} · {days} days'**
  String planPriceAndDuration(String price, int days);

  /// No description provided for @benefitQuotaTimes.
  ///
  /// In en, this message translates to:
  /// **'×{quota}'**
  String benefitQuotaTimes(int quota);

  /// No description provided for @advanceAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Advance: ₹{amount}'**
  String advanceAmountLabel(String amount);

  /// No description provided for @advanceAmountSuffix.
  ///
  /// In en, this message translates to:
  /// **' · advance ₹{amount}'**
  String advanceAmountSuffix(String amount);

  /// No description provided for @activeMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeMembersCount(int count);

  /// No description provided for @usedOfQuota.
  ///
  /// In en, this message translates to:
  /// **'{used}/{quota}'**
  String usedOfQuota(int used, int quota);

  /// No description provided for @daysLeftWithWarning.
  ///
  /// In en, this message translates to:
  /// **'{count}d left ⚠'**
  String daysLeftWithWarning(int count);

  /// No description provided for @aPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'a plan'**
  String get aPlanLabel;

  /// No description provided for @planFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planFallbackLabel;

  /// No description provided for @planWithExpiry.
  ///
  /// In en, this message translates to:
  /// **'{plan} · {date}'**
  String planWithExpiry(String plan, String date);

  /// No description provided for @planPriceAndDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'₹{price} · {days} days left'**
  String planPriceAndDaysLeft(String price, int days);

  /// No description provided for @ledgerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Ledger Preferences'**
  String get ledgerPreferences;

  /// No description provided for @autoConfirmEntries.
  ///
  /// In en, this message translates to:
  /// **'Auto-Confirm Entries'**
  String get autoConfirmEntries;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// No description provided for @categoryShortDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get categoryShortDairy;

  /// No description provided for @categoryShortPress.
  ///
  /// In en, this message translates to:
  /// **'Press'**
  String get categoryShortPress;

  /// No description provided for @categoryShortMaid.
  ///
  /// In en, this message translates to:
  /// **'Maid'**
  String get categoryShortMaid;

  /// No description provided for @categoryShortNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get categoryShortNews;

  /// No description provided for @categoryShortWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get categoryShortWater;

  /// No description provided for @categoryShortTiffin.
  ///
  /// In en, this message translates to:
  /// **'Tiffin'**
  String get categoryShortTiffin;

  /// No description provided for @categoryShortKirana.
  ///
  /// In en, this message translates to:
  /// **'Kirana'**
  String get categoryShortKirana;

  /// No description provided for @categoryShortSalon.
  ///
  /// In en, this message translates to:
  /// **'Salon'**
  String get categoryShortSalon;

  /// No description provided for @categoryShortLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get categoryShortLabour;

  /// No description provided for @categoryShortTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryShortTransport;

  /// No description provided for @categoryShortGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get categoryShortGym;

  /// No description provided for @categoryWithCount.
  ///
  /// In en, this message translates to:
  /// **'{category} ({count})'**
  String categoryWithCount(String category, int count);

  /// No description provided for @pageIndexOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String pageIndexOfTotal(int index, int total);

  /// No description provided for @orderButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderButtonLabel;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @duesTab.
  ///
  /// In en, this message translates to:
  /// **'Dues'**
  String get duesTab;

  /// No description provided for @infoTab.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTab;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @yourNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your nickname'**
  String get yourNicknameLabel;

  /// No description provided for @linkedSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked since'**
  String get linkedSinceLabel;

  /// No description provided for @defaultDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Default Delivery'**
  String get defaultDeliveryTitle;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @pricePerUnitShort.
  ///
  /// In en, this message translates to:
  /// **'Price/unit'**
  String get pricePerUnitShort;

  /// No description provided for @noDefaultDeliveryHint.
  ///
  /// In en, this message translates to:
  /// **'No default set. Staff Quick Delivery will ask each time.'**
  String get noDefaultDeliveryHint;

  /// No description provided for @tierLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get tierLabel;

  /// No description provided for @newOrderForCustomerTooltip.
  ///
  /// In en, this message translates to:
  /// **'New order for customer'**
  String get newOrderForCustomerTooltip;

  /// No description provided for @viewMonthlyStatement.
  ///
  /// In en, this message translates to:
  /// **'View Monthly Statement'**
  String get viewMonthlyStatement;

  /// No description provided for @customerDeliveriesHint.
  ///
  /// In en, this message translates to:
  /// **'Orders delivered to this customer. Tap an entry to see items.'**
  String get customerDeliveriesHint;

  /// No description provided for @remindersSentTo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Reminder sent to 1 customer} other{Reminders sent to {count} customers}}'**
  String remindersSentTo(int count);

  /// No description provided for @remindersNoOutstanding.
  ///
  /// In en, this message translates to:
  /// **'No customers with outstanding balance'**
  String get remindersNoOutstanding;

  /// No description provided for @remindersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reminders. Please try again.'**
  String get remindersFailed;

  /// No description provided for @ordersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage customer orders'**
  String get ordersSubtitle;

  /// No description provided for @defaultDeliverySaved.
  ///
  /// In en, this message translates to:
  /// **'Default delivery saved'**
  String get defaultDeliverySaved;

  /// No description provided for @defaultDeliveryPrefillHint.
  ///
  /// In en, this message translates to:
  /// **'Pre-fills staff Quick Delivery screen for {name}'**
  String defaultDeliveryPrefillHint(String name);

  /// No description provided for @fullCreamMilkExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Full Cream Milk'**
  String get fullCreamMilkExample;

  /// No description provided for @defaultQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Default qty'**
  String get defaultQtyLabel;

  /// No description provided for @unitExampleHint.
  ///
  /// In en, this message translates to:
  /// **'L, kg…'**
  String get unitExampleHint;

  /// No description provided for @saveDefaultsButton.
  ///
  /// In en, this message translates to:
  /// **'Save Defaults'**
  String get saveDefaultsButton;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @byName.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String byName(String name);

  /// No description provided for @latLabel.
  ///
  /// In en, this message translates to:
  /// **'LAT'**
  String get latLabel;

  /// No description provided for @lngLabel.
  ///
  /// In en, this message translates to:
  /// **'LNG'**
  String get lngLabel;

  /// No description provided for @noLinkedVendorsYet.
  ///
  /// In en, this message translates to:
  /// **'No linked vendors yet'**
  String get noLinkedVendorsYet;

  /// No description provided for @autoConfirmingVendorEntries.
  ///
  /// In en, this message translates to:
  /// **'Auto-confirming vendor entries'**
  String get autoConfirmingVendorEntries;

  /// No description provided for @manualConfirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Manual confirmation required'**
  String get manualConfirmationRequired;

  /// No description provided for @updatePreferenceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update preference'**
  String get updatePreferenceFailed;

  /// No description provided for @membershipsLabel.
  ///
  /// In en, this message translates to:
  /// **'Memberships'**
  String get membershipsLabel;

  /// No description provided for @membershipPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and manage your plans'**
  String get membershipPlansSubtitle;

  /// No description provided for @membersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active members, MRR, expiring soon'**
  String get membersSubtitle;

  /// No description provided for @autoConfirmSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage per-vendor auto-confirm settings'**
  String get autoConfirmSettingsSubtitle;

  /// No description provided for @pendingRequestsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pending request} other{{count} pending requests}}'**
  String pendingRequestsSummary(int count);

  /// No description provided for @totalBilledLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Billed'**
  String get totalBilledLabel;

  /// No description provided for @totalDuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Dues'**
  String get totalDuesLabel;

  /// No description provided for @netDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Due'**
  String get netDueLabel;

  /// No description provided for @noTransactionsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month'**
  String get noTransactionsThisMonth;

  /// No description provided for @creditLabel.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get creditLabel;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabel;

  /// No description provided for @entryTypeAdjustmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get entryTypeAdjustmentLabel;

  /// No description provided for @liveUpdatesOn.
  ///
  /// In en, this message translates to:
  /// **'Live — real-time updates on'**
  String get liveUpdatesOn;

  /// No description provided for @proofLocked.
  ///
  /// In en, this message translates to:
  /// **'Proof Locked'**
  String get proofLocked;

  /// No description provided for @paymentProofTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Proof'**
  String get paymentProofTitle;

  /// No description provided for @couldNotLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Could not load image'**
  String get couldNotLoadImage;

  /// No description provided for @generatingStatement.
  ///
  /// In en, this message translates to:
  /// **'Generating statement…'**
  String get generatingStatement;

  /// No description provided for @failedToGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get failedToGeneratePdf;

  /// No description provided for @pastDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Past date'**
  String get pastDateLabel;

  /// No description provided for @deliveriesOnly.
  ///
  /// In en, this message translates to:
  /// **'Deliveries only'**
  String get deliveriesOnly;

  /// No description provided for @filterEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Entries'**
  String get filterEntriesTitle;

  /// No description provided for @dateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'DATE RANGE'**
  String get dateRangeLabel;

  /// No description provided for @amountRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT RANGE'**
  String get amountRangeLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @filterStatusChip.
  ///
  /// In en, this message translates to:
  /// **'Status: {value}'**
  String filterStatusChip(String value);

  /// No description provided for @filterTypeChip.
  ///
  /// In en, this message translates to:
  /// **'Type: {value}'**
  String filterTypeChip(String value);

  /// No description provided for @fromDateLabel.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String fromDateLabel(String date);

  /// No description provided for @toDateLabel.
  ///
  /// In en, this message translates to:
  /// **'To {date}'**
  String toDateLabel(String date);

  /// No description provided for @loadMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMoreButton;

  /// No description provided for @perUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'per unit'**
  String get perUnitLabel;

  /// No description provided for @subtotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal: ₹{amount}'**
  String subtotalAmountLabel(String amount);

  /// No description provided for @amLabel.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get amLabel;

  /// No description provided for @pmLabel.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pmLabel;

  /// No description provided for @alreadyBookedLabel.
  ///
  /// In en, this message translates to:
  /// **'Already Booked'**
  String get alreadyBookedLabel;

  /// No description provided for @bookingDateAtTime.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String bookingDateAtTime(String date, String time);

  /// No description provided for @confirmedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} confirmed'**
  String confirmedCountLabel(int count);

  /// No description provided for @doneCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} done'**
  String doneCountLabel(int count);

  /// No description provided for @cancelledCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} cancelled'**
  String cancelledCountLabel(int count);

  /// No description provided for @bookingDateTimeShort.
  ///
  /// In en, this message translates to:
  /// **'{date}  •  {time}'**
  String bookingDateTimeShort(String date, String time);

  /// No description provided for @bookingDateTimeWithService.
  ///
  /// In en, this message translates to:
  /// **'{base}  •  {service}'**
  String bookingDateTimeWithService(String base, String service);

  /// No description provided for @deliveryAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddressLabel;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptionalLabel;

  /// No description provided for @upiIdOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID (optional)'**
  String get upiIdOptionalLabel;

  /// No description provided for @passwordOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get passwordOptionalHint;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @customCategoryOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom category (optional)'**
  String get customCategoryOptionalLabel;

  /// No description provided for @ayurvedicMedicineExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ayurvedic Medicine'**
  String get ayurvedicMedicineExample;

  /// No description provided for @customCategoryHelper.
  ///
  /// In en, this message translates to:
  /// **'Add your own if not listed above'**
  String get customCategoryHelper;

  /// No description provided for @signUpEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with your email address'**
  String get signUpEmailSubtitle;

  /// No description provided for @passwordWithMinHint.
  ///
  /// In en, this message translates to:
  /// **'{label} (min 8 chars)'**
  String passwordWithMinHint(String label);

  /// No description provided for @customCategoryCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}/3'**
  String customCategoryCountLabel(int count);

  /// No description provided for @upiIdExampleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. name@upi'**
  String get upiIdExampleHint;

  /// No description provided for @businessCategoryGymFitness.
  ///
  /// In en, this message translates to:
  /// **'Gym / Fitness'**
  String get businessCategoryGymFitness;

  /// No description provided for @bulkChargePickOneItem.
  ///
  /// In en, this message translates to:
  /// **'This service has multiple items — pick one to charge'**
  String get bulkChargePickOneItem;

  /// No description provided for @pricePerUnitValue.
  ///
  /// In en, this message translates to:
  /// **'₹{price} / {unit}'**
  String pricePerUnitValue(String price, String unit);

  /// No description provided for @navStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get navBooking;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @removeStaffTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove staff'**
  String get removeStaffTooltip;

  /// No description provided for @searchVendorsByCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search vendors by name or category…'**
  String get searchVendorsByCategoryHint;

  /// No description provided for @latLngValue.
  ///
  /// In en, this message translates to:
  /// **'Lat {lat}  ·  Lng {lng}'**
  String latLngValue(String lat, String lng);

  /// No description provided for @tapToPickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick on map'**
  String get tapToPickOnMap;

  /// No description provided for @deliveredByRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered by {role}'**
  String deliveredByRoleLabel(String role);

  /// No description provided for @deliveredOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredOnlyLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bho',
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mai',
    'ml',
    'mr',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bho':
      return AppLocalizationsBho();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
