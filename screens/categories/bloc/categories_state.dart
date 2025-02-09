// part of 'categories_bloc.dart';

// sealed class CategoriesState extends Equatable {
//   const CategoriesState();

//   @override
//   List<Object> get props => [];
// }

// final class CategoriesInitial extends CategoriesState {}

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<QueryDocumentSnapshot> products;
  CategoriesLoaded(this.products);
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}
