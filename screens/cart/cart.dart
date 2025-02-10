import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/cart/saved_items_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCart extends StatefulWidget {
  //************* */

  const MyCart({
    super.key,
  });

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(
        child: Text('Please log in'),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Your cart is empty 😔'));
            }
            final cartItems = snapshot.data!.docs.map((doc) {
              return CartItem.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            return Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedItemsScreen(
                              moveToCart: (CartItem) {},
                            ),
                          ));
                    },
                    child: const Text('Saved items')),
                Expanded(child: buildCartList(cartItems)),
                buildTotalSection(cartItems),
                //save later call
              ],
            );
          },
        ));
  }

//Cart section
  Widget buildCartList(List<CartItem> cartItems) {
    DateTime estimatedDeliveryDate =
        DateTime.now().add(const Duration(days: 7));
    String formattedDate =
        "${estimatedDeliveryDate.day}-${estimatedDeliveryDate.month}-${estimatedDeliveryDate.year}";
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    decodeBase64Image(item.imageUrls.first),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title  and price
                    Text(
                      item.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('₹${item.price}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    Text(
                      'Estimated Delivery: $formattedDate',
                      style: const TextStyle(
                        color: Color.fromARGB(90, 12, 12, 12),
                      ),
                    ),

                    //add & remove quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => updateQuantity(item, -1),
                            icon: const Icon(Icons.remove)),
                        Text("${item.quantity}"),
                        IconButton(
                            onPressed: () => updateQuantity(item, 1),
                            icon: const Icon(Icons.add)),
                        //Save for later
                        TextButton(
                          onPressed: () {
                            saveForLater(item);
                          },
                          child: const Text('Save for Later',
                              style: TextStyle(color: Colors.blue)),
                        )
                      ],
                    )
                  ],
                )),
                // Remove product
                // IconButton(
                //     onPressed: () => removeFromCart(item.productId),
                //     icon: const Icon(
                //       Icons.delete,
                //       color: Colors.red,
                //     )),
              ],
            ),
          ),
        );
      },
    );
  }

//image
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

//bottom total section
  Widget buildTotalSection(List<CartItem> cartItems) {
    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('₹$total',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(height: 10),

          //New "View Saved Items" button
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.blueAccent,
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => SavedItemsScreen(
          //                   savedItems: savedItems,
          //                   moveToCart: widget.moveToCart,
          //                   // moveToCart: (item) {
          //                   //   setState(() {
          //                   //     savedItems.remove(item);
          //                   //     cartItems.add(item);
          //                   //   });
          //                   // },
          //                 )));
          //   },
          //   child: const Text(
          //     'View Saved Items',
          //     style: TextStyle(fontSize: 16, color: Colors.white),
          //   ),
          // ),
          const SizedBox(height: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
            onPressed: () => print('Proceed to Buy'),
            child: const Text(
              'Proceed to Buy',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

//Update section
  Future<void> updateQuantity(CartItem item, int change) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    int newQuantity = item.quantity + change;
    if (newQuantity > 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.productId)
          .update({'quantity': newQuantity});
    }
  }

//Save for later
  Future<void> saveForLater(CartItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    final savedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('saved');
    //Remove from cart
    await cartRef.doc(item.productId).delete();
    //Add to save for later
    await savedRef.doc(item.productId).set(item.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item saved for later!')),
    );
  }

//Remove Product Logic
  Future<void> removeFromCart(String productId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}
