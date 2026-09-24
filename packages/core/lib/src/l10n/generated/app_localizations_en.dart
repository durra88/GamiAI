// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get signIn => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get organizations => 'Organizations';

  @override
  String get logout => 'Log out';

  @override
  String get forbidden => 'You do not have access to this.';

  @override
  String get failureNetwork =>
      'Could not connect. Check the network and try again.';

  @override
  String get failureUnauthorized => 'Your session has ended. Sign in again.';

  @override
  String get failureForbidden => 'You are not allowed to do that.';

  @override
  String get failureValidation => 'Some fields are invalid.';

  @override
  String get failureNotFound => 'That item could not be found.';

  @override
  String get failureConflict => 'This conflicts with the current data.';

  @override
  String get failureServer => 'The server had a problem. Try again later.';

  @override
  String get failureParsing => 'The response could not be read.';

  @override
  String get failureUnknown => 'Something went wrong.';
}
