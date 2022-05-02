class TimeTable {
  DateTime date;
  List<TimeTableItem> items;

  TimeTable(this.date, this.items);

  static TimeTable fromList(List<dynamic> list) {
    List<TimeTableItem> items = [];
    for (var item in list) {
      items.add(TimeTableItem(int.parse(item["PERIO"].toString()), item["ITRT_CNTNT"]));
    }

    return TimeTable(DateTime.now(), items);
  }
}

class TimeTableItem {
  int period;
  String subject;

  TimeTableItem(this.period, this.subject);
}