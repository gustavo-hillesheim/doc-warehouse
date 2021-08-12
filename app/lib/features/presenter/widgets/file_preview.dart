import 'dart:async';

import 'package:doc_warehouse/core/utils/file_data_loader.dart';
import 'package:enough_media/enough_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FilePreview extends StatefulWidget {
  final String path;
  final String? heroTag;

  FilePreview({required this.path, this.heroTag});

  @override
  _FilePreviewState createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  final _fileDataLoader = Modular.get<FileDataLoader>();
  FileData? _data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFile(widget.path);
  }

  @override
  void didUpdateWidget(covariant FilePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadFile(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = Container(
      color: Theme.of(context).primaryColorLight,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : (_data != null ? _preview(_data!) : _ErrorIndicator()),
    );
    return widget.heroTag != null ? Hero(
      tag: widget.heroTag!,
      child: result,
    ): result;
  }

  Widget _preview(FileData data) => PreviewMediaWidget(
        useHeroAnimation: true,
        mediaProvider: MemoryMediaProvider(
          data.file.path,
          data.mimeType,
          data.data,
        ),
        fallbackBuilder: (_, provider) =>
            _ErrorIndicator.fromMediaProvider(provider),
      );

  Future<void> _loadFile(String path) async {
    if (_fileDataLoader.hasCached(path)) {
      _data = _fileDataLoader.getFromCache(path);
    } else {
      setState(() {
        _isLoading = true;
      });
      final data = await _fileDataLoader.loadFromPath(path);
      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
      }
    }
  }
}

class _ErrorIndicator extends StatelessWidget {
  final IconData icon;

  _ErrorIndicator([this.icon = Icons.error_outline]);

  factory _ErrorIndicator.fromMediaProvider(MediaProvider provider) {
    IconData icon = Icons.help_outline_outlined;
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
    if (provider.isText) {
      icon = Icons.text_snippet_outlined;
    }
    return _ErrorIndicator(icon);
  }

  @override
  Widget build(BuildContext context) {

    return Tooltip(
      message: 'Não foi possível carregar a visualização do arquivo',
      child: Center(
        child: LayoutBuilder(builder: (_, bounds) {
          final maxSize = 64.0;
          final iconSize = bounds.maxWidth / 3 > maxSize ? maxSize : bounds.maxWidth / 3;
          return Icon(icon, size: iconSize);
        }),
      ),
    );
  }
}
