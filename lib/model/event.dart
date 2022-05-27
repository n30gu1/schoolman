import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolman/date_converter.dart';

class Event {
  DateTime date;
  DateTime? endDate;
  String title;
  String? location;
  String? comment;

  Event(this.date, this.title, {this.endDate, this.location, this.comment});

  static fromMap(Map map) {
    DateTime date = map["AA_YMD"].toString().convertFromyyyyMMdd();
    return Event(date, map["EVENT_NM"]);
  }

  static fromFirebaseMap(Map map) {
    DateTime date = (map["date"] as Timestamp).toDate();
    DateTime? endDate;
    String? location;
    String? comment;

    if (map["endDate"] != null) {
      endDate = (map["endDate"] as Timestamp).toDate();
    }
    if (map["location"] != null) {
      location = map["location"];
    }

    if (map["comment"] != null) {
      comment = map["comment"];
    }
    return Event(date, map["title"],
        location: location, comment: comment, endDate: endDate);
  }

  Map<String, dynamic> toMap() {
    Timestamp date = Timestamp.fromDate(this.date);
    Timestamp? endDate =
        this.endDate != null ? Timestamp.fromDate(this.endDate!) : null;

    return {
      "date": date,
      "endDate": endDate,
      "title": this.title,
      "location": this.location,
      "comment": this.comment
    };
  }
}
