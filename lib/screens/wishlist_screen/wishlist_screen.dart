// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/common/card_widget.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:ampify_bloc/widgets/custom_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Scaffold(
//         body: Center(child: Text('Please log in to see wishlist')),
//       );
//     }

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const CustomAppBar(title: 'Wishlist'),
//       body: BlocBuilder<WishlistBloc, WishlistState>(
//         builder: (context, state) {
//           if (state is WishlistLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is WishlistError) {
//             return Center(child: Text(state.message));
//           }

//           if (state is WishlistLoaded && state.wishlist.isEmpty) {
//             print("Wishlist items: ${state.wishlist.length}");
//             return const Center(child: Text('No items in wishlist.'));
//           }

//           if (state is WishlistLoaded) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemCount: state.wishlist.length,
//                 itemBuilder: (context, index) {
//                   var doc = state.wishlist[index];
//                   print("Wishlist item: ${doc.data()}");
//                   String productId = doc['productId'];
//                   String name = doc['name'];
//                   double price = doc['price'];
//                   List<dynamic> images = doc['imageUrls'];
//                   Uint8List imageBytes =
//                       base64Decode(images.isNotEmpty ? images[0] : '');

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ProductDetailPage(productId: productId),
//                         ),
//                       );
//                     },
//                     child: CardWidget(
//                       imageBytes: imageBytes,
//                       name: name,
//                       price: price,
//                       isWishlisted: true,
//                       productId: productId,
//                       cartCount: context.watch<CartBloc>().state is CartLoaded
//                           ? (context.watch<CartBloc>().state as CartLoaded)
//                               .cartItems
//                               .where((item) => item.productId == productId)
//                               .fold(0, (sum, item) => sum + item.quantity)
//                           : 0,
//                       onWishlistToggle: () {
//                         context.read<WishlistBloc>().add(
//                               ToggleWishlistItem(
//                                 productId: productId,
//                                 isCurrentlyWishlisted: true,
//                                 context: context,
//                                 productData: {
//                                   'name': name,
//                                   'price': price,
//                                   'imageUrls': [base64Encode(imageBytes)],
//                                 },
//                               ),
//                             );
//                       },
//                       onAddToCart: () {
//                         // Convert Uint8List to Base64 String
//                         final base64Image = base64Encode(imageBytes);

//                         // Store as List<String>

//                         final cartItem = CartItem(
//                           productId: productId,
//                           title: name,
//                           price: price,
//                           quantity: 1,
//                           imageUrls: [base64Image],
//                         );

//                         context.read<CartBloc>().add(AddToCart(cartItem));

//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Item added to cart!')));
//                       },
//                     ),
//                   );
//                 },
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
//---------------------------------jun 17
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/screens/wishlist_screen/wishlist_widgets/wishlist_item_card.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: const CustomAppBar(title: 'Wishlist'),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        buildWhen: (previous, current) =>
            current is WishlistLoaded || current is WishlistError,
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
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              key: PageStorageKey('wishlist_grid'),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: state.wishlist.length,
              itemBuilder: (context, index) {
                final doc = state.wishlist[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: WishlistItemCard(
                    key: ValueKey(doc.id), //keeping each card's state
                    docId: doc.id,
                    data: doc.data() as Map<String, dynamic>,
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
