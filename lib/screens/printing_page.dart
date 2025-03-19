import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../screens/pos_printer_selection.dart';
import '../services/pos_print_service.dart';
import '../services/mock_pos_print_service.dart';
import '../utils/package_installer.dart';

// Custom painter to create a subtle thermal paper texture
class ThermalPaperPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

    // Draw horizontal lines like those on thermal paper
    final spacing = 3.0;
    for (double y = 0; y < size.height; y += spacing) {
      // Slightly random variation in line placement
      final yOffset = y + (math.Random().nextDouble() * 0.5);
      canvas.drawLine(Offset(0, yOffset), Offset(size.width, yOffset), paint);
    }

    // Add some random dots to simulate paper texture
    final dotPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.05)
          ..style = PaintingStyle.fill;

    final random = math.Random();
    final numDots = (size.width * size.height) ~/ 100;

    for (int i = 0; i < numDots; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PrintingPage extends StatefulWidget {
  // ... existing code ...
  final Map<String, dynamic>? preloadedInvoiceData;

  const PrintingPage({Key? key, this.preloadedInvoiceData}) : super(key: key);

  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  // ... existing code ...

  // Add these variables for POS printing
  final POSPrintService _posPrintService = POSPrintService();
  final MockPOSPrintService _mockPrintService = MockPOSPrintService();
  Map<String, dynamic>? _selectedPOSPrinter;
  bool _isPOSPrinting = false;
  bool _useRealPrinting = false;
  bool _checkedDependencies = false;

  @override
  void initState() {
    super.initState();
    // Keep your existing initialization

    // Check if real printing is available
    _checkPOSPrintingAvailability();

    // Initialize with preloaded invoice data if available
    _initializePreloadedData();
  }

  void _initializePreloadedData() {
    if (widget.preloadedInvoiceData != null) {
      // Show a notification that invoice data was loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invoice data loaded for thermal printing'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });

      // Auto-print if there's a selected printer
      if (_selectedPOSPrinter != null) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _printQuickReceipt(usePreloadedData: true);
          }
        });
      }
    }
  }

  Future<void> _checkPOSPrintingAvailability() async {
    try {
      _useRealPrinting = await _posPrintService.isPrintingAvailable();
    } catch (e) {
      _useRealPrinting = false;
    }

    setState(() {
      _checkedDependencies = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Printing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildPrintOptions(),
      ),
    );
  }

  Widget _buildPrintOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thermal Printing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Add preview section when invoice data is available
        if (widget.preloadedInvoiceData != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Receipt Preview',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  child: _buildReceiptPreview(),
                ),
              ],
            ),
          ),

          // Add hint text below the preview
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'This is how your receipt will appear when printed on a thermal printer.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],

        // POS Thermal Printing button
        ElevatedButton.icon(
          onPressed: () {
            if (!_checkedDependencies) {
              _checkPOSPrintingAvailability();
            }

            if (!_useRealPrinting) {
               // For demo purposes, still allow mock printing
              _openPOSPrinterSelection();
            } else {
              _openPOSPrinterSelection();
            }
          },
          icon: const Icon(Icons.print_outlined),
          label: Text(
            _useRealPrinting ? 'Select Printer' : 'Select Printer (DEMO MODE)',
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: _useRealPrinting ? null : Colors.orange,
          ),
        ),

        const SizedBox(height: 16),

        // Receipt-Style Thermal Printing button (Quick Receipt)
        ElevatedButton.icon(
          onPressed: () {
            if (!_checkedDependencies) {
              _checkPOSPrintingAvailability();
            }

            // Open quick receipt printing with predefined format
            _printQuickReceipt();
          },
          icon: const Icon(Icons.receipt),
          label: const Text('Print Quick Receipt'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
          ),
        ),

        // If we have preloaded invoice data, show a dedicated button
        if (widget.preloadedInvoiceData != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (!_checkedDependencies) {
                _checkPOSPrintingAvailability();
              }

              // Print the preloaded invoice data
              _printQuickReceipt(usePreloadedData: true);
            },
            icon: const Icon(Icons.receipt_long),
            label: Text(
              'Print Invoice #${widget.preloadedInvoiceData?['qrData']?.toString().split('-')[1] ?? 'Receipt'}',
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),

          Text(
            'Customer: ${widget.preloadedInvoiceData!['customerName'] ?? 'Unknown'}',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],

        if (!_useRealPrinting && _checkedDependencies)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'POS printing is in demo mode. Some packages need to be installed.',
              style: TextStyle(color: Colors.orange[800], fontSize: 12),
            ),
          ),

        // Show selected POS printer if available
        if (_selectedPOSPrinter != null) ...[
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected POS Printer:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(_formatPrinterInfo(_selectedPOSPrinter!)),
                        if (!_useRealPrinting)
                          Text(
                            '(Demo Mode - Will print to console)',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isPOSPrinting ? null : _printToPOSPrinter,
                    child:
                        _isPOSPrinting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Print Now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatPrinterInfo(Map<String, dynamic> printer) {
    if (printer['type'] == 'bluetooth') {
      return 'Bluetooth Printer (${printer['address']})';
    } else {
      return 'Network Printer (${printer['ipAddress']}:${printer['port']})';
    }
  }

  void _openPOSPrinterSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => POSPrinterSelection(
              onPrinterSelected: (printerData) {
                setState(() {
                  _selectedPOSPrinter = printerData;
                });
              },
            ),
      ),
    );

    // Handle result if needed
  }

  Future<void> _printToPOSPrinter() async {
    if (_selectedPOSPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a POS printer first')),
      );
      return;
    }

    setState(() {
      _isPOSPrinting = true;
    });

    try {
      // Generate sample items for this example
      List<Map<String, dynamic>> items = [
        {'name': 'Product 1', 'quantity': 2, 'price': '\$15.00'},
        {'name': 'Product 2', 'quantity': 1, 'price': '\$25.00'},
        {'name': 'Product 3', 'quantity': 3, 'price': '\$10.00'},
      ];

      // Format totals for printing
      Map<String, dynamic> totals = {
        'subtotal': '\$80.00',
        'tax': '\$8.00',
        'total': '\$88.00',
      };

      // Optional footer text
      String footer = 'Thank you for your business!';

      // Optional QR code (e.g., for invoice reference)
      String qrData = 'INV-123456';

      bool success = false;

      if (_useRealPrinting) {
        // Use the real print service
        if (_selectedPOSPrinter!['type'] == 'bluetooth') {
          // Print via Bluetooth
          success = await _posPrintService.printReceiptBluetooth(
            title: 'YOUR BUSINESS NAME',
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
          );
        } else {
          // Print via Network
          success = await _posPrintService.printReceiptNetwork(
            ipAddress: _selectedPOSPrinter!['ipAddress'],
            port: _selectedPOSPrinter!['port'],
            title: 'YOUR BUSINESS NAME',
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
          );
        }
      } else {
        // Use mock print service
        if (_selectedPOSPrinter!['type'] == 'bluetooth') {
          // Print via Bluetooth mock
          success = await _mockPrintService.printReceiptBluetooth(
            title: 'YOUR BUSINESS NAME',
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
          );
        } else {
          // Print via Network mock
          success = await _mockPrintService.printReceiptNetwork(
            ipAddress: _selectedPOSPrinter!['ipAddress'],
            port: _selectedPOSPrinter!['port'],
            title: 'YOUR BUSINESS NAME',
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
          );
        }
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printed successfully to POS printer')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to print to POS printer')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing to POS printer: $e')),
      );
    } finally {
      setState(() {
        _isPOSPrinting = false;
      });
    }
  }

  Future<void> _printQuickReceipt({bool usePreloadedData = false}) async {
    setState(() {
      _isPOSPrinting = true;
    });

    try {
      // Set default printer if not already selected
      if (_selectedPOSPrinter == null) {
        // Default to the first available Bluetooth printer or fallback to mock
        List<Map<String, dynamic>> devices = [];
        if (_useRealPrinting) {
          devices = await _posPrintService.getBluethoothDevices();
        } else {
          devices = await _mockPrintService.getBluethoothDevices();
        }

        if (devices.isNotEmpty) {
          final device = devices.first;
          _selectedPOSPrinter = {
            'type': 'bluetooth',
            'address': device['address'],
            'name': device['name'],
          };

          // Connect to the printer
          bool connected = false;
          if (_useRealPrinting) {
            connected = await _posPrintService.connectBluetooth(
              _selectedPOSPrinter!['address'],
            );
          } else {
            connected = await _mockPrintService.connectBluetooth(
              _selectedPOSPrinter!['address'],
            );
          }

          if (!connected) {
            throw Exception(
              'Failed to connect to printer. Please select one manually.',
            );
          }
        } else {
          throw Exception('No printers found. Please select one manually.');
        }
      }

      // Use preloaded invoice data if available and requested
      List<Map<String, dynamic>> items;
      Map<String, dynamic> totals;
      String title;
      String footer;
      String qrData;

      if (usePreloadedData && widget.preloadedInvoiceData != null) {
        // Use data from invoice
        items = List<Map<String, dynamic>>.from(
          widget.preloadedInvoiceData!['items'] ?? [],
        );
        totals = Map<String, dynamic>.from(
          widget.preloadedInvoiceData!['totals'] ?? {},
        );
        title = widget.preloadedInvoiceData!['title'] ?? 'INVOICE';
        footer =
            widget.preloadedInvoiceData!['footer'] ??
            'Thank you for your business!';
        qrData = widget.preloadedInvoiceData!['qrData'] ?? '';

        // Show customer info
        final customerName = widget.preloadedInvoiceData!['customerName'];
        if (customerName != null && customerName.isNotEmpty) {
          title += '\nCustomer: $customerName';
        }
      } else {
        // Generate sample receipt items for demo
        items = [
          {'name': 'Quick Item 1', 'quantity': 1, 'price': '\$10.00'},
          {'name': 'Quick Item 2', 'quantity': 2, 'price': '\$15.00'},
        ];

        // Format totals for quick receipt
        totals = {'subtotal': '\$40.00', 'tax': '\$4.00', 'total': '\$44.00'};

        // Basic footer text
        title = 'QUICK RECEIPT';
        footer = 'Thank you for your purchase!';

        // QR code with timestamp (for demo)
        qrData = 'RECEIPT-${DateTime.now().millisecondsSinceEpoch}';
      }

      bool success = false;

      if (_useRealPrinting) {
        // Use the optimized thermal receipt printer method
        if (_selectedPOSPrinter!['type'] == 'bluetooth') {
          success = await _posPrintService.printThermalReceipt(
            title: title,
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
            printerAddress: _selectedPOSPrinter!['address'],
          );
        } else {
          success = await _posPrintService.printThermalReceipt(
            title: title,
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
            printerIp: _selectedPOSPrinter!['ipAddress'],
            printerPort: _selectedPOSPrinter!['port'],
          );
        }
      } else {
        // Use the mock thermal receipt service
        if (_selectedPOSPrinter!['type'] == 'bluetooth') {
          success = await _mockPrintService.printThermalReceipt(
            title: title,
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
            printerAddress: _selectedPOSPrinter!['address'],
          );
        } else {
          success = await _mockPrintService.printThermalReceipt(
            title: title,
            items: items,
            totals: totals,
            footer: footer,
            qrData: qrData,
            printerIp: _selectedPOSPrinter!['ipAddress'],
            printerPort: _selectedPOSPrinter!['port'],
          );
        }
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quick receipt printed successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to print quick receipt')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing quick receipt: $e')),
      );
    } finally {
      setState(() {
        _isPOSPrinting = false;
      });
    }
  }

  // Build the receipt preview widget
  Widget _buildReceiptPreview() {
    // Early return if no data
    if (widget.preloadedInvoiceData == null) {
      return const Center(child: Text('No invoice data available for preview'));
    }

    // Get data from the preloaded invoice
    final title = widget.preloadedInvoiceData!['title'] ?? 'INVOICE';
    final customerName =
        widget.preloadedInvoiceData!['customerName'] ?? 'Customer';
    final items = List<Map<String, dynamic>>.from(
      widget.preloadedInvoiceData!['items'] ?? [],
    );
    final totals = Map<String, dynamic>.from(
      widget.preloadedInvoiceData!['totals'] ?? {},
    );
    final footer =
        widget.preloadedInvoiceData!['footer'] ??
        'Thank you for your business!';
    final qrData = widget.preloadedInvoiceData!['qrData'] ?? '';

    // Calculate receipt width based on screen size (simulate 58mm paper)
    final receiptWidth = MediaQuery.of(context).size.width * 0.85;

    return Container(
      width: receiptWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFBF3), // Light cream color like thermal paper
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay to mimic thermal paper texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(painter: ThermalPaperPatternPainter()),
            ),
          ),
          // Actual receipt content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Business name/title
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Customer name
                Text(
                  'Customer: $customerName',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),

                // Current date in compact format
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),

                // Divider
                Divider(color: Colors.grey[300], height: 24),

                // Items
                if (items.isNotEmpty) ...[
                  for (var item in items) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            '${item['name']} x${item['quantity']}',
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item['price']}',
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ] else ...[
                  const Text(
                    'No items in this invoice',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],

                // Divider before totals
                Divider(color: Colors.grey[300], height: 16),

                // Totals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:', style: TextStyle(fontSize: 11)),
                    Text(
                      totals['subtotal'] ?? '\$0.00',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),

                if (totals.containsKey('tax') && totals['tax'] != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax:', style: TextStyle(fontSize: 11)),
                      Text(totals['tax'], style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ],

                const SizedBox(height: 4),

                // Total amount - emphasized
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!, width: 1),
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        totals['total'] ?? '\$0.00',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer text
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                  child: Text(
                    footer,
                    style: const TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // QR code visualization (just a placeholder)
                if (qrData.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text('QR Code', style: TextStyle(fontSize: 9)),
                    ),
                  ),
                  Text(
                    'Invoice #${qrData.split('-').length > 1 ? qrData.split('-')[1] : ''}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ... rest of your existing code ...
}
