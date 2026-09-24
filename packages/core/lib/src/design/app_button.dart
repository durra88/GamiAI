import 'package:core/src/design/app_theme.dart';
import 'package:flutter/material.dart';

/// Visual weight of [AppButton].
enum AppButtonVariant { primary, secondary }

/// A labeled button that follows [AppTheme].
class AppButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = Text(label, textAlign: TextAlign.start);
    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
    };
  }
}
