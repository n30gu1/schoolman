import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  String title;
  String content;
  Timestamp timeCreated;
  List attachments;
  String? todoItemId;

  Notice(
      {required this.title,
      required this.content,
      required this.timeCreated,
      required this.attachments,
      this.todoItemId});

  static Notice fromMap(Map map) {
    return Notice(
        title: map["title"],
        content: map["content"],
        timeCreated: map["timeCreated"],
        attachments: map["attachments"],
        todoItemId: map["todoItemId"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "content": this.content,
      "timeCreated": this.timeCreated,
      "attachments": this.attachments,
      "todoItemId": this.todoItemId
    };
  }
}
