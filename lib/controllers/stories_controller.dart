import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoriesController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.put(ProfileController());
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<StoryModel> allStoryList = <StoryModel>[].obs;
  final RxList<StoryModel> userStoryList = <StoryModel>[].obs;
  final RxInt currentStoryIndex = 0.obs;

  final RxList<StoryModel> myStoryList = <StoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Track current index for like button reactivity

  void markStoryAsViewed(String storyId) {
    // update Firestore viewedBy array
  }

  bool isLikedByCurrentUser(String storyId) {
    final story = userStoryList.firstWhere((s) => s.storyId == storyId);
    final currentUserId = ''; // get from your auth controller
    return story.likedBy.contains(currentUserId);
  }

  void toggleLike(String storyId) {
    // update Firestore likedBy array
  }
  // Fetch ALL posts from Firestore (excluding current user)

  Future<void> addStory() async {
    try {
      isLoading.value = true;

      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('stories')
          .doc();

      final StoryModel storyModel = StoryModel(
        storyId: docRef.id,
        mediaUrl:
            'https://img.magnific.com/free-photo/closeup-shot-beautiful-butterfly-with-interesting-textures-orange-petaled-flower_181624-7640.jpg?semt=ais_hybrid&w=740&q=80',
        mediaType: 'mp4',
        caption: '',
        musicTitle: '',
        musicUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now(),
        viewedBy: [],
        likedBy: [],
        mentions: [],
        visibility: 'public',
        isHighlighted: false,
        highlightId: '',
        profileImageUrl: profileController.profileUser.value!.profileImageUrl,
        userId: profileController.profileUser.value!.userId,
        userName: profileController.profileUser.value!.username,
      );

      await docRef.set(storyModel.toJson());
    } on FirebaseException catch (e) {
      error.value = e.message ?? '';
      print('Error in fetching stories: ${e.message}');
    } catch (e) {
      error.value = e.toString();
      print('Error in fetching stories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch ALL posts from Firestore (excluding current user)
  Future<void> fetchStoriesByUser(String userId) async {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('stories')
          .snapshots()
          .listen((snapshot) {
            userStoryList.value = snapshot.docs
                .map((doc) => StoryModel.fromJson(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message ?? '';
      print('Error in fetching stories: ${e.message}');
    } catch (e) {
      error.value = e.toString();
      print('Error in fetching stories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareToStory(
    BuildContext context,
    String mediaUrl,
    String mediaType,
  ) async {
    try {
      isLoading.value = true;

      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('stories')
          .doc();

      final StoryModel storyModel = StoryModel(
        storyId: docRef.id,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        caption: '',
        musicTitle: '',
        musicUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now(),
        viewedBy: [],
        likedBy: [],
        mentions: [],
        visibility: 'public',
        isHighlighted: false,
        highlightId: '',
        profileImageUrl: profileController.profileUser.value!.profileImageUrl,
        userId: profileController.profileUser.value!.userId,
        userName: profileController.profileUser.value!.username,
      );

      await docRef.set(storyModel.toJson());

      CustomToastUtil.showSuccess(
        context,
        message: 'Post added to your story successfully.',
      );
    } on FirebaseException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } catch (e) {
      CustomToastUtil.showError(
        context,
        message:
            'Something went wrong while adding the post to your story. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
