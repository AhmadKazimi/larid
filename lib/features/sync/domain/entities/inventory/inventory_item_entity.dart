import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item_entity.freezed.dart';
part 'inventory_item_entity.g.dart';

@freezed
class InventoryItemEntity with _$InventoryItemEntity {
  const factory InventoryItemEntity({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sItem_cd') required String itemCode,
    @JsonKey(name: 'sDescription') required String description,
    @JsonKey(name: 'iTaxable_fl') required int taxableFlag,
    @JsonKey(name: 'sTax_cd') required String taxCode,
    @JsonKey(name: 'sSellUnit_cd') required String sellUnitCode,
    @JsonKey(name: 'mSellUnitPrice_amt') required double sellUnitPrice,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _InventoryItemEntity;

  factory InventoryItemEntity.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemEntityFromJson(json);
}
