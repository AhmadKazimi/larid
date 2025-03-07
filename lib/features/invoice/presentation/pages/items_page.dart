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

class ItemsPage extends StatefulWidget {
  final bool isReturn;

  const ItemsPage({Key? key, this.isReturn = false}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ItemsBloc _itemsBloc;

  @override
  void initState() {
    super.initState();
    _itemsBloc = ItemsBloc();
    _itemsBloc.add(LoadItems(isReturn: widget.isReturn));
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
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, localizations),
              _buildSearchBar(context, localizations),
              Expanded(child: _buildItemsList(context, localizations, theme)),
              _buildBottomBar(context, localizations, theme),
            ],
          ),
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
              padding: const EdgeInsets.all(24),
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

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.isReturn ? localizations.returnItems : localizations.items,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isReturn ? Colors.orange : AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.isReturn ? localizations.returnItems : localizations.items,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GradientFormCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: localizations.search,
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) => _itemsBloc.add(SearchItems(query: value)),
        ),
      ),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(height: 8),
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
                            '${item.sellUnitPrice.toStringAsFixed(2)} JOD',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (selectedQuantity > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Total: ${(selectedQuantity * item.sellUnitPrice).toStringAsFixed(2)} JOD',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildQuantityControls(context, selectedQuantity, item.itemCode),
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
      child: Icon(
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
    return Row(
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
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        _buildQuantityButton(
          icon: Icons.add,
          onPressed:
              () => _itemsBloc.add(
                UpdateItemQuantity(itemCode: itemCode, quantity: quantity + 1),
              ),
        ),
      ],
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
        decoration: BoxDecoration(
          color:
              onPressed == null
                  ? Colors.grey[200]
                  : AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onPressed == null ? Colors.grey : AppColors.primary,
          size: 20,
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
                    '${localizations.total}: ${totalAmount.toStringAsFixed(2)} JOD',
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
                          final selectedItemsData = <String, dynamic>{};
                          for (final entry in state.selectedItems.entries) {
                            if (entry.value > 0) {
                              final item = state.allItems.firstWhere(
                                (item) => item.itemCode == entry.key,
                              );
                              selectedItemsData[entry.key] = {
                                'item': item,
                                'quantity': entry.value,
                                'total': entry.value * item.sellUnitPrice,
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
}
