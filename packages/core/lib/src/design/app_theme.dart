import 'package:core/src/design/app_colors.dart';
import 'package:core/src/design/app_typography.dart';
import 'package:flutter/material.dart';

/// Light theme is the one the app should use now.
///
/// [dark] is built from the same seed and type ramp so a later phase can
/// select it without changing widget code.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      error: AppColors.danger,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(brightness),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
