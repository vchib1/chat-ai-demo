import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chatgpt_api_demo/module/src/model/message_model.dart';
import 'package:chatgpt_api_demo/module/src/model/user_model.dart';

const double _radius = 20.0;

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
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets inputPadding;
  final EdgeInsets? contentPadding;
  final String hintText;
  final TextEditingController? inputController;
  final Widget Function()? sendButtonBuilder;
  final BoxDecoration? textFieldDecoration;
  final void Function()? onSend;

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
    this.borderRadius,
    this.hintText = "Type here",
    this.inputController,
    this.contentPadding,
    this.sendButtonBuilder,
    this.textFieldDecoration,
    this.onSend,
    this.inputPadding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: false,
            reverse: true,
            physics: scrollPhysics ?? const ClampingScrollPhysics(),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              //
              final message = messages[index];
              final isUser = (message.user == currentUser);
              final msgHasMedia = (message.media != null);
              final mediaLength = (message.media?.length ?? 0);

              return Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: msgPadding,
                          margin: msgMargin,
                          decoration: BoxDecoration(
                            color: isUser
                                ? userMsgColor ??
                                    Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
                                : otherMsgColor ??
                                    Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                            borderRadius: borderRadius ??
                                BorderRadius.only(
                                  topLeft: isUser
                                      ? const Radius.circular(_radius)
                                      : const Radius.circular(0),
                                  topRight: !isUser
                                      ? const Radius.circular(_radius)
                                      : const Radius.circular(0),
                                  bottomLeft: const Radius.circular(_radius),
                                  bottomRight: const Radius.circular(_radius),
                                ),
                          ),
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (msgHasMedia)
                                Wrap(
                                  children: message.media!.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            _radius - 10.0),
                                        child: Image.file(
                                          File(message.media!.first.path),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .20,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              else
                                const SizedBox.shrink(),
                              Padding(
                                padding: msgHasMedia
                                    ? const EdgeInsets.only(
                                        bottom: 8.0, top: 8.0)
                                    : EdgeInsets.zero,
                                child: Text(
                                  message.messageText,
                                  style: msgTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          decoration: textFieldDecoration ??
              BoxDecoration(color: context.colorScheme.secondaryContainer),
          padding: inputPadding,
          child: Row(
            children: [
              /// Text Field
              Flexible(
                child: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding: contentPadding,
                  ),
                ),
              ),

              /// send button
              if (sendButtonBuilder == null)
                IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                )
              else
                sendButtonBuilder!()
            ],
          ),
        ),
      ],
    );
  }
}
