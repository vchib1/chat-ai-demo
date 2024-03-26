import 'package:chatgpt_api_demo/module/src/views/chat_widget.dart';
import 'package:chatgpt_api_demo/src/providers/gemini_chat_provider.dart';
import 'package:chatgpt_api_demo/src/utils/snackbar.dart';
import 'package:chatgpt_api_demo/src/views/full_screen_media.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badge;

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
        Snackbar(context).show(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickedImages = useState(<PlatformFile>[]);
    final inputController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Chat')),
      body: Consumer(
        builder: (context, ref, child) {
          final chat = ref.read(geminiChatNotifier);
          final messages = ref.watch(geminiChatNotifier).messages;
          final isLoading = ref.watch(geminiChatNotifier).isLoading;
          final selectedImageCount = pickedImages.value.length;

          return ChatView(
            inputController: inputController,
            currentUser: chat.user,
            messages: messages,
            isMsgLoading: chat.isLoading,
            onMediaTap: (media) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenView(media),
                ),
              );
            },
            sendButtonBuilder: () {
              return Row(
                children: [
                  /// Media Button
                  if (true)
                    GestureDetector(
                      onTap: () => _pickImages(context, pickedImages),
                      child: badge.Badge(
                        showBadge: selectedImageCount > 0,
                        badgeContent: Text("$selectedImageCount"),
                        child: const Icon(Icons.image),
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  const SizedBox(width: 16.0),

                  /// Send Button
                  IconButton(
                    onPressed: () async {
                      if (selectedImageCount != 0) {
                        if (inputController.text.isEmpty) return;
                      }

                      final images = [...pickedImages.value];
                      final prompt = inputController.text;

                      inputController.clear();
                      pickedImages.value.clear();

                      await chat.sendPrompt(prompt, images);
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Widget bkup(){
//   return ChatView(
//     inputController: inputController,
//     currentUser: chat.user,
//     messages: messages,
//     //onTapMedia: (media) => context.push(FullScreenView(media)),
//     onSend: (msg) =>
//         chat.sendPrompt(msg, selectedImages.value).then((value) {
//           selectedImages.value.clear();
//           inputController.clear();
//         }),
//     // onMediaPressed: () async =>
//     //     !isLoading ? await _pickImages(context, selectedImages) : null,
//   );
// }
