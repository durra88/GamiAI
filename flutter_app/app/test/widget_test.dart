import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('shows the phase 0 placeholder', (tester) async {
    await tester.pumpWidget(const GamiApp());
    expect(find.text('GamiAI - Phase 0'), findsOneWidget);
  });
}
