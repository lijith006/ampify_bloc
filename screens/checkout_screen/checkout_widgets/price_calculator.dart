import 'package:ampify_bloc/screens/cart/cart_model.dart';

double calculateTotalPrice(List<CartItem> products) {
  double subtotal =
      products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double deliveryCharge = subtotal < 600 ? 40 : 0;
  return subtotal + deliveryCharge;
}
