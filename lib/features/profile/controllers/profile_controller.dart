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

  @override
  void onInit() {
    super.onInit();

    _localStorage = Get.put<LocalStorageService>(LocalStorageService());

    loadLocalProfile();
  }

  Future<void> loadLocalProfile() async {
    isLoading.value = true;

    final user = _localStorage.getUser();

    profileUser.value = user;

    isLoading.value = false;
  }

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

  // Future<void> updateProfilePicture(
  //   BuildContext context,
  //   File imageFile,
  // ) async {
  //   try {
  //     LoadingUtil.show();

  //     final userId = FirebaseAuth.instance.currentUser!.uid;

  //     final fileName = '$userId.jpg';

  //     final filePath = 'profile_pictures/$fileName';

  //     await supabase.storage
  //         .from('images')
  //         .upload(
  //           filePath,
  //           imageFile,
  //           fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //         );

  //     final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);

  //     await _firebase
  //         .collection(AppConstants.usersCollection)
  //         .doc(userId)
  //         .update({'profileImageUrl': imageUrl});

  //     await _localStorage.storeProfileImageLocal(imageUrl);

  //     CustomToastUtil.showDefault(context, message: 'Profile picture updated.');
  //   } on FirebaseException catch (e) {
  //     CustomToastUtil.showError(context, message: e.message.toString());
  //   } catch (e) {
  //     print(
  //       '*********************error found in update profile picture********************',
  //     );
  //     print(e.toString());
  //     CustomToastUtil.showError(
  //       context,
  //       message: AppConstants.commonErrorMessage,
  //     );
  //   } finally {
  //     LoadingUtil.dismiss();
  //   }
  // }

  Future<void> loadProfileFromServer(String userId) async {
    isLoading.value = true;

    isLoading.value = false;
  }
}
