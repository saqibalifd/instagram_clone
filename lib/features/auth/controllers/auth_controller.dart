import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/loading_utils.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  Future<void> loading() async {
    LoadingUtil.show();
    await Future.delayed(AppConstants.splashDuration);
    Get.offNamed(AppRoutes.login);
    LoadingUtil.dismiss();
  }

  Future<void> sessionManager() async {
    await Future.delayed(AppConstants.splashDuration);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offNamed(AppRoutes.bottomNavbar);
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  Future<void> login(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      LoadingUtil.show();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
      Get.offAllNamed(AppRoutes.bottomNavbar);
      CustomToastUtil.showGradient(
        context,
        message: 'Welcome back to Instagram.',
      );
    } on FirebaseAuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } on AuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> register(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController nameController,
    TextEditingController passwordController,
  ) async {
    try {
      LoadingUtil.show();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      Get.offAllNamed(AppRoutes.bottomNavbar);
      CustomToastUtil.showGradient(context, message: 'Welcome to Instagram.');
    } on FirebaseAuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } on AuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> signupWithGoogle(BuildContext context) async {
    try {
      LoadingUtil.show();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.bottomNavbar);
      CustomToastUtil.showGradient(context, message: 'Welcome to Instagram.');
    } on FirebaseAuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } catch (e) {
      CustomToastUtil.showError(context, message: e.toString());
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> signOut() async {
    Get.offAllNamed(AppRoutes.login);
  }
}







  // Future<void> signUp(String email, String password, String username) async {
  //   isLoading.value = true;
  //   errorMessage.value = '';
  //   try {
  //     await _repo.signUpWithEmail(email, password, username);
  //     Get.offAllNamed(AppRoutes.feed);
  //   } on AuthException catch (e) {
  //     errorMessage.value = e.message;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }