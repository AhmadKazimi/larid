// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerEntityImpl _$$CustomerEntityImplFromJson(Map<String, dynamic> json) =>
    _$CustomerEntityImpl(
      customerCode: json['customerCode'] as String,
      customerName: json['customerName'] as String,
      address: json['address'] as String?,
      contactPhone: json['contactPhone'] as String?,
      mapCoords: json['mapCoords'] as String?,
      visitStartTime: json['visitStartTime'] as String?,
      visitEndTime: json['visitEndTime'] as String?,
    );

Map<String, dynamic> _$$CustomerEntityImplToJson(
  _$CustomerEntityImpl instance,
) => <String, dynamic>{
  'customerCode': instance.customerCode,
  'customerName': instance.customerName,
  'address': instance.address,
  'contactPhone': instance.contactPhone,
  'mapCoords': instance.mapCoords,
  'visitStartTime': instance.visitStartTime,
  'visitEndTime': instance.visitEndTime,
};
