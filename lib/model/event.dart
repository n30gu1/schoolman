import 'package:schoolman/date_converter.dart';

class Event {
  DateTime date;
  String title;
  String? location;
  String? comment;

  Event(this.date, this.title, {this.location, this.comment});

  static fromMap(Map map) {
    DateTime date = map["AA_YMD"].toString().convertFromyyyyMMdd();
    return Event(date, map["EVENT_NM"]);
  }

  static fromFirebaseMap(Map map) {
    String? location;
    String? comment;
    if (map["location"] != null) {
      location = map["location"];
    }

    if (map["comment"] != null) {
      comment = map["comment"];
    }
    return Event(map["date"], map["title"],
        location: location, comment: comment);
  }
}
