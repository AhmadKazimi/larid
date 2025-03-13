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

  @override
  void initState() {
    super.initState();
    // Don't call _generatePdf() here - it will be called in didChangeDependencies
    _loadFonts();
    _getUserId();
    _getCompanyInfo();
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
    final items =
        widget.isReturn ? widget.invoice.returnItems : widget.invoice.items;

    // Debug log to check tax values
    debugPrint('Building items table with ${items.length} items');

    // Force initialization of tax calculator if needed
    if (_taxCalculator == null) {
      debugPrint('WARNING: Tax calculator is null when building items table');
      // This is a synchronous method, so we can't await the async initialization here
      // We'll rely on the fallback logic below
    } else {
      debugPrint('Tax calculator is available for PDF generation');
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
            _buildTableCell(l10n.grandTotal, isHeader: true), // Price after tax
            _buildTableCell('الضريبة', isHeader: true), // Tax
            _buildTableCell('السعر', isHeader: true), // Price before tax
            _buildTableCell(l10n.quantity, isHeader: true), // Quantity
            _buildTableCell(l10n.description, isHeader: true), // Description
            _buildTableCell(l10n.itemCode, isHeader: true), // Item Code
          ],
        ),
        // Item rows
        ...items.map((item) {
          // Get base values
          final itemCode = item.item.itemCode;
          final taxCode = item.item.taxCode;
          final quantity = item.quantity;
          final unitPrice = item.item.sellUnitPrice;

          // Calculate core values
          final priceBeforeTax =
              item.priceBeforeTax > 0
                  ? item.priceBeforeTax
                  : unitPrice * quantity;

          // 1. Default to stored values if available
          double taxRate = item.taxRate;
          double taxAmount = item.taxAmount;

          // 2. If we have a taxCode but no rate, try to get it from calculator
          if (taxRate <= 0 && taxCode.isNotEmpty && _taxCalculator != null) {
            taxRate = _taxCalculator!.getTaxPercentage(taxCode);
            debugPrint('Using tax calculator: code=$taxCode, rate=$taxRate%');
          }

          // 3. If still no rate but we have a taxCode, use gentle fallback
          if (taxRate <= 0 && taxCode.isNotEmpty) {
            // Attempt one more time with tax calculator
            if (_taxCalculator != null) {
              taxRate = _taxCalculator!.getTaxPercentage(taxCode);
              debugPrint(
                'Second attempt to get tax rate: code=$taxCode, rate=$taxRate%',
              );
            }

            // If still no rate, log warning but use 0% instead of arbitrary default
            if (taxRate <= 0) {
              debugPrint(
                'WARNING: Could not determine tax rate for code $taxCode, using 0%',
              );
              taxRate =
                  0.0; // Don't use arbitrary default rate, use 0% if truly unknown
            }
          }

          // 4. Calculate tax amount if needed
          if (taxAmount <= 0 && taxRate > 0) {
            taxAmount = priceBeforeTax * (taxRate / 100);
            debugPrint('Calculated tax amount: $taxAmount for rate $taxRate%');
          }

          // 5. Calculate final price
          final priceAfterTax = priceBeforeTax + taxAmount;

          // Show EXACTLY what will be displayed
          final taxDisplay =
              '${taxAmount.toStringAsFixed(2)} JOD\n(${taxRate.toStringAsFixed(1)}%)';
          debugPrint('Tax display in PDF: $taxDisplay');

          return pw.TableRow(
            children: [
              _buildTableCell(
                priceAfterTax.toStringAsFixed(2),
              ), // Price after tax
              _buildTableCell(
                taxAmount > 0 || taxRate > 0
                    ? '${taxAmount.toStringAsFixed(2)}\n(${taxRate.toStringAsFixed(1)}%)'
                    : 'معفى من الضريبة', // "Tax exempt" in Arabic
              ), // Tax + percentage or exempt
              _buildTableCell(
                priceBeforeTax.toStringAsFixed(2),
              ), // Price before tax
              _buildTableCell(quantity.toString()), // Quantity
              _buildTableCell(item.item.description), // Description
              _buildTableCell(itemCode), // Item Code
            ],
          );
        }),
      ],
    );
  }

  // Enhanced table cell for better Arabic text rendering
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
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

  pw.Widget _buildTotals() {
    // Get values from invoice state
    final subtotal =
        widget.isReturn
            ? widget.invoice.returnSubtotal
            : widget.invoice.subtotal;
    final discount =
        widget.isReturn
            ? widget.invoice.returnDiscount
            : widget.invoice.discount;
    final total =
        widget.isReturn ? widget.invoice.returnTotal : widget.invoice.total;
    final salesTax =
        widget.isReturn
            ? widget.invoice.returnSalesTax
            : widget.invoice.salesTax;
    final grandTotal =
        widget.isReturn
            ? widget.invoice.returnGrandTotal
            : widget.invoice.grandTotal;

    // Debug log the values
    debugPrint('PDF Totals from state:');
    debugPrint('- subtotal: $subtotal');
    debugPrint('- discount: $discount');
    debugPrint('- total (subtotal - discount): $total');
    debugPrint('- salesTax: $salesTax');
    debugPrint('- grandTotal (total + salesTax): $grandTotal');

    // Recalculate tax and total to ensure accuracy
    double calculatedTax = 0.0;
    final items =
        widget.isReturn ? widget.invoice.returnItems : widget.invoice.items;

    // Sum up all item taxes using our tax calculator
    for (var item in items) {
      final taxCode = item.item.taxCode;
      final priceBeforeTax =
          item.priceBeforeTax > 0
              ? item.priceBeforeTax
              : item.item.sellUnitPrice * item.quantity;

      double itemTaxAmount = item.taxAmount;
      if (itemTaxAmount <= 0 && taxCode.isNotEmpty) {
        // Use tax calculator if available
        if (_taxCalculator != null) {
          itemTaxAmount = calculateTaxAmount(taxCode, priceBeforeTax);
          debugPrint(
            'Using tax calculator for total: code=$taxCode, tax=$itemTaxAmount',
          );
        } else {
          // Fall back to stored tax rate or attempt to get it
          double taxRate =
              item.taxRate > 0 ? item.taxRate : getTaxRate(taxCode);

          // If still no rate, log warning but use 0% instead of arbitrary default
          if (taxRate <= 0 && taxCode.isNotEmpty) {
            debugPrint(
              'WARNING: Could not determine tax rate for totals with code $taxCode, using 0%',
            );
            taxRate = 0.0; // Don't use arbitrary default, use 0% if unknown
          }

          itemTaxAmount = priceBeforeTax * (taxRate / 100);
          debugPrint(
            'Calculated tax amount for totals: $itemTaxAmount for rate $taxRate%',
          );
        }
      }

      calculatedTax += itemTaxAmount;
    }

    // Use original value if it's reasonable, otherwise use calculated
    final finalTaxAmount = (salesTax > 0) ? salesTax : calculatedTax;
    final finalGrandTotal = total + finalTaxAmount;

    debugPrint('PDF Recalculated values:');
    debugPrint('- finalTaxAmount: $finalTaxAmount');
    debugPrint('- finalGrandTotal: $finalGrandTotal');

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Divider(color: PdfColors.grey300),

          _buildTotalRow(l10n.subTotal, subtotal),
          _buildTotalRow(l10n.salesTax, finalTaxAmount, isPrimary: true),
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
          pw.Text('${amount.toStringAsFixed(2)} JOD', style: textStyle),
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
                      const SizedBox(width: 16),
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
