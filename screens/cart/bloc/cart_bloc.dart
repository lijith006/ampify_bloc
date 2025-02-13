// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'cart_event.dart';
// import 'cart_state.dart';

// class CartBloc extends Bloc<CartEvent, CartState> {
//   CartBloc() : super(CartLoading()) {
//     on<LoadCartItems>(_onLoadCartItems);
//     on<AddToCart>(_onAddToCart);
//     on<RemoveFromCart>(_onRemoveFromCart);
//     on<UpdateQuantity>(_onUpdateQuantity);
//     on<MoveToCart>(_onMoveToCart);
//     on<SaveForLater>(_onSaveForLater);
//   }

//   void _onLoadCartItems(LoadCartItems event, Emitter<CartState> emit) {
//     emit(CartLoaded(cartItems: [], savedItems: [])); // Initial empty cart
//   }

//   void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
//     if (state is CartLoaded) {
//       final currentState = state as CartLoaded;
//       emit(CartLoaded(
//         cartItems: List.from(currentState.cartItems)..add(event.item),
//         savedItems: currentState.savedItems,
//       ));
//     }
//   }

//   void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
//     if (state is CartLoaded) {
//       final currentState = state as CartLoaded;
//       emit(CartLoaded(
//         cartItems: currentState.cartItems
//             .where((item) => item.productId != event.productId)
//             .toList(),
//         savedItems: currentState.savedItems,
//       ));
//     }
//   }

//   void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
//     if (state is CartLoaded) {
//       final currentState = state as CartLoaded;
//       final updatedItems = currentState.cartItems.map((item) {
//         if (item.productId == event.item.productId) {
//           int newQuantity = item.quantity + event.change;
//           return item.copyWith(quantity: newQuantity > 0 ? newQuantity : 1);
//         }
//         return item;
//       }).toList();

//       emit(CartLoaded(
//           cartItems: updatedItems, savedItems: currentState.savedItems));
//     }
//   }

//   void _onMoveToCart(MoveToCart event, Emitter<CartState> emit) {
//     if (state is CartLoaded) {
//       final currentState = state as CartLoaded;
//       emit(CartLoaded(
//         cartItems: List.from(currentState.cartItems)..add(event.item),
//         savedItems: currentState.savedItems
//             .where((item) => item.productId != event.item.productId)
//             .toList(),
//       ));
//     }
//   }

//   void _onSaveForLater(SaveForLater event, Emitter<CartState> emit) {
//     if (state is CartLoaded) {
//       final currentState = state as CartLoaded;
//       emit(CartLoaded(
//         cartItems: currentState.cartItems
//             .where((item) => item.productId != event.item.productId)
//             .toList(),
//         savedItems: List.from(currentState.savedItems)..add(event.item),
//       ));
//     }
//   }
// }
//********************************************************************************** */

// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:ampify_bloc/screens/cart/cart_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CartBloc extends Bloc<CartEvent, CartState> {
//   CartBloc() : super(CartLoading()) {
//     on<LoadCartItems>(_onLoadCartItems);
//     on<AddToCart>(_onAddToCart);
//     on<RemoveFromCart>(_onRemoveFromCart);
//     on<UpdateQuantity>(_onUpdateQuantity);
//     on<SaveForLater>(_onSaveForLater);
//   }

//   // Load cart items
//   Future<void> _onLoadCartItems(
//       LoadCartItems event, Emitter<CartState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       emit(CartError("User not logged in"));
//       return;
//     }

//     try {
//       emit(CartLoading());

//       final cartRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('cart');
//       final cartSnapshot = await cartRef.get();

//       List<CartItem> cartItems = cartSnapshot.docs.map((doc) {
//         return CartItem.fromMap(doc.data());
//       }).toList();

//       emit(CartLoaded(cartItems));
//     } catch (e) {
//       emit(CartError("Failed to load cart: ${e.toString()}"));
//     }
//   }

//   Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart')
//         .doc(event.item.productId)
//         .set(event.item.toMap());

//     add(LoadCartItems());
//   }

//   Future<void> _onRemoveFromCart(
//       RemoveFromCart event, Emitter<CartState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart')
//         .doc(event.productId)
//         .delete();

//     add(LoadCartItems());
//   }

//   Future<void> _onUpdateQuantity(
//       UpdateQuantity event, Emitter<CartState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     int newQuantity = event.item.quantity + event.change;
//     if (newQuantity > 0) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('cart')
//           .doc(event.item.productId)
//           .update({'quantity': newQuantity});
//     }
//     add(LoadCartItems());
//   }

//   Future<void> _onSaveForLater(
//       SaveForLater event, Emitter<CartState> emit) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final cartRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cart');

//     final savedRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('saved');

//     await cartRef.doc(event.item.productId).delete();
//     await savedRef.doc(event.item.productId).set(event.item.toMap());

//     add(LoadCartItems());
//   }
// }

//*************************************************************************** */

import 'dart:async';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  StreamSubscription<QuerySnapshot>? _cartSubscription;

  CartBloc() : super(CartLoading()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SaveForLater>(_onSaveForLater);
    on<_CartUpdated>(_onCartUpdated);
  }

  // Load cart items
  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(CartError("User not logged in"));
      return;
    }

    try {
      emit(CartLoading());

      await _cartSubscription?.cancel();

      // Set up real-time listener
      _cartSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .snapshots()
          .listen(
        (snapshot) {
          List<CartItem> cartItems = snapshot.docs.map((doc) {
            return CartItem.fromMap(doc.data());
          }).toList();
          add(_CartUpdated(cartItems));
        },
        onError: (error) {
          emit(CartError("Failed to load cart: ${error.toString()}"));
        },
      );
    } catch (e) {
      emit(CartError("Failed to load cart: ${e.toString()}"));
    }
  }

  void _onCartUpdated(_CartUpdated event, Emitter<CartState> emit) {
    emit(CartLoaded(event.items));
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(event.item.productId)
          .set(event.item.toMap());
      //  stream will handle updates..
    } catch (e) {
      emit(CartError("Failed to add item: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(event.productId)
          .delete();
    } catch (e) {
      emit(CartError("Failed to remove item: ${e.toString()}"));
    }
  }

//update - quantity
  Future<void> _onUpdateQuantity(
      UpdateQuantity event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      int newQuantity = event.item.quantity + event.change;
      if (newQuantity > 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(event.item.productId)
            .update({'quantity': newQuantity});
      }
    } catch (e) {
      emit(CartError("Failed to update quantity: ${e.toString()}"));
    }
  }

//Save for later products
  Future<void> _onSaveForLater(
      SaveForLater event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');
      final savedRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved');

      await cartRef.doc(event.item.productId).delete();
      await savedRef.doc(event.item.productId).set(event.item.toMap());
    } catch (e) {
      emit(CartError("Failed to save for later: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}

class _CartUpdated extends CartEvent {
  final List<CartItem> items;

  _CartUpdated(this.items);
}
