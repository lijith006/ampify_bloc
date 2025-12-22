// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// class ChatNotificationSender {
//   static const String serverKey = "YOUR_FCM_SERVER_KEY"; // from Firebase

//   /// Send notification to specific user
//   static Future<void> sendNotification({
//     required String receiverUserId,
//     required String title,
//     required String body,
//   }) async {
//     // 1. Get receiver's token
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverUserId)
//         .get();

//     if (!userDoc.exists) return;

//     String? token = userDoc['fcmToken'];

//     if (token == null || token.isEmpty) {
//       print("Receiver has no FCM token.");
//       return;
//     }

//     // 2. Prepare message
//     final data = {
//       "to": token,
//       "notification": {
//         "title": title,
//         "body": body,
//         "sound": "default",
//       },
//       "data": {
//         "click_action": "FLUTTER_NOTIFICATION_CLICK",
//         "screen": "chat",
//       }
//     };

//     // 3. Send POST request to FCM
//     final res = await http.post(
//       Uri.parse("https://fcm.googleapis.com/fcm/send"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "key=$serverKey",
//       },
//       body: jsonEncode(data),
//     );

//     print("FCM Response: ${res.body}");
//   }
// }
