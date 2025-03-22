// // //9000000000000000000000000000000000000000000000000000000000
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderModel {
//   final String id;
//   final String paymentId;
//   final List<CartItem> items;
//   final double totalAmount;
//   final String userId;
//   final String customerName;
//   final String status;
//   final String address;
//   final Timestamp createdAt;

//   OrderModel({
//     required this.id,
//     required this.paymentId,
//     required this.items,
//     required this.totalAmount,
//     required this.userId,
//     required this.customerName,
//     required this.status,
//     required this.address,
//     required this.createdAt,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'paymentId': paymentId,
//       'items': items.map((item) => item.toMap()).toList(),
//       'totalAmount': totalAmount,
//       'userId': userId,
//       'customerName': customerName,
//       'status': status,
//       'address': address,
//       'createdAt': createdAt,
//     };
//   }

//   factory OrderModel.fromMap(Map<String, dynamic> map) {
//     return OrderModel(
//       id: map['id'],
//       paymentId: map['paymentId'] ?? '',
//       items:
//           (map['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
//       totalAmount: map['totalAmount'],
//       userId: map['userId'],
//       customerName: map['customerName'],
//       status: map['status'],
//       address: map['address'],
//       createdAt: map['createdAt'],
//     );
//   }
//   // Progress Calculation
//   double get progress {
//     switch (status.toLowerCase()) {
//       case 'processing':
//         return 0.2;
//       case 'shipped':
//         return 0.5;
//       case 'out for delivery':
//         return 0.8;
//       case 'delivered':
//         return 1.0;
//       default:
//         return 0.0;
//     }
//   }
// }
//-------------------------------------------------------
// //9000000000000000000000000000000000000000000000000000000000
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String paymentId;
  final List<CartItem> items;
  final double totalAmount;
  final String userId;
  final String customerName;
  final String status;
  final String address;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.paymentId,
    required this.items,
    required this.totalAmount,
    required this.userId,
    required this.customerName,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentId': paymentId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'userId': userId,
      'customerName': customerName,
      'status': status,
      'address': address,
      'createdAt': createdAt,
    };
  }

  // Modified factory constructor to accept two arguments
  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id, // Pass the ID separately
      paymentId: map['paymentId'] ?? '',
      items:
          (map['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
      totalAmount: map['totalAmount'],
      userId: map['userId'],
      customerName: map['customerName'],
      status: map['status'],
      address: map['address'],
      createdAt: map['createdAt'],
    );
  }

  // Progress Calculation
  double get progress {
    switch (status.toLowerCase()) {
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
}
