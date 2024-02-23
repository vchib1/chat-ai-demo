import 'dart:io';
import 'dart:typed_data';
import 'package:chatgpt_api_demo/src/services/api/imagine_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/functions/file_to_uint8.dart';

final bgRemoverNotifier = StateNotifierProvider<BGRemoverNotifier, Uint8List?>(
    (ref) => BGRemoverNotifier(api: ImageGenerationAPI()));

class BGRemoverNotifier extends StateNotifier<Uint8List?> {
  final ImageGenerationAPI _api;

  BGRemoverNotifier({required ImageGenerationAPI api})
      : _api = api,
        super(null);

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        state = await xFileToUInt8List(pickedFile);

        state = await _api.backgroundRemover(File(pickedFile.path));
      } else {
        throw "No image picked";
      }
    } catch (e) {
      rethrow;
    }
  }
}
