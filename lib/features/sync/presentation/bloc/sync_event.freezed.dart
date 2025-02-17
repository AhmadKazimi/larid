// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncEvent {
  String get userid => throw _privateConstructorUsedError;
  String get workspace => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userid, String workspace, String password)
    syncCustomers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userid, String workspace, String password)?
    syncCustomers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userid, String workspace, String password)?
    syncCustomers,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncCustomers value) syncCustomers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncCustomers value)? syncCustomers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncCustomers value)? syncCustomers,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncEventCopyWith<SyncEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncEventCopyWith<$Res> {
  factory $SyncEventCopyWith(SyncEvent value, $Res Function(SyncEvent) then) =
      _$SyncEventCopyWithImpl<$Res, SyncEvent>;
  @useResult
  $Res call({String userid, String workspace, String password});
}

/// @nodoc
class _$SyncEventCopyWithImpl<$Res, $Val extends SyncEvent>
    implements $SyncEventCopyWith<$Res> {
  _$SyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userid = null,
    Object? workspace = null,
    Object? password = null,
  }) {
    return _then(
      _value.copyWith(
            userid:
                null == userid
                    ? _value.userid
                    : userid // ignore: cast_nullable_to_non_nullable
                        as String,
            workspace:
                null == workspace
                    ? _value.workspace
                    : workspace // ignore: cast_nullable_to_non_nullable
                        as String,
            password:
                null == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncCustomersImplCopyWith<$Res>
    implements $SyncEventCopyWith<$Res> {
  factory _$$SyncCustomersImplCopyWith(
    _$SyncCustomersImpl value,
    $Res Function(_$SyncCustomersImpl) then,
  ) = __$$SyncCustomersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userid, String workspace, String password});
}

/// @nodoc
class __$$SyncCustomersImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncCustomersImpl>
    implements _$$SyncCustomersImplCopyWith<$Res> {
  __$$SyncCustomersImplCopyWithImpl(
    _$SyncCustomersImpl _value,
    $Res Function(_$SyncCustomersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userid = null,
    Object? workspace = null,
    Object? password = null,
  }) {
    return _then(
      _$SyncCustomersImpl(
        userid:
            null == userid
                ? _value.userid
                : userid // ignore: cast_nullable_to_non_nullable
                    as String,
        workspace:
            null == workspace
                ? _value.workspace
                : workspace // ignore: cast_nullable_to_non_nullable
                    as String,
        password:
            null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$SyncCustomersImpl implements _SyncCustomers {
  const _$SyncCustomersImpl({
    required this.userid,
    required this.workspace,
    required this.password,
  });

  @override
  final String userid;
  @override
  final String workspace;
  @override
  final String password;

  @override
  String toString() {
    return 'SyncEvent.syncCustomers(userid: $userid, workspace: $workspace, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncCustomersImpl &&
            (identical(other.userid, userid) || other.userid == userid) &&
            (identical(other.workspace, workspace) ||
                other.workspace == workspace) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userid, workspace, password);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncCustomersImplCopyWith<_$SyncCustomersImpl> get copyWith =>
      __$$SyncCustomersImplCopyWithImpl<_$SyncCustomersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userid, String workspace, String password)
    syncCustomers,
  }) {
    return syncCustomers(userid, workspace, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userid, String workspace, String password)?
    syncCustomers,
  }) {
    return syncCustomers?.call(userid, workspace, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userid, String workspace, String password)?
    syncCustomers,
    required TResult orElse(),
  }) {
    if (syncCustomers != null) {
      return syncCustomers(userid, workspace, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncCustomers value) syncCustomers,
  }) {
    return syncCustomers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncCustomers value)? syncCustomers,
  }) {
    return syncCustomers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncCustomers value)? syncCustomers,
    required TResult orElse(),
  }) {
    if (syncCustomers != null) {
      return syncCustomers(this);
    }
    return orElse();
  }
}

abstract class _SyncCustomers implements SyncEvent {
  const factory _SyncCustomers({
    required final String userid,
    required final String workspace,
    required final String password,
  }) = _$SyncCustomersImpl;

  @override
  String get userid;
  @override
  String get workspace;
  @override
  String get password;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncCustomersImplCopyWith<_$SyncCustomersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
