import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final geminiAPIProvider = Provider<GeminiAPI>((ref) => GeminiAPI());

class GeminiAPI {
  final _apiKey = "AIzaSyC1PD1LEXaKA5S0DMG5D-WmWqrkoaL3twE";
  final _model = "gemini-pro";

  Future<String> sendPrompt(String prompt) async {
    try {
      final model = GenerativeModel(model: _model, apiKey: _apiKey);

      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);

      return response.text ?? "Something went wrong";
    } catch (e) {
      return e.toString();
    }
  }
}
