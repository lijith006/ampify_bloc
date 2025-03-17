// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:ampify_bloc/widgets/custom_action_button.dart';
// import 'package:ampify_bloc/widgets/carousel_indicator_buttons.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:clippy_flutter/arc.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductDetailPage extends StatefulWidget {
//   final String productId;

//   const ProductDetailPage({super.key, required this.productId});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   int currentIndex = 0;

//   bool isWishlisted = false;

//   @override
//   void initState() {
//     super.initState();

//     context
//         .read<ProductDetailsBloc>()
//         .add(FetchProductDetails(widget.productId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return BlocListener<ProductDetailsBloc, ProductDetailsState>(
//       listener: (context, state) {
//         if (state is WishlistUpdated) {
//           // Show snackbar when wishlist is updated
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.isWishlisted
//                     ? "Added to Wishlist"
//                     : "Removed from Wishlist",
//               ),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         } else if (state is CartItemAdded) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Added to Cart")),
//           );
//         } else if (state is CartErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text("Something went wrong: ${state.errorMessage}")),
//           );
//         }
//       },
//       child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
//           builder: (context, state) {
//         if (state is ProductDetailsLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (state is ProductDetailsLoaded) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: const Text("Product Details"),
//               backgroundColor: Colors.transparent,
//               actions: [
//                 BlocBuilder<WishlistBloc, WishlistState>(
//                   builder: (context, wishlistState) {
//                     print("Wishlist State: $wishlistState");
//                     final isWishlisted = wishlistState is WishlistLoaded &&
//                         wishlistState.wishlistedItems
//                             .contains(widget.productId);
//                     print(
//                         "Product ${widget.productId} isWishlisted: $isWishlisted");

//                     return IconButton(
//                       icon: Icon(
//                         isWishlisted ? Icons.favorite : Icons.favorite_border,
//                         color: isWishlisted ? Colors.red : Colors.grey,
//                       ),
//                       onPressed: () {
//                         print(
//                             "Toggling Wishlist for Product ID: ${widget.productId}");
//                         context.read<WishlistBloc>().add(
//                               ToggleWishlistItem(
//                                 productId: widget.productId,
//                                 isCurrentlyWishlisted: isWishlisted,
//                                 context: context,
//                                 productData: isWishlisted
//                                     ? null
//                                     : {
//                                         'name': state.productName,
//                                         'price': state.productPrice,
//                                         'imageUrls': state.base64Images,
//                                       },
//                               ),
//                             );
//                       },
//                     );
//                   },
//                 )
//               ],
//             ),
//             body: state.base64Images.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         //I m a g e    C a r o u s e l
//                         CarouselSlider.builder(
//                           itemCount: state.base64Images.length,
//                           options: CarouselOptions(
//                             height: 320,
//                             autoPlay: true,
//                             enlargeCenterPage: true,
//                             viewportFraction: 0.85,
//                             onPageChanged: (index, reason) {
//                               setState(() {
//                                 currentIndex = index;
//                               });
//                             },
//                           ),
//                           itemBuilder: (context, index, realIndex) {
//                             Uint8List imageBytes =
//                                 base64Decode(state.base64Images[index]);
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(15),
//                               child: Image.memory(
//                                 imageBytes,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),

//                         //I m a g e    I n d i c a t o r

//                         CarouselIndicator(
//                           itemCount: state.base64Images.length,
//                           currentIndex: currentIndex,
//                           activeColor: Colors.blue,
//                           inactiveColor: Colors.grey,
//                         ),

//                         const SizedBox(
//                           height: 30,
//                         ),

//                         //A r c
//                         Arc(
//                           height: 30,
//                           edge: Edge.TOP,
//                           arcType: ArcType.CONVEY,
//                           child: Container(
//                             width: double.infinity,
//                             color: const Color.fromARGB(255, 218, 229, 243),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 50, bottom: 20),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Flexible(
//                                           child: Text(
//                                             state.productName,
//                                             style: const TextStyle(
//                                                 fontSize: 30,
//                                                 fontWeight: FontWeight.w900,
//                                                 color: Color.fromARGB(
//                                                     255, 85, 86, 94)),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         Text(
//                                           " \₹${state.productPrice.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.w500,
//                                             color: Color(0xFFFF6F61),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         //D e t a i l s
//                         Container(
//                           width: screenWidth * 10,
//                           color: AppColors.backgroundColor,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 10),

