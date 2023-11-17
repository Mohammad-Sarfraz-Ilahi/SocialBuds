import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_buds/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadProfilePicture(String url, final photo) async {
    String? uniquePhotoId = const Uuid().v4();
    XFile image = await compressImage(uniquePhotoId, photo);
    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      uniquePhotoId = exp.firstMatch(url)![1];
    }
    UploadTask uploadTask = storageRef
        .child('images/users/userProfile_$uniquePhotoId.jpg')
        .putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPostPicture(File imageFile) async {
    String uniquePhotoId = const Uuid().v4();
    XFile image = await compressImage(uniquePhotoId, imageFile);

    UploadTask uploadTask = storageRef
        .child('images/posts/post_$uniquePhotoId.jpg')
        .putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<dynamic> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedImage = (await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    ));
    return compressedImage;
  }
}
