import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  //REPLACE WITH YOUR RENDER.COM URL
  static const String serverURL =
      "https://fcm-server-jrrq.onrender.com/sendNotification";

  /// Send notification to admin or user
  static Future<void> sendNotificationTo({
    required String receiverUID,
    required String title,
    required String body,
  }) async {
    try {
      print("Sending notification to: $receiverUID");

      final response = await http.post(
        Uri.parse(serverURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "receiverUid": receiverUID,
          "title": title,
          "body": body,
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully!");
        print("Response: ${response.body}");
      } else {
        print("Failed to send notification");
        print("Status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  /// Save FCM token to Firestore (call after login)
  static Future<void> saveTokenToFirestore(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print("FCM Token saved for user $uid: ${token.substring(0, 20)}...");
      }
    } catch (e) {
      print("ERROR saving FCM token: $e");
    }
  }
}
