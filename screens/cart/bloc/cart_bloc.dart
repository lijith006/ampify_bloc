import 'dart:async';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:ampify_bloc/screens/cart/cart_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  StreamSubscription<List<CartItem>>? _cartSubscription;

  CartBloc(this._cartService) : super(CartInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SaveForLater>(_onSaveForLater);
    on<CartUpdated>(_onCartUpdated);
  }

  // Load cart items
  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(CartError("User not logged in"));
        return;
      }

      await _cartSubscription?.cancel();

      // Set up real-time listener
      _cartSubscription = _cartService.getCartStream(userId).listen(
        (cartItems) {
          add(CartUpdated(cartItems));
        },
        onError: (error) {
          emit(CartError("Failed to load cart: ${error.toString()}"));
        },
      );
    } catch (e) {
      emit(CartError("Failed to load cart: ${e.toString()}"));
    }
  }

  void _onCartUpdated(CartUpdated event, Emitter<CartState> emit) {
    if (state is CartLoaded && (state as CartLoaded).cartItems == event.items) {
      return;
    }
    emit(CartLoaded(event.items));
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      print("Adding item to cart: ${event.item.title}");
      await _cartService.addToCart(userId, event.item);
      print("Item added successfully!");
    } catch (e) {
      emit(CartError("Failed to add item: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      print("Removing product ${event.productId} from cart...");
      await _cartService.removeFromCart(userId, event.productId);
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
        await _cartService.updateQuantity(
          userId,
          event.item.productId,
          newQuantity,
        );
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
      await _cartService.saveForLater(userId, event.item);
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
