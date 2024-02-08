import 'package:chatgpt_api_demo/src/models/image_model.dart';
import 'package:chatgpt_api_demo/src/services/api/open_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageState = StateNotifierProvider<ImageStateNotifier, ImageState>(
    (ref) => ImageStateNotifier(api: ref.watch(openAIProvider)));

class ImageStateNotifier extends StateNotifier<ImageState> {
  final OpenAI _api;

  ImageStateNotifier({required OpenAI api})
      : _api = api,
        super(ImageInitialState());

  Future<void> sendPrompt(String prompt) async {
    try {
      state = ImageLoadingState();

      final rawResponse = await _api.sendPromptImageGeneration(prompt: prompt);
      ImageModel data = ImageModel.fromMap(rawResponse);
      state = ImageLoadedState(data: data);

      state = ImageLoadedState(data: data);
    } catch (e) {
      state = ImageErrorState(error: e.toString());
    }
  }
}

sealed class ImageState {}

class ImageInitialState extends ImageState {}

class ImageLoadingState extends ImageState {}

class ImageLoadedState extends ImageState {
  final ImageModel data;

  ImageLoadedState({required this.data});
}

class ImageErrorState extends ImageState {
  final String error;

  ImageErrorState({required this.error});
}
