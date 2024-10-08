import 'package:chatgpt_api_demo/src/providers/dall_e_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/states/image_states.dart';

class DallEPage extends HookWidget {
  const DallEPage({super.key});

  Future<void> _sendPrompt(
      WidgetRef ref, TextEditingController controller) async {
    final prompt = controller.text.trim();

    if (prompt.isEmpty) return;

    controller.clear();

    await ref.read(dallEState.notifier).sendPrompt(prompt);
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              if (ref.watch(dallEState) is DallELoadedState) {
                return TextButton(
                  onPressed: () => ref.read(dallEState.notifier).resetState,
                  child: const Text("Clear"),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(dallEState);

              switch (state) {
                case DallEInitialState():
                  return const Center(child: Text("Enter a prompt"));

                case DallELoadingState():
                  return const Center(child: CircularProgressIndicator());

                case DallELoadedState():
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.data.images.length,
                    itemBuilder: (context, index) {
                      final String url = state.data.images[index];

                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .80,
                        child: Image.network(url),
                      );
                    },
                  );

                case DallEErrorState():
                  return Center(child: Text(state.message));
              }
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
                        controller: controller,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onSubmitted: (_) => _sendPrompt(ref, controller),
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _sendPrompt(ref, controller),
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
