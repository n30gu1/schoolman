import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/todoitem.dart';

class NoticeDetailController extends GetxController with StateMixin {
  Notice notice;

  @override
  void onInit() {
    super.onInit();
    getTodoInfo();
  }

  NoticeDetailController(this.notice);

  Future<void> getTodoInfo() async {
    try {
      if (notice.todoItemId == null) {
        throw "There is no todo item assigned to notice";
      }
      final globalC = Get.find<GlobalController>();
      String regionCode = globalC.school!.regionCode;
      String schoolCode = globalC.school!.schoolCode;

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(regionCode)
          .doc(schoolCode)
          .collection("todos")
          .doc(notice.todoItemId!)
          .get();

      if (snapshot.data() != null) {
        TodoItem item = TodoItem.fromMap(snapshot.data()!);
        change(item, status: RxStatus.success());
        QuerySnapshot<Map<String, dynamic>> usersDoneTodo =
            await FirebaseFirestore.instance
                .collection("users")
                .where("todoDone", arrayContains: item.id)
                .get();

        print(usersDoneTodo.docs.length);

        QuerySnapshot<Map<String, dynamic>> usersAssignedTodo =
            await FirebaseFirestore.instance
                .collection("users")
                .where("regionCode", isEqualTo: regionCode)
                .where("schoolCode", isEqualTo: schoolCode)
                .where("grade", whereIn: item.classAssigned.keys.toList())
                .get();

        print(usersAssignedTodo.docs.length);
      } else {
        throw "Unexpectedly found null while unwrapping value";
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
