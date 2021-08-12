import 'dart:io';

import 'package:flutter/foundation.dart';

class FileDeleter {

  Future<void> delete(String filePath) async {
    await File(filePath).delete().catchError((error) {
      debugPrint("Could not delete file $filePath: $error");
    });
  }

  Future<void> deleteAll(List<String> filePaths) async {
    for (final filePath in filePaths) {
      await delete(filePath);
    }
  }
}