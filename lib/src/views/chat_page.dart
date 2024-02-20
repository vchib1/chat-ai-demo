import 'package:chatgpt_api_demo/src/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/functions/scroll_to_bottom.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //
  late TextEditingController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  Future<void> _sendPrompt(WidgetRef ref) async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty) return;

    _controller.clear();

    await ref.read(chatNotifier.notifier).sendMessage(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Open AI")),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final messages = ref.watch(chatNotifier).messages;

              scrollToBottom(_scrollController);

              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: messages.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = messages[index];
                  final isLastMessage = index == messages.length - 1;
                  final isUser = data.role == "user";
                  return Align(
                    alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: isLastMessage
                          ? EdgeInsets.fromLTRB(
                              8,
                              8,
                              8,
                              MediaQuery.of(context).size.height * .1 + 4.0,
                            )
                          : const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isUser ? 20 : 0),
                          topRight: Radius.circular(isUser ? 0 : 20),
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        data.content,
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              return Container(
                height: MediaQuery.of(context).size.height * .1,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onSubmitted: (_) => _sendPrompt(ref),
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ref.watch(chatNotifier).isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () => _sendPrompt(ref),
                            icon: const Icon(Icons.send),
                          ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
