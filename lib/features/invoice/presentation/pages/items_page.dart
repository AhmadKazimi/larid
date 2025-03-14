import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:larid/features/invoice/presentation/bloc/items_bloc.dart';
import 'package:larid/features/invoice/presentation/bloc/items_event.dart';
import 'package:larid/features/invoice/presentation/bloc/items_state.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/database/user_table.dart';

class ItemsPage extends StatefulWidget {
  final bool isReturn;
  final Map<String, int>? preselectedItems;

  const ItemsPage({Key? key, this.isReturn = false, this.preselectedItems})
    : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ItemsBloc _itemsBloc;
  List<InventoryItemEntity> _filteredItems = [];
  String? _selectedItemCode;
  int _selectedQuantity = 0;
  String? _currency;

  @override
  void initState() {
    super.initState();
    _itemsBloc = ItemsBloc();

    // Load items and apply preselected quantities if available
    _itemsBloc.add(LoadItems(isReturn: widget.isReturn));

    // Apply preselected items after a short delay to ensure items are loaded
    if (widget.preselectedItems != null &&
        widget.preselectedItems!.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        for (final entry in widget.preselectedItems!.entries) {
          _itemsBloc.add(
            UpdateItemQuantity(itemCode: entry.key, quantity: entry.value),
          );
        }
      });
    }

    _getCurrency();
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

  @override
  void dispose() {
    _searchController.dispose();
    _itemsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _itemsBloc,
      child: Scaffold(
        body: Column(
          children: [
            _buildGradientHeader(context, localizations),
            Expanded(
              child: SafeArea(
                top: false,
                child: _buildItemsList(context, localizations, theme),
              ),
            ),
            _buildBottomBar(context, localizations, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader(
    BuildContext context,
    AppLocalizations localizations,
  ) {
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
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
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
                    child: Text(
                      widget.isReturn
                          ? localizations.returnItems
                          : localizations.items,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      widget.isReturn
                          ? localizations.returnItems
                          : localizations.items,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.search,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) => _itemsBloc.add(SearchItems(query: value)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state.error != null) {
          return Center(
            child: GradientFormCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildRetryButton(context),
                ],
              ),
            ),
          );
        }

        if (state.filteredItems.isEmpty) {
          return Center(
            child: GradientFormCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.query.isEmpty
                        ? localizations.noItemsFound
                        : localizations.noItemsFound,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount:
              state.hasMoreItems
                  ? state.filteredItems.length + 1
                  : state.filteredItems.length,
          itemBuilder: (context, index) {
            try {
              if (index >= state.filteredItems.length) {
                _itemsBloc.add(const LoadMoreItems());
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final item = state.filteredItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildItemCard(context, item, theme),
              );
            } catch (e) {
              debugPrint('Error building item at index $index: $e');
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    InventoryItemEntity item,
    ThemeData theme,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      buildWhen:
          (previous, current) =>
              previous.selectedItems[item.itemCode] !=
              current.selectedItems[item.itemCode],
      builder: (context, state) {
        final selectedQuantity = state.selectedItems[item.itemCode] ?? 0;

        return GradientFormCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemCode,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.sellUnitPrice.toStringAsFixed(2)} ${_currency ?? "?"}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (selectedQuantity > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Total: ${(selectedQuantity * item.sellUnitPrice).toStringAsFixed(2)} ${_currency ?? "?"}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildQuantityControls(
                    context,
                    selectedQuantity,
                    item.itemCode,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildQuantityControls(
    BuildContext context,
    int quantity,
    String itemCode,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        // Find the current item to get its available quantity
        final item = state.allItems.firstWhere(
          (item) => item.itemCode == itemCode,
          orElse:
              () => const InventoryItemEntity(
                itemCode: '',
                description: '',
                taxableFlag: 0,
                taxCode: '',
                sellUnitCode: '',
                sellUnitPrice: 0,
                qty: 0,
              ),
        );

        // Check if selected quantity reached available inventory
        final bool isMaxQuantityReached = quantity >= item.qty;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuantityButton(
              icon: Icons.remove,
              onPressed:
                  quantity > 0
                      ? () => _itemsBloc.add(
                        UpdateItemQuantity(
                          itemCode: itemCode,
                          quantity: quantity - 1,
                        ),
                      )
                      : null,
            ),
            SizedBox(
              width: 32,
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildQuantityButton(
              icon: Icons.add,
              onPressed:
                  isMaxQuantityReached
                      ? null
                      : () => _itemsBloc.add(
                        UpdateItemQuantity(
                          itemCode: itemCode,
                          quantity: quantity + 1,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              onPressed == null
                  ? Colors.grey[300]
                  : AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Icon(
          icon,
          color: onPressed == null ? Colors.grey : AppColors.primary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        final itemCount = state.selectedItems.values.fold<int>(
          0,
          (sum, quantity) => sum + quantity,
        );
        final totalAmount = state.selectedItems.entries.fold<double>(0, (
          sum,
          entry,
        ) {
          final item = state.allItems.firstWhere(
            (item) => item.itemCode == entry.key,
            orElse:
                () => const InventoryItemEntity(
                  itemCode: '',
                  description: '',
                  taxableFlag: 0,
                  taxCode: '',
                  sellUnitCode: '',
                  sellUnitPrice: 0,
                  qty: 0,
                ),
          );
          return sum + (entry.value * item.sellUnitPrice);
        });

        return GradientFormCard(
          padding: const EdgeInsets.all(16.0),
          borderRadius: 0, // No rounded corners for the bottom bar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Message to clarify that items need to be saved
              if (itemCount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '⚠️ ${localizations.saveItems}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${localizations.items}: $itemCount',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${localizations.total}: ${totalAmount.toStringAsFixed(2)} ${_currency ?? "?"}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    itemCount == 0
                        ? null
                        : () {
                          final selectedItemsData = <String, dynamic>{
                            'isReturn': widget.isReturn,
                            'totalAmount': totalAmount,
                            'itemCount': itemCount,
                            'items': <String, Map<String, dynamic>>{},
                          };

                          for (final entry in state.selectedItems.entries) {
                            if (entry.value > 0) {
                              final item = state.allItems.firstWhere(
                                (item) => item.itemCode == entry.key,
                              );

                              selectedItemsData['items'][entry.key] = {
                                'item': {
                                  'itemCode': item.itemCode,
                                  'description': item.description,
                                  'taxableFlag': item.taxableFlag,
                                  'taxCode': item.taxCode,
                                  'sellUnitCode': item.sellUnitCode,
                                  'sellUnitPrice': item.sellUnitPrice,
                                  'qty': item.qty,
                                },
                                'quantity': entry.value,
                                'total': entry.value * item.sellUnitPrice,
                                'isReturn': widget.isReturn,
                                'unitPrice': item.sellUnitPrice,
                              };
                            }
                          }
                          context.pop(selectedItemsData);
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      itemCount == 0 ? Colors.grey[300] : AppColors.primary,
                  foregroundColor:
                      itemCount == 0 ? Colors.grey[600] : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  localizations.saveItems,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _itemsBloc.add(LoadItems(isReturn: widget.isReturn)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.refresh),
      label: const Text('Retry', style: TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
