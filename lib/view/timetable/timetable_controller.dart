import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';

class TimeTableController extends GetxController {
  Rx<DateTime> _date = DateTime.now().obs;
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
    _state.value = LoadingState();
    _timer = Timer(Duration(milliseconds: 500), () {
      try {
        APIService.instance.fetchTimeTableByDuration(date).then((value) {
          _state.value = DoneState(result: value);
        });
      } catch (e) {
        _state.value = ErrorState(e.toString());
      }
    });
  }

  setDate(DateTime date) async {
    _date.value = date;
    fetchTimeTables();
  }
}
