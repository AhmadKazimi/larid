// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_config_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ApiConfigEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String baseUrl) saveBaseUrl,
    required TResult Function() checkBaseUrl,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String baseUrl)? saveBaseUrl,
    TResult? Function()? checkBaseUrl,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String baseUrl)? saveBaseUrl,
    TResult Function()? checkBaseUrl,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SaveBaseUrl value) saveBaseUrl,
    required TResult Function(_CheckBaseUrl value) checkBaseUrl,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult? Function(_CheckBaseUrl value)? checkBaseUrl,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult Function(_CheckBaseUrl value)? checkBaseUrl,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiConfigEventCopyWith<$Res> {
  factory $ApiConfigEventCopyWith(
    ApiConfigEvent value,
    $Res Function(ApiConfigEvent) then,
  ) = _$ApiConfigEventCopyWithImpl<$Res, ApiConfigEvent>;
}

/// @nodoc
class _$ApiConfigEventCopyWithImpl<$Res, $Val extends ApiConfigEvent>
    implements $ApiConfigEventCopyWith<$Res> {
  _$ApiConfigEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiConfigEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SaveBaseUrlImplCopyWith<$Res> {
  factory _$$SaveBaseUrlImplCopyWith(
    _$SaveBaseUrlImpl value,
    $Res Function(_$SaveBaseUrlImpl) then,
  ) = __$$SaveBaseUrlImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String baseUrl});
}

/// @nodoc
class __$$SaveBaseUrlImplCopyWithImpl<$Res>
    extends _$ApiConfigEventCopyWithImpl<$Res, _$SaveBaseUrlImpl>
    implements _$$SaveBaseUrlImplCopyWith<$Res> {
  __$$SaveBaseUrlImplCopyWithImpl(
    _$SaveBaseUrlImpl _value,
    $Res Function(_$SaveBaseUrlImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? baseUrl = null}) {
    return _then(
      _$SaveBaseUrlImpl(
        null == baseUrl
            ? _value.baseUrl
            : baseUrl // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$SaveBaseUrlImpl implements _SaveBaseUrl {
  const _$SaveBaseUrlImpl(this.baseUrl);

  @override
  final String baseUrl;

  @override
  String toString() {
    return 'ApiConfigEvent.saveBaseUrl(baseUrl: $baseUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveBaseUrlImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, baseUrl);

  /// Create a copy of ApiConfigEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveBaseUrlImplCopyWith<_$SaveBaseUrlImpl> get copyWith =>
      __$$SaveBaseUrlImplCopyWithImpl<_$SaveBaseUrlImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String baseUrl) saveBaseUrl,
    required TResult Function() checkBaseUrl,
  }) {
    return saveBaseUrl(baseUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String baseUrl)? saveBaseUrl,
    TResult? Function()? checkBaseUrl,
  }) {
    return saveBaseUrl?.call(baseUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String baseUrl)? saveBaseUrl,
    TResult Function()? checkBaseUrl,
    required TResult orElse(),
  }) {
    if (saveBaseUrl != null) {
      return saveBaseUrl(baseUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SaveBaseUrl value) saveBaseUrl,
    required TResult Function(_CheckBaseUrl value) checkBaseUrl,
  }) {
    return saveBaseUrl(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult? Function(_CheckBaseUrl value)? checkBaseUrl,
  }) {
    return saveBaseUrl?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult Function(_CheckBaseUrl value)? checkBaseUrl,
    required TResult orElse(),
  }) {
    if (saveBaseUrl != null) {
      return saveBaseUrl(this);
    }
    return orElse();
  }
}

abstract class _SaveBaseUrl implements ApiConfigEvent {
  const factory _SaveBaseUrl(final String baseUrl) = _$SaveBaseUrlImpl;

  String get baseUrl;

  /// Create a copy of ApiConfigEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveBaseUrlImplCopyWith<_$SaveBaseUrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckBaseUrlImplCopyWith<$Res> {
  factory _$$CheckBaseUrlImplCopyWith(
    _$CheckBaseUrlImpl value,
    $Res Function(_$CheckBaseUrlImpl) then,
  ) = __$$CheckBaseUrlImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckBaseUrlImplCopyWithImpl<$Res>
    extends _$ApiConfigEventCopyWithImpl<$Res, _$CheckBaseUrlImpl>
    implements _$$CheckBaseUrlImplCopyWith<$Res> {
  __$$CheckBaseUrlImplCopyWithImpl(
    _$CheckBaseUrlImpl _value,
    $Res Function(_$CheckBaseUrlImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckBaseUrlImpl implements _CheckBaseUrl {
  const _$CheckBaseUrlImpl();

  @override
  String toString() {
    return 'ApiConfigEvent.checkBaseUrl()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckBaseUrlImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String baseUrl) saveBaseUrl,
    required TResult Function() checkBaseUrl,
  }) {
    return checkBaseUrl();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String baseUrl)? saveBaseUrl,
    TResult? Function()? checkBaseUrl,
  }) {
    return checkBaseUrl?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String baseUrl)? saveBaseUrl,
    TResult Function()? checkBaseUrl,
    required TResult orElse(),
  }) {
    if (checkBaseUrl != null) {
      return checkBaseUrl();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SaveBaseUrl value) saveBaseUrl,
    required TResult Function(_CheckBaseUrl value) checkBaseUrl,
  }) {
    return checkBaseUrl(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult? Function(_CheckBaseUrl value)? checkBaseUrl,
  }) {
    return checkBaseUrl?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SaveBaseUrl value)? saveBaseUrl,
    TResult Function(_CheckBaseUrl value)? checkBaseUrl,
    required TResult orElse(),
  }) {
    if (checkBaseUrl != null) {
      return checkBaseUrl(this);
    }
    return orElse();
  }
}

