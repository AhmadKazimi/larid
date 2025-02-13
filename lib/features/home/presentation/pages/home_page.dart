import 'package:flutter/material.dart';
import '../../../../core/router/navigation_service.dart';
import '../../../../core/router/route_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Larid',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => NavigationService.go(context, RouteConstants.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
