// lib/widgets/shimmer_carousel_placeholder.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCarouselPlaceholder extends StatelessWidget {
  const ShimmerCarouselPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
