import 'dart:typed_data';
import 'package:chatgpt_api_demo/src/utils/functions/file_to_uint8.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView(this._media, {super.key});

  final ChatMedia _media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Uint8List>(
        future: fileToUInt8List(_media.url),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Center(child: Image.memory(snapshot.data!));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
