import 'dart:io';
import 'package:chatgpt_api_demo/module/src/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_api_demo/module/src/model/user_model.dart';
import 'package:chatgpt_api_demo/module/src/model/message_model.dart';
import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';

const double _radius = 20.0;

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.inputController,
    this.scrollPhysics,
    this.userMsgColor,
    this.otherMsgColor,
    this.borderRadius,
    this.hintText = "Type here",
    this.contentPadding,
    this.sendButtonBuilder,
    this.textFieldDecoration,
    this.onSend,
    this.onMediaTap,
    this.enableSelectMode = false,
    this.isMsgLoading = false,
    this.msgTextStyle = const TextStyle(),
    this.inputPadding = const EdgeInsets.all(8.0),
    this.msgPadding = const EdgeInsets.all(8.0),
    this.msgMargin = const EdgeInsets.all(8.0),
    this.duration = const Duration(milliseconds: 300),
  });

  final List<ChatMessage> messages;
  final ChatUser currentUser;
  final ScrollPhysics? scrollPhysics;
  final Color? userMsgColor;
  final Color? otherMsgColor;
  final EdgeInsets msgPadding;
  final EdgeInsets msgMargin;
  final TextStyle msgTextStyle;
  final bool enableSelectMode;
  final bool isMsgLoading;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets inputPadding;
  final EdgeInsets? contentPadding;
  final String hintText;
  final Duration duration;
  final TextEditingController inputController;
  final Widget Function()? sendButtonBuilder;
  final BoxDecoration? textFieldDecoration;
  final void Function(String)? onSend;
  final void Function(ChatMedia)? onMediaTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                shrinkWrap: false,
                reverse: true,
                physics: scrollPhysics ?? const ClampingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  //
                  final message = messages[index];
                  final isUser = (message.user == currentUser);
                  final msgHasMedia = (message.media != null);

                  return Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AnimatedContainer(
                              duration: duration,
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
                                      bottomLeft:
                                          const Radius.circular(_radius),
                                      bottomRight:
                                          const Radius.circular(_radius),
                                    ),
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (msgHasMedia)
                                    Wrap(
                                      children: message.media!.map((media) {
                                        return GestureDetector(
                                          onTap: () => onMediaTap!(media),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 2.0,
                                              bottom: 4.0,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      _radius - 10.0),
                                              child: Image.file(
                                                File(media.path),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .50,
                                                fit: BoxFit.cover,
                                              ),
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
                                            bottom: 8.0,
                                            top: 8.0,
                                          )
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
              Visibility(
                visible: isMsgLoading,
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(),
                ),
              ),
            ],
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
                  onSubmitted: (txt) {
                    if (txt.isNotEmpty && onSend != null) {
                      onSend!(txt);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: hintText,
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: contentPadding,
                  ),
                ),
              ),

              /// Send button
              if (sendButtonBuilder == null)
                IconButton(
                  onPressed: () => onSend!(inputController.text.trim()),
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
