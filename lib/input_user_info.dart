import 'package:flutter/material.dart';

class InputUserInfo extends StatelessWidget {
  const InputUserInfo(this.schoolCode, {Key? key}) : super(key: key);

  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          "User Info",
        ),
        foregroundColor: Colors.black,
      ),
    );
  }
}
