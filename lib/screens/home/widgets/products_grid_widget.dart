import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/card_widget.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart' as cart_event;
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductGridWidget extends StatelessWidget {
  final FirebaseFirestore firestore;

  const ProductGridWidget({Key? key, required this.firestore})
      : super(key: key);

  Stream<QuerySnapshot> _fetchProducts() {
    return firestore.collection('products').snapshots();
  }

  void _toggleWishlist(
    BuildContext context,
    String productId,
    Map<String, dynamic> productData,
  ) {
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

  Widget _buildProductItem(
      BuildContext context, DocumentSnapshot doc, dynamic cartState) {
    final productId = doc.id;
    String name = doc['name'];
    // Support for different numeric types
    double price = (doc['price'] is int)
        ? (doc['price'] as int).toDouble()
        : (doc['price'] ?? 0.0);

    List<dynamic> images = doc['images'];
    Uint8List imageBytes = base64Decode(images.isNotEmpty ? images[0] : '');

    final cartCount = cartState is CartLoaded
        ? cartState.cartItems
            .where((item) => item.productId == productId)
            .fold(0, (sum, item) => sum + item.quantity)
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: productId),
          ),
        );
      },
      child: CardWidget(
        key: ValueKey(productId),
        name: name,
        price: price,
        imageBytes: imageBytes,
        isWishlisted: context
            .watch<WishlistBloc>()
            .state
            .wishlistedItems
            .contains(productId),
        productId: productId,
        onWishlistToggle: () {
          final productData = {
            'name': name,
            'price': price,
            'imageUrls': doc['images'],
          };
          _toggleWishlist(context, productId, productData);
        },
        onAddToCart: () {
          final base64Image = base64Encode(imageBytes);
          final cartItem = CartItem(
            productId: productId,
            title: name,
            price: price,
            quantity: 1,
            imageUrls: [base64Image],
          );
          context.read<CartBloc>().add(cart_event.AddToCart(cartItem));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Product added to cart!'),
            duration: Duration(seconds: 1),
          ));
        },
        cartCount: cartCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No products available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }
        final products = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductItem(context, products[index], cartState);
          },
        );
      },
    );
  }
}
