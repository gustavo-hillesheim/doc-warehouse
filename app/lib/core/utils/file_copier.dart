import 'dart:io';

import 'package:doc_warehouse/core/utils/file_deleter.dart';
import 'package:path_provider/path_provider.dart';

class FileCopier {
  final FileDeleter fileDeleter;

  FileCopier(this.fileDeleter);

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
      await fileDeleter.delete(sourceFile.path);
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
