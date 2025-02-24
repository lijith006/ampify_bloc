// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/cart/saved_items_screen.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

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

//     return DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           backgroundColor: AppColors.backgroundColor,
//           appBar: AppBar(
//             //  title: const Text('My Cart'),
//             bottom: const TabBar(
//                 indicatorColor: Colors.blueAccent,
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.grey,
//                 tabs: [
//                   Tab(
//                     icon: Icon(Icons.save),
//                     text: 'My Cart',
//                   ),
//                   Tab(icon: Icon(Icons.save), text: "Saved for Later"),
//                 ]),
//           ),
//           body: TabBarView(
//             children: [
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(userId)
//                     .collection('cart')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('Your cart is empty 😔'));
//                   }
//                   final cartItems = snapshot.data!.docs.map((doc) {
//                     return CartItem.fromMap(doc.data() as Map<String, dynamic>);
//                   }).toList();

//                   return Column(
//                     children: [
//                       // ElevatedButton(
//                       //     onPressed: () {
//                       //       Navigator.push(
//                       //           context,
//                       //           MaterialPageRoute(
//                       //             builder: (context) => SavedItemsScreen(
//                       //               moveToCart: (CartItem) {},
//                       //             ),
//                       //           ));
//                       //     },
//                       //     child: const Text('Saved items')),
//                       Expanded(child: buildCartList(cartItems)),
//                       buildTotalSection(cartItems),
//                       //save later call
//                     ],
//                   );
//                 },
//               ),

//               // Saved Items Tab
//               SavedItemsScreen(
//                 moveToCart: (CartItem item) async {
//                   final userId = FirebaseAuth.instance.currentUser?.uid;
//                   if (userId == null) return;

//                   final savedRef = FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(userId)
//                       .collection('saved');

//                   final cartRef = FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(userId)
//                       .collection('cart');

//                   await savedRef.doc(item.productId).delete();
//                   await cartRef.doc(item.productId).set(item.toMap());

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Item moved to cart!')),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ));
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
//                             //  TextStyle(
//                             //     fontSize: 18, fontWeight: FontWeight.bold),
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
//                             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                   onPressed: () => updateQuantity(item, -1),
//                                   icon: const Icon(Icons.remove)),
//                               Text("${item.quantity}"),
//                               IconButton(
//                                   onPressed: () => updateQuantity(item, 1),
//                                   icon: const Icon(Icons.add)),
//                               //Save for later
//                               TextButton(
//                                 onPressed: () {
//                                   saveForLater(item);
//                                 },
//                                 child: const Text('Save for Later',
//                                     style: TextStyle(color: Colors.blue)),
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
//                   onPressed: () => removeFromCart(item.productId),
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
//           color: Colors.white,
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
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0XFF1A73E8),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
//             onPressed: () => print('Proceed to Buy'),
//             child: const Text(
//               'Proceed to Buy',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// //Update section
//   Future<void> updateQuantity(CartItem item, int change) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     int newQuantity = item.quantity + change;
//     if (newQuantity > 0) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('cart')
//           .doc(item.productId)
//           .update({'quantity': newQuantity});
//     }
//   }

// //Save for later
//   Future<void> saveForLater(CartItem item) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final cartRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart');

//     final savedRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('saved');
//     //Remove from cart
//     await cartRef.doc(item.productId).delete();
//     //Add to save for later
//     await savedRef.doc(item.productId).set(item.toMap());
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Item saved for later!')),
//     );
//   }

// //Remove Product Logic
//   Future<void> removeFromCart(String productId) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart')
//         .doc(productId)
//         .delete();
//   }
// }

//---------------------------------------------**********************

import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/cart/cart_service.dart';
import 'package:ampify_bloc/screens/cart/saved_item_screen/saved_items_screen.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
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
              bottom: const TabBar(
                  indicatorColor: Colors.blueAccent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.save),
                      text: 'My Cart',
                    ),
                    Tab(icon: Icon(Icons.save), text: "Saved for Later"),
                  ]),
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
                          Expanded(child: buildCartList(state.cartItems)),
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

//Cart section
  Widget buildCartList(List<CartItem> cartItems) {
    DateTime estimatedDeliveryDate =
        DateTime.now().add(const Duration(days: 7));
    String formattedDate =
        "${estimatedDeliveryDate.day}-${estimatedDeliveryDate.month}-${estimatedDeliveryDate.year}";
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailPage(productId: item.productId),
                ));
          },
          child: Stack(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          decodeBase64Image(item.imageUrls.first),
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title  and price
                          Text(
                            item.title,
                            style: AppWidget.boldCardTitle(),
                          ),
                          Text('₹${item.price}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'Estimated Delivery: $formattedDate',
                            style: const TextStyle(
                              color: Color.fromARGB(90, 12, 12, 12),
                            ),
                          ),

                          //add & remove quantity
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.quantity > 1)
                                IconButton(
                                    onPressed: () =>
                                        updateQuantity(context, item, -1),
                                    icon: const Icon(Icons.remove)),
                              Text("${item.quantity}"),
                              IconButton(
                                onPressed: () {
                                  if (item.quantity < 10) {
                                    updateQuantity(context, item, 1);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                              //Save for later
                              TextButton(
                                onPressed: () {
                                  saveForLater(context, item);
                                },
                                child: const Text('Save for Later',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              // Remove product icon
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => removeFromCart(context, item.productId),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
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
          color: Colors.white,
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
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 99, 202, 40),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(products: cartItems),
                )),
            child: const Text(
              'Proceed to Buy',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
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
  }

//Remove Product Logic
  void removeFromCart(BuildContext context, String productId) {
    context.read<CartBloc>().add(RemoveFromCart(productId));
  }
}
