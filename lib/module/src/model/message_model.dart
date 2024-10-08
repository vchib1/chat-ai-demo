import 'package:chatgpt_api_demo/module/src/model/media_model.dart';
import 'package:chatgpt_api_demo/module/src/model/user_model.dart';

class ChatMessage {
  ChatMessage({
    required this.user,
    DateTime? createdAt,
    this.messageText = '',
    this.media,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      user: ChatUser.fromMap(map['user'] as Map<String, dynamic>),
      messageText: map['messageText'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      media: map['media'] != null
          ? (map['media'] as List)
              .map((e) => ChatMedia.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  final ChatUser user;

  final DateTime createdAt;

  final String messageText;

  final List<ChatMedia>? media;

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'messageText': messageText,
      'media': media?.map((e) => e.toMap()).toList(),
    };
  }

  ChatMessage copyWith({
    ChatUser? user,
    DateTime? createdAt,
    String? messageText,
    List<ChatMedia>? media,
  }) {
    return ChatMessage(
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      messageText: messageText ?? this.messageText,
      media: media ?? this.media,
    );
  }
}
