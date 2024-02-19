import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:chatgpt_api_demo/src/views/bg_remover_page.dart';
import 'package:chatgpt_api_demo/src/views/chat_page.dart';
import 'package:chatgpt_api_demo/src/views/dall_e_ai.dart';
import 'package:chatgpt_api_demo/src/views/gemini_chat.dart';
import 'package:chatgpt_api_demo/src/views/imagine_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
