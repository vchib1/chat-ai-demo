import 'dart:io';
import 'package:chatgpt_api_demo/src/utils/functions/get_mime_type.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const _apiKey = "AIzaSyC1PD1LEXaKA5S0DMG5D-WmWqrkoaL3twE";

class GeminiAPI {
  late final ChatSession _chatModel;
  late final GenerativeModel _imageModel;

  GeminiAPI() {
    _chatModel = GenerativeModel(model: "gemini-pro", apiKey: _apiKey)
        .startChat(history: []);
    _imageModel = GenerativeModel(model: "gemini-pro-vision", apiKey: _apiKey);
  }

  Stream<String> sendTextPrompt(String prompt) async* {
    try {
      final response = _chatModel.sendMessage(Content.text(prompt)).asStream();

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
      final response = _imageModel.generateContentStream([
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

  Future<String> getObjectName({String location = "indoor"}) async {
    try {
      final prompt = '''
      You are participating in a Scavenger Hunt. Your current location is $location.
      Your task is to provide the name of an object that is easily accessible in the $location.
      Ensure the object is not repeated, not a living thing or a person, and requires no special tools.
      Return your response with only the object name in string format.
      ''';

      final result = await _chatModel.sendMessage(Content.text(prompt));

      return (result.text ?? "")
        ..trimLeft()
        ..trimRight()
        ..toLowerCase();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkImage(File image, String objectName) async {
    try {
      final prompt = '''
      You're a judge in a scavenger hunt. The player has given you an image of the object.
      Your task is to check whether the object which is "$objectName" matches with the attached photo.
      Return your response with only "yes" if it matches or "no" if not.
      ''';

      final res = await _imageModel.generateContent([
        Content.multi(
          [
            TextPart(prompt),
            DataPart(getMimeType(image)!, image.readAsBytesSync())
          ],
        )
      ]);

      return (res.text ?? "")
        ..trimLeft()
        ..trimRight()
        ..toLowerCase();
    } catch (e) {
      rethrow;
    }
  }
}
