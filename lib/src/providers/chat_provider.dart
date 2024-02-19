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
  bool _messageLoading = false;
  bool get messageLoading => _messageLoading;
  final List<Map<String, dynamic>> _conversationData = [];

  void _addMessageToList(Message message) {
    _messages.add(message);
    _conversationData.add(message.toMap());
    notifyListeners();
  }

  void _showLoading(bool value) {
    _messageLoading = value;
    notifyListeners();
  }

  Future<void> sendMessage(String prompt) async {
    try {
      UserMessage userMessage = UserMessage(content: prompt);

      _addMessageToList(userMessage);

      _showLoading(true);

      final botRawResponse = await _api.sendPromptChat(
        prompt: userMessage.content,
        conversationData: _conversationData,
      );

      final botMessage = AssistantMessage.fromMap(botRawResponse);

      _addMessageToList(botMessage);
      _showLoading(false);
    } catch (e) {
      _showLoading(false);
      throw e.toString();
    }
  }
}
