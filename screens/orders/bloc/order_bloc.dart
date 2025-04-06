import 'dart:async';

import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Razorpay _razorpay = Razorpay();

  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  OrderBloc({required FirebaseFirestore firestore})
      : _firestore = firestore,
        super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<PlaceOrder>(_onPlaceOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<UpdateOrdersFromSnapshot>(_onUpdateOrdersFromSnapshot);
    on<OrderSubscriptionError>(_onOrderSubscriptionError);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      String userId = _auth.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        emit(OrderFailed(error: "User not logged in."));
        return;
      }

//Fetch customer name
      final userDoc = await _firestore.collection('users').doc(userId).get();
      String customerName =
          userDoc.exists ? (userDoc.data()?['name'] ?? 'User') : 'User';

      String orderId = event.orderId.isNotEmpty
          ? event.orderId
          : _firestore.collection('orders').doc().id;
      OrderModel newOrder = OrderModel(
        id: orderId,
        paymentId: event.paymentId,
        items: event.items,
        totalAmount: event.amount,
        userId: userId,
        customerName: customerName,
        status: 'pending',
        address: event.address,
        createdAt: Timestamp.now(),
      );
      print('Order Details- plc ordr:   ${newOrder.toMap()}');
      await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

      emit(OrderPlaced(
          orderId: orderId, status: "Pending", paymentId: event.paymentId));
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    print("Fetching orders - started");

    // Cancel existing subscription if any
    await _ordersSubscription?.cancel();

    // First, fetch the initial data synchronously
    try {
      final QuerySnapshot initialSnapshot = await _firestore
          .collection('orders')
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

    _ordersSubscription = _firestore
        .collection('orders')
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
