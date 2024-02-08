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
    return ImageModel(
      created:
          DateTime.fromMillisecondsSinceEpoch((map['created'] as int) * 1000),
      images: (map['data'] as List<dynamic>)
          .map((data) => data['url'] as String)
          .toList(),
    );
  }
}
