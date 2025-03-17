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
//       print("Current User ID: $userId");
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
//       print("Wishlist Path: ${wishlistRef.path}");
//       print("Product Data: ${event.productData}");
//       final docSnapshot = await wishlistRef.get();
//       print("Does wishlist item exist? ${docSnapshot.exists}");

//       if (event.isCurrentlyWishlisted) {
//         print("Removing product ${event.productId} from wishlist...");
//         await wishlistRef.delete();
//         print("Product removed from wishlist.");
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Removed from Wishlist')),
//           );
//         }
//       } else {
//         print("Adding product ${event.productId} to wishlist...");
//         await wishlistRef
//             .set({
//               'productId': event.productId,
//               'name': event.productData!['name'],
//               'price': event.productData!['price'],
//               'imageUrls': event.productData!['imageUrls'],
//               'timestamp': FieldValue.serverTimestamp(),
//             })
//             .then((_) => print("Successfully added to Firebase"))
//             .catchError((error) => print("Error adding to Firebase: $error"));
//         // print("Product added to wishlist.");
//         if (event.context.mounted) {
//           ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Added to Wishlist')),
//           );
//         }
//       }

//       add(FetchWishlist());
//     } catch (e) {
//       print("Failed to update wishlist: $e");
//       emit(WishlistError('Failed to update wishlist: $e'));
//     }
//   }
// }
//**************************************MARCH 17 */
import 'dart:async';

import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  StreamSubscription<QuerySnapshot>? _wishlistSubscription;
  StreamSubscription<User?>? _authSubscription;
  String? _currentUserId;
  WishlistBloc() : super(WishlistLoading()) {
    on<FetchWishlist>(_onFetchWishlist);
    on<ToggleWishlistItem>(_onToggleWishlistItem);
    on<UpdateWishlist>(_onUpdateWishlist);
    on<ClearWishlistStream>(_onClearWishlistStream);
    on<AuthStateChanged>(_onAuthStateChanged);
    // Listen for authentication state changes
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final newUserId = user?.uid;
      // Only refresh if the user ID has changed
      if (newUserId != _currentUserId) {
        _currentUserId = newUserId;
        add(AuthStateChanged(newUserId));
      }
    });

    // Initialize wishlist when bloc is created
    add(FetchWishlist());
  }
  void _onAuthStateChanged(
      AuthStateChanged event, Emitter<WishlistState> emit) {
    if (event.userId == null) {
      // User logged out, clear wishlist
      emit(WishlistLoading());
    } else {
      // User logged in, fetch their wishlist
      add(FetchWishlist());
    }
  }

  Future<void> _onFetchWishlist(
      FetchWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      print("Current User ID: $userId");
      if (userId == null) {
        emit(WishlistError('User not logged in'));
        return;
      }
      await _wishlistSubscription?.cancel();

      // Create a new stream subscription
      _wishlistSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          add(UpdateWishlist(snapshot.docs));
        },
        onError: (error) {
          add(FetchWishlist());
          print("Wishlist stream error: $error");
        },
      );
    } catch (e) {
      emit(WishlistError('Failed to fetch wishlist: $e'));
    }
  }

  void _onUpdateWishlist(UpdateWishlist event, Emitter<WishlistState> emit) {
    print("Updating wishlist with ${event.wishlist.length} items");
    emit(WishlistLoaded(event.wishlist));
  }

  void _onClearWishlistStream(
      ClearWishlistStream event, Emitter<WishlistState> emit) async {
    await _wishlistSubscription?.cancel();
    _wishlistSubscription = null;
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

      // add(FetchWishlist());
    } catch (e) {
      print("Failed to update wishlist: $e");
      emit(WishlistError('Failed to update wishlist: $e'));
    }
  }

  @override
  Future<void> close() {
    _wishlistSubscription?.cancel();
    return super.close();
  }
}
