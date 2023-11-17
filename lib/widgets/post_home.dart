import 'package:flutter/material.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/screens/comment_screen.dart';
import 'package:social_buds/screens/profile_screen.dart';
import 'package:social_buds/services/database_service.dart';

class PostHomeContainer extends StatefulWidget {
  final snap;
  final Post post;
  final UserModel author;
  final String currentUserId;

  const PostHomeContainer({
    super.key,
    required this.post,
    required this.author,
    required this.currentUserId, this.snap,
  });
  @override
  _PostHomeContainerState createState() => _PostHomeContainerState();
}

class _PostHomeContainerState extends State<PostHomeContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initPostLikes() async {
    bool isLiked =
        await DatabaseServices.isLikePost(widget.currentUserId, widget.post);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likePost() {
    if (_isLiked) {
      DatabaseServices.unlikePost(widget.currentUserId, widget.post);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likePost(widget.currentUserId, widget.post);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post.likes;
    initPostLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 20,
                  backgroundImage: widget.author.profilePicture.isEmpty
                      ? AssetImage('assets/images/default_pic.png')
                      : NetworkImage(widget.author.profilePicture)
                          as ImageProvider,
                ),
                SizedBox(width: 10),
                Text(
                  widget.author.username!,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(
            widget.post.text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          widget.post.image.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Container(
                                    child: Image.network(
                                      widget.post.image,
                                    ),
                                  ),
                                ));
                      },
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.post.image),
                            )),
                      ),
                    )
                  ],
                ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: likePost,
                  ),
                  Text(
                    _likesCount.toString() + ' Likes',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => CommentScreen(
                        //               snap: widget.snap['authotId'],
                        //               visitedUserId: widget.currentUserId,
                        //             ))));
                      },
                      icon: Icon(
                        Icons.comment,
                        color: Colors.grey,
                      )),
                ],
              ),
              Text(
                widget.post.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
