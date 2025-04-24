import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String? senderBase64Image;
  final String text;
  final DateTime timestamp;
  final bool isSeen;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    this.senderBase64Image,
    required this.text,
    required this.timestamp,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderBase64Image': senderBase64Image,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isSeen': isSeen,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    print("DEBUG: Parsing message map -> $map");
    final raw = map['timestamp'];
    DateTime parsed;
    if (raw is Timestamp) {
      parsed = raw.toDate();
    } else if (raw is String) {
      parsed = DateTime.tryParse(raw) ?? DateTime.now();
    } else {
      parsed = DateTime.now();
    }
    return ChatMessage(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      senderBase64Image: map['senderBase64Image'],
      text: map['text'] ?? '',
      timestamp: parsed,
      isSeen: map['isSeen'] ?? false,
    );
  }
}
