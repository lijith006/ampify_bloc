import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;

  // Razorpay
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String paymentStatus; // PENDING / PAID / FAILED
  final bool verified;

  // Order
  final String status; // processing / shipped / delivered
  final String address;
  final String customerName;
  final String userEmail;
  final String userId;

  final double totalAmount;
  final DateTime createdAt;
  final List<CartItem> items;

  OrderModel({
    required this.id,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.paymentStatus,
    required this.verified,
    required this.status,
    required this.address,
    required this.customerName,
    required this.userEmail,
    required this.userId,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  // ---------- Firestore to Model ----------
  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      razorpayOrderId: map['razorpayOrderId'] ?? '',
      razorpayPaymentId: map['razorpayPaymentId'] ?? '',
      paymentStatus: map['paymentStatus'] ?? 'PENDING',
      verified: map['verified'] ?? false,
      status: map['status'] ?? 'processing',
      address: map['address'] ?? '',
      customerName: map['customerName'] ?? 'User',
      userEmail: map['userEmail'] ?? '',
      userId: map['userId'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromMap(e))
          .toList(),
    );
  }

  // ---------- Model to Firestore ----------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'paymentStatus': paymentStatus,
      'verified': verified,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'userId': userId,
      'userEmail': userEmail,
      'customerName': customerName,
      'status': status,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ---------- DELIVERY PROGRESS ----------
  double get progress {
    final s = status.toLowerCase().trim();

    switch (s) {
      case 'processing':
        return 0.2;
      case 'shipped':
        return 0.5;
      case 'out for delivery':
        return 0.8;
      case 'delivered':
        return 1.0;
      default:
        return 0.0;
    }
  }

  bool get isPaid => paymentStatus == 'PAID' && verified;
}
