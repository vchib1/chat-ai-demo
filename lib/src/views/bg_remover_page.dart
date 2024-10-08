import 'package:chatgpt_api_demo/src/providers/bg_remove_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BGRemoverPage extends StatelessWidget {
  const BGRemoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              if (ref.watch(bgRemoverNotifier) == null) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: () {
                  ref.read(bgRemoverNotifier.notifier).clearImage;
                },
                child: const Text("Clear"),
              );
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final image = ref.watch(bgRemoverNotifier);

          if (image == null) {
            return Center(
              child: TextButton(
                onPressed: () =>
                    ref.read(bgRemoverNotifier.notifier).pickImage(),
                child: const Text("Pick a Image"),
              ),
            );
          }

          return Container(
            alignment: Alignment.center,
            child: Image.memory(image),
          );
        },
      ),
    );
  }
}
