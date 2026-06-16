import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/loading_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  late final LocalStorageService _localStorage;

  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final supabase = Supabase.instance.client;

  final profileUser = Rxn<UserModel>();
  final fetchLoading = false.obs;
  final updateLoading = false.obs;
  final isLoading = false.obs;
  final profileSnapshotLoading = false.obs;
  final specificUserData = Rxn<UserModel>();
  RxBool specificUserLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    _localStorage = Get.put<LocalStorageService>(LocalStorageService());

    loadLocalProfile();
    loadProfileStream();
  }

  // load snapshot profile
  Future<void> loadProfileStream() async {
    try {
      profileSnapshotLoading.value = true;

      _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .snapshots()
          .listen((doc) {
            if (doc.exists) {
              profileUser.value = UserModel.fromJson(doc.data()!);
            }
          });
    } finally {
      profileSnapshotLoading.value = false;
    }
  }

  // load local profile
  Future<void> loadLocalProfile() async {
    isLoading.value = true;

    final user = _localStorage.getUser();

    profileUser.value = user;

    isLoading.value = false;
  }

  //update profile on local and global
  Future<void> updateProfile(
    BuildContext context,
    String name,
    String bio,
    String gender,
  ) async {
    try {
      LoadingUtil.show();
      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'fullName': name, 'bio': bio, 'gender': gender});
      await _localStorage.storeFullNameLocal(name);
      await _localStorage.storeBioLocal(bio);
      await _localStorage.storeGenderLocal(gender);

      CustomToastUtil.showDefault(context, message: 'Profile updated.');
    } on FirebaseException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } catch (e) {
      CustomToastUtil.showError(
        context,
        message: AppConstants.commonErrorMessage,
      );
    } finally {
      LoadingUtil.dismiss();
    }
  }

  // update profile picture s
  Future<void> updateProfilePicture(
    BuildContext context,
    File imageFile,
  ) async {
    try {
      LoadingUtil.show();

      final userId = FirebaseAuth.instance.currentUser!.uid;

      final fileName = '$userId.jpg';

      final filePath = 'profile_pictures/$fileName';

      await supabase.storage
          .from('images')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final imageUrl =
          '${supabase.storage.from('images').getPublicUrl(filePath)}'
          '?t=${DateTime.now().millisecondsSinceEpoch}';

      await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'profileImageUrl': imageUrl});

      await _localStorage.storeProfileImageLocal(imageUrl);

      CustomToastUtil.showDefault(context, message: 'Profile picture updated.');
    } on FirebaseException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } catch (e) {
      print(
        '*********************error found in update profile picture********************',
      );
      print(e.toString());
      CustomToastUtil.showError(
        context,
        message: AppConstants.commonErrorMessage,
      );
    } finally {
      LoadingUtil.dismiss();
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
}
