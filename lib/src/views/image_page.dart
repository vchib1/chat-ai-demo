import 'package:chatgpt_api_demo/src/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
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

  Future<void> _sendPrompt(WidgetRef ref) async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty) {
      return;
    }

    _controller.clear();
    await ref.read(imageState.notifier).sendPrompt(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(imageState);

              switch (state) {
                case ImageInitialState():
                  return const Center(child: Text("Enter a prompt"));

                case ImageLoadingState():
                  return const Center(child: CircularProgressIndicator());

                case ImageLoadedState():
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

                case ImageErrorState():
                  return Center(child: Text(state.error));
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
                        controller: _controller,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onSubmitted: (_) => _sendPrompt(ref),
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
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
