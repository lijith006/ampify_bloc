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

class CartUpdated extends CartEvent {
  final List<CartItem> items;

  CartUpdated(this.items);
}

class ClearCart extends CartEvent {}
