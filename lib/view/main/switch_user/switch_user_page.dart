import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:schoolman/view/main/switch_user/switch_user_controller.dart';

class SwitchUserPage extends StatelessWidget {
  SwitchUserPage({Key? key}) : super(key: key);

  final c = Get.put(SwitchUserController());

  Widget cell(Map item) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: Offset(0, 0.75),
                blurRadius: 1,
                spreadRadius: 1,
                color: Colors.black38,
                blurStyle: BlurStyle.normal),
          ], color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(item["schoolName"]),
                Spacer(),
                Text("${item["grade"]}-${item["className"]}")
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      child: Scaffold(
        body: Column(children: [
          Text("Switch User"),
          SizedBox(
            height: 10,
          ),
          c.obx(
            (state) => Column(
              children: [
                for (var item in state) ...[
                  GestureDetector(
                    child: cell(item),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                Get.to(() => InputSchoolInfo());
              },
              child: Text("Add User"))
        ]),
      ),
    );
  }
}
