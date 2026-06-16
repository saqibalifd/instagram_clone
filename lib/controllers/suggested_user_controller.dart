import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';

class SuggestedUserController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final RxString error = ''.obs;
  final RxBool showSuggestion = false.obs;

  RxList<UserModel> suggestedUsersList = <UserModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSuggestedUserStream();
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

  Future<void> followUser(String toFollowUserId, int index) async {
    try {
      isLoading.value = true;

      _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
            'following': FieldValue.arrayUnion([toFollowUserId]),
          })
          .then((value) {
            _firebase
                .collection(AppConstants.usersCollection)
                .doc(toFollowUserId)
                .update({
                  'followers': FieldValue.arrayUnion([userId]),
                });
            skipUser(index);
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unfollowUser(String toFollowUserId, int index) async {
    try {
      isLoading.value = true;

      _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
            'following': FieldValue.arrayRemove([toFollowUserId]),
          })
          .then((value) {
            skipUser(index);
          });
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
