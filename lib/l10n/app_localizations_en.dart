// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TimeSince';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signUpTitle => 'Sign Up';

  @override
  String get emailHint => 'example@gmail.com';

  @override
  String get passwordHint => '********';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get loginButton => 'LOG IN';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get signUpButton => 'SIGN UP';

  @override
  String get createAccountPrompt => 'Create your account';

  @override
  String get confirmPasswordHint => '********';

  @override
  String get passwordsMismatch => 'Passwords do not match!';

  @override
  String get weakPassword => 'The password provided is too weak.';

  @override
  String get emailAlreadyInUse => 'The account already exists for that email.';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get confirmPasswordLabel => 'CONFIRM PASSWORD';

  @override
  String get signOutButton => 'Sign Out';

  @override
  String get upgradeButton => 'Upgrade';

  @override
  String loggedInAs(Object email) {
    return 'Logged in as: $email';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get deleteAccountWarningTitle => 'Delete Account';

  @override
  String get deleteAccountWarningContent =>
      'Are you sure you want to delete your account? All your data will be permanently lost.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get confirmDeletionTitle => 'Confirm Deletion';

  @override
  String get confirmDeletionPrompt =>
      'To confirm, type \"DELETE\" in the box below:';

  @override
  String get incorrectConfirmation => 'Incorrect confirmation text.';

  @override
  String get accountDeletedSuccess => 'Account successfully deleted.';

  @override
  String errorDeletingAccount(Object errorMessage) {
    return 'Error deleting account: $errorMessage';
  }

  @override
  String unexpectedError(Object errorMessage) {
    return 'An unexpected error occurred: $errorMessage';
  }

  @override
  String get noUserLoggedIn => 'No user logged in.';

  @override
  String get itemManagementTitle => 'Item Management';

  @override
  String get noTrackingItems =>
      'No tracking items yet. Add one using the + button!';

  @override
  String notesLabel(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get editButton => 'Edit';

  @override
  String get addItemTitle => 'Add New Item';

  @override
  String get itemNameHint => 'Item Name';

  @override
  String get notesOptionalHint => 'Notes (Optional)';

  @override
  String get addButton => 'Add';

  @override
  String errorAddingItem(Object errorMessage) {
    return 'Error adding item: $errorMessage';
  }

  @override
  String get editItemTitle => 'Edit Item';

  @override
  String get saveButton => 'Save';

  @override
  String errorUpdatingItem(Object errorMessage) {
    return 'Error updating item: $errorMessage';
  }

  @override
  String itemDeleted(Object itemName) {
    return 'Item $itemName deleted.';
  }

  @override
  String errorDeletingItem(Object errorMessage) {
    return 'Error deleting item: $errorMessage';
  }

  @override
  String get upgradeRequiredTitle => 'Upgrade Required';

  @override
  String get upgradeRequiredContent =>
      'Free tier users are limited to 5 items. Please upgrade to add more.';

  @override
  String get pleaseSignIn => 'Please sign in to manage your items.';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get errorSendingPasswordResetEmail =>
      'Error sending password reset email.';

  @override
  String get noUserFound => 'No user found for that email.';

  @override
  String get wrongPassword => 'Wrong password provided for that user.';

  @override
  String yearsAgo(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String monthsAgo(num months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get statusLabel => 'Status';

  @override
  String get manageLabel => 'Manage';

  @override
  String get itemStatusTitle => 'Item Status';

  @override
  String get noTrackingItemsManageTab =>
      'No tracking items yet. Add some in the Manage tab!';

  @override
  String lastLogged(Object date, Object timeSince) {
    return 'Last Logged: $date ($timeSince)';
  }

  @override
  String loggedNowFor(Object itemName) {
    return 'Logged now for: $itemName';
  }

  @override
  String errorLoggingDate(Object errorMessage) {
    return 'Error logging date: $errorMessage';
  }

  @override
  String customDateAddedFor(Object itemName) {
    return 'Custom date added for: $itemName';
  }

  @override
  String errorAddingCustomDate(Object errorMessage) {
    return 'Error adding custom date: $errorMessage';
  }

  @override
  String get pleaseEnterEmailToResetPassword =>
      'Please enter your email to reset password.';

  @override
  String errorSigningOut(Object errorMessage) {
    return 'Error signing out: $errorMessage';
  }

  @override
  String get logNowButton => 'Log Now';

  @override
  String get customDateButton => 'Custom Date';

  @override
  String get sortByName => 'Sort by Name';

  @override
  String get sortByLastLoggedDate => 'Sort by Last Logged Date';

  @override
  String get sortByNextDueDate => 'Sort by Next Due Date';

  @override
  String get setRepeatDaysTitle => 'Set Repeat Days';

  @override
  String get repeatDaysHint => 'Enter number';

  @override
  String repeatDaysUpdated(Object itemName, Object repeatDays) {
    return 'Repeat days for $itemName updated to $repeatDays days.';
  }

  @override
  String errorUpdatingRepeatDays(Object errorMessage) {
    return 'Error updating repeat days: $errorMessage';
  }

  @override
  String get confirmButton => 'Confirm';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get repeatButton => 'Repeat';

  @override
  String get scheduleButton => 'Schedule';

  @override
  String scheduleEventTitle(Object itemName) {
    return '$itemName - Next Due Date';
  }

  @override
  String scheduleEventDescription(Object itemName, Object repeatDays) {
    return 'Time to log $itemName again! (Every $repeatDays days)';
  }

  @override
  String scheduleEventConfirmation(Object date, Object itemName) {
    return 'Scheduled $itemName for $date in your calendar.';
  }

  @override
  String repeatDaysProgress(
    Object currentDays,
    Object percentage,
    Object totalDays,
  ) {
    return '$currentDays days out of $totalDays days ($percentage%)';
  }

  @override
  String repeatDaysProgressRemaining(
    Object percentage,
    Object remainingDays,
    Object totalDays,
  ) {
    return '$remainingDays days out of $totalDays days remaining ($percentage%)';
  }

  @override
  String notificationTitle(String itemName) {
    return 'Reminder: $itemName';
  }

  @override
  String notificationBody(String itemName) {
    return 'It\'s time to log $itemName again!';
  }

  @override
  String get searchHint => 'Search items...';
}
