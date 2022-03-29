import 'package:flutter/material.dart';
import 'package:schoolman/controller/input_user_info.dart';
import 'package:get/get.dart';

class InputUserInfo extends StatelessWidget {
  const InputUserInfo(this.schoolCode, {Key? key}) : super(key: key);

  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    InputUserInfoController controller =
        Get.put(InputUserInfoController(schoolCode));
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
