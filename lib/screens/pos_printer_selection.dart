import 'package:flutter/material.dart';
// Removing dependency on wifi_info_flutter
import 'dart:io';
import '../services/pos_print_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter/foundation.dart';

enum POSPrinterType { bluetooth, network }

class POSPrinterSelection extends StatefulWidget {
  final Function(Map<String, dynamic>) onPrinterSelected;
  final bool useMockData;

  const POSPrinterSelection({
    Key? key,
    required this.onPrinterSelected,
    this.useMockData = false,
  }) : super(key: key);

  @override
  State<POSPrinterSelection> createState() => _POSPrinterSelectionState();
}

class _POSPrinterSelectionState extends State<POSPrinterSelection> {
  final POSPrintService _printService = POSPrintService();
  POSPrinterType _selectedType = POSPrinterType.bluetooth;
  List<Map<String, dynamic>> _bluetoothDevices = [];
  bool _isLoading = false;
  bool _isConnecting = false;
  String? _selectedDeviceAddress;
  bool _bluetoothEnabled = false;
  String _statusMessage = '';

  // Network printer settings
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _portController = TextEditingController(
    text: '9100',
  );

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
    _setupNetworkDefaults();
  }

  @override
  void dispose() {
    _ipAddressController.dispose();
    _portController.dispose();
    super.dispose();
  }

  // Simpler implementation that doesn't rely on wifi_info_flutter
  void _setupNetworkDefaults() {
    // Set some common local network subnet as default
    _ipAddressController.text = '192.168.1.';
  }

  Future<void> _checkBluetoothStatus() async {
    try {
      final bool? isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      setState(() {
        _bluetoothEnabled = isEnabled ?? false;
        if (!_bluetoothEnabled) {
          _statusMessage = 'Bluetooth is disabled. Please enable it.';
        } else {
          _checkPermissions();
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error checking Bluetooth status: $e';
        _bluetoothEnabled = false;
      });
    }
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses =
          await [
            Permission.bluetooth,
            Permission.bluetoothConnect,
            Permission.bluetoothScan,
            Permission.location,
          ].request();

      bool allGranted = true;
      String missingPermissions = '';

      statuses.forEach((permission, status) {
        if (!status.isGranted) {
          allGranted = false;
          missingPermissions += '${permission.toString()}, ';
        }
      });

      if (allGranted) {
        _getBluetoothDevices();
      } else {
        setState(() {
          _statusMessage =
              'Missing permissions: $missingPermissions\nPlease grant all Bluetooth permissions in app settings.';
        });
      }
    } else {
      // For iOS
      _getBluetoothDevices();
    }
  }

  Future<void> _enableBluetooth() async {
    try {
      // In newer versions, this method only checks if Bluetooth is enabled
      final bool? isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (isEnabled != true) {
        // For actually requesting to enable Bluetooth, we'll just inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable Bluetooth in your device settings.'),
          ),
        );
      }
      _checkBluetoothStatus();
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to check Bluetooth status: $e';
      });
    }
  }

  Future<void> _getBluetoothDevices() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Scanning for devices...';
    });

    try {
      if (!_bluetoothEnabled) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Bluetooth is disabled. Please enable it.';
        });
        return;
      }

      final devices = await _printService.getBluethoothDevices();
      setState(() {
        _bluetoothDevices = devices;
        _isLoading = false;

        if (devices.isEmpty) {
          _statusMessage =
              'No devices found. Make sure your printer is paired with this device.';
        } else {
          _statusMessage = '';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error loading devices: $e';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading devices: $e')));
    }
  }

  Future<void> _connectToBluetoothPrinter(String address) async {
    setState(() {
      _isConnecting = true;
    });

    try {
      final bool connected = await _printService.connectBluetooth(address);
      if (connected) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connected to printer')));

        setState(() {
          _selectedDeviceAddress = address;
        });

        // Return the selected printer info
        _returnSelectedPrinter();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect to printer')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to printer: $e')),
      );
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  void _validateAndReturnNetworkPrinter() {
    final ipAddress = _ipAddressController.text.trim();
    final portText = _portController.text.trim();

    if (ipAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an IP address')),
      );
      return;
    }

    if (portText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a port number')),
      );
      return;
    }

    final int? port = int.tryParse(portText);
    if (port == null || port <= 0 || port > 65535) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid port number')));
      return;
    }

    // Return the network printer info
    widget.onPrinterSelected({
      'type': 'network',
      'ipAddress': ipAddress,
      'port': port,
    });

    Navigator.pop(context);
  }

  void _returnSelectedPrinter() {
    if (_selectedType == POSPrinterType.bluetooth) {
      if (_selectedDeviceAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select and connect to a device'),
          ),
        );
        return;
      }

      // Return the selected Bluetooth printer info
      widget.onPrinterSelected({
        'type': 'bluetooth',
        'address': _selectedDeviceAddress,
      });
    } else {
      _validateAndReturnNetworkPrinter();
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select POS Printer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Printer type selection
            const Text(
              'Printer Connection Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<POSPrinterType>(
              segments: const [
                ButtonSegment(
                  value: POSPrinterType.bluetooth,
                  label: Text('Bluetooth'),
                  icon: Icon(Icons.bluetooth),
                ),
                ButtonSegment(
                  value: POSPrinterType.network,
                  label: Text('Network/WiFi'),
                  icon: Icon(Icons.wifi),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<POSPrinterType> selection) {
                setState(() {
                  _selectedType = selection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Show either Bluetooth or Network settings based on selection
            Expanded(
              child:
                  _selectedType == POSPrinterType.bluetooth
                      ? _buildBluetoothView()
                      : _buildNetworkView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _returnSelectedPrinter,
        label: const Text('Select Printer'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildBluetoothView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Available Devices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (!_bluetoothEnabled)
                  TextButton.icon(
                    icon: const Icon(Icons.bluetooth),
                    label: const Text('Enable Bluetooth'),
                    onPressed: _enableBluetooth,
                  ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            if (_bluetoothEnabled) {
                              _getBluetoothDevices();
                            } else {
                              _checkBluetoothStatus();
                            }
                          },
                  tooltip: 'Refresh Devices',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_statusMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: Colors.red.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _bluetoothDevices.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No devices found'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.settings_bluetooth),
                          label: const Text('Pair New Printer'),
                          onPressed: () {
                            // Open system Bluetooth settings (not directly supported in this package)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please pair your printer in the system Bluetooth settings.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: _bluetoothDevices.length,
                    itemBuilder: (context, index) {
                      final device = _bluetoothDevices[index];
                      final name = device['name'] ?? 'Unknown Device';
                      final address = device['address'] ?? '';
                      final isSelected = address == _selectedDeviceAddress;

                      return ListTile(
                        title: Text(name),
                        subtitle: Text(address),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : ElevatedButton(
                                  onPressed:
                                      _isConnecting
                                          ? null
                                          : () => _connectToBluetoothPrinter(
                                            address,
                                          ),
                                  child:
                                      _isConnecting
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Text('Connect'),
                                ),
                        selected: isSelected,
                        selectedTileColor: Colors.blue.withOpacity(0.1),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildNetworkView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Network Printer Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _ipAddressController,
          decoration: const InputDecoration(
            labelText: 'IP Address',
            hintText: 'e.g., 192.168.1.100',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _portController,
          decoration: const InputDecoration(
            labelText: 'Port',
            hintText: 'Default: 9100',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        const Text(
          'Note: Most ESC/POS printers use port 9100 by default.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
