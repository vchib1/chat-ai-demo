import 'package:chatgpt_api_demo/src/providers/gemini_chat_provider.dart';
import 'package:chatgpt_api_demo/src/utils/functions/scroll_to_bottom.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_text_field.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';

class GeminiChatPage extends HookWidget {
  const GeminiChatPage({super.key});

  Future<void> _sendPrompt(
      WidgetRef ref, TextEditingController controller) async {
    final prompt = controller.text.trim();

    if (prompt.isEmpty) return;

    controller.clear();

    await ref.read(geminiChatNotifier).sendMessage(prompt);
  }

  void _onTap(WidgetRef ref, ValueNotifier<bool> selectMode, Message message) {
    final provider = ref.read(geminiChatNotifier);

    provider.selectMessage(message, selectMode.value);

    if (provider.selectedMessages.isEmpty) {
      selectMode.value = false;
    }
  }

  void _onLongPress(
      WidgetRef ref, ValueNotifier<bool> selectMode, Message message) {
    final provider = ref.read(geminiChatNotifier);

    provider.clearSelectedMessages();

    selectMode.value = !selectMode.value;

    if (provider.selectedMessages.isEmpty && selectMode.value) {
      provider.selectMessage(message, selectMode.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final scrollController = useScrollController();

    final selectMode = useState(false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer(
          builder: (context, ref, child) {
            return AppBar(
              actions: selectMode.value
                  ? [
                      Text(
                          "${ref.watch(geminiChatNotifier).selectedMessages.length} selected"),
                      IconButton(
                        onPressed: () {
                          ref.read(geminiChatNotifier).deleteSelectedMessages();
                          selectMode.value = false;
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  : [],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final messages = ref.watch(geminiChatNotifier).messages;
              final selectedMessages =
                  ref.watch(geminiChatNotifier).selectedMessages;

              if (!selectMode.value) {
                scrollToBottom(scrollController);
              }

              return ChatViewWidget(
                scrollController: scrollController,
                messages: messages,
                selectedMessages: selectedMessages,
                selectMode: selectMode.value,
                onTap: (message) => _onTap(ref, selectMode, message),
                onLongPress: (message) =>
                    _onLongPress(ref, selectMode, message),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(geminiChatNotifier).isLoading;

              return ChatTextField(
                controller: controller,
                isLoading: isLoading,
                onSubmitted: (_) => _sendPrompt(ref, controller),
                onPressed: () => _sendPrompt(ref, controller),
              );
            },
          )
        ],
      ),
    );
  }
}
