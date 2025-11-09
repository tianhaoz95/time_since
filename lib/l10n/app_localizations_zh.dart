// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '时间追溯';

  @override
  String get signInTitle => '登录';

  @override
  String get signUpTitle => '注册';

  @override
  String get emailHint => 'example@gmail.com';

  @override
  String get passwordHint => '********';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get loginButton => '登录';

  @override
  String get noAccountPrompt => '还没有账号？';

  @override
  String get signUpButton => '注册';

  @override
  String get createAccountPrompt => '创建您的账户';

  @override
  String get confirmPasswordHint => '********';

  @override
  String get passwordsMismatch => '密码不匹配！';

  @override
  String get weakPassword => '提供的密码太弱。';

  @override
  String get emailAlreadyInUse => '该邮箱已被注册。';

  @override
  String get unknownError => '发生未知错误。';

  @override
  String get emailLabel => '邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get signOutButton => '退出登录';

  @override
  String get upgradeButton => '升级';

  @override
  String loggedInAs(Object email) {
    return '登录身份：$email';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get deleteAccountButton => '删除账户';

  @override
  String get deleteAccountWarningTitle => '删除账户';

  @override
  String get deleteAccountWarningContent => '您确定要删除您的账户吗？您的所有数据将永久丢失。';

  @override
  String get cancelButton => '取消';

  @override
  String get deleteButton => '删除';

  @override
  String get confirmDeletionTitle => '确认删除';

  @override
  String get confirmDeletionPrompt => '要确认，请在下方输入“DELETE”：';

  @override
  String get incorrectConfirmation => '确认文本不正确。';

  @override
  String get accountDeletedSuccess => '账户删除成功。';

  @override
  String errorDeletingAccount(Object errorMessage) {
    return '删除账户错误：$errorMessage';
  }

  @override
  String unexpectedError(Object errorMessage) {
    return '发生意外错误：$errorMessage';
  }

  @override
  String get noUserLoggedIn => '没有用户登录。';

  @override
  String get itemManagementTitle => '项目管理';

  @override
  String get noTrackingItems => '还没有追踪项目。点击“+”按钮添加一个！';

  @override
  String notesLabel(Object notes) {
    return '备注：$notes';
  }

  @override
  String get editButton => '编辑';

  @override
  String get addItemTitle => '添加新项目';

  @override
  String get itemNameHint => '项目名称';

  @override
  String get notesOptionalHint => '备注（可选）';

  @override
  String get addButton => '添加';

  @override
  String errorAddingItem(Object errorMessage) {
    return '添加项目错误：$errorMessage';
  }

  @override
  String get editItemTitle => '编辑项目';

  @override
  String get saveButton => '保存';

  @override
  String errorUpdatingItem(Object errorMessage) {
    return '更新项目错误：$errorMessage';
  }

  @override
  String itemDeleted(Object itemName) {
    return '项目 $itemName 已删除。';
  }

  @override
  String errorDeletingItem(Object errorMessage) {
    return '删除项目错误：$errorMessage';
  }

  @override
  String get upgradeRequiredTitle => '需要升级';

  @override
  String get upgradeRequiredContent => '免费用户限制为5个项目。请升级以添加更多。';

  @override
  String get pleaseSignIn => '请登录以管理您的项目。';

  @override
  String get passwordResetEmailSent => '密码重置邮件已发送。请检查您的收件箱。';

  @override
  String get errorSendingPasswordResetEmail => '发送密码重置邮件错误。';

  @override
  String get noUserFound => '未找到该邮箱的用户。';

  @override
  String get wrongPassword => '该用户密码错误。';

  @override
  String yearsAgo(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前',
      one: '1年前',
    );
    return '$_temp0';
  }

  @override
  String monthsAgo(num months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months个月前',
      one: '1个月前',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days天前',
      one: '1天前',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours小时前',
      one: '1小时前',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes分钟前',
      one: '1分钟前',
    );
    return '$_temp0';
  }

  @override
  String get justNow => '刚刚';

  @override
  String get statusLabel => '状态';

  @override
  String get manageLabel => '管理';

  @override
  String get itemStatusTitle => '项目状态';

  @override
  String get noTrackingItemsManageTab => '还没有追踪项目。在管理标签中添加一些！';

  @override
  String lastLogged(Object date, Object timeSince) {
    return '上次记录：$date ($timeSince)';
  }

  @override
  String loggedNowFor(Object itemName) {
    return '已为：$itemName 记录';
  }

  @override
  String errorLoggingDate(Object errorMessage) {
    return '记录日期错误：$errorMessage';
  }

  @override
  String customDateAddedFor(Object itemName) {
    return '已为：$itemName 添加自定义日期';
  }

  @override
  String errorAddingCustomDate(Object errorMessage) {
    return '添加自定义日期错误：$errorMessage';
  }

  @override
  String get pleaseEnterEmailToResetPassword => '请输入您的电子邮件以重置密码。';

  @override
  String errorSigningOut(Object errorMessage) {
    return '退出登录错误：$errorMessage';
  }

  @override
  String get logNowButton => '立即记录';

  @override
  String get customDateButton => '自定义日期';

  @override
  String get sortByName => '按名称排序';

  @override
  String get sortByLastLoggedDate => '按上次记录日期排序';

  @override
  String get sortByNextDueDate => '按下次到期日排序';

  @override
  String get setRepeatDaysTitle => '设置重复天数';

  @override
  String get repeatDaysHint => '输入数字';

  @override
  String repeatDaysUpdated(Object itemName, Object repeatDays) {
    return '$itemName 的重复天数已更新为 $repeatDays 天。';
  }

  @override
  String errorUpdatingRepeatDays(Object errorMessage) {
    return '更新重复天数错误：$errorMessage';
  }

  @override
  String get confirmButton => '确认';

  @override
  String get passwordStrengthWeak => '弱';

  @override
  String get passwordStrengthMedium => '中';

  @override
  String get passwordStrengthStrong => '强';

  @override
  String get repeatButton => '重复';

  @override
  String get scheduleButton => '日程';

  @override
  String scheduleEventTitle(Object itemName) {
    return '$itemName - 下次到期日';
  }

  @override
  String scheduleEventDescription(Object itemName, Object repeatDays) {
    return '再次记录 $itemName 的时间到了！ (每 $repeatDays 天)';
  }

  @override
  String scheduleEventConfirmation(Object date, Object itemName) {
    return '已将 $itemName 的 $date 日程添加到您的日历中。';
  }

  @override
  String repeatDaysProgress(
    Object currentDays,
    Object percentage,
    Object totalDays,
  ) {
    return '$currentDays 天 / $totalDays 天 ($percentage%)';
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
  String get searchHint => '搜索项目...';
}
