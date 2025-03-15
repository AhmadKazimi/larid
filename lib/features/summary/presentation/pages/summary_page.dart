import 'package:flutter/material.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  // Track which panels are expanded
  List<bool> _isExpanded = [false, false, false];

  // Mock data - will be replaced with actual data from DB later
  final List<String> _mockInvoices = [
    'Invoice #001',
    'Invoice #002',
    'Invoice #003',
  ];
  final List<String> _mockReturnInvoices = ['Return #001', 'Return #002'];
  final List<String> _mockVouchers = [
    'Voucher #001',
    'Voucher #002',
    'Voucher #003',
    'Voucher #004',
  ];

  // Mock sync statuses - will be replaced with actual statuses later
  final Map<String, bool> _syncStatus = {
    'Invoice #001': true,
    'Invoice #002': false,
    'Invoice #003': true,
    'Return #001': false,
    'Return #002': true,
    'Voucher #001': true,
    'Voucher #002': false,
    'Voucher #003': false,
    'Voucher #004': true,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          _buildGradientHeader(context, l10n),
          Expanded(
            child: SafeArea(
              top: false,
              child: _buildExpandableList(context, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableList(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Sync status and action row
          _buildCompactSyncStatusCard(context, l10n),

          const SizedBox(height: 16),

          // Custom expandable panels using GradientFormCard
          _buildCustomExpandableCard(
            context: context,
            l10n: l10n,
            headerText: l10n.invoice + ' (${_mockInvoices.length})',
            isExpanded: _isExpanded[0],
            items: _mockInvoices,
            icon: Icons.receipt_long,
            index: 0,
          ),

          const SizedBox(height: 12),

          _buildCustomExpandableCard(
            context: context,
            l10n: l10n,
            headerText: l10n.returnInvoice + ' (${_mockReturnInvoices.length})',
            isExpanded: _isExpanded[1],
            items: _mockReturnInvoices,
            icon: Icons.assignment_return,
            index: 1,
          ),

          const SizedBox(height: 12),

          _buildCustomExpandableCard(
            context: context,
            l10n: l10n,
            headerText: 'Vouchers (${_mockVouchers.length})',
            isExpanded: _isExpanded[2],
            items: _mockVouchers,
            icon: Icons.receipt,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomExpandableCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String headerText,
    required bool isExpanded,
    required List<String> items,
    required IconData icon,
    required int index,
  }) {
    return GradientFormCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded[index] = !_isExpanded[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      headerText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded ? AppColors.primary : Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? (items.length * 72.0) : 0,
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder:
                    (context, itemIndex) =>
                        _buildItemTile(items[itemIndex], l10n),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(String item, AppLocalizations l10n) {
    final bool isSynced = _syncStatus[item] ?? false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(item),
      subtitle: Text(
        isSynced ? l10n.syncSuccess : l10n.syncFailed,
        style: TextStyle(
          color: isSynced ? Colors.green : Colors.orange,
          fontSize: 12,
        ),
      ),
      trailing:
          isSynced
              ? const Icon(Icons.check_circle, color: Colors.green)
              : IconButton(
                icon: const Icon(Icons.sync, color: Colors.orange),
                onPressed: () {
                  // This will be implemented later for individual sync
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Syncing ${item}...'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildCompactSyncStatusCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    // Calculate sync statistics
    int totalItems =
        _mockInvoices.length +
        _mockReturnInvoices.length +
        _mockVouchers.length;
    int syncedItems = _syncStatus.values.where((status) => status).length;
    double syncPercentage =
        totalItems > 0 ? (syncedItems / totalItems) * 100 : 0;

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
                '$syncedItems of $totalItems items synced',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextButton.icon(
                onPressed: () {
                  // Will be implemented later
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sync all will be implemented soon'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.sync, size: 16),
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
                  color: Colors.white.withOpacity(0.2),
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
                      "Sales Data",
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
                      "Today",
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
