import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  late double height;
  late double width;
  CustomSpacer({Key? key, this.height = 0, this.width = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
