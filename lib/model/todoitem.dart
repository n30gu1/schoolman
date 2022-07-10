import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String id;
  Timestamp dueDate;
  String title;
  String comment;
  List gradeAssigned;
  List classAssigned;

  TodoItem(
      {required this.id,
      required this.dueDate,
      required this.title,
      required this.comment,
      required this.gradeAssigned,
      required this.classAssigned});

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(
        id: map["id"],
        dueDate: map["dueDate"],
        title: map["title"],
        comment: map["comment"],
        gradeAssigned: map["gradeAssigned"],
        classAssigned: map["classAssigned"]);
  }
}
