import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:chatgpt_api_demo/src/utils/error/http_status_codes.dart';
import 'package:image_picker/image_picker.dart';

class ImageGenerationAPI {
  final String _apiKey = "vk-8DcOP2zMFES34frqq39abwFvBXIl21I6FQoRPpo7lFK2FDx";
  final String _baseURL = "https://api.vyro.ai/v1/imagine/api/generations";

  Future<Uint8List> sendImageProcessingRequest(
      {required String prompt, required int style}) async {
    try {
      final headers = <String, String>{"Authorization": "Bearer $_apiKey"};

      final body = <String, String>{
        "prompt": prompt,
        "style_id": '$style',
        "high_res_results": '1'
      };

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(_baseURL),
      )
        ..headers.addAll(headers)
        ..fields.addAll(body);

      final res = await request.send();

      if (res.statusCode == Status.OK) {
        final responseData = await res.stream.toBytes();
        return responseData;
      } else {
        throw "Error: ${res.statusCode} : ${res.reasonPhrase}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print(pickedFile.path);

      return File(pickedFile.path);
    } else {
      return null; // User canceled image pick
    }
  }

  Future<Uint8List> backgroundRemover() async {
    File? imageFile = await _pickImage();

    try {
      final headers = <String, String>{"Authorization": "Bearer $_apiKey"};

      final file = await http.MultipartFile.fromPath('image', imageFile!.path);

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.vyro.ai/v1/imagine/api/background/remover"),
      )
        ..headers.addAll(headers)
        ..files.add(file);

      final res = await request.send();

      if (res.statusCode == Status.OK) {
        final responseData = await res.stream.toBytes();
        return responseData;
      } else {
        throw "Error: ${res.statusCode} : ${res.reasonPhrase}";
      }
    } catch (e) {
      rethrow;
    }
  }
}
