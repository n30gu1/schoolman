import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'dart:developer';

import 'package:schoolman/current_state.dart';
import 'package:schoolman/view/tabview.dart';
import 'package:schoolman/view/tabview_controller.dart';

class InputUserInfoController extends GetxController {
  late String schoolCode;
  late String regionCode;
  late Map gradeMap;

  Rx<CurrentState> _state = CurrentState().obs;
  get state => _state.value;

  RxString gradeSelected = "".obs;
  RxString classSelected = "".obs;

  final studentNumberInputController = TextEditingController();

  InputUserInfoController(this.regionCode, this.schoolCode);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    _state.value = LoadingState();
    try {
      gradeMap = await createMap(
          await APIService.instance.fetchClassInfo(regionCode, schoolCode));
      _state.value = DoneState();
    } catch (e) {
      log(e.toString());
      _state.value = ErrorState(e.toString());
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
    print(FirebaseAuth.instance.currentUser!.displayName);
    await GlobalController.instance.submitNewUser(
        this.regionCode,
        this.schoolCode,
        gradeSelected.value,
        classSelected.value,
        studentNumberInputController.text,
        FirebaseAuth.instance.currentUser!.displayName!);
    Get.offAll(() => TabView());
  }
}
