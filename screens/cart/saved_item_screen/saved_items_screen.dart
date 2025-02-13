// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SavedItemsScreen extends StatelessWidget {
//   final Function(CartItem) moveToCart;

//   const SavedItemsScreen({
//     super.key,
//     required this.moveToCart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Center(
//         child: Text('Please log in'),
//       );
//     }
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Saved Items'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection('saved')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No saved items yet.'));
//           }

//           final savedItems = snapshot.data!.docs.map((doc) {
//             return CartItem.fromMap(doc.data() as Map<String, dynamic>);
//           }).toList();
//           return ListView.builder(
//             itemCount: savedItems.length,
//             itemBuilder: (context, index) {
//               final item = savedItems[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailPage(productId: item.productId),
//                       ));
//                 },
//                 child: Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: ListTile(
//                     leading: Image.memory(
//                       decodeBase64Image(item.imageUrls.first),
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(item.title),
//                     subtitle: Text('₹${item.price}'),
//                     trailing: ElevatedButton(
//                       onPressed: () async {
//                         await moveToCartFirestore(context, item, userId);
//                       },
//                       child: const Text('Move to Cart'),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   Future<void> moveToCartFirestore(
//       BuildContext context, CartItem item, String userId) async {
//     final savedRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('saved');

//     final cartRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart');

//     await savedRef.doc(item.productId).delete();
//     await cartRef.doc(item.productId).set(item.toMap());

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Item moved to cart!')),
//     );
//   }
// }

//******************************************************* */
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/cart/saved_item_screen/bloc/saved_items_bloc.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SavedItemsScreen extends StatelessWidget {
//   final Function(CartItem) moveToCart;

//   const SavedItemsScreen({
//     super.key,
//     required this.moveToCart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Center(
//         child: Text('Please log in'),
//       );
//     }
//     return BlocProvider(
//       create: (context) => SavedItemsBloc()..add(LoadSavedItems()),
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           title: const Text('Saved Items'),
//         ),
//         body: BlocBuilder<SavedItemsBloc, SavedItemsState>(
//             builder: (context, state) {
//           if (state is SavedItemsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is SavedItemsLoaded) {
//             final savedItems = state.savedItems;

//             if (savedItems.isEmpty) {
//               return const Center(child: Text('No saved items yet.'));
//             }

//             // StreamBuilder<QuerySnapshot>(
//             //   stream: FirebaseFirestore.instance
//             //       .collection('users')
//             //       .doc(userId)
//             //       .collection('saved')
//             //       .snapshots(),
//             //   builder: (context, snapshot) {
//             //     if (snapshot.connectionState == ConnectionState.waiting) {
//             //       return const Center(child: CircularProgressIndicator());
//             //     }
//             //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             //       return const Center(child: Text('No saved items yet.'));
//             //     }

//             //     final savedItems = snapshot.data!.docs.map((doc) {
//             //       return CartItem.fromMap(doc.data() as Map<String, dynamic>);
//             //     }).toList();
//             return ListView.builder(
//               itemCount: savedItems.length,
//               itemBuilder: (context, index) {
//                 final item = savedItems[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ProductDetailPage(productId: item.productId),
//                         ));
//                   },
//                   child: Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     child: ListTile(
//                       leading: Image.memory(
//                         decodeBase64Image(item.imageUrls.first),
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(item.title),
//                       subtitle: Text('₹${item.price}'),
//                       trailing: ElevatedButton(
//                         onPressed: () async {
//                           context.read<SavedItemsBloc>().add(MoveToCart(item));
//                           // await moveToCartFirestore(context, item, userId);
//                         },
//                         child: const Text('Move to Cart'),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('Failed to load saved items.'));
//           }
//         }),
//       ),
//     );
//   }

//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   // Future<void> moveToCartFirestore(
//   //     BuildContext context, CartItem item, String userId) async {
//   //   final savedRef = FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(userId)
//   //       .collection('saved');

//   //   final cartRef = FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(userId)
//   //       .collection('cart');

//   //   await savedRef.doc(item.productId).delete();
//   //   await cartRef.doc(item.productId).set(item.toMap());

//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     const SnackBar(content: Text('Item moved to cart!')),
//   //   );
//   // }
// }
//********900000000000000000000000000000000000000000000 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/saved_item_screen/bloc/saved_items_bloc.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text('Please log in'));
    }

    return BlocProvider(
      create: (context) => SavedItemsBloc()..add(LoadSavedItems()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(title: const Text('Saved Items')),
        body: BlocBuilder<SavedItemsBloc, SavedItemsState>(
          builder: (context, state) {
            if (state is SavedItemsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavedItemsLoaded) {
              final savedItems = state.savedItems;

              if (savedItems.isEmpty) {
                return const Center(child: Text('No saved items yet.'));
              }

              return ListView.builder(
                itemCount: savedItems.length,
                itemBuilder: (context, index) {
                  final item = savedItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: item.productId),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                          leading: Image.memory(
                            decodeBase64Image(item.imageUrls.first),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.title),
                          subtitle: Text('₹${item.price}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              final cartBloc = context.read<CartBloc>();

                              context
                                  .read<SavedItemsBloc>()
                                  .add(MoveToCart(item, cartBloc));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Item moved to cart!')),
                              );
                            },
                            child: const Text('Move to Cart'),
                          )

                          // ElevatedButton(
                          //   onPressed: () {
                          //     context
                          //         .read<SavedItemsBloc>()
                          //         .add(MoveToCart(item));
                          //   },
                          //   child: const Text('Move to Cart'),
                          // ),
                          ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Failed to load saved items.'));
            }
          },
        ),
      ),
    );
  }

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
