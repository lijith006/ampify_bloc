// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/common/card_widget.dart';
// import 'package:ampify_bloc/repositories/product_repository.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/home/widgets/fetch_categories.dart';

// import 'package:ampify_bloc/screens/home/widgets/product_carousel.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_carousel_place_holder.dart';
// import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_category_list.dart';
// import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_product_card.dart';
// //import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart' as cart_event;

// class HomeContent extends StatefulWidget {
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// class _HomeContentState extends State<HomeContent> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late final ProductRepository productRepository;
//   // final CarouselSliderController controller = CarouselSliderController();
//   int activeIndex = 0;
//   Set<String> wishlistedItems = {};
//   @override
//   void initState() {
//     super.initState();
//     productRepository = ProductRepository(firestore);
//   }

//   void toggleWishlist(BuildContext context, String productId,
//       Map<String, dynamic> productData) {
//     final wishlistBloc = context.read<WishlistBloc>();
//     final wishlistState = wishlistBloc.state;

//     final isWishlisted = wishlistState is WishlistLoaded &&
//         wishlistState.wishlistedItems.contains(productId);

//     wishlistBloc.add(
//       ToggleWishlistItem(
//         productId: productId,
//         isCurrentlyWishlisted: isWishlisted,
//         productData: productData,
//         context: context,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: AppColors.backgroundColor,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               //C a r o u s e l   B a n n e r
//               // ProductCarousel(productStream: productRepository.fetchProducts()),
//               StreamBuilder(
//                 stream: productRepository.fetchProducts(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const ShimmerCarouselPlaceholder();
//                   }
//                   return ProductCarousel(
//                       productStream: productRepository.fetchProducts());
//                 },
//               ),

//               // F e t c h    C a t e g o r i e s
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // CategoryListWidget(firestore: firestore),
//                     FutureBuilder(
//                       future: firestore.collection('categories').get(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const ShimmerCategoryList();
//                         }
//                         return CategoryListWidget(firestore: firestore);
//                       },
//                     ),

//                     const SizedBox(height: 5),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Featured products',
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     //P R O D U C T    G R I D
//                     StreamBuilder<QuerySnapshot>(
//                       stream: productRepository.fetchProducts(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 8,
//                               mainAxisSpacing: 8,
//                               childAspectRatio: 0.75,
//                             ),
//                             itemCount: 6,
//                             itemBuilder: (context, index) =>
//                                 const ShimmerProductCard(),
//                           );
//                         }

//                         if (snapshot.hasError) {
//                           return const Center(
//                             child: Text('Something went wrong'),
//                           );
//                         }
//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return const Center(
//                             child: Text(
//                               'No products available',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                           );
//                         }
//                         final products = snapshot.data!.docs;
//                         //   final cartState = context.watch<CartBloc>().state;

//                         return Column(
//                           children: [
//                             GridView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         crossAxisSpacing: 8,
//                                         mainAxisSpacing: 8,
//                                         childAspectRatio: 0.75),
//                                 itemCount: products.length,
//                                 itemBuilder: (context, index) {
//                                   final doc = products[index];
//                                   final productId = doc.id;
//                                   final name = doc['name'] as String;
//                                   final price =
//                                       (doc['price'] as num).toDouble();
//                                   final images = doc['images'] as List<dynamic>;
//                                   // final imageBytes = base64Decode(
//                                   //     images.isNotEmpty ? images[0] : '');
//                                   Uint8List imageBytes = Uint8List(0);
//                                   if (images.isNotEmpty &&
//                                       images[0] is String) {
//                                     try {
//                                       imageBytes = base64Decode(images[0]);
//                                     } catch (_) {
//                                       imageBytes = Uint8List(0); // fallback
//                                     }
//                                   }

//                                   return Builder(
//                                     builder: (inner) {
//                                       final isWishlisted = inner
//                                           .select<WishlistBloc, bool>((bloc) {
//                                         final s = bloc.state;
//                                         return s is WishlistLoaded &&
//                                             s.wishlistedItems
//                                                 .contains(productId);
//                                       });

//                                       final cartState =
//                                           inner.watch<CartBloc>().state;
//                                       final cartCount = cartState is CartLoaded
//                                           ? cartState.cartItems
//                                               .where((item) =>
//                                                   item.productId == productId)
//                                               .fold(
//                                                   0,
//                                                   (sum, item) =>
//                                                       sum + item.quantity)
//                                           : 0;
//                                       //Product details screen
//                                       return GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               inner,
//                                               MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     ProductDetailPage(
//                                                   productId: productId,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           //Product card
//                                           child: CardWidget(
//                                             key: ValueKey(productId),
//                                             name: name,
//                                             price: price,
//                                             imageBytes: imageBytes,
//                                             isWishlisted: isWishlisted,
//                                             productId: productId,
//                                             onWishlistToggle: () =>
//                                                 toggleWishlist(
//                                                     inner, productId, {
//                                               'name': name,
//                                               'price': price,
//                                               'imageUrls': images,
//                                             }),
//                                             onAddToCart: () {
//                                               final base64Image =
//                                                   base64Encode(imageBytes);
//                                               final cartItem = CartItem(
//                                                 productId: productId,
//                                                 title: name,
//                                                 price: price,
//                                                 quantity: 1,
//                                                 imageUrls: [base64Image],
//                                               );
//                                               inner.read<CartBloc>().add(
//                                                   cart_event.AddToCart(
//                                                       cartItem));
//                                               ScaffoldMessenger.of(inner)
//                                                   .showSnackBar(
//                                                 const SnackBar(
//                                                   content: Text(
//                                                       'Product added to cart!'),
//                                                   duration:
//                                                       Duration(seconds: 1),
//                                                 ),
//                                               );
//                                             },
//                                             cartCount: cartCount,
//                                           ));
//                                     },
//                                   );
//                                 }),
//                             SizedBox(height: 16),
//                           ],
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/common/card_widget.dart';
import 'package:ampify_bloc/repositories/product_repository.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/home/widgets/fetch_categories.dart';

