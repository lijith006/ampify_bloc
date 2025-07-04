// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:flutter/material.dart';

// class CartList extends StatelessWidget {
//   final List<CartItem> cartItems;
//   final Function(BuildContext, CartItem, int) onUpdateQuantity;
//   final Function(BuildContext, CartItem) onSaveForLater;
//   final Function(BuildContext, CartItem) onRemoveFromCart;

//   const CartList({
//     super.key,
//     required this.cartItems,
//     required this.onUpdateQuantity,
//     required this.onSaveForLater,
//     required this.onRemoveFromCart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     DateTime estimatedDeliveryDate =
//         DateTime.now().add(const Duration(days: 7));
//     String formattedDate =
//         "${estimatedDeliveryDate.day}-${estimatedDeliveryDate.month}-${estimatedDeliveryDate.year}";

//     return ListView.builder(
//       itemCount: cartItems.length,
//       itemBuilder: (context, index) {

//         final item = cartItems[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     ProductDetailPage(productId: item.productId),
//               ),
//             );
//           },
//           child: Stack(
//             children: [
//               Card(
//                 color: AppColors.backgroundColor,
//                 elevation: 1,
//                 margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Image
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.memory(
//                           decodeBase64Image(item.imageUrls.first),
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Title and Price
//                             Text(
//                               item.title,
//                             ),
//                             Text(
//                               '₹${item.price}',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Estimated Delivery: $formattedDate',
//                               style: const TextStyle(
//                                 color: Color.fromARGB(90, 12, 12, 12),
//                               ),
//                             ),

//                             // Add & Remove Quantity

//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // Minus Icon
//                                 IconButton(
//                                   onPressed: item.quantity > 1
//                                       ? () =>
//                                           onUpdateQuantity(context, item, -1)
//                                       : null,
//                                   icon: Icon(
//                                     Icons.remove,
//                                     color: item.quantity > 1
//                                         ? Colors.black
//                                         : Colors.grey,
//                                   ),
//                                 ),
//                                 Text("${item.quantity}"),
//                                 // Plus Icon
//                                 IconButton(
//                                   onPressed: () {
//                                     if (item.quantity < 10) {
//                                       onUpdateQuantity(context, item, 1);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                               "Maximum quantity limit reached (10)"),
//                                           duration: Duration(seconds: 2),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   icon: const Icon(Icons.add),
//                                 ),

//                                 // Save for Later
//                                 TextButton(
//                                   onPressed: () {
//                                     onSaveForLater(context, item);
//                                   },
//                                   child: const Text(
//                                     'Save for Later',
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Remove Product Icon
//               Positioned(
//                 top: 0,
//                 right: 3,
//                 child: IconButton(
//                   onPressed: () => onRemoveFromCart(context, item),
//                   icon: Image.asset(
//                     'assets/icons/delete_2.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Decode Base64 Image
//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }
// }
//--------------------jun 17
import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/cart/cart_widgets/cached_cart_image.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartList extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(BuildContext, CartItem, int) onUpdateQuantity;
  final Function(BuildContext, CartItem) onSaveForLater;
  final Function(BuildContext, CartItem) onRemoveFromCart;

  const CartList({
    super.key,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onSaveForLater,
    required this.onRemoveFromCart,
  });

  @override
  Widget build(BuildContext context) {
    DateTime estimatedDeliveryDate =
        DateTime.now().add(const Duration(days: 7));
    String formattedDate =
        "${estimatedDeliveryDate.day}-${estimatedDeliveryDate.month}-${estimatedDeliveryDate.year}";

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) {
            if (previous is CartLoaded && current is CartLoaded) {
              final prevQty = previous.cartItems
                  .firstWhere((e) => e.productId == item.productId,
                      orElse: () => item)
                  .quantity;
              final currQty = current.cartItems
                  .firstWhere((e) => e.productId == item.productId,
                      orElse: () => item)
                  .quantity;
              return prevQty != currQty;
            }
            return true;
          },
          builder: (context, state) {
            final currentItem = state is CartLoaded
                ? state.cartItems.firstWhere(
                    (e) => e.productId == item.productId,
                    orElse: () => item,
                  )
                : item;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailPage(productId: currentItem.productId),
                  ),
                );
              },
              child: Stack(
                children: [
                  Card(
                    color: AppColors.backgroundColor,
                    elevation: 1,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          CachedCartImage(
                            key: ValueKey(currentItem.imageUrls.first),
                            base64Image: currentItem.imageUrls.first,
                          ),

                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(10),
                          //   child: Image.memory(
                          //     decodeBase64Image(currentItem.imageUrls.first),
                          //     width: 100,
                          //     height: 100,
                          //     fit: BoxFit.contain,
                          //   ),
                          // ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentItem.title),
                                Text(
                                  '₹${currentItem.price}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Estimated Delivery: $formattedDate',
                                  style: const TextStyle(
                                    color: Color.fromARGB(90, 12, 12, 12),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: currentItem.quantity > 1
                                          ? () => onUpdateQuantity(
                                              context, currentItem, -1)
                                          : null,
                                      icon: Icon(
                                        Icons.remove,
                                        color: currentItem.quantity > 1
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text("${currentItem.quantity}"),
                                    IconButton(
                                      onPressed: () {
                                        if (currentItem.quantity < 10) {
                                          onUpdateQuantity(
                                              context, currentItem, 1);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Maximum quantity limit reached (10)"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onSaveForLater(context, currentItem);
                                      },
                                      child: const Text(
                                        'Save for Later',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 3,
                    child: IconButton(
                      onPressed: () => onRemoveFromCart(context, currentItem),
                      icon: Image.asset(
                        'assets/icons/delete_2.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Decode Base64 Image
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
