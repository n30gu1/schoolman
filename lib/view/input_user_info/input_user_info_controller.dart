import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'dart:developer';

class InputUserInfoController extends GetxController with StateMixin {
  late String schoolCode;
  late String regionCode;
  late String schoolName;
  late Map gradeMap;

  RxString gradeSelected = "".obs;
  RxString classSelected = "".obs;

  final studentNumberInputController = TextEditingController();

  InputUserInfoController(this.regionCode, this.schoolCode, this.schoolName);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    change(null, status: RxStatus.loading());
    try {
      gradeMap = await createMap(
          await APIService.instance.fetchClassInfo(regionCode, schoolCode));
      change(null, status: RxStatus.success());
    } catch (e) {
      log(e.toString());
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<Map<String, dynamic>> createMap(List classInfo) async {
    Set grade = {};
    Map classMap = {};

    for (var element in classInfo) {
      grade.add(element["GRADE"]);
    }

    for (var gradeElement in grade) {
      classMap.addAll({gradeElement.toString(): []});
      classInfo.forEach((element) {
        if (element["GRADE"].toString().contains(gradeElement)) {
          classMap[gradeElement.toString()].add(element["CLASS_NM"]);
        }
      });
      classMap[gradeElement.toString()].sort((a, b) {
        var aInt = int.tryParse(a);
        var bInt = int.tryParse(b);

        if (aInt != null && bInt != null) {
          return aInt.compareTo(bInt);
        } else {
          return a.toString().compareTo(b.toString());
        }
      });
    }

    gradeSelected.value = grade.first.toString();
    classSelected.value = classMap[gradeSelected.value].first;
    return {"grades": grade, "classes": classMap};
  }

  void submitUserInfo() async {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      // Offline Mode (Anonymous)
      await Get.find<GlobalController>().submitNewUser(
          this.regionCode,
          this.schoolCode,
          this.schoolName,
          int.parse(gradeSelected.value),
          classSelected.value,
          int.parse(studentNumberInputController.text),
          "");
    } else {
      // Online Mode
      await Get.find<GlobalController>().submitNewUser(
          this.regionCode,
          this.schoolCode,
          this.schoolName,
          int.parse(gradeSelected.value),
          classSelected.value,
          int.parse(studentNumberInputController.text),
          FirebaseAuth.instance.currentUser!.displayName!,
      );
    }
  }
}
