import 'dart:convert';
import 'dart:io';
import 'package:chatgpt_api_demo/src/utils/constants/message_const.dart';
import 'package:chatgpt_api_demo/src/utils/error/http_status_codes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final openAIProvider = Provider<OpenAI>((ref) => OpenAI());

class OpenAI {
  final _apiKey = "";

  final _baseURL = "https://api.openai.com/v1";

  Map<String, String> get _headers =>
      {"Content-Type": "application/json", "Authorization": "Bearer $_apiKey"};

  Future<Map<String, dynamic>> sendPromptChat({
    required String prompt,
    required List<Map<String, dynamic>> conversationData,
  }) async {
    try {
      const model = "gpt-3.5-turbo";
      const endPoint = "/chat/completions";

      final body = jsonEncode({
        "model": model,
        "messages": [
          ...conversationData,
          {"role": "assistant", "content": prompt}
        ]
      });

      final response = await http.post(
        Uri.parse("$_baseURL$endPoint"),
        headers: _headers,
        body: body,
      );

      switch (response.statusCode) {
        case Status.ok:
          return jsonDecode(response.body)["choices"][0]["message"];

        case Status.tooManyRequests:
          return {
            MessageConst.role: "assistant",
            MessageConst.content:
                "You exceeded your current quota, please check your plan and billing details"
          };
        default:
          throw "ERROR CODE : ${response.statusCode}";
      }
    } on SocketException catch (_) {
      throw "NO INTERNET CONNECTION";
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendPromptImageGeneration({
    required prompt,
  }) async {
    try {
      const model = "dall-e-2";
      const endPoint = "/images/generations";

      final body = jsonEncode({
        "model": model,
        "prompt": prompt,
        "n": 1,
        "size": "1024x1024",
      });

      final response = await http.post(
        Uri.parse("$_baseURL$endPoint"),
        headers: _headers,
        body: body,
      );

      switch (response.statusCode) {
        case Status.ok:
          return jsonDecode(response.body);
        default:
          throw "ERROR CODE : ${response.statusCode}, ${response.reasonPhrase}";
      }
    } on SocketException catch (_) {
      throw "NO INTERNET CONNECTION";
    } catch (e) {
      rethrow;
    }
  }
}
