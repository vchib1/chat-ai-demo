import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/open_ai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatNotifier = ChangeNotifierProvider(
    (ref) => ChatNotifier(api: ref.watch(openAIProvider)));

class ChatNotifier extends ChangeNotifier {
  final OpenAI _api;

  ChatNotifier({required OpenAI api}) : _api = api;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  final List<Message> _selectedMessages = [];
  List<Message> get selectedMessages => _selectedMessages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Map<String, dynamic>> _conversationData = [];

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

  Future<void> sendMessage(String message) async {
    try {
      UserMessage userMessage = UserMessage(content: message);

      _addMessageToList(userMessage);
      _showLoading(true);

      final botRawResponse = await _api.sendPromptChat(
        prompt: userMessage.content,
        conversationData: _conversationData,
      );

      _addMessageToList(AssistantMessage.fromMap(botRawResponse));
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
    if (!selectMode) return;

    if (_selectedMessages.contains(message)) {
      _selectedMessages.remove(message);
    } else {
      _selectedMessages.add(message);
    }

    notifyListeners();
  }
}
