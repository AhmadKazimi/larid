import 'package:larid/features/sync/domain/entities/sales_tax_entity.dart';

abstract class TaxRepository {
  /// Get all sales taxes
  Future<List<SalesTaxEntity>> getAllTaxes();

  /// Get tax by tax code
  Future<SalesTaxEntity?> getTaxByCode(String taxCode);
}
