// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/widgets/custom_action_button.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:clippy_flutter/arc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ProductDetailPage extends StatefulWidget {
//   final String productId;

//   const ProductDetailPage({super.key, required this.productId});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   int currentIndex = 0;
//   List<String> base64Images = [];
//   String productName = "";
//   String productDescription = "";
//   double productPrice = 0.0;
//   bool isLoading = true;
//   bool isWishlisted = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchProductDetails();
//     checkIfWishlisted();
//   }

//   Future<void> fetchProductDetails() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .doc(widget.productId)
//           .get();

//       if (snapshot.exists) {
//         final productData = snapshot.data() as Map<String, dynamic>;
//         setState(() {
//           base64Images = List<String>.from(productData['images'] ?? []);
//           productName = productData['name'] ?? "No Name";
//           productDescription =
//               productData['description'] ?? "No description available";
//           productPrice = (productData['price'] ?? 0.0).toDouble();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching products details:$e');
//     }
//   }

// //check Wishlisted items
//   Future<void> checkIfWishlisted() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('wishlist')
//         .doc(widget.productId)
//         .get();

//     setState(() {
//       isWishlisted = doc.exists;
//     });
//   }

//   //Add or remove wishlist
//   Future<void> toggleWishlist() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final wishlistRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('wishlist')
//         .doc(widget.productId);
//     if (isWishlisted) {
//       // Remove from wishlist
//       await wishlistRef.delete();
//       setState(() {
//         isWishlisted = false;
//       });
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Removed from Wishlist')));
//     } else {
//       // Add to wishlist
//       await wishlistRef.set({
//         'productId': widget.productId,
//         'name': productName,
//         'price': productPrice,
//         'imageUrls': base64Images,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       setState(() {
//         isWishlisted = true;
//       });
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Added to Wishlist')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         backgroundColor: Colors.transparent,
//         actions: [
//           IconButton(
//             icon: Icon(
//               isWishlisted ? Icons.favorite : Icons.favorite_border,
//               color: isWishlisted ? Colors.red : Colors.grey,
//             ),
//             onPressed: toggleWishlist,
//           ),
//         ],
//       ),
//       body: base64Images.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               // padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CarouselSlider.builder(
//                     itemCount: base64Images.length,
//                     options: CarouselOptions(
//                       height: 320,
//                       autoPlay: true,
//                       enlargeCenterPage: true,
//                       viewportFraction: 0.85,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           currentIndex = index;
//                         });
//                       },
//                     ),
//                     itemBuilder: (context, index, realIndex) {
//                       Uint8List imageBytes = base64Decode(base64Images[index]);
//                       return ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: Image.memory(
//                           imageBytes,
//                           fit: BoxFit.cover,
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Arc(
//                     height: 30,
//                     edge: Edge.TOP,
//                     arcType: ArcType.CONVEY,
//                     child: Container(
//                       width: double.infinity,
//                       color: const Color.fromARGB(255, 123, 168, 228),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 50, bottom: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Flexible(
//                                     child: Text(
//                                       productName,
//                                       style: const TextStyle(
//                                           fontSize: 30,
//                                           fontWeight: FontWeight.w900,
//                                           color: Colors.white),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Text(
//                                     " \₹${productPrice.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                         fontSize: 23,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: screenWidth * 10,

//                     // color: const Color.fromARGB(255, 217, 241, 239),
//                     color: AppColors.backgroundColor,

//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 10),

//                           // Product Description
//                           Text(
//                             productDescription,
//                             style: const TextStyle(
//                                 fontSize: 15,
//                                 color: AppColors.textcolorCommmonGrey),
//                           ),
//                           const SizedBox(height: 20),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               CustomActionButton(
//                                 label: 'Add to Cart',
//                                 backgroundColor: const Color(0xFF1A73E8),
//                                 onPressed: () {
//                                   final cartItem = CartItem(
//                                     productId: widget.productId,
//                                     title: productName,
//                                     price: productPrice,
//                                     quantity: 1,
//                                     imageUrls: base64Images,
//                                   );
//                                   addToCart(cartItem);
//                                 },
//                                 icon: Icons.shopping_cart,
//                               ),
//                               CustomActionButton(
//                                 label: 'Buy now',
//                                 backgroundColor: const Color(0xFFFF6F61),
//                                 onPressed: () {
//                                   final cartItem = CartItem(
//                                     productId: widget.productId,
//                                     title: productName,
//                                     price: productPrice,
//                                     quantity: 1,
//                                     imageUrls: base64Images,
//                                   );
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => CheckoutScreen(
//                                               product: cartItem)));
//                                 },
//                                 icon: Icons.shopping_cart,
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> addToCart(CartItem item) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final cartRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart');
//     final docSnapshot = await cartRef.doc(item.productId).get();
//     if (docSnapshot.exists) {
//       //if the item already in cart-
//       final existingData = docSnapshot.data();
//       final currentQuantity = existingData?['quantity'] ?? 0;
//       await cartRef
//           .doc(item.productId)
//           .update({'quantity': currentQuantity + 1});
//     } else {
//       //If the item is new
//       await cartRef.doc(item.productId).set(item.toMap());
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Product added to cart!')),
//     );
//   }
// }
//**************************************************** */
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
// import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
// import 'package:ampify_bloc/widgets/custom_action_button.dart';
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
//     // _onSubscribeToProductDetails();

//     context
//         .read<ProductDetailsBloc>()
//         .add(FetchProductDetails(widget.productId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return BlocListener<ProductDetailsBloc, ProductDetailsState>(
//       listener: (context, state) {
//         // TODO: implement listener
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
//                 IconButton(
//                   icon: Icon(
//                     state.isWishlisted ? Icons.favorite : Icons.favorite_border,
//                     color: state.isWishlisted ? Colors.red : Colors.grey,
//                   ),
//                   onPressed: () {
//                     context.read<ProductDetailsBloc>().add(
//                           ToggleWishlist(
//                               widget.productId, state.isWishlisted, context),
//                         );
//                   },
//                 ),
//               ],
//             ),
//             body: state.base64Images.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                     // padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
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
//                           height: 30,
//                         ),
//                         Arc(
//                           height: 30,
//                           edge: Edge.TOP,
//                           arcType: ArcType.CONVEY,
//                           child: Container(
//                             width: double.infinity,
//                             // color: const Color.fromARGB(255, 123, 168, 228),
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
//                                                 // color: AppColors
//                                                 //     .textcolorCommmonGrey
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
//                                             //  Color.fromARGB(
//                                             //     255, 255, 120, 120)
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
//                         Container(
//                           width: screenWidth * 10,

//                           // color: const Color.fromARGB(255, 217, 241, 239),
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

//                                 // Product Description
//                                 // Text(
//                                 //   state.productDescription,
//                                 //   style: const TextStyle(
//                                 //       fontSize: 15,
//                                 //       color: AppColors.textcolorCommmonGrey),
//                                 // ),
//                                 // const SizedBox(height: 20),

// //Buttons
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
//                                               255, 218, 229, 243),
//                                           // const Color(0xFF1A73E8),
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
//                                           backgroundColor:
//                                               const Color(0xFFFF6F61),
//                                           onPressed: () {
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
//                                                             product:
//                                                                 cartItem)));
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
///************************************************* */
///
///import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkout_screen.dart';
import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/widgets/custom_action_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/arc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        // TODO: implement listener
        if (state is WishlistUpdated) {
          // Show snackbar when wishlist is updated
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
          // final productId = widget.productId;
          // final productName = state.productName;
          // final productPrice = state.productPrice;
          // final base64Images = state.base64Images;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Product Details"),
              backgroundColor: Colors.transparent,
              actions: [
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wishlistState) {
                    final isWishlisted = wishlistState is WishlistLoaded &&
                        wishlistState.wishlistedItems
                            .contains(widget.productId);
                    // bool isWishlisted =
                    //     state.wishlistedItems.contains(widget.productId);
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
                )

                // IconButton(
                //   icon: Icon(
                //     state.isWishlisted ? Icons.favorite : Icons.favorite_border,
                //     color: state.isWishlisted ? Colors.red : Colors.grey,
                //   ),
                //   onPressed: () {
                //     context.read<ProductDetailsBloc>().add(
                //           ToggleWishlist(
                //               widget.productId, state.isWishlisted, context),
                //         );
                //   },
                // ),
              ],
            ),
            body: state.base64Images.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    // padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(
                          height: 30,
                        ),
                        Arc(
                          height: 30,
                          edge: Edge.TOP,
                          arcType: ArcType.CONVEY,
                          child: Container(
                            width: double.infinity,
                            // color: const Color.fromARGB(255, 123, 168, 228),
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
                                                // color: AppColors
                                                //     .textcolorCommmonGrey
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
                                            //  Color.fromARGB(
                                            //     255, 255, 120, 120)
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth * 10,

                          // color: const Color.fromARGB(255, 217, 241, 239),
                          color: AppColors.backgroundColor,

                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),

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
                                          color: AppColors.textcolorCommmonGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Product Description
                                // Text(
                                //   state.productDescription,
                                //   style: const TextStyle(
                                //       fontSize: 15,
                                //       color: AppColors.textcolorCommmonGrey),
                                // ),
                                // const SizedBox(height: 20),

//Buttons
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
                                          backgroundColor: const Color.fromARGB(
                                              255, 218, 229, 243),
                                          // const Color(0xFF1A73E8),
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
                                              const Color(0xFFFF6F61),
                                          onPressed: () {
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
                                                            product:
                                                                cartItem)));
                                          },
                                          icon: Icons.shopping_cart,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
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
      }),
    );
  }
}
