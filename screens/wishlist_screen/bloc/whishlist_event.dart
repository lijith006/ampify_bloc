// import 'package:flutter/material.dart';

// abstract class WishlistEvent {}

// class FetchWishlist extends WishlistEvent {}

// class ToggleWishlistItem extends WishlistEvent {
//   final String productId;
//   final bool isCurrentlyWishlisted;
//   final BuildContext context;
//   final Map<String, dynamic>? productData;

//   ToggleWishlistItem({
//     required this.productId,
//     required this.isCurrentlyWishlisted,
//     required this.context,
//     this.productData,
//   });
// }
//************************************MARCH 17 */*********************00 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class WishlistEvent {}

class FetchWishlist extends WishlistEvent {}

class UpdateWishlist extends WishlistEvent {
  final List<QueryDocumentSnapshot> wishlist;

  UpdateWishlist(this.wishlist);
}

class AuthStateChanged extends WishlistEvent {
  final String? userId;

  AuthStateChanged(this.userId);
}

class ClearWishlistStream extends WishlistEvent {}

class ToggleWishlistItem extends WishlistEvent {
  final String productId;
  final bool isCurrentlyWishlisted;
  final BuildContext context;
  final Map<String, dynamic>? productData;

  ToggleWishlistItem({
    required this.productId,
    required this.isCurrentlyWishlisted,
    required this.context,
    this.productData,
  });
}
