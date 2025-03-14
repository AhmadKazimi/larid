import 'package:flutter/material.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/database/receipt_voucher_table.dart';
import 'package:larid/features/receipt_voucher/domain/repositories/receipt_voucher_repository.dart';
import 'package:larid/database/user_table.dart';

class ReceiptVoucherPage extends StatefulWidget {
  final CustomerEntity customer;

  const ReceiptVoucherPage({Key? key, required this.customer})
    : super(key: key);

  @override
  State<ReceiptVoucherPage> createState() => _ReceiptVoucherPageState();
}

class _ReceiptVoucherPageState extends State<ReceiptVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedPaymentMethod;

  // Payment method type mapping
  static const int CHECK_TYPE = 1;
  static const int CASH_TYPE = 2;
  static const int VISA_TYPE = 3;
  static const int TRANSFER_TYPE = 11;

  // Method to map selected payment method to API payment method type
  int getPaymentMethodType(
    String? paymentMethod,
    AppLocalizations localizations,
  ) {
    if (paymentMethod == localizations.check) {
      return CHECK_TYPE;
    } else if (paymentMethod == localizations.cash) {
      return CASH_TYPE;
    } else if (paymentMethod == localizations.creditCard) {
      return VISA_TYPE;
    } else if (paymentMethod == localizations.bankTransfer) {
      return TRANSFER_TYPE;
    }
    // Default to cash if no valid selection
    return CASH_TYPE;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildGradientHeader(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
                      localizations.receiptVoucher,
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
                  localizations.receiptVoucher,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          _buildGradientHeader(context),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.receiptDetails,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Amount field
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: localizations.amount,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.attach_money),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.pleaseEnterAmount;
                          }
                          if (double.tryParse(value) == null) {
                            return localizations.pleaseEnterValidNumber;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Payment method selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.paymentMethod,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.5,
                            children: [
                              _buildPaymentOption(
                                context,
                                localizations.cash,
                                Icons.money,
                                _selectedPaymentMethod == localizations.cash,
                                () => setState(
                                  () =>
                                      _selectedPaymentMethod =
                                          localizations.cash,
                                ),
                              ),
                              _buildPaymentOption(
                                context,
                                localizations.check,
                                Icons.payment,
                                _selectedPaymentMethod == localizations.check,
                                () => setState(
                                  () =>
                                      _selectedPaymentMethod =
                                          localizations.check,
                                ),
                              ),
                              _buildPaymentOption(
                                context,
                                localizations.bankTransfer,
                                Icons.account_balance,
                                _selectedPaymentMethod ==
                                    localizations.bankTransfer,
                                () => setState(
                                  () =>
                                      _selectedPaymentMethod =
                                          localizations.bankTransfer,
                                ),
                              ),
                              _buildPaymentOption(
                                context,
                                localizations.creditCard,
                                Icons.credit_card,
                                _selectedPaymentMethod ==
                                    localizations.creditCard,
                                () => setState(
                                  () =>
                                      _selectedPaymentMethod =
                                          localizations.creditCard,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Notes field
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: localizations.notes,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.note),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        maxLines: 3,
                      ),

                      const SizedBox(
                        height: 80,
                      ), // Add padding for the fixed button
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Fixed save button at bottom
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Show loading dialog
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) => AlertDialog(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  localizations.savingReceiptVoucher,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                    );

                    // Save to local database
                    final receiptVoucherTable = getIt<ReceiptVoucherTable>();
                    await receiptVoucherTable.saveReceiptVoucher(
                      customerCode: widget.customer.customerCode,
                      paidAmount: double.parse(_amountController.text),
                      paymentType: _selectedPaymentMethod!,
                      description: _notesController.text,
                      comment: _notesController.text,
                    );

                    // Get user credentials
                    final userTable = getIt<UserTable>();
                    final user = await userTable.getCurrentUser();
                    if (user == null) {
                      throw Exception('User not found');
                    }

                    // Upload to server
                    final repository = getIt<ReceiptVoucherRepository>();
                    final result = await repository.uploadReceiptVoucher(
                      userid: user.userid,
                      workspace: user.workspace,
                      password: user.password,
                      customerCode: widget.customer.customerCode,
                      paidAmount: double.parse(_amountController.text),
                      description: _notesController.text,
                      paymentmethod: getPaymentMethodType(
                        _selectedPaymentMethod,
                        localizations,
                      ),
                    );

                    // Close loading dialog
                    if (!mounted) return;
                    Navigator.of(context).pop();

                    if (result['success']) {
                      // Show success dialog with receipt number
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text(localizations.success),
                              content: Text(
                                '${localizations.receiptVoucherSaved}\n${localizations.receiptVoucher} #${result['number']}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.pop();
                                  },
                                  child: Text(localizations.ok),
                                ),
                              ],
                            ),
                      );
                    } else {
                      // Show error message
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations.errorSavingReceiptVoucher,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Close loading dialog if still showing
                    if (mounted) {
                      Navigator.of(context).pop();
                    }

                    // Show error message
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.errorSavingReceiptVoucher),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 5,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save),
                  const SizedBox(width: 8),
                  Text(
                    localizations.saveReceiptVoucher,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
