import 'package:core/src/domain/failure_code.dart';
import 'package:core/src/l10n/generated/app_localizations.dart';

/// Localized message for [code]. Does not include technical details.
String failureMessage(AppLocalizations l10n, FailureCode code) {
  return switch (code) {
    FailureCode.network => l10n.failureNetwork,
    FailureCode.unauthorized => l10n.failureUnauthorized,
    FailureCode.forbidden => l10n.failureForbidden,
    FailureCode.validation => l10n.failureValidation,
    FailureCode.notFound => l10n.failureNotFound,
    FailureCode.conflict => l10n.failureConflict,
    FailureCode.server => l10n.failureServer,
    FailureCode.parsing => l10n.failureParsing,
    FailureCode.unknown => l10n.failureUnknown,
  };
}
