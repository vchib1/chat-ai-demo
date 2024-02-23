import 'dart:io';
import 'dart:typed_data';

import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final geminiChatNotifier = ChangeNotifierProvider(
    (ref) => GeminiChatNotifier(api: ref.watch(geminiAPIProvider)));

class GeminiChatNotifier extends ChangeNotifier {
  final GeminiAPI _api;

  GeminiChatNotifier({required GeminiAPI api}) : _api = api;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  final List<Message> _selectedMessages = [];
  List<Message> get selectedMessages => _selectedMessages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendTextMessage(String prompt) async {
    try {
      UserMessage userMessage = UserMessage(content: prompt);

      _addMessageToList(userMessage);
      _showLoading(true);

      final botResponse = await _api.sendTextPrompt([Content.text(prompt)]);

      _addMessageToList(AssistantMessage(content: botResponse));
      _showLoading(false);
    } catch (e) {
      _showLoading(false);
      throw e.toString();
    }
  }

  Future<void> sendImageMessage(String prompt, List<Uint8List> images) async {
    try {
      _addMessageToList(UserMessage(content: prompt));
      _showLoading(true);

      final botResponse = await _api.sendImagePrompt(prompt, images);

      _addMessageToList(AssistantMessage(content: botResponse));
      _showLoading(false);
    } catch (e) {
      _showLoading(false);
      throw e.toString();
    }
  }

  void clearSelectedMessages() => _selectedMessages.clear();

  void deleteSelectedMessages() {
    try {
      _messages.removeWhere((message) => _selectedMessages.contains(message));
      _selectedMessages.clear();
      notifyListeners();
    } catch (_) {}
  }

  void selectMessage(Message message, bool selectMode) {
    if (selectMode == false) return;

    if (_selectedMessages.contains(message)) {
      _selectedMessages.remove(message);
    } else {
      _selectedMessages.add(message);
    }

    notifyListeners();
  }

  void _addMessageToList(Message message) {
    _messages.add(message);

    for (Message msg in _messages) {
      print(msg);
    }

    notifyListeners();
  }

  void _showLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