//                                 ConstrainedBox(
//                                   constraints: const BoxConstraints(
//                                     minHeight: 100,
//                                     maxHeight: 200,
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColors.backgroundColor,
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.grey,
//                                         ),
//                                       ],
//                                     ),
//                                     child: SingleChildScrollView(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Text(
//                                         state.productDescription,
//                                         style: const TextStyle(
//                                           fontSize: 15,
//                                           color: AppColors.textcolorCommmonGrey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 20),

//                                 //B u t t o n s
//                                 Container(
//                                   color: AppColors.backgroundColor,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         CustomActionButton(
//                                           label: 'Add to Cart',
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 221, 168, 62),
//                                           onPressed: () {
//                                             final cartItem = CartItem(
//                                               productId: widget.productId,
//                                               title: state.productName,
//                                               price: state.productPrice,
//                                               quantity: 1,
//                                               imageUrls: state.base64Images,
//                                             );
//                                             context
//                                                 .read<ProductDetailsBloc>()
//                                                 .add(AddToCart(
//                                                     cartItem, context));
//                                           },
//                                           icon: Icons.shopping_cart,
//                                         ),
//                                         CustomActionButton(
//                                           label: 'Buy now',
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 218, 229, 243),
//                                           onPressed: () async {
//                                             final cartItem = CartItem(
//                                               productId: widget.productId,
//                                               title: state.productName,
//                                               price: state.productPrice,
//                                               quantity: 1,
//                                               imageUrls: state.base64Images,
//                                             );

//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         CheckoutScreen(
//                                                             products: [
//                                                               cartItem
//                                                             ])));
//                                           },
//                                           icon: Icons.shopping_cart,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//           );
//         } else {
//           return Scaffold(
//             appBar: AppBar(title: const Text("Product Details")),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Something went wrong. Please try again."),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       context
//                           .read<ProductDetailsBloc>()
//                           .add(FetchProductDetails(widget.productId));
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }),
//     );
//   }
// }
//---------------------------march 14 **************************

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:ampify_bloc/widgets/custom_action_button.dart';
// import 'package:ampify_bloc/widgets/carousel_indicator_buttons.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:clippy_flutter/arc.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductDetailPage extends StatefulWidget {
//   final String productId;

//   const ProductDetailPage({super.key, required this.productId});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   int currentIndex = 0;

//   bool isWishlisted = false;

//   @override
//   void initState() {
//     super.initState();

//     context
//         .read<ProductDetailsBloc>()
//         .add(FetchProductDetails(widget.productId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return BlocListener<ProductDetailsBloc, ProductDetailsState>(
//       listener: (context, state) {
//         if (state is WishlistUpdated) {
//           // Show snackbar when wishlist is updated
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.isWishlisted
//                     ? "Added to Wishlist"
//                     : "Removed from Wishlist",
//               ),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         } else if (state is CartItemAdded) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Added to Cart")),
//           );
//         } else if (state is CartErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text("Something went wrong: ${state.errorMessage}")),
//           );
//         }
//       },
//       child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
//           builder: (context, state) {
//         if (state is ProductDetailsLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (state is ProductDetailsLoaded) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: const Text("Product Details"),
//               backgroundColor: Colors.transparent,
//               actions: [
//                 BlocBuilder<WishlistBloc, WishlistState>(
//                   builder: (context, wishlistState) {
//                     print("Wishlist State: $wishlistState");
//                     final isWishlisted = wishlistState is WishlistLoaded &&
//                         wishlistState.wishlistedItems
//                             .contains(widget.productId);
//                     print(
//                         "Product ${widget.productId} isWishlisted: $isWishlisted");

