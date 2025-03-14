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
        body: Column(
          children: [
            _buildGradientHeader(context, l10n),
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
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
                            // Address
                            if (_customer.address != null &&
                                _customer.address!.isNotEmpty)
                              _buildDetailRow(
                                label: l10n.address,
                                value: _customer.address!,
                              ),
                            // Phone
                            if (_customer.contactPhone != null &&
                                _customer.contactPhone!.isNotEmpty)
                              _buildDetailRow(
                                label: l10n.phone,
                                value: _customer.contactPhone!,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Visit Session Information
                      if (_hasActiveSession) ...[
                        GradientFormCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _sessionStartTime != null
                                          ? l10n.visitStartedAt(
                                            _sessionStartTime!,
                                          )
                                          : l10n.visitSessionStarted,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.visitSessionInfo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _endVisitSession(context),
                                icon: const Icon(Icons.exit_to_app),
                                label: Text(l10n.endVisitSession),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Activities Section Title
                      Text(
                        l10n.activities,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Activities Grid
                      _buildActivitiesGrid(context, l10n),

                      const SizedBox(height: 16),

                      // Start Visit Session Button (only if no active session)
                      if (!_hasActiveSession)
                        ElevatedButton.icon(
                          onPressed: () => _startVisitSession(context),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(l10n.startCustomerVisit),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader(BuildContext context, AppLocalizations l10n) {
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
                onTap: () {
                  // Notify session state change before popping
                  visitSessionState.markSessionChanged();
                  NavigationService.pop(context);
                },
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
                    if (widget.customer.address != null &&
                        widget.customer.address!.isNotEmpty)
                      Text(
                        widget.customer.address!,
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
              if (_hasActiveSession)
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.activeVisit,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
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
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
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

  void _startVisitSession(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    // Check for existing active session
    final hasActiveSession = await _customerTable.hasActiveVisitSession();
    final customerWithActiveSession =
        hasActiveSession
            ? await _customerTable.getCustomerWithActiveVisitSession()
            : null;

    if (customerWithActiveSession != null &&
        customerWithActiveSession.customerCode != _customer.customerCode) {
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
      return;
    }

    // Check if customer was visited today
    final wasVisitedToday = await _customerTable.wasVisitedToday(
      _customer.customerCode,
    );
    if (wasVisitedToday) {
      // Show dialog if customer was already visited today
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.visitRestriction),
            content: Text(l10n.alreadyVisitedToday),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
      return;
    }

    // Start visit session
    await _customerTable.startVisitSession(_customer.customerCode);
    await _checkVisitSession(); // Update the UI

    // Notify that session state has changed
    visitSessionState.markSessionChanged();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.visitSessionStarted),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _endVisitSession(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    // End the visit session
    await _customerTable.endVisitSession(_customer.customerCode);
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

    // Navigate back to map
    NavigationService.pop(context);
  }

  Widget _buildActivitiesGrid(BuildContext context, AppLocalizations l10n) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSquareActivityButton(
          icon: Icons.receipt_long,
          title: l10n.createInvoice,
          onTap:
              () => _handleActivitySelection(0, RouteConstants.invoice, false),
        ),
        _buildSquareActivityButton(
          icon: Icons.camera_alt,
          title: l10n.takePhoto,
          onTap:
              () => _handleActivitySelection(
                1,
                RouteConstants.photoCapture,
                false,
              ),
        ),
        _buildSquareActivityButton(
          icon: Icons.receipt,
          title: l10n.receiptVoucher,
          onTap:
              () => _handleActivitySelection(
                2,
                RouteConstants.receiptVoucher,
                false,
              ),
        ),
        _buildSquareActivityButton(
          icon: Icons.assignment_return,
          title: l10n.returnItem,
          onTap:
              () => _handleActivitySelection(3, RouteConstants.invoice, true),
        ),
      ],
    );
  }

  void _handleActivitySelection(
    int index,
    String routeName,
    bool isReturn,
  ) async {
    // Check if we can navigate to the activity
    if (!_hasActiveSession) {
      // We need to start a session first
      _startVisitSession(context);

      // Wait a moment for the session to start
      await Future.delayed(const Duration(milliseconds: 500));

      // Refresh the session status
      await _checkVisitSession();

      // If starting the session failed, return
      if (!_hasActiveSession) return;
    }

    // Navigate to the selected activity
    final extra =
        isReturn ? {'customer': _customer, 'isReturn': true} : _customer;
    NavigationService.push(context, routeName, extra: extra);
  }
}
