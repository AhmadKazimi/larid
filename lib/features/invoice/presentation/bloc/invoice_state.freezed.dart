// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InvoiceState {
  CustomerEntity get customer => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get returnCount => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get salesTax => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  double get returnSubtotal => throw _privateConstructorUsedError;
  double get returnDiscount => throw _privateConstructorUsedError;
  double get returnTotal => throw _privateConstructorUsedError;
  double get returnSalesTax => throw _privateConstructorUsedError;
  double get returnGrandTotal => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get isSyncing => throw _privateConstructorUsedError;
  bool get isPrinting => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceStateCopyWith<InvoiceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceStateCopyWith<$Res> {
  factory $InvoiceStateCopyWith(
    InvoiceState value,
    $Res Function(InvoiceState) then,
  ) = _$InvoiceStateCopyWithImpl<$Res, InvoiceState>;
  @useResult
  $Res call({
    CustomerEntity customer,
    int itemCount,
    int returnCount,
    double subtotal,
    double discount,
    double total,
    double salesTax,
    double grandTotal,
    double returnSubtotal,
    double returnDiscount,
    double returnTotal,
    double returnSalesTax,
    double returnGrandTotal,
    String comment,
    bool isSubmitting,
    bool isSyncing,
    bool isPrinting,
    String paymentType,
    String? errorMessage,
  });

  $CustomerEntityCopyWith<$Res> get customer;
}

/// @nodoc
class _$InvoiceStateCopyWithImpl<$Res, $Val extends InvoiceState>
    implements $InvoiceStateCopyWith<$Res> {
  _$InvoiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? itemCount = null,
    Object? returnCount = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? total = null,
    Object? salesTax = null,
    Object? grandTotal = null,
    Object? returnSubtotal = null,
    Object? returnDiscount = null,
    Object? returnTotal = null,
    Object? returnSalesTax = null,
    Object? returnGrandTotal = null,
    Object? comment = null,
    Object? isSubmitting = null,
    Object? isSyncing = null,
    Object? isPrinting = null,
    Object? paymentType = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            customer:
                null == customer
                    ? _value.customer
                    : customer // ignore: cast_nullable_to_non_nullable
                        as CustomerEntity,
            itemCount:
                null == itemCount
                    ? _value.itemCount
                    : itemCount // ignore: cast_nullable_to_non_nullable
                        as int,
            returnCount:
                null == returnCount
                    ? _value.returnCount
                    : returnCount // ignore: cast_nullable_to_non_nullable
                        as int,
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            discount:
                null == discount
                    ? _value.discount
                    : discount // ignore: cast_nullable_to_non_nullable
                        as double,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as double,
            salesTax:
                null == salesTax
                    ? _value.salesTax
                    : salesTax // ignore: cast_nullable_to_non_nullable
                        as double,
            grandTotal:
                null == grandTotal
                    ? _value.grandTotal
                    : grandTotal // ignore: cast_nullable_to_non_nullable
                        as double,
            returnSubtotal:
                null == returnSubtotal
                    ? _value.returnSubtotal
                    : returnSubtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            returnDiscount:
                null == returnDiscount
                    ? _value.returnDiscount
                    : returnDiscount // ignore: cast_nullable_to_non_nullable
                        as double,
            returnTotal:
                null == returnTotal
                    ? _value.returnTotal
                    : returnTotal // ignore: cast_nullable_to_non_nullable
                        as double,
            returnSalesTax:
                null == returnSalesTax
                    ? _value.returnSalesTax
                    : returnSalesTax // ignore: cast_nullable_to_non_nullable
                        as double,
            returnGrandTotal:
                null == returnGrandTotal
                    ? _value.returnGrandTotal
                    : returnGrandTotal // ignore: cast_nullable_to_non_nullable
                        as double,
            comment:
                null == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String,
            isSubmitting:
                null == isSubmitting
                    ? _value.isSubmitting
                    : isSubmitting // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSyncing:
                null == isSyncing
                    ? _value.isSyncing
                    : isSyncing // ignore: cast_nullable_to_non_nullable
                        as bool,
            isPrinting:
                null == isPrinting
                    ? _value.isPrinting
                    : isPrinting // ignore: cast_nullable_to_non_nullable
                        as bool,
            paymentType:
                null == paymentType
                    ? _value.paymentType
                    : paymentType // ignore: cast_nullable_to_non_nullable
                        as String,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerEntityCopyWith<$Res> get customer {
    return $CustomerEntityCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvoiceStateImplCopyWith<$Res>
    implements $InvoiceStateCopyWith<$Res> {
  factory _$$InvoiceStateImplCopyWith(
    _$InvoiceStateImpl value,
    $Res Function(_$InvoiceStateImpl) then,
  ) = __$$InvoiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CustomerEntity customer,
    int itemCount,
    int returnCount,
    double subtotal,
    double discount,
    double total,
    double salesTax,
    double grandTotal,
    double returnSubtotal,
    double returnDiscount,
    double returnTotal,
    double returnSalesTax,
    double returnGrandTotal,
    String comment,
    bool isSubmitting,
    bool isSyncing,
    bool isPrinting,
    String paymentType,
    String? errorMessage,
  });

  @override
  $CustomerEntityCopyWith<$Res> get customer;
}

