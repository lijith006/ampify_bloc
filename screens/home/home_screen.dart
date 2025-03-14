//000000000000000000000000000000 Feb 27 0000000000000000000000

// import 'dart:convert';

// import 'package:ampify_bloc/authentication/screens/login_screen.dart';
// import 'package:ampify_bloc/authentication/service/auth_service.dart';
// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/cart/cart.dart';
// import 'package:ampify_bloc/screens/home/home_content.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/profile/profile.dart';
// import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/wishlist_screen.dart';
// import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final TextEditingController searchController = TextEditingController();
//   final CarouselSliderController controller = CarouselSliderController();
//   final SearchFilterService searchFilterService =
//       SearchFilterService(FirebaseFirestore.instance);
//   ProductFilter filter = ProductFilter();
//   String searchQuery = '';
//   bool isFilterActive = false;

//   final List<Widget> screens = [
//     HomeContent(),
//     const WishlistScreen(),
//     const MyCart(),
//     const MyProfile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final _auth = AuthService();
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         excludeHeaderSemantics: true,
//         backgroundColor: AppColors.backgroundColor,
//         title:
//             _selectedIndex == 0 ? buildSearchField() : Text(getScreenTitle()),
//         actions: [
//           if (_selectedIndex == 0) buildFilterButton(),
//           buildLogoutButton(_auth),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Main content based on--- navigation
//           IndexedStack(
//             index: _selectedIndex,
//             children: screens,
//           ),

//           // Search results or filtered products
//           if (_selectedIndex == 0 && (searchQuery.isNotEmpty || isFilterActive))
//             buildSearchAndFilterResults(),
//         ],
//       ),
//       bottomNavigationBar: buildBottomNav(),
//     );
//   }

//   Widget buildSearchAndFilterResults() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: searchFilterService.fetchProducts(
//         searchQuery: searchQuery,
//         filter: filter,
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             color: Colors.white,
//             child: const Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 if (isFilterActive || searchQuery.isNotEmpty)
//                   buildActiveFilters(),
//                 Expanded(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.search_off,
//                             size: 64, color: Colors.black87),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No products found for "${searchQuery.isEmpty ? 'selected filters' : searchQuery}"',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               searchQuery = '';
//                               searchController.clear();
//                               filter = ProductFilter();
//                               isFilterActive = false;
//                             });
//                           },
//                           child: const Text('Clear all filters'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//           color: AppColors.backgroundColor,
//           child: Column(
//             children: [
//               if (isFilterActive || searchQuery.isNotEmpty)
//                 buildActiveFilters(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   '${snapshot.data!.docs.length} products found',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(8.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.75,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final product = snapshot.data!.docs[index];
//                     return Card(
//                       elevation: 3,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductDetailPage(
//                                 productId: product.id,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: MemoryImage(
//                                       base64Decode(product['images'][0]),
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product['name'],
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '₹${product['price']}',
//                                     style: const TextStyle(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

// //Active filters box
//   Widget buildActiveFilters() {
//     return Container(
//       color: Colors.grey[100],
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Active Filters',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     filter = ProductFilter();
//                     isFilterActive = false;
//                   });
//                 },
//                 child: const Text('Clear All'),
//               ),
//             ],
//           ),
//           Wrap(
//             spacing: 8.0,
//             children: [
//               if (filter.category != null)
//                 Chip(
//                   label: Text('Category: ${filter.category}'),
//                   onDeleted: () => setState(() => filter.category = null),
//                 ),
//               if (filter.brand != null)
//                 Chip(
//                   label: Text('Brand: ${filter.brand}'),
//                   onDeleted: () => setState(() => filter.brand = null),
//                 ),
//               if (filter.minPrice != null && filter.maxPrice != null)
//                 Chip(
//                   label:
//                       Text('Price: ₹${filter.minPrice} - ₹${filter.maxPrice}'),
//                   onDeleted: () => setState(() {
//                     filter.minPrice = null;
//                     filter.maxPrice = null;
//                   }),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// //Filter bottom sheet
//   void showFilterBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: const EdgeInsets.all(16),
//               height: MediaQuery.of(context).size.height * 0.75,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Filters',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           buildPriceRangeFilter(setState),
//                           const SizedBox(height: 20),
//                           buildCategoryFilter(setState),
//                           const SizedBox(height: 20),
//                           buildBrandFilter(setState),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         this.setState(() {
//                           isFilterActive = true;
//                         });
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Apply Filters'),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// //Filter button
//   Widget buildFilterButton() {
//     return IconButton(
//       color: Colors.black,
//       icon: const Icon(Icons.filter_list),
//       onPressed: showFilterBottomSheet,
//     );
//   }

