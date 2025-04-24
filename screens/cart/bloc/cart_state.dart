import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState with EquatableMixin {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
