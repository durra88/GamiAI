import 'package:core/core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GamiApp(config: EnvironmentConfig.fromDefines()));
}

class GamiApp extends StatelessWidget {
  const new({required this.config, super.key});

  final EnvironmentConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamiAI',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(apiBaseUrl: config.apiBaseUrl),
    );
  }
}

class HomePage extends StatelessWidget {
  const new({required this.apiBaseUrl, super.key});

  final String apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('GamiAI')),
      body: Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.organizations,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(apiBaseUrl, textAlign: TextAlign.start),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: l10n.signIn, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
