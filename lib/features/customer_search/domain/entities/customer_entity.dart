import 'package:flutter/foundation.dart';

@immutable
class CustomerEntity {
  final String customerCode;
  final String customerName;
  final String? address;
  final String? contactPhone;
  final String? mapCoords;

  const CustomerEntity({
    required this.customerCode,
    required this.customerName,
    this.address,
    this.contactPhone,
    this.mapCoords,
  });

  factory CustomerEntity.fromJson(Map<String, dynamic> json) {
    return CustomerEntity(
      customerCode: json['customerCode'] as String,
      customerName: json['customerName'] as String,
      address: json['address'] as String?,
      contactPhone: json['contactPhone'] as String?,
      mapCoords: json['mapCoords'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerCode': customerCode,
      'customerName': customerName,
      'address': address,
      'contactPhone': contactPhone,
      'mapCoords': mapCoords,
    };
  }
}
