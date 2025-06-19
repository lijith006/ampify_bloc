import 'package:ampify_bloc/screens/chat_screen/chat_bloc/bloc/chat_bloc.dart';
import 'package:ampify_bloc/screens/chat_screen/chat_bloc/bloc/chat_event.dart';
import 'package:ampify_bloc/screens/chat_screen/chat_bloc/bloc/chat_state.dart';
import 'package:ampify_bloc/screens/chat_screen/model/chat_model.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String currentUserId;
  final ChatBloc chatBloc;

  ChatScreen({
    required this.chatId,
    required this.currentUserId,
    required this.chatBloc,
  });

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with admin')),
      body: SafeArea(
        child: BlocBuilder<ChatBloc, ChatState>(
          bloc: chatBloc..add(LoadMessages(chatId)),
          builder: (context, state) {
            if (state is ChatLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              // Scroll to bottom after UI is built
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isMe = msg.senderId == currentUserId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (_controller.text.trim().isEmpty) return;
                              final profileState =
                                  context.read<ProfileBloc>().state;
                              if (profileState is ProfileLoaded) {
                                final userProfile = profileState.userProfile;
                                final message = ChatMessage(
                                  senderId: currentUserId,
                                  senderName: userProfile['name'] ?? 'Unknown',
                                  senderEmail:
                                      userProfile['email'] ?? 'No email',
                                  senderBase64Image:
                                      userProfile['profileImage'],
                                  text: _controller.text.trim(),
                                  timestamp: DateTime.now(),
                                  isSeen: false,
                                );
                                chatBloc.add(SendMessage(chatId, message));
                                _controller.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("User profile not loaded")),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No chat available'));
            }
          },
        ),
      ),
    );
  }
}
