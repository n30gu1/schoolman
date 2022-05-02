import 'package:flutter/material.dart';

class MainPageCard extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Widget child;

  const MainPageCard(
      {Key? key, this.onTap, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: child,
          ),
        )
      ],
    );
  }
}
