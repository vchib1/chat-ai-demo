import 'package:chatgpt_api_demo/module/src/model/message_model.dart';
import 'package:chatgpt_api_demo/module/src/model/user_model.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final List<ChatMessage> messages;
  final ChatUser currentUser;
  final ScrollPhysics? scrollPhysics;
  final Color? userMsgColor;
  final Color? otherMsgColor;
  final EdgeInsets msgPadding;
  final EdgeInsets msgMargin;
  final TextStyle msgTextStyle;
  final bool enableSelectMode;

  const ChatView({
    super.key,
    required this.messages,
    required this.currentUser,
    this.scrollPhysics,
    this.userMsgColor,
    this.otherMsgColor,
    this.enableSelectMode = false,
    this.msgPadding = const EdgeInsets.all(8.0),
    this.msgMargin = const EdgeInsets.all(8.0),
    this.msgTextStyle = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      physics: scrollPhysics ?? const ClampingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        //
        final message = messages[index];
        final isUser = (message.user == currentUser);

        return Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Stack(
                children: [
                  Container(
                    padding: msgPadding,
                    margin: msgMargin,
                    color: isUser
                        ? userMsgColor ?? Theme.of(context).colorScheme.primary
                        : otherMsgColor ??
                            Theme.of(context).colorScheme.secondaryContainer,
                    child: Text(
                      message.messageText,
                      style: msgTextStyle,
                    ),
                  ),
                  Container(
                    padding: msgPadding,
                    margin: msgMargin,
                    color: isUser
                        ? userMsgColor ?? Theme.of(context).colorScheme.primary
                        : otherMsgColor ??
                            Theme.of(context).colorScheme.secondaryContainer,
                    child: Text(
                      message.messageText,
                      style: msgTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
