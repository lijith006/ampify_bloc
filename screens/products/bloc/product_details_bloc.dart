// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'product_details_event.dart';
// part 'product_details_state.dart';

// class ProductDetailsBloc
//     extends Bloc<ProductDetailsEvent, ProductDetailsState> {
//   ProductDetailsBloc() : super(ProductDetailsLoading()) {
//     on<FetchProductDetails>(_onFetchProductDetails);
//     on<CheckWishlistStatus>(_onCheckWishlistStatus);
//     on<ToggleWishlist>(_onToggleWishlist);
//     on<AddToCart>(_onAddToCart);
//   }

//   Future<void> _onFetchProductDetails(
//       FetchProductDetails event, Emitter<ProductDetailsState> emit) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .doc(event.productId)
//           .get();

//       if (snapshot.exists) {
//         final productData = snapshot.data() as Map<String, dynamic>;
//         final userId = FirebaseAuth.instance.currentUser?.uid;
//         bool isWishlisted = false;

//         if (userId != null) {
//           final wishlistDoc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .collection('wishlist')
//               .doc(event.productId)
//               .get();

//           isWishlisted = wishlistDoc.exists;
//         }

//         emit(ProductDetailsLoaded(
//           base64Images: List<String>.from(productData['images'] ?? []),
//           productName: productData['name'] ?? "No Name",
//           productDescription:
//               productData['description'] ?? "No description available",
//           productPrice: (productData['price'] ?? 0.0).toDouble(),
//           isWishlisted: isWishlisted,
//         ));
//       } else {
//         emit(ProductDetailError("Product not found"));
//       }
//     } catch (e) {
//       emit(ProductDetailError("Error fetching product details"));
//     }
//   }

//   Future<void> _onCheckWishlistStatus(
//       CheckWishlistStatus event, Emitter<ProductDetailsState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('wishlist')
//         .doc(event.productId)
//         .get();

//     emit(WishlistUpdated(doc.exists));
//   }

//   Future<void> _onToggleWishlist(
//       ToggleWishlist event, Emitter<ProductDetailsState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     if (state is ProductDetailsLoaded) {
//       final currentState = state as ProductDetailsLoaded;

//       final wishlistRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(event.productId);
//       if (event.isCurrentlyWishlisted) {
//         await wishlistRef.delete();
//         emit(ProductDetailsLoaded(
//           base64Images: currentState.base64Images,
//           productName: currentState.productName,
//           productDescription: currentState.productDescription,
//           productPrice: currentState.productPrice,
//           isWishlisted: false,
//         ));
//         // Show Snackbar - removing
//         ScaffoldMessenger.of(event.context).showSnackBar(
//             const SnackBar(content: Text('Removed from Wishlist')));
//       } else {
//         await wishlistRef.set({
//           'productId': event.productId,
//           'name': currentState.productName,
//           'price': currentState.productPrice,
//           'imageUrls': currentState.base64Images,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         emit(ProductDetailsLoaded(
//           base64Images: currentState.base64Images,
//           productName: currentState.productName,
//           productDescription: currentState.productDescription,
//           productPrice: currentState.productPrice,
//           isWishlisted: true,
//         ));
//         // Show Snackbar - add
//         ScaffoldMessenger.of(event.context)
//             .showSnackBar(const SnackBar(content: Text('Added to Wishlist')));
//       }
//     }
//   }

//   Future<void> _onAddToCart(
//       AddToCart event, Emitter<ProductDetailsState> emit) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(CartErrorState(errorMessage: "User not logged in"));
//         return;
//       }

//       // Keep the current state
//       if (state is! ProductDetailsLoaded) return;
//       final currentState = state as ProductDetailsLoaded;

//       final cartRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('cart');

//       // Start a batch write
//       final batch = FirebaseFirestore.instance.batch();
//       final cartItemRef = cartRef.doc(event.item.productId);

//       final docSnapshot = await cartItemRef.get();
//       if (docSnapshot.exists) {
//         final currentQuantity = docSnapshot.data()?['quantity'] ?? 0;
//         batch.update(cartItemRef, {'quantity': currentQuantity + 1});
//       } else {
//         batch.set(cartItemRef, event.item.toMap());
//       }

//       // Commit the batch
//       await batch.commit();

//       // Re-emit the current state to maintain UI consistency
//       emit(ProductDetailsLoaded(
//         base64Images: currentState.base64Images,
//         productName: currentState.productName,
//         productDescription: currentState.productDescription,
//         productPrice: currentState.productPrice,
//         isWishlisted: currentState.isWishlisted,
//       ));

//       // Emit success state
//       emit(CartItemAdded());

//       // Re-emit the loaded state to maintain the UI
//       emit(currentState);
//     } catch (e) {
//       print("Error adding to cart: $e");
//       emit(CartErrorState(errorMessage: e.toString()));

//       // Re-emit the previous state if it exists
//       if (state is ProductDetailsLoaded) {
//         emit(state);
//       }
//     }
//   }
// }
//***************************************************** */
import 'dart:async';

