class ImageModel {
  final DateTime created;
  final List<String> images;

  const ImageModel({required this.created, required this.images});

  Map<String, dynamic> toMap() {
    return {
      'created': created.millisecondsSinceEpoch,
      'data': images.map((url) => {"url": url}).toList()
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    DateTime created =
        DateTime.fromMillisecondsSinceEpoch((map['created'] as int) * 1000);

    List<String> images =
        (map['data'] as List).map((e) => e['url'] as String).toList();

    return ImageModel(created: created, images: images);
  }
}
