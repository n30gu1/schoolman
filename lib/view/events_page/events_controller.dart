import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/user.dart';

class EventsController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;

  CurrentState get state => _state.value;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    _state.value = LoadingState();
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
      _state.value = DoneState(result: result);
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  void removeEvent(Event event) async {
    try {
      User user = GlobalController.instance.user!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(user.regionCode)
          .doc(user.schoolCode)
          .collection("events")
          .get();

      print(snapshot.docs.where((element) {
        Map map = element.data() as Map;
        return map["title"] == event.title &&
            map["startDate"] == event.date &&
            map["endDate"] == event.endDate;
      }));

      fetch();
    } catch (e) {
      print(e);
      _state.value = ErrorState(e.toString());
    }
  }
}
