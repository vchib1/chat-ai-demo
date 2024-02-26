import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;

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
    this.enableMediaButton = false,
    this.onLongPressMessage,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

              /// Send Button
              IconButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    final msg = ChatMessage(
                      text: controller.text,
                      createdAt: DateTime.now(),
                      user: currentUser,
                    );

                    onSend(msg);

                    controller.clear();
                  },
                  icon: const Icon(Icons.send)),
            ],
          );
        },
      ),
      messageOptions: MessageOptions(
        containerColor: context.colorScheme.primaryContainer,
        onLongPressMessage: onLongPressMessage,
        marginDifferentAuthor: const EdgeInsets.all(1.0),
      ),
    );
  }
}
