abstract class PaymentEvent {}

class StartPayment extends PaymentEvent {
  final double amount;
  final String orderId;

  StartPayment({required this.amount, required this.orderId});
}
