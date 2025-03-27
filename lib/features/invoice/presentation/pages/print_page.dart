import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/database/user_table.dart';
import 'package:larid/database/company_info_table.dart';
import 'package:larid/database/invoice_table.dart';
import 'package:larid/features/auth/domain/entities/user_entity.dart';
import 'package:larid/features/sync/domain/entities/company_info_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/features/taxes/domain/services/tax_calculator_service.dart';
import 'package:provider/provider.dart';
import 'package:larid/screens/printing_page.dart';

class PrintPage extends StatefulWidget {
  final InvoiceState invoice;
  final CustomerEntity customer;
  final bool isReturn;

  const PrintPage({
    Key? key,
    required this.invoice,
    required this.customer,
    required this.isReturn,
  }) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  bool _isGenerating = false;
  String? _pdfPath;
  late final AppLocalizations l10n;
  bool _didInitialize = false;
  pw.Font? _arabicFont;
  String? _userId;
  TaxCalculatorService? _taxCalculator;
  bool _fontLoaded = false;
  bool _initialized = false;
  CompanyInfoEntity? _companyInfo;
  String? _currency;
  List<Map<String, dynamic>>? _returnInvoices;
  bool _returnInvoicesLoaded = false;

  @override
  void initState() {
    super.initState();
    // Don't call _generatePdf() here - it will be called in didChangeDependencies
    _loadFonts();
    _getUserId();
    _getCompanyInfo();
    _getCurrency();
    _initTaxCalculator().then((_) {
      if (mounted) {
        _logInvoiceItemTaxes();
      }
    });
  }

