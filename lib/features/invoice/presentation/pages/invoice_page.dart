import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class InvoicePage extends StatefulWidget {
  final CustomerEntity customer;

  const InvoicePage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final TextEditingController _commentController = TextEditingController();
  late final InvoiceBloc _invoiceBloc;

  @override
  void initState() {
    super.initState();
    _invoiceBloc = InvoiceBloc();
    _invoiceBloc.add(InitializeInvoice(customerCode: widget.customer.customerCode));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _invoiceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    
    return BlocProvider.value(
      value: _invoiceBloc,
      child: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state, localizations),
                  Expanded(
                    child: _buildBody(context, state, theme, localizations),
                  ),
                  _buildBottomBar(context, state, theme, localizations),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: _buildFloatingButtons(context, state),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, InvoiceState state, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.invoice,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.customer.customerName,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(state.paymentType),
            backgroundColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, InvoiceState state, ThemeData theme, AppLocalizations localizations) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Invoice section
        _buildSectionCard(
          title: localizations.invoice,
          child: Column(
            children: [
              _buildAmountRow(localizations.subTotal, state.subtotal),
              _buildAmountRow(localizations.discount, state.discount),
              const Divider(),
              _buildAmountRow(localizations.total, state.total, isBold: true),
              _buildAmountRow(localizations.salesTax, state.salesTax),
              const Divider(),
              _buildAmountRow(localizations.grandTotal, state.grandTotal, isPrimary: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Return section
        _buildSectionCard(
          title: localizations.returnItems,
          child: Column(
            children: [
              _buildAmountRow(localizations.subTotal, state.returnSubtotal),
              _buildAmountRow(localizations.discount, state.returnDiscount),
              const Divider(),
              _buildAmountRow(localizations.total, state.returnTotal, isBold: true),
              _buildAmountRow(localizations.salesTax, state.returnSalesTax),
              const Divider(),
              _buildAmountRow(localizations.grandTotal, state.returnGrandTotal, isPrimary: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Summary section
        _buildSectionCard(
          title: localizations.summary,
          child: Column(
            children: [
              _buildAmountRow(
                localizations.netSubTotal, 
                state.subtotal - state.returnSubtotal
              ),
              _buildAmountRow(
                localizations.netDiscount, 
                state.discount - state.returnDiscount
              ),
              const Divider(),
              _buildAmountRow(
                localizations.netTotal, 
                state.total - state.returnTotal, 
                isBold: true
              ),
              _buildAmountRow(
                localizations.netSalesTax, 
                state.salesTax - state.returnSalesTax
              ),
              const Divider(),
              _buildAmountRow(
                localizations.netGrandTotal, 
                state.grandTotal - state.returnGrandTotal, 
                isPrimary: true
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Comment field
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: localizations.addComment,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 2,
          onChanged: (value) {
            context.read<InvoiceBloc>().add(UpdateComment(comment: value));
          },
        ),
        const SizedBox(height: 80), // Space for floating buttons
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isBold = false, bool isPrimary = false}) {
    final textStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: isBold || isPrimary ? FontWeight.w500 : FontWeight.w400,
      color: isPrimary ? AppColors.primary : null,
    );
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(
            '${amount.toStringAsFixed(2)} SAR',
            style: GoogleFonts.robotoMono(
              fontSize: 14,
              fontWeight: isBold || isPrimary ? FontWeight.w500 : FontWeight.w400,
              color: isPrimary ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context, InvoiceState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 72.0), // Space for the bottom bar
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Add item button
          FloatingActionButton.extended(
            heroTag: 'addItem',
            onPressed: () => context.read<InvoiceBloc>().add(const AddItem()),
            label: const Text('Add Item'),
            icon: Badge(
              isLabelVisible: state.itemCount > 0,
              label: Text('${state.itemCount}'),
              child: const Icon(Icons.add_shopping_cart),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: 8),
          
          // Return item button
          FloatingActionButton.extended(
            heroTag: 'returnItem',
            onPressed: () => context.read<InvoiceBloc>().add(const ReturnItem()),
            label: const Text('Return Item'),
            icon: Badge(
              isLabelVisible: state.returnCount > 0,
              label: Text('${state.returnCount}'),
              child: const Icon(Icons.assignment_return),
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: 8),
          
          // Sync button
          FloatingActionButton(
            heroTag: 'sync',
            onPressed: () => context.read<InvoiceBloc>().add(const SyncInvoice()),
            child: state.isSyncing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.cloud_upload),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, InvoiceState state, ThemeData theme, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<InvoiceBloc>().add(const SubmitInvoice());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: state.isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      localizations.submit,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              context.read<InvoiceBloc>().add(const PrintInvoice());
            },
            icon: state.isPrinting
                ? const CircularProgressIndicator()
                : const Icon(Icons.picture_as_pdf),
            tooltip: localizations.print,
            color: AppColors.primary,
            iconSize: 32,
          ),
        ],
      ),
    );
  }
}