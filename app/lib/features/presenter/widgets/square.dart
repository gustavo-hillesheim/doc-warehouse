import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Widget child;

  Square({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bounds) {
      final smallerSize = bounds.maxWidth < bounds.maxHeight
          ? bounds.maxWidth
          : bounds.maxHeight;
      return SizedBox(
        width: smallerSize,
        height: smallerSize - 16,
        child: child,
      );
    });
  }
}