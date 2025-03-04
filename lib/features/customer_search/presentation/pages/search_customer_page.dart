import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../bloc/customer_search_bloc.dart';
import '../bloc/customer_search_event.dart';
import '../bloc/customer_search_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:larid/core/router/navigation_service.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import '../../../../database/customer_table.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/state/visit_session_state.dart';

class SearchCustomerPage extends StatefulWidget {
  const SearchCustomerPage({super.key});

  @override
  State<SearchCustomerPage> createState() => _SearchCustomerPageState();
}

class _SearchCustomerPageState extends State<SearchCustomerPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showTodayCustomers = true;
  String? _activeVisitCustomerCode; // Track the active visit customer code

  @override
  void initState() {
    super.initState();
    context.read<CustomerSearchBloc>().add(
      const SwitchCustomerList(showTodayCustomers: true),
    );
    _checkActiveVisitCustomer(); // Check for active visit customer on init
    
    // Listen for visit session changes
    visitSessionState.addListener(_onVisitSessionChanged);
  }
  
  // Check for active visit customer
  Future<void> _checkActiveVisitCustomer() async {
    final customerTable = getIt<CustomerTable>();
    final activeCustomer = await customerTable.getCustomerWithActiveVisitSession();
    
    if (mounted) {
      setState(() {
        _activeVisitCustomerCode = activeCustomer?.customerCode;
      });
    }
  }
  
  // Listen for visit session changes
  void _onVisitSessionChanged() {
    if (visitSessionState.visitSessionChanged) {
      _checkActiveVisitCustomer();
      visitSessionState.consumeSessionChange();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    visitSessionState.removeListener(_onVisitSessionChanged);
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<CustomerSearchBloc>().add(
        SearchQueryChanged(query: query, searchInToday: _showTodayCustomers),
      );
    });
  }

  void _onTabChanged(bool showTodayCustomers) {
    if (_showTodayCustomers == showTodayCustomers) return;
    
    // Update the state before triggering the bloc event to make UI feel more responsive
    setState(() {
      _showTodayCustomers = showTodayCustomers;
    });

    // Use Future.microtask to ensure the UI updates before starting the potentially heavy operation
    Future.microtask(() {
      if (_searchController.text.isEmpty) {
        context.read<CustomerSearchBloc>().add(
          SwitchCustomerList(showTodayCustomers: showTodayCustomers),
        );
      } else {
        _onSearchChanged(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(0x7F),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(25),
                  right: Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  // Sliding indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left:
                        _showTodayCustomers
                            ? MediaQuery.of(context).size.width / 2 - 16
                            : 0,
                    right:
                        _showTodayCustomers
                            ? 0
                            : MediaQuery.of(context).size.width / 2 - 16,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  // Tabs with improved interaction
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            // Always respond to tap, even when active
                            onTap: () => _onTabChanged(true),
                            // Add a custom splash color that matches the design
                            splashColor: AppColors.primary.withOpacity(0.1),
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(25),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _showTodayCustomers
                                      ? AppColors.primary
                                      : AppColors.background,
                                  fontWeight: _showTodayCustomers 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                  fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                                ),
                                child: Text(
                                  AppLocalizations.of(context).todayCustomersTab,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            // Always respond to tap, even when active
                            onTap: () => _onTabChanged(false),
                            // Add a custom splash color that matches the design
                            splashColor: AppColors.primary.withOpacity(0.1),
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(25),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: !_showTodayCustomers
                                      ? AppColors.primary
                                      : AppColors.background,
                                  fontWeight: !_showTodayCustomers 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                  fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                                ),
                                child: Text(
                                  AppLocalizations.of(context).customersTab,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: AppColors.primaryDark,
                  filled: true,
                  hintText: AppLocalizations.of(context)!.searchForClient,
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: BlocBuilder<CustomerSearchBloc, CustomerSearchState>(
                builder: (context, state) {
                  return state.when(
                    initial:
                        () => const Center(
                          child: Text('Start typing to search for customers'),
                        ),
                    loading: () {
                      // Show a more subtle loading indicator that doesn't replace content
                      return Stack(
                        children: [
                          // Show faded previous content if available
                          Opacity(
                            opacity: 0.5,
                            child: _buildCustomerList(_showTodayCustomers ? 
                                context.read<CustomerSearchBloc>().todayCustomersCache : 
                                context.read<CustomerSearchBloc>().allCustomersCache),
                          ),
                          // Centered progress indicator
                          const Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                    loaded: (customers) => customers.isEmpty
                        ? const Center(child: Text('No customers found'))
                        : _buildCustomerList(customers),
                    error: (message) => Center(child: Text('Error: $message')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Extracted customer list building to a separate method
  Widget _buildCustomerList(List<CustomerEntity> customers) {
    // If list is empty, don't try to build it
    if (customers.isEmpty) {
      return const Center(child: Text('No customers found'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      // Using a key to ensure proper recycling
      key: PageStorageKey(_showTodayCustomers ? 'today_customers' : 'all_customers'),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: customer.customerCode == _activeVisitCustomerCode 
                ? Colors.green.shade50  // Light green background for active session
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: customer.customerCode == _activeVisitCustomerCode
                ? Border.all(color: Colors.green, width: 2) // Green border for active session
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  AppLocalizations.of(context)!.address,
                  customer.address?.isNotEmpty == true
                      ? customer.address!
                      : AppLocalizations.of(context)!.notExists,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  Icons.phone_outlined,
                  AppLocalizations.of(context)!.phone,
                  customer.contactPhone?.isNotEmpty == true
                      ? customer.contactPhone!
                      : AppLocalizations.of(context)!.notExists,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (customer.mapCoords != null)
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final coords = customer.mapCoords!.split(',');
                            if (coords.length == 2) {
                              final lat = double.tryParse(coords[0]);
                              final lng = double.tryParse(coords[1]);
                              if (lat != null && lng != null) {
                                final url = Uri.parse(
                                  'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              }
                            }
                          },
                          icon: Icon(
                            Icons.directions,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          NavigationService.push(
                            context,
                            RouteConstants.customerActivity,
                            extra: customer,
                          );
                        },
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
