// import 'dart:convert';

// import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_state.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Categories extends StatelessWidget {
//   final String categoryId;
//   final String categoryName;
//   const Categories(
//       {super.key, required this.categoryId, required this.categoryName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('C a t e g o r y'),
//       ),
//       body: BlocBuilder<CategoriesBloc, CategoriesState>(
//           builder: (context, state) {
//         if (state is CategoriesLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is CategoriesError) {
//           return Center(
//             child: Text(state.message),
//           );
//         } else if (state is CategoriesLoaded) {
//           final products = state.products;
//           if (products.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No product available in this category',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             );
//           }

//           //   final products = snapshot.data!.docs;
//           return GridView.builder(
//             padding: const EdgeInsets.all(8.0),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//                 childAspectRatio: 0.75),
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final productId = products[index].id;

//               final product = products[index];

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailPage(productId: productId),
//                       ));
//                 },
//                 child: Card(
//                   elevation: 2,
//                   child: Column(
//                     children: [
//                       Expanded(
//                           child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             image: DecorationImage(
//                                 image: MemoryImage(
//                                   base64Decode(product['images'][0]),
//                                 ),
//                                 fit: BoxFit.contain)),
//                       )),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Text(
//                               product['name'],
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '\₹${product['price']}',
//                               style: const TextStyle(
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         } else {
//           return const Center(
//             child: Text('Initial state'),
//           );
//         }
//       }),
//     );
//   }
// }
//---------------------------------------------APR 8
import 'dart:convert';

import 'package:ampify_bloc/common/card_widget.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_state.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const Categories(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item added to cart!'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(title: 'C a t e g o r i e s'),
          body: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoriesError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is CategoriesLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    'No product available in this category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }
              return BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, wishlistState) {
                  // ignore: unused_local_variable
                  List<String> wishlistIds = [];

                  if (wishlistState is WishlistLoaded) {
                    wishlistIds =
                        wishlistState.wishlist.map((doc) => doc.id).toList();
                  }

                  //   final products = snapshot.data!.docs;
                  return BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, wishlistState) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.75),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final productId = products[index].id;

                          final product = products[index];
                          bool isWishlisted = false;
                          if (wishlistState is WishlistLoaded) {
                            isWishlisted = wishlistState.wishlist
                                .any((doc) => doc.id == productId);
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(productId: productId),
                                  ));
                            },
                            child: CardWidget(
                              name: product['name'],
                              price: product['price'].toDouble(),
                              imageBytes: base64Decode(product['images'][0]),
                              isWishlisted: isWishlisted,
                              productId: productId,
                              onAddToCart: () {
                                // Dispatch Add to Cart action via Bloc
                                final cartItem = CartItem(
                                  productId: productId,
                                  title: product['name'],
                                  price: product['price'].toDouble(),
                                  quantity: 1,
                                  imageUrls:
                                      List<String>.from(product['images']),
                                );
                                context
                                    .read<CartBloc>()
                                    .add(AddToCart(cartItem));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product['name']} added to cart!'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              onWishlistToggle: () {
                                final productData = {
                                  'name': product['name'],
                                  'price': product['price'].toDouble(),
                                  'imageUrls': product['images'],
                                };

                                context.read<WishlistBloc>().add(
                                      ToggleWishlistItem(
                                        productId: productId,
                                        isCurrentlyWishlisted: isWishlisted,
                                        context: context,
                                        productData: productData,
                                      ),
                                    );
                              },
                              cartCount: 0,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Initial state'));
            }
          }),
        ));
  }
}
