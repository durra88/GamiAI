import 'package:core/src/design/app_spacing.dart';
import 'package:flutter/material.dart';

/// Centered progress indicator with an optional [message].
class LoadingView extends StatelessWidget {
  const new({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final label = message;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (label != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(label, textAlign: TextAlign.start),
            ],
          ],
        ),
      ),
    );
  }
}
