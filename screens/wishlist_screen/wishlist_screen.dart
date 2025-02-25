// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// // import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Center(child: Text('Please log in to see wishlist'));
//     }
//     return BlocProvider(
//       create: (context) => WishlistBloc()..add(FetchWishlist()),
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(title: const Text('Wishlist')),
//         body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .collection('wishlist')
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No items in wishlist.'));
//             }

//             // return GridView.builder(
//             //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             //       crossAxisCount: 2,
//             //       crossAxisSpacing: 10,
//             //       mainAxisSpacing: 10,
//             //       childAspectRatio: 1.0),
//             //   itemCount: snapshot.data!.docs.length,
//             //   itemBuilder: (context, index) {
//             //     var doc = snapshot.data!.docs[index];
//             //     String productId = doc['productId'];
//             //     String name = doc['name'];
//             //     double price = doc['price'];
//             //     List<dynamic> images = doc['imageUrls'];
//             //     Uint8List imageBytes =
//             //         base64Decode(images.isNotEmpty ? images[0] : '');
//             //     // return GestureDetector(
//             //     //   onTap: () {
//             //     //     Navigator.push(
//             //     //         context,
//             //     //         MaterialPageRoute(
//             //     //           builder: (context) =>
//             //     //               ProductDetailPage(productId: productId),
//             //     //         ));

//             //     //   },
//             //     // );
//             //     return Container(
//             //         decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(12),
//             //           color: Colors.cyan,
//             //         ),
//             //         child: ClipRRect(
//             //             child: images.isNotEmpty
//             //                 ? Image.memory(
//             //                     imageBytes,
//             //                     width: 100,
//             //                     height: 100,
//             //                     fit: BoxFit.cover,
//             //                   )
//             //                 : const Icon(Icons.image_not_supported_rounded)));
//             //   },
//             // );

//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var doc = snapshot.data!.docs[index];
//                 String productId = doc['productId'];
//                 String name = doc['name'];
//                 double price = doc['price'];
//                 List<dynamic> images = doc['imageUrls'];
//                 Uint8List imageBytes =
//                     base64Decode(images.isNotEmpty ? images[0] : '');
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailPage(productId: productId),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.all(8.0),
//                     child: ListTile(
//                       leading: images.isNotEmpty
//                           ? Image.memory(imageBytes,
//                               width: 50, height: 50, fit: BoxFit.cover)
//                           : const Icon(Icons.image_not_supported),
//                       title: Text(name),
//                       subtitle: Text("₹${price.toStringAsFixed(2)}"),
//                       trailing: const Icon(Icons.arrow_forward_ios),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//***************************************************************************************************************** */

import 'dart:convert';
import 'dart:typed_data';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/common/card_widget.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to see wishlist')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('W i s h l i s t'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WishlistError) {
            return Center(child: Text(state.message));
          }

          if (state is WishlistLoaded && state.wishlist.isEmpty) {
            return const Center(child: Text('No items in wishlist.'));
          }

          if (state is WishlistLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.wishlist.length,
                itemBuilder: (context, index) {
                  var doc = state.wishlist[index];
                  String productId = doc['productId'];
                  String name = doc['name'];
                  double price = doc['price'];
                  List<dynamic> images = doc['imageUrls'];
                  Uint8List imageBytes =
                      base64Decode(images.isNotEmpty ? images[0] : '');

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: productId),
                        ),
                      );
                    },
                    child: CardWidget(
                      imageBytes: imageBytes,
                      name: name,
                      price: price,
                      isWishlisted: true,
                      productId: productId,
                      onWishlistToggle: () {
                        context.read<WishlistBloc>().add(
                              ToggleWishlistItem(
                                productId: productId,
                                isCurrentlyWishlisted: true,
                                context: context,
                                //********** */
                                productData: {
                                  'name': name,
                                  'price': price,
                                  'imageUrls': [base64Encode(imageBytes)],
                                },

                                //************* */
                              ),
                            );
                      },
                      onAddToCart: () {
                        // Convert Uint8List to Base64 String
                        final base64Image = base64Encode(imageBytes);

                        // Store as List<String>

                        final cartItem = CartItem(
                          productId: productId,
                          title: name,
                          price: price,
                          quantity: 1,
                          imageUrls: [base64Image],
                        );

                        context.read<CartBloc>().add(AddToCart(cartItem));

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Item added to cart!')));
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
