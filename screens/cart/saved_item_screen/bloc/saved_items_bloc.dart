import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'saved_items_event.dart';
part 'saved_items_state.dart';

class SavedItemsBloc extends Bloc<SavedItemsEvent, SavedItemsState> {
  SavedItemsBloc() : super(SavedItemsLoading()) {
    on<LoadSavedItems>(_onLoadSavedItems);
    on<MoveToCart>(_onMoveToCart);
  }

  Future<void> _onLoadSavedItems(
      LoadSavedItems event, Emitter<SavedItemsState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(SavedItemsError('User not logged in'));
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved')
          .get();

      final savedItems =
          snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();

      emit(SavedItemsLoaded(savedItems));
    } catch (e) {
      emit(SavedItemsError('Failed to load saved items'));
    }
  }

  Future<void> _onMoveToCart(
      MoveToCart event, Emitter<SavedItemsState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final savedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('saved');

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    try {
      await savedRef.doc(event.item.productId).delete();
      await cartRef.doc(event.item.productId).set(event.item.toMap());

      //  Reload  SavedItems and Cart
      add(LoadSavedItems()); // Reload saved items
      event.cartBloc.add(LoadCartItems()); // --Reload cart
    } catch (e) {
      emit(SavedItemsError('Failed to move item to cart'));
    }
  }
}
