import 'package:equatable/equatable.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object?> get props => [];
}

class LoadItems extends ItemsEvent {
  final bool isReturn;
  
  const LoadItems({this.isReturn = false});
  
  @override
  List<Object?> get props => [isReturn];
}

class LoadMoreItems extends ItemsEvent {
  final bool isReturn;
  
  const LoadMoreItems({this.isReturn = false});
  
  @override
  List<Object?> get props => [isReturn];
}

class SearchItems extends ItemsEvent {
  final String query;

  const SearchItems({required this.query});

  @override
  List<Object?> get props => [query];
}

class UpdateItemQuantity extends ItemsEvent {
  final String itemCode;
  final int quantity;

  const UpdateItemQuantity({
    required this.itemCode,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemCode, quantity];
}

class ResetItems extends ItemsEvent {
  const ResetItems();
}
