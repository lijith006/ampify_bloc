import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

abstract class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final double amount;

  final List<CartItem> items;
  final String address;
  final String customerName;
  PlaceOrder({
    required this.amount,
    required this.items,
    required this.address,
    required this.customerName,
  });
}

class FetchOrders extends OrderEvent {}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String newStatus;

  UpdateOrderStatus({required this.orderId, required this.newStatus});
}

class UpdateOrdersFromSnapshot extends OrderEvent {
  final QuerySnapshot snapshot;
  UpdateOrdersFromSnapshot({required this.snapshot});
}

class OrderSubscriptionError extends OrderEvent {
  final String error;
  OrderSubscriptionError({required this.error});
}

class PaymentSucceeded extends OrderEvent {
  final PaymentSuccessResponse response;

  PaymentSucceeded(this.response);
}

class PaymentFailed extends OrderEvent {
  final String error;

  PaymentFailed(this.error);
}

class PreparePayment extends OrderEvent {
  final double amount;

  PreparePayment(this.amount);
}
