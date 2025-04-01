// import 'package:ampify_bloc/screens/search/search_widgets/search_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class PriceRangeFilter extends StatelessWidget {
//   final double minPrice;
//   final double maxPrice;
//   final Function(double, double) onChanged;

//   const PriceRangeFilter({
//     Key? key,
//     required this.minPrice,
//     required this.maxPrice,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Price Range',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         RangeSlider(
//           values: RangeValues(minPrice, maxPrice),
//           min: 0,
//           max: 90000,
//           divisions: 20,
//           labels: RangeLabels(
//             '₹${minPrice.toInt()}',
//             '₹${maxPrice.toInt()}',
//           ),
//           onChanged: (values) {
//             onChanged(values.start, values.end);
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('₹${minPrice.toInt()}'),
//             Text('₹${maxPrice.toInt()}'),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class CategoryFilter extends StatefulWidget {
//   final List<String>? selectedCategories;
//   final SearchFilterService searchFilterService;
//   final Function(List<String>) onCategoriesSelected;

//   const CategoryFilter({
//     Key? key,
//     required this.selectedCategories,
//     required this.searchFilterService,
//     required this.onCategoriesSelected,
//   }) : super(key: key);

//   @override
//   State<CategoryFilter> createState() => _CategoryFilterState();
// }

// class _CategoryFilterState extends State<CategoryFilter> {
//   List<String> selectedCategories = [];

//   @override
//   void initState() {
//     super.initState();
//     selectedCategories = widget.selectedCategories ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         StreamBuilder<QuerySnapshot>(
//           stream: widget.searchFilterService.fetchCategories(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return Wrap(
//               spacing: 8.0,
//               children: snapshot.data!.docs.map((doc) {
//                 final categoryId = doc.id;
//                 final isSelected = selectedCategories.contains(categoryId);

//                 return FilterChip(
//                   label: Text(doc['name']),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() {
//                       if (selected) {
//                         selectedCategories.add(categoryId);
//                       } else {
//                         selectedCategories.remove(categoryId);
//                       }
//                     });
//                     widget.onCategoriesSelected(selectedCategories);
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

// class BrandFilter extends StatefulWidget {
//   final List<String>? selectedBrands;
//   final SearchFilterService searchFilterService;
//   final Function(List<String>) onBrandsSelected;

//   const BrandFilter({
//     Key? key,
//     required this.selectedBrands,
//     required this.searchFilterService,
//     required this.onBrandsSelected,
//   }) : super(key: key);

//   @override
//   _BrandFilterState createState() => _BrandFilterState();
// }

// class _BrandFilterState extends State<BrandFilter> {
//   List<String> selectedBrands = [];

//   @override
//   void initState() {
//     super.initState();
//     selectedBrands = widget.selectedBrands ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         StreamBuilder<QuerySnapshot>(
//           stream: widget.searchFilterService.fetchBrands(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return Wrap(
//               spacing: 8.0,
//               children: snapshot.data!.docs.map((doc) {
//                 final brandId = doc.id;
//                 final isSelected = selectedBrands.contains(brandId);

//                 return FilterChip(
//                   label: Text(doc['name']),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() {
//                       if (selected) {
//                         selectedBrands.add(brandId);
//                       } else {
//                         selectedBrands.remove(brandId);
//                       }
//                     });
//                     widget.onBrandsSelected(selectedBrands);
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
