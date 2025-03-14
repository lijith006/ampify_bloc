// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/order_tracking_screen/order_timeline.dart';
// import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
// import 'package:ampify_bloc/widgets/custom_app_bar.dart';
// import 'package:flutter/material.dart';

// class OrderTrackingScreen extends StatelessWidget {
//   final OrderModel order;

//   const OrderTrackingScreen({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const CustomAppBar(title: 'Track my Orders'),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Details
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Order #${order.id}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Total: \₹${order.totalAmount}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Order Status Timeline
//             const Text(
//               "Order Status ",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             OrderTimeline(
//               status: "Pending",
//               isFirst: true,
//               isActive: order.status == "Pending",
//             ),
//             OrderTimeline(
//               status: "Processing",
//               isActive: order.status == "Processing",
//             ),
//             OrderTimeline(
//               status: "Shipped",
//               isActive: order.status == "Shipped",
//             ),
//             OrderTimeline(
//               status: "Out for Delivery",
//               isActive: order.status == "Delivered",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//********************************************MARCH 14 */
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/order_timeline.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});
  // Format the createdAt timestamp
  String formatDate(Timestamp timestamp) {
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a'); //
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Details
              Card(
                elevation: 2,
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
                        "Order #${order.id}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //Date
                      Text(
                        "Ordered on: ${formatDate(order.createdAt)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total: \₹${order.totalAmount}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //A d d r e s s
                      Text(
                        "Delivery Address: ${order.address}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // P r o g r e s s   I n d i c a t o r

              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: order.progress),
                duration: const Duration(seconds: 1),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[300],
                    color: Colors.black54,
                  );
                },
              ),
              // LinearProgressIndicator(
              //   value: order.progress,
              //   backgroundColor: Colors.grey[300],
              //   color: Colors.black54,
              // ),
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
                isActive: order.status == "pending",
                icon: Icons.shopping_cart,
                description: "Your order has been placed.",
                animationPath: 'assets/animations/order_placed.json',
              ),
              OrderTimeline(
                status: "Processing",
                isActive: order.status == "Processing",
                icon: Icons.build,
                description: "Your order is being processed.",
                animationPath: 'assets/animations/order_processing.json',
              ),
              OrderTimeline(
                status: "Shipped",
                isActive: order.status == "Shipped",
                icon: Icons.local_shipping,
                description: "Your order has been shipped.",
                animationPath: 'assets/animations/order_shipped.json',
              ),
              OrderTimeline(
                status: "Out for Delivery",
                isActive: order.status == "Delivered",
                icon: Icons.check_circle,
                description: "Your order has been delivered.",
                animationPath: 'assets/animations/order_delivered.json',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
