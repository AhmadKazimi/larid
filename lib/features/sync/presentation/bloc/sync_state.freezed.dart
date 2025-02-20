// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ApiCallState<T> {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorCode => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<T>? get data => throw _privateConstructorUsedError;

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiCallStateCopyWith<T, ApiCallState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiCallStateCopyWith<T, $Res> {
  factory $ApiCallStateCopyWith(
    ApiCallState<T> value,
    $Res Function(ApiCallState<T>) then,
  ) = _$ApiCallStateCopyWithImpl<T, $Res, ApiCallState<T>>;
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<T>? data,
  });
}

/// @nodoc
class _$ApiCallStateCopyWithImpl<T, $Res, $Val extends ApiCallState<T>>
    implements $ApiCallStateCopyWith<T, $Res> {
  _$ApiCallStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSuccess:
                null == isSuccess
                    ? _value.isSuccess
                    : isSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorCode:
                freezed == errorCode
                    ? _value.errorCode
                    : errorCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as List<T>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiCallStateImplCopyWith<T, $Res>
    implements $ApiCallStateCopyWith<T, $Res> {
  factory _$$ApiCallStateImplCopyWith(
    _$ApiCallStateImpl<T> value,
    $Res Function(_$ApiCallStateImpl<T>) then,
  ) = __$$ApiCallStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<T>? data,
  });
}

/// @nodoc
class __$$ApiCallStateImplCopyWithImpl<T, $Res>
    extends _$ApiCallStateCopyWithImpl<T, $Res, _$ApiCallStateImpl<T>>
    implements _$$ApiCallStateImplCopyWith<T, $Res> {
  __$$ApiCallStateImplCopyWithImpl(
    _$ApiCallStateImpl<T> _value,
    $Res Function(_$ApiCallStateImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$ApiCallStateImpl<T>(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSuccess:
            null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorCode:
            freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        data:
            freezed == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as List<T>?,
      ),
    );
  }
}

/// @nodoc

