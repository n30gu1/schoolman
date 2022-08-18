import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/todoitem.dart';
import 'package:schoolman/view/notice_board/notice_board_controller.dart';
import 'package:uuid/uuid.dart';

class AddNoticeController extends GetxController with StateMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  RxList _attachments = [].obs;

  RxBool expandTodoTab = false.obs;
  TextEditingController todoTitleController = TextEditingController();
  TextEditingController todoCommentController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  RxBool isAssignedToAllClasses = false.obs;
  RxMap<String, dynamic> classSelected = Map<String, dynamic>().obs;

  late Map gradeMap;

  List get attachments => _attachments;

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void fetchClassInfo() async {
    change(null, status: RxStatus.loading());
    School school = GlobalController.instance.school!;
    try {
      gradeMap = await createMap(await APIService.instance
          .fetchClassInfo(school.regionCode, school.schoolCode));
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
    return {"grades": grade, "classes": classMap};
  }

  void upload() {
    School school = GlobalController.instance.school!;
    String? uuid;

    change(null, status: RxStatus.loading());
    if (expandTodoTab.isTrue &&
        !todoTitleController.isBlank! &&
        !todoCommentController.isBlank!) {
      uuid = Uuid().v4();
      FirebaseFirestore.instance
          .collection(school.regionCode)
          .doc(school.schoolCode)
          .collection("todos")
          .doc(uuid)
          .set(TodoItem(
                  id: uuid,
                  dueDate: Timestamp.fromDate(_dueDate),
                  title: todoTitleController.isBlank!
                      ? "No title"
                      : todoTitleController.text,
                  comment: todoCommentController.isBlank!
                      ? "No comment"
                      : todoCommentController.text,
                  classAssigned: classSelected)
              .toMap());
    }

    FirebaseFirestore.instance
        .collection(school.regionCode)
        .doc(school.schoolCode)
        .collection("notices")
        .add(Notice(
                title: titleController.text,
                content: contentController.text,
                timeCreated: Timestamp.now(),
                attachments: attachments,
                todoItemId: uuid)
            .toMap())
        .then((_) {
      change(null, status: RxStatus.success());
      Get.back();

      Get.delete<NoticeBoardController>();
    }).onError((e, stackTrace) {
      change(null, status: RxStatus.error(e.toString()));
    });
  }

  void setDueDate(DateTime date) {
    _dueDate = date;
  }
}
