import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFilter {
  double? minPrice;
  double? maxPrice;
  String? category;
  String? brand;
  ProductFilter({
    this.minPrice,
    this.maxPrice,
    this.category,
    this.brand,
  });
}

class SearchFilterService {
  final FirebaseFirestore firestore;
  SearchFilterService(this.firestore);

  //Fetch products with filters
  Stream<QuerySnapshot> fetchProducts({
    required String searchQuery,
    required ProductFilter filter,
  }) {
    Query query = firestore.collection('products');

    //Apply search query
    if (searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('name',
              isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff');
    }

    //Apply price range
    if (filter.minPrice != null && filter.maxPrice != null) {
      query = query
          .where('price', isGreaterThanOrEqualTo: filter.minPrice)
          .where('price', isLessThanOrEqualTo: filter.maxPrice);
    }

    // Apply category filter
    if (filter.category != null) {
      query = query.where('categoryId', isEqualTo: filter.category);
    }

    // Apply brand filter
    if (filter.brand != null) {
      query = query.where('brandId', isEqualTo: filter.brand);
    }
    return query.snapshots();
  }

  // Fetch categories for filter options
  Stream<QuerySnapshot> fetchCategories() {
    return firestore.collection('categories').snapshots();
  }

  // Fetch brands for filter options
  Stream<QuerySnapshot> fetchBrands() {
    return firestore.collection('brands').snapshots();
  }
}
