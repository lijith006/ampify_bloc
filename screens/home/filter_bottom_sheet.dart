// import 'package:ampify_bloc/screens/search_filter/search_filter_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FilterBottomSheet extends StatefulWidget {
//   final ProductFilter initialFilter;
//   final List<QueryDocumentSnapshot> categories;
//   final List<QueryDocumentSnapshot> brands;
//   final Function(ProductFilter) onApply;

//   const FilterBottomSheet({
//     super.key,
//     required this.initialFilter,
//     required this.categories,
//     required this.brands,
//     required this.onApply,
//   });

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   late ProductFilter filter;

//   @override
//   void initState() {
//     super.initState();
//     filter = widget.initialFilter;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       height: MediaQuery.of(context).size.height * 0.75,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Filters',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildPriceRange(),
//                   const SizedBox(height: 20),
//                   _buildCategories(),
//                   const SizedBox(height: 20),
//                   _buildBrands(),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 widget.onApply(filter);
//                 Navigator.pop(context);
//               },
//               child: const Text('Apply Filters'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPriceRange() {
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
//               filter = filter.copyWith(
//                 minPrice: values.start,
//                 maxPrice: values.end,
//               );
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Category'),
//         Wrap(
//           spacing: 8.0,
//           children: widget.categories.map((category) {
//             return FilterChip(
//               label: Text(category['name']),
//               selected: filter.category == category.id,
//               onSelected: (selected) {
//                 setState(() {
//                   filter = filter.copyWith(
//                     category: selected ? category.id : null,
//                   );
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrands() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Brand'),
//         Wrap(
//           spacing: 8.0,
//           children: widget.brands.map((brand) {
//             return FilterChip(
//               label: Text(brand['name']),
//               selected: filter.brand == brand.id,
//               onSelected: (selected) {
//                 setState(() {
//                   filter = filter.copyWith(
//                     brand: selected ? brand.id : null,
//                   );
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
