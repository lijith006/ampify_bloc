// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/common/image_to_base.dart';
// import 'package:ampify_bloc/common/order_utils.dart';
// import 'package:ampify_bloc/screens/order_tracking_screen/track_my_order_screen.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/widgets/custom_app_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';

// class AllOrdersScreen extends StatefulWidget {
//   const AllOrdersScreen({super.key});

//   @override
//   State<AllOrdersScreen> createState() => _AllOrdersScreenState();
// }

// class _AllOrdersScreenState extends State<AllOrdersScreen> {
//   // Format the createdAt timestamp
//   String formatDate(Timestamp timestamp) {
//     final dateFormat = DateFormat('MMM dd, yyyy    hh:mm a');
//     return dateFormat.format(timestamp.toDate());
//   }

//   @override
//   void initState() {
//     super.initState();
//     print("AllOrdersScreen initialized");
//     context.read<OrderBloc>().add(FetchOrders());
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("AllOrdersScreen building");
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const CustomAppBar(title: 'My Orders'),
//       //BLOC Builder --
//       body: BlocBuilder<OrderBloc, OrderState>(
//         builder: (context, state) {
//           print("BlocBuilder rebuilding with state: ${state.runtimeType}");
//           if (state is OrderLoading) {
//             return Center(
//               child: Lottie.asset(
//                 'assets/animations/loading.json',
//                 width: 250,
//               ),
//             );
//           } else if (state is OrdersLoaded) {
//             if (state.orders.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset('assets/animations/noOrders.json',
//                         height: 150),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "No orders found",
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: state.orders.length,
//               itemBuilder: (context, index) {
//                 final order = state.orders[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               OrderTrackingScreen(order: order),
//                         ));
//                   },
//                   child: Card(
//                     color: AppColors.backgroundColor,
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     elevation: 1,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Order ID and Date
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Order #${order.id}",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "Ordered on: ${formatDate(order.createdAt)}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Divider(height: 1, thickness: 1),

//                         // List of Products in the Order
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: order.items.length,
//                           itemBuilder: (context, productIndex) {
//                             final product = order.items[productIndex];
//                             return Column(
//                               children: [
//                                 ListTile(
//                                   leading: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: ImageUtils.base64ToImage(
//                                         product.imageUrls[0]),
//                                   ),
//                                   title: Text(
//                                     product.title,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     "Quantity: ${product.quantity}",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   trailing: Text(
//                                     // "\₹${product.price}",

//                                     "\₹${product.price * product.quantity}",
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 if (productIndex < order.items.length - 1)
//                                   const Divider(height: 1, thickness: 1),
//                               ],
//                             );
//                           },
//                         ),

//                         // Order Status and Progress
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: OrderUtils.getStatusColor(order.status)
//                                       .withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   order.status,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color:
//                                         OrderUtils.getStatusColor(order.status),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               TweenAnimationBuilder<double>(
//                                 tween: Tween<double>(
//                                     begin: 0, end: order.progress),
//                                 duration: const Duration(seconds: 1),
//                                 builder: (context, value, _) {
//                                   return LinearProgressIndicator(
//                                     value: value,
//                                     backgroundColor: Colors.grey[300],
//                                     color: Colors.black54,
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is OrderFailed) {
//             return Center(
//               child: Text(
//                 "Error: ${state.error}",
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }
//           return const Center(child: Text("No orders found"));
//         },
//       ),
//     );
//   }
// }
//--------------------------------------------APR 7----

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/common/order_utils.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/track_my_order_screen.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String formatDate(Timestamp timestamp) {
    final dateFormat = DateFormat('MMM dd, yyyy    hh:mm a');
    return dateFormat.format(timestamp.toDate());
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
      backgroundColor: AppColors.backgroundColor,
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
              padding: const EdgeInsets.all(8),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];

                final totalAmount = order.items.fold<double>(
                    0.0, (sum, item) => sum + (item.price * item.quantity));

                final totalProductCount =
                    order.items.fold(0, (count, item) => count + item.quantity);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderTrackingScreen(order: order),
                        ));
                  },
                  child: Card(
                    color: AppColors.backgroundColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID and Date
                        Padding(
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
                              const SizedBox(height: 4),
                              Text(
                                "Ordered on: ${formatDate(order.createdAt)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///  T o t a l   i t e m s   c o u n t   &   a m o u n t
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Items: $totalProductCount",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Total: ₹$totalAmount",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // const Divider(height: 1, thickness: 1),

                        // List of Products in the Order
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: order.items.length,
                        //   itemBuilder: (context, productIndex) {
                        //     final product = order.items[productIndex];
                        //     return Column(
                        //       children: [
                        //         ListTile(
                        //           leading: ClipRRect(
                        //             borderRadius: BorderRadius.circular(8),
                        //             child: ImageUtils.base64ToImage(
                        //                 product.imageUrls[0]),
                        //           ),
                        //           title: Text(
                        //             product.title,
                        //             style: const TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           subtitle: Text(
                        //             "Quantity: ${product.quantity}",
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               color: Colors.grey,
                        //             ),
                        //           ),
                        //           trailing: Text(
                        //             // "\₹${product.price}",

                        //             "\₹${product.price * product.quantity}",
                        //             style: const TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //         if (productIndex < order.items.length - 1)
                        //           const Divider(height: 1, thickness: 1),
                        //       ],
                        //     );
                        //   },
                        // ),
// OrderItemsList(items: order.items),

                        // Order Status and Progress
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: OrderUtils.getStatusColor(order.status)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        OrderUtils.getStatusColor(order.status),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0, end: order.progress),
                                duration: const Duration(seconds: 1),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.black54,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is OrderFailed) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          return const Center(child: Text("No orders found"));
        },
      ),
    );
  }
}
