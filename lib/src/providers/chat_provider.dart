import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final API _api;

  ChatProvider({required API api}) : _api = api;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  final List<Map<String, dynamic>> _conversationData = [];

  void _addMessageToList(Message message) {
    try {
      _messages.add(message);
      _conversationData.add(message.toMap());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(UserMessage userMessage) async {
    try {
      _addMessageToList(userMessage);

      final botRawResponse = await _api.sendPrompt(
        prompt: userMessage.content,
        conversationData: _conversationData,
      );

      final botMessage = AssistantMessage.fromMap(botRawResponse);

      _addMessageToList(botMessage);
    } catch (e) {
      throw e.toString();
    }
  }
}
