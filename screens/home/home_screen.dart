// import 'dart:convert';

// import 'package:ampify_bloc/authentication/screens/login_screen.dart';
// import 'package:ampify_bloc/authentication/service/auth_service.dart';
// // import 'package:ampify_bloc/screens/cart/cart.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
// import 'package:ampify_bloc/screens/categories/categories.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// // import 'package:ampify_bloc/screens/profile/profile.dart';
// // import 'package:ampify_bloc/widgets/custom_bottom_navbar.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final TextEditingController searchController = TextEditingController();
//   final CarouselSliderController controller = CarouselSliderController();

//   String searchQuery = '';
//   int selectedIndex = 0;
//   int activeIndex = 0;
//   //Fetch  categories

//   Stream<QuerySnapshot> fetchCategories() {
//     return firestore.collection('categories').snapshots();
//   }

//   //Fetch brand
//   Stream<QuerySnapshot> fetchBrand() {
//     return firestore.collection('brands').snapshots();
//   }

//   //Fetch Products
//   Stream<QuerySnapshot> fetchProducts() {
//     if (searchQuery.isEmpty) {
//       // print('fetched...');
//       return firestore.collection('products').snapshots();
//     } else {
//       return firestore
//           .collection('products')
//           .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
//           .where('name',
//               isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff')
//           .snapshots();
//     }
//   }

//   //Bottom Navigation bar

//   // void onItemTapped(int index) {
//   //   setState(() {
//   //     selectedIndex = index;
//   //   });
//   //   //nav logic
//   //   switch (index) {
//   //     case 0:
//   //       //Home
//   //       break;
//   //     case 1:
//   //       //Cart
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => const MyCart(),
//   //           ));

