import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/view/events_page/events_controller.dart';

class AddEventController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  Rx<DateTimeRange?> _range = Rx(null);
  RxList _attachments = [].obs;

  CurrentState get state => _state.value;
  List get attachments => _attachments;
  DateTimeRange? get range => _range.value;

  @override
  void onClose() {
    titleController.dispose();
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
          .add(Event(range!.start, titleController.text,
                  endDate: range!.end,
                  location: locationController.text,
                  comment: commentController.text)
              .toMap())
          .then((_) {
        _state.value = DoneState();
        Get.back();

        EventsController eventsController = Get.find();
        eventsController.fetch();
      });
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  void setRange(DateTimeRange range) {
    _range.value = range;
  }
}
