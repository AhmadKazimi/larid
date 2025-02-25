// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_tax_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesTaxEntityImpl _$$SalesTaxEntityImplFromJson(Map<String, dynamic> json) =>
    _$SalesTaxEntityImpl(
      id: (json['id'] as num?)?.toInt(),
      taxCode: json['sTax_cd'] as String,
      description: json['sDescription'] as String,
      taxRate: (json['fTotalTax_pc'] as num).toDouble(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$SalesTaxEntityImplToJson(
  _$SalesTaxEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sTax_cd': instance.taxCode,
  'sDescription': instance.description,
  'fTotalTax_pc': instance.taxRate,
  'created_at': instance.createdAt,
};