  Future<void> _loadFonts() async {
    debugPrint('Loading Arabic font for PDF generation');
    try {
      // Load the KufiArabic font - use the correct path
      final fontData = await rootBundle.load(
        'assets/fonts/NotoKufiArabic-Regular.ttf',
      );
      _arabicFont = pw.Font.ttf(fontData.buffer.asByteData());
      debugPrint('Arabic font (NotoKufiArabic) loaded successfully');

      // Try to load the bold version as well for better rendering
      try {
        final boldFontData = await rootBundle.load(
          'assets/fonts/NotoKufiArabic-Bold.ttf',
        );
        final boldFont = pw.Font.ttf(boldFontData.buffer.asByteData());
        debugPrint('Bold Arabic font loaded successfully');
      } catch (boldError) {
        debugPrint('Bold font not loaded: $boldError');
      }

      setState(() {
        _fontLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading Arabic font: $e');
      // Use default fonts if we couldn't load the Arabic font
      setState(() {
        _fontLoaded = true;
      });
    }
  }

  Future<void> _getUserId() async {
    try {
      final userTable = GetIt.I<UserTable>();
      final currentUser = await userTable.getCurrentUser();
      if (currentUser != null) {
        setState(() {
          _userId = currentUser.userid;
        });
      }
    } catch (e) {
      debugPrint('Error getting user ID: $e');
    }
  }

  Future<void> _getCompanyInfo() async {
    try {
      final companyInfoTable = GetIt.I<CompanyInfoTable>();
      final companyInfo = await companyInfoTable.getCompanyInfo();
      if (companyInfo != null) {
        setState(() {
          _companyInfo = companyInfo;
        });
        debugPrint('Company info loaded: ${companyInfo.companyName}');
      } else {
        debugPrint('No company info found in database');
      }
    } catch (e) {
      debugPrint('Error getting company info: $e');
    }
  }

  Future<void> _getCurrency() async {
    try {
      final userTable = GetIt.I<UserTable>();
      final currentUser = await userTable.getCurrentUser();
      if (currentUser != null && currentUser.currency != null) {
        setState(() {
          _currency = currentUser.currency;
        });
        debugPrint('Currency loaded: $_currency');
      } else {
        debugPrint('No currency found in user table');
      }
    } catch (e) {
      debugPrint('Error getting currency: $e');
    }
  }

  Future<void> _initTaxCalculator() async {
    debugPrint('Initializing tax calculator for PDF generation');
    try {
      final taxService = Provider.of<TaxCalculatorService>(
        context,
        listen: false,
      );
      _taxCalculator = taxService;
      debugPrint('Tax calculator initialized successfully');

      // Verify tax calculator is working by testing with a sample tax code
      final sampleTaxCode = "GST";
      final sampleRate = _taxCalculator!.getTaxPercentage(sampleTaxCode);
      final sampleAmount = _taxCalculator!.calculateTax(sampleTaxCode, 100);
      debugPrint(
        'Tax calculator test: code=$sampleTaxCode, rate=$sampleRate%, amount=$sampleAmount',
      );
    } catch (e) {
      debugPrint('Error initializing tax calculator: $e');
      // We'll use fallback calculations if the tax calculator isn't available
    }
  }

  // Helper methods for tax calculations when needed
  double getTaxRate(String taxCode) {
    if (_taxCalculator != null) {
      return _taxCalculator!.getTaxPercentage(taxCode);
    }

    // Log warning when tax calculator isn't available
    debugPrint('WARNING: Tax calculator not available for code $taxCode');

    // No hardcoded defaults - return 0% if tax calculator isn't available
    // This is safer than assuming an arbitrary rate
    return 0.0;
  }

  double calculateTaxAmount(String taxCode, double price) {
    if (_taxCalculator != null) {
      return _taxCalculator!.calculateTax(taxCode, price);
    }
    // Fallback calculation
    final taxRate = getTaxRate(taxCode);
    return price * (taxRate / 100);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
    if (!_initialized) {
      _initialized = true;
      _initializeAndGeneratePdf();
    }
  }

  Future<void> _initializeAndGeneratePdf() async {
    debugPrint('Initializing components for PDF generation');
    setState(() {
      _isGenerating = true;
    });

    try {
      // Initialize all components in parallel for efficiency
      final futures = <Future>[];

      // Load font if not already loaded
      if (!_fontLoaded) {
        futures.add(_loadFonts());
      }

      // Get user ID if not already loaded
      if (_userId == null || _userId!.isEmpty) {
        futures.add(_getUserId());
      }

      // Get company info if not already loaded
      if (_companyInfo == null) {
        futures.add(_getCompanyInfo());
      }

      // Initialize tax calculator if not already initialized
      if (_taxCalculator == null) {
        futures.add(_initTaxCalculator());
      }

      // If this is a normal invoice, fetch return invoices for the same customer
      if (!widget.isReturn && !_returnInvoicesLoaded) {
        futures.add(_loadReturnInvoices());
      }

      // Wait for all initializations to complete
      await Future.wait(futures);

      // Generate PDF once everything is initialized
      if (mounted) {
        debugPrint('All components initialized, generating PDF');
        await _generatePdf();
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error initializing: $e')));
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _generatePdf() async {
    if (!_fontLoaded || _userId == null || _userId!.isEmpty) {
      debugPrint(
        'Cannot generate PDF: Font loaded: $_fontLoaded, User ID: ${_userId == null ? "Not loaded" : "Loaded"}',
      );
      return;
    }

    if (_taxCalculator == null) {
      debugPrint(
        'Tax calculator not initialized, attempting to initialize now...',
      );
      await _initTaxCalculator();
    }

    debugPrint(
      'Generating PDF with tax calculator: ${_taxCalculator != null ? "Available" : "NOT AVAILABLE"}',
    );

    setState(() {
      _isGenerating = true;
    });

    try {
      final pdf = pw.Document();

      // Ensure we have the Arabic font
      if (_arabicFont == null) {
        debugPrint('WARNING: Arabic font not loaded, attempting to load again');
        await _loadFonts();
        if (_arabicFont == null) {
          debugPrint('CRITICAL: Could not load Arabic font, using fallbacks');
        }
      }

      // Create a theme with Arabic font as the base font
      final defaultFont = await pw.Font.courier();
      final theme = pw.ThemeData.withFont(
        base: _arabicFont ?? defaultFont,
        bold: _arabicFont ?? defaultFont,
        italic: _arabicFont ?? defaultFont,
        boldItalic: _arabicFont ?? defaultFont,
      );

      // Load app logo for footer
      Uint8List? logoImage;
      try {
        final logoBytes = await rootBundle.load('assets/images/img_larid2.png');
        logoImage = logoBytes.buffer.asUint8List();
        debugPrint('Logo loaded successfully for PDF footer');
      } catch (e) {
        debugPrint('Error loading logo for PDF footer: $e');
        // Continue without logo if it can't be loaded
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(16),
          theme: theme,
          textDirection: pw.TextDirection.rtl,
          build:
              (context) => [
                _buildHeader(),
                _buildCustomerInfo(),
                pw.SizedBox(height: 8),
                _buildItemsTable(context),
                _buildTotals(),
                _buildFooter(),
              ],
          footer:
              (context) => pw.Padding(
                padding: const pw.EdgeInsets.only(top: 10),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                    ),
                  ),
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Row(
                    mainAxisAlignment:
                        pw.MainAxisAlignment.start, // Align to left
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (logoImage != null)
                        pw.Container(
                          height: 30,
                          width: 40,
                          child: pw.Image(pw.MemoryImage(logoImage)),
                        ),
                      pw.Text(
                        'Powered by',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                      // Add page number on the right side
                      pw.Spacer(),
                      pw.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );

      // Save the PDF
      final output = await getTemporaryDirectory();
      final formattedInvoiceNumber =
          "${_userId!}-${widget.invoice.invoiceNumber ?? "new"}";
      final file = File('${output.path}/invoice_$formattedInvoiceNumber.pdf');
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _pdfPath = file.path;
        _isGenerating = false;
      });
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      setState(() {
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  pw.Widget _buildHeader() {
    final title =
        widget.isReturn
            ? '${l10n.invoiceNumber} #${formattedInvoiceNumber}'
            : '${l10n.invoiceNumber} #${formattedInvoiceNumber}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Company info header
        if (_companyInfo != null) ...[
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  _companyInfo!.companyName,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                if (true /*_companyInfo!.address1.isNotEmpty*/ )
                  pw.Text(
                    "عمان - الاردن",
                    style: const pw.TextStyle(fontSize: 12),
                    textAlign: pw.TextAlign.center,
                  ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.SizedBox(width: 16),
                    if (_companyInfo!.taxId.isEmpty)
                      pw.Text(
                        'الرقم الضريبي: 1234566789',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    pw.SizedBox(width: 16),
                    if (true) ...[
                      pw.Text(
                        '${l10n.phone}: 0780282893',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.SizedBox(width: 8),
                    ],
                  ],
                ),
                pw.Text("فاتورة مبيعات"),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
        ],

        // Invoice number and date
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildCustomerInfo() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // pw.Text(
          //   l10n.customerInformation,
          //   style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          // ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${l10n.customerName}: ${widget.customer.customerName}',
                    ),
                    // pw.Text(
                    //   '${l10n.customerCode}: ${widget.customer.customerCode}',
                    // ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // pw.Text(
                    //   '${l10n.phone}: ${widget.customer.contactPhone ?? "-"}',
                    // ),
                    pw.Text(
                      '${l10n.address}: ${widget.customer.address ?? "-"}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceDetails() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        children: [
          // pw.Expanded(
          //   child: pw.Column(
          //     crossAxisAlignment: pw.CrossAxisAlignment.start,
          //     children: [
          //       pw.Text('${l10n.paymentType}: ${widget.invoice.paymentType}'),
          //       if (widget.invoice.comment.isNotEmpty)
          //         pw.Text('${l10n.comment}: ${widget.invoice.comment}'),
          //     ],
          //   ),
          // ),
          // pw.Expanded(
          //   child: pw.Column(
          //     crossAxisAlignment: pw.CrossAxisAlignment.start,
          //     children: [
          //       pw.Text(
          //         '${l10n.date}: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
          //       ),
          //       pw.Text(
          //         '${l10n.time}: ${DateFormat('HH:mm').format(DateTime.now())}',
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(pw.Context context) {
    // Get all items (both regular and return)
    final List<Map<String, dynamic>> allItems = [];

    // Add regular invoice items
    final regularItems =
        widget.invoice.items.map((item) {
          // Calculate price before tax
          final priceBeforeTax =
              item.priceBeforeTax > 0
                  ? item.priceBeforeTax
                  : item.item.sellUnitPrice * item.quantity;

          // Calculate tax amount and rate
          double taxRate = item.taxRate;
          double taxAmount = item.taxAmount;

          // If tax rate is not set but we have a tax code, try to get it from calculator
          if (taxRate <= 0 &&
              item.item.taxCode.isNotEmpty &&
              _taxCalculator != null) {
            taxRate = _taxCalculator!.getTaxPercentage(item.item.taxCode);
          }

          // If tax amount is not set but we have a rate, calculate it
          if (taxAmount <= 0 && taxRate > 0) {
            taxAmount = priceBeforeTax * (taxRate / 100);
          }

          return {
            'itemCode': item.item.itemCode,
            'description': item.item.description,
            'quantity': item.quantity,
            'unitPrice': item.item.sellUnitPrice,
            'taxCode': item.item.taxCode,
            'taxRate': taxRate,
            'taxAmount': taxAmount,
            'priceBeforeTax': priceBeforeTax,
            'isReturn': false,
          };
        }).toList();

    allItems.addAll(regularItems);

    // Add return items if they exist
    if (_returnInvoices != null && _returnInvoices!.isNotEmpty) {
      for (final returnInvoice in _returnInvoices!) {
        final items = returnInvoice['items'] as List<Map<String, dynamic>>;
        final returnItems =
            items.map((item) {
              // Calculate price before tax for return item
              final priceBeforeTax =
                  (item['unitPrice'] as double) *
                  (item['quantity'] as int).abs();

              // Calculate tax for return item
              double taxRate = item['tax_pc'] as double? ?? 0.0;
              double taxAmount = item['tax_amt'] as double? ?? 0.0;

              // If we have a tax code but no rate, try to get it from calculator
              if (taxRate <= 0 &&
                  (item['taxCode'] as String?)?.isNotEmpty == true &&
                  _taxCalculator != null) {
                taxRate = _taxCalculator!.getTaxPercentage(
                  item['taxCode'] as String,
                );
              }

              // If we have a rate but no amount, calculate the tax amount
              if (taxAmount <= 0 && taxRate > 0) {
                taxAmount = priceBeforeTax * (taxRate / 100);
              }

              return {
                'itemCode': item['itemCode'] as String,
                'description': item['description'] as String,
                'quantity':
                    -(item['quantity'] as int), // Negative quantity for returns
                'unitPrice': item['unitPrice'] as double,
                'taxCode': item['taxCode'] as String? ?? '',
                'taxRate': taxRate,
                'taxAmount': -taxAmount, // Make tax amount negative for returns
                'priceBeforeTax':
                    -priceBeforeTax, // Make price before tax negative for returns
                'isReturn': true,
              };
            }).toList();
        allItems.addAll(returnItems);
      }
    }

    return pw.Table(
      border: pw.TableBorder(
        left: pw.BorderSide(color: PdfColors.black, width: 1),
        right: pw.BorderSide(color: PdfColors.black, width: 1),
        top: pw.BorderSide(color: PdfColors.black, width: 1),
        bottom: pw.BorderSide(color: PdfColors.black, width: 1),
        horizontalInside: pw.BorderSide(color: PdfColors.black, width: 0.7),
        verticalInside: pw.BorderSide(color: PdfColors.black, width: 0.7),
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5), // Price after tax
        1: const pw.FlexColumnWidth(1), // Tax
        2: const pw.FlexColumnWidth(1.5), // Price before tax
        3: const pw.FlexColumnWidth(1), // Quantity
        4: const pw.FlexColumnWidth(3), // Description
        5: const pw.FlexColumnWidth(1), // Item Code
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(2)),
          ),
          children: [
            _buildTableCell(l10n.grandTotal, isHeader: true),
            _buildTableCell('الضريبة', isHeader: true),
            _buildTableCell('السعر', isHeader: true),
            _buildTableCell(l10n.quantity, isHeader: true),
            _buildTableCell(l10n.description, isHeader: true),
            _buildTableCell(l10n.itemCode, isHeader: true),
          ],
        ),
        // Item rows
        ...allItems.map((item) {
          final itemCode = item['itemCode'] as String;
          final description = item['description'] as String;
          final quantity = item['quantity'] as int;
          final unitPrice = item['unitPrice'] as double;
          final taxCode = item['taxCode'] as String;
          final priceBeforeTax = item['priceBeforeTax'] as double;
          final taxRate = item['taxRate'] as double;
          final taxAmount = item['taxAmount'] as double;

          final priceAfterTax = priceBeforeTax + taxAmount;

          return pw.TableRow(
            children: [
              _buildTableCell(priceAfterTax.toStringAsFixed(2)),
              _buildTableCell(
                taxAmount != 0 || taxRate > 0
                    ? '${taxAmount.toStringAsFixed(2)}\n(${taxRate.toStringAsFixed(1)}%)'
                    : 'معفى من الضريبة',
              ),
              _buildTableCell(priceBeforeTax.toStringAsFixed(2)),
              _buildTableCell(quantity.abs().toString()),
              _buildTableCell(description),
              _buildTableCell(itemCode),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTotals() {
    // Get base values from invoice state
    final subtotal = widget.invoice.subtotal;
    final discount = widget.invoice.discount;
    final total = subtotal - (discount > 0 ? discount : 0);
    final salesTax = widget.invoice.salesTax;
    final grandTotal = widget.invoice.grandTotal;

    // Calculate return totals if they exist
    double returnSubtotal = 0;
    double returnSalesTax = 0;
    double returnGrandTotal = 0;

    if (_returnInvoices != null && _returnInvoices!.isNotEmpty) {
      for (final returnInvoice in _returnInvoices!) {
        // Sum up all return items
        final items = returnInvoice['items'] as List<Map<String, dynamic>>;
        for (final item in items) {
          final quantity = item['quantity'] as int;
          final unitPrice = item['unitPrice'] as double;
          final priceBeforeTax = unitPrice * quantity;

          // Calculate tax for return item
          double taxRate = item['tax_pc'] as double? ?? 0.0;
          double taxAmount = item['tax_amt'] as double? ?? 0.0;

          // If we have a tax code but no rate, try to get it from calculator
          if (taxRate <= 0 &&
              (item['taxCode'] as String?)?.isNotEmpty == true &&
              _taxCalculator != null) {
            taxRate = _taxCalculator!.getTaxPercentage(
              item['taxCode'] as String,
            );
          }

          // If we have a rate but no amount, calculate the tax amount
          if (taxAmount <= 0 && taxRate > 0) {
            taxAmount = priceBeforeTax * (taxRate / 100);
          }

          // For return items with tax, subtract the total amount (including tax)
          // from both subtotal and grand total
          if (taxAmount > 0) {
            final totalAmount = priceBeforeTax + taxAmount;
            returnSubtotal += totalAmount;
            returnGrandTotal += totalAmount;
          } else {
            // For return items without tax, subtract from subtotal
            returnSubtotal += priceBeforeTax;
          }
        }
      }
    }

    // Calculate final totals after deducting returns
    final finalSubtotal = subtotal - returnSubtotal;
    final finalSalesTax = salesTax - returnSalesTax;
    final finalGrandTotal = grandTotal - returnGrandTotal;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Divider(color: PdfColors.grey300),
          _buildTotalRow(l10n.subTotal, finalSubtotal),
          _buildTotalRow(l10n.salesTax, finalSalesTax, isPrimary: true),
          _buildTotalRow(
            l10n.grandTotal,
            finalGrandTotal,
            isBold: true,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // Enhanced table cell for better Arabic text rendering
  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    PdfColor? textColor,
  }) {
    // Check if the text contains Arabic characters (which need special handling)
    bool containsArabic = text.contains(RegExp(r'[\u0600-\u06FF]'));

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : null,
          // Explicitly use Arabic font if the text contains Arabic characters
          font: containsArabic ? _arabicFont : null,
          fontSize: isHeader ? 10 : 9, // Slightly smaller for better fitting
          color: textColor, // Use the specified color if provided
        ),
        textAlign:
            containsArabic || isHeader
                ? pw.TextAlign.center
                : pw.TextAlign.left,
        textDirection:
            containsArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      ),
    );
  }

  pw.Widget _buildTotalRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    final textStyle = pw.TextStyle(
      fontWeight: isBold ? pw.FontWeight.bold : null,
      color: isPrimary ? PdfColors.blue700 : null,
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(label, style: textStyle),
          pw.SizedBox(width: 20),
          pw.Text(
            l10n.currency(amount.toStringAsFixed(2), _currency ?? "?"),
            style: textStyle,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (widget.invoice.comment.isNotEmpty)
          pw.Text('${l10n.comment}: ${widget.invoice.comment}'),
        pw.SizedBox(height: 8),
        pw.Text("المندوب: $_userId"),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          l10n.thankYouForYourBusiness,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  Future<void> _sharePdf() async {
    if (_pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noPdfFileToShare),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final result = await Share.shareXFiles(
        [XFile(_pdfPath!)],
        text: widget.isReturn ? l10n.sharingReturnInvoice : l10n.sharingInvoice,
      );

      if (result.status == ShareResultStatus.success) {
        debugPrint('Invoice shared successfully');
      } else if (result.status == ShareResultStatus.dismissed) {
        debugPrint('Share was dismissed');
      }
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Get formatted invoice number consistently
  String get formattedInvoiceNumber {
    return _userId != null && _userId!.isNotEmpty
        ? '${_userId!}-${widget.invoice.invoiceNumber ?? "New"}'
        : widget.invoice.invoiceNumber ?? "New";
  }

  // Helper method to directly log tax information for all items
  void _logInvoiceItemTaxes() {
    if (_taxCalculator == null) {
      debugPrint(
        'WARNING: Cannot log invoice item taxes - tax calculator not initialized',
      );
      return;
    }

    final items =
        widget.isReturn ? widget.invoice.returnItems : widget.invoice.items;

    debugPrint('\n======= INVOICE ITEM TAX CODES =======');
    debugPrint('Total items: ${items.length}');

    for (var item in items) {
      final taxCode = item.item.taxCode;
      final taxRate = _taxCalculator!.getTaxPercentage(taxCode);
      final priceBeforeTax = item.item.sellUnitPrice * item.quantity;
      final taxAmount = _taxCalculator!.calculateTax(taxCode, priceBeforeTax);

      debugPrint(
        'Item: ${item.item.itemCode}, TaxCode: $taxCode, ' +
            'Rate: $taxRate%, Amount: $taxAmount, ' +
            'Price: ${priceBeforeTax.toStringAsFixed(2)}',
      );
    }

    debugPrint('======================================\n');
  }

  // Navigate to thermal printing page
  void _navigateToThermalPrinting() {
    // Create invoice items for thermal printing from current invoice
    final items =
        widget.isReturn ? widget.invoice.returnItems : widget.invoice.items;
    List<Map<String, dynamic>> thermalItems =
        items.map((item) {
          return {
            'name': item.item.description,
            'quantity': item.quantity,
            'price': l10n.currency(
              (item.item.sellUnitPrice * item.quantity).toStringAsFixed(2),
              _currency ?? "",
            ),
          };
        }).toList();

    // Calculate total and tax for thermal printing
    final subtotal =
        widget.isReturn
            ? widget.invoice.returnSubtotal
            : widget.invoice.subtotal;
    final salesTax =
        widget.isReturn
            ? widget.invoice.returnSalesTax
            : widget.invoice.salesTax;
    final grandTotal =
        widget.isReturn
            ? widget.invoice.returnGrandTotal
            : widget.invoice.grandTotal;

    // Format totals for thermal printing
    Map<String, dynamic> totals = {
      'subtotal': l10n.currency(subtotal.toStringAsFixed(2), _currency ?? ""),
      'tax': l10n.currency(salesTax.toStringAsFixed(2), _currency ?? ""),
      'total': l10n.currency(grandTotal.toStringAsFixed(2), _currency ?? ""),
    };

    // Generate receipt data
    final receiptTitle = _companyInfo?.companyName ?? "YOUR BUSINESS";
    final footer =
        "Thank you for your business!\nInvoice #$formattedInvoiceNumber";
    final qrData =
        "INV-$formattedInvoiceNumber-${DateTime.now().millisecondsSinceEpoch}";

    // Navigate to the thermal printing page with invoice data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PrintingPage(
              preloadedInvoiceData: {
                'items': thermalItems,
                'totals': totals,
                'title': receiptTitle,
                'footer': footer,
                'qrData': qrData,
                'customerName': widget.customer.customerName,
              },
            ),
      ),
    );
  }

  // Load return invoices for the current customer
  Future<void> _loadReturnInvoices() async {
    if (widget.isReturn) {
      // Skip loading return invoices if this is already a return invoice
      _returnInvoicesLoaded = true;
      return;
    }

    try {
      debugPrint(
        'Loading return invoices for customer: ${widget.customer.customerCode}',
      );
      final invoiceTable = GetIt.I<InvoiceTable>();

      // Get all invoices for this customer
      final allCustomerInvoices = await invoiceTable.getInvoicesForCustomer(
        widget.customer.customerCode,
      );

      // Filter to only return invoices
      final returnInvoices =
          allCustomerInvoices
              .where((invoice) => invoice['isReturn'] == 1)
              .toList();

      debugPrint(
        'Found ${returnInvoices.length} return invoices for customer ${widget.customer.customerCode}',
      );

      setState(() {
        _returnInvoices = returnInvoices;
        _returnInvoicesLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading return invoices: $e');
      setState(() {
        _returnInvoices = [];
        _returnInvoicesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildGradientHeader(context),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child:
                      _isGenerating
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(l10n.generatingPdf),
                              ],
                            ),
                          )
                          : _pdfPath != null
                          ? PdfPreview(
                            pdfFileName:
                                widget.isReturn
                                    ? 'return_invoice_${formattedInvoiceNumber}.pdf'
                                    : 'invoice_${formattedInvoiceNumber}.pdf',
                            build:
                                (format) => File(_pdfPath!).readAsBytesSync(),
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                            canDebug: false,
                            allowPrinting: true,
                            allowSharing: false,
                            loadingWidget: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                            initialPageFormat: PdfPageFormat.a4,
                            pdfPreviewPageDecoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            useActions: false,
                            padding: const EdgeInsets.all(8),
                          )
                          : Center(child: Text(l10n.errorGeneratingPdf)),
                ),
                GradientFormCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.share),
                          label: Text(l10n.share),
                          onPressed: _isGenerating ? null : _sharePdf,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.print),
                          label: Text(l10n.print),
                          onPressed:
                              _isGenerating
                                  ? null
                                  : () async {
                                    if (_pdfPath != null) {
                                      try {
                                        await Printing.layoutPdf(
                                          onLayout:
                                              (_) =>
                                                  File(
                                                    _pdfPath!,
                                                  ).readAsBytesSync(),
                                        );
                                      } catch (e) {
                                        debugPrint('Error printing PDF: $e');
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error printing PDF: $e',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.receipt),
                          label: Text(
                            'Thermal',
                          ), // Use localization in production
                          onPressed:
                              _isGenerating ? null : _navigateToThermalPrinting,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customer.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.isReturn ? l10n.returnInvoice : l10n.printInvoice,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Right-side actions
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _isGenerating ? null : _sharePdf,
                tooltip: l10n.share,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
