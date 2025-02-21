import 'package:flutter/material.dart';
import '../../../../core/router/navigation_service.dart';
import '../../../../core/router/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.welcomeToLarid,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => NavigationService.go(context, RouteConstants.login),
              child: Text(l10n.goToLogin),
            ),
          ],
        ),
      ),
    );
  }
}
