import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Map toMap() {
    return {
      "title": title,
      "author": author,
      "items": items.map((e) => e.toMap()).toList()
    };
  }
}

class StudyPlanItem {
  RxString subject;
  Rx<TimeOfDay> startTime;
  Rx<TimeOfDay> endTime;
  RxString description;

  StudyPlanItem({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  static StudyPlanItem fromMap(Map map) {
    Timestamp startDate = map["startTime"];
    Timestamp endDate = map["endTime"];
    return StudyPlanItem(
        subject: map["subject"],
        startTime: TimeOfDay(
          hour: startDate.toDate().hour,
          minute: startDate.toDate().minute,
        ).obs,
        endTime: TimeOfDay(
          hour: endDate.toDate().hour,
          minute: endDate.toDate().minute,
        ).obs,
        description: map["description"]);
  }

  Map toMap() {
    DateTime today = DateTime.now();
    return {
      "subject": subject.value,
      "startTime": Timestamp.fromDate(DateTime(today.year, today.month,
          today.day, startTime.value.hour, startTime.value.minute)),
      "endTime": Timestamp.fromDate(DateTime(today.year, today.month, today.day,
          endTime.value.hour, endTime.value.minute)),
      "description": description.value,
    };
  }
}
