import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_tax_entity.freezed.dart';
part 'sales_tax_entity.g.dart';

@freezed
class SalesTaxEntity with _$SalesTaxEntity {
  const factory SalesTaxEntity({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sTax_cd') required String taxCode,
    @JsonKey(name: 'sTax_desc') required String description,
    @JsonKey(name: 'mTax_rate') required double taxRate,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _SalesTaxEntity;

  factory SalesTaxEntity.fromJson(Map<String, dynamic> json) => _$SalesTaxEntityFromJson(json);
}
