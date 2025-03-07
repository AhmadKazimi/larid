import '../../../../core/models/api_response.dart';
import '../entities/customer_entity.dart';
import '../entities/inventory/inventory_item_entity.dart';
import '../entities/inventory/inventory_unit_entity.dart';
import '../entities/prices/prices_entity.dart';
import '../entities/sales_tax_entity.dart';
import '../entities/warehouse/warehouse_entity.dart';

abstract class SyncRepository {
  Future<ApiResponse<List<CustomerEntity>>> getCustomers();
  Future<void> saveCustomers(List<CustomerEntity> customers);

  Future<ApiResponse<List<CustomerEntity>>> getSalesrepRouteCustomers();
  Future<void> saveSalesrepRouteCustomers(List<CustomerEntity> customers);

  Future<ApiResponse<List<PriceEntity>>> getPrices();
  Future<void> savePrices(List<PriceEntity> prices);

  Future<ApiResponse<List<InventoryItemEntity>>> getInventoryItems();
  Future<void> saveInventoryItems(List<InventoryItemEntity> items);

  Future<ApiResponse<List<InventoryUnitEntity>>> getInventoryUnits();
  Future<void> saveInventoryUnits(List<InventoryUnitEntity> units);

  Future<ApiResponse<List<SalesTaxEntity>>> getSalesTaxes();
  Future<void> saveSalesTaxes(List<SalesTaxEntity> taxes);

  Future<ApiResponse<List<WarehouseEntity>>> getUserWarehouse();
  Future<void> saveUserWarehouse(String warehouse, String currency);
}
