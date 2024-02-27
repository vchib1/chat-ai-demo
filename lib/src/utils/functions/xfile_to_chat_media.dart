import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';

List<ChatMedia> xFilesToChatMediaImage(List<XFile> images) {
  return images
      .map((image) => ChatMedia(
          url: image.path, fileName: image.name, type: MediaType.image))
      .toList();
}
