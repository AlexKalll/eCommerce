import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;

  const Button(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}