//   //       break;
//   //     case 2:
//   //       //Profile
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => const MyProfile(),
//   //           ));
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final _auth = AuthService();
//     return Scaffold(
//       appBar: AppBar(
//         excludeHeaderSemantics: true,
//         backgroundColor: Colors.blue,
//         title: TextField(
//           controller: searchController,
//           decoration: InputDecoration(
//             hintText: 'Search products...',
//             border: InputBorder.none,
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () {
//                 setState(() {
//                   searchQuery = searchController.text.trim().toLowerCase();
//                 });
//               },
//             ),
//           ),
//           onSubmitted: (value) {
//             setState(() {
//               searchQuery = value.trim().toLowerCase();
//             });
//           },
//         ),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 // await _auth.signOut();
//                 showSignOutDialog(context, _auth);
//               },
//               icon: const Icon(Icons.logout))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               //Carousel slider
//               StreamBuilder<QuerySnapshot>(
//                 stream: fetchProducts(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   }
//                   final products = snapshot.data!.docs;
//                   //********************************* */
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       //Carousel Slider
//                       CarouselSlider.builder(
//                         itemCount: products.length,
//                         carouselController: controller,
//                         itemBuilder: (context, index, realIndex) {
//                           final image = products[index]['images'][0];
//                           return Container(
//                             margin: const EdgeInsets.all(5.0),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 image: DecorationImage(
//                                     image: MemoryImage(base64Decode(image)),
//                                     fit: BoxFit.cover)),
//                           );
//                         },
//                         options: CarouselOptions(
//                           height: 250,
//                           autoPlay: true,
//                           enlargeCenterPage: true,
//                           onPageChanged: (index, reason) {
//                             setState(() {
//                               activeIndex = index;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       //page indicator
//                       AnimatedSmoothIndicator(
//                         activeIndex: activeIndex,
//                         count: products.length,
//                         effect: const ExpandingDotsEffect(
//                             dotHeight: 8,
//                             dotWidth: 8,
//                             activeDotColor: Colors.blue,
//                             dotColor: Colors.grey,
//                             expansionFactor: 3),
//                         onDotClicked: (index) =>
//                             controller.animateToPage(index),
//                       )
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Categories',
//                   style: AppWidget.boldTextFieldStyle(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               //Categories
//               StreamBuilder(
//                 stream: fetchCategories(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   }
//                   final categories = snapshot.data!.docs;
//                   return SizedBox(
//                     height: 100,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         final category = categories[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => BlocProvider(
//                                     create: (context) => CategoriesBloc(
//                                       firestore: FirebaseFirestore.instance,
//                                     )..add(FetchProducts(
//                                         category.id,
//                                       )),
//                                     child: Categories(
//                                       categoryId: category.id,
//                                       categoryName: category['name'],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Column(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 30,
//                                   backgroundImage: MemoryImage(
//                                       base64Decode(category['image'])),
//                                 ),
//                                 const SizedBox(
//                                   height: 4,
//                                 ),
//                                 Text(category['name']),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Featured products',
//                   style: AppWidget.boldTextFieldStyle(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               //PRODUCT GRID
//               StreamBuilder<QuerySnapshot>(
//                 stream: fetchProducts(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(
//                       child: Text('Something went wrong'),
//                     );
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No products available',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                     );
//                   }
//                   final products = snapshot.data!.docs;
//                   return GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                             childAspectRatio: 0.75),
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       final productId = products[index].id;

//                       final product = products[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetailPage(productId: productId),
//                               ));
//                         },
//                         child: Card(
//                           elevation: 2,
//                           child: Column(
//                             children: [
//                               Expanded(
//                                   child: Container(
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                   image: MemoryImage(
//                                     base64Decode(product['images'][0]),
//                                   ),
//                                   fit: BoxFit.cover,
//                                 )),
//                               )),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       product['name'],
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       '\₹${product['price']}',
//                                       style: const TextStyle(
//                                         color:
//                                             Color.fromARGB(255, 107, 104, 104),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//     //       CustomBottomNavBar(currentIndex: selectedIndex, onTap: onItemTapped),
//     // );
//   }

//   void showSignOutDialog(BuildContext context, AuthService _auth) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           title: const Text(
//             'Sign Out',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text('Are you sure you want to sign out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await _auth.signOut();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const LoginScreen(),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//               ),
//               child: const Text('Sign Out'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//******************************************************** */
import 'dart:convert';

import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/screens/cart/cart.dart';
// import 'package:ampify_bloc/screens/cart/cart.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
import 'package:ampify_bloc/screens/categories/categories.dart';
import 'package:ampify_bloc/screens/products/product_details.dart';
import 'package:ampify_bloc/screens/profile/profile.dart';
// import 'package:ampify_bloc/screens/profile/profile.dart';
// import 'package:ampify_bloc/widgets/custom_bottom_navbar.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  final CarouselSliderController controller = CarouselSliderController();

  String searchQuery = '';
  int selectedIndex = 0;
  int activeIndex = 0;
  // List of screens to show
  final List<Widget> screens = [
    const HomeScreen(),
    const MyCart(),
    const MyProfile(),
  ];
  //Fetch  categories

  Stream<QuerySnapshot> fetchCategories() {
    return firestore.collection('categories').snapshots();
  }

  //Fetch brand
  Stream<QuerySnapshot> fetchBrand() {
    return firestore.collection('brands').snapshots();
  }

  //Fetch Products
  Stream<QuerySnapshot> fetchProducts() {
    if (searchQuery.isEmpty) {
      // print('fetched...');
      return firestore.collection('products').snapshots();
    } else {
      return firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('name',
              isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: true,
        backgroundColor: Colors.blue,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchQuery = searchController.text.trim().toLowerCase();
                });
              },
            ),
          ),
          onSubmitted: (value) {
            setState(() {
              searchQuery = value.trim().toLowerCase();
            });
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // await _auth.signOut();
                showSignOutDialog(context, _auth);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCart(),
                        ));
                  },
                  child: Text('CART')),
              //Carousel slider
              StreamBuilder<QuerySnapshot>(
                stream: fetchProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final products = snapshot.data!.docs;
                  //********************************* */
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Carousel Slider
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
                                    fit: BoxFit.cover)),
                          );
                        },
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //page indicator
                      AnimatedSmoothIndicator(
                        activeIndex: activeIndex,
                        count: products.length,
                        effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Colors.blue,
                            dotColor: Colors.grey,
                            expansionFactor: 3),
                        onDotClicked: (index) =>
                            controller.animateToPage(index),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: AppWidget.boldTextFieldStyle(),
                ),
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
                                  backgroundImage: MemoryImage(
                                      base64Decode(category['image'])),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  final products = snapshot.data!.docs;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        color:
                                            Color.fromARGB(255, 107, 104, 104),
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
        ),
      ),
    );
  }

  void showSignOutDialog(BuildContext context, AuthService _auth) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
