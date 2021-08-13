import 'dart:async';

import 'package:doc_warehouse/core/utils/file_data_loader.dart';
import 'package:enough_media/enough_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FileDisplay extends StatefulWidget {
  final String path;
  final bool interactive;

  FileDisplay({required this.path, this.interactive = false});

  @override
  _FileDisplayState createState() => _FileDisplayState();
}

class _FileDisplayState extends State<FileDisplay> {
  final _fileDataLoader = Modular.get<FileDataLoader>();
  FileData? _data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFile(widget.path);
  }

  @override
  void didUpdateWidget(covariant FileDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadFile(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isLoading) {
      content = Center(child: CircularProgressIndicator());
    } else {
      if (_data != null) {
        final mediaProvider = MemoryMediaProvider(
          _data!.file.path,
          _data!.mimeType,
          _data!.data,
        );
        content = widget.interactive
            ? _interactive(mediaProvider)
            : _preview(mediaProvider);
      } else {
        content = _ErrorIndicator();
      }
    }
    return Hero(
      tag: widget.path,
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: content,
      ),
    );
  }

  Widget _interactive(MemoryMediaProvider mediaProvider) =>
      InteractiveMediaWidget(
        mediaProvider: mediaProvider,
        fallbackBuilder: (_, provider) =>
            _ErrorIndicator.fromMediaProvider(provider),
      );

  Widget _preview(MemoryMediaProvider mediaProvider) => PreviewMediaWidget(
        mediaProvider: mediaProvider,
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
          final iconSize =
              bounds.maxWidth / 3 > maxSize ? maxSize : bounds.maxWidth / 3;
          return Icon(icon, size: iconSize);
        }),
      ),
    );
  }
}
