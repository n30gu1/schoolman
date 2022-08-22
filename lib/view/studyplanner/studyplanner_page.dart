import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/studyplanner/create_studyplan/create_studyplan_controller.dart';
import 'package:schoolman/view/studyplanner/create_studyplan/create_studyplan_page.dart';
import 'package:schoolman/view/studyplanner/studyplanner_controller.dart';

class StudyPlannerPage extends StatelessWidget {
  StudyPlannerPage({Key? key}) : super(key: key);

  final c = Get.put(StudyPlannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planners"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => CreateStudyPlanPage());
            },
          ),
        ],
      ),
      body: c.obx((state) => Container(), onError: (error) {
        if (error == "ERROR_NOT_MAIN_PROFILE") {
          return Text("Current profile isn't a main profile");
        } else {
          return Text("Unexpected Error: $error");
        }
      },
          onEmpty: Center(
            child: Text("Empty!"),
          )),
    );
  }
}
