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
    // Create our own bloc instance to ensure it's available
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
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);


    return BlocProvider.value(
      value: _itemsBloc,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, localizations),
            _buildSearchBar(context, theme, localizations),
            Expanded(child: _buildItemsList(context, theme, localizations)),
            _buildBottomBar(context, theme, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              localizations.items,
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: localizations.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          // Use the local _itemsBloc instance
          _itemsBloc.add(SearchItems(query: value));
        },
      ),
    );
  }

  Widget _buildItemsList(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      bloc: _itemsBloc, // Explicitly provide the local bloc instance
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(state.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<ItemsBloc>().add(
                        LoadItems(isReturn: widget.isReturn),
                      ),
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (state.filteredItems.isEmpty) {
          return Center(
            child: Text(
              state.query.isEmpty
                  ? localizations.noItemsFound
                  : localizations.noItemsFound,
              style: theme.textTheme.titleMedium,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount:
              state.hasMoreItems
                  ? state.filteredItems.length + 1
                  : state.filteredItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= state.filteredItems.length) {
              _itemsBloc.add(const LoadMoreItems());
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = state.filteredItems[index];
            return _buildItemCard(context, item, theme, localizations);
          },
        );
      },
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    InventoryItemEntity item,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      buildWhen:
          (previous, current) =>
              previous.selectedItems[item.itemCode] !=
              current.selectedItems[item.itemCode],
      builder: (context, state) {
        final selectedQuantity = state.selectedItems[item.itemCode] ?? 0;

        return GradientFormCard(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Item image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 30),
              ),
              const SizedBox(width: 12),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemCode,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.sellUnitPrice.toStringAsFixed(2)} JOD',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Quantity controls
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.primary,
                          onPressed:
                              selectedQuantity <= 0
                                  ? null
                                  : () => context.read<ItemsBloc>().add(
                                    UpdateItemQuantity(
                                      itemCode: item.itemCode,
                                      quantity: selectedQuantity - 1,
                                    ),
                                  ),
                          iconSize: 24,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 36,
                        alignment: Alignment.center,
                        child: Text(
                          selectedQuantity.toString(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.primary,
                          onPressed:
                              () => context.read<ItemsBloc>().add(
                                UpdateItemQuantity(
                                  itemCode: item.itemCode,
                                  quantity: selectedQuantity + 1,
                                ),
                              ),
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                  if (selectedQuantity > 0)
                    Text(
                      'Total: ${(selectedQuantity * item.sellUnitPrice).toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
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
          final itemCode = entry.key;
          final quantity = entry.value;
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
          return sum + (quantity * item.sellUnitPrice);
        });

        return GradientFormCard(
          padding: const EdgeInsets.all(16.0),
          borderRadius: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${localizations.items}: $itemCount',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '${localizations.total}: ${totalAmount.toStringAsFixed(2)} JOD',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      itemCount == 0
                          ? null
                          : () {
                            final Map<String, dynamic> selectedItemsData = {};

                            for (final entry in state.selectedItems.entries) {
                              final itemCode = entry.key;
                              final quantity = entry.value;

                              if (quantity > 0) {
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

                                if (item.itemCode.isNotEmpty) {
                                  selectedItemsData[itemCode] = {
                                    'item': item,
                                    'quantity': quantity,
                                    'total': quantity * item.sellUnitPrice,
                                  };
                                }
                              }
                            }

                            context.pop(selectedItemsData);
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    localizations.saveItems,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
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
