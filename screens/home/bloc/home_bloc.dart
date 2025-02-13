// import 'dart:async';

// import 'package:ampify_bloc/screens/home/bloc/home_event.dart';
// import 'package:ampify_bloc/screens/home/bloc/home_state.dart';
// import 'package:ampify_bloc/screens/search_filter/search_filter_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final FirebaseFirestore firestore;
//   final SearchFilterService searchFilterService;
//   StreamSubscription? _productsSubscription;
//   StreamSubscription? _categoriesSubscription;
//   StreamSubscription? _brandsSubscription;

//   HomeBloc({
//     required this.firestore,
//     required this.searchFilterService,
//   }) : super(const HomeState()) {
//     on<LoadHomeData>(_onLoadHomeData);
//     on<UpdateSearchQuery>(_onUpdateSearchQuery);
//     on<UpdateFilter>(_onUpdateFilter);
//     on<ClearFilters>(_onClearFilters);
//     on<UpdateCarouselIndex>(_onUpdateCarouselIndex);
//   }

//   Future<void> _onLoadHomeData(
//       LoadHomeData event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       await _productsSubscription?.cancel();
//       await _categoriesSubscription?.cancel();
//       await _brandsSubscription?.cancel();

//       // Load initial data
//       final productsSnapshot = await searchFilterService
//           .fetchProducts(searchQuery: '', filter: ProductFilter())
//           .first;
//       final categoriesSnapshot =
//           await searchFilterService.fetchCategories().first;
//       final brandsSnapshot = await searchFilterService.fetchBrands().first;

//       emit(state.copyWith(
//         isLoading: false,
//         products: productsSnapshot.docs,
//         categories: categoriesSnapshot.docs,
//         brands: brandsSnapshot.docs,
//       ));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   Future<void> _onUpdateSearchQuery(
//       UpdateSearchQuery event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(isLoading: true, searchQuery: event.query));
//     try {
//       final snapshot = await searchFilterService
//           .fetchProducts(searchQuery: event.query, filter: state.filter)
//           .first;
//       emit(state.copyWith(isLoading: false, products: snapshot.docs));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   Future<void> _onUpdateFilter(
//       UpdateFilter event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(
//         isLoading: true, filter: event.filter, isFilterActive: true));
//     try {
//       final snapshot = await searchFilterService
//           .fetchProducts(searchQuery: state.searchQuery, filter: event.filter)
//           .first;
//       emit(state.copyWith(isLoading: false, products: snapshot.docs));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   void _onClearFilters(ClearFilters event, Emitter<HomeState> emit) {
//     emit(state.copyWith(
//       filter: ProductFilter(),
//       isFilterActive: false,
//     ));
//     add(UpdateFilter(ProductFilter()));
//   }

//   void _onUpdateCarouselIndex(
//       UpdateCarouselIndex event, Emitter<HomeState> emit) {
//     emit(state.copyWith(activeCarouselIndex: event.index));
//   }

//   @override
//   Future<void> close() {
//     _productsSubscription?.cancel();
//     _categoriesSubscription?.cancel();
//     _brandsSubscription?.cancel();
//     return super.close();
//   }
// }
