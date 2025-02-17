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
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

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
      appBar: AppBar(title: const Text('Wishlist')),
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
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(109, 155, 154, 154),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: images.isNotEmpty
                                      ? Image.memory(
                                          imageBytes,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.contain,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "₹${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<WishlistBloc>().add(
                                      ToggleWishlistItem(
                                        productId: productId,
                                        isCurrentlyWishlisted: true,
                                        context: context,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
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
