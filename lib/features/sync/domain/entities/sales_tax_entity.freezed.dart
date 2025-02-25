// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_tax_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesTaxEntity _$SalesTaxEntityFromJson(Map<String, dynamic> json) {
  return _SalesTaxEntity.fromJson(json);
}

/// @nodoc
mixin _$SalesTaxEntity {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sTax_cd')
  String get taxCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'sDescription')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'fTotalTax_pc')
  double get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SalesTaxEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesTaxEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesTaxEntityCopyWith<SalesTaxEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesTaxEntityCopyWith<$Res> {
  factory $SalesTaxEntityCopyWith(
    SalesTaxEntity value,
    $Res Function(SalesTaxEntity) then,
  ) = _$SalesTaxEntityCopyWithImpl<$Res, SalesTaxEntity>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sTax_cd') String taxCode,
    @JsonKey(name: 'sDescription') String description,
    @JsonKey(name: 'fTotalTax_pc') double taxRate,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$SalesTaxEntityCopyWithImpl<$Res, $Val extends SalesTaxEntity>
    implements $SalesTaxEntityCopyWith<$Res> {
  _$SalesTaxEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesTaxEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxCode = null,
    Object? description = null,
    Object? taxRate = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            taxCode:
                null == taxCode
                    ? _value.taxCode
                    : taxCode // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            taxRate:
                null == taxRate
                    ? _value.taxRate
                    : taxRate // ignore: cast_nullable_to_non_nullable
                        as double,
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
abstract class _$$SalesTaxEntityImplCopyWith<$Res>
    implements $SalesTaxEntityCopyWith<$Res> {
  factory _$$SalesTaxEntityImplCopyWith(
    _$SalesTaxEntityImpl value,
    $Res Function(_$SalesTaxEntityImpl) then,
  ) = __$$SalesTaxEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'sTax_cd') String taxCode,
    @JsonKey(name: 'sDescription') String description,
    @JsonKey(name: 'fTotalTax_pc') double taxRate,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$SalesTaxEntityImplCopyWithImpl<$Res>
    extends _$SalesTaxEntityCopyWithImpl<$Res, _$SalesTaxEntityImpl>
    implements _$$SalesTaxEntityImplCopyWith<$Res> {
  __$$SalesTaxEntityImplCopyWithImpl(
    _$SalesTaxEntityImpl _value,
    $Res Function(_$SalesTaxEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesTaxEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxCode = null,
    Object? description = null,
    Object? taxRate = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SalesTaxEntityImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        taxCode:
            null == taxCode
                ? _value.taxCode
                : taxCode // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        taxRate:
            null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                    as double,
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
class _$SalesTaxEntityImpl implements _SalesTaxEntity {
  const _$SalesTaxEntityImpl({
    @JsonKey(name: 'id') this.id,
    @JsonKey(name: 'sTax_cd') required this.taxCode,
    @JsonKey(name: 'sDescription') required this.description,
    @JsonKey(name: 'fTotalTax_pc') required this.taxRate,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$SalesTaxEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesTaxEntityImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'sTax_cd')
  final String taxCode;
  @override
  @JsonKey(name: 'sDescription')
  final String description;
  @override
  @JsonKey(name: 'fTotalTax_pc')
  final double taxRate;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'SalesTaxEntity(id: $id, taxCode: $taxCode, description: $description, taxRate: $taxRate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesTaxEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taxCode, taxCode) || other.taxCode == taxCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, taxCode, description, taxRate, createdAt);

  /// Create a copy of SalesTaxEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesTaxEntityImplCopyWith<_$SalesTaxEntityImpl> get copyWith =>
      __$$SalesTaxEntityImplCopyWithImpl<_$SalesTaxEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesTaxEntityImplToJson(this);
  }
}

abstract class _SalesTaxEntity implements SalesTaxEntity {
  const factory _SalesTaxEntity({
    @JsonKey(name: 'id') final int? id,
    @JsonKey(name: 'sTax_cd') required final String taxCode,
    @JsonKey(name: 'sDescription') required final String description,
    @JsonKey(name: 'fTotalTax_pc') required final double taxRate,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$SalesTaxEntityImpl;

  factory _SalesTaxEntity.fromJson(Map<String, dynamic> json) =
      _$SalesTaxEntityImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'sTax_cd')
  String get taxCode;
  @override
  @JsonKey(name: 'sDescription')
  String get description;
  @override
  @JsonKey(name: 'fTotalTax_pc')
  double get taxRate;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of SalesTaxEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesTaxEntityImplCopyWith<_$SalesTaxEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
