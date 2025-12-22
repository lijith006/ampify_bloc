import 'package:ampify_bloc/screens/chat_screen/model/chat_model.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatId;

  LoadMessages(this.chatId);
}

class SendMessage extends ChatEvent {
  final String chatId;
  final ChatMessage message;
  final String receiverId;

  SendMessage(this.chatId, this.message, this.receiverId);
}
