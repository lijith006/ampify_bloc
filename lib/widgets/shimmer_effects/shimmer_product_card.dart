import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 200,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 150,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 100,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
