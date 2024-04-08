import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/screens/edit_profile.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/widgets/posts.dart';

import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  const ProfileScreen(
      {super.key, required this.currentUserId, required this.visitedUserId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<Post> _allPosts = [];
  List<Post> _mediaPosts = [];

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Posts',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Photos',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _allPosts.length,
              itemBuilder: (context, index) {
                return PostContainer(
                  currentUserId: widget.currentUserId,
                  author: author,
                  post: _allPosts[index],
                );
              }),
        );
        break;
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _mediaPosts.length,
              itemBuilder: (context, index) {
                return PostContainer(
                  currentUserId: widget.currentUserId,
                  author: author,
                  post: _mediaPosts[index],
                );
              }),
        );
        break;
      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
        break;
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  getAllPosts() async {
    List<Post> userPosts =
        await DatabaseServices.getUserPosts(widget.visitedUserId) as dynamic;
    if (mounted) {
      setState(() {
        _allPosts = userPosts;
        _mediaPosts =
            _allPosts.where((element) => element.image.isNotEmpty).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: KTweeterColor,
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(KTweeterColor),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  transform: Matrix4.translationValues(0.0, 10.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          child: userModel.profilePicture.isEmpty
                                              ? Image.asset(
                                                  'assets/images/default_pic.png')
                                              : Image.network(
                                                  userModel.profilePicture,),
                                        ),
                                      ));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[800],
                              radius: 45,
                              backgroundImage: userModel.profilePicture.isEmpty
                                  ? const AssetImage(
                                      'assets/images/default_pic.png')
                                  : NetworkImage(userModel.profilePicture)
                                      as ImageProvider,
                            ),
                          ),
                          widget.currentUserId == widget.visitedUserId
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          user: userModel,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: KTweeterColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnFollow,
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _isFollowing
                                          ? Colors.white
                                          : KTweeterColor,
                                      border: Border.all(color: KTweeterColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isFollowing ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isFollowing
                                              ? KTweeterColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        userModel.username!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        userModel.bio!,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            '$_followingCount Following',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _profileSegmentedValue,
                          thumbColor: KTweeterColor,
                          backgroundColor: Colors.grey.shade700,
                          children: _profileTabs,
                          onValueChanged: (i) {
                            setState(() {
                              _profileSegmentedValue = i!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                buildProfileWidgets(userModel),
              ],
            );
          },
        ));
  }
}
