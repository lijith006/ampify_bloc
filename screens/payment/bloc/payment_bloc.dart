import 'dart:async';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../orders/bloc/order_bloc.dart';
import '../../cart/cart_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Razorpay _razorpay = Razorpay();
  final OrderBloc orderBloc;

  PaymentBloc({required this.orderBloc}) : super(PaymentInitial()) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<InitiatePayment>(_onInitiatePayment);
  }

  Future<void> _onInitiatePayment(
      InitiatePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    // Set current order details
    _currentOrderAmount = event.amount;
    _currentOrderItems = event.items;
    _currentUserEmail = event.userEmail;
    _currentOrderAddress = event.address;

    var options = {
      'key': 'rzp_test_FRLD6BPBYxystN',
      'amount': (event.amount * 100).toInt(),
      'name': 'Ampify',
      'description': 'Product Purchase',
      'prefill': {'email': event.userEmail}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      emit(PaymentError('Payment initiation failed: $e'));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String orderId = response.orderId ?? _generateCustomOrderId();
    orderBloc.add(PlaceOrder(
      amount: _currentOrderAmount,
      orderId: orderId,
      paymentId: response.paymentId ?? '',
      address: _currentOrderAddress,
      userEmail: _currentUserEmail,
      items: _currentOrderItems,
    ));

    emit(PaymentSuccess(
      paymentId: response.paymentId ?? '',
      orderId: orderId,
    ));
  }

  String _generateCustomOrderId() {
    // Generate order ID
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    emit(PaymentError('Payment Failed: ${response.message}'));
  }

  // Variables to store current order details
  double _currentOrderAmount = 0.0;
  List<CartItem> _currentOrderItems = [];
  String _currentOrderAddress = '';
  String _currentUserEmail = '';

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
