import 'package:chatgpt_api_demo/module/src/model/media_model.dart';
import 'package:chatgpt_api_demo/module/src/model/message_model.dart';
import 'package:chatgpt_api_demo/module/src/model/user_model.dart';
import 'package:chatgpt_api_demo/module/src/views/chat_widget.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatUser user1 = ChatUser(id: 'user1');
    final ChatUser user2 = ChatUser(id: 'user2');

    List<ChatMessage> messages = [
      ChatMessage(user: user2, messageText: "hello!!"),
      ChatMessage(
        user: user1,
        messageText: "hi",
        media: [
          const ChatMedia(
            path:
                "/data/user/0/com.example.chatgpt_api_demo/cache/file_picker/640px-Cup_and_Saucer_LACMA_47.35.6a-b_(1_of_3).jpg",
            fileName: "cup",
            mediaType: MediaType.image,
          ),
          const ChatMedia(
            path:
                "/data/user/0/com.example.chatgpt_api_demo/cache/file_picker/640px-Cup_and_Saucer_LACMA_47.35.6a-b_(1_of_3).jpg",
            fileName: "cup",
            mediaType: MediaType.image,
          ),
        ],
      ),
    ];

    final list = messages..reversed;

    return Scaffold(
      appBar: AppBar(),
      body: ChatView(
        currentUser: user1,
        messages: list,
      ),
    );
  }
}
