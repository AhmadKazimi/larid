// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerEntity _$CustomerEntityFromJson(Map<String, dynamic> json) {
  return _CustomerEntity.fromJson(json);
}

/// @nodoc
mixin _$CustomerEntity {
  String get customerCode => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get mapCoords => throw _privateConstructorUsedError;

  /// Serializes this CustomerEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerEntityCopyWith<CustomerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerEntityCopyWith<$Res> {
  factory $CustomerEntityCopyWith(
    CustomerEntity value,
    $Res Function(CustomerEntity) then,
  ) = _$CustomerEntityCopyWithImpl<$Res, CustomerEntity>;
  @useResult
  $Res call({
    String customerCode,
    String customerName,
    String? address,
    String? contactPhone,
    String? mapCoords,
  });
}

/// @nodoc
class _$CustomerEntityCopyWithImpl<$Res, $Val extends CustomerEntity>
    implements $CustomerEntityCopyWith<$Res> {
  _$CustomerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerCode = null,
    Object? customerName = null,
    Object? address = freezed,
    Object? contactPhone = freezed,
    Object? mapCoords = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerCode:
                null == customerCode
                    ? _value.customerCode
                    : customerCode // ignore: cast_nullable_to_non_nullable
                        as String,
            customerName:
                null == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String?,
            contactPhone:
                freezed == contactPhone
                    ? _value.contactPhone
                    : contactPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            mapCoords:
                freezed == mapCoords
                    ? _value.mapCoords
                    : mapCoords // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerEntityImplCopyWith<$Res>
    implements $CustomerEntityCopyWith<$Res> {
  factory _$$CustomerEntityImplCopyWith(
    _$CustomerEntityImpl value,
    $Res Function(_$CustomerEntityImpl) then,
  ) = __$$CustomerEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String customerCode,
    String customerName,
    String? address,
    String? contactPhone,
    String? mapCoords,
  });
}

/// @nodoc
class __$$CustomerEntityImplCopyWithImpl<$Res>
    extends _$CustomerEntityCopyWithImpl<$Res, _$CustomerEntityImpl>
    implements _$$CustomerEntityImplCopyWith<$Res> {
  __$$CustomerEntityImplCopyWithImpl(
    _$CustomerEntityImpl _value,
    $Res Function(_$CustomerEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerCode = null,
    Object? customerName = null,
    Object? address = freezed,
    Object? contactPhone = freezed,
    Object? mapCoords = freezed,
  }) {
    return _then(
      _$CustomerEntityImpl(
        customerCode:
            null == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                    as String,
        customerName:
            null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String?,
        contactPhone:
            freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        mapCoords:
            freezed == mapCoords
                ? _value.mapCoords
                : mapCoords // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerEntityImpl implements _CustomerEntity {
  const _$CustomerEntityImpl({
    required this.customerCode,
    required this.customerName,
    this.address,
    this.contactPhone,
    this.mapCoords,
  });

  factory _$CustomerEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerEntityImplFromJson(json);

  @override
  final String customerCode;
  @override
  final String customerName;
  @override
  final String? address;
  @override
  final String? contactPhone;
  @override
  final String? mapCoords;

  @override
  String toString() {
    return 'CustomerEntity(customerCode: $customerCode, customerName: $customerName, address: $address, contactPhone: $contactPhone, mapCoords: $mapCoords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerEntityImpl &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.mapCoords, mapCoords) ||
                other.mapCoords == mapCoords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    customerCode,
    customerName,
    address,
    contactPhone,
    mapCoords,
  );

  /// Create a copy of CustomerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerEntityImplCopyWith<_$CustomerEntityImpl> get copyWith =>
      __$$CustomerEntityImplCopyWithImpl<_$CustomerEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerEntityImplToJson(this);
  }
}

abstract class _CustomerEntity implements CustomerEntity {
  const factory _CustomerEntity({
    required final String customerCode,
    required final String customerName,
    final String? address,
    final String? contactPhone,
    final String? mapCoords,
  }) = _$CustomerEntityImpl;

  factory _CustomerEntity.fromJson(Map<String, dynamic> json) =
      _$CustomerEntityImpl.fromJson;

  @override
  String get customerCode;
  @override
  String get customerName;
  @override
  String? get address;
  @override
  String? get contactPhone;
  @override
  String? get mapCoords;

  /// Create a copy of CustomerEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerEntityImplCopyWith<_$CustomerEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
