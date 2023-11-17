import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  Post(
      {this.id,
      required this.authorId,
      required this.text,
      required this.image,
      required this.timestamp,
      required this.likes,});

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
    );
  }
}
