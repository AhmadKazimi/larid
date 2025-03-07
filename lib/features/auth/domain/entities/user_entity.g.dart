// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      userid: json['userid'] as String,
      workspace: json['workspace'] as String,
      password: json['password'] as String,
      warehouse: json['warehouse'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'workspace': instance.workspace,
      'password': instance.password,
      'warehouse': instance.warehouse,
      'currency': instance.currency,
    };
