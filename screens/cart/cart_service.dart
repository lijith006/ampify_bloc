import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ampify_bloc/screens/cart/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CartItem>> getCartStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
    });
  }

  // Fetch cart items for a user
  Future<List<CartItem>> getCartItems(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      return querySnapshot.docs
          .map((doc) => CartItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Add an item to the cart
  Future<void> addToCart(String userId, CartItem item) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.productId)
          .set(item.toMap());
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Remove an item from the cart
  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Update item quantity in the cart
  Future<void> updateQuantity(
      String userId, String productId, int quantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Save an item for later
  Future<void> saveForLater(String userId, CartItem item) async {
    try {
      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart');
      final savedRef =
          _firestore.collection('users').doc(userId).collection('saved');

      await cartRef.doc(item.productId).delete();
      await savedRef.doc(item.productId).set(item.toMap());
    } catch (e) {
      throw Exception('Failed to save for later: $e');
    }
  }
}
