import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get userId => _auth.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> fetchAddresses() async {
    if (userId.isEmpty) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, 'address': doc['address'] as String})
        .toList();
  }

  Future<void> addAddress(String address) async {
    if (userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add({'address': address});
  }

  Future<void> updateAddress(String id, String newAddress) async {
    if (userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(id)
        .update({'address': newAddress});
  }

  Future<void> deleteAddress(String id) async {
    if (userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(id)
        .delete();
  }
}
