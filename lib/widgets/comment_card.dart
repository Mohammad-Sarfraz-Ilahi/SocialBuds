
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:social_buds/models/comment.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';

class CommentCard extends StatefulWidget {
  final Comments authorId;
  const CommentCard({super.key, required this.authorId,});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            // backgroundImage: widget.authorId.image
            // ? AssetImage('assets/images/default_pic.png')
            // : NetworkImage(widget.authorId['profilePicture']) as ImageProvider,
            radius: 18,
          ),
          Padding(padding: EdgeInsets.only(left: 16),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: 'username',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: 'Some description',
                   ),
                ],
              ))
            ],
           ),
          ),
        ],
      ),
    );
  }
}
