import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainAppBar extends AppBar {
  MainAppBar({Key? key, this.label = ''})
      : super(
            title: Text(label!),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black);
  String? label;
}
