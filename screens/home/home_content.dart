// import 'dart:convert';

// import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
// import 'package:ampify_bloc/screens/categories/categories.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class HomeContent extends StatefulWidget {
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// class _HomeContentState extends State<HomeContent> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final CarouselSliderController controller = CarouselSliderController();
//   int activeIndex = 0;

//   Stream<QuerySnapshot> fetchProducts() {
//     return firestore.collection('products').snapshots();
//   }

//   Stream<QuerySnapshot> fetchCategories() {
//     return firestore.collection('categories').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           //C a r o u s a l
//           StreamBuilder<QuerySnapshot>(
//             stream: fetchProducts(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const CircularProgressIndicator();
//               }
//               final products = snapshot.data!.docs;
//               return Column(
//                 children: [
//                   //c a r o u s a l   S l i d e r
//                   CarouselSlider.builder(
//                     itemCount: products.length,
//                     carouselController: controller,
//                     itemBuilder: (context, index, realIndex) {
//                       final image = products[index]['images'][0];
//                       return Container(
//                         margin: const EdgeInsets.all(5.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           image: DecorationImage(
//                             image: MemoryImage(base64Decode(image)),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     },
//                     options: CarouselOptions(
//                       height: 250,
//                       autoPlay: true,
//                       enlargeCenterPage: true,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           activeIndex = index;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   AnimatedSmoothIndicator(
//                     activeIndex: activeIndex,
//                     count: products.length,
//                     effect: const ExpandingDotsEffect(
//                       dotHeight: 8,
//                       dotWidth: 8,
//                       activeDotColor: Colors.blue,
//                       dotColor: Colors.grey,
//                       expansionFactor: 3,
//                     ),
//                     onDotClicked: (index) => controller.animateToPage(index),
//                   )
//                 ],
//               );
//             },
//           ),
//           const SizedBox(height: 20),
//           // C a t e g o r i e s
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text('Categories', style: AppWidget.boldTextFieldStyle()),
//           ),
//           const SizedBox(height: 20),
//           //Categories
//           StreamBuilder(
//             stream: fetchCategories(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const CircularProgressIndicator();
//               }
//               final categories = snapshot.data!.docs;
//               return SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: categories.length,
//                   itemBuilder: (context, index) {
//                     final category = categories[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BlocProvider(
//                                 create: (context) => CategoriesBloc(
//                                   firestore: FirebaseFirestore.instance,
//                                 )..add(FetchProducts(
//                                     category.id,
//                                   )),
//                                 child: Categories(
//                                   categoryId: category.id,
//                                   categoryName: category['name'],
//                                 ),
//                               ),
//                             ));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Column(
//                           children: [
//                             CircleAvatar(
//                               radius: 30,
//                               backgroundImage:
//                                   MemoryImage(base64Decode(category['image'])),
//                             ),
//                             const SizedBox(
//                               height: 4,
//                             ),
//                             Text(category['name']),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Featured products',
//               style: AppWidget.boldTextFieldStyle(),
//             ),
//           ),
//           const SizedBox(height: 20),
//           //PRODUCT GRID
//           StreamBuilder<QuerySnapshot>(
//             stream: fetchProducts(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text('Something went wrong'),
//                 );
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No products available',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 );
//               }
//               final products = snapshot.data!.docs;
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 0.75),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final productId = products[index].id;

//                   final product = products[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ProductDetailPage(productId: productId),
//                           ));
//                     },
//                     child: Card(
//                       elevation: 3,
//                       child: Column(
//                         children: [
//                           Expanded(
//                               child: Container(
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                               image: MemoryImage(
//                                 base64Decode(product['images'][0]),
//                               ),
//                               fit: BoxFit.cover,
//                             )),
//                           )),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   product['name'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   '\₹${product['price']}',
//                                   style: const TextStyle(
//                                     color: Color.fromARGB(255, 107, 104, 104),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
//************************************************************* */

import 'dart:convert';

import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
import 'package:ampify_bloc/screens/categories/categories.dart';
import 'package:ampify_bloc/screens/home/widgets/product_carousel.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CarouselSliderController controller = CarouselSliderController();
  int activeIndex = 0;

  Stream<QuerySnapshot> fetchProducts() {
    return firestore.collection('products').snapshots();
  }

  Stream<QuerySnapshot> fetchCategories() {
    return firestore.collection('categories').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ProductCarousel(productStream: fetchProducts()),

          const SizedBox(height: 20),
          // C a t e g o r i e s
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Categories', style: AppWidget.boldTextFieldStyle()),
          ),
          const SizedBox(height: 20),
          //Categories
          StreamBuilder(
            stream: fetchCategories(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final categories = snapshot.data!.docs;
              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => CategoriesBloc(
                                  firestore: FirebaseFirestore.instance,
                                )..add(FetchProducts(
                                    category.id,
                                  )),
                                child: Categories(
                                  categoryId: category.id,
                                  categoryName: category['name'],
                                ),
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  MemoryImage(base64Decode(category['image'])),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(category['name']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Featured products',
              style: AppWidget.boldTextFieldStyle(),
            ),
          ),
          const SizedBox(height: 20),
          //PRODUCT GRID
          StreamBuilder<QuerySnapshot>(
            stream: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }
              final products = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                      elevation: 3,
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(
                                base64Decode(product['images'][0]),
                              ),
                              fit: BoxFit.cover,
                            )),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\₹${product['price']}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 107, 104, 104),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
