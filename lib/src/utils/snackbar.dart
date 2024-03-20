import 'package:flutter/material.dart';

Future<void> showSnackbar(BuildContext context, String message) async {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
}
