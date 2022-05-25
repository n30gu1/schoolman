import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/view/noticeboardpage/noticeboardcontroller.dart';

class AddNoticeController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  RxList _attachments = [].obs;

  CurrentState get state => _state.value;
  List get attachments => _attachments;

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void upload() {
    School school = GlobalController.instance.school!;
    _state.value = LoadingState();
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
        _state.value = DoneState();
        Get.back();

        NoticeBoardController noticeBoardController = Get.find();
        noticeBoardController.fetch();
      });
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }
}
