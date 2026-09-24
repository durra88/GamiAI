import 'package:core/src/design/app_button.dart';
import 'package:core/src/design/app_spacing.dart';
import 'package:flutter/material.dart';

/// Message with an optional retry action.
class ErrorView extends StatelessWidget {
  const new({required this.message, this.onRetry, this.retryLabel, super.key});

  final String message;
  final VoidCallback? onRetry;

  /// Localized retry label. The button is omitted when this is null.
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    final label = retryLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.start),
            if (retry != null && label != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton(label: label, onPressed: retry),
            ],
          ],
        ),
      ),
    );
  }
}
