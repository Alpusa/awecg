import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuButton extends StatefulWidget {
  Widget child;
  MenuButton({Key? key, required this.child}) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  Color backgroundColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      // set inifinite width
      width: double.infinity,
      child: TextButton(
        child: widget.child,
        onPressed: () {
          setState(() {
            backgroundColor = Colors.white;
          });
        },
      ),
    );
  }
}
