import 'package:flutter/material.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';

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
  // This will be expanded with actual invoice creation functionality
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createInvoice),
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
            
            // Invoice form placeholder - to be implemented
            Text(
              'Invoice Form',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Invoice creation functionality will be implemented here',
                textAlign: TextAlign.center,
              ),
            ),
            
            // Add product button placeholder
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // To be implemented
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Save invoice button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // To be implemented
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Save Invoice'),
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
