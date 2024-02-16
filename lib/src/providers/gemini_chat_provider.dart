import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/gemini_ai.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiChatNotifier = ChangeNotifierProvider(
    (ref) => GeminiChatNotifier(api: ref.watch(geminiAPIProvider)));

class GeminiChatNotifier extends ChangeNotifier {
  final GeminiAPI _api;

  GeminiChatNotifier({required GeminiAPI api}) : _api = api;

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

  Future<void> sendMessage(UserMessage userMessage) async {
    try {
      _addMessageToList(userMessage);

      _showLoading(true);

      final response = await _api.sendPrompt(userMessage.content);

      final botMessage = AssistantMessage(content: response!);

      _addMessageToList(botMessage);
      _showLoading(false);
    } catch (e) {
      _showLoading(false);
      throw e.toString();
    }
  }
}
