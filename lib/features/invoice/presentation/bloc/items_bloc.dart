import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/database/inventory_items_table.dart';
import 'package:larid/features/invoice/presentation/bloc/items_event.dart';
import 'package:larid/features/invoice/presentation/bloc/items_state.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final InventoryItemsTable _inventoryItemsTable = getIt<InventoryItemsTable>();

  ItemsBloc() : super(ItemsState.initial()) {
    on<LoadItems>(_onLoadItems);
    on<LoadMoreItems>(_onLoadMoreItems);
    on<SearchItems>(_onSearchItems);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ResetItems>(_onResetItems);
  }

  void _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(state.copyWith(isLoading: true, page: 1, query: '', clearError: true));

    try {
      final items = await _inventoryItemsTable.getAllItems();

      // Filter items based on isReturn if needed
      // For returns, we might want to filter only certain items that can be returned
      // This is a placeholder - adjust the filtering logic based on your business rules
      final List<InventoryItemEntity> filteredItems =
          event.isReturn
              ? items
                  .where((item) => item.sellUnitPrice > 0)
                  .toList() // Example filter for returnable items
              : items;

      // Show first page of items
      final List<InventoryItemEntity> firstPageItems =
          filteredItems.take(state.pageSize).toList();

      emit(
        state.copyWith(
          allItems: filteredItems, // Store filtered items, not all items
          filteredItems: firstPageItems,
          isLoading: false,
          hasMoreItems: filteredItems.length > state.pageSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load items: ${e.toString()}',
        ),
      );
    }
  }

  void _onLoadMoreItems(LoadMoreItems event, Emitter<ItemsState> emit) async {
    if (state.isLoading || !state.hasMoreItems) return;

    final nextPage = state.page + 1;

    // For filtered (search) results
    if (state.query.isNotEmpty) {
      final startIndex = (nextPage - 1) * state.pageSize;
      final filteredItems =
          state.allItems
              .where((item) => _itemMatchesQuery(item, state.query))
              .toList();

      if (startIndex < filteredItems.length) {
        final nextPageItems =
            filteredItems.skip(startIndex).take(state.pageSize).toList();

        emit(
          state.copyWith(
            filteredItems: [...state.filteredItems, ...nextPageItems],
            page: nextPage,
            hasMoreItems: filteredItems.length > startIndex + state.pageSize,
          ),
        );
      }
    }
    // For all items
    else {
      final startIndex = (nextPage - 1) * state.pageSize;

      if (startIndex < state.allItems.length) {
        final nextPageItems =
            state.allItems.skip(startIndex).take(state.pageSize).toList();

        emit(
          state.copyWith(
            filteredItems: [...state.filteredItems, ...nextPageItems],
            page: nextPage,
            hasMoreItems: state.allItems.length > startIndex + state.pageSize,
          ),
        );
      }
    }
  }

  void _onSearchItems(SearchItems event, Emitter<ItemsState> emit) {
    final query = event.query.trim();

    emit(state.copyWith(isLoading: true, query: query, page: 1));

    if (query.isEmpty) {
      // Reset to first page of all items
      final firstPageItems = state.allItems.take(state.pageSize).toList();

      emit(
        state.copyWith(
          filteredItems: firstPageItems,
          isLoading: false,
          hasMoreItems: state.allItems.length > state.pageSize,
        ),
      );
    } else {
      // Filter items by query
      final filteredItems =
          state.allItems
              .where((item) => _itemMatchesQuery(item, query))
              .take(state.pageSize)
              .toList();

      final totalFilteredCount =
          state.allItems.where((item) => _itemMatchesQuery(item, query)).length;

      emit(
        state.copyWith(
          filteredItems: filteredItems,
          isLoading: false,
          hasMoreItems: totalFilteredCount > state.pageSize,
        ),
      );
    }
  }

  bool _itemMatchesQuery(InventoryItemEntity item, String query) {
    final lowercaseQuery = query.toLowerCase();
    return item.itemCode.toLowerCase().contains(lowercaseQuery) ||
        item.description.toLowerCase().contains(lowercaseQuery);
  }

  void _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<ItemsState> emit,
  ) {
    final updatedSelectedItems = Map<String, int>.from(state.selectedItems);

    if (event.quantity <= 0) {
      updatedSelectedItems.remove(event.itemCode);
    } else {
      updatedSelectedItems[event.itemCode] = event.quantity;
    }

    emit(state.copyWith(selectedItems: updatedSelectedItems));
  }

  void _onResetItems(ResetItems event, Emitter<ItemsState> emit) {
    emit(
      state.copyWith(
        selectedItems: {},
        query: '',
        page: 1,
        filteredItems: state.allItems.take(state.pageSize).toList(),
        hasMoreItems: state.allItems.length > state.pageSize,
      ),
    );
  }
}
