// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/order_tracking_screen/order_timeline.dart';
// import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
// import 'package:ampify_bloc/widgets/custom_app_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class OrderTrackingScreen extends StatefulWidget {
//   final OrderModel order;

//   const OrderTrackingScreen({super.key, required this.order});

//   @override
//   State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
// }

// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStream;
//   @override
//   void initState() {
//     super.initState();
//     // Listen for real-time updates to the order document
//     _orderStream = FirebaseFirestore.instance
//         .collection('orders')
//         .doc(widget.order.id)
//         .snapshots();
//   }

//   // Format the createdAt timestamp
//   String formatDate(Timestamp timestamp) {
//     final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
//     return dateFormat.format(timestamp.toDate());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const CustomAppBar(title: 'Track my Orders'),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: StreamBuilder<DocumentSnapshot>(
//             stream: _orderStream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return const Center(child: Text('Order not found'));
//               }

//               final orderData = snapshot.data!.data() as Map<String, dynamic>;
//               final updatedOrder =
//                   OrderModel.fromMap(widget.order.id, orderData);

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Order Details
//                   Card(
//                     color: AppColors.backgroundColor,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       //O r d e r   ID
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Order #${updatedOrder.id}",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           //Date
//                           Text(
//                             "Ordered on: ${formatDate(updatedOrder.createdAt)}",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Total: \₹${updatedOrder.totalAmount}",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           //A d d r e s s
//                           Text(
//                             "Delivery Address: ${updatedOrder.address}",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // P r o g r e s s   I n d i c a t o r

//                   TweenAnimationBuilder<double>(
//                     tween: Tween<double>(begin: 0, end: updatedOrder.progress),
//                     duration: const Duration(seconds: 1),
//                     builder: (context, value, _) {
//                       return LinearProgressIndicator(
//                         value: value,
//                         backgroundColor: Colors.grey[300],
//                         color: Colors.black54,
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   // Order Status Timeline
//                   const Text(
//                     "Order Status ",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   OrderTimeline(
//                     status: "Pending",
//                     isFirst: true,
//                     isActive: updatedOrder.status == "Pending",
//                     icon: Icons.shopping_cart,
//                     description: "Your order has been placed.",
//                     animationPath: 'assets/animations/order_placed.json',
//                   ),
//                   OrderTimeline(
//                     status: "Processing",
//                     isActive: updatedOrder.status == "Processing",
//                     icon: Icons.build,
//                     description: "Your order is being processed.",
//                     animationPath: 'assets/animations/order_processing.json',
//                   ),
//                   OrderTimeline(
//                     status: "Shipped",
//                     isActive: updatedOrder.status == "Shipped",
//                     icon: Icons.local_shipping,
//                     description: "Your order has been shipped.",
//                     animationPath: 'assets/animations/order_shipped.json',
//                   ),
//                   OrderTimeline(
//                     status: "Out for Delivery",
//                     isActive: updatedOrder.status == "Delivered",
//                     icon: Icons.check_circle,
//                     description: "Your order has been delivered.",
//                     animationPath: 'assets/animations/order_delivered.json',
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//----------------------------------------APR 7

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/order_timeline.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/widgets/ordered_products_list.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Stream<DocumentSnapshot> _orderStream;
  @override
  void initState() {
    super.initState();
    // Listen for real-time updates to the order document
    _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.order.id)
        .snapshots();
  }

  // Format the createdAt timestamp
  String formatDate(Timestamp timestamp) {
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    return dateFormat.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Track my Orders'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _orderStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Order not found'));
              }

              final orderData = snapshot.data!.data() as Map<String, dynamic>;
              final updatedOrder =
                  OrderModel.fromMap(widget.order.id, orderData);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Details
                  Card(
                    color: AppColors.backgroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      //O r d e r   ID
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order #${updatedOrder.id}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          //Date
                          Text(
                            "Ordered on: ${formatDate(updatedOrder.createdAt)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total: \₹${updatedOrder.totalAmount}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          //A d d r e s s
                          Text(
                            "Delivery Address: ${updatedOrder.address}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Divider(height: 1, thickness: 1),
                          SizedBox(
                            height: 20,
                          ),

                          //L i s t   o f   P r o d u c t s
                          OrderItemsList(items: updatedOrder.items),
                        ],
                      ),
                    ),
                  ),
                  //  const SizedBox(height: 20),
                  // P r o g r e s s   I n d i c a t o r

                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: updatedOrder.progress),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[300],
                        color: Colors.black54,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Order Status Timeline
                  const Text(
                    "Order Status ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OrderTimeline(
                    status: "Pending",
                    isFirst: true,
                    isActive: updatedOrder.status == "Pending",
                    icon: Icons.shopping_cart,
                    description: "Your order has been placed.",
                    animationPath: 'assets/animations/order_placed.json',
                  ),
                  OrderTimeline(
                    status: "Processing",
                    isActive: updatedOrder.status == "Processing",
                    icon: Icons.build,
                    description: "Your order is being processed.",
                    animationPath: 'assets/animations/order_processing.json',
                  ),
                  OrderTimeline(
                    status: "Shipped",
                    isActive: updatedOrder.status == "Shipped",
                    icon: Icons.local_shipping,
                    description: "Your order has been shipped.",
                    animationPath: 'assets/animations/order_shipped.json',
                  ),
                  OrderTimeline(
                    status: "Out for Delivery",
                    isActive: updatedOrder.status == "Delivered",
                    icon: Icons.check_circle,
                    description: "Your order has been delivered.",
                    animationPath: 'assets/animations/order_delivered.json',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
