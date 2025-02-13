// import 'package:equatable/equatable.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';

// abstract class CartState extends Equatable {
//   const CartState();

//   @override
//   List<Object> get props => [];
// }

// class CartLoading extends CartState {}

// class CartLoaded extends CartState {
//   final List<CartItem> cartItems;
//   final List<CartItem> savedItems;

//   const CartLoaded({required this.cartItems, required this.savedItems});

//   @override
//   List<Object> get props => [cartItems, savedItems];
// }

// class CartError extends CartState {
//   final String message;
//   const CartError(this.message);

//   @override
//   List<Object> get props => [message];
// }
//******************************************************** */

import 'package:ampify_bloc/screens/cart/cart_model.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
