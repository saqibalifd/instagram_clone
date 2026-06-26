import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/services/send_notification_service.dart';
import '../../../data/models/user_model.dart';

class UserController extends GetxController {
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
  final specificUserData = Rxn<UserModel>();
  RxBool specificUserLoading = false.obs;
  final RxString followStatus = 'Follow'.obs;
  final RxBool followStatusLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // getSuggestedUsers();
    fetchDiscoverUsers();
    // loadSuggestedUserStream();
    loadMyFollowing();
    loadFriends();
  }

  Future<void> loadFriends() async {
    try {
      isLoading.value = true;

      final doc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final data = doc.data();
      final List<String> following = List<String>.from(
        data?['following'] ?? [],
      );
      final List<String> followers = List<String>.from(
        data?['followers'] ?? [],
      );

      // Friends = IDs present in BOTH following and followers (mutual)
      final List<String> friendIds = following
          .where((id) => followers.contains(id))
          .toList();

      if (friendIds.isEmpty) {
        friendsUsers.clear();
        return;
      }

      final List<UserModel> fetchedFriends = [];

      for (final friendId in friendIds) {
        final friendDoc = await _firebase
            .collection(AppConstants.usersCollection)
            .doc(friendId)
            .get();

        if (friendDoc.exists && friendDoc.data() != null) {
          fetchedFriends.add(UserModel.fromJson(friendDoc.data()!));
        }
      }

      friendsUsers.assignAll(fetchedFriends);
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
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

  Future<void> fetchDiscoverUsers() async {
    try {
      isLoading.value = true;

      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Step 1: Get current user's doc to read the following list
      final DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      final List<String> followingList = List<String>.from(
        (currentUserDoc.data() as Map<String, dynamic>)['following'] ?? [],
      );

      // Step 2: Fetch all users
      final QuerySnapshot allUsersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      // Step 3: Filter out yourself + anyone you already follow
      final List<UserModel> filtered = allUsersSnapshot.docs
          .where((doc) {
            final isMe = doc.id == currentUserId;
            final isFollowing = followingList.contains(doc.id);
            return !isMe && !isFollowing;
          })
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      suggestedUsersList.assignAll(filtered);
    } catch (e) {
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
      await loadFollowStatus(toFollowUserId);

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
      await loadFollowStatus(toFollowUserId);
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch any specific user by userId and store in Rxn<UserModel>
  Future<UserModel?> fetchUserById(String targetUserId) async {
    try {
      specificUserLoading.value = true;

      final doc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(targetUserId)
          .get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromJson(doc.data()!);

        // store in reactive variable (you can reuse or create separate one)
        specificUserData.value = user;

        return user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    } finally {
      specificUserLoading.value = false;
    }
  }

  Future<void> skipUser(int index) async {
    try {
      suggestedUsersList.removeAt(index);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> loadFollowStatus(String targetUserId) async {
    try {
      followStatusLoading.value = true;

      final currentUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final targetUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(targetUserId)
          .get();

      if (!currentUserDoc.exists || !targetUserDoc.exists) {
        followStatus.value = "Follow";
        return;
      }

      final currentUserData = currentUserDoc.data()!;
      final targetUserData = targetUserDoc.data()!;

      final List<String> myFollowing = List<String>.from(
        currentUserData['following'] ?? [],
      );

      final List<String> targetFollowing = List<String>.from(
        targetUserData['following'] ?? [],
      );

      final bool iFollowHim = myFollowing.contains(targetUserId);
      final bool heFollowsMe = targetFollowing.contains(userId);

      if (!iFollowHim && !heFollowsMe) {
        followStatus.value = "Follow";
      } else if (!iFollowHim && heFollowsMe) {
        followStatus.value = "Follow Back";
      } else if (iFollowHim && !heFollowsMe) {
        followStatus.value = "Following";
      } else {
        followStatus.value = "Friends";
      }
    } on FirebaseException catch (e) {
      error.value = e.message ?? "";
      followStatus.value = "Follow";
    } finally {
      followStatusLoading.value = false;
    }
  }

  void suggestionButtonSwitch() {
    showSuggestion.value = !showSuggestion.value;
  }
}
