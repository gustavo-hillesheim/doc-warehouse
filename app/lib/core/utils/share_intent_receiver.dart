import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class ShareIntentReceiver {

  final _methodChannel = MethodChannel('gustavohill.shareIntentReceiver/method_channel');
  final _eventChannel = EventChannel('gustavohill.shareIntentReceiver/event_channel');
  final _fileStreamController = StreamController<SharedFile>();

  Stream<SharedFile> get fileStream => _fileStreamController.stream;

  ShareIntentReceiver() {
    listenToShareIntent();
  }

  void listenToShareIntent() async {
    final initialSharedData = await _methodChannel.invokeMapMethod("getSharedData");
    if (initialSharedData != null) {
      _fileStreamController.sink.add(SharedFile(path: initialSharedData['path']));
    }
    _eventChannel.receiveBroadcastStream("sharedData").listen((event) {
      if (event is Map<String, String> && event.containsKey('path')) {
        _fileStreamController.sink.add(SharedFile(path: event['path']!));
      }
    });
  }

  Future<void> close() async {
    await _fileStreamController.close();
  }
}

class SharedFile extends Equatable {

  final String path;
  final String name;

  SharedFile({required this.path}) : name = basename(path);

  @override
  List<Object?> get props => [path, name];
}