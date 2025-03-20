part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  // const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetails extends ProductDetailsEvent {
  final String productId;

  FetchProductDetails(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CheckWishlistStatus extends ProductDetailsEvent {
  final String productId;

  CheckWishlistStatus({required this.productId});
  @override
  List<Object?> get props => [productId];
}

class ToggleWishlist extends ProductDetailsEvent {
  final String productId;
  final bool isCurrentlyWishlisted;
  final BuildContext context;

  ToggleWishlist(this.productId, this.isCurrentlyWishlisted, this.context);
  @override
  List<Object?> get props => [productId, isCurrentlyWishlisted];
}

class AddToCart extends ProductDetailsEvent {
  final CartItem item;
  final BuildContext context;

  AddToCart(this.item, this.context);

  @override
  List<Object?> get props => [item, context];
}

class CartErrorState extends ProductDetailsState {
  final String errorMessage;

  CartErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class _ProductUpdated extends ProductDetailsEvent {
  final List<String> base64Images;
  final String productName;
  final String productDescription;
  final double productPrice;

  _ProductUpdated({
    required this.base64Images,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  List<Object?> get props => [
        base64Images,
        productName,
        productDescription,
        productPrice,
      ];
}

class _WishlistStatusUpdated extends ProductDetailsEvent {
  final bool isWishlisted;

  _WishlistStatusUpdated(this.isWishlisted);

  @override
  List<Object?> get props => [isWishlisted];
}