// //Logout logic
//   Widget buildLogoutButton(AuthService auth) {
//     return IconButton(
//       onPressed: () => showSignOutDialog(context, auth),
//       icon: const Icon(
//         Icons.logout,
//         color: Colors.black,
//       ),
//     );
//   }

// //Sign out dialogue box
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
//                 backgroundColor: Colors.red,
//               ),
//               child: Text(
//                 'Sign Out',
//                 style: AppWidget.whitelightTextFieldStyle(),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String getScreenTitle() {
//     switch (_selectedIndex) {
//       case 1:
//         return '';
//       case 2:
//         return '';
//       case 3:
//         return '';
//       default:
//         return 'Home';
//     }
//   }

//   void updateSearch() {
//     setState(() {
//       searchQuery = searchController.text.trim().toLowerCase();
//     });
//   }

// //Bottom nav bar
//   Widget buildBottomNav() {
//     return GNav(
//       gap: 8,
//       selectedIndex: _selectedIndex,
//       onTabChange: (index) {
//         HapticFeedback.heavyImpact();
//         setState(() {
//           _selectedIndex = index;
//           // Clear search when switching tabs
//           if (_selectedIndex != 0) {
//             searchQuery = '';
//             searchController.clear();
//           }
//         });
//       },
//       tabs: const [
//         GButton(icon: Icons.home, text: 'Home'),
//         GButton(icon: Icons.favorite, text: 'Wishlist'),
//         GButton(icon: Icons.shopping_cart, text: 'My cart'),
//         GButton(icon: Icons.person, text: 'Profile'),
//       ],
//     );
//   }

// //Search field
//   Widget buildSearchField() {
//     return Row(
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage('assets/images/ampifylogo.png'),
//           ),
//         ),
//         Expanded(
//           child: TextField(
//             controller: searchController,
//             style: const TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               hintText: 'Search products...',
//               hintStyle: const TextStyle(color: Colors.black),
//               border: InputBorder.none,
//               suffixIcon: IconButton(
//                 icon: const Icon(
//                   Icons.search,
//                   color: Colors.black,
//                 ),
//                 onPressed: () => updateSearch(),
//               ),
//             ),
//             onSubmitted: (value) => updateSearch(),
//           ),
//         ),
//       ],
//     );
//   }

//   //********************************** */
//   Widget buildPriceRangeFilter(StateSetter setState) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Price Range'),
//         RangeSlider(
//           values: RangeValues(
//             filter.minPrice ?? 0,
//             filter.maxPrice ?? 90000,
//           ),
//           min: 0,
//           max: 90000,
//           divisions: 20,
//           labels: RangeLabels(
//             '₹${filter.minPrice?.toStringAsFixed(0)}',
//             '₹${filter.maxPrice?.toStringAsFixed(0)}',
//           ),
//           onChanged: (values) {
//             setState(() {
//               filter.minPrice = values.start;
//               filter.maxPrice = values.end;
//             });
//           },
//         ),
//       ],
//     );
//   }

// //Category filter
//   Widget buildCategoryFilter(StateSetter setState) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Category'),
//         StreamBuilder<QuerySnapshot>(
//           stream: searchFilterService.fetchCategories(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const CircularProgressIndicator();
//             }
//             return Wrap(
//               spacing: 8.0,
//               children: snapshot.data!.docs.map((doc) {
//                 return FilterChip(
//                   label: Text(doc['name']),
//                   selected: filter.category == doc.id,
//                   onSelected: (selected) {
//                     setState(() {
//                       filter.category = selected ? doc.id : null;
//                     });
//                   },
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }

