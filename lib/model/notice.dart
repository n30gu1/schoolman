import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  String title;
  String content;
  Timestamp timeCreated;
  List attachments;

  Notice(
      {required this.title,
      required this.content,
      required this.timeCreated,
      required this.attachments});

  static Notice fromMap(Map map) {
    return Notice(
        title: map["title"],
        content: map["content"],
        timeCreated: map["timeCreated"],
        attachments: map["attachments"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "content": this.content,
      "timeCreated": this.timeCreated,
      "attachments": this.attachments
    };
  }
}
