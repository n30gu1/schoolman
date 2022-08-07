import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/model/user.dart';
import 'package:schoolman/view/main/debug_page/debug_page_controller.dart';

class DebugPage extends StatelessWidget {
  final c = Get.put(DebugPageController());

  DebugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Debug Page")),
        body: Column(
          children: [
            TextField(
              controller: c.gradeInputController,
              decoration: InputDecoration(hintText: "Grade"),
            ),
            TextField(
              controller: c.classNumInputController,
              decoration: InputDecoration(hintText: "Class"),
            ),
            TextButton(
                onPressed: () => c.findUserByConditions(),
                child: Text("Search!")),
            c.obx((state) => Expanded(
                    child: ListView(
                  children: [
                    for (User item in state) ...[
                      Text(item.studentNumber ?? "0")
                    ]
                  ],
                )))
          ],
        ));
  }
}
