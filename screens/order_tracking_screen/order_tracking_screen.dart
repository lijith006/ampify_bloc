// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OrderTrackingScreen extends StatelessWidget {
//   final String orderId;
//   const OrderTrackingScreen({super.key, required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Tracking")),
//       body: BlocBuilder<OrderBloc, OrderState>(
//         builder: (context, state) {
//           if (state is OrderUpdated || state is OrderPlaced) {
//             String status = (state is OrderPlaced)
//                 ? state.status
//                 : (state as OrderUpdated).status;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     "Order ID: $orderId",
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const Divider(),
//                 _buildTrackingStatus(status),
//               ],
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   Widget _buildTrackingStatus(String status) {
//     List<String> statuses = ["Pending", "Processing", "Shipped", "Delivered"];

//     return Column(
//       children: statuses.map((s) {
//         bool isActive = statuses.indexOf(s) <= statuses.indexOf(status);
//         return ListTile(
//           leading: Icon(
//             isActive ? Icons.check_circle : Icons.radio_button_unchecked,
//             color: isActive ? Colors.green : Colors.grey,
//           ),
//           title: Text(s,
//               style: TextStyle(
//                   fontSize: 16, color: isActive ? Colors.black : Colors.grey)),
//         );
//       }).toList(),
//     );
//   }
// }

//from clud//***************************** */
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          if (state is OrdersLoaded) {
            // Find the specific order by orderId
            final order = state.orders.firstWhere(
              (order) => order.id == orderId,
              orElse: () => OrderModel(
                id: '',
                paymentId: '',
                items: [],
                totalAmount: 0.0,
                userId: '',
                customerName: '',
                status: 'Pending',
                address: '',
                createdAt: Timestamp.now(),
              ),
            );

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
                _buildTrackingStatus(order.status),
              ],
            );
          } else if (state is OrderFailed) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("No orders found"));
        },
      ),
    );
  }

  Widget _buildTrackingStatus(String status) {
    List<String> statuses = ["Pending", "Processing", "Shipped", "Delivered"];

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
