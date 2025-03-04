// //****************------------******************---------------* */

// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
//   WishlistBloc() : super(WishlistLoading()) {
//     on<FetchWishlist>(_onFetchWishlist);
//     on<ToggleWishlistItem>(_onToggleWishlistItem);
//   }

//   Future<void> _onFetchWishlist(
//       FetchWishlist event, Emitter<WishlistState> emit) async {
//     emit(WishlistLoading());
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(WishlistError('User not logged in'));
//         return;
//       }

//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .orderBy('timestamp', descending: true)
//           .get();

//       emit(WishlistLoaded(snapshot.docs));
//     } catch (e) {
//       emit(WishlistError('Failed to fetch wishlist: $e'));
//     }
//   }

//   Future<void> _onToggleWishlistItem(
//       ToggleWishlistItem event, Emitter<WishlistState> emit) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(WishlistError('User not logged in'));
//         return;
//       }

//       final wishlistRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(event.productId);

//       if (event.isCurrentlyWishlisted) {
//         await wishlistRef.delete();
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Removed from Wishlist')),
//           );
//         }
//       } else {
//         await wishlistRef.set({
//           'productId': event.productId,
//           'name': event.productData!['name'],
//           'price': event.productData!['price'],
//           'imageUrls': event.productData!['imageUrls'],
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Added to Wishlist')),
//           );
//         }
//       }

//       // Refresh wishlist state after modification
//       add(FetchWishlist());
//     } catch (e) {
//       emit(WishlistError('Failed to update wishlist: $e'));
//     }
//   }
// }
//**************************************************************** */

//****************------------******************---------------* */
//BLOC
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
//   WishlistBloc() : super(WishlistLoading()) {
//     on<FetchWishlist>(_onFetchWishlist);
//     on<ToggleWishlistItem>(_onToggleWishlistItem);
//   }

//   Future<void> _onFetchWishlist(
//       FetchWishlist event, Emitter<WishlistState> emit) async {
//     emit(WishlistLoading());
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(WishlistError('User not logged in'));
//         return;
//       }

//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .orderBy('timestamp', descending: true)
//           .get();

//       emit(WishlistLoaded(snapshot.docs));
//     } catch (e) {
//       emit(WishlistError('Failed to fetch wishlist: $e'));
//     }
//   }

//   Future<void> _onToggleWishlistItem(
//       ToggleWishlistItem event, Emitter<WishlistState> emit) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(WishlistError('User not logged in'));
//         return;
//       }

//       final wishlistRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(event.productId);

//       if (event.isCurrentlyWishlisted) {
//         await wishlistRef.delete();
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Removed from Wishlist')),
//           );
//         }
//       } else {
//         await wishlistRef.set({
//           'productId': event.productId,
//           'name': event.productData!['name'],
//           'price': event.productData!['price'],
//           'imageUrls': event.productData!['imageUrls'],
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Added to Wishlist')),
//           );
//         }
//       }

//       add(FetchWishlist());
//     } catch (e) {
//       emit(WishlistError('Failed to update wishlist: $e'));
//     }
//   }
// }

//************************march 3 */**************0 */

import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoading()) {
    on<FetchWishlist>(_onFetchWishlist);
    on<ToggleWishlistItem>(_onToggleWishlistItem);
  }

  Future<void> _onFetchWishlist(
      FetchWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(WishlistError('User not logged in'));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .orderBy('timestamp', descending: true)
          .get();

      emit(WishlistLoaded(snapshot.docs));
    } catch (e) {
      emit(WishlistError('Failed to fetch wishlist: $e'));
    }
  }

  Future<void> _onToggleWishlistItem(
      ToggleWishlistItem event, Emitter<WishlistState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(WishlistError('User not logged in'));
        return;
      }

      final wishlistRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(event.productId);
      print("Wishlist Path: ${wishlistRef.path}");
      print("Product Data: ${event.productData}");
      final docSnapshot = await wishlistRef.get();
      print("Does wishlist item exist? ${docSnapshot.exists}");

      if (event.isCurrentlyWishlisted) {
        print("Removing product ${event.productId} from wishlist...");
        await wishlistRef.delete();
        print("Product removed from wishlist.");
        if (event.context.mounted) {
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Removed from Wishlist')),
          );
        }
      } else {
        print("Adding product ${event.productId} to wishlist...");
        await wishlistRef
            .set({
              'productId': event.productId,
              'name': event.productData!['name'],
              'price': event.productData!['price'],
              'imageUrls': event.productData!['imageUrls'],
              'timestamp': FieldValue.serverTimestamp(),
            })
            .then((_) => print("Successfully added to Firebase"))
            .catchError((error) => print("Error adding to Firebase: $error"));
        // print("Product added to wishlist.");
        if (event.context.mounted) {
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Added to Wishlist')),
          );
        }
      }

      add(FetchWishlist());
    } catch (e) {
      print("Failed to update wishlist: $e");
      emit(WishlistError('Failed to update wishlist: $e'));
    }
  }
}
