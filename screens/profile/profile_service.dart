// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfileService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //Get prodile info
//   Future<Map<String, dynamic>> getUserProfile(String userId) async {
//     try {
//       final doc = await _firestore.collection('users').doc(userId).get();
//       if (doc.exists) {
//         return doc.data()!;
//       } else {
//         throw Exception('User not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to fetch user profile');
//     }
//   }

// //update user
//   Future<void> updateProfile(
//       String userId, Map<String, dynamic> updates) async {
//     try {
//       await _firestore.collection('users').doc(userId).update(updates);
//     } catch (e) {
//       throw Exception('Failed to update profile');
//     }
//   }

// //Delete user
//   Future<void> deleteAccount(String userId) async {
//     try {
//       await _firestore.collection('users').doc(userId).delete();
//       await FirebaseAuth.instance.currentUser?.delete();
//     } catch (e) {
//       throw Exception('Failed to delete account');
//     }
//   }
// }
//******************************************************** */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out');
    }
  }

  //Get prodile info
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data()!;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile');
    }
  }

//update user
  Future<void> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }

//Delete user
  Future<void> deleteAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      throw Exception('Failed to delete account');
    }
  }
}
