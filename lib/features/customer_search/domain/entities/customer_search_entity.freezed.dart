// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_search_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CustomerSearchResult {
  List<CustomerEntity> get customers => throw _privateConstructorUsedError;

  /// Create a copy of CustomerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerSearchResultCopyWith<CustomerSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerSearchResultCopyWith<$Res> {
  factory $CustomerSearchResultCopyWith(
    CustomerSearchResult value,
    $Res Function(CustomerSearchResult) then,
  ) = _$CustomerSearchResultCopyWithImpl<$Res, CustomerSearchResult>;
  @useResult
  $Res call({List<CustomerEntity> customers});
}

/// @nodoc
class _$CustomerSearchResultCopyWithImpl<
  $Res,
  $Val extends CustomerSearchResult
>
    implements $CustomerSearchResultCopyWith<$Res> {
  _$CustomerSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customers = null}) {
    return _then(
      _value.copyWith(
            customers:
                null == customers
                    ? _value.customers
                    : customers // ignore: cast_nullable_to_non_nullable
                        as List<CustomerEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerSearchResultImplCopyWith<$Res>
    implements $CustomerSearchResultCopyWith<$Res> {
  factory _$$CustomerSearchResultImplCopyWith(
    _$CustomerSearchResultImpl value,
    $Res Function(_$CustomerSearchResultImpl) then,
  ) = __$$CustomerSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CustomerEntity> customers});
}

/// @nodoc
class __$$CustomerSearchResultImplCopyWithImpl<$Res>
    extends _$CustomerSearchResultCopyWithImpl<$Res, _$CustomerSearchResultImpl>
    implements _$$CustomerSearchResultImplCopyWith<$Res> {
  __$$CustomerSearchResultImplCopyWithImpl(
    _$CustomerSearchResultImpl _value,
    $Res Function(_$CustomerSearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customers = null}) {
    return _then(
      _$CustomerSearchResultImpl(
        customers:
            null == customers
                ? _value._customers
                : customers // ignore: cast_nullable_to_non_nullable
                    as List<CustomerEntity>,
      ),
    );
  }
}

/// @nodoc

class _$CustomerSearchResultImpl implements _CustomerSearchResult {
  const _$CustomerSearchResultImpl({
    required final List<CustomerEntity> customers,
  }) : _customers = customers;

  final List<CustomerEntity> _customers;
  @override
  List<CustomerEntity> get customers {
    if (_customers is EqualUnmodifiableListView) return _customers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customers);
  }

  @override
  String toString() {
    return 'CustomerSearchResult(customers: $customers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerSearchResultImpl &&
            const DeepCollectionEquality().equals(
              other._customers,
              _customers,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_customers));

  /// Create a copy of CustomerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerSearchResultImplCopyWith<_$CustomerSearchResultImpl>
  get copyWith =>
      __$$CustomerSearchResultImplCopyWithImpl<_$CustomerSearchResultImpl>(
        this,
        _$identity,
      );
}

abstract class _CustomerSearchResult implements CustomerSearchResult {
  const factory _CustomerSearchResult({
    required final List<CustomerEntity> customers,
  }) = _$CustomerSearchResultImpl;

  @override
  List<CustomerEntity> get customers;

  /// Create a copy of CustomerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerSearchResultImplCopyWith<_$CustomerSearchResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
