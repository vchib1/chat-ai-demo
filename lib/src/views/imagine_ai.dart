import 'package:chatgpt_api_demo/src/providers/states/image_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/imagine_notifier.dart';
import '../utils/constants/app_const.dart';

class ImagineAIPage extends HookWidget {
  const ImagineAIPage({super.key});

  Future<void> _sendPrompt(
    WidgetRef ref,
    TextEditingController controller,
    int selectedArtStyle,
  ) async {
    final prompt = controller.text.trim();

    if (prompt.isEmpty) return;

    controller.clear();
    await ref.read(imagineState.notifier).sendPrompt(prompt, selectedArtStyle);
  }

  @override
  Widget build(BuildContext context) {
    final selectedArtStyle = useState(artStyle.first.id);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
            value: selectedArtStyle.value,
            items: artStyle
                .map((style) => DropdownMenuItem(
                      value: style.id,
                      child: Text(style.name),
                    ))
                .toList(),
            onChanged: (value) => selectedArtStyle.value = value!),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              if (ref.watch(imagineState) is ImagineLoadedState) {
                return TextButton(
                  onPressed: () => ref.read(imagineState.notifier).resetState,
                  child: const Text("Clear"),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(imagineState);

                switch (state) {
                  case ImagineInitialState():
                    return const Center(child: Text("Enter a prompt"));

                  case ImagineLoadingState():
                    return const Center(child: CircularProgressIndicator());

                  case ImagineLoadedState():
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * .80,
                      child: Image.memory(state.bytes),
                    );

                  case ImagineErrorState():
                    return Center(child: Text(state.message));
                }
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onSubmitted: (_) => _sendPrompt(
                            ref, controller, selectedArtStyle.value),
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _sendPrompt(ref, controller, selectedArtStyle.value),
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
