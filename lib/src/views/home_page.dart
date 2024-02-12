import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:chatgpt_api_demo/src/views/bg_remover_page.dart';
import 'package:chatgpt_api_demo/src/views/chat_page.dart';
import 'package:chatgpt_api_demo/src/views/dall_e_ai.dart';
import 'package:chatgpt_api_demo/src/views/imagine_ai.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              onPressed: () => context.push(page: const ChatPage()),
              child: const Text("ChatBot"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(page: const DallEPage()),
              child: const Text("Dall-e Image generator"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(page: const ImagineAIPage()),
              child: const Text("Imagine AI Image generator"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: context.width * .50,
              onPressed: () => context.push(page: const BGRemoverPage()),
              child: const Text("Background Remover"),
            ),
          ],
        ),
      ),
    );
  }
}
