import 'package:cloud_firestore/cloud_firestore.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchAddresses() async {
    final snapshot = await _firestore.collection('addresses').get();
    return snapshot.docs.map((doc) => doc['address'] as String).toList();
  }

  Future<void> addAddress(String address) async {
    await _firestore.collection('addresses').add({'address': address});
  }
}
