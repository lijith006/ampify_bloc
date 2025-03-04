//************************************************************ */
// import 'package:cloud_firestore/cloud_firestore.dart';

// abstract class WishlistState {
//   final List<String> wishlistedItems;
//   const WishlistState(this.wishlistedItems);
// }

// class WishlistLoading extends WishlistState {
//   WishlistLoading() : super([]);
// }

// class WishlistLoaded extends WishlistState {
//   final List<QueryDocumentSnapshot> wishlist;

//   WishlistLoaded(this.wishlist)
//       : super(wishlist.map((doc) => doc['productId'] as String).toList());
// }

// class WishlistError extends WishlistState {
//   final String message;
//   WishlistError(this.message) : super([]);
// }
//m***********************march 3**********

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WishlistState {
  final List<String> wishlistedItems;
  const WishlistState(this.wishlistedItems);
}

class WishlistLoading extends WishlistState {
  WishlistLoading() : super([]);
}

class WishlistLoaded extends WishlistState {
  final List<QueryDocumentSnapshot> wishlist;

  WishlistLoaded(this.wishlist)
      : super(wishlist.map((doc) => doc['productId'] as String).toList());
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message) : super([]);
}
