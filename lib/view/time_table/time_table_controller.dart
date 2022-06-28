import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';

class TimeTableController extends GetxController with StateMixin {
  Rx<DateTime> _date = DateTime.now().obs;

  DateTime get date => _date.value;

  Timer? _timer;

  @override
  void onInit() async {
    fetchTimeTables();
    super.onInit();
  }

  void fetchTimeTables() async {
    _timer?.cancel();
    change(null, status: RxStatus.loading());
    _timer = Timer(Duration(milliseconds: 500), () {
      try {
        APIService.instance.fetchTimeTableByDuration(date).then((value) {
          change(value, status: RxStatus.success());
        });
      } catch (e) {
        change(null, status: RxStatus.error(e.toString()));
      }
    });
  }

  setDate(DateTime date) async {
    _date.value = date;
    fetchTimeTables();
  }
}
