import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_tax_entity.freezed.dart';
part 'sales_tax_entity.g.dart';

@freezed
class SalesTaxEntity with _$SalesTaxEntity {
  const factory SalesTaxEntity({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sTax_cd', defaultValue: '') required String taxCode,
    @JsonKey(name: 'sTax_desc', defaultValue: '') required String description,
    @JsonKey(name: 'mTax_rate', defaultValue: 0.0) required double taxRate,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _SalesTaxEntity;

  factory SalesTaxEntity.fromJson(Map<String, dynamic> json) {
    // Handle potential null or invalid values
    return _$SalesTaxEntityFromJson({
      'id': json['id'],
      'sTax_cd': json['sTax_cd']?.toString() ?? '',
      'sTax_desc': json['sTax_desc']?.toString() ?? '',
      'mTax_rate': (json['mTax_rate'] is num) 
          ? (json['mTax_rate'] as num).toDouble() 
          : 0.0,
      'created_at': json['created_at']?.toString(),
    });
  }
}
