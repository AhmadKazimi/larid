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
  List<InvoiceItemModel> get items => throw _privateConstructorUsedError;
  List<InvoiceItemModel> get returnItems => throw _privateConstructorUsedError;
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
  bool get isSubmitted => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String? get invoiceNumber => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

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
    List<InvoiceItemModel> items,
    List<InvoiceItemModel> returnItems,
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
    bool isSubmitted,
    bool isDeleted,
    String paymentType,
    String? invoiceNumber,
    String? errorMessage,
    bool isLoading,
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
    Object? items = null,
    Object? returnItems = null,
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
    Object? isSubmitted = null,
    Object? isDeleted = null,
    Object? paymentType = null,
    Object? invoiceNumber = freezed,
    Object? errorMessage = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            customer:
                null == customer
                    ? _value.customer
                    : customer // ignore: cast_nullable_to_non_nullable
                        as CustomerEntity,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<InvoiceItemModel>,
            returnItems:
                null == returnItems
                    ? _value.returnItems
                    : returnItems // ignore: cast_nullable_to_non_nullable
                        as List<InvoiceItemModel>,
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
            isSubmitted:
                null == isSubmitted
                    ? _value.isSubmitted
                    : isSubmitted // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDeleted:
                null == isDeleted
                    ? _value.isDeleted
                    : isDeleted // ignore: cast_nullable_to_non_nullable
                        as bool,
            paymentType:
                null == paymentType
                    ? _value.paymentType
                    : paymentType // ignore: cast_nullable_to_non_nullable
                        as String,
            invoiceNumber:
                freezed == invoiceNumber
                    ? _value.invoiceNumber
                    : invoiceNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
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
    List<InvoiceItemModel> items,
    List<InvoiceItemModel> returnItems,
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
    bool isSubmitted,
    bool isDeleted,
    String paymentType,
    String? invoiceNumber,
    String? errorMessage,
    bool isLoading,
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
    Object? items = null,
    Object? returnItems = null,
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
    Object? isSubmitted = null,
    Object? isDeleted = null,
    Object? paymentType = null,
    Object? invoiceNumber = freezed,
    Object? errorMessage = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$InvoiceStateImpl(
        customer:
            null == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                    as CustomerEntity,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<InvoiceItemModel>,
        returnItems:
            null == returnItems
                ? _value._returnItems
                : returnItems // ignore: cast_nullable_to_non_nullable
                    as List<InvoiceItemModel>,
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
        isSubmitted:
            null == isSubmitted
                ? _value.isSubmitted
                : isSubmitted // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDeleted:
            null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                    as bool,
        paymentType:
            null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                    as String,
        invoiceNumber:
            freezed == invoiceNumber
                ? _value.invoiceNumber
                : invoiceNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$InvoiceStateImpl implements _InvoiceState {
  const _$InvoiceStateImpl({
    required this.customer,
    final List<InvoiceItemModel> items = const <InvoiceItemModel>[],
    final List<InvoiceItemModel> returnItems = const <InvoiceItemModel>[],
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
    this.isSubmitted = false,
    this.isDeleted = false,
    this.paymentType = 'Cash',
    this.invoiceNumber,
    this.errorMessage,
    this.isLoading = false,
  }) : _items = items,
       _returnItems = returnItems;

  @override
  final CustomerEntity customer;
  final List<InvoiceItemModel> _items;
  @override
  @JsonKey()
  List<InvoiceItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<InvoiceItemModel> _returnItems;
  @override
  @JsonKey()
  List<InvoiceItemModel> get returnItems {
    if (_returnItems is EqualUnmodifiableListView) return _returnItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_returnItems);
  }

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
  final bool isSubmitted;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final String paymentType;
  @override
  final String? invoiceNumber;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'InvoiceState(customer: $customer, items: $items, returnItems: $returnItems, itemCount: $itemCount, returnCount: $returnCount, subtotal: $subtotal, discount: $discount, total: $total, salesTax: $salesTax, grandTotal: $grandTotal, returnSubtotal: $returnSubtotal, returnDiscount: $returnDiscount, returnTotal: $returnTotal, returnSalesTax: $returnSalesTax, returnGrandTotal: $returnGrandTotal, comment: $comment, isSubmitting: $isSubmitting, isSyncing: $isSyncing, isPrinting: $isPrinting, isSubmitted: $isSubmitted, isDeleted: $isDeleted, paymentType: $paymentType, invoiceNumber: $invoiceNumber, errorMessage: $errorMessage, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceStateImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._returnItems,
              _returnItems,
            ) &&
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
            (identical(other.isSubmitted, isSubmitted) ||
                other.isSubmitted == isSubmitted) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    customer,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_returnItems),
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
    isSubmitted,
    isDeleted,
    paymentType,
    invoiceNumber,
    errorMessage,
    isLoading,
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
    final List<InvoiceItemModel> items,
    final List<InvoiceItemModel> returnItems,
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
    final bool isSubmitted,
    final bool isDeleted,
    final String paymentType,
    final String? invoiceNumber,
    final String? errorMessage,
    final bool isLoading,
  }) = _$InvoiceStateImpl;

  @override
  CustomerEntity get customer;
  @override
  List<InvoiceItemModel> get items;
  @override
  List<InvoiceItemModel> get returnItems;
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
  bool get isSubmitted;
  @override
  bool get isDeleted;
  @override
  String get paymentType;
  @override
  String? get invoiceNumber;
  @override
  String? get errorMessage;
  @override
  bool get isLoading;

  /// Create a copy of InvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceStateImplCopyWith<_$InvoiceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InvoiceItemModel {
  InventoryItemEntity get item => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceItemModelCopyWith<InvoiceItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemModelCopyWith<$Res> {
  factory $InvoiceItemModelCopyWith(
    InvoiceItemModel value,
    $Res Function(InvoiceItemModel) then,
  ) = _$InvoiceItemModelCopyWithImpl<$Res, InvoiceItemModel>;
  @useResult
  $Res call({
    InventoryItemEntity item,
    int quantity,
    double totalPrice,
    double discount,
    double tax,
  });

  $InventoryItemEntityCopyWith<$Res> get item;
}

