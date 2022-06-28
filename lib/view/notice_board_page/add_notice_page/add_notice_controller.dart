import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/view/notice_board_page/notice_board_controller.dart';

class AddNoticeController extends GetxController with StateMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  RxList _attachments = [].obs;

  List get attachments => _attachments;

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void upload() {
    School school = GlobalController.instance.school!;
    change(null, status: RxStatus.loading());
    try {
      FirebaseFirestore.instance
          .collection(school.regionCode)
          .doc(school.schoolCode)
          .collection("notices")
          .add(Notice(
                  title: titleController.text,
                  content: contentController.text,
                  timeCreated: Timestamp.now(),
                  attachments: attachments)
              .toMap())
          .then((_) {
        change(null, status: RxStatus.success());
        Get.back();

        NoticeBoardController noticeBoardController = Get.find();
        noticeBoardController.fetch();
      });
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
