import 'package:chatgpt_api_demo/module/src/views/test_page.dart';
import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:chatgpt_api_demo/src/views/bg_remover_page.dart';
import 'package:chatgpt_api_demo/src/views/chat_page.dart';
import 'package:chatgpt_api_demo/src/views/dall_e_ai.dart';
import 'package:chatgpt_api_demo/src/views/gemini_chat.dart';
import 'package:chatgpt_api_demo/src/views/imagine_ai.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TestPage()));
        },
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(const ChatPage()),
              child: const Text("Open AI Chat"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(const GeminiChatPage()),
              child: const Text("Gemini Chat"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(const DallEPage()),
              child: const Text("Dall-e Image generator"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(const ImagineAIPage()),
              child: const Text("Imagine AI Image generator"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(const BGRemoverPage()),
              child: const Text("Background Remover"),
            ),
          ],
        ),
      ),
    );
  }
}
