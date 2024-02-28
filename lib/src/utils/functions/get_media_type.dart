import 'package:dash_chat_2/dash_chat_2.dart';

MediaType getMediaType(String? extension) {
  switch (extension) {
    case "jpg":
    case "jpeg":
    case "png":
    case "gif":
    case "bmp":
      return MediaType.image;
    case "mp4":
    case "mkv":
    case "avi":
    case "mov":
      return MediaType.video;
    case "pdf":
    case "doc":
    case "docx":
    case "xls":
    case "xlsx":
    case "ppt":
    case "pptx":
    case "txt":
      return MediaType.file;
    default:
      throw "Not a Suitable File";
  }
}
