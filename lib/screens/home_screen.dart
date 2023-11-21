import 'package:flutter/material.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/screens/create_post.dart';
import 'package:social_buds/screens/setting_screen.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/widgets/post_home.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  

  const HomeScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingPosts = [];
  bool _loading = false;

  buildPosts(Post post, UserModel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: PostHomeContainer(
        post: post,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingPosts(String currentUserId) {
    List<Widget> followingPostsList = [];
    for (Post post in _followingPosts) {
      followingPostsList.add(FutureBuilder(
          future: usersRef.doc(post.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildPosts(post, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return followingPostsList;
  }

  setupFollowingPosts() async {
    setState(() {
      _loading = true;
    });
    List followingTweets =
        await DatabaseServices.getHomePosts(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingPosts = followingTweets;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          leading: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              child: Icon(
                Icons.settings,
                color: KTweeterColor,
              )),
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/images/app_logo.png',
            height: 45,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePostScreen(
                              currentUserId: widget.currentUserId,
                            )));
              },
              icon: const Icon(
                Icons.add_box,
                color: Color.fromARGB(255, 255, 78, 90),
              ),
            ),
          ]),
      body: RefreshIndicator(
        color: KTweeterColor,
        onRefresh: () => setupFollowingPosts(),
        child: ListView(
          children: [
            _loading
                ? LinearProgressIndicator(
                    color: KTweeterColor,
                    minHeight: 2,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5),
                Column(
                  children: _followingPosts.isEmpty && _loading == false
                      ? [
                          Text(
                            'There is no new posts',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ]
                      : showFollowingPosts(widget.currentUserId),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
