// // lib/notifications/fcm_service.dart

// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   /// Request Notification Permission
//   Future<void> requestPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );

//     log(" Notification Permission: ${settings.authorizationStatus}");
//   }

//   /// Get Device Token
//   Future<String?> getDeviceToken() async {
//     String? token = await _firebaseMessaging.getToken();
//     log(" FCM Device Token: $token");
//     return token;
//   }

//   /// Listen to token refresh
//   void listenToTokenRefresh(Function(String) onTokenRefresh) {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       log(" FCM Token Refreshed: $newToken");
//       onTokenRefresh(newToken);
//     });
//   }

//   /// Show notifications when app is in foreground
//   void enableForegroundNotifications() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("Foreground Notification Received!");
//       log("Title = ${message.notification?.title}");
//       log("Body = ${message.notification?.body}");
//     });
//   }
// }
