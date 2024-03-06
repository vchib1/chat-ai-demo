import 'package:dash_chat_2/dash_chat_2.dart';

class Message extends ChatMessage {
  Message({
    required super.user,
    required super.createdAt,
    super.isMarkdown = false,
    super.text = '',
    super.medias,
    super.quickReplies,
    super.customProperties,
    super.mentions,
    super.status = MessageStatus.none,
    super.replyTo,
  });

  Message copyWith(String? text) {
    return Message(
      text: text ?? this.text,
      createdAt: createdAt,
      user: user,
      medias: medias,
      customProperties: customProperties,
      isMarkdown: isMarkdown,
      mentions: mentions,
      quickReplies: quickReplies,
      replyTo: replyTo,
      status: status,
    );
  }

  /*factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(
      user: ChatUser.fromJson(jsonData['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(jsonData['createdAt'].toString()).toLocal(),
      text: jsonData['text']?.toString() ?? '',
      isMarkdown: jsonData['isMarkdown']?.toString() == 'true',
      medias: jsonData['medias'] != null
          ? (jsonData['medias'] as List<dynamic>)
          .map((dynamic media) =>
          ChatMedia.fromJson(media as Map<String, dynamic>))
          .toList()
          : <ChatMedia>[],
      quickReplies: jsonData['quickReplies'] != null
          ? (jsonData['quickReplies'] as List<dynamic>)
          .map((dynamic quickReply) =>
          QuickReply.fromJson(quickReply as Map<String, dynamic>))
          .toList()
          : <QuickReply>[],
      customProperties: jsonData['customProperties'] as Map<String, dynamic>?,
      mentions: jsonData['mentions'] != null
          ? (jsonData['mentions'] as List<dynamic>)
          .map((dynamic mention) =>
          Mention.fromJson(mention as Map<String, dynamic>))
          .toList()
          : <Mention>[],
      status: MessageStatus.parse(jsonData['status'].toString()),
      replyTo: jsonData['replyTo'] != null
          ? ChatMessage.fromJson(jsonData['replyTo'] as Map<String, dynamic>)
          : null,
    );
  }*/
}