//                     return IconButton(
//                       icon: Icon(
//                         isWishlisted ? Icons.favorite : Icons.favorite_border,
//                         color: isWishlisted ? Colors.red : Colors.grey,
//                       ),
//                       onPressed: () {
//                         print(
//                             "Toggling Wishlist for Product ID: ${widget.productId}");
//                         context.read<WishlistBloc>().add(
//                               ToggleWishlistItem(
//                                 productId: widget.productId,
//                                 isCurrentlyWishlisted: isWishlisted,
//                                 context: context,
//                                 productData: isWishlisted
//                                     ? null
//                                     : {
//                                         'name': state.productName,
//                                         'price': state.productPrice,
//                                         'imageUrls': state.base64Images,
//                                       },
//                               ),
//                             );
//                       },
//                     );
//                   },
//                 )
//               ],
//             ),
//             body: state.base64Images.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         //I m a g e    C a r o u s e l
//                         CarouselSlider.builder(
//                           itemCount: state.base64Images.length,
//                           options: CarouselOptions(
//                             height: 320,
//                             autoPlay: true,
//                             enlargeCenterPage: true,
//                             viewportFraction: 0.85,
//                             onPageChanged: (index, reason) {
//                               setState(() {
//                                 currentIndex = index;
//                               });
//                             },
//                           ),
//                           itemBuilder: (context, index, realIndex) {
//                             Uint8List imageBytes =
//                                 base64Decode(state.base64Images[index]);
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(15),
//                               child: Image.memory(
//                                 imageBytes,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),

//                         //I m a g e    I n d i c a t o r

//                         CarouselIndicator(
//                           itemCount: state.base64Images.length,
//                           currentIndex: currentIndex,
//                           activeColor: Colors.blue,
//                           inactiveColor: Colors.grey,
//                         ),

//                         const SizedBox(
//                           height: 30,
//                         ),

//                         //A r c
//                         Arc(
//                           height: 30,
//                           edge: Edge.TOP,
//                           arcType: ArcType.CONVEY,
//                           child: Container(
//                             width: double.infinity,
//                             color: const Color.fromARGB(255, 218, 229, 243),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 50, bottom: 20),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Flexible(
//                                           child: Text(
//                                             state.productName,
//                                             style: const TextStyle(
//                                                 fontSize: 30,
//                                                 fontWeight: FontWeight.w900,
//                                                 color: Color.fromARGB(
//                                                     255, 85, 86, 94)),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         Text(
//                                           " \₹${state.productPrice.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.w500,
//                                             color: Color(0xFFFF6F61),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         //D e t a i l s
//                         Container(
//                           width: screenWidth * 10,
//                           color: AppColors.backgroundColor,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 10),

//                                 ConstrainedBox(
//                                   constraints: const BoxConstraints(
//                                     minHeight: 100,
//                                     maxHeight: 200,
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColors.backgroundColor,
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.grey,
//                                         ),
//                                       ],
//                                     ),
//                                     child: SingleChildScrollView(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Text(
//                                         state.productDescription,
//                                         style: const TextStyle(
//                                           fontSize: 15,
//                                           color: AppColors.textcolorCommmonGrey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 20),

//                                 //B u t t o n s
//                                 Container(
//                                   color: AppColors.backgroundColor,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         CustomActionButton(
//                                           label: 'Add to Cart',
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 221, 168, 62),
//                                           onPressed: () {
//                                             final cartItem = CartItem(
//                                               productId: widget.productId,
//                                               title: state.productName,
//                                               price: state.productPrice,
//                                               quantity: 1,
//                                               imageUrls: state.base64Images,
//                                             );
//                                             context
//                                                 .read<ProductDetailsBloc>()
//                                                 .add(AddToCart(
//                                                     cartItem, context));
//                                           },
//                                           icon: Icons.shopping_cart,
//                                         ),
//                                         CustomActionButton(
//                                           label: 'Buy now',
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 218, 229, 243),
//                                           onPressed: () async {
//                                             final cartItem = CartItem(
//                                               productId: widget.productId,
//                                               title: state.productName,
//                                               price: state.productPrice,
//                                               quantity: 1,
//                                               imageUrls: state.base64Images,
//                                             );

