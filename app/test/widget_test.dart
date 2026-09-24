import 'package:app/main.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the app shell', (tester) async {
    await tester.pumpWidget(
      const GamiApp(
        config: EnvironmentConfig(
          environment: AppEnvironment.dev,
          apiBaseUrl: 'http://localhost:8080',
        ),
      ),
    );

    expect(find.text('GamiAI'), findsOneWidget);
    expect(find.text('Organizations'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
