import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String? username;
  String profilePicture;
  String? email;
  String? bio;
  UserModel(
      {required this.id,
      required this.username,
      required this.profilePicture,
      this.email,
      required this.bio,
      });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      username: doc['username'],
      email: doc['email'],
      profilePicture: doc['profilePicture'],
      bio: doc['bio'],
    );
  }
}