/// @nodoc
class _$InvoiceItemModelCopyWithImpl<$Res, $Val extends InvoiceItemModel>
    implements $InvoiceItemModelCopyWith<$Res> {
  _$InvoiceItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? discount = null,
    Object? tax = null,
  }) {
    return _then(
      _value.copyWith(
            item:
                null == item
                    ? _value.item
                    : item // ignore: cast_nullable_to_non_nullable
                        as InventoryItemEntity,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
            totalPrice:
                null == totalPrice
                    ? _value.totalPrice
                    : totalPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            discount:
                null == discount
                    ? _value.discount
                    : discount // ignore: cast_nullable_to_non_nullable
                        as double,
            tax:
                null == tax
                    ? _value.tax
                    : tax // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryItemEntityCopyWith<$Res> get item {
    return $InventoryItemEntityCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvoiceItemModelImplCopyWith<$Res>
    implements $InvoiceItemModelCopyWith<$Res> {
  factory _$$InvoiceItemModelImplCopyWith(
    _$InvoiceItemModelImpl value,
    $Res Function(_$InvoiceItemModelImpl) then,
  ) = __$$InvoiceItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    InventoryItemEntity item,
    int quantity,
    double totalPrice,
    double discount,
    double tax,
  });

  @override
  $InventoryItemEntityCopyWith<$Res> get item;
}

/// @nodoc
class __$$InvoiceItemModelImplCopyWithImpl<$Res>
    extends _$InvoiceItemModelCopyWithImpl<$Res, _$InvoiceItemModelImpl>
    implements _$$InvoiceItemModelImplCopyWith<$Res> {
  __$$InvoiceItemModelImplCopyWithImpl(
    _$InvoiceItemModelImpl _value,
    $Res Function(_$InvoiceItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? discount = null,
    Object? tax = null,
  }) {
    return _then(
      _$InvoiceItemModelImpl(
        item:
            null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                    as InventoryItemEntity,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
        totalPrice:
            null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        discount:
            null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                    as double,
        tax:
            null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

class _$InvoiceItemModelImpl implements _InvoiceItemModel {
  const _$InvoiceItemModelImpl({
    required this.item,
    required this.quantity,
    required this.totalPrice,
    this.discount = 0.0,
    this.tax = 0.0,
  });

  @override
  final InventoryItemEntity item;
  @override
  final int quantity;
  @override
  final double totalPrice;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double tax;

  @override
  String toString() {
    return 'InvoiceItemModel(item: $item, quantity: $quantity, totalPrice: $totalPrice, discount: $discount, tax: $tax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemModelImpl &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, item, quantity, totalPrice, discount, tax);

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemModelImplCopyWith<_$InvoiceItemModelImpl> get copyWith =>
      __$$InvoiceItemModelImplCopyWithImpl<_$InvoiceItemModelImpl>(
        this,
        _$identity,
      );
}

abstract class _InvoiceItemModel implements InvoiceItemModel {
  const factory _InvoiceItemModel({
    required final InventoryItemEntity item,
    required final int quantity,
    required final double totalPrice,
    final double discount,
    final double tax,
  }) = _$InvoiceItemModelImpl;

  @override
  InventoryItemEntity get item;
  @override
  int get quantity;
  @override
  double get totalPrice;
  @override
  double get discount;
  @override
  double get tax;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceItemModelImplCopyWith<_$InvoiceItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
