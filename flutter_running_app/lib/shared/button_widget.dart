import 'package:flutter/material.dart';
import 'package:flutter_running_app/shared/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    this.color = light,
    this.backgroundColor = secondary,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32)),
      onPressed: onClicked,
      child: Text(text, style: TextStyle(fontSize: 20, color: color)));
}
