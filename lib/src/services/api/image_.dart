import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageEnhancerAPI {
  final String _apiKey = "c4221a80-c640-11ee-bfcc-4d09780ce7c3";
  final String _baseURL = "https://deep-image.ai/rest_api/process_result";

  Future<void> sendImageProcessingRequest(File image) async {
    final headers = {
      "x-api-key": _apiKey,
    };

    final data = {
      "enhancements": ["denoise", "deblur", "light"],
      "width": 2000,
    };

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseURL))
        ..headers.addAll(headers)
        ..fields
            .addAll(data.map((key, value) => MapEntry(key, value.toString())))
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        debugPrint(result);
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }
}
