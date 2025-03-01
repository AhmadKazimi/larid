import 'package:flutter/material.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';

class ReceiptVoucherPage extends StatefulWidget {
  final CustomerEntity customer;

  const ReceiptVoucherPage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<ReceiptVoucherPage> createState() => _ReceiptVoucherPageState();
}

class _ReceiptVoucherPageState extends State<ReceiptVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.receiptVoucher),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer information card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.customerDetails,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildCustomerInfoRow(
                      Icons.person,
                      widget.customer.customerName,
                    ),
                    _buildCustomerInfoRow(
                      Icons.badge,
                      '${localizations.customerCode}: ${widget.customer.customerCode}',
                    ),
                    if (widget.customer.address != null)
                      _buildCustomerInfoRow(
                        Icons.location_on,
                        '${localizations.address}: ${widget.customer.address}',
                      ),
                    if (widget.customer.contactPhone != null)
                      _buildCustomerInfoRow(
                        Icons.phone,
                        '${localizations.phone}: ${widget.customer.contactPhone}',
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Receipt voucher form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receipt Details',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Amount field
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.attach_money),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Payment method dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.payment),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    items: ['Cash', 'Check', 'Bank Transfer', 'Credit Card']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // To be implemented
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a payment method';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Notes field
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.note),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save receipt voucher button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // To be implemented
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Save Receipt Voucher'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
