import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_buds/constants.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(
      String email, String username, String bio, String password, BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
              color: KTweeterColor,
            ));
          });
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'username': username,
          'email': email,
          'profilePicture': '',
          'bio': bio,
        });
        Navigator.pop(context);
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
              color: KTweeterColor,
            ));
          });
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      return true;
    } catch (e) {
      return false;
    }
  }

  static void logout() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
