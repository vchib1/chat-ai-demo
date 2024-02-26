import 'dart:typed_data';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/functions/file_to_uint8.dart';

final geminiChatNotifier = ChangeNotifierProvider(
    (ref) => GeminiChatNotifier(api: ref.watch(geminiAPIProvider)));

class GeminiChatNotifier extends ChangeNotifier {
  final GeminiAPI _api;

  GeminiChatNotifier({required GeminiAPI api}) : _api = api;

  final ChatUser user = ChatUser(id: "idUser", firstName: "User");
  final ChatUser bot = ChatUser(
      id: "idBot", firstName: "Gemini", customProperties: {'test': 'test'});

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendTextMessage(String prompt) async {
    try {
      ChatMessage userMessage =
          ChatMessage(user: user, createdAt: DateTime.now(), text: prompt);

      _addMessageToList(userMessage);

      _showLoading(true);

      final botResponse = await _api.sendTextPrompt(prompt);

      _addMessageToList(
        ChatMessage(user: bot, createdAt: DateTime.now(), text: botResponse),
      );
    } catch (e) {
      throw e.toString();
    } finally {
      _showLoading(false);
    }
  }

  Future<void> sendImageMessage(
      String prompt, List<XFile> selectedImages) async {
    try {
      _addMessageToList(
        ChatMessage(
          user: user,
          createdAt: DateTime.now(),
          text: prompt,
          medias: selectedImages
              .map((image) => ChatMedia(
                  url: image.path, fileName: image.name, type: MediaType.image))
              .toList(),
        ),
      );
      _showLoading(true);

      List<Uint8List> images = [];

      for (final img in selectedImages) {
        images.add(await xFileToUInt8List(img));
      }

      final botResponse = await _api.sendImagePrompt(prompt, images);

      _addMessageToList(
          ChatMessage(user: bot, createdAt: DateTime.now(), text: botResponse));
    } catch (e) {
      throw e.toString();
    } finally {
      _showLoading(false);
    }
  }

  void _addMessageToList(ChatMessage message) {
    _messages = [message, ..._messages];
    notifyListeners();
  }

  void _showLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
