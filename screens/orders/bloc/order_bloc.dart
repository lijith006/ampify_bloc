// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   OrderBloc() : super(OrderInitial()) {
//     on<PlaceOrder>(_onPlaceOrder);
//     on<FetchOrders>(_onFetchOrders);
//     on<UpdateOrderStatus>(_onUpdateOrderStatus);
//   }

//   Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
//     emit(OrderLoading());
//     try {
//       String userId = _auth.currentUser?.uid ?? '';

//       if (userId.isEmpty) {
//         emit(OrderFailed(error: "User not logged in."));
//         return;
//       }

//       String orderId = _firestore.collection('orders').doc().id;
//       OrderModel newOrder = OrderModel(
//         id: orderId,
//         items: event.items,
//         totalAmount: event.amount,
//         userId: userId,
//         status: 'pending',
//         address: event.address,
//         createdAt: Timestamp.now(),
//       );

//       await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

//       emit(OrderPlaced(orderId: orderId));
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

//       // Fixed: Using OrderModel instead of Order
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
// }
//******************************** */

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
    on<PlaceOrder>(_onPlaceOrder);
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<InitiatePayment>(_onInitiatePayment);

    // Setup Razorpay Listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    add(PlaceOrder(
      amount: _currentOrderAmount,
      orderId: response.paymentId ?? '',
      items: _currentOrderItems,
      address: _currentOrderAddress,
      userEmail: _currentUserEmail,
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    emit(OrderFailed(error: 'Payment Failed: ${response.message}'));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print('External Wallet: ${response.walletName}');
  }

  // Variables to store current order details
  double _currentOrderAmount = 0.0;
  List<CartItem> _currentOrderItems = [];
  String _currentOrderAddress = '';
  String _currentUserEmail = '';

  Future<void> _onInitiatePayment(
      InitiatePayment event, Emitter<OrderState> emit) async {
    // Store current order details
    _currentOrderAmount = event.amount;
    _currentOrderItems = event.items;
    _currentOrderAddress = event.address;
    _currentUserEmail = event.userEmail;

    // Prepare Razorpay options
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': (event.amount * 100).toInt(),
      'name': 'Your App Name',
      'description': 'Order Payment',
      'prefill': {'email': event.userEmail}
    };

    try {
      _razorpay.open(options);
      emit(PaymentInitiated());
    } catch (e) {
      emit(OrderFailed(error: 'Payment Initiation Failed: $e'));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      String userId = _auth.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        emit(OrderFailed(error: "User not logged in."));
        return;
      }

      String orderId = _firestore.collection('orders').doc().id;
      OrderModel newOrder = OrderModel(
        id: orderId,
        items: event.items,
        totalAmount: event.amount,
        userId: userId,
        status: 'pending',
        address: event.address,
        createdAt: Timestamp.now(),
      );

      await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

      emit(OrderPlaced(orderId: event.orderId, status: "Pending"));
      _simulateOrderTracking(orderId);
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }

  void _simulateOrderTracking(String orderId) {
    Future.delayed(const Duration(seconds: 5), () {
      add(UpdateOrderStatus(orderId: orderId, newStatus: "Processing"));
    });
    Future.delayed(const Duration(seconds: 10), () {
      add(UpdateOrderStatus(orderId: orderId, newStatus: "Shipped"));
    });
    Future.delayed(const Duration(seconds: 15), () {
      add(UpdateOrderStatus(orderId: orderId, newStatus: "Out for Delivery"));
    });
    Future.delayed(const Duration(seconds: 20), () {
      add(UpdateOrderStatus(orderId: orderId, newStatus: "Delivered"));
    });
  }

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
