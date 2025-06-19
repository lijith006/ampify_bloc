// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/card_widget.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WishlistItemCard extends StatelessWidget {
//   final String docId;
//   final Map<String, dynamic> data;

//   const WishlistItemCard({
//     super.key, // Required for tracking in GridView.builder
//     required this.docId,
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final String name = data['name'];
//     final double price = data['price'];
//     final List<dynamic> imageUrls = data['imageUrls'];
//     final Uint8List imageBytes =
//         base64Decode(imageUrls.isNotEmpty ? imageUrls[0] : '');

//     return BlocBuilder<CartBloc, CartState>(
//       buildWhen: (previous, current) {
//         if (previous is CartLoaded && current is CartLoaded) {
//           final prevQty = previous.cartItems
//               .where((item) => item.productId == docId)
//               .fold(0, (sum, item) => sum + item.quantity);

//           final currQty = current.cartItems
//               .where((item) => item.productId == docId)
//               .fold(0, (sum, item) => sum + item.quantity);

//           return prevQty != currQty;
//         }
//         return true;
//       },
//       builder: (context, cartState) {
//         final cartCount = cartState is CartLoaded
//             ? cartState.cartItems
//                 .where((item) => item.productId == docId)
//                 .fold(0, (sum, item) => sum + item.quantity)
//             : 0;

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProductDetailPage(productId: docId),
//               ),
//             );
//           },
//           child: CardWidget(
//             imageBytes: imageBytes,
//             name: name,
//             price: price,
//             isWishlisted: true,
//             productId: docId,
//             cartCount: cartCount,
//             onWishlistToggle: () {
//               context.read<WishlistBloc>().add(
//                     ToggleWishlistItem(
//                       productId: docId,
//                       isCurrentlyWishlisted: true,
//                       context: context,
//                       productData: {
//                         'name': name,
//                         'price': price,
//                         'imageUrls': [base64Encode(imageBytes)],
//                       },
//                     ),
//                   );
//             },
//             onAddToCart: () {
//               final base64Image = base64Encode(imageBytes);
//               final cartItem = CartItem(
//                 productId: docId,
//                 title: name,
//                 price: price,
//                 quantity: 1,
//                 imageUrls: [base64Image],
//               );

//               context.read<CartBloc>().add(AddToCart(cartItem));

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Item added to cart!')),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/card_widget.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistItemCard extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const WishlistItemCard({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<WishlistItemCard> createState() => _WishlistItemCardState();
}

class _WishlistItemCardState extends State<WishlistItemCard> {
  late final Uint8List imageBytes;

  @override
  void initState() {
    super.initState();
    final imageUrls = widget.data['imageUrls'] as List<dynamic>;
    imageBytes = base64Decode(imageUrls.isNotEmpty ? imageUrls[0] : '');
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.data['name'];
    final double price = widget.data['price'];
    final String productId = widget.docId;

    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) {
        if (prev is CartLoaded && curr is CartLoaded) {
          final prevQty = prev.cartItems
              .where((item) => item.productId == productId)
              .fold(0, (sum, item) => sum + item.quantity);
          final currQty = curr.cartItems
              .where((item) => item.productId == productId)
              .fold(0, (sum, item) => sum + item.quantity);
          return prevQty != currQty;
        }
        return true;
      },
      builder: (context, cartState) {
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
            imageBytes: imageBytes,
            name: name,
            price: price,
            isWishlisted: true,
            productId: productId,
            cartCount: cartCount,
            onWishlistToggle: () {
              context.read<WishlistBloc>().add(
                    ToggleWishlistItem(
                      productId: productId,
                      isCurrentlyWishlisted: true,
                      context: context,
                      productData: {
                        'name': name,
                        'price': price,
                        'imageUrls': [base64Encode(imageBytes)],
                      },
                    ),
                  );
            },
            onAddToCart: () {
              final cartItem = CartItem(
                productId: productId,
                title: name,
                price: price,
                quantity: 1,
                imageUrls: [base64Encode(imageBytes)],
              );

              context.read<CartBloc>().add(AddToCart(cartItem));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item added to cart!')),
              );
            },
          ),
        );
      },
    );
  }
}
