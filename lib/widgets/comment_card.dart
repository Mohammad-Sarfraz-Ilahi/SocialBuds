import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:social_buds/models/comment.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snap['profilePicture']),
            radius: 18,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('${snap['username']} ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(snap['text'],style: TextStyle(fontSize: 15),),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap['date'].toDate(),
                      ),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,color: Colors.grey),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
