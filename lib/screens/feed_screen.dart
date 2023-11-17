import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_buds/constants.dart';

import 'home_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;

  const FeedScreen({super.key, required this.currentUserId});
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationScreen(
          currentUserId: widget.currentUserId,
        ),
        ProfileScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        //backgroundColor: Colors.redAccent,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: KTweeterColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded,)),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded)),
        ],
      ),
    );
  }
}
