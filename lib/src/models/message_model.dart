import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Message extends Equatable {
  final String role;
  final String content;

  const Message({required this.role, required this.content});

  Map<String, dynamic> toMap() => {'role': role, 'content': content};

  @override
  List<Object?> get props => [role, content];
}

class UserMessage extends Message {
  const UserMessage({required super.content}) : super(role: "user");

  factory UserMessage.fromMap(Map<String, dynamic> map) {
    return UserMessage(content: map['content']);
  }
}

class AssistantMessage extends Message {
  const AssistantMessage({required super.content}) : super(role: "assistant");

  factory AssistantMessage.fromMap(Map<String, dynamic> map) {
    return AssistantMessage(content: map['content']);
  }
}
