import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String id;
  Timestamp dueDate;
  String title;
  String comment;
  Map<String, dynamic> classAssigned;

  TodoItem(
      {required this.id,
      required this.dueDate,
      required this.title,
      required this.comment,
      required this.classAssigned});

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(
        id: map["id"],
        dueDate: map["dueDate"],
        title: map["title"],
        comment: map["comment"],
        classAssigned: map["classAssigned"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dueDate": dueDate,
      "title": title,
      "comment": comment,
      "classAssigned": classAssigned
    };
  }
}
