import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/model/todoitem.dart';

class TodoListController extends GetxController with StateMixin {
  RxList todoDone = (Get.find<GlobalController>().user!.todoDone).obs;

  @override
  void onInit() {
    fetchTodo();
    super.onInit();
  }

  Future<void> fetchTodo() async {
    change(null, status: RxStatus.loading());
    try {
      final globalController = Get.find<GlobalController>();
      String regionCode = globalController.school!.regionCode;
      String schoolCode = globalController.school!.schoolCode;
      int grade = globalController.userProfile!.grade;
      String className = globalController.userProfile!.className;
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(regionCode)
          .doc(schoolCode)
          .collection("todos")
          .where("classAssigned.$grade", arrayContains: className)
          .get();

      List<TodoItem> result = <TodoItem>[];
      snapshot.docs.forEach((e) => result.add(TodoItem.fromMap(e.data())));
      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> markReminderAsDone(TodoItem item, BuildContext context) async {
    final user = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    try {
      if (!todoDone.contains(item.id)) {
        todoDone.add(item.id);
      } else {
        todoDone.remove(item.id);
      }

      Timer(const Duration(seconds: 1), () {
        user.update({"todoDone": todoDone});
      });
    } catch (e) {
      Get.snackbar(S.of(context).somethingWentWrong, e.toString());
    }
  }
}
