import 'package:equatable/equatable.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';

class ItemsState extends Equatable {
  final List<InventoryItemEntity> allItems;
  final List<InventoryItemEntity> filteredItems;
  final Map<String, int> selectedItems; // itemCode -> quantity
  final bool isLoading;
  final bool hasMoreItems;
  final String query;
  final int page;
  final int pageSize;
  final String? error;

  const ItemsState({
    required this.allItems,
    required this.filteredItems,
    required this.selectedItems,
    required this.isLoading,
    required this.hasMoreItems,
    required this.query,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory ItemsState.initial() {
    return const ItemsState(
      allItems: [],
      filteredItems: [],
      selectedItems: {},
      isLoading: true,
      hasMoreItems: false,
      query: '',
      page: 1,
      pageSize: 50,
      error: null,
    );
  }

  ItemsState copyWith({
    List<InventoryItemEntity>? allItems,
    List<InventoryItemEntity>? filteredItems,
    Map<String, int>? selectedItems,
    bool? isLoading,
    bool? hasMoreItems,
    String? query,
    int? page,
    int? pageSize,
    String? error,
    bool clearError = false,
  }) {
    return ItemsState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      query: query ?? this.query,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        selectedItems,
        isLoading,
        hasMoreItems,
        query,
        page,
        pageSize,
        error,
      ];
}
