import 'package:schoolman/date_converter.dart';

class Schedule {
  DateTime date;
  String title;

  Schedule(this.date, this.title);

  static fromMap(Map map) {
    DateTime date = map["AA_YMD"].toString().convertFromyyyyMMdd();
    return Schedule(date, map["EVENT_NM"]);
  }
}
