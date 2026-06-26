import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/comments_model.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/loading_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.put(ProfileController());
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<PostModel> allPostsList = <PostModel>[].obs;
  final RxList<PostModel> myPostsList = <PostModel>[].obs;
  final RxList<CommentModel> commentModelList = <CommentModel>[].obs;
  final myVideoPostsList = <PostModel>[].obs;
  final myRepostsList = <PostModel>[].obs;
  final RxList<PostModel> friendsPostsList = <PostModel>[].obs;
  RxInt imageIndx = 22.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
    fetchMyPosts();
  }

  // Fetch ALL posts from Firestore
  Future<void> fetchAllPosts() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.postsCollection)
          .where('userId', isNotEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            allPostsList.value = snapshot.docs
                .map((doc) => PostModel.fromJson(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching all posts: ${e.message}');
    } catch (e) {
      print('Error in fetching all posts: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch only the current user's posts
  Future<void> fetchMyPosts() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.postsCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            final docs = snapshot.docs
                .map((doc) => PostModel.fromJson(doc.data()))
                .toList();

            // All my posts
            myPostsList.value = docs;

            // Only video posts
            myVideoPostsList.value = docs
                .where((post) => post.mediaType == 'video')
                .toList();

            // Only reposts (repostBy array contains my userId)
            myRepostsList.value = docs
                .where((post) => post.repostBy.contains(userId))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching my posts: ${e.message}');
    } catch (e) {
      print('Error in fetching my posts: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch posts from users the current user is following
  Future<void> fetchFriendsPosts(List<String> followingIds) async {
    try {
      isLoading.value = true;

      if (followingIds.isEmpty) {
        friendsPostsList.value = [];
        return;
      }

      // Split into chunks of 30 (Firestore whereIn limit)
      final chunks = <List<String>>[];
      for (var i = 0; i < followingIds.length; i += 30) {
        chunks.add(
          followingIds.sublist(
            i,
            i + 30 > followingIds.length ? followingIds.length : i + 30,
          ),
        );
      }

      FirebaseFirestore.instance
          .collection(AppConstants.postsCollection)
          .where('userId', whereIn: chunks.first)
          .snapshots()
          .listen((snapshot) {
            friendsPostsList.value = snapshot.docs
                .map((doc) => PostModel.fromJson(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching friends posts: ${e.message}');
    } catch (e) {
      print('Error in fetching friends posts: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadPost(
    BuildContext context,
    File? file,
    final String caption,
    final String location,
    final String visibility,
    final bool allowComments,
    final TextEditingController tagsController,
  ) async {
    try {
      LoadingUtil.show();
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(AppConstants.postsCollection)
          .doc();

      String mediaUrl = '';

      // Upload image to Supabase
      if (file != null) {
        final supabase = Supabase.instance.client;

        final String filePath =
            'post_images/${DateTime.now().millisecondsSinceEpoch}_${docRef.id}.jpg';

        await supabase.storage.from('images').upload(filePath, file);

        mediaUrl = supabase.storage.from('images').getPublicUrl(filePath);
      }
      final List<String> tags = tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final PostModel postModel = PostModel(
        postId: docRef.id,
        userId: userId,
        userName: profileController.profileUser.value!.username,
        profileImageUrl: profileController.profileUser.value!.profileImageUrl,
        caption: caption,
        mediaUrl: file != null ? mediaUrl : '',
        mediaType: 'image',
        isVideo: false,
        createdAt: DateTime.now(),
        location: location,
        likes: [],
        comments: [],
        tags: tags,
        repostBy: [],
        favorites: [],
        viewsBy: [],
        visibility: visibility,
        allowComments: allowComments,
        hideFrom: [],
        reports: [],
      );

      // Save story in Firebase
      await docRef.set(postModel.toJson());
      CustomToastUtil.showSuccess(
        context,
        message: 'Post uploaded successfully.',
      );
    } on FirebaseException catch (e) {
      error.value = e.message ?? '';
      CustomToastUtil.showError(context, message: e.message.toString());
      print('Error adding Post: ${e.message}');
    } catch (e) {
      error.value = e.toString();
      CustomToastUtil.showError(
        context,
        message: 'Unable to upload your Post. Please try again later.',
      );
      print('Error adding story: $e');
    } finally {
      LoadingUtil.dismiss();
    }
  }

  // Fetch ALL posts from Firestore
  Future<void> likePost(String postId) async {
    try {
      print('button pressed ******************');
      await _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
            'likes': FieldValue.arrayUnion([userId]),
          });
      print('updated');
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in like  posts: ${e.message}');
    } catch (e) {
      print('Error in like posts: ${e.toString()}');
      error.value = e.toString();
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
            'likes': FieldValue.arrayRemove([userId]),
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in like  posts: ${e.message}');
    } catch (e) {
      print('Error in like posts: ${e.toString()}');
      error.value = e.toString();
    }
  }

  Future<void> addComment(
    BuildContext context,
    String userName,
    String fullName,
    String profilePicture,
    String text,
    String postId,
  ) async {
    try {
      DocumentReference docRef = _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .collection(AppConstants.commentsCollection)
          .doc();

      CommentModel commentModel = CommentModel(
        id: docRef.id,
        userId: userId,
        username: userName,
        fullName: fullName,
        profilePicture: profilePicture,
        text: text,

        createdAt: DateTime.now(),
      );

      await docRef.set(commentModel.toMap());
      CustomToastUtil.showSuccess(
        context,
        message: 'Comment added successfully.',
      );
    } on FirebaseException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
      print('Error in add comment: ${e.message}');
    } catch (e) {
      CustomToastUtil.showError(context, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //fetch comments  by post id

  Future<void> fetchCommentsByPostId(String postId) async {
    try {
      isLoading.value = true;

      _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .collection(AppConstants.commentsCollection)
          .snapshots()
          .listen((snapshot) {
            commentModelList.value = snapshot.docs
                .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching friends posts: ${e.message}');
    } catch (e) {
      print('Error in fetching friends posts: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToStory(BuildContext context, String link) async {
    try {} catch (e) {}
  }
  //

  Future<void> reportPost(BuildContext context, String postId) async {
    try {
      await _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
            'reports': FieldValue.arrayUnion([userId]),
          });
      CustomToastUtil.showSuccess(
        context,
        message:
            'Post reported successfully. Thank you for helping keep our community safe.',
      );
    } catch (e) {
      CustomToastUtil.showError(
        context,
        message: 'Unable to report the post right now. Please try again later.',
      );
    }
  }

  Future<void> hidePost(BuildContext context, String postId) async {
    try {
      await _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
            'hideFrom': FieldValue.arrayUnion([userId]),
          });
      CustomToastUtil.showSuccess(
        context,
        message: 'This post has been hidden from your feed.',
      );
    } catch (e) {
      CustomToastUtil.showError(
        context,
        message:
            'Something went wrong while hiding the post. Please try again.',
      );
    }
  }

  Future<void> repostPost(BuildContext context, String postId) async {
    try {
      await _firebase
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
            'repostBy': FieldValue.arrayUnion([userId]),
          });
      CustomToastUtil.showSuccess(
        context,
        message: 'Post reposted successfully.',
      );
    } catch (e) {
      CustomToastUtil.showError(
        context,
        message: 'Unable to repost the post. Please try again later.',
      );
    }
  }

  Future<void> copyLink(BuildContext context, String link) async {
    try {
      await Clipboard.setData(ClipboardData(text: link));
      CustomToastUtil.showSuccess(context, message: 'Link copied to clipboard');
    } catch (e) {
      CustomToastUtil.showError(context, message: 'Failed to copy link');
    }
  }
}
