import 'package:chatgpt_api_demo/src/providers/states/image_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/imagine_ai.dart';

final imagineState = StateNotifierProvider<ImagineStateNotifier, ImagineState>(
    (ref) => ImagineStateNotifier(api: ImageGenerationAPI()));

class ImagineStateNotifier extends StateNotifier<ImagineState> {
  final ImageGenerationAPI _api;

  ImagineStateNotifier({required ImageGenerationAPI api})
      : _api = api,
        super(ImagineInitialState());

  Future<void> sendPrompt(String prompt, int style) async {
    try {
      state = ImagineLoadingState();

      final response =
          await _api.sendImageProcessingRequest(prompt: prompt, style: style);

      state = ImagineLoadedState(bytes: response);
    } catch (e) {
      state = ImagineErrorState(message: e.toString());
    }
  }
}
