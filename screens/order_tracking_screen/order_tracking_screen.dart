// import 'package:flutter/material.dart';

// class OrderTrackingScreen extends StatelessWidget {
//   final String orderId;

//   const OrderTrackingScreen({super.key, required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     // Mock order status (can be fetched from an API)
//     final List<String> statusList = [
//       "Order Placed",
//       "Processing",
//       "Shipped",
//       "Out for Delivery",
//       "Delivered"
//     ];
//     final int currentStatus = 3; // Change this dynamically

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Track Order"),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order ID: $orderId",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text("Estimated Delivery: Today, 2:30 PM"),
//             const SizedBox(height: 20),

//             // Progress Indicator
//             Column(
//               children: List.generate(statusList.length, (index) {
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Status Icon
//                     Icon(
//                       index <= currentStatus
//                           ? Icons.check_circle
//                           : Icons.radio_button_unchecked,
//                       color:
//                           index <= currentStatus ? Colors.green : Colors.grey,
//                     ),
//                     const SizedBox(width: 10),

//                     // Status Text
//                     Text(
//                       statusList[index],
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: index <= currentStatus
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                         color:
//                             index <= currentStatus ? Colors.black : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//************************************************* */
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking")),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderUpdated || state is OrderPlaced) {
            String status = (state is OrderPlaced)
                ? state.status
                : (state as OrderUpdated).status;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Order ID: $orderId",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                _buildTrackingStatus(status),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTrackingStatus(String status) {
    List<String> statuses = [
      "Pending",
      "Processing",
      "Shipped",
      "Out for Delivery",
      "Delivered"
    ];
    return Column(
      children: statuses.map((s) {
        bool isActive = statuses.indexOf(s) <= statuses.indexOf(status);
        return ListTile(
          leading: Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isActive ? Colors.green : Colors.grey,
          ),
          title: Text(s,
              style: TextStyle(
                  fontSize: 16, color: isActive ? Colors.black : Colors.grey)),
        );
      }).toList(),
    );
  }
}
