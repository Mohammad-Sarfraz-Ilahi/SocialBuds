import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/post.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../models/activity.dart';

class DatabaseServices {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('username', isGreaterThanOrEqualTo: name)
        .where('username', isLessThan: name + 'z')
        .get();

    return users;
  }

  static void updateUserData(UserModel user) {
    usersRef.doc(user.id).update({
      'username': user.username,
      'bio': user.bio,
      'profilePicture': user.profilePicture,
    });
  }

  static void followUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({});

    addActivity(currentUserId, null, true, visitedUserId);
  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static void createPost(Post post) {
    postsRef.doc(post.authorId).set({'postTime': post.timestamp});
    postsRef.doc(post.authorId).collection('userPosts').add({
      'text': post.text,
      'image': post.image,
      "authorId": post.authorId,
      "timestamp": post.timestamp,
      'likes': post.likes,
    }).then((doc) async {
      QuerySnapshot followerSnapshot =
          await followersRef.doc(post.authorId).collection('Followers').get();

      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': post.text,
          'image': post.image,
          "authorId": post.authorId,
          "timestamp": post.timestamp,
          'likes': post.likes,
        });
      }
    });
  }

  static Future<List> getHomePosts(String currentUserId) async {
    QuerySnapshot homePosts = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<Post> followingPosts =
        homePosts.docs.map((doc) => Post.fromDoc(doc)).toList();
    return followingPosts;
  }

  static Future<List> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> userPosts =
        userPostsSnap.docs.map((doc) => Post.fromDoc(doc)).toList();

    return userPosts;
  }

  static Future<bool> isLikePost(String currentUserId, Post post) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(post.id)
        .collection('postLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static void likePost(String currentUserId, Post post) {
    DocumentReference postDocProfile =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postDocProfile.get().then((doc) {
      int likes = doc['likes'];
      postDocProfile.update({'likes': likes + 1});
    });

    DocumentReference postDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(post.id);
    postDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = doc['likes'];
        postDocFeed.update({'likes': likes + 1});
      }
    });

    likesRef.doc(post.id).collection('postLikes').doc(currentUserId).set({});

    addActivity(currentUserId, post, false, null);
  }

  static void unlikePost(String currentUserId, Post post) {
    DocumentReference postDocProfile =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postDocProfile.get().then((doc) {
      int likes = doc['likes'];
      postDocProfile.update({'likes': likes - 1});
    });

    DocumentReference postDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(post.id);
    postDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = doc['likes'];
        postDocFeed.update({'likes': likes - 1});
      }
    });

    likesRef
        .doc(post.id)
        .collection('postLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());

    addActivity(currentUserId, post, false, null);
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();

    List<Activity> activities = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();

    return activities;
  }

  static void addActivity(
      String currentUserId, Post? post, bool follow, String? followedUserId) {
    if (follow) {
      activitiesRef.doc(followedUserId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": true,
      });
    } else {
      activitiesRef.doc(post!.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": false,
      });
    }
  }


  Future<void> postComment(Post post, String text, String uid, String? username,
      String profilePicture) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        postsRef
            .doc(post.authorId)
            .collection('userPosts')
            .doc(post.id)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePicture': profilePicture,
          'username': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'date': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
