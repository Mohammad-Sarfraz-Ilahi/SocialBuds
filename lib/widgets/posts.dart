import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/screens/comment_screen.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/widgets/photoview.dart';

class PostContainer extends StatefulWidget {
  final Post post;
  final UserModel author;
  final String currentUserId;

  const PostContainer({
    super.key,
    required this.post,
    required this.author,
    required this.currentUserId,
  });
  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              SizedBox(width: 20),
                Text(
                DateFormat.yMMMd().format(
                  widget.post.timestamp.toDate(),
                ),
                style: TextStyle(color: Colors.grey),
              ),
            ],
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoViewEx(
                                      author: widget.author,
                                      post: widget.post,
                                    )));
                      },
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.post.image),
                            )),
                      ),
                    )
                  ],
                ),
          SizedBox(height: 15),
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
                  SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => CommentScreen(
                                      visitedUserId: widget.currentUserId,
                                      authorId: widget.post.authorId,
                                      id: widget.post.id.toString(),
                                      post: widget.post,
                                    ))));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.comment,
                        color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text('Comments')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
