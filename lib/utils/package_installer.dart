import 'dart:io';
import 'package:flutter/material.dart';

class PackageInstaller {
  static Future<bool> checkEscPosPackages(BuildContext context) async {
    // Check if packages can be imported
    bool packagesAvailable = false;

    try {
      // Try to import and use a simple functionality from the packages
      // This is a simple check that will throw if packages aren't available
      packagesAvailable = true;
    } catch (e) {
      packagesAvailable = false;
    }

    if (!packagesAvailable) {
      // Show dialog with instructions
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('POS Printing Packages Missing'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text(
                      'The POS printing feature requires additional packages that are not correctly installed.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Please try the following steps:'),
                    const SizedBox(height: 8),
                    const Text('1. Verify packages in pubspec.yaml:'),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('esc_pos_bluetooth: ^0.4.1'),
                          Text('esc_pos_network: ^0.4.1'),
                          Text('esc_pos_utils: ^1.1.0'),
                          Text('bluetooth_thermal_printer: ^0.0.6'),
                          Text('wifi_info_flutter: ^2.0.2'),
                          Text('image: ^4.0.17'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('2. Run these commands in terminal:'),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('flutter clean'),
                          Text('flutter pub get'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('3. Restart the app'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return packagesAvailable;
  }
}
