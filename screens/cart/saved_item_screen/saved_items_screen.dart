import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/saved_item_screen/bloc/saved_items_bloc.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text('Please log in'));
    }

    return BlocProvider(
      create: (context) => SavedItemsBloc()..add(LoadSavedItems()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(title: const Text('Saved Items')),
        body: BlocBuilder<SavedItemsBloc, SavedItemsState>(
          builder: (context, state) {
            if (state is SavedItemsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavedItemsLoaded) {
              final savedItems = state.savedItems;

              if (savedItems.isEmpty) {
                return const Center(child: Text('No saved items yet.'));
              }

              return ListView.builder(
                itemCount: savedItems.length,
                itemBuilder: (context, index) {
                  final item = savedItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: item.productId),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                                    style: AppWidget.boldCardTitle(),
                                  ),
                                  Text('₹${item.price}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColorOrange,
                              ),
                              onPressed: () {
                                final cartBloc = context.read<CartBloc>();

                                context
                                    .read<SavedItemsBloc>()
                                    .add(MoveToCart(item, cartBloc));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Item moved to cart!')),
                                );
                              },
                              child: const Text(
                                'Move to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Failed to load saved items.'));
            }
          },
        ),
      ),
    );
  }

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
