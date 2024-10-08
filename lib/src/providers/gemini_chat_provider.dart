import 'dart:io';
import 'package:chatgpt_api_demo/module/src/model/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:chatgpt_api_demo/src/utils/constants/message_const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../module/src/model/media_model.dart';
import '../../module/src/model/user_model.dart';
import '../utils/functions/platform_file_to_chat_media.dart';

final geminiChatNotifier = ChangeNotifierProvider<GeminiChatNotifier>(
    (ref) => GeminiChatNotifier(api: GeminiAPI()));

class GeminiChatNotifier extends ChangeNotifier {
  final GeminiAPI? _api;

  GeminiChatNotifier({required GeminiAPI api}) : _api = api;

  final ChatUser user = ChatUser(id: MessageConst.userRole);
  final ChatUser bot = ChatUser(id: MessageConst.assistantRole);

  int get _maxChatHistoryLength => 6;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Content> _chatHistory = [];

  Future<void> sendPrompt(
    String prompt,
    List<PlatformFile> pickedImages,
  ) async {
    try {
      if (pickedImages.isEmpty) {
        debugPrint("Sending Text Prompt");
        return await _sendTextMessage(prompt);
      }

      debugPrint("Sending Image Prompt");
      await _sendImageMessage(prompt, pickedImages);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _sendTextMessage(String prompt) async {
    try {
      _showLoading(true);

      _addMessageToList(user, prompt);
      notifyListeners();

      assert(_api != null);
      final botResponse = _api!.sendTextPrompt(prompt);

      String message = "";

      await for (final text in botResponse) {
        if (isLoading) {
          _addMessageToList(bot, message);
          _showLoading(false);
        }

        message += text;
        _updateBotMessage(message);
        notifyListeners();
      }

      _addChatHistory(Content.text(prompt));
      _addChatHistory(Content('model', [TextPart(message)]));
    } on SocketException catch (_) {
      _addErrorMsg("No internet connection");
    } catch (e) {
      _addErrorMsg("$e");
    } finally {
      _showLoading(false);
    }
  }

  Future<void> _sendImageMessage(
    String prompt,
    List<PlatformFile> selectedImages,
  ) async {
    try {
      _showLoading(true);

      final media = platformFilesToChatMediaImage(selectedImages);

      _addMessageToList(user, prompt, media: media);
      notifyListeners();

      List<File> images = selectedImages.map((e) => File(e.path!)).toList();

      assert(_api != null);
      final botResponse = _api!.sendImagePrompt(prompt, images);

      String message = "";

      await for (final text in botResponse) {
        if (isLoading) {
          _addMessageToList(bot, message);
          _showLoading(false);
        }

        message += text;
        _updateBotMessage(message);
      }
    } on SocketException catch (_) {
      _addErrorMsg("No internet connection");
    } catch (e) {
      _addErrorMsg("$e");
    } finally {
      _showLoading(false);
    }
  }

  void _addMessageToList(
    ChatUser user,
    String text, {
    List<ChatMedia>? media,
  }) {
    _messages = List.from([
      ChatMessage(
        user: user,
        createdAt: DateTime.now(),
        messageText: text,
        media: media,
      ),
      ...messages
    ]);
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

  void _addErrorMsg(String message) {
    _messages.first = _messages.first.copyWith(messageText: message);
    notifyListeners();
  }

  void _updateBotMessage(String message) {
    _messages.first = _messages.first.copyWith(messageText: message);
    notifyListeners();
  }
}
