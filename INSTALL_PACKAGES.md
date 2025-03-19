# ESC/POS Printing Package Installation

To properly install and use the ESC/POS printing packages, please run the following commands in your terminal:

```bash
flutter clean
flutter pub get
```

After running these commands, restart your app.

## Troubleshooting

If you still encounter issues with the packages, try the following:

1. Make sure your Flutter environment is up to date:

```bash
flutter upgrade
```

2. Check if packages are available for your platform:

```bash
flutter pub deps
```

3. For iOS, ensure pods are installed:

```bash
cd ios
pod install
cd ..
```

4. For Android, make sure Bluetooth permissions are added to your AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```

## Supported Platforms

- Android: Bluetooth and Network printing
- iOS: Bluetooth and Network printing (requires Bluetooth entitlements)
- Windows/Linux/macOS: Only Network printing supported 