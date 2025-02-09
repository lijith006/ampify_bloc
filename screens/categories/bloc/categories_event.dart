// part of 'categories_bloc.dart';

// sealed class CategoriesEvent extends Equatable {
//   const CategoriesEvent();

//   @override
//   List<Object> get props => [];
// }

abstract class CategoriesEvent {}

class FetchProducts extends CategoriesEvent {
  final String categoryId;
  FetchProducts(this.categoryId);
}
