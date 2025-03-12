class InvoiceItem {
  final String itemCode; // sItem_cd
  final String description; // sDescription
  final String unit; // sSellUnit_cd
  final double quantity; // qty
  final double price; // mSellUnitPrice_amt
  final String taxCode; // sTax_cd
  final double taxPercentage; // taxPercentage

  InvoiceItem({
    required this.itemCode,
    required this.description,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.taxCode,
    required this.taxPercentage,
  });

  // Calculate the subtotal (price * quantity)
  double get subtotal => price * quantity;

  // Calculate the tax amount
  double get taxAmount => subtotal * (taxPercentage / 100);

  // Calculate the total including tax
  double get total => subtotal + taxAmount;

  // Factory constructor to create an InvoiceItem from a JSON map
  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      itemCode: json['sItem_cd'] ?? '',
      description: json['sDescription'] ?? '',
      unit: json['sSellUnit_cd'] ?? '',
      quantity:
          json['qty'] != null
              ? double.tryParse(json['qty'].toString()) ?? 0.0
              : 0.0,
      price:
          json['mSellUnitPrice_amt'] != null
              ? double.tryParse(json['mSellUnitPrice_amt'].toString()) ?? 0.0
              : 0.0,
      taxCode: json['sTax_cd'] ?? 'NOTAX',
      taxPercentage:
          json['taxPercentage'] != null
              ? double.tryParse(json['taxPercentage'].toString()) ?? 0.0
              : 0.0,
    );
  }

  // Convert InvoiceItem to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sItem_cd': itemCode,
      'sDescription': description,
      'sSellUnit_cd': unit,
      'qty': quantity,
      'mSellUnitPrice_amt': price,
      'sTax_cd': taxCode,
      'taxPercentage': taxPercentage,
      'taxAmount': taxAmount,
      'total': total,
    };
  }
}
