import 'package:core/core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GamiApp());
}

class GamiApp extends StatelessWidget {
  const GamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamiAI',
      theme: AppTheme.light(),
      home: const Scaffold(body: Center(child: Text('GamiAI - Phase 0'))),
    );
  }
}