//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         CheckoutScreen(
//                                                             products: [
//                                                               cartItem
//                                                             ])));
//                                           },
//                                           icon: Icons.shopping_cart,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//           );
//         } else {
//           return Scaffold(
//             appBar: AppBar(title: const Text("Product Details")),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Something went wrong. Please try again."),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       context
//                           .read<ProductDetailsBloc>()
//                           .add(FetchProductDetails(widget.productId));
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }),
//     );
//   }
// }
//0000000000000000000000000000000000000000000000000000000000
import 'dart:typed_data';

import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/widgets/carousel_indicator_buttons.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert'; // For base64 decoding
import 'package:ampify_bloc/common/app_colors.dart'; // Your app's color scheme
import 'package:ampify_bloc/screens/cart/cart_model.dart'; // Cart model
// Wishlist bloc
import 'package:ampify_bloc/widgets/custom_action_button.dart'; // Custom button widget

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentIndex = 0;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ProductDetailsBloc>()
        .add(FetchProductDetails(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        if (state is WishlistUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isWishlisted
                    ? "Added to Wishlist"
                    : "Removed from Wishlist",
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CartItemAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Added to Cart")),
          );
        } else if (state is CartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Something went wrong: ${state.errorMessage}")),
          );
        }
      },
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProductDetailsLoaded) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text("Product Details"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, wishlistState) {
                      final isWishlisted = wishlistState is WishlistLoaded &&
                          wishlistState.wishlistedItems
                              .contains(widget.productId);
                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<WishlistBloc>().add(
                                ToggleWishlistItem(
                                  productId: widget.productId,
                                  isCurrentlyWishlisted: isWishlisted,
                                  context: context,
                                  productData: isWishlisted
                                      ? null
                                      : {
                                          'name': state.productName,
                                          'price': state.productPrice,
                                          'imageUrls': state.base64Images,
                                        },
                                ),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
              body: state.base64Images.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Carousel
                          CarouselSlider.builder(
                            itemCount: state.base64Images.length,
                            options: CarouselOptions(
                              height: 320,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              Uint8List imageBytes =
                                  base64Decode(state.base64Images[index]);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),

                          // Image Indicator
                          CarouselIndicator(
                            itemCount: state.base64Images.length,
                            currentIndex: currentIndex,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                          ),

                          const SizedBox(height: 30),

                          // Arc Design
                          Arc(
                            height: 30,
                            edge: Edge.TOP,
                            arcType: ArcType.CONVEY,
                            child: Container(
                              width: double.infinity,
                              color: const Color.fromARGB(255, 218, 229, 243),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              state.productName,
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(
                                                      255, 85, 86, 94)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            " \₹${state.productPrice.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFFF6F61),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Product Details
                          Container(
                            width: screenWidth * 10,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),

                                  // Product Description
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 100,
                                      maxHeight: 200,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          state.productDescription,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color:
                                                AppColors.textcolorCommmonGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Buttons
                                  Container(
                                    color: AppColors.backgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomActionButton(
                                            label: 'Add to Cart',
                                            backgroundColor: Colors.orange,
                                            onPressed: () {
                                              final cartItem = CartItem(
                                                productId: widget.productId,
                                                title: state.productName,
                                                price: state.productPrice,
                                                quantity: 1,
                                                imageUrls: state.base64Images,
                                              );
                                              context
                                                  .read<ProductDetailsBloc>()
                                                  .add(AddToCart(
                                                      cartItem, context));
                                            },
                                            icon: Icons.shopping_cart,
                                          ),
                                          CustomActionButton(
                                            label: 'Buy now',
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 218, 229, 243),
                                            onPressed: () async {
                                              final cartItem = CartItem(
                                                productId: widget.productId,
                                                title: state.productName,
                                                price: state.productPrice,
                                                quantity: 1,
                                                imageUrls: state.base64Images,
                                              );

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckoutScreen(
                                                              products: [
                                                                cartItem
                                                              ])));
                                            },
                                            icon: Icons.shopping_cart,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text("Product Details")),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Something went wrong. Please try again."),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductDetailsBloc>()
                            .add(FetchProductDetails(widget.productId));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
