import 'package:chatgpt_api_demo/src/providers/chat_provider.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Open AI Chat')),
      body: Consumer(
        builder: (context, ref, child) {
          final chat = ref.read(chatNotifier);
          final messages = ref.watch(chatNotifier).messages;
          final isLoading = ref.watch(chatNotifier).isLoading;

          return ChatWidget(
            controller: controller,
            currentUser: chat.user,
            onSend: (message) => chat.sendMessage(message.text),
            messages: messages,
            typingUsers: isLoading ? [chat.assistant] : [],
          );
        },
      ),
    );
  }
}
