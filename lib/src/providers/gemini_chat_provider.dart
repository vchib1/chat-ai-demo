import 'dart:typed_data';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/functions/file_to_uint8.dart';
import '../utils/functions/xfile_to_chat_media.dart';

final geminiChatNotifier = ChangeNotifierProvider<GeminiChatNotifier>(
    (ref) => GeminiChatNotifier(api: GeminiAPI([])));

class GeminiChatNotifier extends ChangeNotifier {
  final GeminiAPI _api;

  GeminiChatNotifier({required GeminiAPI api}) : _api = api;

  final ChatUser user = ChatUser(id: "idUser", firstName: "User");
  final ChatUser bot = ChatUser(id: "idBot", firstName: "Gemini");

  final int _maxChatHistoryLength = 6;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  final List<Content> _chatHistory = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> sendPrompt(String prompt, List<XFile> selectedImages) async {
    try {
      if (selectedImages.isEmpty) {
        await _sendTextMessage(prompt);
      } else {
        await _sendImageMessage(prompt, selectedImages);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _sendTextMessage(String prompt) async {
    try {
      _showLoading(true);

      _addMessageToList(user, prompt);

      final botResponse = await _api.sendTextPrompt(prompt);

      _addMessageToList(bot, botResponse);

      _addChatHistory(Content.text(prompt));
      _addChatHistory(Content('model', [TextPart(botResponse)]));
    } catch (e) {
      throw e.toString();
    } finally {
      _showLoading(false);
    }
  }

  Future<void> _sendImageMessage(
      String prompt, List<XFile> selectedImages) async {
    try {
      _showLoading(true);

      _addMessageToList(
        user,
        prompt,
        medias: xFilesToChatMediaImage(selectedImages),
      );

      List<Uint8List> images = [];

      for (final img in selectedImages) {
        images.add(await xFileToUInt8List(img));
      }

      final botResponse = await _api.sendImagePrompt(prompt, images);

      _addMessageToList(bot, botResponse);
    } catch (e) {
      throw e.toString();
    } finally {
      _showLoading(false);
    }
  }

  void _addMessageToList(ChatUser user, String text,
      {List<ChatMedia>? medias}) {
    _messages = List.from([
      ChatMessage(
        user: user,
        createdAt: DateTime.now(),
        text: text,
        medias: medias,
      ),
      ..._messages
    ]);

    notifyListeners();
  }

  void _addChatHistory(Content message) {
    if (_chatHistory.length > _maxChatHistoryLength) {
      _chatHistory.removeAt(0);
    }
    _chatHistory.add(message);
  }

  void _showLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
