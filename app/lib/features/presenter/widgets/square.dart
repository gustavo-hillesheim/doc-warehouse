import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bounds) {
      final smallerSize = bounds.maxWidth < bounds.maxHeight
          ? bounds.maxWidth
          : bounds.maxHeight;
      return Container(
        width: smallerSize,
        height: smallerSize - 16,
        color: Colors.red,
      );
    });
  }
}