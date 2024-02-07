import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/providers/chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _sendPrompt(BuildContext context) async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty) {
      return;
    }

    _controller.clear();

    final chatProvider = context.read<ChatProvider>();

    await chatProvider.sendMessage(UserMessage(content: prompt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DEMO")),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                shrinkWrap: false,
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  //
                  final data = provider.messages[index];
                  final isLastMessage = index == provider.messages.length - 1;
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
          Container(
            height: MediaQuery.of(context).size.height * .1,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onSubmitted: (_) => _sendPrompt(context),
                    decoration: const InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendPrompt(context),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
