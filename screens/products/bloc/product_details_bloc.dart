import 'dart:async';

import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
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
            print(
                'Raw price value: ${productData['price']} (${productData['price'].runtimeType})');

            add(_ProductUpdated(
              base64Images: List<String>.from(productData['images'] ?? []),
              productName: productData['name'] ?? "No Name",
              productDescription:
                  productData['description'] ?? "No description available",
              productPrice: (productData['price'] is int ||
                      productData['price'] is double)
                  ? (productData['price'] as num).toDouble()
                  : double.tryParse(productData['price'].toString()) ?? 0.0,
            ));
          } else {
            emit(ProductDetailError("Product not found"));
          }
        },
        onError: (error) {
          emit(ProductDetailError("Error fetching product details"));
        },
      );

      if (userId != null) {}
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

      event.context.read<WishlistBloc>().add(ToggleWishlistItem(
            productId: event.productId,
            isCurrentlyWishlisted: event.isCurrentlyWishlisted,
            productData: {
              'name': currentState.productName,
              'price': currentState.productPrice,
              'imageUrls': currentState.base64Images,
            },
            // For snackbar messages
            context: event.context,
          ));
    }
  }

//Add to Cart
  Future<void> _onAddToCart(
      AddToCart event, Emitter<ProductDetailsState> emit) async {
    try {
      print("Adding item to cart: ${event.item.title}");
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
