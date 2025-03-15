// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SummaryItemEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;

  /// Create a copy of SummaryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SummaryItemEntityCopyWith<SummaryItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryItemEntityCopyWith<$Res> {
  factory $SummaryItemEntityCopyWith(
    SummaryItemEntity value,
    $Res Function(SummaryItemEntity) then,
  ) = _$SummaryItemEntityCopyWithImpl<$Res, SummaryItemEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    String subtitle,
    DateTime date,
    double amount,
    bool isSynced,
    String? details,
  });
}

/// @nodoc
class _$SummaryItemEntityCopyWithImpl<$Res, $Val extends SummaryItemEntity>
    implements $SummaryItemEntityCopyWith<$Res> {
  _$SummaryItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SummaryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? date = null,
    Object? amount = null,
    Object? isSynced = null,
    Object? details = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            subtitle:
                null == subtitle
                    ? _value.subtitle
                    : subtitle // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            isSynced:
                null == isSynced
                    ? _value.isSynced
                    : isSynced // ignore: cast_nullable_to_non_nullable
                        as bool,
            details:
                freezed == details
                    ? _value.details
                    : details // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SummaryItemEntityImplCopyWith<$Res>
    implements $SummaryItemEntityCopyWith<$Res> {
  factory _$$SummaryItemEntityImplCopyWith(
    _$SummaryItemEntityImpl value,
    $Res Function(_$SummaryItemEntityImpl) then,
  ) = __$$SummaryItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String subtitle,
    DateTime date,
    double amount,
    bool isSynced,
    String? details,
  });
}

/// @nodoc
class __$$SummaryItemEntityImplCopyWithImpl<$Res>
    extends _$SummaryItemEntityCopyWithImpl<$Res, _$SummaryItemEntityImpl>
    implements _$$SummaryItemEntityImplCopyWith<$Res> {
  __$$SummaryItemEntityImplCopyWithImpl(
    _$SummaryItemEntityImpl _value,
    $Res Function(_$SummaryItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SummaryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? date = null,
    Object? amount = null,
    Object? isSynced = null,
    Object? details = freezed,
  }) {
    return _then(
      _$SummaryItemEntityImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        subtitle:
            null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        isSynced:
            null == isSynced
                ? _value.isSynced
                : isSynced // ignore: cast_nullable_to_non_nullable
                    as bool,
        details:
            freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SummaryItemEntityImpl
    with DiagnosticableTreeMixin
    implements _SummaryItemEntity {
  const _$SummaryItemEntityImpl({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isSynced,
    this.details,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final DateTime date;
  @override
  final double amount;
  @override
  final bool isSynced;
  @override
  final String? details;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SummaryItemEntity(id: $id, title: $title, subtitle: $subtitle, date: $date, amount: $amount, isSynced: $isSynced, details: $details)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SummaryItemEntity'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('isSynced', isSynced))
      ..add(DiagnosticsProperty('details', details));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    subtitle,
    date,
    amount,
    isSynced,
    details,
  );

  /// Create a copy of SummaryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryItemEntityImplCopyWith<_$SummaryItemEntityImpl> get copyWith =>
      __$$SummaryItemEntityImplCopyWithImpl<_$SummaryItemEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _SummaryItemEntity implements SummaryItemEntity {
  const factory _SummaryItemEntity({
    required final String id,
    required final String title,
    required final String subtitle,
    required final DateTime date,
    required final double amount,
    required final bool isSynced,
    final String? details,
  }) = _$SummaryItemEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  DateTime get date;
  @override
  double get amount;
  @override
  bool get isSynced;
  @override
  String? get details;

  /// Create a copy of SummaryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SummaryItemEntityImplCopyWith<_$SummaryItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
