import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  Timestamp dueDate;
  String title;
  String comment;
  List gradeAssigned;
  List classAssigned;

  TodoItem(
      {required this.dueDate,
      required this.title,
      required this.comment,
      required this.gradeAssigned,
      required this.classAssigned});

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(dueDate: map["dueDate"], title: map["title"], comment: map["comment"], gradeAssigned: map["gradeAssigned"], classAssigned: map["classAssigned"]);
  }
}
