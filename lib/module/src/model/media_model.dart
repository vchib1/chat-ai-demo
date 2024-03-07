class ChatMedia {
  const ChatMedia({
    required this.path,
    required this.fileName,
    required this.mediaType,
    this.uploadDate,
  });

  final String path;
  final String fileName;
  final MediaType mediaType;
  final DateTime? uploadDate;

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'fileName': fileName,
      'mediaType': mediaType.toString(),
      'uploadDate': uploadDate?.toIso8601String(),
    };
  }

  factory ChatMedia.fromMap(Map<String, dynamic> map) {
    return ChatMedia(
      path: map['path'] as String,
      fileName: map['fileName'] as String,
      mediaType: MediaType.parse(map['mediaType'].toString()),
      uploadDate: map['uploadDate'] != null
          ? DateTime.parse(map['uploadDate'] as String)
          : null,
    );
  }
}

class MediaType {
  const MediaType._internal(this._value);
  final String _value;

  @override
  String toString() => _value;

  static MediaType parse(String value) {
    switch (value) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'file':
        return MediaType.file;
      default:
        throw UnsupportedError('$value is not a valid MediaType');
    }
  }

  static const MediaType image = MediaType._internal('image');
  static const MediaType video = MediaType._internal('video');
  static const MediaType file = MediaType._internal('file');
}
