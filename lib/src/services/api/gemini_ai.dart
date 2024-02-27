import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const _apiKey = "AIzaSyC1PD1LEXaKA5S0DMG5D-WmWqrkoaL3twE";

class GeminiAPI {
  final _chatModel = GenerativeModel(model: "gemini-pro", apiKey: _apiKey);
  final _imageModel =
      GenerativeModel(model: "gemini-pro-vision", apiKey: _apiKey);

  late final ChatSession _chat;

  final List<Content> chatHistory;

  GeminiAPI(this.chatHistory) {
    _chat = _chatModel.startChat(history: chatHistory);
  }

  Future<String> sendTextPrompt(String prompt) async {
    try {
      final response = await _chat.sendMessage(Content.text(prompt));

      return response.text ?? "Something went wrong";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> sendImagePrompt(
    String prompt,
    List<Uint8List> images,
  ) async {
    try {
      final response = await _imageModel.generateContent([
        Content.multi([
          TextPart(prompt),
          ...images.map((image) => DataPart('image/jpeg', image))
        ]),
      ]);

      return response.text ?? "Something went wrong";
    } catch (e) {
      return e.toString();
    }
  }
}
