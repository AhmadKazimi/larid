import 'package:flutter/material.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/core/router/navigation_service.dart';

class CustomerActivityPage extends StatefulWidget {
  final CustomerEntity customer;

  const CustomerActivityPage({Key? key, required this.customer})
    : super(key: key);

  @override
  State<CustomerActivityPage> createState() => _CustomerActivityPageState();
}

class _CustomerActivityPageState extends State<CustomerActivityPage> {
  // Track the selected activity index, null means no selection
  int? _selectedActivityIndex;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.customerName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Customer Details Card
            GradientFormCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.customerDetails,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        widget.customer.customerCode.isNotEmpty
                            ? widget.customer.customerCode
                            : l10n.noExist,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Column(
                    children: [
                      _buildCompactInfoRow(
                        Icons.location_on,
                        (widget.customer.address?.isNotEmpty ?? false)
                            ? widget.customer.address!
                            : l10n.noExist,
                      ),
                      const SizedBox(height: 12),
                      _buildCompactInfoRow(
                        Icons.phone,
                        (widget.customer.contactPhone?.isNotEmpty ?? false)
                            ? widget.customer.contactPhone!
                            : l10n.noExist,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Activity Options
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                l10n.activities,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Square Activity Buttons Grid
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Add aspect ratio to make cells taller
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSquareActivityButton(
                  icon: Icons.receipt_long,
                  title: l10n.createInvoice,
                  isSelected: _selectedActivityIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedActivityIndex =
                          _selectedActivityIndex == 0 ? null : 0;
                    });
                  },
                ),
                _buildSquareActivityButton(
                  icon: Icons.camera_alt,
                  title: l10n.takePhoto,
                  isSelected: _selectedActivityIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedActivityIndex =
                          _selectedActivityIndex == 1 ? null : 1;
                    });
                  },
                ),
                _buildSquareActivityButton(
                  icon: Icons.receipt,
                  title: l10n.receiptVoucher,
                  isSelected: _selectedActivityIndex == 2,
                  onTap: () {
                    setState(() {
                      _selectedActivityIndex =
                          _selectedActivityIndex == 2 ? null : 2;
                    });
                  },
                ),
              ],
            ),

            // Start Visit Button - only shown when an activity is selected
            if (_selectedActivityIndex != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle starting visit with selected activity
                      final activityType =
                          _selectedActivityIndex == 0
                              ? RouteConstants.invoice
                              : _selectedActivityIndex == 1
                              ? RouteConstants.photoCapture
                              : RouteConstants.receiptVoucher;

                      NavigationService.push(
                        context,
                        activityType,
                        extra: widget.customer,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.startCustomerVisit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareActivityButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected ? Border.all(color: Colors.green, width: 2.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 30),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
