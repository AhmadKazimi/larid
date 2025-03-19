# Thermal Printing Guide for Flutter

This guide explains how to implement thermal printing in your Flutter app, based on the article [Thermal Print with Flutter](https://medium.com/@10urbulut/thermal-print-with-flutter-48f8aa5496a4).

## Overview

Thermal printers are commonly used for receipts, labels, and tickets. They're popular for POS (Point of Sale) systems due to their speed and reliability. To print to thermal printers from Flutter, we use specialized packages that support the ESC/POS protocol.

## Required Packages

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  # ESC/POS Printing
  esc_pos_bluetooth: ^0.4.1
  esc_pos_network: ^0.4.1
  esc_pos_utils: ^1.1.0
  bluetooth_thermal_printer: ^0.0.6
  image: ^4.0.17
```

## Installation

After adding the dependencies, run:

```bash
flutter clean
flutter pub get
```

## Platform-Specific Setup

### Android

Add Bluetooth permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
```

For Android 12+ (SDK 31+), add this to your `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        // ...
        minSdkVersion 19
        targetSdkVersion 31
        // ...
    }
}
```

### iOS

Add Bluetooth permissions to your `ios/Runner/Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Need Bluetooth permission for printing receipts</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Need Bluetooth permission for printing receipts</string>
<key>UISupportedExternalAccessoryProtocols</key>
<array>
    <string>com.epson.escpos</string>
</array>
```

## Implementation Example

### 1. Discover Bluetooth Printers

```dart
Future<List<BluetoothDevice>> getBluethoothDevices() async {
  final List<BluetoothDevice> devices = [];
  try {
    final printer = PrinterBluetooth();
    final List<BluetoothDevice> results = await printer.scan();
    devices.addAll(results);
  } catch (e) {
    print("Error scanning for devices: $e");
  }
  return devices;
}
```

### 2. Connect to a Printer

```dart
Future<bool> connectPrinter(BluetoothDevice device) async {
  try {
    final printer = PrinterBluetooth();
    await printer.connect(device);
    return true;
  } catch (e) {
    print("Error connecting to printer: $e");
    return false;
  }
}
```

### 3. Print a Receipt

```dart
Future<void> printReceipt(BluetoothDevice printer, {
  required String title,
  required List<Map<String, dynamic>> items,
  required double total,
}) async {
  try {
    // Generate ESC/POS commands
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Add title
    bytes += generator.text(title,
        styles: const PosStyles(align: PosAlign.center, 
                               bold: true,
                               height: PosTextSize.size2));
    bytes += generator.hr();

    // Add items
    for (var item in items) {
      bytes += generator.row([
        PosColumn(text: item['name'], width: 6),
        PosColumn(
            text: "x${item['quantity']}", width: 2, 
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "\$${item['price']}", width: 4, 
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: "TOTAL", width: 6, 
                styles: const PosStyles(bold: true)),
      PosColumn(
          text: "\$${total.toStringAsFixed(2)}", width: 6,
          styles: const PosStyles(bold: true, align: PosAlign.right)),
    ]);

    bytes += generator.hr();
    bytes += generator.text("Thank you for your business!",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.cut();

    // Send to printer
    await PrinterBluetooth().printBytes(printer, bytes);

  } catch (e) {
    print("Error printing: $e");
  }
}
```

### 4. Network Printing

For network printing (WiFi/Ethernet), use this approach:

```dart
Future<void> printToNetworkPrinter(String ipAddress, int port) async {
  try {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final printer = NetworkPrinter(paper: PaperSize.mm80, profile: profile);

    final PosPrintResult res = await printer.connect(ipAddress, port: port);

    if (res == PosPrintResult.success) {
      // Print functions similar to Bluetooth
      printer.text('Hello World');
      // ...
      printer.cut();
      printer.disconnect();
    }
  } catch (e) {
    print("Error printing to network printer: $e");
  }
}
```

## Troubleshooting

1. **No devices found**: Ensure Bluetooth is turned on and the printer is in discovery mode
2. **Connection fails**: Check if the printer is already connected to another device
3. **Printing fails**: Verify that the printer supports ESC/POS commands
4. **Paper doesn't cut**: Not all printers support cutting, remove the cut command if necessary
5. **Wrong characters printed**: Ensure you're using the correct capability profile

## Testing

During development, you can test your receipt formatting without an actual printer by printing the bytes to the console:

```dart
void printReceiptToConsole(List<int> bytes) {
  final List<String> hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
  debugPrint('Receipt bytes: ${hex.join(' ')}');
}
```

## Resources

- [ESC/POS Commands Reference](https://reference.epson-biz.com/modules/ref_escpos/index.php)
- [Testing with a Virtual Printer](https://github.com/receipt-print-hq/escpos-printer-simulator)
- [Additional ESC/POS Utilities](https://github.com/andrey-ushakov/esc_pos_utils) 