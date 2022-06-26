import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/view/events_page/events_controller.dart';

class AddEventController extends GetxController with StateMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  Rx<DateTimeRange?> _range = Rx(null);
  RxList _attachments = [].obs;

  List get attachments => _attachments;
  DateTimeRange? get range => _range.value;

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void upload() {
    School school = GlobalController.instance.school!;
    change(null, status: RxStatus.loading());
    try {
      FirebaseFirestore.instance
          .collection(school.regionCode)
          .doc(school.schoolCode)
          .collection("events")
          .add(Event(range!.start, titleController.text,
                  endDate: range!.end,
                  location: locationController.text,
                  comment: commentController.text,
                  fromFirebase: true)
              .toMap())
          .then((_) {
        change(null, status: RxStatus.loading());
        Get.back();

        EventsController eventsController = Get.find();
        eventsController.fetch();
      });
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void setRange(DateTimeRange range) {
    _range.value = range;
  }
}
