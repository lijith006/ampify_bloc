part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final List<String> base64Images;
  final String productName;
  final String productDescription;
  final double productPrice;
  final bool isWishlisted;

  ProductDetailsLoaded(
      {required this.base64Images,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.isWishlisted});
  // Copy method- to update specific fields
  ProductDetailsLoaded copyWith({bool? isWishlisted}) {
    return ProductDetailsLoaded(
      base64Images: base64Images,
      productName: productName,
      productDescription: productDescription,
      productPrice: productPrice,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  List<Object?> get props => [
        base64Images,
        productName,
        productDescription,
        productPrice,
        isWishlisted
      ];
}

class ProductDetailError extends ProductDetailsState {
  final String message;

  ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistUpdated extends ProductDetailsState {
  final bool isWishlisted;

  WishlistUpdated(this.isWishlisted);

  @override
  List<Object?> get props => [isWishlisted];
}

class CartItemAdded extends ProductDetailsState {}
