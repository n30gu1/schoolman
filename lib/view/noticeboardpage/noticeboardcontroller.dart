import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/school.dart';

class NoticeBoardController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;

  CurrentState get state => _state.value;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  @override
  void onReady() {
    fetch();
    super.onReady();
  }

  void fetch() async {
    _state.value = LoadingState();
    try {
      School school = GlobalController.instance.school!;
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(school.regionCode)
          .doc(school.schoolCode)
          .collection("notices")
          .get();

      List<Notice> notices = <Notice>[];
      snapshot.docs.forEach((element) {
        notices.add(Notice.fromMap(element.data()));
      });

      _state.value = DoneState(result: notices);
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }
}
