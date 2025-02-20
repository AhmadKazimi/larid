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
mixin _$ApiCallState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorCode => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<CustomerEntity>? get data => throw _privateConstructorUsedError;

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiCallStateCopyWith<ApiCallState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiCallStateCopyWith<$Res> {
  factory $ApiCallStateCopyWith(
    ApiCallState value,
    $Res Function(ApiCallState) then,
  ) = _$ApiCallStateCopyWithImpl<$Res, ApiCallState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<CustomerEntity>? data,
  });
}

/// @nodoc
class _$ApiCallStateCopyWithImpl<$Res, $Val extends ApiCallState>
    implements $ApiCallStateCopyWith<$Res> {
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
                        as List<CustomerEntity>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiCallStateImplCopyWith<$Res>
    implements $ApiCallStateCopyWith<$Res> {
  factory _$$ApiCallStateImplCopyWith(
    _$ApiCallStateImpl value,
    $Res Function(_$ApiCallStateImpl) then,
  ) = __$$ApiCallStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<CustomerEntity>? data,
  });
}

/// @nodoc
class __$$ApiCallStateImplCopyWithImpl<$Res>
    extends _$ApiCallStateCopyWithImpl<$Res, _$ApiCallStateImpl>
    implements _$$ApiCallStateImplCopyWith<$Res> {
  __$$ApiCallStateImplCopyWithImpl(
    _$ApiCallStateImpl _value,
    $Res Function(_$ApiCallStateImpl) _then,
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
      _$ApiCallStateImpl(
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
                    as List<CustomerEntity>?,
      ),
    );
  }
}

/// @nodoc

class _$ApiCallStateImpl implements _ApiCallState {
  const _$ApiCallStateImpl({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorCode,
    this.errorMessage,
    final List<CustomerEntity>? data,
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
  final List<CustomerEntity>? _data;
  @override
  List<CustomerEntity>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApiCallState(isLoading: $isLoading, isSuccess: $isSuccess, errorCode: $errorCode, errorMessage: $errorMessage, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiCallStateImpl &&
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
  _$$ApiCallStateImplCopyWith<_$ApiCallStateImpl> get copyWith =>
      __$$ApiCallStateImplCopyWithImpl<_$ApiCallStateImpl>(this, _$identity);
}

abstract class _ApiCallState implements ApiCallState {
  const factory _ApiCallState({
    final bool isLoading,
    final bool isSuccess,
    final String? errorCode,
    final String? errorMessage,
    final List<CustomerEntity>? data,
  }) = _$ApiCallStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  String? get errorCode;
  @override
  String? get errorMessage;
  @override
  List<CustomerEntity>? get data;

  /// Create a copy of ApiCallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiCallStateImplCopyWith<_$ApiCallStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SyncState {
  ApiCallState get customersState => throw _privateConstructorUsedError;
  ApiCallState get salesRepState => throw _privateConstructorUsedError;

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
  $Res call({ApiCallState customersState, ApiCallState salesRepState});

  $ApiCallStateCopyWith<$Res> get customersState;
  $ApiCallStateCopyWith<$Res> get salesRepState;
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
  $Res call({Object? customersState = null, Object? salesRepState = null}) {
    return _then(
      _value.copyWith(
            customersState:
                null == customersState
                    ? _value.customersState
                    : customersState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState,
            salesRepState:
                null == salesRepState
                    ? _value.salesRepState
                    : salesRepState // ignore: cast_nullable_to_non_nullable
                        as ApiCallState,
          )
          as $Val,
    );
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<$Res> get customersState {
    return $ApiCallStateCopyWith<$Res>(_value.customersState, (value) {
      return _then(_value.copyWith(customersState: value) as $Val);
    });
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiCallStateCopyWith<$Res> get salesRepState {
    return $ApiCallStateCopyWith<$Res>(_value.salesRepState, (value) {
      return _then(_value.copyWith(salesRepState: value) as $Val);
    });
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
  $Res call({ApiCallState customersState, ApiCallState salesRepState});

  @override
  $ApiCallStateCopyWith<$Res> get customersState;
  @override
  $ApiCallStateCopyWith<$Res> get salesRepState;
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
  $Res call({Object? customersState = null, Object? salesRepState = null}) {
    return _then(
      _$SyncStateImpl(
        customersState:
            null == customersState
                ? _value.customersState
                : customersState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState,
        salesRepState:
            null == salesRepState
                ? _value.salesRepState
                : salesRepState // ignore: cast_nullable_to_non_nullable
                    as ApiCallState,
      ),
    );
  }
}

/// @nodoc

class _$SyncStateImpl implements _SyncState {
  const _$SyncStateImpl({
    this.customersState = const ApiCallState(),
    this.salesRepState = const ApiCallState(),
  });

  @override
  @JsonKey()
  final ApiCallState customersState;
  @override
  @JsonKey()
  final ApiCallState salesRepState;

  @override
  String toString() {
    return 'SyncState(customersState: $customersState, salesRepState: $salesRepState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateImpl &&
            (identical(other.customersState, customersState) ||
                other.customersState == customersState) &&
            (identical(other.salesRepState, salesRepState) ||
                other.salesRepState == salesRepState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, customersState, salesRepState);

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
    final ApiCallState customersState,
    final ApiCallState salesRepState,
  }) = _$SyncStateImpl;

  @override
  ApiCallState get customersState;
  @override
  ApiCallState get salesRepState;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
