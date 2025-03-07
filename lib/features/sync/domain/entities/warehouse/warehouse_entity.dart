import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_entity.freezed.dart';
part 'warehouse_entity.g.dart';

@freezed
class WarehouseEntity with _$WarehouseEntity {
  const factory WarehouseEntity({
    required String warehouse,
    required String currency,
  }) = _WarehouseEntity;

  factory WarehouseEntity.fromJson(Map<String, dynamic> json) =>
      _$WarehouseEntityFromJson(json);
}
