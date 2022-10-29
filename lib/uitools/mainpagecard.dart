import 'package:flutter/material.dart';

class MainPageCard extends StatelessWidget {
  final double? height;
  final String title;
  final Widget child;

  MainPageCard({Key? key, this.height, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Text("$title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Theme.of(context).dialogBackgroundColor),
          child: child,
        )
      ],
    );
  }
}
