// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/cart/cart_service.dart';
// import 'package:ampify_bloc/screens/cart/cart_widgets/cart_list_widget.dart';
// import 'package:ampify_bloc/screens/cart/saved_item_screen/saved_items_screen.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/widgets/confirm_dialogue.dart';
// import 'package:ampify_bloc/widgets/glowing_revolving_button.dart';
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
//                     tabs: [
//                       Tab(
//                         icon: Icon(Icons.shopping_cart),
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
//                           Expanded(
//                             child: CartList(
//                               cartItems: state.cartItems,
//                               onUpdateQuantity: updateQuantity,
//                               onSaveForLater: saveForLater,
//                               onRemoveFromCart: removeFromCart,
//                             ),
//                           ),
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
//           GlowingSnakeButton(
//             width: 280,
//             text: 'Proceed to Buy',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CheckoutScreen(products: cartItems),
//                 ),
//               );
//             },
//           ),
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

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: const Text('Item saved for later!'),
//       duration: const Duration(seconds: 2),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ));
//   }

//   void removeFromCart(BuildContext context, CartItem item) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => const ConfirmDialog(
//         title: 'Remove Item',
//         content: 'Are you sure you want to remove this item from your cart?',
//       ),
//     );

//     if (confirmed == true) {
//       context.read<CartBloc>().add(RemoveFromCart(item.productId));

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('Item removed from cart!'),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             context.read<CartBloc>().add(AddToCart(item));
//           },
//         ),
//       ));
//     }
//   }
// }
//-----------------------------------june 17
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
import 'package:ampify_bloc/widgets/confirm_dialogue.dart';
import 'package:ampify_bloc/widgets/glowing_revolving_button.dart';
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
                    tabs: [
                      Tab(
                        icon: Icon(Icons.shopping_cart),
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
          GlowingSnakeButton(
            width: 280,
            text: 'Proceed to Buy',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(products: cartItems),
                ),
              );
            },
          ),
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Item saved for later!'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void removeFromCart(BuildContext context, CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ConfirmDialog(
        title: 'Remove Item',
        content: 'Are you sure you want to remove this item from your cart?',
      ),
    );

    if (confirmed == true) {
      context.read<CartBloc>().add(RemoveFromCart(item.productId));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Item removed from cart!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            context.read<CartBloc>().add(AddToCart(item));
          },
        ),
      ));
    }
  }
}