import 'package:ampify_bloc/screens/home/widgets/product_carousel.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_carousel_place_holder.dart';
import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_category_list.dart';
import 'package:ampify_bloc/widgets/shimmer_effects/shimmer_product_card.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart' as cart_event;

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final ProductRepository productRepository;
  // final CarouselSliderController controller = CarouselSliderController();
  int activeIndex = 0;
  Set<String> wishlistedItems = {};
  @override
  void initState() {
    super.initState();
    productRepository = ProductRepository(firestore);
  }

  void toggleWishlist(BuildContext context, String productId,
      Map<String, dynamic> productData) {
    final wishlistBloc = context.read<WishlistBloc>();
    final wishlistState = wishlistBloc.state;

    final isWishlisted = wishlistState is WishlistLoaded &&
        wishlistState.wishlistedItems.contains(productId);

    wishlistBloc.add(
      ToggleWishlistItem(
        productId: productId,
        isCurrentlyWishlisted: isWishlisted,
        productData: productData,
        context: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //C a r o u s e l   B a n n e r
              // ProductCarousel(productStream: productRepository.fetchProducts()),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('banners')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerCarouselPlaceholder();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No banners available'));
                  }

                  return ProductCarousel(documents: snapshot.data!.docs);
                },
              ),

              // StreamBuilder(
              //   stream: productRepository.fetchProducts(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const ShimmerCarouselPlaceholder();
              //     }
              //     // return ProductCarousel(
              //     //     productStream: productRepository.fetchProducts());
              //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //       return const Center(child: Text("No banners available"));
              //     }

              //     return ProductCarousel(documents: snapshot.data!.docs);
              //   },
              // ),

              // F e t c h    C a t e g o r i e s
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CategoryListWidget(firestore: firestore),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('categories').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ShimmerCategoryList();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No categories available'));
                        }

                        return CategoryListWidget(
                          categories: snapshot.data!.docs,
                          firestore: firestore,
                        );
                      },
                    ),
                    // FutureBuilder(
                    //   future: firestore.collection('categories').get(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const ShimmerCategoryList();
                    //     }
                    //     return CategoryListWidget(firestore: firestore);
                    //   },
                    // ),

                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Featured products',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //P R O D U C T    G R I D
                    StreamBuilder<QuerySnapshot>(
                      stream: productRepository.fetchProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) =>
                                const ShimmerProductCard(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products available',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        final products = snapshot.data!.docs;
                        //   final cartState = context.watch<CartBloc>().state;

                        return Column(
                          children: [
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 0.75),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final doc = products[index];
                                  final productId = doc.id;
                                  final name = doc['name'] as String;
                                  final price =
                                      (doc['price'] as num).toDouble();
                                  final images = doc['images'] as List<dynamic>;
                                  // final imageBytes = base64Decode(
                                  //     images.isNotEmpty ? images[0] : '');
                                  Uint8List imageBytes = Uint8List(0);
                                  if (images.isNotEmpty &&
                                      images[0] is String) {
                                    try {
                                      imageBytes = base64Decode(images[0]);
                                    } catch (_) {
                                      imageBytes = Uint8List(0); // fallback
                                    }
                                  }

                                  return Builder(
                                    builder: (inner) {
                                      final isWishlisted = inner
                                          .select<WishlistBloc, bool>((bloc) {
                                        final s = bloc.state;
                                        return s is WishlistLoaded &&
                                            s.wishlistedItems
                                                .contains(productId);
                                      });

                                      final cartState =
                                          inner.watch<CartBloc>().state;
                                      final cartCount = cartState is CartLoaded
                                          ? cartState.cartItems
                                              .where((item) =>
                                                  item.productId == productId)
                                              .fold(
                                                  0,
                                                  (sum, item) =>
                                                      sum + item.quantity)
                                          : 0;
                                      //Product details screen
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              inner,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProductDetailPage(
                                                  productId: productId,
                                                ),
                                              ),
                                            );
                                          },
                                          //Product card
                                          child: CardWidget(
                                            key: ValueKey(productId),
                                            name: name,
                                            price: price,
                                            imageBytes: imageBytes,
                                            isWishlisted: isWishlisted,
                                            productId: productId,
                                            onWishlistToggle: () =>
                                                toggleWishlist(
                                                    inner, productId, {
                                              'name': name,
                                              'price': price,
                                              'imageUrls': images,
                                            }),
                                            onAddToCart: () {
                                              final base64Image =
                                                  base64Encode(imageBytes);
                                              final cartItem = CartItem(
                                                productId: productId,
                                                title: name,
                                                price: price,
                                                quantity: 1,
                                                imageUrls: [base64Image],
                                              );
                                              inner.read<CartBloc>().add(
                                                  cart_event.AddToCart(
                                                      cartItem));
                                              ScaffoldMessenger.of(inner)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Product added to cart!'),
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            cartCount: cartCount,
                                          ));
                                    },
                                  );
                                }),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
