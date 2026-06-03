// ============================================================
//  WHAT GOES HERE
//  All auth business logic:
//    * Observable form state (isLoading, errorMessage)
//    * signIn / signUp / signOut methods
//    * Navigate after success, Snackbar on failure
//  Talks to AuthRepository ONLY — never to AuthSource directly.
//  Do NOT import firebase_auth here.
// ============================================================

import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import '../../../data/repositories/interfaces/auth_repository.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  AuthController(this._repo);

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> sessionManager() async {
    await Future.delayed(AppConstants.splashDuration);
    Get.offNamed(AppRoutes.login);
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _repo.signInWithEmail(email, password);
      Get.offAllNamed(AppRoutes.feed);
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _repo.signUpWithEmail(email, password, username);
      Get.offAllNamed(AppRoutes.feed);
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
