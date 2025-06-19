// lib/widgets/shimmer_product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductDetailPage extends StatelessWidget {
  const ShimmerProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: screenWidth * 0.6,
                height: 24,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Price shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: screenWidth * 0.3,
                height: 20,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            const SizedBox(height: 30),

            // Description shimmer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: List.generate(5, (index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Button shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
