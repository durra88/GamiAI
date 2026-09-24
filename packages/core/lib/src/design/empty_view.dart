import 'package:core/src/design/app_spacing.dart';
import 'package:flutter/material.dart';

/// Placeholder for a screen with nothing to show.
class EmptyView extends StatelessWidget {
  const new({required this.title, this.message, super.key});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final body = message;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, textAlign: TextAlign.start),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(body, textAlign: TextAlign.start),
            ],
          ],
        ),
      ),
    );
  }
}
