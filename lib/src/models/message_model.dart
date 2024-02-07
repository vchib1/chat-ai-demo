import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String role;
  final String content;

  const Message({required this.role, required this.content});

  Map<String, dynamic> toMap() {
    return {'role': role, 'content': content};
  }

  @override
  List<Object?> get props => [role, content];
}

class UserMessage extends Message {
  const UserMessage({super.role = "user", required super.content});

  factory UserMessage.fromMap(Map<String, dynamic> map) {
    return UserMessage(
      role: map['role'],
      content: map['content'],
    );
  }
}

class AssistantMessage extends Message {
  const AssistantMessage({super.role = "assistant", required super.content});

  factory AssistantMessage.fromMap(Map<String, dynamic> map) {
    return AssistantMessage(
      role: map['role'],
      content: map['content'],
    );
  }
}
