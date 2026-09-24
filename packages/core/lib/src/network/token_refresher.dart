import 'package:core/src/domain/failure.dart';

/// Supplies a new access token after an HTTP 401.
///
/// The interceptor attempts refresh, retries the original request once,
/// and propagates [UnauthorizedFailure] so the app can force logout.
///
// TODO(phase-auth): Implement the HTTP refresh call in the auth package.
abstract interface class TokenRefresher {
  /// Returns a new access token, or null when refresh cannot continue.
  ///
  /// Implementations must persist the new token before returning so later
  /// requests read it from token storage.
  Future<String?> refreshAccessToken();
}
