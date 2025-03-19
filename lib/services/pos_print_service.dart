import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

// We'll handle missing dependencies gracefully
class POSPrintService {
  // Singleton implementation
  static final POSPrintService _instance = POSPrintService._internal();

  factory POSPrintService() => _instance;

  POSPrintService._internal();

  // Check if the required packages are available
  Future<bool> isPrintingAvailable() async {
    try {
      // Try to check Bluetooth availability
      final bool? isAvailable = await PrintBluetoothThermal.bluetoothEnabled;
      return isAvailable ?? false;
    } catch (e) {
      debugPrint('Error checking Bluetooth availability: $e');
      return false;
    }
  }

  // Bluetooth printing functionality
  Future<List<Map<String, dynamic>>> getBluethoothDevices() async {
    final List<Map<String, dynamic>> results = [];

    try {
      // First check if Bluetooth is available
      final bool? isAvailable = await PrintBluetoothThermal.bluetoothEnabled;
      if (isAvailable != true) {
        debugPrint('Bluetooth is not enabled');
        return [];
      }

      // Get list of paired Bluetooth devices
      final List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      debugPrint('Found ${devices.length} paired devices');

      for (var device in devices) {
        debugPrint('Device: ${device.name} - ${device.macAdress}');
        if (device.name != null && device.macAdress != null) {
          results.add({
            'name': device.name ?? 'Unknown Device',
            'address': device.macAdress ?? '',
          });
        }
      }

      // Only add mock devices if no real devices are found and we're in debug mode
      if (results.isEmpty && kDebugMode) {
        debugPrint(
          'No paired devices found, adding mock devices in debug mode',
        );
        results.addAll([
          {'name': 'Mock Printer 1', 'address': '00:11:22:33:44:55'},
          {'name': 'Mock Printer 2', 'address': '55:44:33:22:11:00'},
        ]);
      }

      return results;
    } catch (e) {
      debugPrint('Error getting Bluetooth devices: $e');
      // Only add mock devices in debug mode if there's an error
      if (kDebugMode) {
        results.addAll([
          {
            'name': 'Mock Printer 1 (Error fallback)',
            'address': '00:11:22:33:44:55',
          },
          {
            'name': 'Mock Printer 2 (Error fallback)',
            'address': '55:44:33:22:11:00',
          },
        ]);
      }
      return results;
    }
  }

  Future<bool> connectBluetooth(String macAddress) async {
    try {
      // Connect to Bluetooth device
      final bool? connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      // Log the connection status
      debugPrint(
        'Bluetooth connection status: $connected for device $macAddress',
      );

      return connected ?? false;
    } catch (e) {
      debugPrint('Error connecting to Bluetooth device: $e');
      // In debug mode, simulate a successful connection
      if (kDebugMode && macAddress.contains('Mock')) {
        return true;
      }
      return false;
    }
  }

