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
//   final CarouselController controller = CarouselController();

//   int activeIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: widget.productStream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox(
//             height: 250,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final products = snapshot.data!.docs;

//         return Column(
//           children: [
//             CarouselSlider.builder(
//               itemCount: products.length,
//               carouselController: controller,
//               itemBuilder: (context, index, realIndex) {
//                 final image = products[index]['images'][0];
//                 return Container(
//                   margin: const EdgeInsets.all(5.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     image: DecorationImage(
//                       image: MemoryImage(base64Decode(image)),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//               options: CarouselOptions(
//                 height: 250,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     activeIndex = index;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             AnimatedSmoothIndicator(
//               activeIndex: activeIndex,
//               count: products.length,
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
//********************* */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int _activeIndex = 0;

  Stream<QuerySnapshot> fetchProducts() {
    return firestore.collection('products').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final products = snapshot.data!.docs;

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: products.length,
              carouselController: controller,
              itemBuilder: (context, index, realIndex) {
                final image = products[index]['images'][0];
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(image)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _activeIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            AnimatedSmoothIndicator(
              activeIndex: _activeIndex,
              count: products.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
                expansionFactor: 3,
              ),
              onDotClicked: (index) => controller.animateToPage(index), // FIXED
            ),
          ],
        );
      },
    );
  }
}
