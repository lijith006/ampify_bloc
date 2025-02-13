// import 'package:equatable/equatable.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';

// abstract class CartEvent extends Equatable {
//   const CartEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadCartItems extends CartEvent {
//   const LoadCartItems();
// }

// class AddToCart extends CartEvent {
//   final CartItem item;
//   const AddToCart(this.item);

//   @override
//   List<Object> get props => [item];
// }

// class RemoveFromCart extends CartEvent {
//   final String productId;
//   const RemoveFromCart(this.productId);

//   @override
//   List<Object> get props => [productId];
// }

// class UpdateQuantity extends CartEvent {
//   final CartItem item;
//   final int change;
//   const UpdateQuantity(this.item, this.change);

//   @override
//   List<Object> get props => [item, change];
// }

// class MoveToCart extends CartEvent {
//   final CartItem item;
//   const MoveToCart(this.item);

//   @override
//   List<Object> get props => [item];
// }

// class SaveForLater extends CartEvent {
//   final CartItem item;
//   const SaveForLater(this.item);

//   @override
//   List<Object> get props => [item];
// }

//*************************************************************************** */

import 'package:ampify_bloc/screens/cart/cart_model.dart';

abstract class CartEvent {}

class LoadCartItems extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class UpdateQuantity extends CartEvent {
  final CartItem item;
  final int change;
  UpdateQuantity(this.item, this.change);
}

class SaveForLater extends CartEvent {
  final CartItem item;
  SaveForLater(this.item);
}
