import 'package:chatgpt_api_demo/src/providers/bg_remove_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BGRemoverPage extends StatelessWidget {
  const BGRemoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(bgRemoverNotifier);

          if (state == null) {
            return Center(
              child: TextButton(
                onPressed: () {
                  ref.read(bgRemoverNotifier.notifier).pickImage();
                },
                child: const Text("Pick a Image"),
              ),
            );
          }

          return Container(
            alignment: Alignment.center,
            child: Image.memory(state),
          );
        },
      ),
    );
  }
}
