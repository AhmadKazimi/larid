import 'dart:developer' as dev;
import 'package:larid/database/sales_taxes_table.dart';
import 'package:larid/features/sync/domain/entities/sales_tax_entity.dart';
import 'package:larid/features/taxes/domain/repositories/tax_repository.dart';

class TaxRepositoryImpl implements TaxRepository {
  final SalesTaxesTable _salesTaxesTable;

  // Cache for tax data to minimize DB queries
  List<SalesTaxEntity>? _taxesCache;

  TaxRepositoryImpl({required SalesTaxesTable salesTaxesTable})
    : _salesTaxesTable = salesTaxesTable;

  @override
  Future<List<SalesTaxEntity>> getAllTaxes() async {
    if (_taxesCache != null) {
      return _taxesCache!;
    }

    try {
      final taxes = await _salesTaxesTable.getAllTaxes();
      _taxesCache = taxes;
      dev.log('Retrieved ${taxes.length} taxes from database and cached them');
      return taxes;
    } catch (e) {
      dev.log('Error retrieving taxes: $e');
      return [];
    }
  }

  @override
  Future<SalesTaxEntity?> getTaxByCode(String taxCode) async {
    try {
      // Check cache first
      if (_taxesCache != null) {
        return _taxesCache!.firstWhere(
          (tax) => tax.taxCode == taxCode,
          orElse: () => throw Exception('Tax not found in cache'),
        );
      }

      // Retrieve from database if not in cache
      return await _salesTaxesTable.getTaxByCode(taxCode);
    } catch (e) {
      dev.log('Error retrieving tax by code: $e');
      // Try to get all taxes and search manually
      final allTaxes = await getAllTaxes();
      return allTaxes.firstWhere(
        (tax) => tax.taxCode == taxCode,
        orElse: () => throw Exception('Tax not found'),
      );
    }
  }

  // Clear cache if needed (e.g., after sync)
  void clearCache() {
    _taxesCache = null;
  }
}
