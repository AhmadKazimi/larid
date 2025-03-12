import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final String id;
  final String invoiceId;
  final String itemCode;
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final bool isReturn;
  final String taxCode;
  final int taxableFlag;
  final String sellUnitCode;
  final double tax_amt; // Tax amount
  final double tax_pc; // Tax percentage
  final DateTime createdAt;
  final DateTime updatedAt;

  const InvoiceItemEntity({
    required this.id,
    required this.invoiceId,
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.isReturn,
    required this.taxCode,
    required this.taxableFlag,
    required this.sellUnitCode,
    this.tax_amt = 0.0,
    this.tax_pc = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    itemCode,
    description,
    quantity,
    unitPrice,
    totalPrice,
    isReturn,
    taxCode,
    taxableFlag,
    sellUnitCode,
    tax_amt,
    tax_pc,
    createdAt,
    updatedAt,
  ];
}
