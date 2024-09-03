import 'dart:io';
import 'package:chatgpt_api_demo/src/utils/functions/get_mime_type.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const _apiKey = "";

class GeminiAPI {
  ChatSession? _chatModel;
  GenerativeModel? _imageModel;

  GeminiAPI() {
    _initialize();
  }

  _initialize() {
    if (_chatModel == null && _imageModel == null) {
      _chatModel = GenerativeModel(model: "gemini-pro", apiKey: _apiKey)
          .startChat(history: []);
      _imageModel =
          GenerativeModel(model: "gemini-pro-vision", apiKey: _apiKey);
    }
  }

  Stream<String> sendTextPrompt(String prompt) async* {
    try {
      _initialize();

      final response = _chatModel!.sendMessage(Content.text(prompt)).asStream();

      await for (final chunk in response) {
        yield chunk.text!;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<String> sendImagePrompt(
    String prompt,
    List<File> files,
  ) async* {
    try {
      _initialize();

      final response = _imageModel!.generateContentStream([
        Content.multi([
          TextPart(prompt),
          ...files.map((file) {
            return DataPart(getMimeType(file)!, file.readAsBytesSync());
          })
        ]),
      ]);

      await for (final chunk in response) {
        yield chunk.text ?? "";
      }
    } catch (e) {
      rethrow;
    }
  }
}
