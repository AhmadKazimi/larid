import 'package:freezed_annotation/freezed_annotation.dart';

class PriceEntity {
  final String itemCode;
  final double price;
  final String customerCode;
  final String createdAt;

  PriceEntity({
    required this.itemCode,
    required this.price,
    required this.customerCode,
    required this.createdAt,
  });

  factory PriceEntity.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toIso8601String();
    return PriceEntity(
      itemCode: json['sItem_cd'] as String,
      price: (json['mPrice_amt'] as num).toDouble(),
      customerCode: json['sCustomer_cd'] as String,
      createdAt: json['created_at'] as String? ?? now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sItem_cd': itemCode,
      'mPrice_amt': price,
      'sCustomer_cd': customerCode,
      'created_at': createdAt,
    };
  }
}
