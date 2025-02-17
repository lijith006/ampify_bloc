// abstract class WishlistEvent {}

// class FetchWishlist extends WishlistEvent {}

//********************************************** */

import 'package:flutter/material.dart';

abstract class WishlistEvent {}

class FetchWishlist extends WishlistEvent {}

class ToggleWishlistItem extends WishlistEvent {
  final String productId;
  final bool isCurrentlyWishlisted;
  final BuildContext context;
  final Map<String, dynamic>?
      productData; // Optional product data for adding new items

  ToggleWishlistItem({
    required this.productId,
    required this.isCurrentlyWishlisted,
    required this.context,
    this.productData,
  });
}
