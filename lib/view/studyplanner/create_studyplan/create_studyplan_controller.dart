import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/studyplan.dart';

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

  void upload() {
    School school = Get.find<GlobalController>().school!;

    StudyPlan studyPlan = StudyPlan(
      title: title.text,
      author: FirebaseAuth.instance.currentUser!.uid,
      items: items,
    );

    FirebaseFirestore.instance
        .collection(school.regionCode)
        .doc(school.schoolCode)
        .collection("planners")
        .add(studyPlan.toMap());
  }
}
