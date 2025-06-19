// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
// import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_field.dart';
// import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_results.dart';

// class FilterComponents extends StatefulWidget {
//   final TextEditingController searchController;
//   final ProductFilter filter;
//   final bool isFilterActive;
//   final String searchQuery;
//   final Function() updateSearch;
//   final Function(String, String?) clearFilter;
//   final Function() clearAllFilters;
//   final SearchFilterService searchFilterService;
//   final Function() showFilterBottomSheet;

//   const FilterComponents({
//     required this.searchController,
//     required this.filter,
//     required this.isFilterActive,
//     required this.searchQuery,
//     required this.updateSearch,
//     required this.clearFilter,
//     required this.clearAllFilters,
//     required this.searchFilterService,
//     required this.showFilterBottomSheet,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _FilterComponentsState createState() => _FilterComponentsState();
// }

// class _FilterComponentsState extends State<FilterComponents> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         buildSearchField(),
//         buildFilterButton(),
//         if (widget.isFilterActive || widget.searchQuery.isNotEmpty)
//           buildSearchAndFilterResults(),
//       ],
//     );
//   }

//   // Widget buildSearchField() {
//   //   return SearchField(
//   //     controller: widget.searchController,
//   //     onSearch: () {
//   //       setState(widget.updateSearch);
//   //     },
//   //   );
//   // }
//   // Move buildSearchField here
//   Widget buildSearchField() {
//     return SearchField(
//       controller: widget.searchController,
//       onSearch: widget.updateSearch,
//     );
//   }

//   Widget buildFilterButton() {
//     return IconButton(
//       color: Colors.black,
//       icon: const Icon(Icons.filter_list),
//       onPressed: widget.showFilterBottomSheet,
//     );
//   }

//   Widget buildSearchAndFilterResults() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: widget.searchFilterService.fetchProducts(
//         searchQuery: widget.searchQuery,
//         filter: widget.filter,
//       ),
//       builder: (context, snapshot) {
//         return SearchResults(
//           searchResults: snapshot.hasData ? snapshot.data : null,
//           searchQuery: widget.searchQuery,
//           filter: widget.filter,
//           isLoading: snapshot.connectionState == ConnectionState.waiting,
//           onClearFilters: widget.clearAllFilters,
//           onClearFilter: widget.clearFilter,
//           searchFilterService: widget.searchFilterService,
//         );
//       },
//     );
//   }
// }
