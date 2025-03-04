// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/widgets/custom_orange_button.dart';
// import 'package:flutter/material.dart';

// class OrderConfirmationScreen extends StatelessWidget {
//   final String orderId;
//   final String address;
//   final double amount;

//   const OrderConfirmationScreen({
//     super.key,
//     required this.orderId,
//     required this.address,
//     required this.amount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Order Confirmation"),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 100),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   margin: EdgeInsets.all(8.0),
//                   color: Colors.green,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Your order has been placed successfully!",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(height: 10),
//                       Text("Order ID: $orderId",
//                           style: const TextStyle(fontSize: 16)),
//                       Text("Delivering to: $address",
//                           style: const TextStyle(fontSize: 16)),
//                       Text("Total Amount: ₹$amount",
//                           style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: CustomOrangeButton(
//                     width: 120, text: 'Track Order', onPressed: () {}),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//**************************************************************** */
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/order_tracking_screen.dart';
import 'package:ampify_bloc/widgets/custom_orange_button.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final String address;
  final double amount;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.address,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Your order has been placed successfully!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildOrderDetailRow("Order ID:", orderId),
                    _buildOrderDetailRow("Delivering to:", address),
                    _buildOrderDetailRow("Total Amount:", "₹$amount"),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomOrangeButton(
                width: 180,
                text: 'Track Order',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderTrackingScreen(orderId: orderId),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
