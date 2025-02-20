// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_unit_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryUnitEntityImpl _$$InventoryUnitEntityImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryUnitEntityImpl(
  id: (json['id'] as num?)?.toInt(),
  unitCode: json['Unit_cd'] as String,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$InventoryUnitEntityImplToJson(
  _$InventoryUnitEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'Unit_cd': instance.unitCode,
  'created_at': instance.createdAt,
};
