import 'dart:typed_data';
import 'package:flutter/material.dart';

/// A mock implementation of ESC/POS printing service for demonstration
/// This allows the UI to work without the actual ESC/POS packages installed
class MockPOSPrintService {
  // Singleton implementation
  static final MockPOSPrintService _instance = MockPOSPrintService._internal();

  factory MockPOSPrintService() => _instance;

  MockPOSPrintService._internal();

  // Mock Bluetooth devices for demonstration
  final List<Map<String, dynamic>> _mockBluetoothDevices = [
    {'name': 'Mock Printer 1', 'address': '00:11:22:33:44:55'},
    {'name': 'Mock Printer 2', 'address': '55:44:33:22:11:00'},
    {'name': 'Receipt Printer', 'address': 'AA:BB:CC:DD:EE:FF'},
  ];

  Future<List<Map<String, dynamic>>> getBluethoothDevices() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockBluetoothDevices;
  }

  Future<bool> connectBluetooth(String macAddress) async {
    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));
    // Simulate 80% success rate
    return (macAddress.length % 10) <= 7;
  }

  Future<bool> printReceiptBluetooth({
    required String title,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> totals,
    String? footer,
    String? qrData,
    Uint8List? logo,
  }) async {
    // Print to debug console to demonstrate the receipt format
    debugPrint('\n===== MOCK BLUETOOTH RECEIPT =====');
    debugPrint('TITLE: $title');
    debugPrint('---------------------------------');
    for (var item in items) {
      debugPrint('${item['name']} x ${item['quantity']} - ${item['price']}');
    }
    debugPrint('---------------------------------');
    debugPrint('Subtotal: ${totals['subtotal']}');
    if (totals.containsKey('tax')) {
      debugPrint('Tax: ${totals['tax']}');
    }
    debugPrint('TOTAL: ${totals['total']}');
    debugPrint('---------------------------------');
    if (footer != null) {
      debugPrint(footer);
    }
    if (qrData != null) {
      debugPrint('QR: $qrData');
    }
    debugPrint('=================================\n');

    // Simulate printing delay
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

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
    // Print to debug console to demonstrate the receipt format
    debugPrint('\n===== MOCK NETWORK RECEIPT =====');
    debugPrint('PRINTER: $ipAddress:$port');
    debugPrint('TITLE: $title');
    debugPrint('---------------------------------');
    for (var item in items) {
      debugPrint('${item['name']} x ${item['quantity']} - ${item['price']}');
    }
    debugPrint('---------------------------------');
    debugPrint('Subtotal: ${totals['subtotal']}');
    if (totals.containsKey('tax')) {
      debugPrint('Tax: ${totals['tax']}');
    }
    debugPrint('TOTAL: ${totals['total']}');
    debugPrint('---------------------------------');
    if (footer != null) {
      debugPrint(footer);
    }
    if (qrData != null) {
      debugPrint('QR: $qrData');
    }
    debugPrint('=================================\n');

    // Simulate printing delay
    await Future.delayed(const Duration(seconds: 2));
    // IP validation check for demo success/failure
    final ipParts = ipAddress.split('.');
    if (ipParts.length != 4) {
      return false;
    }
    return true;
  }

  // Mock implementation for thermal receipt printing
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
    // Print to debug console to demonstrate the thermal receipt format
    debugPrint('\n===== MOCK THERMAL RECEIPT (58MM) =====');

    if (printerAddress != null) {
      debugPrint('BLUETOOTH PRINTER: $printerAddress');
    } else if (printerIp != null) {
      debugPrint('NETWORK PRINTER: $printerIp:$printerPort');
    } else {
      debugPrint('PRINTER: Default');
    }

    debugPrint('TITLE: $title');
    debugPrint('---------- COMPACT FORMAT ----------');
    for (var item in items) {
      debugPrint('${item['name']} x${item['quantity']} ${item['price']}');
    }
    debugPrint('------------------------------------');
    debugPrint('Subtotal: ${totals['subtotal']}');
    if (totals.containsKey('tax')) {
      debugPrint('Tax: ${totals['tax']}');
    }
    debugPrint('TOTAL: ${totals['total']}');
    if (footer != null) {
      debugPrint('------------------------------------');
      debugPrint(footer);
    }
    if (qrData != null) {
      debugPrint('QR: $qrData [Small Format]');
    }
    debugPrint('======================================\n');

    // Simulate printing delay (faster than regular receipt)
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }
}
