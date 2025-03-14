import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static void push(BuildContext context, String location, {Object? extra}) {
    context.push(location, extra: extra);
  }

  static void pushNamed(
    BuildContext context,
    String name, {
    Object? extra,
    Map<String, String>? pathParameters,
  }) {
    context.pushNamed(name, extra: extra, pathParameters: pathParameters ?? {});
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop(result);
  }

  static void go(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  static void goNamed(
    BuildContext context,
    String name, {
    Object? extra,
    Map<String, String>? pathParameters,
  }) {
    context.goNamed(name, extra: extra, pathParameters: pathParameters ?? {});
  }

  static void pushReplacement(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.pushReplacement(location, extra: extra);
  }

  static void pushReplacementNamed(
    BuildContext context,
    String name, {
    Object? extra,
  }) {
    context.pushReplacementNamed(name, extra: extra);
  }

  static void showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restart Required'),
          content: const Text(
            'The language settings have been changed. Please restart the app for the changes to take effect.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
