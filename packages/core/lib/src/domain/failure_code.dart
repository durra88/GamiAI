/// Stable identifier for a failure.
///
/// Presentation code maps each value to a localized string. Domain code
/// does not carry English copy.
enum FailureCode {
  network,
  unauthorized,
  forbidden,
  validation,
  notFound,
  conflict,
  server,
  parsing,
  unknown,
}
