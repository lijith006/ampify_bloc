abstract class CategoriesEvent {}

class FetchProducts extends CategoriesEvent {
  final String categoryId;
  FetchProducts(this.categoryId);
}
