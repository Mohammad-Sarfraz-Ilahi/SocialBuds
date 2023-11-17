import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  final String visitedUserId;

  CommentScreen({
    super.key,
    required this.snap,
    required this.visitedUserId,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
        child: FutureBuilder(
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
            return Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    radius: 17,
                    backgroundImage: userModel.profilePicture.isEmpty
                        ? const AssetImage('assets/images/default_pic.png')
                        : NetworkImage(userModel.profilePicture)
                            as ImageProvider,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Comment here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await DatabaseServices().postComment(
                          widget.snap['authorId'],
                          _commentController.text,
                          userModel.id,
                          userModel.username,
                          userModel.profilePicture);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
