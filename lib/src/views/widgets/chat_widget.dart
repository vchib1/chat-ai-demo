import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatWidget extends StatelessWidget {
  final ChatUser currentUser;
  final List<ChatMessage> messages;
  final void Function(ChatMessage) onSend;
  final TextEditingController controller;
  final bool showBadge;
  final bool enableMediaButton;
  final List<ChatUser>? typingUsers;
  final Widget? badgeContent;
  final void Function()? onMediaPressed;
  final void Function(ChatMedia)? onTapMedia;
  final int pickedMediaLength;
  final dynamic Function(ChatMessage)? onLongPressMessage;

  const ChatWidget({
    super.key,
    required this.currentUser,
    required this.messages,
    required this.onSend,
    required this.controller,
    this.showBadge = false,
    this.badgeContent,
    this.onMediaPressed,
    this.typingUsers,
    this.pickedMediaLength = 0,
    this.enableMediaButton = false,
    this.onLongPressMessage,
    this.onTapMedia,
  });

  @override
  Widget build(BuildContext context) {
    return DashChat(
      currentUser: currentUser,
      onSend: (_) {},
      messages: messages,
      scrollToBottomOptions: const ScrollToBottomOptions(disabled: false),
      typingUsers: typingUsers,
      inputOptions: InputOptions(
        textController: controller,
        alwaysShowSend: true,
        sendButtonBuilder: (sendButton) {
          return Row(
            children: [
              /// Media Button
              if (enableMediaButton)
                GestureDetector(
                  onTap: onMediaPressed,
                  child: badge.Badge(
                    showBadge: showBadge,
                    badgeContent: badgeContent,
                    child: const Icon(Icons.image),
                  ),
                )
              else
                const SizedBox.shrink(),

              const SizedBox(width: 16.0),

              /// Send Button
              IconButton(
                onPressed: () {
                  if (pickedMediaLength != 0) {
                    if (controller.text.isEmpty) return;
                  }

                  final msg = ChatMessage(
                    text: controller.text.trim(),
                    createdAt: DateTime.now(),
                    user: currentUser,
                  );

                  onSend(msg);

                  controller.clear();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          );
        },
      ),
      messageOptions: MessageOptions(
        currentUserContainerColor: context.colorScheme.primaryContainer,
        containerColor: context.colorScheme.secondaryContainer,
        spaceWhenAvatarIsHidden: 10.0,
        showOtherUsersAvatar: false,
        onTapMedia: onTapMedia,
        messageTextBuilder: (message, previousMessage, nextMessage) {
          return MarkdownBody(
            data: message.text,
            selectable: true,
          );
        },
        onLongPressMessage: onLongPressMessage,
      ),
    );
  }
}
