import 'package:flutter/material.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/database/receipt_voucher_table.dart';

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

                      // Payment method dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration: InputDecoration(
                          labelText: localizations.paymentMethod,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.payment),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        items:
                            [
                                  localizations.cash,
                                  localizations.check,
                                  localizations.bankTransfer,
                                  localizations.creditCard,
                                ]
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.pleaseSelectPaymentMethod;
                          }
                          return null;
                        },
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

                      const SizedBox(height: 32),

                      // Save receipt voucher button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final receiptVoucherTable =
                                    getIt<ReceiptVoucherTable>();
                                await receiptVoucherTable.saveReceiptVoucher(
                                  customerCode: widget.customer.customerCode,
                                  paidAmount: double.parse(
                                    _amountController.text,
                                  ),
                                  paymentType: _selectedPaymentMethod!,
                                  description: _notesController.text,
                                  comment: _notesController.text,
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.receiptVoucherSaved,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  context.pop();
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.errorSavingReceiptVoucher,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(200, 50),
                          ),
                          child: Text(localizations.saveReceiptVoucher),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
