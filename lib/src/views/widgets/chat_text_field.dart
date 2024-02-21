import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final String hintText;
  final void Function(String)? onSubmitted;
  final void Function()? onPressed;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.isLoading,
    this.hintText = "Message",
    this.onSubmitted,
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
          isLoading
              ? const CircularProgressIndicator()
              : IconButton(onPressed: onPressed, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
