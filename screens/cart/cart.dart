import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

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
          title: const Text('Cart'),
          // ... other app bar properties
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
              return const Center(
                child: Text('Cart is empty'),
              );
            }
            final cartItems = snapshot.data!.docs.map((doc) {
              return CartItem.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                // Uint8List imageBytes = base64Decode(item.imageUrls.first);
                Uint8List? imageBytes;
                if (item.imageUrls.isNotEmpty) {
                  imageBytes = base64Decode(item.imageUrls.first);
                }

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  leading: (item.imageUrls.isNotEmpty &&
                          item.imageUrls.first.isNotEmpty)
                      ? Image.memory(
                          base64Decode(item.imageUrls.first),
                          width: 50,
                          height: 50,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(item.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('₹${item.price} x ${item.quantity}'),
                  trailing: IconButton(
                      onPressed: () {
                        removeFromCart(item.productId);
                      },
                      icon: const Icon(Icons.delete)),
                );
              },
            );
          },
        ));
  }

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
