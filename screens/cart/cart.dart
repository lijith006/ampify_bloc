// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/cart/cart_service.dart';
// import 'package:ampify_bloc/screens/cart/saved_item_screen/saved_items_screen.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/widgets/custom_orange_button.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MyCart extends StatefulWidget {
//   const MyCart({
//     super.key,
//   });

//   @override
//   State<MyCart> createState() => _MyCartState();
// }

// class _MyCartState extends State<MyCart> {
//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Center(
//         child: Text('Please log in'),
//       );
//     }

//     return BlocProvider(
//       create: (context) =>
//           CartBloc(context.read<CartService>())..add(LoadCartItems()),
//       child: DefaultTabController(
//           length: 2,
//           child: Scaffold(
//             backgroundColor: AppColors.backgroundColor,
//             appBar: AppBar(
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(30),
//                 child: TabBar(
//                     indicatorColor: AppColors.buttonColorOrange,
//                     labelColor: Colors.black,
//                     unselectedLabelColor: Colors.grey,
//                     tabs: const [
//                       Tab(
//                         icon: Icon(Icons.save),
//                         text: 'My Cart',
//                       ),
//                       Tab(icon: Icon(Icons.save), text: "Saved for Later"),
//                     ]),
//               ),
//             ),
//             body: TabBarView(
//               children: [
//                 BlocBuilder<CartBloc, CartState>(
//                   builder: (context, state) {
//                     if (state is CartLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state is CartLoaded) {
//                       if (state.cartItems.isEmpty) {
//                         return const Center(
//                             child: Text('Your cart is empty 😔'));
//                       }
//                       return Column(
//                         children: [
//                           Expanded(child: buildCartList(state.cartItems)),
//                           buildTotalSection(state.cartItems),
//                         ],
//                       );
//                     } else {
//                       return const Center(child: Text('Failed to load cart.'));
//                     }
//                   },
//                 ),

//                 // Saved Items Tab
//                 const SavedItemsScreen()
//               ],
//             ),
//           )),
//     );
//   }

// //Cart section
//   Widget buildCartList(List<CartItem> cartItems) {
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
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       ProductDetailPage(productId: item.productId),
//                 ));
//           },
//           child: Stack(
//             children: [
//               Card(
//                 color: Colors.white,
//                 margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       //image
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.memory(
//                           decodeBase64Image(item.imageUrls.first),
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //title  and price
//                           Text(
//                             item.title,
//                             style: AppWidget.boldCardTitle(),
//                           ),
//                           Text('₹${item.price}',
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold)),
//                           Text(
//                             'Estimated Delivery: $formattedDate',
//                             style: const TextStyle(
//                               color: Color.fromARGB(90, 12, 12, 12),
//                             ),
//                           ),

//                           //add & remove quantity
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               // Minus Icon
//                               IconButton(
//                                 onPressed: item.quantity > 1
//                                     ? () => updateQuantity(context, item, -1)
//                                     : null, // Disable if quantity is 1
//                                 icon: Icon(
//                                   Icons.remove,
//                                   color: item.quantity > 1
//                                       ? Colors.black
//                                       : Colors.grey,
//                                 ),
//                               ),
//                               Text("${item.quantity}"),
//                               // Plus Icon
//                               IconButton(
//                                 onPressed: () {
//                                   if (item.quantity < 10) {
//                                     updateQuantity(context, item, 1);
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Maximum quantity limit reached (10)"),
//                                         duration: Duration(seconds: 2),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(Icons.add),
//                               ),

//                               //Save for later
//                               TextButton(
//                                 onPressed: () {
//                                   saveForLater(context, item);
//                                 },
//                                 child: const Text('Save for Later',
//                                     style: TextStyle(color: Colors.black54)),
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                     ],
//                   ),
//                 ),
//               ),
//               // Remove product icon
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: IconButton(
//                   onPressed: () => removeFromCart(context, item),
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

// //image
//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

// //bottom total section
//   Widget buildTotalSection(List<CartItem> cartItems) {
//     double total =
//         cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//           color: AppColors.light,
//           boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)]),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Total:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text('₹$total',
//                   style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           CustomOrangeButton(
//               width: 300,
//               text: 'Proceed to Buy',
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CheckoutScreen(products: cartItems),
//                     ));
//               })
//         ],
//       ),
//     );
//   }

// //Update section
//   void updateQuantity(BuildContext context, CartItem item, int change) {
//     context.read<CartBloc>().add(UpdateQuantity(item, change));
//   }

// //Save for later
//   void saveForLater(BuildContext context, CartItem item) {
//     context.read<CartBloc>().add(SaveForLater(item));
//   }

// //Remove Product Logic
//   void removeFromCart(BuildContext context, CartItem item) {
//     context.read<CartBloc>().add(RemoveFromCart(item.productId));

//     //snackbar
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: const Text('Item removed from cart!'),
//       duration: const Duration(seconds: 2),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             //Re-add the item
//             context.read<CartBloc>().add(AddToCart(item));
//           }),
//     ));
//   }
// }
//***************************************************MARC 19 */
import 'dart:convert';
import 'dart:typed_data';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/cart/cart_service.dart';
import 'package:ampify_bloc/screens/cart/cart_widgets/cart_list_widget.dart';
import 'package:ampify_bloc/screens/cart/saved_item_screen/saved_items_screen.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
import 'package:ampify_bloc/widgets/custom_orange_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCart extends StatefulWidget {
  const MyCart({
    super.key,
  });

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(
        child: Text('Please log in'),
      );
    }

    return BlocProvider(
      create: (context) =>
          CartBloc(context.read<CartService>())..add(LoadCartItems()),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: TabBar(
                    indicatorColor: AppColors.buttonColorOrange,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.save),
                        text: 'My Cart',
                      ),
                      Tab(icon: Icon(Icons.save), text: "Saved for Later"),
                    ]),
              ),
            ),
            body: TabBarView(
              children: [
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CartLoaded) {
                      if (state.cartItems.isEmpty) {
                        return const Center(
                            child: Text('Your cart is empty 😔'));
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: CartList(
                              cartItems: state.cartItems,
                              onUpdateQuantity: updateQuantity,
                              onSaveForLater: saveForLater,
                              onRemoveFromCart: removeFromCart,
                            ),
                            //buildCartList(state.cartItems)
                          ),
                          buildTotalSection(state.cartItems),
                        ],
                      );
                    } else {
                      return const Center(child: Text('Failed to load cart.'));
                    }
                  },
                ),

                // Saved Items Tab
                const SavedItemsScreen()
              ],
            ),
          )),
    );
  }

//image
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

//bottom total section
  Widget buildTotalSection(List<CartItem> cartItems) {
    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.light,
          boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('₹$total',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(height: 10),
          CustomOrangeButton(
              width: 300,
              text: 'Proceed to Buy',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(products: cartItems),
                    ));
              })
        ],
      ),
    );
  }

//Update section
  void updateQuantity(BuildContext context, CartItem item, int change) {
    context.read<CartBloc>().add(UpdateQuantity(item, change));
  }

//Save for later
  void saveForLater(BuildContext context, CartItem item) {
    context.read<CartBloc>().add(SaveForLater(item));
  }

//Remove Product Logic
  void removeFromCart(BuildContext context, CartItem item) {
    context.read<CartBloc>().add(RemoveFromCart(item.productId));

    //snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Item removed from cart!'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            //Re-add the item
            context.read<CartBloc>().add(AddToCart(item));
          }),
    ));
  }
}
