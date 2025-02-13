import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<QueryDocumentSnapshot> wishlistItems;
  WishlistLoaded(this.wishlistItems);
}

class WishlistError extends WishlistState {
  final String errorMessage;
  WishlistError(this.errorMessage);
}