  Future<bool> printReceiptBluetooth({
    required String title,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> totals,
    String? footer,
    String? qrData,
    Uint8List? logo,
  }) async {
    try {
      // Check if connected to a printer
      final bool? isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected != true) {
        debugPrint('Not connected to a printer');
        return false;
      }

      // Generate ESC/POS commands
      List<int> bytes = [];
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      // Add logo if provided
      if (logo != null) {
        final decodedImage = img.decodeImage(logo);
        if (decodedImage != null) {
          bytes += generator.image(decodedImage);
        }
      }

      // Add title
      bytes += generator.text(
        title,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      bytes += generator.text(''); // Line break

      // Date and time
      final DateTime now = DateTime.now();
      final String dateStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      bytes += generator.text(
        dateStr,
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(''); // Line break

      // Add separator
      bytes += generator.hr();

      // Add items
      for (var item in items) {
        bytes += generator.text(
          "${item['name']} x ${item['quantity']}",
          styles: const PosStyles(bold: true),
        );
        bytes += generator.row([
          PosColumn(text: '', width: 6),
          PosColumn(
            text: "${item['price']}",
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.hr();

      // Add totals
      bytes += generator.row([
        PosColumn(
          text: "Subtotal:",
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: "${totals['subtotal']}",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (totals.containsKey('tax')) {
        bytes += generator.row([
          PosColumn(
            text: "Tax:",
            width: 6,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: "${totals['tax']}",
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.row([
        PosColumn(
          text: "TOTAL:",
          width: 6,
          styles: const PosStyles(bold: true, height: PosTextSize.size2),
        ),
        PosColumn(
          text: "${totals['total']}",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size2,
          ),
        ),
      ]);

      bytes += generator.hr();

      // Add footer if provided
      if (footer != null && footer.isNotEmpty) {
        bytes += generator.text(
          footer,
          styles: const PosStyles(align: PosAlign.center),
        );
        bytes += generator.text(''); // Line break
      }

      // Add QR code if provided
      if (qrData != null && qrData.isNotEmpty) {
        bytes += generator.qrcode(qrData);
      }

      bytes += generator.cut();

      // Print to thermal printer
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      return result ?? false;
    } catch (e) {
      debugPrint('Error printing via Bluetooth: $e');
      return false;
    }
  }

  // Network printing functionality (as a placeholder - print_bluetooth_thermal doesn't support network)
  Future<bool> printReceiptNetwork({
    required String ipAddress,
    required int port,
    required String title,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> totals,
    String? footer,
    String? qrData,
    Uint8List? logo,
  }) async {
    // Show what would be printed in the console
    debugPrint('\n======== NETWORK RECEIPT ========');
    debugPrint('PRINTER: $ipAddress:$port');
    debugPrint('TITLE: $title');
    debugPrint('-----------------------------------');
    for (var item in items) {
      debugPrint('${item['name']} x ${item['quantity']}: ${item['price']}');
    }
    debugPrint('-----------------------------------');
    debugPrint('Subtotal: ${totals['subtotal']}');
    if (totals.containsKey('tax')) {
      debugPrint('Tax: ${totals['tax']}');
    }
    debugPrint('TOTAL: ${totals['total']}');
    if (footer != null) {
      debugPrint('-----------------------------------');
      debugPrint(footer);
    }
    if (qrData != null) {
      debugPrint('QR Code: $qrData');
    }
    debugPrint('==================================\n');

    // Note: For true network printing, you would need to implement a socket connection
    // This is not directly supported by print_bluetooth_thermal package
    return true;
  }

  // Optimized thermal receipt printing for small 58mm/80mm printers
  Future<bool> printThermalReceipt({
    required String title,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> totals,
    String? footer,
    String? qrData,
    Uint8List? logo,
    String? printerAddress,
    String? printerIp,
    int printerPort = 9100,
  }) async {
    try {
      bool isConnected = false;

      // Connect to printer if not already connected
      if (printerAddress != null) {
        // Bluetooth connection
        final bool? connectionResult =
            await PrintBluetoothThermal.connectionStatus;
        if (connectionResult != true) {
          isConnected = await connectBluetooth(printerAddress) ?? false;
        } else {
          isConnected = true;
        }

        if (!isConnected) {
          debugPrint('Failed to connect to thermal printer');
          return false;
        }

        // Generate optimized ESC/POS commands for 58mm width
        List<int> bytes = [];
        final profile = await CapabilityProfile.load(
          name: 'XP-N160I',
        ); // Generic profile for small printers
        final generator = Generator(
          PaperSize.mm58,
          profile,
        ); // 58mm paper size is common for receipt printers

        // Add smaller logo if provided (rescaled for small paper)
        if (logo != null) {
          final decodedImage = img.decodeImage(logo);
          if (decodedImage != null) {
            // Resize image to fit small paper
            final resizedImage = img.copyResize(
              decodedImage,
              width: 250,
            ); // Smaller width for 58mm paper
            bytes += generator.image(resizedImage);
          }
        }

        // Add title in condensed format
        bytes += generator.text(
          title,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        );

        // Current date in compact format
        final now = DateTime.now();
        final dateStr =
            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
        bytes += generator.text(
          dateStr,
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
          ),
        );

        bytes += generator.hr(ch: '-', linesAfter: 0);

        // Add items in condensed format
        for (var item in items) {
          // Use smaller font and condensed spacing
          bytes += generator.text(
            "${item['name']} x${item['quantity']}",
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
          bytes += generator.text(
            "${item['price']}",
            styles: const PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
            ),
          );
        }

        bytes += generator.hr(ch: '-', linesAfter: 0);

        // Add totals with minimal spacing
        bytes += generator.row([
          PosColumn(text: "Subtotal:", width: 6),
          PosColumn(
            text: "${totals['subtotal']}",
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);

        if (totals.containsKey('tax')) {
          bytes += generator.row([
            PosColumn(text: "Tax:", width: 6),
            PosColumn(
              text: "${totals['tax']}",
              width: 6,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }

        bytes += generator.hr(ch: '-', linesAfter: 0);

        // Total in slightly larger font
        bytes += generator.row([
          PosColumn(
            text: "TOTAL:",
            width: 6,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: "${totals['total']}",
            width: 6,
            styles: const PosStyles(align: PosAlign.right, bold: true),
          ),
        ]);

        if (footer != null && footer.isNotEmpty) {
          bytes += generator.hr(ch: '-', linesAfter: 0);
          bytes += generator.text(
            footer,
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
            ),
          );
        }

        // Smaller QR code if provided
        if (qrData != null && qrData.isNotEmpty) {
          bytes += generator.qrcode(qrData);
        }

        // Cut paper
        bytes += generator.cut();

        // Print to thermal printer
        final result = await PrintBluetoothThermal.writeBytes(bytes);
        return result ?? false;
      } else if (printerIp != null) {
        // For network printing, we just log the data since the package doesn't directly support it
        debugPrint('\n======== THERMAL NETWORK RECEIPT ========');
        debugPrint('PRINTER: $printerIp:$printerPort');
        debugPrint('TITLE: $title (THERMAL FORMAT)');
        debugPrint('-----------------------------------');
        for (var item in items) {
          debugPrint('${item['name']} x ${item['quantity']}: ${item['price']}');
        }
        debugPrint('-----------------------------------');
        debugPrint('Subtotal: ${totals['subtotal']}');
        if (totals.containsKey('tax')) {
          debugPrint('Tax: ${totals['tax']}');
        }
        debugPrint('TOTAL: ${totals['total']}');
        if (footer != null) {
          debugPrint('-----------------------------------');
          debugPrint(footer);
        }
        if (qrData != null) {
          debugPrint('QR Code: $qrData');
        }
        debugPrint('=====================================\n');

        return true; // Simulate success for demo
      }

      return false; // No printer specified
    } catch (e) {
      debugPrint('Error printing thermal receipt: $e');
      return false;
    }
  }
}
