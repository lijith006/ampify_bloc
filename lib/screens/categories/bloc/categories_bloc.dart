import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final FirebaseFirestore firestore;
  CategoriesBloc({required this.firestore}) : super(CategoriesInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final snapshot = await firestore
          .collection('products')
          .where('categoryId', isEqualTo: event.categoryId)
          .get();
      emit(CategoriesLoaded(snapshot.docs));
    } catch (e) {
      emit(CategoriesError('Failed to fetch products:$e'));
    }
  }
}
