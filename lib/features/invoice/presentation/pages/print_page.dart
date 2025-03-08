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
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    // Don't call _generatePdf() here - it will be called in didChangeDependencies
    _loadFonts();
  }

  Future<void> _loadFonts() async {
    try {
      // Load the Arabic font from assets
      final fontData = await rootBundle.load(
        'assets/fonts/NotoKufiArabic-Regular.ttf',
      );
      _arabicFont = pw.Font.ttf(fontData.buffer.asByteData());
      debugPrint('Arabic font loaded successfully');
    } catch (e) {
      debugPrint('Error loading Arabic font: $e');
      // Fallback to default font if loading fails
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);

    // Only generate PDF on the first call to didChangeDependencies
    if (!_didInitialize) {
      _didInitialize = true;
      _generatePdf();
    }
  }

  Future<void> _generatePdf() async {
    if (mounted) {
      setState(() {
        _isGenerating = true;
      });
    }

    try {
      // Make sure font is loaded
      if (_arabicFont == null) {
        await _loadFonts();
      }

      final pdf = pw.Document();

      // Create a theme with Arabic font
      final theme = pw.ThemeData.withFont(
        base: _arabicFont ?? await pw.Font.courier(),
        bold: _arabicFont ?? await pw.Font.courier(),
        italic: _arabicFont ?? await pw.Font.courier(),
        boldItalic: _arabicFont ?? await pw.Font.courier(),
      );

      // Add pages to the PDF with the theme
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) {
            return [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildCustomerInfo(),
              pw.SizedBox(height: 20),
              _buildInvoiceDetails(),
              pw.SizedBox(height: 20),
              _buildItemsTable(),
              pw.SizedBox(height: 20),
              _buildTotals(),
              pw.SizedBox(height: 30),
              _buildFooter(),
            ];
          },
        ),
      );

      // Save the PDF
      final output = await getTemporaryDirectory();
      final file = File(
        '${output.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        setState(() {
          _pdfPath = file.path;
          _isGenerating = false;
        });
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      if (mounted) {
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
  }

  pw.Widget _buildHeader() {
    final title =
        widget.isReturn
            ? '${l10n.returnItem} #${widget.invoice.invoiceNumber ?? "New"}'
            : '${l10n.invoice} #${widget.invoice.invoiceNumber ?? "New"}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
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
          pw.Text(
            l10n.customerInformation,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
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
                    pw.Text(
                      '${l10n.customerCode}: ${widget.customer.customerCode}',
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${l10n.phone}: ${widget.customer.contactPhone ?? "-"}',
                    ),
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
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${l10n.paymentType}: ${widget.invoice.paymentType}'),
                if (widget.invoice.comment.isNotEmpty)
                  pw.Text('${l10n.comment}: ${widget.invoice.comment}'),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${l10n.date}: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                ),
                pw.Text(
                  '${l10n.time}: ${DateFormat('HH:mm').format(DateTime.now())}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable() {
    final items =
        widget.isReturn ? widget.invoice.returnItems : widget.invoice.items;

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(1), // Item Code
        1: const pw.FlexColumnWidth(3), // Description
        2: const pw.FlexColumnWidth(1), // Quantity
        3: const pw.FlexColumnWidth(1), // Unit Price
        4: const pw.FlexColumnWidth(1), // Total
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell(l10n.itemCode, isHeader: true),
            _buildTableCell(l10n.description, isHeader: true),
            _buildTableCell(l10n.quantity, isHeader: true),
            _buildTableCell(l10n.unitPrice, isHeader: true),
            _buildTableCell(l10n.total, isHeader: true),
          ],
        ),
        // Item rows
        ...items
            .map(
              (item) => pw.TableRow(
                children: [
                  _buildTableCell(item.item.itemCode),
                  _buildTableCell(item.item.description),
                  _buildTableCell(item.quantity.toString()),
                  _buildTableCell(
                    '${item.item.sellUnitPrice.toStringAsFixed(2)} JOD',
                  ),
                  _buildTableCell('${item.totalPrice.toStringAsFixed(2)} JOD'),
                ],
              ),
            )
            .toList(),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: isHeader ? pw.FontWeight.bold : null),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  pw.Widget _buildTotals() {
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

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildTotalRow(l10n.subTotal, subtotal),
          _buildTotalRow(l10n.discount, discount),
          pw.Divider(),
          _buildTotalRow(l10n.total, total, isBold: true),
          _buildTotalRow(l10n.salesTax, salesTax),
          pw.Divider(),
          _buildTotalRow(
            l10n.grandTotal,
            grandTotal,
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
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          l10n.thankYouForYourBusiness,
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
                                    ? 'return_invoice_${widget.invoice.invoiceNumber ?? "new"}.pdf'
                                    : 'invoice_${widget.invoice.invoiceNumber ?? "new"}.pdf',
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
