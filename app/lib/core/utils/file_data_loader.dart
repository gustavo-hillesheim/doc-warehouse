import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class FileDataLoader {
  Map<String, FileData> _cache = Map<String, FileData>();

  Future<FileData?> loadFromPath(String path) async {
    if (!_cache.containsKey(path)) {
      File file = File(path);
      if (file.existsSync()) {
        final data = await compute(_loadFileData, file);
        final mimeType = lookupMimeType(file.path);
        final fileData = FileData(file, mimeType!, data);
        _cache[path] = fileData;
      }
    }
    return _cache[path];
  }

  static Future<Uint8List> _loadFileData(File file) {
    return file.readAsBytes();
  }
}

class FileData {
  final File file;
  final String mimeType;
  final Uint8List data;

  FileData(this.file, this.mimeType, this.data);
}