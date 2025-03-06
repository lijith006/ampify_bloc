// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductCarousel extends StatefulWidget {
//   final Stream<QuerySnapshot> productStream;

//   const ProductCarousel({
//     Key? key,
//     required this.productStream,
//   }) : super(key: key);

//   @override
//   State<ProductCarousel> createState() => _ProductCarouselState();
// }

// class _ProductCarouselState extends State<ProductCarousel> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final CarouselSliderController controller = CarouselSliderController();
//   int _activeIndex = 0;

//   Stream<QuerySnapshot> fetchBanners() {
//     return firestore.collection('banners').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: fetchBanners(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox(
//             height: 250,
//             width: double.infinity,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final banners = snapshot.data!.docs;

//         // Flatten the list of images
//         List<Widget> imageWidgets = [];
//         for (var banner in banners) {
//           final imageList = banner['images'] as List<dynamic>;
//           for (var base64Image in imageList) {
//             try {
//               final imageBytes = base64Decode(base64Image);
//               imageWidgets.add(
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     //  borderRadius: BorderRadius.circular(10.0),
//                     image: DecorationImage(
//                       image: MemoryImage(imageBytes),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               );
//             } catch (e) {
//               // Handle decoding errors
//               imageWidgets.add(
//                 const Center(child: Text('Failed to load image')),
//               );
//             }
//           }
//         }

//         if (imageWidgets.isEmpty) {
//           return const Center(child: Text('No images available'));
//         }

//         return Column(
//           children: [
//             CarouselSlider(
//               items: imageWidgets,
//               carouselController: controller,
//               options: CarouselOptions(
//                 height: 180,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 viewportFraction: 1.0,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _activeIndex = index;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             AnimatedSmoothIndicator(
//               activeIndex: _activeIndex,
//               count: imageWidgets.length,
//               effect: const ExpandingDotsEffect(
//                 dotHeight: 8,
//                 dotWidth: 8,
//                 activeDotColor: Colors.blue,
//                 dotColor: Colors.grey,
//                 expansionFactor: 3,
//               ),
//               onDotClicked: (index) => controller.animateToPage(index),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//****************************************************** */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class ProductCarousel extends StatefulWidget {
  final Stream<QuerySnapshot> productStream;

  const ProductCarousel({
    Key? key,
    required this.productStream,
  }) : super(key: key);

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
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
                pagination: const SwiperPagination(
                  builder: FractionPaginationBuilder(
                    color: Colors.white54,
                    activeColor: Colors.white,
                    fontSize: 14,
                    activeFontSize: 16,
                  ),
                ),
                control: const SwiperControl(color: Colors.white70),
                //fade: 0.7,
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
