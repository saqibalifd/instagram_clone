import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/loading_utils.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  late final LocalStorageService _localStorage;
  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

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

  Future<void> updateProfilePicture(BuildContext context) async {
    try {
      LoadingUtil.show();
      await _firebase.collection(AppConstants.usersCollection).doc(userId).update({
        'profileImageUrl':
            'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
      });
      await _localStorage.storeProfileImageLocal(
        'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
      );

      CustomToastUtil.showDefault(context, message: 'Profile picture updated.');
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

  Future<void> loadProfileFromServer(String userId) async {
    isLoading.value = true;

    isLoading.value = false;
  }
}
