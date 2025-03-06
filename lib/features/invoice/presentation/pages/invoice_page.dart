import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class InvoicePage extends StatefulWidget {
  final CustomerEntity customer;
  final bool isReturn;

  const InvoicePage({Key? key, required this.customer, this.isReturn = false})
    : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final TextEditingController _commentController = TextEditingController();
  late final InvoiceBloc _invoiceBloc;
  late final bool _isReturn;

  @override
  void initState() {
    super.initState();
    _isReturn = widget.isReturn;
    _invoiceBloc = InvoiceBloc();
    _invoiceBloc.add(
      InitializeInvoice(customerCode: widget.customer.customerCode),
    );
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
                  _buildActionButtons(context, state, localizations),
                  Expanded(
                    child: _buildBody(context, state, theme, localizations),
                  ),
                  _buildBottomBar(context, state, theme, localizations),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    InvoiceState state,
    AppLocalizations localizations,
  ) {
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
                  state.customer.customerName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              state.paymentType,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InvoiceState state,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Invoice section - only show if not in return mode
        if (!_isReturn)
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
                _buildAmountRow(
                  localizations.grandTotal,
                  state.grandTotal,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        if (!_isReturn) const SizedBox(height: 16),

        // Return section - always show in return mode, otherwise show conditionally
        if (_isReturn)
          _buildSectionCard(
            title: localizations.returnItems,
            child: Column(
              children: [
                _buildAmountRow(localizations.subTotal, state.returnSubtotal),
                _buildAmountRow(localizations.discount, state.returnDiscount),
                const Divider(),
                _buildAmountRow(
                  localizations.total,
                  state.returnTotal,
                  isBold: true,
                ),
                _buildAmountRow(localizations.salesTax, state.returnSalesTax),
                const Divider(),
                _buildAmountRow(
                  localizations.grandTotal,
                  state.returnGrandTotal,
                  isPrimary: true,
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // // Summary section - only show if not in return mode
        // if (!_isReturn)
        //   _buildSectionCard(
        //     title: localizations.summary,
        //     child: Column(
        //       children: [
        //         _buildAmountRow(
        //           localizations.netSubTotal,
        //           state.subtotal - state.returnSubtotal,
        //         ),
        //         _buildAmountRow(
        //           localizations.netDiscount,
        //           state.discount - state.returnDiscount,
        //         ),
        //         const Divider(),
        //         _buildAmountRow(
        //           localizations.netTotal,
        //           state.total - state.returnTotal,
        //           isBold: true,
        //         ),
        //         _buildAmountRow(
        //           localizations.netSalesTax,
        //           state.salesTax - state.returnSalesTax,
        //         ),
        //         const Divider(),
        //         _buildAmountRow(
        //           localizations.netGrandTotal,
        //           state.grandTotal - state.returnGrandTotal,
        //           isPrimary: true,
        //         ),
        //       ],
        //     ),
        //   ),
        // if (!_isReturn) const SizedBox(height: 16),
        // const SizedBox(height: 16),

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
        const SizedBox(height: 24), // Bottom padding
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return GradientFormCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        final labelStyle = (isBold || isPrimary
                ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)
                : textTheme.bodyMedium)
            ?.copyWith(color: isPrimary ? AppColors.primary : null);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              Text(
                '${amount.toStringAsFixed(2)} JOD',
                style: (isBold || isPrimary
                        ? textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        )
                        : textTheme.bodyMedium)
                    ?.copyWith(
                      color: isPrimary ? AppColors.primary : null,
                      letterSpacing: -0.5, // Tighten spacing for numbers
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    InvoiceState state,
    AppLocalizations localizations,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: GradientFormCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Add item button
            _buildActionButton(
              onPressed: () => context.read<InvoiceBloc>().add(const AddItem()),
              icon: Icons.add_shopping_cart,
              label: localizations.addItem,
              count: state.itemCount,
              color: AppColors.secondary,
            ),

            // Sync button
            _buildActionButton(
              onPressed:
                  () => context.read<InvoiceBloc>().add(const SyncInvoice()),
              icon: Icons.cloud_upload,
              label: localizations.sync,
              isLoading: state.isSyncing,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    int count = 0,
    bool isLoading = false,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: color,
                            strokeWidth: 2,
                          ),
                        )
                        : Icon(icon, color: color, size: 24),
              ),
              if (count > 0 && !isLoading)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    InvoiceState state,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return GradientFormCard(
      padding: const EdgeInsets.all(16.0),
      borderRadius: 0, // No rounded corners for the bottom bar
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
              child:
                  state.isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Builder(
                        builder: (context) {
                          return Text(
                            localizations.submit,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          );
                        },
                      ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              context.read<InvoiceBloc>().add(const PrintInvoice());
            },
            icon:
                state.isPrinting
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
