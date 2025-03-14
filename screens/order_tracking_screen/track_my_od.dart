import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/order_timeline.dart';
import 'package:ampify_bloc/screens/orders/order_model/order_model.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Track my Orders'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Text(
                      "Total: \₹${order.totalAmount}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
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
              isActive: order.status == "Pending",
            ),
            OrderTimeline(
              status: "Processing",
              isActive: order.status == "Processing",
            ),
            OrderTimeline(
              status: "Shipped",
              isActive: order.status == "Shipped",
            ),
            OrderTimeline(
              status: "Out for Delivery",
              isActive: order.status == "Delivered",
            ),
          ],
        ),
      ),
    );
  }
}
