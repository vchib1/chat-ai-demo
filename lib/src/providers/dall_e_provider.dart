import 'package:chatgpt_api_demo/src/models/image_model.dart';
import 'package:chatgpt_api_demo/src/providers/states/image_states.dart';
import 'package:chatgpt_api_demo/src/services/api/open_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dallEState = StateNotifierProvider<DallEStateNotifier, DallEState>(
    (ref) => DallEStateNotifier(api: ref.watch(openAIProvider)));

class DallEStateNotifier extends StateNotifier<DallEState> {
  final OpenAI _api;

  DallEStateNotifier({required OpenAI api})
      : _api = api,
        super(DallEInitialState());

  Future<void> sendPrompt(String prompt) async {
    try {
      state = DallELoadingState();

      final rawResponse = await _api.sendPromptImageGeneration(prompt: prompt);

      ImageModel data = ImageModel.fromMap(rawResponse);

      state = DallELoadedState(data: data);
    } catch (e) {
      state = DallEErrorState(message: e.toString());
    }
  }

  void get resetState => state = DallEInitialState();
}
