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

import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
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
                      Card(
                        // color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  decodeBase64Image(item.imageUrls.first),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppWidget.boldCardTitle(),
                                  ),
                                  Text('₹${item.price}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ))
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                  // return ListTile(
                  //   title: Text(item.title),
                  //   subtitle: Text('₹${item.price} x ${item.quantity}'),
                  // );
                },
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectAddressScreen())),
              child: BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(state.selectedAddress ?? "Select Address",
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}
