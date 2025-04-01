import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final FirebaseFirestore firestore;

  ProductRepository(this.firestore);

  Stream<QuerySnapshot> fetchProducts() {
    return firestore.collection('products').snapshots();
  }
}
