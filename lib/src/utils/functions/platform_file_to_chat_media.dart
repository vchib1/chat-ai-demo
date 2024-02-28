import 'package:chatgpt_api_demo/src/utils/functions/get_media_type.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';

List<ChatMedia> platformFilesToChatMediaImage(List<PlatformFile> files) {
  return files
      .map((file) => ChatMedia(
          url: file.path!,
          fileName: file.name,
          type: getMediaType(file.extension)))
      .toList();
}
