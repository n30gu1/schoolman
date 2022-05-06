import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/date_converter.dart';

class TimeTableController extends GetxController {
  @override
  void onInit() {
    List duration = DateTime.now().listByWeekday();
    APIService.instance.fetchTimeTableByDuration(duration.first, duration.last);
    super.onInit();
  }


}