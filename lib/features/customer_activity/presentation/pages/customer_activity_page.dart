import 'package:flutter/material.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/core/router/navigation_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/core/state/visit_session_state.dart';

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

  // Customer table for database operations
  late CustomerTable _customerTable;

  // Flag to track if there's an active visit session
  bool _hasActiveSession = false;

  // Customer data with session info
  late CustomerEntity _customer;

  // Session start time
  String? _sessionStartTime;

  @override
  void initState() {
    super.initState();
    _customerTable = getIt<CustomerTable>();
    _customer = widget.customer;
    _checkVisitSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will refresh the customer visit session status every time
    // the user navigates back to this page from an activity
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisitSession();
    });
  }

  // Check if this customer has an active visit session
  Future<void> _checkVisitSession() async {
    final updatedCustomer = await _customerTable.getCustomerByCode(
      _customer.customerCode,
    );
    if (updatedCustomer != null) {
      setState(() {
        _customer = updatedCustomer;
        _hasActiveSession =
            updatedCustomer.visitStartTime != null &&
            updatedCustomer.visitEndTime == null;
        _sessionStartTime = updatedCustomer.visitStartTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        debugPrint(
          'Back button pressed in CustomerActivityPage, active session: $_hasActiveSession',
        );

        // Notify session state change before popping
        visitSessionState.markSessionChanged();

        // Pop back to map page
        NavigationService.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.customer.customerName),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            if (_hasActiveSession)
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: Chip(
                  label: Text(
                    l10n.activeVisit,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                ),
              ),
          ],
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
                      onPressed: () async {
                        // Get the current active session if any
                        final hasActiveSession =
                            await _customerTable.hasActiveVisitSession();
                        final customerWithActiveSession =
                            hasActiveSession
                                ? await _customerTable
                                    .getCustomerWithActiveVisitSession()
                                : null;

                        // Handle starting visit with selected activity
                        final activityType =
                            _selectedActivityIndex == 0
                                ? RouteConstants.invoice
                                : _selectedActivityIndex == 1
                                ? RouteConstants.photoCapture
                                : RouteConstants.receiptVoucher;

                        // If this customer doesn't have an active session and there is no active session for any customer
                        if (!_hasActiveSession &&
                            customerWithActiveSession == null) {
                          // Start a new visit session
                          await _customerTable.startVisitSession(
                            _customer.customerCode,
                          );
                          await _checkVisitSession(); // Update the UI

                          // Notify that session state has changed
                          visitSessionState.markSessionChanged();
                        } else if (!_hasActiveSession &&
                            customerWithActiveSession != null &&
                            customerWithActiveSession.customerCode !=
                                _customer.customerCode) {
                          // Another customer has an active session
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.otherCustomerActiveVisit(
                                  customerWithActiveSession.customerName,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Don't proceed
                        }

                        // Now navigate to the selected activity
                        NavigationService.push(
                          context,
                          activityType,
                          extra: _customer,
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

              // Session info and End Visit Button - only shown when there's an active session
              if (_hasActiveSession) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              l10n.visitStartedAt(_sessionStartTime ?? ''),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.visitSessionInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // End the visit session
                        await _customerTable.endVisitSession(
                          _customer.customerCode,
                        );
                        await _checkVisitSession(); // Update the UI

                        // Notify that session state has changed
                        visitSessionState.markSessionChanged();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.visitSessionEnded),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // With GoRouter, we don't need to pass back a result
                        // Just navigate back to the map page
                        NavigationService.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.endVisitSession,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
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
