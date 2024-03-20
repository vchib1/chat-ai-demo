import 'package:chatgpt_api_demo/module/src/model/media_model.dart';
import 'package:chatgpt_api_demo/src/utils/functions/get_media_type.dart';
import 'package:file_picker/file_picker.dart';

List<ChatMedia> platformFilesToChatMediaImage(List<PlatformFile> files) {
  try {
    return files
        .map((file) => ChatMedia(
            path: file.path!,
            fileName: file.name,
            mediaType: getMediaType(file.extension)))
        .toList();
  } catch (e) {
    rethrow;
  }
}
