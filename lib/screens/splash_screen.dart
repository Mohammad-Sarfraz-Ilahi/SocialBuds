import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_buds/screens/feed_screen.dart';
import 'package:social_buds/screens/welcome_screen.dart';


class StartPage extends StatefulWidget {

  @override
  State<StartPage> createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/splashlogo.jpg",
                    height: 500,
                    width: 500,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Color.fromARGB(255, 255, 255, 255),width: 500,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                child: Text("Developed By Sarfraz",
                style: TextStyle(
                color: Colors.grey),),
              ),
            ),
          ),
        ],
      ),
    );
  }
   void whereToGo() async {
    Timer(Duration(seconds: 1), () {
    StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if(snapshot.hasData){
        return FeedScreen(currentUserId: snapshot.data!.uid,);
      }else {
        return WelcomeScreen();
      }
    }
    );
    });
  }
}