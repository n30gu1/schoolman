import 'package:flutter/material.dart';

// TODO: Add Button Clicking Animation
class LoginButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final TextStyle? textStyle;
  final Color? color;
  const LoginButton(
      {required this.onTap,
      required this.label,
      this.textStyle,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
          color: color != null ? color : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
            child: Text(
          label,
          style: textStyle,
        )),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Function() onTap;
  final BorderRadius? borderRadius;
  final Widget child;

  CustomButton(
      {Key? key,
      this.width,
      this.height,
      required this.onTap,
      this.borderRadius,
      required this.child})
      : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        decoration:
            BoxDecoration(color: Colors.black12, borderRadius: borderRadius),
        child: this.child,
      ),
    );
  }
}
