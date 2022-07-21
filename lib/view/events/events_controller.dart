import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/user.dart';

class EventsController extends GetxController with StateMixin {
  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    change(null, status: RxStatus.loading());
    try {
      User user = GlobalController.instance.user!;
      List<Event> result = await APIService.instance.fetchEvents(200);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(user.regionCode)
          .doc(user.schoolCode)
          .collection("events")
          .get();
      snapshot.docs.forEach((element) {
        result.add(Event.fromFirebaseMap(element.data() as Map));
      });
      result.sort(((a, b) => a.date.compareTo(b.date)));
      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void deleteEvent(Event event) async {
    try {
      User user = GlobalController.instance.user!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(user.regionCode)
          .doc(user.schoolCode)
          .collection("events")
          .get();

      var target = snapshot.docs.where((element) {
        Map map = element.data() as Map;
        return map["title"] == event.title &&
            map["date"] == Timestamp.fromDate(event.date) &&
            map["endDate"] ==
                (event.endDate != null
                    ? Timestamp.fromDate(event.endDate!)
                    : null);
      });

      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(target.first.reference);
      });

      fetch();
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
