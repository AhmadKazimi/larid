// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WarehouseEntity _$WarehouseEntityFromJson(Map<String, dynamic> json) {
  return _WarehouseEntity.fromJson(json);
}

/// @nodoc
mixin _$WarehouseEntity {
  String get warehouse => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this WarehouseEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WarehouseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarehouseEntityCopyWith<WarehouseEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseEntityCopyWith<$Res> {
  factory $WarehouseEntityCopyWith(
    WarehouseEntity value,
    $Res Function(WarehouseEntity) then,
  ) = _$WarehouseEntityCopyWithImpl<$Res, WarehouseEntity>;
  @useResult
  $Res call({String warehouse, String currency});
}

/// @nodoc
class _$WarehouseEntityCopyWithImpl<$Res, $Val extends WarehouseEntity>
    implements $WarehouseEntityCopyWith<$Res> {
  _$WarehouseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarehouseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? warehouse = null, Object? currency = null}) {
    return _then(
      _value.copyWith(
            warehouse:
                null == warehouse
                    ? _value.warehouse
                    : warehouse // ignore: cast_nullable_to_non_nullable
                        as String,
            currency:
                null == currency
                    ? _value.currency
                    : currency // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WarehouseEntityImplCopyWith<$Res>
    implements $WarehouseEntityCopyWith<$Res> {
  factory _$$WarehouseEntityImplCopyWith(
    _$WarehouseEntityImpl value,
    $Res Function(_$WarehouseEntityImpl) then,
  ) = __$$WarehouseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String warehouse, String currency});
}

/// @nodoc
class __$$WarehouseEntityImplCopyWithImpl<$Res>
    extends _$WarehouseEntityCopyWithImpl<$Res, _$WarehouseEntityImpl>
    implements _$$WarehouseEntityImplCopyWith<$Res> {
  __$$WarehouseEntityImplCopyWithImpl(
    _$WarehouseEntityImpl _value,
    $Res Function(_$WarehouseEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WarehouseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? warehouse = null, Object? currency = null}) {
    return _then(
      _$WarehouseEntityImpl(
        warehouse:
            null == warehouse
                ? _value.warehouse
                : warehouse // ignore: cast_nullable_to_non_nullable
                    as String,
        currency:
            null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseEntityImpl implements _WarehouseEntity {
  const _$WarehouseEntityImpl({
    required this.warehouse,
    required this.currency,
  });

  factory _$WarehouseEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseEntityImplFromJson(json);

  @override
  final String warehouse;
  @override
  final String currency;

  @override
  String toString() {
    return 'WarehouseEntity(warehouse: $warehouse, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseEntityImpl &&
            (identical(other.warehouse, warehouse) ||
                other.warehouse == warehouse) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, warehouse, currency);

  /// Create a copy of WarehouseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseEntityImplCopyWith<_$WarehouseEntityImpl> get copyWith =>
      __$$WarehouseEntityImplCopyWithImpl<_$WarehouseEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseEntityImplToJson(this);
  }
}

abstract class _WarehouseEntity implements WarehouseEntity {
  const factory _WarehouseEntity({
    required final String warehouse,
    required final String currency,
  }) = _$WarehouseEntityImpl;

  factory _WarehouseEntity.fromJson(Map<String, dynamic> json) =
      _$WarehouseEntityImpl.fromJson;

  @override
  String get warehouse;
  @override
  String get currency;

  /// Create a copy of WarehouseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarehouseEntityImplCopyWith<_$WarehouseEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
