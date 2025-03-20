// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/common/card_widget.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
// import 'package:ampify_bloc/screens/categories/categories.dart';
// import 'package:ampify_bloc/screens/home/bloc/home_event.dart';
// import 'package:ampify_bloc/screens/home/bloc/home_state.dart';
// import 'package:ampify_bloc/screens/home/widgets/product_carousel.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeContent extends StatelessWidget {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   HomeContent({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => HomeBloc(
//         firestore: FirebaseFirestore.instance,
//       )..add(FetchHomeData()),
//       child: const HomeContentView(),
//     );
//   }
// }

// class HomeContentView extends StatelessWidget {
//   const HomeContentView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (state is HomeLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is HomeError) {
//           return Center(child: Text('Error: ${state.message}'));
//         } else if (state is HomeLoaded) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 ProductCarousel(
//                   productStream: FirebaseFirestore.instance
//                       .collection('banners')
//                       .snapshots(),
//                 ),

//                 // Categories
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('C a t e g o r i e s',
//                           style: AppWidget.boldCardTitle()),
//                       const SizedBox(height: 5),
//                       _buildCategoriesSection(context, state.categories),
//                       const SizedBox(height: 5),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'F e a t u r e d   p r o d u c t s',
//                           style: AppWidget.boldCardTitle(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildProductsGrid(context, state.products),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         // Default loading state
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget _buildCategoriesSection(
//       BuildContext context, List<DocumentSnapshot> categories) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BlocProvider(
//                     create: (context) => CategoriesBloc(
//                       firestore: FirebaseFirestore.instance,
//                     )..add(FetchProducts(category.id)),
//                     child: Categories(
//                       categoryId: category.id,
//                       categoryName: category['name'],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: MemoryImage(base64Decode(category['image'])),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(category['name']),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductsGrid(
//       BuildContext context, List<DocumentSnapshot> products) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];
//         final productId = product.id;
//         String name = product['name'];
//         double price = product['price'];
//         List<dynamic> images = product['images'];
//         Uint8List imageBytes = base64Decode(images.isNotEmpty ? images[0] : '');

//         // Get cart count from CartBloc
//         final cartState = context.watch<CartBloc>().state;
//         final cartCount = cartState is CartLoaded
//             ? cartState.cartItems
//                 .where((item) => item.productId == productId)
//                 .fold(0, (sum, item) => sum + item.quantity)
//             : 0;

//         // Get wishlist status from WishlistBloc
//         final isWishlisted =
//             context.watch<WishlistBloc>().state is WishlistLoaded &&
//                 (context.watch<WishlistBloc>().state as WishlistLoaded)
//                     .wishlistedItems
//                     .contains(productId);

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProductDetailPage(productId: productId),
//               ),
//             );
//           },
//           child: CardWidget(
//             key: ValueKey(productId),
//             name: name,
//             price: price,
//             imageBytes: imageBytes,
//             isWishlisted: isWishlisted,
//             productId: productId,
//             onWishlistToggle: () {
//               final productData = {
//                 'name': name,
//                 'price': price,
//                 'imageUrls': images,
//               };

//               context.read<WishlistBloc>().add(
//                     ToggleWishlistItem(
//                       productId: productId,
//                       isCurrentlyWishlisted: isWishlisted,
//                       productData: productData,
//                       context: context,
//                     ),
//                   );
//             },
//             onAddToCart: () {
//               // Convert Uint8List to Base64 String
//               final base64Image = base64Encode(imageBytes);

//               final cartItem = CartItem(
//                 productId: productId,
//                 title: name,
//                 price: price,
//                 quantity: 1,
//                 imageUrls: [base64Image],
//               );

//               context.read<CartBloc>().add(AddToCart(cartItem));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Product added to cart!')),
//               );
//             },
//             cartCount: cartCount,
//           ),
//         );
//       },
//     );
//   }
// }
