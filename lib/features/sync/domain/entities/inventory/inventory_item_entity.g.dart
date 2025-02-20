// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemEntityImpl _$$InventoryItemEntityImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryItemEntityImpl(
  id: (json['id'] as num?)?.toInt(),
  itemCode: json['sItem_cd'] as String,
  description: json['sDescription'] as String,
  taxableFlag: (json['iTaxable_fl'] as num).toInt(),
  taxCode: json['sTax_cd'] as String,
  sellUnitCode: json['sSellUnit_cd'] as String,
  sellUnitPrice: (json['mSellUnitPrice_amt'] as num).toDouble(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$InventoryItemEntityImplToJson(
  _$InventoryItemEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sItem_cd': instance.itemCode,
  'sDescription': instance.description,
  'iTaxable_fl': instance.taxableFlag,
  'sTax_cd': instance.taxCode,
  'sSellUnit_cd': instance.sellUnitCode,
  'mSellUnitPrice_amt': instance.sellUnitPrice,
  'created_at': instance.createdAt,
};
