import 'package:chatgpt_api_demo/src/providers/gemini_chat_provider.dart';
import 'package:chatgpt_api_demo/src/utils/snackbar.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GeminiChatPage extends HookWidget {
  const GeminiChatPage({super.key});

  Future<void> _pickImages(
      BuildContext context, ValueNotifier<List<PlatformFile>> images) async {
    try {
      final pickedFiles = await FilePicker.platform.pickFiles();
      if (pickedFiles!.files.isEmpty) return;
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
            onSend: (msg) => chat
                .sendPrompt(msg.text, selectedImages.value)
                .then((value) => selectedImages.value.clear()),
            messages: messages,
            typingUsers: isLoading ? [chat.bot] : [],
            enableMediaButton: true,
            showBadge: selectedImageCount > 0,
            onMediaPressed: () async => _pickImages(context, selectedImages),
            badgeContent: Text("$selectedImageCount"),
          );
        },
      ),
    );
  }
}
