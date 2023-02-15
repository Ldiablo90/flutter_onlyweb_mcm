import 'package:flutter/material.dart';

class MainElevatedButton extends ElevatedButton {
  MainElevatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.color,
  }) : super(
            onPressed: onPressed,
            child: child,
            style: ElevatedButton.styleFrom(backgroundColor: color));
  Widget child;
  Function()? onPressed;
  Color? color;
}
