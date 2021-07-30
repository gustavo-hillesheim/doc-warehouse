import 'package:doc_warehouse/features/presenter/widgets/custom_checkbox.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableItem<T> extends StatefulWidget {
  final T value;
  final Widget child;

  SelectableItem({required this.child, required this.value});

  @override
  _SelectableItemState<T> createState() => _SelectableItemState<T>();
}

class _SelectableItemState<T> extends State<SelectableItem<T>> {
  SelectableGroupState<T>? _parent;

  void initState() {
    super.initState();
    _parent = SelectableGroup.of<T>(context);
    _parent?.registerPossibleValue(widget.value);
  }

  @override
  void didUpdateWidget(covariant SelectableItem<T> oldWidget) {
    if (oldWidget.value != widget.value) {
      _parent?.unregisterPossibleValue(oldWidget.value);
      _parent?.registerPossibleValue(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  void dispose() {
    _parent?.unregisterPossibleValue(widget.value);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_parent == null) {
      return widget.child;
    }
    return Stack(
      children: [
        widget.child,
        _parent!.isSelectMode() ? _checkbox() : Container(),
        _tapDetector(),
      ],
    );
  }

  Widget _checkbox() => Container(
        margin: const EdgeInsets.all(8),
        child: CustomCheckbox(
          value: _isSelected(),
          onChange: (_) {},
        ),
      );

  Widget _tapDetector() {
    if (_parent!.isSelectMode()) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _changeSelected,
          onLongPress: _changeSelected,
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: _changeSelected,
      );
    }
  }

  bool _isSelected() {
    return _parent?.isSelected(widget.value) == true;
  }

  void _changeSelected() {
    if (_parent == null) return;
    setState(() {
      if (_isSelected()) {
        _parent!.unselect(widget.value);
      } else {
        _parent!.select(widget.value);
      }
    });
  }
}
