// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/checkoutScreen/checkout_screen.dart';
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

//   @override
//   void initState() {
//     super.initState();
//     fetchProductDetails();
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

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     // double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         backgroundColor: Colors.transparent,
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

//                     color: const Color.fromARGB(255, 217, 241, 239),
//                     // color: Color(0XFF202224),

//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 10),

//                           // Product Description
//                           Text(
//                             productDescription,
//                             style: const TextStyle(
//                                 fontSize: 15, color: Colors.black),
//                           ),
//                           const SizedBox(height: 20),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               CustomActionButton(
//                                 label: 'Add to Cart',
//                                 backgroundColor: Colors.blue,
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
//                                 backgroundColor: Colors.orange,
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
//********************************************************** */

import 'dart:convert';
import 'dart:typed_data';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/checkoutScreen/checkout_screen.dart';
import 'package:ampify_bloc/widgets/custom_action_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentIndex = 0;
  List<String> base64Images = [];
  String productName = "";
  String productDescription = "";
  double productPrice = 0.0;
  bool isLoading = true;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    checkIfWishlisted();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        final productData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          base64Images = List<String>.from(productData['images'] ?? []);
          productName = productData['name'] ?? "No Name";
          productDescription =
              productData['description'] ?? "No description available";
          productPrice = (productData['price'] ?? 0.0).toDouble();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products details:$e');
    }
  }

//check Wishlisted items
  Future<void> checkIfWishlisted() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(widget.productId)
        .get();

    setState(() {
      isWishlisted = doc.exists;
    });
  }

  //Add or remove wishlist
  Future<void> toggleWishlist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(widget.productId);
    if (isWishlisted) {
      // Remove from wishlist
      await wishlistRef.delete();
      setState(() {
        isWishlisted = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Removed from Wishlist')));
    } else {
      // Add to wishlist
      await wishlistRef.set({
        'productId': widget.productId,
        'name': productName,
        'price': productPrice,
        'imageUrls': base64Images,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        isWishlisted = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added to Wishlist')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.grey,
            ),
            onPressed: toggleWishlist,
          ),
        ],
      ),
      body: base64Images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: base64Images.length,
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
                      Uint8List imageBytes = base64Decode(base64Images[index]);
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
                      color: const Color.fromARGB(255, 123, 168, 228),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 50, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      productName,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    " \₹${productPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
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

                    color: const Color.fromARGB(255, 217, 241, 239),
                    // color: Color(0XFF202224),

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // Product Description
                          Text(
                            productDescription,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomActionButton(
                                label: 'Add to Cart',
                                backgroundColor: Colors.blue,
                                onPressed: () {
                                  final cartItem = CartItem(
                                    productId: widget.productId,
                                    title: productName,
                                    price: productPrice,
                                    quantity: 1,
                                    imageUrls: base64Images,
                                  );
                                  addToCart(cartItem);
                                },
                                icon: Icons.shopping_cart,
                              ),
                              CustomActionButton(
                                label: 'Buy now',
                                backgroundColor: Colors.orange,
                                onPressed: () {
                                  final cartItem = CartItem(
                                    productId: widget.productId,
                                    title: productName,
                                    price: productPrice,
                                    quantity: 1,
                                    imageUrls: base64Images,
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                              product: cartItem)));
                                },
                                icon: Icons.shopping_cart,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> addToCart(CartItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');
    final docSnapshot = await cartRef.doc(item.productId).get();
    if (docSnapshot.exists) {
      //if the item already in cart-
      final existingData = docSnapshot.data();
      final currentQuantity = existingData?['quantity'] ?? 0;
      await cartRef
          .doc(item.productId)
          .update({'quantity': currentQuantity + 1});
    } else {
      //If the item is new
      await cartRef.doc(item.productId).set(item.toMap());
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to cart!')),
    );
  }
}
