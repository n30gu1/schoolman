import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/todoitem.dart';

class TodoListController extends GetxController with StateMixin {
  RxList todoDone = (GlobalController.instance.user!.todoDone).obs;
  Timer? _timer;

  @override
  void onInit() {
    fetchTodo();
    super.onInit();
  }

  Future<void> fetchTodo() async {
    change(null, status: RxStatus.loading());
    try {
      String regionCode = GlobalController.instance.school!.regionCode;
      String schoolCode = GlobalController.instance.school!.schoolCode;
      String grade = GlobalController.instance.user!.grade;
      String className = GlobalController.instance.user!.className;
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

  Future<void> markReminderAsDone(TodoItem item) async {
    final user = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    try {
      if (!todoDone.contains(item.id)) {
        todoDone.add(item.id);
      } else {
        todoDone.remove(item.id);
      }

      _timer = Timer(const Duration(seconds: 1), () {
        user.update({"todoDone": todoDone});
      });
    } catch (e) {
      Get.snackbar("An Error Occurred", e.toString());
    }
  }
}
