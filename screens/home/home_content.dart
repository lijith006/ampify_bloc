import 'dart:convert';
import 'dart:typed_data';

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
import 'package:carousel_slider/carousel_slider.dart';
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
  final CarouselSliderController controller = CarouselSliderController();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          //C a r o u s e l >>---------------------------
          ProductCarousel(productStream: productRepository.fetchProducts()),

          // F e t c h    C a t e g o r i e s >>>>>>>>>>>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryListWidget(firestore: firestore),

                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Featured products',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 20),

                //P R O D U C T    G R I D >>>>>>>>---------
                StreamBuilder<QuerySnapshot>(
                  stream: productRepository.fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                    final cartState = context.watch<CartBloc>().state;

                    return GridView.builder(
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
                        var doc = products[index];

                        String name = doc['name'];
                        // double price = doc['price'];

                        double price = (doc['price'] as num).toDouble();
                        final productId = products[index].id;
                        List<dynamic> images = doc['images'];
                        Uint8List imageBytes =
                            base64Decode(images.isNotEmpty ? images[0] : '');

                        final cartCount = cartState is CartLoaded
                            ? cartState.cartItems
                                .where((item) => item.productId == productId)
                                .fold(0, (sum, item) => sum + item.quantity)
                            : 0;

                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    productId: productId,
                                  ),
                                ));
                          },

                          //C a r d     W i d g e t-*->>>>>>>>>>-------
                          child: CardWidget(
                              key: ValueKey(productId),
                              name: product['name'],
                              price: (product['price'] is int)
                                  ? (product['price'] as int).toDouble()
                                  : (product['price'] ?? 0.0),
                              imageBytes: base64Decode(product['images'][0]),
                              isWishlisted: context
                                  .watch<WishlistBloc>()
                                  .state
                                  .wishlistedItems
                                  .contains(productId),
                              productId: productId,

                              //c h e c k   w i s h l i s t e d------>>>--
                              onWishlistToggle: () {
                                print(
                                    "Wishlist Toggle Clicked for Product ID: $productId");

                                final productData = {
                                  'name': product['name'],
                                  'price': product['price'].toDouble(),
                                  'imageUrls': product['images'],
                                };

                                toggleWishlist(context, productId, productData);
                              },
                              onAddToCart: () {
                                //  Uint8List  to  Base64 String
                                final base64Image = base64Encode(imageBytes);

                                // Store as List<String>

                                final cartItem = CartItem(
                                  productId: productId,
                                  title: name,
                                  price: price.toDouble(),
                                  // price: price,
                                  quantity: 1,
                                  imageUrls: [base64Image],
                                );

                                context
                                    .read<CartBloc>()
                                    .add(cart_event.AddToCart(cartItem));
                                print(
                                    "AddToCart event dispatched: ${cartItem.productId}");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Product added to cart!'),
                                  duration: Duration(seconds: 1),
                                ));
                              },
                              cartCount: cartCount),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
