import 'package:flutter/material.dart';

/// A single-line text field with a floating [label].
class AppTextField extends StatelessWidget {
  const new({
    required this.label,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
