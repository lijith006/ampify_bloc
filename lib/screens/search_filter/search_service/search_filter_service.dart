import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFilter {
  double? minPrice;
  double? maxPrice;
  List<String>? categories;
  List<String>? brands;
  // List<String> selectedCategories;
  // List<String> selectedBrands;
  ProductFilter({
    this.minPrice,
    this.maxPrice,
    this.categories,
    this.brands,
    // this.selectedCategories = const [],
    // this.selectedBrands = const [],
  });
  //test
  bool get isActive {
    return minPrice != null ||
        maxPrice != null ||
        (categories != null && categories!.isNotEmpty) ||
        (brands != null && brands!.isNotEmpty);
  }

  // Add clear method to reset all filters
  void clear() {
    minPrice = null;
    maxPrice = null;
    categories = null;
    brands = null;
  }

  // Add clone method to create a copy of the filter
  ProductFilter clone() {
    return ProductFilter(
      minPrice: minPrice,
      maxPrice: maxPrice,
      categories: categories != null ? List.from(categories!) : null,
      brands: brands != null ? List.from(brands!) : null,
    );
  }
}

class SearchFilterService {
  final FirebaseFirestore firestore;
  SearchFilterService(this.firestore);

  // Fetch category names by IDs
  Future<List<String>> fetchCategoryNames(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return [];
    final QuerySnapshot snapshot = await firestore
        .collection('categories')
        .where(FieldPath.documentId, whereIn: categoryIds)
        .get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  // Fetch brand names by IDs
  Future<List<String>> fetchBrandNames(List<String> brandIds) async {
    if (brandIds.isEmpty) return [];
    final QuerySnapshot snapshot = await firestore
        .collection('brands')
        .where(FieldPath.documentId, whereIn: brandIds)
        .get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  // Fetch products with filters
  Stream<QuerySnapshot> fetchProducts({
    required String searchQuery,
    required ProductFilter filter,
  }) {
    Query query = firestore.collection('products');

    // Apply search query
    if (searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('name',
              isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff');
    }

    // Apply price range filter
    if (filter.minPrice != null && filter.maxPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: filter.minPrice);
      query = query.where('price', isLessThanOrEqualTo: filter.maxPrice);
    }

    // If category filter is active, apply it at database level
    if (filter.categories != null && filter.categories!.isNotEmpty) {
      query = query.where('categoryId', whereIn: filter.categories);

      // brand filtering locally in _filterResultsLocally
      return query.snapshots();
    }

    // If only brand filter is active, apply it at database level
    else if (filter.brands != null && filter.brands!.isNotEmpty) {
      query = query.where('brandId', whereIn: filter.brands);
    }

    return query.snapshots();
  }

  // Fetch categories for filter options
  Stream<QuerySnapshot> fetchCategories() {
    return firestore.collection('categories').snapshots();
  }

  // Fetch brands for filter
  Stream<QuerySnapshot> fetchBrands() {
    return firestore.collection('brands').snapshots();
  }
}
