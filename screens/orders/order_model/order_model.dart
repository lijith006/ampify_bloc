import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String userId;
  final String status;
  final String address;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.userId,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'userId': userId,
      'status': status,
      'address': address,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      items:
          (map['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
      totalAmount: map['totalAmount'],
      userId: map['userId'],
      status: map['status'],
      address: map['address'],
      createdAt: map['createdAt'],
    );
  }
}
