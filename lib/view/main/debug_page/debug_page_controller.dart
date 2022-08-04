import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/model/user.dart';

class DebugPageController extends GetxController with StateMixin {
  CollectionReference<Map<String, dynamic>> db =
      FirebaseFirestore.instance.collection("users");
  TextEditingController gradeInputController = TextEditingController();
  TextEditingController classNumInputController = TextEditingController();

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void findUserByConditions() async {
    change(null, status: RxStatus.loading());
    String grade = gradeInputController.text;
    String classNum = classNumInputController.text;
    List<User> result = [];
    await db
        .where("grade", isEqualTo: grade)
        .where("classNum", isEqualTo: classNum)
        .get()
      ..docs.forEach((element) async {
        result.add(await User.parse(element.data()));
      });

    change(result, status: RxStatus.success());
  }
}
