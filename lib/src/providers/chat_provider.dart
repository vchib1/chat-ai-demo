import 'package:chatgpt_api_demo/src/models/message_model.dart';
import 'package:chatgpt_api_demo/src/services/api/open_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatNotifier = StateNotifierProvider<ChatNotifier, List<Message>>(
    (ref) => ChatNotifier(api: ref.watch(openAIProvider)));

class ChatNotifier extends StateNotifier<List<Message>> {
  final OpenAI _api;

  ChatNotifier({required OpenAI api})
      : _api = api,
        super([]);

  final List<Map<String, dynamic>> _conversationData = [];

  void _addMessageToList(Message message) {
    state = [...state, message];
    _conversationData.add(message.toMap());
  }

  Future<void> sendMessage(UserMessage userMessage) async {
    try {
      _addMessageToList(userMessage);

      final botRawResponse = await _api.sendPromptChat(
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