/// @nodoc
class __$$InvoiceStateImplCopyWithImpl<$Res>
    extends _$InvoiceStateCopyWithImpl<$Res, _$InvoiceStateImpl>
    implements _$$InvoiceStateImplCopyWith<$Res> {
  __$$InvoiceStateImplCopyWithImpl(
    _$InvoiceStateImpl _value,
    $Res Function(_$InvoiceStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? itemCount = null,
    Object? returnCount = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? total = null,
    Object? salesTax = null,
    Object? grandTotal = null,
    Object? returnSubtotal = null,
    Object? returnDiscount = null,
    Object? returnTotal = null,
    Object? returnSalesTax = null,
    Object? returnGrandTotal = null,
    Object? comment = null,
    Object? isSubmitting = null,
    Object? isSyncing = null,
    Object? isPrinting = null,
    Object? paymentType = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$InvoiceStateImpl(
        customer:
            null == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                    as CustomerEntity,
        itemCount:
            null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                    as int,
        returnCount:
            null == returnCount
                ? _value.returnCount
                : returnCount // ignore: cast_nullable_to_non_nullable
                    as int,
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        discount:
            null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                    as double,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as double,
        salesTax:
            null == salesTax
                ? _value.salesTax
                : salesTax // ignore: cast_nullable_to_non_nullable
                    as double,
        grandTotal:
            null == grandTotal
                ? _value.grandTotal
                : grandTotal // ignore: cast_nullable_to_non_nullable
                    as double,
        returnSubtotal:
            null == returnSubtotal
                ? _value.returnSubtotal
                : returnSubtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        returnDiscount:
            null == returnDiscount
                ? _value.returnDiscount
                : returnDiscount // ignore: cast_nullable_to_non_nullable
                    as double,
        returnTotal:
            null == returnTotal
                ? _value.returnTotal
                : returnTotal // ignore: cast_nullable_to_non_nullable
                    as double,
        returnSalesTax:
            null == returnSalesTax
                ? _value.returnSalesTax
                : returnSalesTax // ignore: cast_nullable_to_non_nullable
                    as double,
        returnGrandTotal:
            null == returnGrandTotal
                ? _value.returnGrandTotal
                : returnGrandTotal // ignore: cast_nullable_to_non_nullable
                    as double,
        comment:
            null == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String,
        isSubmitting:
            null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSyncing:
            null == isSyncing
                ? _value.isSyncing
                : isSyncing // ignore: cast_nullable_to_non_nullable
                    as bool,
        isPrinting:
            null == isPrinting
                ? _value.isPrinting
                : isPrinting // ignore: cast_nullable_to_non_nullable
                    as bool,
        paymentType:
            null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                    as String,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$InvoiceStateImpl implements _InvoiceState {
  const _$InvoiceStateImpl({
    required this.customer,
    this.itemCount = 0,
    this.returnCount = 0,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.total = 0.0,
    this.salesTax = 0.0,
    this.grandTotal = 0.0,
    this.returnSubtotal = 0.0,
    this.returnDiscount = 0.0,
    this.returnTotal = 0.0,
    this.returnSalesTax = 0.0,
    this.returnGrandTotal = 0.0,
    this.comment = '',
    this.isSubmitting = false,
    this.isSyncing = false,
    this.isPrinting = false,
    this.paymentType = 'Cash',
    this.errorMessage,
  });

  @override
  final CustomerEntity customer;
  @override
  @JsonKey()
  final int itemCount;
  @override
  @JsonKey()
  final int returnCount;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double total;
  @override
  @JsonKey()
  final double salesTax;
  @override
  @JsonKey()
  final double grandTotal;
  @override
  @JsonKey()
  final double returnSubtotal;
  @override
  @JsonKey()
  final double returnDiscount;
  @override
  @JsonKey()
  final double returnTotal;
  @override
  @JsonKey()
  final double returnSalesTax;
  @override
  @JsonKey()
  final double returnGrandTotal;
  @override
  @JsonKey()
  final String comment;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool isSyncing;
  @override
  @JsonKey()
  final bool isPrinting;
  @override
  @JsonKey()
  final String paymentType;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'InvoiceState(customer: $customer, itemCount: $itemCount, returnCount: $returnCount, subtotal: $subtotal, discount: $discount, total: $total, salesTax: $salesTax, grandTotal: $grandTotal, returnSubtotal: $returnSubtotal, returnDiscount: $returnDiscount, returnTotal: $returnTotal, returnSalesTax: $returnSalesTax, returnGrandTotal: $returnGrandTotal, comment: $comment, isSubmitting: $isSubmitting, isSyncing: $isSyncing, isPrinting: $isPrinting, paymentType: $paymentType, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceStateImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.returnCount, returnCount) ||
                other.returnCount == returnCount) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.salesTax, salesTax) ||
                other.salesTax == salesTax) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.returnSubtotal, returnSubtotal) ||
                other.returnSubtotal == returnSubtotal) &&
            (identical(other.returnDiscount, returnDiscount) ||
                other.returnDiscount == returnDiscount) &&
            (identical(other.returnTotal, returnTotal) ||
                other.returnTotal == returnTotal) &&
            (identical(other.returnSalesTax, returnSalesTax) ||
                other.returnSalesTax == returnSalesTax) &&
            (identical(other.returnGrandTotal, returnGrandTotal) ||
                other.returnGrandTotal == returnGrandTotal) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.isPrinting, isPrinting) ||
                other.isPrinting == isPrinting) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    customer,
    itemCount,
    returnCount,
    subtotal,
    discount,
    total,
    salesTax,
    grandTotal,
    returnSubtotal,
    returnDiscount,
    returnTotal,
    returnSalesTax,
    returnGrandTotal,
    comment,
    isSubmitting,
    isSyncing,
    isPrinting,
    paymentType,
    errorMessage,
  ]);

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceStateImplCopyWith<_$InvoiceStateImpl> get copyWith =>
      __$$InvoiceStateImplCopyWithImpl<_$InvoiceStateImpl>(this, _$identity);
}

