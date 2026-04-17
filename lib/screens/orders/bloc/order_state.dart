import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

/// Firestore order created, Razorpay order created
class OrderCreated extends OrderState {
  final String orderId;
  final String razorpayOrderId;

  OrderCreated({
    required this.orderId,
    required this.razorpayOrderId,
  });
}

/// Razorpay checkout opened
class PaymentInProgress extends OrderState {}

/// Payment verified successfully
class PaymentSuccess extends OrderState {
  final String orderId;
  final String paymentId;

  PaymentSuccess({
    required this.orderId,
    required this.paymentId,
  });
}

/// Payment failed or verification failed
class PaymentFailure extends OrderState {
  final String error;
  PaymentFailure({required this.error});
}

/// Orders list
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

/// Any backend / firestore error
class OrderFailed extends OrderState {
  final String error;
  OrderFailed({required this.error});
}
