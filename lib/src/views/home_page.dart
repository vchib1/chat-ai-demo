import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:chatgpt_api_demo/src/views/chat_page.dart';
import 'package:chatgpt_api_demo/src/views/image_page.dart';
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
              minWidth: MediaQuery.of(context).size.width * .50,
              onPressed: () => context.push(page: const ChatPage()),
              child: const Text("ChatBot"),
            ),
            MaterialButton(
              color: context.colorScheme.secondaryContainer,
              minWidth: MediaQuery.of(context).size.width * .50,
              onPressed: () => context.push(page: const ImagePage()),
              child: const Text("Image"),
            ),
          ],
        ),
      ),
    );
  }
}
