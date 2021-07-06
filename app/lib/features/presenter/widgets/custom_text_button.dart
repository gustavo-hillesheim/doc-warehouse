import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum IconPlacement { left, right }

class CustomTextButton extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback? onPressed;
  final IconPlacement iconPlacement;

  CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.iconPlacement = IconPlacement.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((state) =>
            state.contains(MaterialState.disabled) ? null : Theme.of(context).primaryColor),
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _getButtonContent(context),
      ),
    );
  }

  List<Widget> _getButtonContent(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, min(scale - 1, 1))!;
    var buttonContent = [
      icon,
      SizedBox(width: gap),
      label,
    ];
    if (iconPlacement == IconPlacement.right) {
      buttonContent = buttonContent.reversed.toList();
    }
    return buttonContent;
  }
}
