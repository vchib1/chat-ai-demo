import 'package:flutter/material.dart';

class Snackbar {
  const Snackbar(this.context, {this.duration = const Duration(seconds: 4)});

  final BuildContext context;
  final Duration duration;

  Future<void> show(String content) async {
    final snackBar = SnackBar(content: Text(content), duration: duration);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }
}
