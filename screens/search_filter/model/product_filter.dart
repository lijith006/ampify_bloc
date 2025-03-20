// import 'package:equatable/equatable.dart';

// class ProductFilter extends Equatable {
//   final List<String>? categories;
//   final List<String>? brands;
//   final double? minPrice;
//   final double? maxPrice;

//   const ProductFilter({
//     this.categories,
//     this.brands,
//     this.minPrice,
//     this.maxPrice,
//   });

//   const ProductFilter.empty()
//       : categories = null,
//         brands = null,
//         minPrice = null,
//         maxPrice = null;

//   bool get isActive =>
//       (categories != null && categories!.isNotEmpty) ||
//       (brands != null && brands!.isNotEmpty) ||
//       minPrice != null ||
//       maxPrice != null;

//   ProductFilter clear() {
//     return const ProductFilter.empty();
//   }

//   ProductFilter copyWith({
//     List<String>? categories,
//     List<String>? brands,
//     double? minPrice,
//     double? maxPrice,
//     bool clearCategories = false,
//     bool clearBrands = false,
//     bool clearMinPrice = false,
//     bool clearMaxPrice = false,
//   }) {
//     return ProductFilter(
//       categories: clearCategories ? null : categories ?? this.categories,
//       brands: clearBrands ? null : brands ?? this.brands,
//       minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
//       maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
//     );
//   }

//   // Helper methods for immutable modifications
//   ProductFilter removeCategory(String category) {
//     if (categories == null || !categories!.contains(category)) {
//       return this;
//     }
//     final newCategories = List<String>.from(categories!)..remove(category);
//     return copyWith(categories: newCategories.isEmpty ? null : newCategories);
//   }

//   ProductFilter removeBrand(String brand) {
//     if (brands == null || !brands!.contains(brand)) {
//       return this;
//     }
//     final newBrands = List<String>.from(brands!)..remove(brand);
//     return copyWith(brands: newBrands.isEmpty ? null : newBrands);
//   }

//   @override
//   List<Object?> get props => [categories, brands, minPrice, maxPrice];
// }
