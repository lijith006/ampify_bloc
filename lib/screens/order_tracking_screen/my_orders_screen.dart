import 'dart:convert';

import 'package:ampify_bloc/common/order_utils.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/track_my_order_screen.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  // Format the createdAt timestamp
  String formatDate(DateTime dateTime) {
    final dateFormat = DateFormat('MMM dd, yyyy    hh:mm a');
    return dateFormat.format(dateTime);
  }

// Helper for the Status Pill
  Widget _buildStatusChip(String status) {
    Color color = OrderUtils.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("AllOrdersScreen initialized");
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    print("AllOrdersScreen building");
    return Scaffold(
      // backgroundColor: AppColors.backgroundColor,
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(title: 'My Orders'),
      //BLOC Builder --
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          print("BlocBuilder rebuilding with state: ${state.runtimeType}");
          if (state is OrderLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loading.json',
                width: 250,
              ),
            );
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/noOrders.json',
                        height: 150),
                    const SizedBox(height: 20),
                    const Text(
                      "No orders found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                final totalAmount = order.items.fold<double>(
                    0.0, (sum, item) => sum + (item.price * item.quantity));
                final totalProductCount =
                    order.items.fold(0, (count, item) => count + item.quantity);
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderTrackingScreen(order: order)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order ID and Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Order #${order.id.toString().substring(0, 8)}",
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text(formatDate(order.createdAt),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ],
                                ),
                                _buildStatusChip(order.status),
                              ],
                            ),
                            const Divider(height: 30, thickness: 0.8),

                            // Product Images and Info
                            Row(
                              children: [
                                //  image stack

                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: order
                                            .items.first.imageUrls.isNotEmpty
                                        ? Image.memory(
                                            // Decode
                                            base64Decode(order
                                                .items.first.imageUrls.first),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey);
                                            },
                                          )
                                        : const Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.grey),
                                  ),
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${order.items.first.title} ${totalProductCount > 1 ? '+ ${totalProductCount - 1} more' : ''}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      Text("Total: ₹$totalAmount",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blueAccent)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 14, color: Colors.grey),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Footer: Progress Bar
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery Progress",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text("${(order.progress * 100).toInt()}%",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                        begin: 0, end: order.progress),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        minHeight: 6,
                                        backgroundColor: Colors.grey[200],
                                        color: OrderUtils.getStatusColor(
                                            order.status),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is OrderFailed) {
            return Center(
                child: Text("Error: ${state.error}",
                    style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text("No orders found"));
        },
      ),
    );
  }
}
