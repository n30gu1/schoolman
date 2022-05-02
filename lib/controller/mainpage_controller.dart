import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/timetable.dart';

class MainPageController extends GetxController {
  Rx<TimeTable?> timeTable = Rx(null);
  Rx<CurrentState> _state = CurrentState().obs;
  get state => _state.value;

  @override
  void onInit() {
    fetchTimeTable();
    super.onInit();
  }

  void fetchTimeTable() async {
    _state.value = LoadingState();
    try {
      timeTable.value = await APIService.instance.fetchTimeTable(
          GlobalController.instance.school!);
      _state.value = DoneState();
    } catch (error) {
      _state.value = ErrorState(error.toString());
    }
  }
}