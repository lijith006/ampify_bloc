import 'package:ampify_bloc/screens/cart/cart_model.dart';

abstract class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final double amount;
  final String orderId;
  final String paymentId;

  final List<CartItem> items;
  final String address;
  final String userEmail;

  PlaceOrder({
    required this.paymentId,
    required this.amount,
    required this.orderId,
    required this.items,
    required this.address,
    required this.userEmail,
  });
}

class InitiatePayment extends OrderEvent {
  final double amount;
  final List<CartItem> items;
  final String address;
  final String userEmail;

  InitiatePayment({
    required this.amount,
    required this.items,
    required this.address,
    required this.userEmail,
  });
}

class FetchOrders extends OrderEvent {}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String newStatus;

  UpdateOrderStatus({required this.orderId, required this.newStatus});
}
