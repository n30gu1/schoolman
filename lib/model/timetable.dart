import 'dart:convert';

import 'package:intl/intl.dart';

class TimeTable {
  DateTime date;
  List<TimeTableItem> items;

  TimeTable(this.date, this.items);

  static TimeTable fromList(List<dynamic> list) {
    List<TimeTableItem> items = [];
    for (var item in list) {
      items.add(TimeTableItem(
          int.parse(item["PERIO"].toString()), item["ITRT_CNTNT"]));
    }

    return TimeTable(DateTime.now(), items);
  }

  String toJson() {
    List<Map<String, Object>> items = this
        .items
        .map((e) => {"period": e.period, "subject": e.subject})
        .toList();
    Map map = {
      "date": DateFormat("yyyy/MM/dd").format(this.date),
      "items": items
    };

    return jsonEncode(map);
  }
}

class TimeTableItem {
  int period;
  String subject;

  TimeTableItem(this.period, this.subject);
}
