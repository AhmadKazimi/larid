import 'package:larid/features/sync/domain/entities/sales_tax_entity.dart';

class TaxCalculatorService {
  // Cache map of tax codes to tax entities for efficient lookups
  final Map<String, SalesTaxEntity> _taxesCache;

  TaxCalculatorService(List<SalesTaxEntity> taxes)
    : _taxesCache = {for (var tax in taxes) tax.taxCode: tax};

  /// Calculate tax amount for a single item
  double calculateTax(String taxCode, double amount) {
    if (taxCode.isEmpty || !_taxesCache.containsKey(taxCode)) {
      return 0.0;
    }

    final taxRate = _taxesCache[taxCode]!.taxRate;
    return amount * (taxRate / 100);
  }

  /// Calculate price after tax for a single item
  double calculatePriceWithTax(String taxCode, double price) {
    final taxAmount = calculateTax(taxCode, price);
    return price + taxAmount;
  }

  /// Get tax percentage for a tax code
  double getTaxPercentage(String taxCode) {
    if (taxCode.isEmpty || !_taxesCache.containsKey(taxCode)) {
      return 0.0;
    }
    return _taxesCache[taxCode]!.taxRate;
  }

  /// Check if a tax code exists
  bool hasTax(String taxCode) {
    return _taxesCache.containsKey(taxCode);
  }
}
