// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/widgets/custom_orange_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class TrackMyOrders extends StatefulWidget {
//   const TrackMyOrders({super.key});

//   @override
//   State<TrackMyOrders> createState() => _TrackMyOrdersState();
// }

// class _TrackMyOrdersState extends State<TrackMyOrders> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<OrderBloc>().add(FetchOrders());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Track Orders")),
//       body: BlocBuilder<OrderBloc, OrderState>(
//         builder: (context, state) {
//           if (state is OrderLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is OrdersLoaded) {
//             if (state.orders.isEmpty) {
//               return const Center(child: Text("No orders found"));
//             }
//             return ListView.builder(
//               itemCount: state.orders.length,
//               itemBuilder: (context, index) {
//                 final order = state.orders[index];
//                 return SizedBox(height: 100,
//                   child: Card(
//                     margin: EdgeInsets.all(8),
//                     color: Colors.purple[300],
//                     child: Text('Order #${order.id}'),
//                   ),
//                 );
//                 // return ListTile(
//                 //   title: Text(
//                 //     "Order  #${order.id}",
//                 //     style: TextStyle(color: AppColors.dark),
//                 //   ),
//                 //   subtitle: Text("Status:  ${order.status}"),
//                 //   trailing: CustomOrangeButton(
//                 //       width: 90, text: 'Track', onPressed: () {}),
//                 // );
//               },
//             );
//           } else if (state is OrderFailed) {
//             return Center(child: Text("Error: ${state.error}"));
//           }
//           return const Center(child: Text("No orders found"));
//         },
//       ),
//     );
//   }
// }
//************************************************ */
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/widgets/custom_black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class TrackMyOrders extends StatefulWidget {
  const TrackMyOrders({super.key});

  @override
  State<TrackMyOrders> createState() => _TrackMyOrdersState();
}

class _TrackMyOrdersState extends State<TrackMyOrders> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Track Orders"),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
                child: Lottie.asset('assets/animations/orderLoading.json',
                    width: 250));
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    LottieBuilder.asset('assets/animations/noOrders.json'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                        child: Text("No orders found",
                            style: TextStyle(fontSize: 18))),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return SizedBox(
                    //height: 100,
                    child: Card(
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.grey[200],
                        child: ListTile(
                            title: Text(
                              "Order  #${order.id}",
                              style: TextStyle(color: AppColors.dark),
                            ),
                            // subtitle: Text("Status:  ${order.status}"),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status: ${order.status}"),
                                  LinearProgressIndicator(
                                    value: order.progress,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.cyan,
                                  ),
                                ]),
                            trailing: CustomBlackButton(
                                width: 90, text: 'Track', onPressed: () {})
                            // trailing: CustomOrangeButton(
                            //     width: 90, text: 'Track', onPressed: () {}),
                            )),
                  );
                },
              ),
            );
          } else if (state is OrderFailed) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const Center(child: Text("No orders found"));
        },
      ),
    );
  }
}
