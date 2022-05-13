import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/timetable.dart';

class TimeTableController extends GetxController {
  RxList<TimeTable> timeTables = <TimeTable>[].obs;
  Rx<DateTime> _date = DateTime
      .now()
      .obs;
  Rx<CurrentState> _state = CurrentState().obs;

  get state => _state.value;

  DateTime get date => _date.value;

  Timer? _timer;

  @override
  void onInit() async {
    fetchTimeTables();
    super.onInit();
  }

  void fetchTimeTables() async {
    _timer?.cancel();
    timeTables.clear();
    _state.value = LoadingState();
    try {
      _timer = Timer(Duration(milliseconds: 500), () {
        APIService.instance
            .fetchTimeTableByDuration(date)
            .then((value) {
          timeTables.addAll(value);
          _state.value = DoneState();
        });
      });
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  setDate(DateTime date) async {
    _date.value = date;
    fetchTimeTables();
  }
}
