part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  final double totalAmount;
  final String selectedAddress;
  final String userEmail;
  final List<CartItem> items;

  const PaymentState({
    this.totalAmount = 0.0,
    this.selectedAddress = '',
    this.userEmail = '',
    this.items = const [],
  });

  @override
  List<Object?> get props => [totalAmount, selectedAddress, userEmail, items];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentId;
  final String orderId;

  const PaymentSuccess({required this.paymentId, required this.orderId});

  @override
  List<Object?> get props => [paymentId, orderId];
}

class PaymentError extends PaymentState {
  final String errorMessage;

  const PaymentError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
