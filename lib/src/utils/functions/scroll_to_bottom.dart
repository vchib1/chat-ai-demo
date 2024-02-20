import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

Future<void> scrollToBottom(ScrollController controller) async {
  if (controller.hasClients) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.linear,
      );
    });
  }
}
