import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String? commentId;
  String authorId;
  String username;
  String text;
  String profilePicture;
  Timestamp date;
  Comments(
      {this.commentId,
      required this.authorId,
      required this.username,
      required this.text,
      required this.profilePicture,
      required this.date,});

  factory Comments.fromDoc(DocumentSnapshot doc) {
    return Comments(
      commentId: doc.id,
      authorId: doc['authorId'],
      username: doc['username'],
      text: doc['text'],
      profilePicture: doc['profilePicture'],
      date: doc['date'],
    );
  }
}
