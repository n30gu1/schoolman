import 'package:flutter/material.dart';
import 'package:schoolman/model/notice.dart';

class NoticeDetailPage extends StatelessWidget {
  NoticeDetailPage(this.notice, {Key? key}) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("Detail")],
      ),
    );
  }
}
