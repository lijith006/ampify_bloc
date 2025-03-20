// import 'dart:typed_data';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/common/card_widget.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:ampify_bloc/screens/products/product_details.dart';
// import 'package:ampify_bloc/screens/search/filter/filter_widgets/active_filters.dart';
// import 'package:ampify_bloc/screens/search/search_widgets/search_services.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// import 'package:flutter_bloc/flutter_bloc.dart';

// class SearchResults extends StatelessWidget {
//   final QuerySnapshot? searchResults;
//   final String searchQuery;
//   final ProductFilter filter;
//   final bool isLoading;
//   final VoidCallback onClearFilters;
//   final Function(String, String?) onClearFilter;

//   final SearchFilterService searchFilterService;

//   const SearchResults({
//     Key? key,
//     required this.searchResults,
//     required this.searchQuery,
//     required this.filter,
//     required this.isLoading,
//     required this.onClearFilters,
//     required this.onClearFilter,
//     required this.searchFilterService,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Container(
//         color: Colors.white,
//         child: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (searchResults == null || searchResults!.docs.isEmpty) {
//       print("No search results found");
//       return _buildNoResultsFound();
//     }
//     // Filter results locally
//     final filteredResults = _filterResultsLocally(searchResults!.docs);

//     if (filteredResults.isEmpty) {
//       print("No filtered results found");
//       return _buildNoResultsFound();
//     }
//     print("Displaying ${filteredResults.length} filtered results");
//     return _buildResultsList(filteredResults);
//     // return _buildResultsList();
//   }

//   // Filter results locally to match both categories and brands
//   List<DocumentSnapshot> _filterResultsLocally(List<DocumentSnapshot> docs) {
//     return docs.where((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       final categoryId = data['categoryId'];
//       final brandId = data['brandId'];
//       final price = (data['price'] ?? 0).toDouble();

//       // Check if the product matches the selected categories
//       final matchesCategory = filter.categories == null ||
//           filter.categories!.isEmpty ||
//           filter.categories!.contains(categoryId);

//       // Check if the product matches the selected brands
//       final matchesBrand = filter.brands == null ||
//           filter.brands!.isEmpty ||
//           filter.brands!.contains(brandId);
//       // Check if the product matches the price range
//       final matchesPrice =
//           (filter.minPrice == null || price >= filter.minPrice!) &&
//               (filter.maxPrice == null || price <= filter.maxPrice!);

//       return matchesCategory && matchesBrand && matchesPrice;
//     }).toList();
//   }

//   Widget _buildNoResultsFound() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           if ((filter.isActive &&
//                   (filter.categories != null || filter.brands != null)) ||
//               searchQuery.isNotEmpty)
//             ActiveFiltersDisplay(
//               filter: filter,
//               searchQuery: searchQuery,
//               onClearAll: onClearFilters,
//               onClearFilter: onClearFilter,
//               searchFilterService: searchFilterService,
//             ),
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.search_off, size: 64, color: Colors.black87),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No products found for "${searchQuery.isEmpty ? 'selected filters' : searchQuery}"',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: onClearFilters,
//                     child: const Text('Clear all filters'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultsList(List<DocumentSnapshot> filteredResults) {
//     print("Building results list with ${filteredResults.length} products");

//     return Container(
//       color: AppColors.backgroundColor,
//       child: Column(
//         children: [
//           if (filter.isActive || searchQuery.isNotEmpty)
//             ActiveFiltersDisplay(
//               filter: filter,
//               searchQuery: searchQuery,
//               onClearAll: onClearFilters,
//               onClearFilter: onClearFilter,
//               searchFilterService: searchFilterService,
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               '${filteredResults.length} products found',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8.0),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               // itemCount: searchResults!.docs.length,
//               itemCount: filteredResults.length,
//               itemBuilder: (context, index) {
//                 final product = filteredResults[index];
//                 print("Building product card for: ${product['name']}");
//                 //  final product = searchResults!.docs[index];
//                 // final productData = product.data() as Map<String, dynamic>;
//                 return _buildProductCard(context, product);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductCard(BuildContext context, DocumentSnapshot product) {
//     final String productId = product.id;
//     final Map<String, dynamic> productData =
//         product.data() as Map<String, dynamic>;
//     final String name = product['name'];
//     final double price = (product['price'] ?? 0).toDouble();

//     // final bool isWishlisted = product['isWishlisted'] ?? false;
//     final bool isWishlisted = (productData['isWishlisted'] ?? false) as bool;
//     final int cartCount =
//         productData.containsKey('cartCount') ? productData['cartCount'] : 0;
//     final Uint8List imageBytes = base64Decode(product['images'][0]);

//     return InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductDetailPage(productId: productId),
//             ),
//           );
//         },
//         child: CardWidget(
//             key: ValueKey(productId),
//             name: name,
//             price: price,
//             isWishlisted: isWishlisted,
//             imageBytes: imageBytes,
//             productId: productId,
//             onWishlistToggle: () {
//               final productData = {
//                 'name': name,
//                 'price': price,
//                 'imageUrls': product['images'],
//                 'isWishlisted': isWishlisted
//               };
//               context.read<WishlistBloc>().add(
//                     ToggleWishlistItem(
//                       productId: productId,
//                       isCurrentlyWishlisted: context.read<WishlistBloc>().state
//                               is WishlistLoaded &&
//                           (context.read<WishlistBloc>().state as WishlistLoaded)
//                               .wishlistedItems
//                               .any((doc) => doc == productId),
//                       productData: productData,
//                       context: context,
//                     ),
//                   );
//             },
//             onAddToCart: () {
//               // Convert Uint8List to Base64 String
//               final base64Image = base64Encode(imageBytes);

//               // Store as List<String>
//               final cartItem = CartItem(
//                 productId: productId,
//                 title: name,
//                 price: price,
//                 quantity: 1,
//                 imageUrls: [base64Image],
//               );

//               context.read<CartBloc>().add(AddToCart(cartItem));
//               print("AddToCart event dispatched: ${cartItem.productId}");
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Product added to cart!')),
//               );
//             },
//             cartCount: cartCount));
//   }
// }
//************************************************** */
