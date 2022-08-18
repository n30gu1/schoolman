import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/studyplanner/studyplanner_controller.dart';

class StudyPlannerPage extends StatelessWidget {
  StudyPlannerPage({Key? key}) : super(key: key);

  final c = Get.put(StudyPlannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Planners"),),
      body: c.obx((state) => Container(), onError: (error) {
        if (error == "ERROR_NOT_MAIN_PROFILE") {
          return Text("Current profile isn't a main profile");
        } else {
          return Text("Unexpected Error: $error");
        }
      }, onEmpty: Center(child: Text("Empty!"),)),
    );
  }
}
