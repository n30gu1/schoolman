import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/todoitem.dart';

class TodoListController extends GetxController with StateMixin {
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
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(regionCode)
          .doc(schoolCode)
          .collection("todos")
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
      List<String> todoDone = GlobalController.instance.user!.todoDone;

      if (!todoDone.contains(item.id)) {
        todoDone.add(item.id);
      }

      user.update({"todoDone": todoDone});
    } catch (e) {
      Get.snackbar("An Error Occurred", e.toString());
    }
  }
}
