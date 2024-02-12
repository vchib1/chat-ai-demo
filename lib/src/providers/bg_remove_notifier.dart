import 'dart:io';
import 'dart:typed_data';
import 'package:chatgpt_api_demo/src/services/api/imagine_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final bgRemoverNotifier = StateNotifierProvider<BGRemoverNotifier, Uint8List?>(
    (ref) => BGRemoverNotifier(api: ImageGenerationAPI()));

class BGRemoverNotifier extends StateNotifier<Uint8List?> {
  final ImageGenerationAPI _api;

  BGRemoverNotifier({required ImageGenerationAPI api})
      : _api = api,
        super(null);

  Future<Uint8List> fileToUInt8List(String filePath) async {
    File file = File(filePath);
    RandomAccessFile randomAccessFile = await file.open();

    int length = await file.length();

    Uint8List res = await randomAccessFile.read(length);

    await randomAccessFile.close();

    return res;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);

        state = await fileToUInt8List(file.path);

        state = await _api.backgroundRemover(file);
      } else {
        throw "No image picked";
      }
    } catch (e) {
      rethrow;
    }
  }
}
