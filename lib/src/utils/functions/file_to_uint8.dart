import 'dart:io';
import 'package:flutter/services.dart';

Future<Uint8List> fileToUInt8List(String path) async {
  final fileData = File(path);
  final randomAccessFile = await fileData.open();

  int length = await fileData.length();

  Uint8List res = await randomAccessFile.read(length);

  await randomAccessFile.close();

  return res;
}
