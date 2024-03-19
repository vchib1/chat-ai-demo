import 'package:chatgpt_api_demo/src/services/api/open_ai.dart';
import 'package:chatgpt_api_demo/src/utils/constants/message_const.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatNotifier = ChangeNotifierProvider(
    (ref) => ChatNotifier(api: ref.watch(openAIProvider)));

class ChatNotifier extends ChangeNotifier {
  ChatNotifier({required OpenAI api}) : _api = api;

  final OpenAI _api;

  final ChatUser user = ChatUser(id: MessageConst.userRole);
  final ChatUser assistant = ChatUser(id: MessageConst.assistantRole);

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Map<String, dynamic>> _conversationData = [];

  void _addMessageToList(ChatMessage message) {
    _messages = [message, ..._messages];

    if (_conversationData.length >= 6) {
      _conversationData.removeAt(0);
    }

    _conversationData.add({
      MessageConst.role: message.user.id,
      MessageConst.content: message.text,
    });
  }

  void _showLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    try {
      _showLoading(true);

      final userMessage = ChatMessage(
        user: user,
        createdAt: DateTime.now(),
        text: message,
      );

      _addMessageToList(userMessage);
      notifyListeners();

      final botRawResponse = await _api.sendPromptChat(
        prompt: userMessage.text,
        conversationData: _conversationData,
      );

      final assistantMessage = ChatMessage(
        user: assistant,
        createdAt: DateTime.now(),
        text: botRawResponse[MessageConst.content],
      );

      _addMessageToList(assistantMessage);
      notifyListeners();
    } catch (e) {
      _showLoading(false);
      final assistantMessage = ChatMessage(
        user: assistant,
        createdAt: DateTime.now(),
        text: e.toString(),
      );

      _addMessageToList(assistantMessage);
      notifyListeners();
    } finally {
      _showLoading(false);
    }
  }
}
