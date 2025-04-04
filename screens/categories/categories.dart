import 'dart:convert';

import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_state.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const Categories(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('C a t e g o r y'),
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoriesError) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is CategoriesLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No product available in this category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          //   final products = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final productId = products[index].id;

              final product = products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(productId: productId),
                      ));
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode(product['images'][0]),
                                ),
                                fit: BoxFit.contain)),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              product['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\₹${product['price']}',
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text('Initial state'),
          );
        }
      }),
    );
  }
}
