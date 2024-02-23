import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final String hintText;
  final void Function(String)? onSubmitted;
  final void Function()? onPressed;
  final bool allowImagePick;
  final void Function()? onImagePressed;
  final int selectedImageCount;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.isLoading,
    this.hintText = "Message",
    this.allowImagePick = false,
    this.selectedImageCount = 0,
    this.onSubmitted,
    this.onImagePressed,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: [
          /// TextField
          Expanded(
            child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyMedium,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),

          /// Image Icon Button
          if (allowImagePick)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: onImagePressed,
                child: badge.Badge(
                  showBadge: selectedImageCount > 0,
                  badgeContent: Text("$selectedImageCount"),
                  child: const Icon(Icons.image),
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          /// Send Button
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(onPressed: onPressed, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
