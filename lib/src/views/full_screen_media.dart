import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:chatgpt_api_demo/module/src/model/media_model.dart';
import 'package:chatgpt_api_demo/src/utils/functions/file_to_uint8.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView(this._media, {super.key});

  final ChatMedia _media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Uint8List>(
        future: fileToUInt8List(_media.path),
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
