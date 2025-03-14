// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/common/image_to_base.dart';
// import 'package:ampify_bloc/screens/order_tracking_screen/track_my_od.dart';
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
//     //final dateFormat = DateFormat('yyyy-MM-dd');
//     final dateFormat = DateFormat('yyyy-MM-dd    hh:mm a');
//     return dateFormat.format(timestamp.toDate());
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<OrderBloc>().add(FetchOrders());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const CustomAppBar(title: 'My Orders'),
//       body: BlocBuilder<OrderBloc, OrderState>(
//         builder: (context, state) {
//           if (state is OrderLoading) {
//             return Center(
//               child: Lottie.asset(
//                 'assets/animations/orderLoading.json',
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
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     elevation: 2,
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
//                                     child: ImageUtils.base64ToImage(product
//                                         .imageUrls[0]), // Display Base64 image
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
//                                     "\₹${product.price}",
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
//                               Text(
//                                 "Status: ${order.status}",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               LinearProgressIndicator(
//                                 value: order.progress,
//                                 backgroundColor: Colors.grey[300],
//                                 color: Colors.blueAccent,
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
//***************************************************MARCH 14/**** */
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/common/image_to_base.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/track_my_od.dart';
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
    //final dateFormat = DateFormat('yyyy-MM-dd');
    final dateFormat = DateFormat('yyyy-MM-dd    hh:mm a');
    return dateFormat.format(timestamp.toDate());
  }

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'My Orders'),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/orderLoading.json',
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 2,
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
                        const Divider(height: 1, thickness: 1),

                        // List of Products in the Order
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          itemBuilder: (context, productIndex) {
                            final product = order.items[productIndex];
                            return Column(
                              children: [
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ImageUtils.base64ToImage(product
                                        .imageUrls[0]), // Display Base64 image
                                  ),
                                  title: Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Quantity: ${product.quantity}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: Text(
                                    "\₹${product.price}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (productIndex < order.items.length - 1)
                                  const Divider(height: 1, thickness: 1),
                              ],
                            );
                          },
                        ),

                        // Order Status and Progress
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status: ${order.status}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: order.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.blueAccent,
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
