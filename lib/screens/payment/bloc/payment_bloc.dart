// import 'dart:async';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../orders/bloc/order_bloc.dart';
import '../../cart/cart_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  //final Razorpay _razorpay = Razorpay();
  final OrderBloc orderBloc;

  PaymentBloc({required this.orderBloc}) : super(PaymentInitial()) {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    //on<InitiatePayment>(_onInitiatePayment);
  }
}
