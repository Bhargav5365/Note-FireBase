import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String title;
  final String? name;
  final String? uid;
  final Timestamp? dateTime;
  Note({required this.title, this.name, this.uid, this.dateTime});

  Note.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            uid: json['uid'] as String,
            dateTime: json['dateTime'] as Timestamp);

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'name': name,
      'uid': uid,
      'dateTime': dateTime,
    };
  }
}
