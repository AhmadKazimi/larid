# POS Thermal Printing in Your Flutter App

This documentation explains how to use the POS (Point of Sale) thermal printing feature that has been added to your application.

## Overview

The app now supports two printing options:
1. **PDF Printing** - The original printing functionality (unchanged)
2. **POS Thermal Printing** - For printing receipts directly to thermal printers

## Supported Printer Connection Types

### 1. Bluetooth Printers
- Connects to ESC/POS compatible thermal printers over Bluetooth
- Discovers nearby Bluetooth devices
- Requires Bluetooth permissions to be granted to the app

### 2. Network/WiFi Printers
- Connects to ESC/POS compatible thermal printers over WiFi/LAN
- Requires the printer's IP address and port (typically 9100)
- Both the device and printer must be on the same network

## Using POS Printing

1. Navigate to the printing page in your app
2. Select "Print to Thermal Printer (POS)" option
3. Choose the connection type (Bluetooth or Network)
4. For Bluetooth:
   - The app will scan for nearby Bluetooth devices
   - Select your printer from the list and tap "Connect"
   - Once connected, the printer will be selected
5. For Network:
   - Enter the IP address of your printer
   - Confirm the port (default: 9100)
   - Select the printer
6. Tap "Print Now" to send the receipt to the selected printer

## Troubleshooting

### Bluetooth Issues
- Ensure Bluetooth is enabled on your device
- Make sure the printer is turned on and in pairing mode
- Some printers may require a PIN code for pairing (typically 0000 or 1234)
- Check that your app has Bluetooth permissions

### Network Issues
- Ensure your device and printer are on the same network
- Verify the IP address of the printer (check printer settings or print a network configuration)
- Confirm the printer is powered on and connected to the network
- Check if the printer has a firewall blocking the connection

### Printing Issues
- Most thermal printers use 58mm or 80mm paper width - the app is configured for 80mm by default
- If text appears cut off, ensure your printer supports the paper width configured
- Some advanced formatting may not be supported by all printers

## Supported Printer Features

The POS printing implementation supports:
- Text formatting (bold, alignment, size)
- Item listings with prices
- Subtotal, tax, and total calculations
- QR code generation
- Paper cutting (if supported by the printer)

## Requirements

The following packages are used for POS printing:
- `esc_pos_bluetooth: ^0.4.1`
- `esc_pos_network: ^0.4.1`
- `esc_pos_utils: ^1.1.0`
- `bluetooth_thermal_printer: ^0.0.6`
- `wifi_info_flutter: ^2.0.2`
- `image: ^4.0.17`
- `path_provider: ^2.0.15`

## Customizing Receipts

If you need to customize the receipt format, you can modify the following methods in the `POSPrintService` class:
- `printReceiptBluetooth()` for Bluetooth printing
- `printReceiptNetwork()` for Network printing

These methods allow you to change the layout, add logos, modify text formatting, and more. 