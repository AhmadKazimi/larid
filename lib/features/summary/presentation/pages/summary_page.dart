import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';
import 'package:larid/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:larid/features/summary/presentation/bloc/summary_event.dart';
import 'package:larid/features/summary/presentation/bloc/summary_state.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/features/auth/domain/repositories/auth_repository.dart';
import 'package:larid/database/user_table.dart';
import 'package:larid/core/utils/network_connectivity.dart';

class CustomExpansionPanel {
  String title;
  final IconData icon;
  List<SummaryItemEntity> items;
  final String itemType;
  bool isExpanded;

  CustomExpansionPanel({
    required this.title,
    required this.icon,
    required this.items,
    required this.itemType,
    this.isExpanded = false,
  });
}

// Create a static global function to refresh the summary page
void refreshSummaryPage(BuildContext context) {
  final bloc = BlocProvider.of<SummaryBloc>(context, listen: false);
  bloc.add(const LoadSummaryData());
  debugPrint('Summary page refreshed directly via BlocProvider');
}

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  // Static method to refresh the SummaryPage data if possible
  static void refreshData(BuildContext context) {
    try {
      // Try to directly access the bloc from any ancestor that has it
      refreshSummaryPage(context);
    } catch (e) {
      debugPrint('Error refreshing SummaryPage: $e');
    }
  }

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool _isDataLoaded = false;
  String? _userId;
  String? _currency;
  final List<CustomExpansionPanel> _panels = [
    CustomExpansionPanel(
      title: '',
      icon: Icons.receipt_long,
      items: [],
      itemType: 'invoice',
    ),
    CustomExpansionPanel(
      title: '',
      icon: Icons.assignment_return,
      items: [],
      itemType: 'returnInvoice',
    ),
    CustomExpansionPanel(
      title: '',
      icon: Icons.receipt,
      items: [],
      itemType: 'voucher',
    ),
  ];

  // Key to identify this widget
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Get the user ID for invoice number formatting
    _getUserId();
    // Get currency
    _getCurrency();

    // Load data when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  // Simple method to load data
  void loadData() {
    debugPrint('Loading Summary page data - direct call');
    if (!mounted) return;
    context.read<SummaryBloc>().add(const LoadSummaryData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize panel titles with localized strings
    final l10n = AppLocalizations.of(context);
    _panels[0].title = '${l10n.invoice} (0)';
    _panels[1].title = '${l10n.returnInvoice} (0)';
    _panels[2].title = '${l10n.vouchers} (0)';

    // Load data first time
    if (!_isDataLoaded) {
      loadData();
      _isDataLoaded = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  Future<void> _getUserId() async {
    try {
      final authRepository = GetIt.I<AuthRepository>();
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        setState(() {
          _userId = user.userid;
        });
        debugPrint('User ID for invoice formatting: $_userId');
      }
    } catch (e) {
      debugPrint('Error getting user ID: $e');
    }
  }

  Future<void> _getCurrency() async {
    try {
      final userTable = GetIt.I<UserTable>();
      final currentUser = await userTable.getCurrentUser();
      if (currentUser != null && currentUser.currency != null) {
        setState(() {
          _currency = currentUser.currency;
        });
        debugPrint('Currency loaded: $_currency');
      } else {
        debugPrint('No currency found in user table');
      }
    } catch (e) {
      debugPrint('Error getting currency: $e');
    }
  }

  // Helper method to format invoice numbers with user ID
  String getFormattedInvoiceNumber(String invoiceNumber) {
    if (invoiceNumber.isEmpty) {
      return AppLocalizations.of(context).newInvoice;
    }

    // Ensure proper userid-invoiceNumber format
    return _userId != null && _userId!.isNotEmpty
        ? '${_userId!}-$invoiceNumber'
        : invoiceNumber;
  }

  // Helper method to format currency
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} $_currency';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocListener<SummaryBloc, SummaryState>(
        listenWhen:
            (previous, current) =>
                current.successMessage != null || current.errorMessage != null,
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildGradientHeader(context, l10n),
            // Network status indicator
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                child: NetworkConnectivity().getNetworkStatusIndicator(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  debugPrint('Pull-to-refresh triggered');
                  loadData();
                  // Need to return a Future that completes when the refresh is done
                  return Future.delayed(const Duration(milliseconds: 1000));
                },
                child: SafeArea(
                  top: false,
                  child: BlocBuilder<SummaryBloc, SummaryState>(
                    builder: (context, state) {
                      debugPrint(
                        'Building Summary UI with state: ${state.status}',
                      );
                      if (state.status == SummaryStatus.loading &&
                          state.totalItems == 0) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == SummaryStatus.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage ?? 'An error occurred',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: loadData,
                                child: Text(l10n.retrySync),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Update panel data
                        _updatePanelData(state, l10n);
                        return _buildExpandableList(context, l10n, state);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Manual refresh button pressed');
          loadData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _updatePanelData(SummaryState state, AppLocalizations l10n) {
    _panels[0].title = '${l10n.invoice} (${state.invoices.length})';
    _panels[0].items = state.invoices;

    _panels[1].title = '${l10n.returnInvoice} (${state.returnInvoices.length})';
    _panels[1].items = state.returnInvoices;

    _panels[2].title = '${l10n.vouchers} (${state.receiptVouchers.length})';
    _panels[2].items = state.receiptVouchers;
  }

  Widget _buildExpandableList(
    BuildContext context,
    AppLocalizations l10n,
    SummaryState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Sync status and action row
          _buildCompactSyncStatusCard(context, l10n, state),

          const SizedBox(height: 16),

          // ExpansionTile based panels
          ..._panels.map((panel) => _buildExpansionTile(context, l10n, panel)),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
    BuildContext context,
    AppLocalizations l10n,
    CustomExpansionPanel panel,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            listTileTheme: const ListTileThemeData(
              dense: true,
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          child: ExpansionTile(
            initiallyExpanded: panel.isExpanded,
            onExpansionChanged: (isExpanded) {
              setState(() {
                panel.isExpanded = isExpanded;
              });
            },
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
            expandedAlignment: Alignment.topLeft,
            childrenPadding: EdgeInsets.zero,
            // Custom header without gradient
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(panel.icon, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      panel.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            collapsedIconColor: Colors.grey,
            iconColor: AppColors.primary,
            backgroundColor: Colors.white,
            // Children (list items)
            children:
                panel.items.isEmpty
                    ? [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.noItemsFound,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ]
                    : panel.items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              children: [
                                _buildItemTile(item, l10n, panel.itemType),
                                if (panel.items.indexOf(item) <
                                    panel.items.length - 1)
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFEEEEEE),
                                    thickness: 1,
                                  ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(
    SummaryItemEntity item,
    AppLocalizations l10n,
    String itemType,
  ) {
    final bool isSynced = item.isSynced;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = dateFormat.format(item.date);

    // Format the invoice number with user ID
    final formattedInvoiceNumber = getFormattedInvoiceNumber(item.title);

    // Format the amount with proper currency
    final formattedAmount = formatCurrency(item.amount);

    // Get current state from BLoC to check if item is syncing
    final state = context.watch<SummaryBloc>().state;
    final bool isSyncing = state.isItemSyncing(item.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Customer info & details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer name (was subtitle)
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                // Invoice ID (was title)
                Row(
                  children: [
                    Icon(
                      itemType == 'invoice'
                          ? Icons.receipt_outlined
                          : itemType == 'returnInvoice'
                          ? Icons.assignment_return_outlined
                          : Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedInvoiceNumber,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Date & time
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right side - Amount & sync status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount with currency
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formattedAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Sync status with three possible states: synced, syncing, or not synced
              if (isSynced)
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      l10n.synced,
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                )
              else if (isSyncing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.syncNow,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.sync, size: 14),
                  label: Text(
                    l10n.syncNow,
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Update sync status based on item type
                    if (itemType == 'invoice') {
                      context.read<SummaryBloc>().add(
                        UpdateInvoiceSyncStatus(id: item.id),
                      );
                    } else if (itemType == 'returnInvoice') {
                      context.read<SummaryBloc>().add(
                        UpdateInvoiceSyncStatus(id: item.id),
                      );
                    } else {
                      context.read<SummaryBloc>().add(
                        UpdateReceiptVoucherSyncStatus(id: item.id),
                      );
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSyncStatusCard(
    BuildContext context,
    AppLocalizations l10n,
    SummaryState state,
  ) {
    // Calculate sync statistics from the state
    int totalItems = state.totalItems;
    int syncedItems = state.syncedItems;
    double syncPercentage = state.syncPercentage;

    // Check if sync is in progress
    bool isSyncing = state.status == SummaryStatus.loading;

    return GradientFormCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.sync, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l10n.syncStatus,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${syncPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: syncPercentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.itemsSynced(syncedItems, totalItems),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextButton.icon(
                onPressed:
                    isSyncing
                        ? null // Disable button while syncing
                        : () {
                          // Trigger sync all data event
                          context.read<SummaryBloc>().add(const SyncAllData());
                        },
                icon:
                    isSyncing
                        ? SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                        : const Icon(Icons.sync, size: 16),
                label: Text(
                  l10n.syncAllData,
                  style: const TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.insert_chart_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.summary,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      l10n.salesData,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.today,
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
}
