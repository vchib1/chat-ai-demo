import 'dart:convert';
import 'dart:io';
import 'package:chatgpt_api_demo/src/utils/error/http_status_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final openAIProvider = Provider<OpenAI>((ref) => OpenAI());

class OpenAI {
  final _apiKey = "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";
  final _baseURLChat = "https://api.openai.com/v1/chat/completions";
  final _baseURLImage = "https://api.openai.com/v1/images/generations";

  Map<String, String> get _headers =>
      {"Content-Type": "application/json", "Authorization": "Bearer $_apiKey"};

  Future<Map<String, dynamic>> sendPromptChat({
    required String prompt,
    required List<Map<String, dynamic>> conversationData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURLChat),
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
        case Status.OK:
          final Map<String, dynamic> botResponse =
              jsonDecode(response.body)["choices"][0]["message"];

          return botResponse;

        case Status.UNAUTHORIZED:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content": "Invalid Authentication"
          };

          return botResponse;

        case Status.TOO_MANY_REQUESTS:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content":
                "You exceeded your current quota, please check your plan and billing details"
          };

          return botResponse;

        case Status.SERVICE_UNAVAILABLE:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content":
                "The engine is currently overloaded, please try again later"
          };

          return botResponse;

        case Status.INTERNAL_SERVER_ERROR:
          final Map<String, dynamic> botResponse = {
            "role": "assistant",
            "content": "The server had an error while processing your request"
          };

          return botResponse;
        default:
          throw "ERROR CODE : ${response.statusCode}";
      }
    } on SocketException catch (_) {
      throw "NO INTERNET CONNECTION";
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendPromptImageGeneration(
      {required prompt}) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURLImage),
        headers: _headers,
        body: jsonEncode({
          "model": "dall-e-2",
          "prompt": prompt,
          "n": 1,
          "size": "1024x1024"
        }),
      );

      debugPrint(response.body);

      switch (response.statusCode) {
        case Status.OK:
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
