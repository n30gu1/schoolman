import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schoolman/view/titleview.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? appBar;

  CustomScaffold({this.body, this.appBar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        if (defaultTargetPlatform == TargetPlatform.macOS) ...[
          TitleView(appWindow.titleBarHeight)
        ],
        if (appBar != null) ...[appBar!],
        if (body != null) ...[Expanded(child: body!)]
      ]),
    );
  }
}
