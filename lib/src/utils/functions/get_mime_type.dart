import 'dart:io';
import 'package:mime/mime.dart' as mime;

String? getMimeType(File file) => mime.lookupMimeType(file.path);
