// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InventoryItemEntity _$InventoryItemEntityFromJson(Map<String, dynamic> json) {
  return _InventoryItemEntity.fromJson(json);
}

/// @nodoc
mixin _$InventoryItemEntity {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sItem_cd')
  String get itemCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'sDescription')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'iTaxable_fl')
  int get taxableFlag => throw _privateConstructorUsedError;
  @JsonKey(name: 'sTax_cd')
  String get taxCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'sSellUnit_cd')
  String get sellUnitCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'mSellUnitPrice_amt')
  double get sellUnitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'Qty')
  int get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryItemEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryItemEntityCopyWith<InventoryItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemEntityCopyWith<$Res> {
  factory $InventoryItemEntityCopyWith(
    InventoryItemEntity value,
    $Res Function(InventoryItemEntity) then,
  ) = _$InventoryItemEntityCopyWithImpl<$Res, InventoryItemEntity>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sItem_cd') String itemCode,
    @JsonKey(name: 'sDescription') String description,
    @JsonKey(name: 'iTaxable_fl') int taxableFlag,
    @JsonKey(name: 'sTax_cd') String taxCode,
    @JsonKey(name: 'sSellUnit_cd') String sellUnitCode,
    @JsonKey(name: 'mSellUnitPrice_amt') double sellUnitPrice,
    @JsonKey(name: 'Qty') int qty,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$InventoryItemEntityCopyWithImpl<$Res, $Val extends InventoryItemEntity>
    implements $InventoryItemEntityCopyWith<$Res> {
  _$InventoryItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemCode = null,
    Object? description = null,
    Object? taxableFlag = null,
    Object? taxCode = null,
    Object? sellUnitCode = null,
    Object? sellUnitPrice = null,
    Object? qty = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            itemCode:
                null == itemCode
                    ? _value.itemCode
                    : itemCode // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            taxableFlag:
                null == taxableFlag
                    ? _value.taxableFlag
                    : taxableFlag // ignore: cast_nullable_to_non_nullable
                        as int,
            taxCode:
                null == taxCode
                    ? _value.taxCode
                    : taxCode // ignore: cast_nullable_to_non_nullable
                        as String,
            sellUnitCode:
                null == sellUnitCode
                    ? _value.sellUnitCode
                    : sellUnitCode // ignore: cast_nullable_to_non_nullable
                        as String,
            sellUnitPrice:
                null == sellUnitPrice
                    ? _value.sellUnitPrice
                    : sellUnitPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            qty:
                null == qty
                    ? _value.qty
                    : qty // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryItemEntityImplCopyWith<$Res>
    implements $InventoryItemEntityCopyWith<$Res> {
  factory _$$InventoryItemEntityImplCopyWith(
    _$InventoryItemEntityImpl value,
    $Res Function(_$InventoryItemEntityImpl) then,
  ) = __$$InventoryItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sItem_cd') String itemCode,
    @JsonKey(name: 'sDescription') String description,
    @JsonKey(name: 'iTaxable_fl') int taxableFlag,
    @JsonKey(name: 'sTax_cd') String taxCode,
    @JsonKey(name: 'sSellUnit_cd') String sellUnitCode,
    @JsonKey(name: 'mSellUnitPrice_amt') double sellUnitPrice,
    @JsonKey(name: 'Qty') int qty,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$InventoryItemEntityImplCopyWithImpl<$Res>
    extends _$InventoryItemEntityCopyWithImpl<$Res, _$InventoryItemEntityImpl>
    implements _$$InventoryItemEntityImplCopyWith<$Res> {
  __$$InventoryItemEntityImplCopyWithImpl(
    _$InventoryItemEntityImpl _value,
    $Res Function(_$InventoryItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemCode = null,
    Object? description = null,
    Object? taxableFlag = null,
    Object? taxCode = null,
    Object? sellUnitCode = null,
    Object? sellUnitPrice = null,
    Object? qty = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$InventoryItemEntityImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        itemCode:
            null == itemCode
                ? _value.itemCode
                : itemCode // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        taxableFlag:
            null == taxableFlag
                ? _value.taxableFlag
                : taxableFlag // ignore: cast_nullable_to_non_nullable
                    as int,
        taxCode:
            null == taxCode
                ? _value.taxCode
                : taxCode // ignore: cast_nullable_to_non_nullable
                    as String,
        sellUnitCode:
            null == sellUnitCode
                ? _value.sellUnitCode
                : sellUnitCode // ignore: cast_nullable_to_non_nullable
                    as String,
        sellUnitPrice:
            null == sellUnitPrice
                ? _value.sellUnitPrice
                : sellUnitPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        qty:
            null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemEntityImpl implements _InventoryItemEntity {
  const _$InventoryItemEntityImpl({
    @JsonKey(name: 'id') this.id,
    @JsonKey(name: 'sItem_cd') required this.itemCode,
    @JsonKey(name: 'sDescription') required this.description,
    @JsonKey(name: 'iTaxable_fl') required this.taxableFlag,
    @JsonKey(name: 'sTax_cd') required this.taxCode,
    @JsonKey(name: 'sSellUnit_cd') required this.sellUnitCode,
    @JsonKey(name: 'mSellUnitPrice_amt') required this.sellUnitPrice,
    @JsonKey(name: 'Qty') required this.qty,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$InventoryItemEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemEntityImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'sItem_cd')
  final String itemCode;
  @override
  @JsonKey(name: 'sDescription')
  final String description;
  @override
  @JsonKey(name: 'iTaxable_fl')
  final int taxableFlag;
  @override
  @JsonKey(name: 'sTax_cd')
  final String taxCode;
  @override
  @JsonKey(name: 'sSellUnit_cd')
  final String sellUnitCode;
  @override
  @JsonKey(name: 'mSellUnitPrice_amt')
  final double sellUnitPrice;
  @override
  @JsonKey(name: 'Qty')
  final int qty;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'InventoryItemEntity(id: $id, itemCode: $itemCode, description: $description, taxableFlag: $taxableFlag, taxCode: $taxCode, sellUnitCode: $sellUnitCode, sellUnitPrice: $sellUnitPrice, qty: $qty, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemCode, itemCode) ||
                other.itemCode == itemCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taxableFlag, taxableFlag) ||
                other.taxableFlag == taxableFlag) &&
            (identical(other.taxCode, taxCode) || other.taxCode == taxCode) &&
            (identical(other.sellUnitCode, sellUnitCode) ||
                other.sellUnitCode == sellUnitCode) &&
            (identical(other.sellUnitPrice, sellUnitPrice) ||
                other.sellUnitPrice == sellUnitPrice) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    itemCode,
    description,
    taxableFlag,
    taxCode,
    sellUnitCode,
    sellUnitPrice,
    qty,
    createdAt,
  );

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemEntityImplCopyWith<_$InventoryItemEntityImpl> get copyWith =>
      __$$InventoryItemEntityImplCopyWithImpl<_$InventoryItemEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemEntityImplToJson(this);
  }
}

abstract class _InventoryItemEntity implements InventoryItemEntity {
  const factory _InventoryItemEntity({
    @JsonKey(name: 'id') final int? id,
    @JsonKey(name: 'sItem_cd') required final String itemCode,
    @JsonKey(name: 'sDescription') required final String description,
    @JsonKey(name: 'iTaxable_fl') required final int taxableFlag,
    @JsonKey(name: 'sTax_cd') required final String taxCode,
    @JsonKey(name: 'sSellUnit_cd') required final String sellUnitCode,
    @JsonKey(name: 'mSellUnitPrice_amt') required final double sellUnitPrice,
    @JsonKey(name: 'Qty') required final int qty,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$InventoryItemEntityImpl;

  factory _InventoryItemEntity.fromJson(Map<String, dynamic> json) =
      _$InventoryItemEntityImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'sItem_cd')
  String get itemCode;
  @override
  @JsonKey(name: 'sDescription')
  String get description;
  @override
  @JsonKey(name: 'iTaxable_fl')
  int get taxableFlag;
  @override
  @JsonKey(name: 'sTax_cd')
  String get taxCode;
  @override
  @JsonKey(name: 'sSellUnit_cd')
  String get sellUnitCode;
  @override
  @JsonKey(name: 'mSellUnitPrice_amt')
  double get sellUnitPrice;
  @override
  @JsonKey(name: 'Qty')
  int get qty;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryItemEntityImplCopyWith<_$InventoryItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
