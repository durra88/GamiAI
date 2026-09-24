import 'package:core/src/design/app_spacing.dart';
import 'package:flutter/material.dart';

/// Padded surface for grouped content.
class AppCard extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}
