import 'package:ampify_bloc/screens/chat_screen/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());

    //  Upsert the root chat-room document with metadata
    await _firestore.collection('chats').doc(chatId).set({
      'userId': message.senderId,
      'userName': message.senderName,
      'userImage': message.senderBase64Image,
      'lastMessage': message.text,
      'lastTimestamp': Timestamp.fromDate(message.timestamp),
      'lastSender': 'user',
      'isSeen': false,
    }, SetOptions(merge: true));
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }
}
