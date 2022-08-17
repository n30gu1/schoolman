import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final double height;
  TitleView(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height,
      child: Row(children: [
        SizedBox(
          width: 80,
        ),
        Text(
          "SchoolMan ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("- Custom TitleBar Prototype"),
      ]),
    );
  }
}
