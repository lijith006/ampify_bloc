import 'dart:convert';
// import 'package:ampify_bloc/widgets/carousel_indicator_buttons.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class ProductCarousel extends StatefulWidget {
  final Stream<QuerySnapshot> productStream;

  const ProductCarousel({
    Key? key,
    required this.productStream,
    //required List<DocumentSnapshot<Object?>> products,
  }) : super(key: key);

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int currentIndex = 0;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CarouselSliderController controller = CarouselSliderController();

  Stream<QuerySnapshot> fetchBanners() {
    return firestore.collection('banners').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchBanners(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 250,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final banners = snapshot.data!.docs;

        // Flatten the list of images
        List<Widget> imageWidgets = [];
        for (var banner in banners) {
          final imageList = banner['images'] as List<dynamic>;
          for (var base64Image in imageList) {
            try {
              final imageBytes = base64Decode(base64Image);
              imageWidgets.add(
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: MemoryImage(imageBytes),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } catch (e) {
              // Handle decoding errors
              imageWidgets.add(
                const Center(child: Text('Failed to load image')),
              );
            }
          }
        }

        if (imageWidgets.isEmpty) {
          return const Center(child: Text('No images available'));
        }
        return Column(
          children: [
            SizedBox(
              height: 210,
              child: Swiper(
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: imageWidgets[index],
                  );
                },
                itemCount: imageWidgets.length,
                autoplay: true,
                autoplayDelay: 3000,
                autoplayDisableOnInteraction: true,
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
            buildIndicator(imageWidgets.length),
          ],
        );
      },
    );
  }

  // Carousel Indicators with Slide Animation
  Widget buildIndicator(int itemCount) {
    if (itemCount == 0)
      return const SizedBox.shrink(); // Handle empty list case

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
