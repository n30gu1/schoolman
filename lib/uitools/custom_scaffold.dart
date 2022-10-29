import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? appBar;

  CustomScaffold({this.body, this.appBar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        if (appBar != null) ...[appBar!],
        if (body != null) ...[Expanded(child: body!)]
      ]),
    );
  }
}
