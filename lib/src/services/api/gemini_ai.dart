import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final geminiAPIProvider = Provider<GeminiAPI>((ref) => GeminiAPI());

class GeminiAPI {
  final _apiKey = "AIzaSyC1PD1LEXaKA5S0DMG5D-WmWqrkoaL3twE";

  Future<String> sendTextPrompt(List<Content> content) async {
    try {
      final model = GenerativeModel(model: "gemini-pro", apiKey: _apiKey);

      final response = await model.generateContent(content);

      return response.text ?? "Something went wrong";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> sendImagePrompt(String prompt, List<Uint8List> images) async {
    try {
      final model =
          GenerativeModel(model: "gemini-pro-vision", apiKey: _apiKey);

      final response = await model.generateContent([
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
