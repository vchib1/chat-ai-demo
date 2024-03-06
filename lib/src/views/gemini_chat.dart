import 'package:chatgpt_api_demo/src/providers/gemini_chat_provider.dart';
import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:chatgpt_api_demo/src/utils/snackbar.dart';
import 'package:chatgpt_api_demo/src/views/full_screen_media.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminiChatPage extends HookWidget {
  const GeminiChatPage({super.key});

  Future<void> _pickImages(
      BuildContext context, ValueNotifier<List<PlatformFile>> images) async {
    try {
      final pickedFiles = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['png', 'jpeg', 'jpg']);

      if (pickedFiles == null) return;

      images.value = pickedFiles.files;
    } catch (e) {
      if (context.mounted) {
        kShowSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = useState(<PlatformFile>[]);
    final inputController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Chat')),
      body: Consumer(
        builder: (context, ref, child) {
          final chat = ref.read(geminiChatNotifier);
          final messages = ref.watch(geminiChatNotifier).messages;
          final isLoading = ref.watch(geminiChatNotifier).isLoading;
          final selectedImageCount = selectedImages.value.length;

          return ChatWidget(
            controller: inputController,
            currentUser: chat.user,
            messages: messages,
            typingUsers: isLoading ? [chat.bot] : [],
            enableMediaButton: true,
            showBadge: selectedImageCount > 0,
            badgeContent: Text("$selectedImageCount"),
            onTapMedia: (media) => context.push(FullScreenView(media)),
            onSend: (msg) => chat
                .sendPrompt(msg.text, selectedImages.value)
                .then((value) => selectedImages.value.clear()),
            onMediaPressed: () async =>
                !isLoading ? await _pickImages(context, selectedImages) : null,
          );
        },
      ),
    );
  }
}
