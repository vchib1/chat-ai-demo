import 'package:chatgpt_api_demo/src/providers/chat_provider.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_text_field.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/functions/scroll_to_bottom.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  Future<void> _sendPrompt(
      WidgetRef ref, TextEditingController controller) async {
    final prompt = controller.text.trim();

    if (prompt.isEmpty) return;

    controller.clear();

    await ref.read(chatNotifier.notifier).sendMessage(prompt);
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
                          "${ref.watch(chatNotifier).selectedMessages.length} selected"),
                      IconButton(
                        onPressed: () {
                          ref.read(chatNotifier).deleteSelectedMessages();
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
              final messages = ref.watch(chatNotifier).messages;
              final selectedMessages = ref.watch(chatNotifier).selectedMessages;

              if (!selectMode.value) {
                scrollToBottom(scrollController);
              }

              scrollToBottom(scrollController);

              return ChatViewWidget(
                scrollController: scrollController,
                messages: messages,
                selectedMessages: selectedMessages,
                selectMode: selectMode.value,
                onTap: (message) => ref
                    .read(chatNotifier)
                    .selectMessage(message, selectMode.value),
                onLongPress: () {
                  ref.read(chatNotifier).clearSelectedMessages();

                  selectMode.value = !selectMode.value;
                },
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(chatNotifier).isLoading;

              return ChatTextField(
                controller: controller,
                isLoading: isLoading,
                onSubmitted: (_) => _sendPrompt(ref, controller),
                onPressed: () => _sendPrompt(ref, controller),
              );
            },
          ),
        ],
      ),
    );
  }
}
