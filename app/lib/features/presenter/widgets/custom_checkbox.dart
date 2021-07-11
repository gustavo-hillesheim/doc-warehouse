import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?> onChange;
  final _backgroundColor = Colors.grey;

  CustomCheckbox({required this.value, required this.onChange});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgroundColor.withOpacity(.8),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChange,
        shape: CircleBorder(),
        side: BorderSide(color: _backgroundColor, width: 1),
        fillColor: MaterialStateProperty.all(Colors.blue),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}