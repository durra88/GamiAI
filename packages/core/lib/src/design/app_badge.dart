import 'package:core/src/design/app_spacing.dart';
import 'package:flutter/material.dart';

/// Compact status label.
class AppBadge extends StatelessWidget {
  const new({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: colorScheme.onSecondaryContainer),
          ),
        ),
      ),
    );
  }
}
