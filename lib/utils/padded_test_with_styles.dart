import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  TextStyle styles;
  final String text;
  final EdgeInsets padding;

  CustomTextStyle(
      {Key? key,
      required this.text,
      required this.padding,
      this.styles = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text, style: styles),
    );
  }
}
