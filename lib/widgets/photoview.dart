import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';

class PhotoViewEx extends StatefulWidget {
  final Post post;
  final UserModel author;
  const PhotoViewEx({
    super.key,
    required this.post,
    required this.author,
  });

  @override
  State<PhotoViewEx> createState() => _PhotoViewExState();
}

class _PhotoViewExState extends State<PhotoViewEx> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          minScale: 0.3,
          maxScale: 3.0,
      imageProvider: NetworkImage(widget.post.image),
    ));
  }
}
