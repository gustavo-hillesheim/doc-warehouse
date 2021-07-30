import 'package:flutter/material.dart';

typedef SelectableGroupChildBuilder = Widget Function(BuildContext context, bool isSelectMode);

class SelectableGroup<T> extends StatefulWidget {
  final SelectableGroupChildBuilder builder;

  SelectableGroup({required this.builder});

  @override
  SelectableGroupState<T> createState() => SelectableGroupState<T>();

  static SelectableGroupState<S>? of<S>(BuildContext context) {
    return context.findAncestorStateOfType<SelectableGroupState<S>>();
  }
}

class SelectableGroupState<T> extends State<SelectableGroup<T>> {
  final Set<T> _selected = <T>{};
  final Set<T> _possibleValues = <T>{};
  bool _isSelectMode = false;

  select(T item) {
    final wasEmpty = _selected.isEmpty;
    setState(() {
      _selected.add(item);
    });
    if (wasEmpty) {
      setSelectMode(true);
    }
  }

  unselect(T item) {
    setState(() {
      _selected.remove(item);
    });
    if (_selected.isEmpty) {
      setSelectMode(false);
    }
  }

  List<T> getAllSelected() {
    return _selected.toList(growable: false);
  }

  void registerPossibleValue(T item) {
    _possibleValues.add(item);
  }

  void unregisterPossibleValue(T item) {
    _possibleValues.remove(item);
  }

  void selectAll() {
    setState(() {
      _selected.addAll(_possibleValues);
    });
  }

  void unselectAll() {
    setState(() {
      _selected.clear();
      setSelectMode(false);
    });
  }

  bool isAllSelected() {
    return _selected.containsAll(_possibleValues);
  }

  bool isSelected(T item) {
    return _selected.contains(item);
  }

  void setSelectMode(bool newValue) {
    setState(() {
      _isSelectMode = newValue;
    });
  }

  bool isSelectMode() {
    return _isSelectMode;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, isSelectMode());
  }
}