abstract class _InvoiceState implements InvoiceState {
  const factory _InvoiceState({
    required final CustomerEntity customer,
    final int itemCount,
    final int returnCount,
    final double subtotal,
    final double discount,
    final double total,
    final double salesTax,
    final double grandTotal,
    final double returnSubtotal,
    final double returnDiscount,
    final double returnTotal,
    final double returnSalesTax,
    final double returnGrandTotal,
    final String comment,
    final bool isSubmitting,
    final bool isSyncing,
    final bool isPrinting,
    final String paymentType,
    final String? errorMessage,
  }) = _$InvoiceStateImpl;

  @override
  CustomerEntity get customer;
  @override
  int get itemCount;
  @override
  int get returnCount;
  @override
  double get subtotal;
  @override
  double get discount;
  @override
  double get total;
  @override
  double get salesTax;
  @override
  double get grandTotal;
  @override
  double get returnSubtotal;
  @override
  double get returnDiscount;
  @override
  double get returnTotal;
  @override
  double get returnSalesTax;
  @override
  double get returnGrandTotal;
  @override
  String get comment;
  @override
  bool get isSubmitting;
  @override
  bool get isSyncing;
  @override
  bool get isPrinting;
  @override
  String get paymentType;
  @override
  String? get errorMessage;

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceStateImplCopyWith<_$InvoiceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
