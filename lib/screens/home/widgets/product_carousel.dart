import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCarousel extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  const ProductCarousel({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    List<Widget> imageWidgets = [];

    for (var banner in documents) {
      final imageList = banner['images'] as List<dynamic>;
      for (var base64Image in imageList) {
        try {
          final imageBytes = base64Decode(base64Image);
          imageWidgets.add(
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } catch (e) {
          imageWidgets.add(
            const Center(child: Text('Failed to load image')),
          );
        }
      }
    }

    if (imageWidgets.isEmpty) {
      return const Center(child: Text('No images available'));
    }

    return _CarouselWithIndicator(imageWidgets: imageWidgets);
  }
}

class _CarouselWithIndicator extends StatefulWidget {
  final List<Widget> imageWidgets;

  const _CarouselWithIndicator({required this.imageWidgets});

  @override
  State<_CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<_CarouselWithIndicator> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: Swiper(
            itemBuilder: (context, index) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0,
                child: widget.imageWidgets[index],
              );
            },
            itemCount: widget.imageWidgets.length,
            autoplay: true,
            autoplayDelay: 3000,
            curve: Curves.easeInOut,
            control: const SwiperControl(color: Colors.white70),
            onIndexChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        buildIndicator(widget.imageWidgets.length),
      ],
    );
  }

  Widget buildIndicator(int itemCount) {
    if (itemCount == 0) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
