import 'package:flutter/material.dart';

/// Typography tokens. Both brightnesses use the Material 2021 defaults
/// so a later dark theme can swap brightness without new font assets.
abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final base = ThemeData(brightness: brightness).textTheme;
    return base.apply();
  }
}
