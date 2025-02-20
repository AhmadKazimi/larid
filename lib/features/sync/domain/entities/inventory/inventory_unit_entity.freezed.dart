// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_unit_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InventoryUnitEntity _$InventoryUnitEntityFromJson(Map<String, dynamic> json) {
  return _InventoryUnitEntity.fromJson(json);
}

/// @nodoc
mixin _$InventoryUnitEntity {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Unit_cd')
  String get unitCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryUnitEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryUnitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryUnitEntityCopyWith<InventoryUnitEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryUnitEntityCopyWith<$Res> {
  factory $InventoryUnitEntityCopyWith(
    InventoryUnitEntity value,
    $Res Function(InventoryUnitEntity) then,
  ) = _$InventoryUnitEntityCopyWithImpl<$Res, InventoryUnitEntity>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'Unit_cd') String unitCode,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$InventoryUnitEntityCopyWithImpl<$Res, $Val extends InventoryUnitEntity>
    implements $InventoryUnitEntityCopyWith<$Res> {
  _$InventoryUnitEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryUnitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? unitCode = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            unitCode:
                null == unitCode
                    ? _value.unitCode
                    : unitCode // ignore: cast_nullable_to_non_nullable
                        as String,
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
abstract class _$$InventoryUnitEntityImplCopyWith<$Res>
    implements $InventoryUnitEntityCopyWith<$Res> {
  factory _$$InventoryUnitEntityImplCopyWith(
    _$InventoryUnitEntityImpl value,
    $Res Function(_$InventoryUnitEntityImpl) then,
  ) = __$$InventoryUnitEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'Unit_cd') String unitCode,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$InventoryUnitEntityImplCopyWithImpl<$Res>
    extends _$InventoryUnitEntityCopyWithImpl<$Res, _$InventoryUnitEntityImpl>
    implements _$$InventoryUnitEntityImplCopyWith<$Res> {
  __$$InventoryUnitEntityImplCopyWithImpl(
    _$InventoryUnitEntityImpl _value,
    $Res Function(_$InventoryUnitEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryUnitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? unitCode = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$InventoryUnitEntityImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        unitCode:
            null == unitCode
                ? _value.unitCode
                : unitCode // ignore: cast_nullable_to_non_nullable
                    as String,
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
class _$InventoryUnitEntityImpl implements _InventoryUnitEntity {
  const _$InventoryUnitEntityImpl({
    @JsonKey(name: 'id') this.id,
    @JsonKey(name: 'Unit_cd') required this.unitCode,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$InventoryUnitEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryUnitEntityImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'Unit_cd')
  final String unitCode;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'InventoryUnitEntity(id: $id, unitCode: $unitCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryUnitEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.unitCode, unitCode) ||
                other.unitCode == unitCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, unitCode, createdAt);

  /// Create a copy of InventoryUnitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryUnitEntityImplCopyWith<_$InventoryUnitEntityImpl> get copyWith =>
      __$$InventoryUnitEntityImplCopyWithImpl<_$InventoryUnitEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryUnitEntityImplToJson(this);
  }
}

abstract class _InventoryUnitEntity implements InventoryUnitEntity {
  const factory _InventoryUnitEntity({
    @JsonKey(name: 'id') final int? id,
    @JsonKey(name: 'Unit_cd') required final String unitCode,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$InventoryUnitEntityImpl;

  factory _InventoryUnitEntity.fromJson(Map<String, dynamic> json) =
      _$InventoryUnitEntityImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'Unit_cd')
  String get unitCode;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of InventoryUnitEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryUnitEntityImplCopyWith<_$InventoryUnitEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
