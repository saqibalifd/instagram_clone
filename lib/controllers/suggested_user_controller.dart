import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:instagram/services/send_notification_service.dart';
import '../../../data/models/user_model.dart';

class SuggestedUserController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final RxString error = ''.obs;
  final RxBool showSuggestion = false.obs;
  final RxBool isFollowed = false.obs;

  RxList<UserModel> suggestedUsersList = <UserModel>[].obs;
  RxList<UserModel> friendsUsers = <UserModel>[].obs;
  RxList<UserModel> mutualUsers = <UserModel>[].obs;
  final RxSet<String> followingIds = <String>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSuggestedUserStream();
    loadMyFollowing();
  }

  Future<void> loadMyFollowing() async {
    final doc = await _firebase
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    final data = doc.data();
    final List<String> following = List<String>.from(data?['following'] ?? []);

    followingIds.assignAll(following);
  }

  Future<void> checkMutuals(String targetUserId) async {
    try {
      isLoading.value = true;

      // Fetch current user's following list
      final currentUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final currentUserData = currentUserDoc.data();
      final List<String> myFollowing = List<String>.from(
        currentUserData?['following'] ?? [],
      );

      // Fetch target user's following list
      final targetUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(targetUserId)
          .get();

      final targetUserData = targetUserDoc.data();
      final List<String> targetFollowing = List<String>.from(
        targetUserData?['following'] ?? [],
      );

      // Find mutual IDs (users that both follow)
      final List<String> mutualIds = myFollowing
          .where((id) => targetFollowing.contains(id))
          .toList();

      if (mutualIds.isEmpty) {
        mutualUsers.clear();
        return;
      }

      // Fetch UserModel for each mutual ID
      final List<UserModel> fetchedMutuals = [];

      for (final mutualId in mutualIds) {
        final doc = await _firebase
            .collection(AppConstants.usersCollection)
            .doc(mutualId)
            .get();

        if (doc.exists && doc.data() != null) {
          fetchedMutuals.add(UserModel.fromJson(doc.data()!));
        }
      }

      mutualUsers.assignAll(fetchedMutuals);
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // load snapshot profile
  Future<void> loadSuggestedUserStream() async {
    try {
      isLoading.value = true;

      _firebase
          .collection(AppConstants.usersCollection)
          .where('userId', isNotEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            final allUsers = snapshot.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList();

            // filter locally
            final filteredUsers = allUsers.where((user) {
              return user.userId != userId &&
                  !suggestedUsersList.contains(user.userId.toString());
            }).toList();

            suggestedUsersList.assignAll(filteredUsers);
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> followUser(String toFollowUserId) async {
    try {
      isLoading.value = true;

      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
            'following': FieldValue.arrayUnion([toFollowUserId]),
          });

      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(toFollowUserId)
          .update({
            'followers': FieldValue.arrayUnion([userId]),
          });

      followingIds.add(toFollowUserId);

      await SendNotificationService.sendNotificationUsingApi(
        token:
            'dbpjwWeLSs2DxXxb2giIq8:APA91bHDQvjVYMw4tMamHe3oiYLr3nlBYGggh0oNEYk9X9ioHrDCytHmL_vK9HgddUXLnU1VRaVCQ6rDiIGme5QH6qnpMTEk0SW1DVTgqlkqGuqnuzUzwC8',
        title: 'New Follower',
        body: 'You have a new follower',
        data: {},
      );
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unfollowUser(String toFollowUserId) async {
    try {
      isLoading.value = true;
      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
            'following': FieldValue.arrayRemove([toFollowUserId]),
          });

      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(toFollowUserId)
          .update({
            'followers': FieldValue.arrayRemove([userId]),
          });

      followingIds.remove(toFollowUserId); // update UI instantly
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipUser(int index) async {
    try {
      suggestedUsersList.removeAt(index);
    } catch (e) {
      error.value = e.toString();
    }
  }

  void suggestionButtonSwitch() {
    showSuggestion.value = !showSuggestion.value;
  }
}
