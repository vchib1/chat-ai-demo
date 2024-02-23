import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> xFileToUInt8List(XFile file) async {
  File fileData = File(file.path);
  RandomAccessFile randomAccessFile = await fileData.open();

  int length = await fileData.length();

  Uint8List res = await randomAccessFile.read(length);

  await randomAccessFile.close();

  return res;
}
