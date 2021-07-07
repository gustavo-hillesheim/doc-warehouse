import 'dart:io';
import 'dart:typed_data';

import 'package:enough_media/enough_media.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FilePreview extends StatefulWidget {
  final String path;

  FilePreview(this.path);

  @override
  _FilePreviewState createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  File? _file;
  Uint8List? _fileData;
  String? _fileMimeType;
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    _file = File(widget.path);
    _file!.exists().then((exists) async {
      _fileExists = exists;
      if (exists) {
        await _loadFileData(_file!);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Center(
        child: _fileExists
            ? PreviewMediaWidget(mediaProvider: MemoryMediaProvider(_file!.path, _fileMimeType!, _fileData!))
            : CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _loadFileData(File file) async {
    _fileData = await file.readAsBytes();
    _fileMimeType = lookupMimeType(file.path);
  }
}
