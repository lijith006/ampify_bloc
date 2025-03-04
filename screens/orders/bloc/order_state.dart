// import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';

// abstract class OrderState {}

// class OrderInitial extends OrderState {}

// class OrderLoading extends OrderState {}

// class PaymentInitiated extends OrderState {}

// class OrderPlaced extends OrderState {
//   final String orderId;
//   OrderPlaced({required this.orderId});
// }

// class OrdersLoaded extends OrderState {
//   final List<OrderModel> orders;
//   OrdersLoaded({required this.orders});
// }

// class OrderFailed extends OrderState {
//   final String error;
//   OrderFailed({required this.error});
// }
//************************************************************ */
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class PaymentInitiated extends OrderState {}

class OrderPlaced extends OrderState {
  final String orderId;
  final String status;
  OrderPlaced({required this.orderId, required this.status});
}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

class OrderUpdated extends OrderState {
  final String orderId;
  final String status;

  OrderUpdated({required this.orderId, required this.status});
}

class OrderFailed extends OrderState {
  final String error;
  OrderFailed({required this.error});
}
