// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';

// class HomeCubit extends Cubit<int> {
//   HomeCubit() : super(0); // Default to Home screen

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final SearchFilterService searchFilterService =
//       SearchFilterService(FirebaseFirestore.instance);

//   ProductFilter filter = ProductFilter();
//   String searchQuery = '';
//   bool isFilterActive = false;

//   void updateSearch(String query) {
//     searchQuery = query.trim().toLowerCase();
//     emit(state); // Notify UI to update
//   }

//   void applyFilters(ProductFilter newFilter) {
//     filter = newFilter;
//     isFilterActive = filter.isActive;
//     emit(state); // Notify UI
//   }

//   void clearFilter(String filterType, String? value) {
//     switch (filterType) {
//       case 'search':
//         searchQuery = '';
//         break;
//       case 'category':
//         filter.categories?.remove(value);
//         if (filter.categories!.isEmpty) filter.categories = null;
//         break;
//       case 'brand':
//         filter.brands?.remove(value);
//         if (filter.brands!.isEmpty) filter.brands = null;
//         break;
//       case 'price':
//         filter.minPrice = null;
//         filter.maxPrice = null;
//         break;
//     }
//     isFilterActive = filter.isActive;
//     emit(state);
//   }

//   void clearAllFilters() {
//     searchQuery = '';
//     filter.clear();
//     isFilterActive = false;
//     emit(state);
//   }

//   Stream<QuerySnapshot> fetchFilteredProducts() {
//     return searchFilterService.fetchProducts(
//       searchQuery: searchQuery,
//       filter: filter,
//     );
//   }

//   void updateSelectedIndex(int index) {
//     emit(index);
//   }
// }
