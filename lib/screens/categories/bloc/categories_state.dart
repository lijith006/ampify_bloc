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
