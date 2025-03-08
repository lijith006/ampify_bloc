// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Razorpay _razorpay = Razorpay();

//   OrderBloc() : super(OrderInitial()) {
//     on<PlaceOrder>(_onPlaceOrder);
//     on<FetchOrders>(_onFetchOrders);
//     on<UpdateOrderStatus>(_onUpdateOrderStatus);
//     // on<InitiatePayment>(_onInitiatePayment);

//     // Setup Razorpay Listeners
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     String firestoreOrderId = _firestore.collection('orders').doc().id;
//     add(PlaceOrder(
//       amount: _currentOrderAmount,
//       orderId: firestoreOrderId,
//       paymentId: response.paymentId ?? '',
//       items: _currentOrderItems,
//       address: _currentOrderAddress,
//       userEmail: _currentUserEmail,
//     ));
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     emit(OrderFailed(error: 'Payment Failed: ${response.message}'));
//   }

//   // Variables to store current order details
//   double _currentOrderAmount = 0.0;
//   List<CartItem> _currentOrderItems = [];
//   String _currentOrderAddress = '';
//   String _currentUserEmail = '';

//   Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
//     emit(OrderLoading());
//     try {
//       String userId = _auth.currentUser?.uid ?? '';

//       if (userId.isEmpty) {
//         emit(OrderFailed(error: "User not logged in."));
//         return;
//       }

// //Fetch customer name
//       final userDoc = await _firestore.collection('users').doc(userId).get();
//       String customerName =
//           userDoc.exists ? (userDoc.data()?['name'] ?? 'User') : 'User';

//       String orderId = _firestore.collection('orders').doc().id;
//       OrderModel newOrder = OrderModel(
//         id: orderId,
//         paymentId: event.paymentId,
//         items: event.items,
//         totalAmount: event.amount,
//         userId: userId,
//         customerName: customerName,
//         status: 'pending',
//         address: event.address,
//         createdAt: Timestamp.now(),
//       );

//       await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

//       emit(OrderPlaced(
//           orderId: orderId, status: "Pending", paymentId: event.paymentId));
//     } catch (e) {
//       emit(OrderFailed(error: e.toString()));
//     }
//   }

//   Future<void> _onFetchOrders(
//       FetchOrders event, Emitter<OrderState> emit) async {
//     emit(OrderLoading());
//     try {
//       String userId = _auth.currentUser?.uid ?? '';

//       QuerySnapshot snapshot = await _firestore
//           .collection('orders')
//           .where('userId', isEqualTo: userId)
//           .get();

//       List<OrderModel> orders = snapshot.docs
//           .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();

//       emit(OrdersLoaded(orders: orders));
//     } catch (e) {
//       emit(OrderFailed(error: e.toString()));
//     }
//   }

//   Future<void> _onUpdateOrderStatus(
//       UpdateOrderStatus event, Emitter<OrderState> emit) async {
//     try {
//       await _firestore
//           .collection('orders')
//           .doc(event.orderId)
//           .update({'status': event.newStatus});
//     } catch (e) {
//       emit(OrderFailed(error: e.toString()));
//     }
//   }

//   @override
//   Future<void> close() {
//     _razorpay.clear();
//     return super.close();
//   }
// }

//************************************************************* */

//9999999****************************
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Razorpay _razorpay = Razorpay();

  OrderBloc() : super(OrderInitial()) {
    //on<PlaceOrder>(_onPlaceOrder);
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);

    // Setup Razorpay Listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String firestoreOrderId = _firestore.collection('orders').doc().id;
    add(PlaceOrder(
      amount: _currentOrderAmount,
      orderId: firestoreOrderId,
      paymentId: response.paymentId ?? '',
      items: _currentOrderItems,
      address: _currentOrderAddress,
      userEmail: _currentUserEmail,
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    emit(OrderFailed(error: 'Payment Failed: ${response.message}'));
  }

  // Variables to store current order details
  double _currentOrderAmount = 0.0;
  List<CartItem> _currentOrderItems = [];
  String _currentOrderAddress = '';
  String _currentUserEmail = '';

//   Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
//     emit(OrderLoading());
//     try {
//       String userId = _auth.currentUser?.uid ?? '';

//       if (userId.isEmpty) {
//         emit(OrderFailed(error: "User not logged in."));
//         return;
//       }

// //Fetch customer name
//       final userDoc = await _firestore.collection('users').doc(userId).get();
//       String customerName =
//           userDoc.exists ? (userDoc.data()?['name'] ?? 'User') : 'User';

//       String orderId = _firestore.collection('orders').doc().id;
//       OrderModel newOrder = OrderModel(
//         id: orderId,
//         paymentId: event.paymentId,
//         items: event.items,
//         totalAmount: event.amount,
//         userId: userId,
//         customerName: customerName,
//         status: 'pending',
//         address: event.address,
//         createdAt: Timestamp.now(),
//       );

//       await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

//       emit(OrderPlaced(
//           orderId: orderId, status: "Pending", paymentId: event.paymentId));
//     } catch (e) {
//       emit(OrderFailed(error: e.toString()));
//     }
//   }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      String userId = _auth.currentUser?.uid ?? '';

      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      List<OrderModel> orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatus event, Emitter<OrderState> emit) async {
    try {
      await _firestore
          .collection('orders')
          .doc(event.orderId)
          .update({'status': event.newStatus});
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
