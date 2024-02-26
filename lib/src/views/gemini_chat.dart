import 'package:chatgpt_api_demo/src/providers/gemini_chat_provider.dart';
import 'package:chatgpt_api_demo/src/views/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GeminiChatPage extends HookWidget {
  const GeminiChatPage({super.key});

  Future<void> _pickImages(ValueNotifier<List<XFile>> images) async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isEmpty) return;
    images.value = pickedFiles;
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = useState(<XFile>[]);
    final inputController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final data = ref.read(geminiChatNotifier);
          final messages = ref.watch(geminiChatNotifier).messages;
          final isLoading = ref.watch(geminiChatNotifier).isLoading;
          final selectedImageCount = selectedImages.value.length;

          return ChatWidget(
            controller: inputController,
            currentUser: data.user,
            onSend: (msg) {
              if (selectedImageCount == 0) {
                data.sendTextMessage(msg.text);
              } else {
                data
                    .sendImageMessage(msg.text, selectedImages.value)
                    .whenComplete(() => selectedImages.value.clear());
              }
            },
            messages: messages,
            typingUsers: isLoading ? [data.bot] : [],
            enableMediaButton: true,
            showBadge: selectedImageCount > 0,
            onMediaPressed: () async => _pickImages(selectedImages),
            badgeContent: Text("$selectedImageCount"),
            onLongPressMessage: (msg) {},
          );
        },
      ),
    );
  }
}
