import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  final FirebaseFirestore firestore;

  CategoryRepository(this.firestore);

  Stream<List<Map<String, dynamic>>> fetchCategories() {
    return firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          // used Spread operator to include all fields
          ...doc.data(),
        };
      }).toList();
    });
  }
}
