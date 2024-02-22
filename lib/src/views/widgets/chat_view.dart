import 'package:chatgpt_api_demo/src/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class ChatViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final List<Message> messages;
  final List<Message> selectedMessages;
  final bool selectMode;
  final void Function(Message)? onTap;
  final void Function(Message)? onLongPress;

  const ChatViewWidget({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.selectedMessages,
    required this.selectMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        reverse: true,
        physics: const ClampingScrollPhysics(),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          final isUser = message.role == "user";
          return GestureDetector(
            onTap: () => onTap!(message),
            onLongPress: () => onLongPress!(message),
            child: Stack(
              children: [
                Align(
                  alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          offset: const Offset(0, 0),
                          blurRadius: 5,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isUser ? 20 : 0),
                        topRight: Radius.circular(isUser ? 0 : 20),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ),
                ),
                selectMode
                    ? Opacity(
                        opacity:
                            selectedMessages.contains(message) ? 0.25 : 0.0,
                        child: Container(
                          width: context.width,
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            message.content,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .copyWith(color: Colors.transparent),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