abstract class _CheckBaseUrl implements ApiConfigEvent {
  const factory _CheckBaseUrl() = _$CheckBaseUrlImpl;
}

/// @nodoc
mixin _$ApiConfigState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiConfigStateCopyWith<$Res> {
  factory $ApiConfigStateCopyWith(
    ApiConfigState value,
    $Res Function(ApiConfigState) then,
  ) = _$ApiConfigStateCopyWithImpl<$Res, ApiConfigState>;
}

/// @nodoc
class _$ApiConfigStateCopyWithImpl<$Res, $Val extends ApiConfigState>
    implements $ApiConfigStateCopyWith<$Res> {
  _$ApiConfigStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ApiConfigState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ApiConfigState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ApiConfigState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ApiConfigState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$ExistsImplCopyWith<$Res> {
  factory _$$ExistsImplCopyWith(
    _$ExistsImpl value,
    $Res Function(_$ExistsImpl) then,
  ) = __$$ExistsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String baseUrl});
}

/// @nodoc
class __$$ExistsImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$ExistsImpl>
    implements _$$ExistsImplCopyWith<$Res> {
  __$$ExistsImplCopyWithImpl(
    _$ExistsImpl _value,
    $Res Function(_$ExistsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? baseUrl = null}) {
    return _then(
      _$ExistsImpl(
        null == baseUrl
            ? _value.baseUrl
            : baseUrl // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$ExistsImpl implements _Exists {
  const _$ExistsImpl(this.baseUrl);

  @override
  final String baseUrl;

  @override
  String toString() {
    return 'ApiConfigState.exists(baseUrl: $baseUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExistsImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, baseUrl);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExistsImplCopyWith<_$ExistsImpl> get copyWith =>
      __$$ExistsImplCopyWithImpl<_$ExistsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return exists(baseUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return exists?.call(baseUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exists != null) {
      return exists(baseUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return exists(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return exists?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (exists != null) {
      return exists(this);
    }
    return orElse();
  }
}

abstract class _Exists implements ApiConfigState {
  const factory _Exists(final String baseUrl) = _$ExistsImpl;

  String get baseUrl;

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExistsImplCopyWith<_$ExistsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotExistsImplCopyWith<$Res> {
  factory _$$NotExistsImplCopyWith(
    _$NotExistsImpl value,
    $Res Function(_$NotExistsImpl) then,
  ) = __$$NotExistsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotExistsImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$NotExistsImpl>
    implements _$$NotExistsImplCopyWith<$Res> {
  __$$NotExistsImplCopyWithImpl(
    _$NotExistsImpl _value,
    $Res Function(_$NotExistsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotExistsImpl implements _NotExists {
  const _$NotExistsImpl();

  @override
  String toString() {
    return 'ApiConfigState.notExists()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotExistsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return notExists();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return notExists?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notExists != null) {
      return notExists();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return notExists(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return notExists?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (notExists != null) {
      return notExists(this);
    }
    return orElse();
  }
}

abstract class _NotExists implements ApiConfigState {
  const factory _NotExists() = _$NotExistsImpl;
}

/// @nodoc
abstract class _$$SavedImplCopyWith<$Res> {
  factory _$$SavedImplCopyWith(
    _$SavedImpl value,
    $Res Function(_$SavedImpl) then,
  ) = __$$SavedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SavedImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$SavedImpl>
    implements _$$SavedImplCopyWith<$Res> {
  __$$SavedImplCopyWithImpl(
    _$SavedImpl _value,
    $Res Function(_$SavedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SavedImpl implements _Saved {
  const _$SavedImpl();

  @override
  String toString() {
    return 'ApiConfigState.saved()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SavedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return saved();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return saved?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return saved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return saved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(this);
    }
    return orElse();
  }
}

abstract class _Saved implements ApiConfigState {
  const factory _Saved() = _$SavedImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ApiConfigStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ApiConfigState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String baseUrl) exists,
    required TResult Function() notExists,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String baseUrl)? exists,
    TResult? Function()? notExists,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String baseUrl)? exists,
    TResult Function()? notExists,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Exists value) exists,
    required TResult Function(_NotExists value) notExists,
    required TResult Function(_Saved value) saved,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Exists value)? exists,
    TResult? Function(_NotExists value)? notExists,
    TResult? Function(_Saved value)? saved,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Exists value)? exists,
    TResult Function(_NotExists value)? notExists,
    TResult Function(_Saved value)? saved,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ApiConfigState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ApiConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
