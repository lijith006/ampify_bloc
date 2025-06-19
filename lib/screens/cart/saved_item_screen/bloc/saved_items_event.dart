part of 'saved_items_bloc.dart';

abstract class SavedItemsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSavedItems extends SavedItemsEvent {}

class MoveToCart extends SavedItemsEvent {
  final CartItem item;
  final CartBloc cartBloc;

  MoveToCart(this.item, this.cartBloc);

  @override
  List<Object> get props => [item];
}
