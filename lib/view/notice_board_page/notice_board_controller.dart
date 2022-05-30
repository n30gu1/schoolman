import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/user.dart';

class NoticeBoardController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;
  DateFormat format = DateFormat("yyyy/M/d HH:mm:ss");

  CurrentState get state => _state.value;

  @override
  void onInit() {
    fetch();
    super.onInit();
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

      notices.sort(
        (a, b) => b.timeCreated.compareTo(a.timeCreated),
      );
      _state.value = DoneState(result: notices);
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  void deleteNotice(Notice notice) async {
    try {
      User user = GlobalController.instance.user!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(user.regionCode)
          .doc(user.schoolCode)
          .collection("notices")
          .get();

      var target = snapshot.docs.where((element) {
        Map map = element.data() as Map;
        return map["title"] == notice.title && map["content"] == notice.content;
      });

      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(target.first.reference);
      });

      fetch();
    } catch (e) {
      print(e);
      _state.value = ErrorState(e.toString());
    }
  }
}
