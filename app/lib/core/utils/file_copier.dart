import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileCopier {
  Future<File> createInternalFile({
    required String sourcePath,
    required String name,
    required bool deleteSource,
  }) async {
    final internalFilePath = await _getInternalFileName(sourcePath, name);
    final sourceFile = File(sourcePath);
    final internalFile = File(internalFilePath);
    internalFile.createSync(recursive: true);
    internalFile.writeAsBytesSync(sourceFile.readAsBytesSync());
    if (deleteSource) {
      sourceFile.delete().catchError((error) {
        print("Could not delete file ${sourceFile.path}: $error");
      });
    }
    return internalFile;
  }

  Future<String> _getInternalFileName(String sourceFilePath, String fileName) async {
    final separator = Platform.pathSeparator;
    final appFolder = await getApplicationDocumentsDirectory();
    final documentsFolder = '${appFolder.path}${separator}documents';
    final fileExtension = sourceFilePath.split('.').last;
    return '$documentsFolder$separator$fileName.$fileExtension';
  }
}
