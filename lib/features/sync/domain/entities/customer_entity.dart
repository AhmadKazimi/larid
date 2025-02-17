import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_entity.freezed.dart';
part 'customer_entity.g.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    required String customerCode,
    required String customerName,
    required String address,
    required String contactPhone,
    required String mapCoords,
  }) = _CustomerEntity;

  factory CustomerEntity.fromJson(Map<String, dynamic> json) => _$CustomerEntityFromJson({
        'customerCode': json['sCustomer_cd'] as String,
        'customerName': json['sCustomer_nm'] as String,
        'address': json['sAddress1'] as String,
        'contactPhone': json['sContactPhone'] as String,
        'mapCoords': json['sMapCoords'] as String,
      });
}
