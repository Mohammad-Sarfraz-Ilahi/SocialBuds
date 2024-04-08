import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/services/database_service.dart';
import 'package:social_buds/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _name;
  String? _bio;
  File? _profileImage;
  File? _coverImage;
  String? _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  ImagePicker imagePicker = new ImagePicker();

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profilePicture.isEmpty) {
        return const AssetImage('assets/images/default_pic.png');
      } else {
        return NetworkImage(widget.user.profilePicture);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String? profilePictureUrl = '';
      String? coverPictureUrl = '';
      if (_profileImage == null) {
        profilePictureUrl = widget.user.profilePicture;
      } else {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.user.profilePicture, _profileImage!);
      }
      UserModel user = UserModel(
        id: widget.user.id,
        username: _name,
        profilePicture: profilePictureUrl,
        bio: _bio,
      );

      DatabaseServices.updateUserData(user);
      Navigator.pop(context);
    }
  }

  void handleImageFromGallery() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        _profileImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.username;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: KTweeterColor,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            transform: Matrix4.translationValues(0, 10, 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: displayProfileImage(),
                          ),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Change Profile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        width: 100,
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: KTweeterColor,
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          initialValue: _name,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: KTweeterColor),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3 || value.length > 30) {
                              return 'Username must be between 3 and 30 characters';
                            }
                            if (!RegExp(r'^[a-z-0-9_]+$').hasMatch(value)) {
                              return 'It can only contain small letters, numbers, underscore';
                            }
                            if (value.startsWith('_') || value.endsWith('_')) {
                              return 'Username cannot start or end with an underscore';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          initialValue: _bio,
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            labelStyle: TextStyle(color: KTweeterColor),
                          ),
                          onSaved: (value) {
                            _bio = value;
                          },
                        ),
                        SizedBox(height: 30),
                        _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(KTweeterColor),
                              )
                            : SizedBox.shrink()
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
