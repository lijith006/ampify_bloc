part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
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

  @override
  List<Object?> get props => [amount, items, address, userEmail];
}
