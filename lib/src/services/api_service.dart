import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  final _apiKey = "";
  final _baseURL = "https://api.openai.com/v1/chat/completions";

  Map<String, String> get _headers =>
      {"Content-Type": "application/json", "Authorization": "Bearer $_apiKey"};

  Future<Map<String, dynamic>> sendPrompt({
    required String prompt,
    required List<Map<String, dynamic>> conversationData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL),
        headers: _headers,
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              ...conversationData,
              {"role": "assistant", "content": prompt}
            ]
          },
        ),
      );

      switch (response.statusCode) {
        //
        case HttpStatus.OK:
          final Map<String, dynamic> botResponse =
              jsonDecode(response.body)["choices"][0]["message"];

          return botResponse;

        case HttpStatus.INVALID_AUTH:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content": "Invalid Authentication"
          };

          return botResponse;

        case HttpStatus.QUOTA_EXCEEDED:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content":
                "You exceeded your current quota, please check your plan and billing details"
          };

          return botResponse;

        case HttpStatus.ENGINE_OVERLOADED:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content":
                "The engine is currently overloaded, please try again later"
          };

          return botResponse;

        case HttpStatus.SERVER_ERROR:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content": "The server had an error while processing your request"
          };

          return botResponse;
        default:
          throw "ERROR CODE : ${response.statusCode}";
      }
    } catch (e) {
      rethrow;
    }
  }
}

class HttpStatus {
  static const int OK = 200;
  static const int INVALID_AUTH = 401;
  static const int QUOTA_EXCEEDED = 429;
  static const int SERVER_ERROR = 500;
  static const int ENGINE_OVERLOADED = 503;
}
