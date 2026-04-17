import 'dart:async';

import 'package:ampify_bloc/repositories/payment_repository.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  List<Map<String, dynamic>> _pendingItems = [];
  double _pendingAmount = 0;
  String _pendingAddress = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Razorpay _razorpay = Razorpay();

  final FirebaseFirestore _firestore;
  final PaymentRepository paymentRepository;

  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  OrderBloc({
    required FirebaseFirestore firestore,
    required this.paymentRepository,
  })  : _firestore = firestore,
        super(OrderInitial()) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      add(PaymentSucceeded(response));
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      add(PaymentFailed(response.message ?? "Payment failed"));
    });

    on<FetchOrders>(_onFetchOrders);
    on<PlaceOrder>(_onPlaceOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<UpdateOrdersFromSnapshot>(_onUpdateOrdersFromSnapshot);
    on<OrderSubscriptionError>(_onOrderSubscriptionError);
    on<PaymentSucceeded>(_handlePaymentSuccess);
    on<PaymentFailed>(_handlePaymentFailed);
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(PaymentInProgress());

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not logged in');

      _pendingItems = event.items.map((e) => e.toMap()).toList();
      _pendingAmount = event.amount;
      _pendingAddress = event.address;

      final customerName = event.customerName;

      print("STEP 1 - Creating Razorpay order");
      final razorpayOrderId = await paymentRepository.createOrder(event.amount);
      print("STEP 2 - Razorpay order created: $razorpayOrderId");

      _razorpay.open({
        'key': 'rzp_test_FRLD6BPBYxystN',
        'amount': (event.amount * 100).toInt(),
        'order_id': razorpayOrderId,
        'name': 'Ampify',
        'prefill': {
          'email': user.email,
          'name': customerName,
        },
      });
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _handlePaymentSuccess(
    PaymentSucceeded event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final response = event.response;

      final verified = await paymentRepository.verifyPayment(
        orderId: response.orderId!,
        paymentId: response.paymentId!,
        signature: response.signature!,
      );

      if (!verified) {
        emit(PaymentFailure(error: 'Payment verification failed'));
        return;
      }
      final user = _auth.currentUser!;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      final docRef = _firestore.collection('orders').doc();

      await docRef.set({
        'id': docRef.id,
        'razorpayOrderId': response.orderId,
        'razorpayPaymentId': response.paymentId,
        'paymentStatus': 'PAID',
        'verified': true,
        'address': _pendingAddress,
        'items': _pendingItems,
        'totalAmount': _pendingAmount,
        'userId': user.uid,
        'userEmail': user.email,
        // 'customerName': userDoc['name'],
        'customerName': userDoc.data()?['name'] ?? 'User',
        'status': 'confirmed',
        'progress': 20,
        'createdAt': FieldValue.serverTimestamp(),
      });
      //_preparedRazorpayOrderId = null;

      emit(PaymentSuccess(
        orderId: docRef.id,
        paymentId: response.paymentId!,
      ));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  void _handlePaymentFailed(
    PaymentFailed event,
    Emitter<OrderState> emit,
  ) {
    // reset prepared order
    // _preparedRazorpayOrderId = null;
    emit(PaymentFailure(error: event.error));
  }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    print("Fetching orders - started");

    // Cancel existing subscription if any
    await _ordersSubscription?.cancel();

    //Fetch
    try {
      String userId = _auth.currentUser!.uid;

      final QuerySnapshot initialSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      print("Initial fetch: ${initialSnapshot.docs.length} documents");

      final initialOrders = initialSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(doc.id, data);
      }).toList();

      emit(OrdersLoaded(orders: initialOrders));
    } catch (e) {
      print("Error in initial fetch: $e");
      emit(OrderFailed(error: e.toString()));
      return;
    }
    String userId = _auth.currentUser!.uid;

    _ordersSubscription = _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          print(
              "Real-time update received, dispatching UpdateOrdersFromSnapshot event");
          add(UpdateOrdersFromSnapshot(snapshot: snapshot));
        }
      },
      onError: (error) {
        print("Error in subscription: $error");
        add(OrderSubscriptionError(error: error.toString()));
      },
    );
  }

  void _onUpdateOrdersFromSnapshot(
      UpdateOrdersFromSnapshot event, Emitter<OrderState> emit) {
    try {
      print(
          "Processing snapshot update: ${event.snapshot.docs.length} documents");

      for (var change in event.snapshot.docChanges) {
        print("Doc change type: ${change.type} for document: ${change.doc.id}");
        final data = change.doc.data() as Map<String, dynamic>;
        if (data.containsKey('status')) {
          print("Updated status: ${data['status']}");
        }
      }

      final orders = event.snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(doc.id, data);
      }).toList();

      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      print("Error processing snapshot: $e");
      emit(OrderFailed(error: e.toString()));
    }
  }

  void _onOrderSubscriptionError(
      OrderSubscriptionError event, Emitter<OrderState> emit) {
    emit(OrderFailed(error: event.error));
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
    _ordersSubscription?.cancel();
    return super.close();
  }
}
