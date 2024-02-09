import 'package:chatgpt_api_demo/src/providers/states/image_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/imagine_notifier.dart';

class ImagineAIPage extends StatefulWidget {
  const ImagineAIPage({super.key});

  @override
  State<ImagineAIPage> createState() => _ImagineAIPageState();
}

class _ImagineAIPageState extends State<ImagineAIPage> {
  //
  late TextEditingController _controller;

  late int _selectedArtStyle;

  final List<List<dynamic>> _artStyleOptions = [
    ["Anime", 21],
    ["Portrait", 26],
    ["Realistic", 29],
    ["Imagine V1", 27],
    ["Imagine V3", 28],
    ["Imagine V4", 30],
    ["Imagine V4 - Creative", 31],
    ["Imagine V4.1", 32],
    ["Imagine V5", 33],
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedArtStyle = _artStyleOptions.first[1];
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
    await ref.read(imagineState.notifier).sendPrompt(prompt, _selectedArtStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
            value: _selectedArtStyle,
            items: _artStyleOptions
                .map((e) => DropdownMenuItem(
                      value: e[1] as int,
                      child: Text(e[0]),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedArtStyle = value!)),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .80,
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
                    return Center(child: Text(state.error));
                }
              },
            ),
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