import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  StreamSubscription? _productSubscription;
  StreamSubscription? _wishlistSubscription;
  ProductDetailsBloc() : super(ProductDetailsLoading()) {
    on<FetchProductDetails>(_onFetchProductDetails);
    on<CheckWishlistStatus>(_onCheckWishlistStatus);
    on<ToggleWishlist>(_onToggleWishlist);
    on<AddToCart>(_onAddToCart);
    on<_ProductUpdated>(_onProductUpdated);
    on<_WishlistStatusUpdated>(_onWishlistStatusUpdated);
  }

  Future<void> _onFetchProductDetails(
      FetchProductDetails event, Emitter<ProductDetailsState> emit) async {
    try {
      // Cancel existing subscriptions
      await _productSubscription?.cancel();
      await _wishlistSubscription?.cancel();

      final userId = FirebaseAuth.instance.currentUser?.uid;

      // Set up product details stream
      _productSubscription = FirebaseFirestore.instance
          .collection('products')
          .doc(event.productId)
          .snapshots()
          .listen(
        (snapshot) {
          if (snapshot.exists) {
            final productData = snapshot.data() as Map<String, dynamic>;
            add(_ProductUpdated(
              base64Images: List<String>.from(productData['images'] ?? []),
              productName: productData['name'] ?? "No Name",
              productDescription:
                  productData['description'] ?? "No description available",
              productPrice: (productData['price'] ?? 0.0).toDouble(),
            ));
          } else {
            emit(ProductDetailError("Product not found"));
          }
        },
        onError: (error) {
          emit(ProductDetailError("Error fetching product details"));
        },
      );

      if (userId != null) {
        _wishlistSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc(event.productId)
            .snapshots()
            .listen(
          (snapshot) {
            add(_WishlistStatusUpdated(snapshot.exists));
          },
          onError: (error) {
            print("Error monitoring wishlist status: $error");
          },
        );
      }
    } catch (e) {
      emit(ProductDetailError("Error setting up product streams"));
    }
  }

//product update
  void _onProductUpdated(
      _ProductUpdated event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(ProductDetailsLoaded(
        base64Images: event.base64Images,
        productName: event.productName,
        productDescription: event.productDescription,
        productPrice: event.productPrice,
        isWishlisted: currentState.isWishlisted,
      ));
    } else {
      emit(ProductDetailsLoaded(
        base64Images: event.base64Images,
        productName: event.productName,
        productDescription: event.productDescription,
        productPrice: event.productPrice,
        isWishlisted: false,
      ));
    }
  }

//wishlist updated
  void _onWishlistStatusUpdated(
      _WishlistStatusUpdated event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(ProductDetailsLoaded(
        base64Images: currentState.base64Images,
        productName: currentState.productName,
        productDescription: currentState.productDescription,
        productPrice: currentState.productPrice,
        isWishlisted: event.isWishlisted,
      ));
    }
  }

//wishlist status
  Future<void> _onCheckWishlistStatus(
      CheckWishlistStatus event, Emitter<ProductDetailsState> emit) async {}

  Future<void> _onToggleWishlist(
      ToggleWishlist event, Emitter<ProductDetailsState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;

      final wishlistRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(event.productId);
      if (event.isCurrentlyWishlisted) {
        await wishlistRef.delete();
        emit(ProductDetailsLoaded(
          base64Images: currentState.base64Images,
          productName: currentState.productName,
          productDescription: currentState.productDescription,
          productPrice: currentState.productPrice,
          isWishlisted: false,
        ));
        // Show Snackbar - removing
        ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Removed from Wishlist')));
      } else {
        await wishlistRef.set({
          'productId': event.productId,
          'name': currentState.productName,
          'price': currentState.productPrice,
          'imageUrls': currentState.base64Images,
          'timestamp': FieldValue.serverTimestamp(),
        });
        emit(ProductDetailsLoaded(
          base64Images: currentState.base64Images,
          productName: currentState.productName,
          productDescription: currentState.productDescription,
          productPrice: currentState.productPrice,
          isWishlisted: true,
        ));
        // Show Snackbar - add
        ScaffoldMessenger.of(event.context)
            .showSnackBar(const SnackBar(content: Text('Added to Wishlist')));
      }
    }
  }

//Add to Cart
  Future<void> _onAddToCart(
      AddToCart event, Emitter<ProductDetailsState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(CartErrorState(errorMessage: "User not logged in"));
        return;
      }

      // Keep the current state
      if (state is! ProductDetailsLoaded) return;
      final currentState = state as ProductDetailsLoaded;

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      final batch = FirebaseFirestore.instance.batch();
      final cartItemRef = cartRef.doc(event.item.productId);

      final docSnapshot = await cartItemRef.get();
      if (docSnapshot.exists) {
        final currentQuantity = docSnapshot.data()?['quantity'] ?? 0;
        batch.update(cartItemRef, {'quantity': currentQuantity + 1});
      } else {
        batch.set(cartItemRef, event.item.toMap());
      }

      await batch.commit();

      emit(ProductDetailsLoaded(
        base64Images: currentState.base64Images,
        productName: currentState.productName,
        productDescription: currentState.productDescription,
        productPrice: currentState.productPrice,
        isWishlisted: currentState.isWishlisted,
      ));

      // Emit success state
      emit(CartItemAdded());

      // Re-emit the loaded state to maintain the UI
      emit(currentState);
    } catch (e) {
      print("Error adding to cart: $e");
      emit(CartErrorState(errorMessage: e.toString()));

      // Re-emit the previous state if it exists
      if (state is ProductDetailsLoaded) {
        emit(state);
      }
    }
  }
}
