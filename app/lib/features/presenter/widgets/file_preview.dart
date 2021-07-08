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
    _loadFile(widget.path);
  }

  @override
  void didUpdateWidget(FilePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadFile(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: _fileExists
          ? _canRenderPreview()
              ? _preview()
              : _errorOnLoad()
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _preview() => LayoutBuilder(
        builder: (_, bounds) => PreviewMediaWidget(
          width: bounds.maxWidth,
          height: bounds.maxHeight,
          mediaProvider: MemoryMediaProvider(
            _file!.path,
            _fileMimeType!,
            _fileData!,
          ),
          fallbackBuilder: _fallbackPreviewBuilder,
        ),
      );

  Widget _fallbackPreviewBuilder(BuildContext context, MediaProvider provider) {
    IconData icon = Icons.error_outline;
    if (provider.isAudio) {
      icon = Icons.audiotrack_outlined;
    }
    if (provider.isVideo) {
      icon = Icons.videocam_outlined;
    }
    if (provider.isImage) {
      icon = Icons.image_outlined;
    }
    if (provider.isApplication) {
      icon = Icons.picture_as_pdf_outlined;
    }
    return Center(
      child: Tooltip(
        message: 'Não foi possível carregar a visualização do arquivo',
        child: Icon(icon, size: 64),
      ),
    );
  }

  Widget _errorOnLoad() => Center(
    child: Tooltip(
      message: 'Não foi possível carregar a visualização do '
          'arquivo',
      child: Icon(Icons.error_outline, size: 64),
    ),
  );

  Future<void> _loadFile(String filePath) async {
    _file = File(widget.path);
    _fileExists = await _file!.exists();
    if (_fileExists) {
      await _loadFileData(_file!);
    }
    setState(() {});
  }

  Future<void> _loadFileData(File file) async {
    _fileData = await file.readAsBytes();
    _fileMimeType = lookupMimeType(file.path);
  }

  bool _canRenderPreview() {
    return _fileExists &&
        _file != null &&
        _fileMimeType != null &&
        _fileData != null;
  }
}
