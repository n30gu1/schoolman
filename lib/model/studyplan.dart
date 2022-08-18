import 'package:cloud_firestore/cloud_firestore.dart';

class StudyPlan {
  String title;
  String author;
  List<StudyPlanItem> items;

  StudyPlan({required this.title, required this.author, required this.items});

  static StudyPlan fromMap(Map map) {
    return StudyPlan(
        title: map["title"],
        author: map["author"],
        items: map["items"].map((e) => StudyPlanItem.fromMap(e)));
  }
}

class StudyPlanItem {
  String subject;
  Timestamp startDate;
  Timestamp endDate;

  StudyPlanItem(
      {required this.subject, required this.startDate, required this.endDate});

  static StudyPlanItem fromMap(Map map) {
    return StudyPlanItem(
        subject: map["subject"],
        startDate: map["startDate"],
        endDate: map["endDate"]);
  }

  Map toMap() {
    return {
      "subject": this.subject,
      "startDate": this.startDate,
      "endDate": this.endDate
    };
  }
}