// //Brand filter
//   Widget buildBrandFilter(StateSetter setState) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Brand'),
//         StreamBuilder<QuerySnapshot>(
//           stream: searchFilterService.fetchBrands(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const CircularProgressIndicator();
//             }
//             return Wrap(
//               spacing: 8.0,
//               children: snapshot.data!.docs.map((doc) {
//                 return FilterChip(
//                   label: Text(doc['name']),
//                   selected: filter.brand == doc.id,
//                   onSelected: (selected) {
//                     setState(() {
//                       filter.brand = selected ? doc.id : null;
//                     });
//                   },
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
//*********************************************************** */
//*************************MArch 3

import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart.dart';
import 'package:ampify_bloc/screens/home/home_content.dart';
import 'package:ampify_bloc/screens/profile/profile.dart';
import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/filters/filter_bottom_sheet.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_field.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_results.dart';
import 'package:ampify_bloc/screens/wishlist_screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  final CarouselSliderController controller = CarouselSliderController();
  final SearchFilterService searchFilterService =
      SearchFilterService(FirebaseFirestore.instance);
  ProductFilter filter = ProductFilter();
  String searchQuery = '';
  bool isFilterActive = false;

  final List<Widget> screens = [
    HomeContent(),
    const WishlistScreen(),
    const MyCart(),
    const MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        excludeHeaderSemantics: true,
        backgroundColor: AppColors.backgroundColor,
        title:
            _selectedIndex == 0 ? buildSearchField() : Text(getScreenTitle()),
        actions: [
          if (_selectedIndex == 0) buildFilterButton(),
          // buildLogoutButton(_auth),
        ],
      ),
      body: Stack(
        children: [
          // Main content based on--- navigation
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),

          // Search results or filtered products
          if (_selectedIndex == 0 && (searchQuery.isNotEmpty || isFilterActive))
            buildSearchAndFilterResults(),
        ],
      ),
      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildSearchField() {
    return SearchField(
      controller: searchController,
      onSearch: () {
        setState(() {
          searchQuery = searchController.text.trim().toLowerCase();
        });
      },
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          initialFilter: filter,
          searchFilterService: searchFilterService,
          onApplyFilters: (newFilter) {
            setState(() {
              filter = newFilter;
              isFilterActive = filter.isActive;
            });
          },
        );
      },
    );
  }

  // Method to clear specific filter
  void clearFilter(String filterType, String? value) {
    setState(() {
      switch (filterType) {
        case 'search':
          searchQuery = '';
          searchController.clear();
          break;
        case 'category':
          filter.categories?.remove(value);
          if (filter.categories!.isEmpty) filter.categories = null;
          break;
        case 'brand':
          filter.brands?.remove(value);
          if (filter.brands!.isEmpty) filter.brands = null;
          break;
        case 'price':
          filter.minPrice = null;
          filter.maxPrice = null;
          break;
      }
      isFilterActive = filter.isActive;
    });
  }

  // Method to clear all filters
  void clearAllFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      filter.clear();
      isFilterActive = false;
    });
  }

//Filter button
  Widget buildFilterButton() {
    return IconButton(
      color: Colors.black,
      icon: const Icon(Icons.filter_list),
      onPressed: showFilterBottomSheet,
    );
  }

  String getScreenTitle() {
    switch (_selectedIndex) {
      case 1:
        return '';
      case 2:
        return '';
      case 3:
        return '';
      default:
        return 'Home';
    }
  }

  void updateSearch() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

//Bottom nav bar
  Widget buildBottomNav() {
    return GNav(
      gap: 8,
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        HapticFeedback.heavyImpact();
        setState(() {
          _selectedIndex = index;
          // Clear search when switching tabs
          if (_selectedIndex != 0) {
            searchQuery = '';
            searchController.clear();
          }
        });
      },
      tabs: const [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.favorite, text: 'Wishlist'),
        GButton(icon: Icons.shopping_cart, text: 'My cart'),
        GButton(icon: Icons.person, text: 'Profile'),
      ],
    );
  }

  Widget buildSearchAndFilterResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: searchFilterService.fetchProducts(
        searchQuery: searchQuery,
        filter: filter,
      ),
      builder: (context, snapshot) {
        return SearchResults(
          searchResults: snapshot.hasData ? snapshot.data : null,
          searchQuery: searchQuery,
          filter: filter,
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          onClearFilters: clearAllFilters,
          onClearFilter: clearFilter,
          searchFilterService: searchFilterService,
        );
      },
    );
  }
}
