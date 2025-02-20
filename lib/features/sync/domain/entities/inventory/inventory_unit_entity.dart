import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_unit_entity.freezed.dart';
part 'inventory_unit_entity.g.dart';

@freezed
class InventoryUnitEntity with _$InventoryUnitEntity {
  const factory InventoryUnitEntity({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'Unit_cd') required String unitCode,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _InventoryUnitEntity;

  factory InventoryUnitEntity.fromJson(Map<String, dynamic> json) =>
      _$InventoryUnitEntityFromJson(json);
}