class _$ApiCallStateImpl<T> implements _ApiCallState<T> {
  const _$ApiCallStateImpl({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorCode,
    this.errorMessage,
    final List<T>? data,
  }) : _data = data;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final String? errorCode;
  @override
  final String? errorMessage;
  final List<T>? _data;
  @override
  List<T>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApiCallState<$T>(isLoading: $isLoading, isSuccess: $isSuccess, errorCode: $errorCode, errorMessage: $errorMessage, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiCallStateImpl<T> &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isSuccess,
    errorCode,
    errorMessage,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiCallStateImplCopyWith<T, _$ApiCallStateImpl<T>> get copyWith =>
      __$$ApiCallStateImplCopyWithImpl<T, _$ApiCallStateImpl<T>>(
        this,
        _$identity,
      );
}

abstract class _ApiCallState<T> implements ApiCallState<T> {
  const factory _ApiCallState({
    final bool isLoading,
    final bool isSuccess,
    final String? errorCode,
    final String? errorMessage,
    final List<T>? data,
  }) = _$ApiCallStateImpl<T>;

  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  String? get errorCode;
  @override
  String? get errorMessage;
  @override
  List<T>? get data;

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiCallStateImplCopyWith<T, _$ApiCallStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SyncState {
  ApiCallState<CustomerEntity> get customersState =>
      throw _privateConstructorUsedError;
  ApiCallState<CustomerEntity> get salesRepState =>
      throw _privateConstructorUsedError;
  ApiCallState<PriceEntity> get pricesState =>
      throw _privateConstructorUsedError;
  ApiCallState<InventoryItemEntity> get inventoryItemsState =>
      throw _privateConstructorUsedError;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStateCopyWith<SyncState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
  @useResult
  $Res call({
    ApiCallState<CustomerEntity> customersState,
    ApiCallState<CustomerEntity> salesRepState,
    ApiCallState<PriceEntity> pricesState,
    ApiCallState<InventoryItemEntity> inventoryItemsState,
  });

  $ApiCallStateCopyWith<CustomerEntity, $Res> get customersState;
  $ApiCallStateCopyWith<CustomerEntity, $Res> get salesRepState;
  $ApiCallStateCopyWith<PriceEntity, $Res> get pricesState;
  $ApiCallStateCopyWith<InventoryItemEntity, $Res> get inventoryItemsState;
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customersState = null,
    Object? salesRepState = null,
    Object? pricesState = null,
    Object? inventoryItemsState = null,
  }) {
    return _then(
      _value.copyWith(
            customersState:
                null == customersState
                    ? _value.customersState
                    : customersState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState<CustomerEntity>,
            salesRepState:
                null == salesRepState
                    ? _value.salesRepState
                    : salesRepState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState<CustomerEntity>,
            pricesState:
                null == pricesState
                    ? _value.pricesState
                    : pricesState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState<PriceEntity>,
            inventoryItemsState:
                null == inventoryItemsState
                    ? _value.inventoryItemsState
                    : inventoryItemsState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState<InventoryItemEntity>,
          )
          as $Val,
    );
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<CustomerEntity, $Res> get customersState {
    return $ApiCallStateCopyWith<CustomerEntity, $Res>(_value.customersState, (
      value,
    ) {
      return _then(_value.copyWith(customersState: value) as $Val);
    });
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<CustomerEntity, $Res> get salesRepState {
    return $ApiCallStateCopyWith<CustomerEntity, $Res>(_value.salesRepState, (
      value,
    ) {
      return _then(_value.copyWith(salesRepState: value) as $Val);
    });
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<PriceEntity, $Res> get pricesState {
    return $ApiCallStateCopyWith<PriceEntity, $Res>(_value.pricesState, (
      value,
    ) {
      return _then(_value.copyWith(pricesState: value) as $Val);
    });
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<InventoryItemEntity, $Res> get inventoryItemsState {
    return $ApiCallStateCopyWith<InventoryItemEntity, $Res>(
      _value.inventoryItemsState,
      (value) {
        return _then(_value.copyWith(inventoryItemsState: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$SyncStateImplCopyWith<$Res>
    implements $SyncStateCopyWith<$Res> {
  factory _$$SyncStateImplCopyWith(
    _$SyncStateImpl value,
    $Res Function(_$SyncStateImpl) then,
  ) = __$$SyncStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ApiCallState<CustomerEntity> customersState,
    ApiCallState<CustomerEntity> salesRepState,
    ApiCallState<PriceEntity> pricesState,
    ApiCallState<InventoryItemEntity> inventoryItemsState,
  });

  @override
  $ApiCallStateCopyWith<CustomerEntity, $Res> get customersState;
  @override
  $ApiCallStateCopyWith<CustomerEntity, $Res> get salesRepState;
  @override
  $ApiCallStateCopyWith<PriceEntity, $Res> get pricesState;
  @override
  $ApiCallStateCopyWith<InventoryItemEntity, $Res> get inventoryItemsState;
}

/// @nodoc
class __$$SyncStateImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncStateImpl>
    implements _$$SyncStateImplCopyWith<$Res> {
  __$$SyncStateImplCopyWithImpl(
    _$SyncStateImpl _value,
    $Res Function(_$SyncStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customersState = null,
    Object? salesRepState = null,
    Object? pricesState = null,
    Object? inventoryItemsState = null,
  }) {
    return _then(
      _$SyncStateImpl(
        customersState:
            null == customersState
                ? _value.customersState
                : customersState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState<CustomerEntity>,
        salesRepState:
            null == salesRepState
                ? _value.salesRepState
                : salesRepState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState<CustomerEntity>,
        pricesState:
            null == pricesState
                ? _value.pricesState
                : pricesState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState<PriceEntity>,
        inventoryItemsState:
            null == inventoryItemsState
                ? _value.inventoryItemsState
                : inventoryItemsState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState<InventoryItemEntity>,
      ),
    );
  }
}

/// @nodoc

class _$SyncStateImpl implements _SyncState {
  const _$SyncStateImpl({
    this.customersState = const ApiCallState<CustomerEntity>(),
    this.salesRepState = const ApiCallState<CustomerEntity>(),
    this.pricesState = const ApiCallState<PriceEntity>(),
    this.inventoryItemsState = const ApiCallState<InventoryItemEntity>(),
  });

  @override
  @JsonKey()
  final ApiCallState<CustomerEntity> customersState;
  @override
  @JsonKey()
  final ApiCallState<CustomerEntity> salesRepState;
  @override
  @JsonKey()
  final ApiCallState<PriceEntity> pricesState;
  @override
  @JsonKey()
  final ApiCallState<InventoryItemEntity> inventoryItemsState;

  @override
  String toString() {
    return 'SyncState(customersState: $customersState, salesRepState: $salesRepState, pricesState: $pricesState, inventoryItemsState: $inventoryItemsState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateImpl &&
            (identical(other.customersState, customersState) ||
                other.customersState == customersState) &&
            (identical(other.salesRepState, salesRepState) ||
                other.salesRepState == salesRepState) &&
            (identical(other.pricesState, pricesState) ||
                other.pricesState == pricesState) &&
            (identical(other.inventoryItemsState, inventoryItemsState) ||
                other.inventoryItemsState == inventoryItemsState));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    customersState,
    salesRepState,
    pricesState,
    inventoryItemsState,
  );

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      __$$SyncStateImplCopyWithImpl<_$SyncStateImpl>(this, _$identity);
}

abstract class _SyncState implements SyncState {
  const factory _SyncState({
    final ApiCallState<CustomerEntity> customersState,
    final ApiCallState<CustomerEntity> salesRepState,
    final ApiCallState<PriceEntity> pricesState,
    final ApiCallState<InventoryItemEntity> inventoryItemsState,
  }) = _$SyncStateImpl;

  @override
  ApiCallState<CustomerEntity> get customersState;
  @override
  ApiCallState<CustomerEntity> get salesRepState;
  @override
  ApiCallState<PriceEntity> get pricesState;
  @override
  ApiCallState<InventoryItemEntity> get inventoryItemsState;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
