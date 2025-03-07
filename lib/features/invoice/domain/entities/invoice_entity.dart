import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final double totalAmount;
  final DateTime date;
  final String status;
  final bool isReturn;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InvoiceEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.isReturn,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    totalAmount,
    date,
    status,
    isReturn,
    createdAt,
    updatedAt,
  ];
}
