// import 'package:ampify_bloc/screens/search_filter/search_filter_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';

// class HomeState extends Equatable {
//   final bool isLoading;
//   final String searchQuery;
//   final ProductFilter filter;
//   final bool isFilterActive;
//   final int activeCarouselIndex;
//   final List<QueryDocumentSnapshot> products;
//   final List<QueryDocumentSnapshot> categories;
//   final List<QueryDocumentSnapshot> brands;
//   final String? error;

//   const HomeState({
//     this.isLoading = false,
//     this.searchQuery = '',
//     this.filter = const ProductFilter(),
//     this.isFilterActive = false,
//     this.activeCarouselIndex = 0,
//     this.products = const [],
//     this.categories = const [],
//     this.brands = const [],
//     this.error,
//   });

//   HomeState copyWith({
//     bool? isLoading,
//     String? searchQuery,
//     ProductFilter? filter,
//     bool? isFilterActive,
//     int? activeCarouselIndex,
//     List<QueryDocumentSnapshot>? products,
//     List<QueryDocumentSnapshot>? categories,
//     List<QueryDocumentSnapshot>? brands,
//     String? error,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       searchQuery: searchQuery ?? this.searchQuery,
//       filter: filter ?? this.filter,
//       isFilterActive: isFilterActive ?? this.isFilterActive,
//       activeCarouselIndex: activeCarouselIndex ?? this.activeCarouselIndex,
//       products: products ?? this.products,
//       categories: categories ?? this.categories,
//       brands: brands ?? this.brands,
//       error: error,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isLoading,
//         searchQuery,
//         filter,
//         isFilterActive,
//         activeCarouselIndex,
//         products,
//         categories,
//         brands,
//         error,
//       ];
// }
