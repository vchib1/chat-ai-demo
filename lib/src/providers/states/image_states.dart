import 'dart:typed_data';
import '../../models/image_model.dart';

sealed class DallEState {}

class DallEInitialState extends DallEState {}

class DallELoadingState extends DallEState {}

class DallELoadedState extends DallEState {
  final ImageModel data;

  DallELoadedState({required this.data});
}

class DallEErrorState extends DallEState {
  final String error;

  DallEErrorState({required this.error});
}

sealed class ImagineState {}

class ImagineInitialState extends ImagineState {}

class ImagineLoadingState extends ImagineState {}

class ImagineLoadedState extends ImagineState {
  final Uint8List bytes;

  ImagineLoadedState({required this.bytes});
}

class ImagineErrorState extends ImagineState {
  final String error;

  ImagineErrorState({required this.error});
}
