import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/timetable.dart';

class TimeTableController extends GetxController {
  RxList<TimeTable> timeTables = <TimeTable>[].obs;
  Rx<DateTime> date = DateTime.now().obs;
  Rx<CurrentState> _state = CurrentState().obs;

  get state => _state.value;

  @override
  void onInit() async {
    fetchTimeTables();
    super.onInit();
  }

  fetchTimeTables() async {
    _state.value = LoadingState();
    try {
      timeTables.addAll(await APIService.instance
          .fetchTimeTableByDuration(date.value));
      _state.value = DoneState();
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }
}
