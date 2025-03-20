// import 'package:ampify_bloc/screens/home/bloc/home_event.dart';
// import 'package:ampify_bloc/screens/home/bloc/home_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final FirebaseFirestore firestore;

//   HomeBloc({required this.firestore}) : super(HomeInitial()) {
//     on<FetchHomeData>(_onFetchHomeData);
//     on<ToggleProductWishlist>(_onToggleProductWishlist);
//   }

//   Future<void> _onFetchHomeData(
//       FetchHomeData event, Emitter<HomeState> emit) async {
//     emit(HomeLoading());
//     try {
//       // Using Future.wait to fetch both products and categories concurrently
//       final results = await Future.wait([
//         firestore.collection('products').get(),
//         firestore.collection('categories').get(),
//       ]);

//       final products = results[0].docs;
//       final categories = results[1].docs;

//       emit(HomeLoaded(products: products, categories: categories));
//     } catch (e) {
//       emit(HomeError(message: 'Failed to load home data: ${e.toString()}'));
//     }
//   }

//   void _onToggleProductWishlist(
//       ToggleProductWishlist event, Emitter<HomeState> emit) {}
// }
//********************************************** */
