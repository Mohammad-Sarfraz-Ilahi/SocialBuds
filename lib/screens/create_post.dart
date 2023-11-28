import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/services/storage_service.dart';
import 'package:social_buds/widgets/rounded_button.dart';

class CreatePostScreen extends StatefulWidget {
  final String currentUserId;

  const CreatePostScreen({
    super.key,
    required this.currentUserId,
  });
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _caption = '';
  File? _pickedImage;
  bool _loading = false;

  void handleImageFromGallery() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        _pickedImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTweeterColor,
        centerTitle: true,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Write something here...',
                ),
                onChanged: (value) {
                  _caption = value;
                },
              ),
              SizedBox(height: 20),
              _pickedImage == null
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (context)=>Container(
                                child: PhotoView(
                              minScale: 0.3,
                              maxScale: 3.0,
                              imageProvider: FileImage(_pickedImage as File),
                            )));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: KTweeterColor,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_pickedImage as File),
                                )),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
              GestureDetector(
                onTap: handleImageFromGallery,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: KTweeterColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: KTweeterColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                btnText: 'Post',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_caption != null && _caption.isNotEmpty) {
                    String image;
                    if (_pickedImage == null) {
                      image = '';
                    } else {
                      image =
                          await StorageService.uploadPostPicture(_pickedImage!);
                    }
                    Post post = Post(
                      text: _caption,
                      image: image,
                      authorId: widget.currentUserId,
                      likes: 0,
                      timestamp: Timestamp.fromDate(
                        DateTime.now(),
                      ),
                    );
                    DatabaseServices.createPost(post);
                    Navigator.pop(context);
                  }
                  setState(() {
                    _loading = false;
                  });
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator(
                      color: KTweeterColor,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
