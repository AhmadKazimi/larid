import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../../../../core/router/route_constants.dart';

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
    _invoiceBloc = getIt<InvoiceBloc>();

    // Listen for state changes to update the comment controller
    _invoiceBloc.stream.listen((state) {
      if (state.comment.isNotEmpty &&
          _commentController.text != state.comment) {
        debugPrint('Setting comment controller text: ${state.comment}');
        _commentController.text = state.comment;
      }

      // Debug current invoice state
      if (!state.isLoading) {
        debugPrint('Invoice state updated:');
        debugPrint('- Invoice Number: ${state.invoiceNumber ?? "New Invoice"}');
        debugPrint('- Items Count: ${state.items.length}');
        debugPrint('- Return Items Count: ${state.returnItems.length}');
        debugPrint('- Grand Total: ${state.grandTotal}');
      }
    });

    // Initialize the invoice after setup
    debugPrint(
      'Initializing invoice for customer: ${widget.customer.customerCode}',
    );
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
          // Show loading indicator when loading
          if (state.isLoading) {
            debugPrint('🔄 Showing loading indicator for invoice page');
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Loading invoice...',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          debugPrint(
            '🏗️ Building invoice page for ${state.customer.customerName} with:',
          );
          debugPrint(
            '- Invoice Number: ${state.invoiceNumber ?? "New Invoice"}',
          );
          debugPrint(
            '- Items: ${state.items.length}, Return Items: ${state.returnItems.length}',
          );
          debugPrint(
            '- Subtotal: ${state.subtotal}, Grand Total: ${state.grandTotal}',
          );

          return Scaffold(
            // Added Scaffold to provide Material context
            body: Column(
              children: [
                _buildGradientHeader(context, state, localizations),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        _buildActionButtons(context, state, localizations),
                        Expanded(
                          child: _buildBody(
                            context,
                            state,
                            theme,
                            localizations,
                          ),
                        ),
                        _buildBottomBar(context, state, theme, localizations),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientHeader(
    BuildContext context,
    InvoiceState state,
    AppLocalizations localizations,
  ) {
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
                      state.customer.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _isReturn
                          ? localizations.returnItem
                          : localizations.invoice,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  state.paymentType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary),
            ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              state.paymentType,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
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
    // Use a unique key based on state values to force rebuild when they change
    final invoiceCardKey = ValueKey(
      'invoice-card-${state.subtotal}-${state.grandTotal}-${state.items.length}',
    );
    final returnCardKey = ValueKey(
      'return-card-${state.returnSubtotal}-${state.returnGrandTotal}-${state.returnItems.length}',
    );

    debugPrint(
      'Building invoice body with (reusing keys: $invoiceCardKey, $returnCardKey)',
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Display items if any (non-return mode)
        if (!_isReturn && state.items.isNotEmpty)
          _buildSectionCard(
            title: localizations.items,
            child: Column(
              children: [
                ...state.items.map(
                  (item) => _buildItemRow(context, item, false),
                ),
              ],
            ),
          ),
        if (!_isReturn && state.items.isNotEmpty) const SizedBox(height: 16),

        // Display return items if any (return mode)
        if (_isReturn && state.returnItems.isNotEmpty)
          _buildSectionCard(
            title: localizations.returnItems,
            child: Column(
              children: [
                ...state.returnItems.map(
                  (item) => _buildItemRow(context, item, true),
                ),
              ],
            ),
          ),
        if (_isReturn && state.returnItems.isNotEmpty)
          const SizedBox(height: 16),

        // Invoice section - only show if not in return mode
        if (!_isReturn)
          _buildSectionCard(
            key: invoiceCardKey,
            title: localizations.invoice,
            child: Column(
              children: [
                _buildAmountRow(localizations.subTotal, state.subtotal),
                if (state.discount > 0)
                  _buildAmountRow(localizations.discount, state.discount),
                _buildAmountRow(localizations.total, state.total),
                _buildAmountRow(
                  localizations.salesTax,
                  state.salesTax,
                  isPrimary: true,
                ),
                _buildAmountRow(
                  localizations.grandTotal,
                  state.grandTotal,
                  isBold: true,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        if (!_isReturn) const SizedBox(height: 16),

        // Return section - always show in return mode
        if (_isReturn)
          _buildSectionCard(
            key: returnCardKey,
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

  Widget _buildSectionCard({
    Key? key,
    required String title,
    required Widget child,
  }) {
    return GradientFormCard(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
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

  Widget _buildItemRow(
    BuildContext context,
    InvoiceItemModel invoiceItem,
    bool isReturn,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = context.read<InvoiceBloc>();
    final localizations = AppLocalizations.of(context);

    // Get tax calculator to display tax information
    final taxCalculator = bloc.getTaxCalculator();
    final hasTax = taxCalculator?.hasTax(invoiceItem.item.taxCode) ?? false;
    final taxRate =
        taxCalculator?.getTaxPercentage(invoiceItem.item.taxCode) ?? 0.0;

    // Calculate tax amounts
    final priceBeforeTax =
        invoiceItem.item.sellUnitPrice * invoiceItem.quantity;
    final taxAmount =
        taxCalculator?.calculateTax(invoiceItem.item.taxCode, priceBeforeTax) ??
        0.0;
    final priceAfterTax = priceBeforeTax + taxAmount;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item header - code and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item code with colored background
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      invoiceItem.item.itemCode,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Total price with prominent styling
                  Text(
                    '${priceAfterTax.toStringAsFixed(2)} JOD',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Item description
              Text(
                invoiceItem.item.description,
                style: textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Price breakdown and quantity controls
              Row(
                children: [
                  // Price information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unit price
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${invoiceItem.item.sellUnitPrice.toStringAsFixed(2)} × ${invoiceItem.quantity}',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        // Tax information if applicable
                        if (hasTax && taxRate > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'ضريبة ${taxRate.toStringAsFixed(1)}%: ${taxAmount.toStringAsFixed(2)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Quantity controls - redesigned with fully circular buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decrease button (circular)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            if (invoiceItem.quantity > 1) {
                              bloc.add(
                                UpdateItemQuantity(
                                  item: invoiceItem,
                                  quantity: invoiceItem.quantity - 1,
                                  isReturn: isReturn,
                                ),
                              );
                            } else {
                              bloc.add(
                                RemoveItem(
                                  item: invoiceItem,
                                  isReturn: isReturn,
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      // Quantity display
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        alignment: Alignment.center,
                        child: Text(
                          '${invoiceItem.quantity}',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Increase button (circular)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () {
                            bloc.add(
                              UpdateItemQuantity(
                                item: invoiceItem,
                                quantity: invoiceItem.quantity + 1,
                                isReturn: isReturn,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Divider for visual separation between items
        Divider(color: Colors.grey.shade200, height: 1),
      ],
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
              onPressed: () async {
                // Create a map of previously selected items to send to the items page
                final Map<String, int> preselectedItems = {};

                // Add current items to the preselected map
                if (_isReturn) {
                  for (final item in state.returnItems) {
                    preselectedItems[item.item.itemCode] = item.quantity;
                  }
                } else {
                  for (final item in state.items) {
                    preselectedItems[item.item.itemCode] = item.quantity;
                  }
                }

                // Navigate to items page using GoRouter and capture the result
                final result = await context.push<Map<String, dynamic>>(
                  RouteConstants.items,
                  extra: {
                    'isReturn': _isReturn,
                    'preselectedItems': preselectedItems,
                  },
                );

                // Process the returned items
                if (result != null && result.isNotEmpty) {
                  // Debug log to verify we're receiving data
                  debugPrint('Received selected items: ${result.toString()}');

                  // Extract the 'items' map from the result
                  final items = result['items'] as Map<String, dynamic>;

                  // Add items to invoice
                  if (_isReturn) {
                    context.read<InvoiceBloc>().add(
                      AddReturnItems(items: items),
                    );
                  } else {
                    context.read<InvoiceBloc>().add(
                      AddInvoiceItems(items: items),
                    );
                  }

                  // Force refresh UI by triggering invoice totals calculation
                  context.read<InvoiceBloc>().add(
                    const CalculateInvoiceTotals(),
                  );
                }
              },
              icon: Icons.add_shopping_cart,
              label:
                  _isReturn ? localizations.returnItems : localizations.addItem,
              count: _isReturn ? state.returnCount : state.itemCount,
              color: AppColors.primary,
            ),

            // Print button
            _buildActionButton(
              onPressed: () {
                // Navigate to the print page with invoice data
                context.push(
                  RouteConstants.printInvoice,
                  extra: {
                    'invoice': state,
                    'isReturn': _isReturn,
                    'customer': state.customer,
                  },
                );
              },
              icon: Icons.print,
              label: localizations.print,
              isLoading: state.isPrinting,
              color: Colors.green,
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

            // Delete invoice button
            _buildActionButton(
              onPressed: () {
                // Show confirmation dialog
                _showDeleteConfirmationDialog(context, state, localizations);
              },
              icon: Icons.delete,
              label: localizations.deleteInvoice,
              isLoading: false,
              color: Colors.red,
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
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
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
      ),
    );
  }

  // Show confirmation dialog for invoice deletion
  void _showDeleteConfirmationDialog(
    BuildContext context,
    InvoiceState state,
    AppLocalizations localizations,
  ) {
    // Get the currently displayed invoice data from the UI
    final currentInvoiceData = context.read<InvoiceBloc>().state;

    // We can only delete if there's an existing invoice number
    if (currentInvoiceData.invoiceNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No invoice to delete'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.deleteInvoice),
          content: Text(localizations.deleteConfirmation),
          actions: <Widget>[
            TextButton(
              child: Text(
                localizations.cancel,
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                localizations.deleteInvoice,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog

                // We'll simply use the ID 1 as a placeholder until the actual ID system is implemented
                // In a real app, you would get the actual invoice ID from the database
                final invoiceId = 1;

                // Dispatch delete event
                context.read<InvoiceBloc>().add(
                  DeleteInvoice(invoiceId: invoiceId),
                );

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.invoiceDeletedSuccessfully),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate back to customer screen
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    InvoiceState state,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    // Debug log to show the current number of items in the invoice
    debugPrint(
      'Current invoice state: ${state.items.length} regular items, ${state.returnItems.length} return items',
    );

    return GradientFormCard(
      padding: const EdgeInsets.all(16.0),
      borderRadius: 0, // No rounded corners for the bottom bar
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message to clarify that items need to be submitted to save to database
          if (state.items.isNotEmpty || state.returnItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                '⚠️ ${localizations.submit}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            onPressed: () {
              // Debug log when submit button is clicked
              debugPrint(
                'Submitting invoice with ${state.items.length + state.returnItems.length} items',
              );
              context.read<InvoiceBloc>().add(
                SubmitInvoice(isReturn: _isReturn),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 5,
            ),
            child:
                state.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Builder(
                      builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save),
                            const SizedBox(width: 8),
                            Text(
                              _isReturn
                                  ? '${localizations.submit} ${localizations.returnItem}'
                                  : '${localizations.submit} ${localizations.invoice}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
