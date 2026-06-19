import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoriesController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.put(ProfileController());
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<StoryModel> allStoryList = <StoryModel>[].obs;
  final RxList<StoryModel> myStoryList = <StoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch ALL posts from Firestore (excluding current user)
  Future<void> fetchAllStories() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.storiesCollection)
          .where('userId', isNotEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            allStoryList.value = snapshot.docs
                .map((doc) => StoryModel.fromJson(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching all stories: ${e.message}');
    } catch (e) {
      print('Error in fetching all stories: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch only the current user's posts
  Future<void> fetchMyStory() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.storiesCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            final docs = snapshot.docs
                .map((doc) => StoryModel.fromJson(doc.data()))
                .toList();

            // All my posts
            myStoryList.value = docs;
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

  Future<void> uploadStories(String caption) async {
    try {
      isLoading.value = true;

      DocumentReference docRef = _firebase
          .collection(AppConstants.storiesCollection)
          .doc();
      final currentUser = profileController.profileUser.value;
      final StoryModel storyModel = StoryModel(
        storyId: docRef.id,
        userId: userId,
        userName: currentUser!.fullName,
        profileImageUrl: currentUser.profileImageUrl,
        mediaUrl:
            'https://www.whitcoulls.co.nz/content/products/9780008792183.jpg?enable=upscale&canvas=2:3&auto=webp&optimize=high&width=248',
        mediaType: 'photo',
        caption: caption,
        musicTitle: 'The pop song of the day remix',
        musicUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 1)),
        viewedBy: [],
        likedBy: [],
        mentions: [],
        visibility: 'public',
        isHighlighted: false,
        highlightId: currentUser.userId,
      );

      await docRef.set(storyModel.toJson());
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } catch (e) {
      error.value = AppConstants.commonErrorMessage;
    } finally {
      isLoading.value = false;
    }
  }
}
