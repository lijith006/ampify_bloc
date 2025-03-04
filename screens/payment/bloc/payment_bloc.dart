// import 'package:ampify_bloc/screens/payment/bloc/payment_event.dart';
// import 'package:ampify_bloc/screens/payment/bloc/payment_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   late Razorpay _razorpay;

//   PaymentBloc() : super(PaymentInitial()) {
//     _razorpay = Razorpay();

//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

//     on<StartPayment>(_onStartPayment);
//   }

//   void _onStartPayment(StartPayment event, Emitter<PaymentState> emit) {
//     emit(PaymentProcessing());
//     try {
//       // var options = {
//       //   // 'key': 'YOUR_RAZORPAY_KEY',
//       //   // 'amount': (event.amount * 100).toInt(),
//       //   // 'currency': 'INR',
//       //   // 'name': 'Ampify',
//       //   // 'description': 'Order Payment',
//       //   // 'order_id': event.orderId,
//       //   // 'prefill': {
//       //   //   'contact': '9876543210',
//       //   //   'email': 'user@example.com',
//       //   // },
//       // };

//       //_razorpay.open(options);
//     } catch (e) {
//       emit(PaymentFailed(error: e.toString()));
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     emit(PaymentSuccess());
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     emit(PaymentFailed(error: response.message ?? "Payment failed"));
//   }

//   @override
//   Future<void> close() {
//     _razorpay.clear();
//     return super.close();
//   }
// }
