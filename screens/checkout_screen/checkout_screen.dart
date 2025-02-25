// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
// import 'package:ampify_bloc/screens/checkout_screen/select_address_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CheckoutScreen extends StatelessWidget {
//   final List<CartItem> products;
//   const CheckoutScreen({super.key, required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Product: Awesome Gadget", style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             Text("Price: \$299", style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             const Text("Delivery Address",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const SelectAddressScreen())),
//               child: BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   return Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(state.selectedAddress ?? "Select Address",
//                         style: const TextStyle(fontSize: 16)),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text("Place Order"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//******************************************************* */

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
// import 'package:ampify_bloc/screens/checkout_screen/select_address_screen.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CheckoutScreen extends StatelessWidget {
//   final List<CartItem> products;
//   const CheckoutScreen({super.key, required this.products});
//   //image
//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }
// //   @override
// // void initState() {
// //   super.initState();
// //   context.read<CheckoutBloc>().add(LoadAddresses());
// // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('C h e c k o u t'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Delivering To',
//               style: AppWidget.boldTextFieldStyle(),
//             ),
//             BlocBuilder<CheckoutBloc, CheckoutState>(
//               builder: (context, state) {
//                 if (state.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return GestureDetector(
//                   onTap: () async {
//                     final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SelectAddressScreen(),
//                         ));

//                     if (selectedAddress is String) {
//                       context
//                           .read<CheckoutBloc>()
//                           .add(SelectAddress(selectedAddress));
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Text(
//                       state.selectedAddress ?? 'Selected Address',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const Divider(
//               thickness: 0.6,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final item = products[index];
//                   return Stack(
//                     children: [
//                       //CARD
//                       Card(
//                         color: Colors.white,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.memory(
//                                   decodeBase64Image(item.imageUrls.first),
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               Expanded(
//                                   child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     style: AppWidget.boldTextFieldStyleSmall(),
//                                   ),
//                                   Text('₹${item.price}',
//                                       style: const TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ))
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                   // return ListTile(
//                   //   title: Text(item.title),
//                   //   subtitle: Text('₹${item.price} x ${item.quantity}'),
//                   // );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text("Place Order"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//8888888888888888888888888888888888888888888888888888888888
import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
import 'package:ampify_bloc/screens/checkout_screen/select_address_screen.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> products;
  const CheckoutScreen({super.key, required this.products});
  //image
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        products.fold(0, (sum, item) => sum + (item.price * item.quantity));
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('C h e c k o u t'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Delivering To',
              style: AppWidget.boldTextFieldStyle(),
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () async {
                    final selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectAddressScreen(),
                        ));

                    if (selectedAddress is String) {
                      context
                          .read<CheckoutBloc>()
                          .add(SelectAddress(selectedAddress));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      state.selectedAddress ?? 'Selected Address',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 0.6,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Stack(
                    children: [
                      //CARD
                      Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  decodeBase64Image(item.imageUrls.first),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),

                              //product details
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppWidget.boldTextFieldStyleSmall(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('₹${item.price} | Qty: ${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ))
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildPriceRow("Subtotal", "₹$totalPrice"),
                  _buildPriceRow("Delivery Fee", "Free"),
                  const Divider(),
                  _buildPriceRow("Total", "₹$totalPrice", isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColorOrange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Place Order",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
