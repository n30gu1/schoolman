import 'package:flutter/material.dart';
import "package:get/get.dart";

class CreateStudyPlanController extends GetxController with StateMixin {
  final title = TextEditingController();
  final description = TextEditingController();
  RxList<StudyPlanItem> items = <StudyPlanItem>[].obs;

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void createItem() {
    items.add(StudyPlanItem(
        subject: "".obs,
        description: "".obs,
        startTime: TimeOfDay.now().obs,
        endTime: TimeOfDay.now().obs));
  }
}

class StudyPlanItem {
  RxString subject;
  Rx<TimeOfDay> startTime;
  Rx<TimeOfDay> endTime;
  RxString description;

  StudyPlanItem({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.description,
  });
}
