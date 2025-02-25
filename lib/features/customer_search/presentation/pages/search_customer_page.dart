import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../../database/customer_table.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import '../bloc/customer_search_bloc.dart';
import '../bloc/customer_search_event.dart';
import '../bloc/customer_search_state.dart';
import '../../../../core/theme/app_theme.dart';

class SearchCustomerPage extends StatefulWidget {
  const SearchCustomerPage({super.key});

  @override
  State<SearchCustomerPage> createState() => _SearchCustomerPageState();
}

class _SearchCustomerPageState extends State<SearchCustomerPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showTodayCustomers = true;

  @override
  void initState() {
    super.initState();
    context.read<CustomerSearchBloc>().add(const LoadInitialData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<CustomerSearchBloc>().add(
            SearchQueryChanged(
              query: query,
              searchInToday: _showTodayCustomers,
            ),
          );
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
                borderRadius: BorderRadius.horizontal(left: Radius.circular(25), right: Radius.circular(25)),
              ),
              child: Stack(
                children: [
                  // Sliding indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: _showTodayCustomers ? MediaQuery.of(context).size.width / 2 - 16 : 0,
                    right: _showTodayCustomers ? 0 : MediaQuery.of(context).size.width / 2 - 16,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(25), right: Radius.circular(25)),
                      ),
                    ),
                  ),
                  // Tabs
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: !_showTodayCustomers ? () {
                            setState(() {
                              _showTodayCustomers = true;
                            });
                            _onSearchChanged(_searchController.text);
                          } : null,
                          child: Container(
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 13,
                                color: _showTodayCustomers ? AppColors.primary : AppColors.background,
                              ),
                              child: const Text('Today Customers'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showTodayCustomers ? () {
                            setState(() {
                              _showTodayCustomers = false;
                            });
                            _onSearchChanged(_searchController.text);
                          } : null,
                          child: Container(
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 13,
                                color: _showTodayCustomers ? AppColors.background : AppColors.primary,
                              ),
                              child: const Text('Customers'),
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
                color: const Color(0xFF3A5DA3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: BlocBuilder<CustomerSearchBloc, CustomerSearchState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: Text('Start typing to search for customers'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    loaded: (customers) => customers.isEmpty
                        ? const Center(
                            child: Text('No customers found'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              final customer = customers[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    customer.customerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Customer details',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onTap: () => Navigator.pop(context, customer),
                                ),
                              );
                            },
                          ),
                    error: (message) => Center(
                      child: Text('Error: $message'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
