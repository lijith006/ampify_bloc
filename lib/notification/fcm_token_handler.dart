import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTokenHandler {
  static Future<void> saveTokenToFirestore(String userId) async {
    final fcm = FirebaseMessaging.instance;

    // get token
    final token = await fcm.getToken();
    if (token == null) return;

    // save/update in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fcmToken': token,
      'tokenUpdatedAt': DateTime.now(),
    });
  }
}
