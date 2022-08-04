import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/main/switch_user/switch_user_controller.dart';

class SwitchUserPage extends StatelessWidget {
  SwitchUserPage({Key? key}) : super(key: key);

  final c = Get.lazyPut<SwitchUserController>(() => SwitchUserController());

  // Widget cell(String schoolName, String grade, String )

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
      child: Scaffold(
        body: Column(children: [
          // ListView.builder(itemBuilder: ((context, index) {
          //   return Card()
          // }))
        ]),
      ),
    );
  }
}
