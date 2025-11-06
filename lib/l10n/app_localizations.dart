import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TimeSince'**
  String get appTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get loginButton;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUpButton;

  /// No description provided for @createAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccountPrompt;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get passwordsMismatch;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get emailAlreadyInUse;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPasswordLabel;

  /// No description provided for @signOutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButton;

  /// No description provided for @upgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgradeButton;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as: {email}'**
  String loggedInAs(Object email);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountWarningTitle;

  /// No description provided for @deleteAccountWarningContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? All your data will be permanently lost.'**
  String get deleteAccountWarningContent;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @confirmDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletionTitle;

  /// No description provided for @confirmDeletionPrompt.
  ///
  /// In en, this message translates to:
  /// **'To confirm, type \"DELETE\" in the box below:'**
  String get confirmDeletionPrompt;

  /// No description provided for @incorrectConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Incorrect confirmation text.'**
  String get incorrectConfirmation;

  /// No description provided for @accountDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted.'**
  String get accountDeletedSuccess;

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {errorMessage}'**
  String errorDeletingAccount(Object errorMessage);

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {errorMessage}'**
  String unexpectedError(Object errorMessage);

  /// No description provided for @noUserLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No user logged in.'**
  String get noUserLoggedIn;

  /// No description provided for @itemManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Management'**
  String get itemManagementTitle;

  /// No description provided for @noTrackingItems.
  ///
  /// In en, this message translates to:
  /// **'No tracking items yet. Add one using the + button!'**
  String get noTrackingItems;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String notesLabel(Object notes);

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @addItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addItemTitle;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemNameHint;

  /// No description provided for @notesOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptionalHint;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @errorAddingItem.
  ///
  /// In en, this message translates to:
  /// **'Error adding item: {errorMessage}'**
  String errorAddingItem(Object errorMessage);

  /// No description provided for @editItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItemTitle;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @errorUpdatingItem.
  ///
  /// In en, this message translates to:
  /// **'Error updating item: {errorMessage}'**
  String errorUpdatingItem(Object errorMessage);

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item {itemName} deleted.'**
  String itemDeleted(Object itemName);

  /// No description provided for @errorDeletingItem.
  ///
  /// In en, this message translates to:
  /// **'Error deleting item: {errorMessage}'**
  String errorDeletingItem(Object errorMessage);

  /// No description provided for @upgradeRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Required'**
  String get upgradeRequiredTitle;

  /// No description provided for @upgradeRequiredContent.
  ///
  /// In en, this message translates to:
  /// **'Free tier users are limited to 5 items. Please upgrade to add more.'**
  String get upgradeRequiredContent;

  /// No description provided for @pleaseSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to manage your items.'**
  String get pleaseSignIn;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get passwordResetEmailSent;

  /// No description provided for @errorSendingPasswordResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Error sending password reset email.'**
  String get errorSendingPasswordResetEmail;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get noUserFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrongPassword;

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{years,plural, =1{1 year ago} other{{years} years ago}}'**
  String yearsAgo(num years);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{months,plural, =1{1 month ago} other{{months} months ago}}'**
  String monthsAgo(num months);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days,plural, =1{1 day ago} other{{days} days ago}}'**
  String daysAgo(num days);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours,plural, =1{1 hour ago} other{{hours} hours ago}}'**
  String hoursAgo(num hours);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes,plural, =1{1 minute ago} other{{minutes} minutes ago}}'**
  String minutesAgo(num minutes);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @manageLabel.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageLabel;

  /// No description provided for @itemStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Status'**
  String get itemStatusTitle;

  /// No description provided for @noTrackingItemsManageTab.
  ///
  /// In en, this message translates to:
  /// **'No tracking items yet. Add some in the Manage tab!'**
  String get noTrackingItemsManageTab;

  /// No description provided for @lastLogged.
  ///
  /// In en, this message translates to:
  /// **'Last Logged: {date} ({timeSince})'**
  String lastLogged(Object date, Object timeSince);

  /// No description provided for @loggedNowFor.
  ///
  /// In en, this message translates to:
  /// **'Logged now for: {itemName}'**
  String loggedNowFor(Object itemName);

  /// No description provided for @errorLoggingDate.
  ///
  /// In en, this message translates to:
  /// **'Error logging date: {errorMessage}'**
  String errorLoggingDate(Object errorMessage);

  /// No description provided for @customDateAddedFor.
  ///
  /// In en, this message translates to:
  /// **'Custom date added for: {itemName}'**
  String customDateAddedFor(Object itemName);

  /// No description provided for @errorAddingCustomDate.
  ///
  /// In en, this message translates to:
  /// **'Error adding custom date: {errorMessage}'**
  String errorAddingCustomDate(Object errorMessage);

  /// No description provided for @pleaseEnterEmailToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset password.'**
  String get pleaseEnterEmailToResetPassword;

  /// No description provided for @errorSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {errorMessage}'**
  String errorSigningOut(Object errorMessage);

  /// No description provided for @logNowButton.
  ///
  /// In en, this message translates to:
  /// **'Log Now'**
  String get logNowButton;

  /// No description provided for @customDateButton.
  ///
  /// In en, this message translates to:
  /// **'Custom Date'**
  String get customDateButton;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// No description provided for @sortByLastLoggedDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Last Logged Date'**
  String get sortByLastLoggedDate;

  /// No description provided for @setRepeatDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Repeat Days'**
  String get setRepeatDaysTitle;

  /// No description provided for @repeatDaysHint.
  ///
  /// In en, this message translates to:
  /// **'Enter number'**
  String get repeatDaysHint;

  /// No description provided for @repeatDaysUpdated.
  ///
  /// In en, this message translates to:
  /// **'Repeat days for {itemName} updated to {repeatDays} days.'**
  String repeatDaysUpdated(Object itemName, Object repeatDays);

  /// No description provided for @errorUpdatingRepeatDays.
  ///
  /// In en, this message translates to:
  /// **'Error updating repeat days: {errorMessage}'**
  String errorUpdatingRepeatDays(Object errorMessage);

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @repeatButton.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatButton;

  /// No description provided for @repeatDaysProgress.
  ///
  /// In en, this message translates to:
  /// **'{currentDays} days out of {totalDays} days ({percentage}%)'**
  String repeatDaysProgress(
    Object currentDays,
    Object percentage,
    Object totalDays,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
