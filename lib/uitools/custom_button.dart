import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Function() onTap;
  final Widget child;

  CustomButton(
      {Key? key,
        required this.width,
        required this.height,
        required this.onTap,
        required this.child})
      : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        decoration:
        BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
        child: Center(child: this.child),
      ),
    );
  }
}
