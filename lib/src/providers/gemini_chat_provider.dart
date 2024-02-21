import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:chatgpt_api_demo/src/utils/snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  final List<Map<String, dynamic>> _conversationData = [];

  Future<void> sendMessage(String prompt) async {
    try {
      UserMessage userMessage = UserMessage(content: prompt);

      _addMessageToList(userMessage);
      _showLoading(true);

      final botResponse = await _api.sendPrompt(userMessage.content);

      _addMessageToList(AssistantMessage(content: botResponse));
      _showLoading(false);
    } catch (e) {
      _showLoading(false);
      throw e.toString();
    }
  }

  void clearSelectedMessages() {
    _selectedMessages.clear();
  }

  void deleteSelectedMessages() {
    try {
      _messages.removeWhere((message) => _selectedMessages.contains(message));
      _selectedMessages.clear();
      notifyListeners();
    } catch (_) {}
  }

  void selectMessage(Message message, bool selectMode) {
    if (selectMode) {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);

        notifyListeners();
        return;
      }

      _selectedMessages.add(message);
      notifyListeners();
    }
  }

  void _addMessageToList(Message message) {
    _messages.add(message);

    if (_conversationData.length >= 6) {
      _conversationData.removeAt(0);
    }

    _conversationData.add(message.toMap());

    notifyListeners();
  }

  void _showLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
