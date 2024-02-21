import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../utils/constants/message_const.dart';

@immutable
class Message extends Equatable {
  final String role;
  final String content;

  const Message({required this.role, required this.content});

  Map<String, dynamic> toMap() {
    return {MessageConst.role: role, MessageConst.content: content};
  }

  @override
  List<Object?> get props => [role, content];
}

class UserMessage extends Message {
  const UserMessage({required super.content})
      : super(role: MessageConst.userRole);

  factory UserMessage.fromMap(Map<String, dynamic> map) {
    return UserMessage(content: map[MessageConst.content]);
  }
}

class AssistantMessage extends Message {
  const AssistantMessage({required super.content})
      : super(role: MessageConst.assistantRole);

  factory AssistantMessage.fromMap(Map<String, dynamic> map) {
    return AssistantMessage(content: map[MessageConst.content]);
  }
}
