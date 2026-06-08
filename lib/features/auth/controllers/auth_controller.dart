import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/loading_utils.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationServices _notificationService = NotificationServices();

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
      updateDeviceToken();
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
      await storeUserData(
        context,
        fullName: nameController.text,
        email: emailController.text.trim(),
        username: nameController.text.trim(),
        profileImageUrl: '',
        phone: '',
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

  Future<void> registerWithGoogle(BuildContext context) async {
    try {
      LoadingUtil.show();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await storeUserData(
        context,
        fullName: googleUser.displayName ?? '',
        email: googleUser.email,
        username: googleUser.displayName ?? '',
        profileImageUrl: googleUser.photoUrl ?? '',
        phone: '',
      );
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

  Future<void> sendOtp(
    BuildContext context,
    String selectedCountry,
    String phone,
    String name,
    String email,
  ) async {
    try {
      LoadingUtil.show();
      final phoneNumber = '$selectedCountry$phone';
      final completer = Completer<void>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          if (!completer.isCompleted) completer.complete();
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) completer.complete();
          CustomToastUtil.showError(context, message: e.message.toString());
        },

        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) completer.complete();
          CustomToastUtil.showDefault(
            context,
            message: 'OTP sent successfully',
          );
          Get.offAllNamed(
            AppRoutes.otp,
            arguments: {
              'verificationId': verificationId,
              'phone': '$selectedCountry$phone',
              'name': name,
              'email': email,
            },
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future;
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> verifyOtp(
    BuildContext context,
    String otp,
    String verificationId,
    String name,
    String userName,
    String email,
    String phone,
  ) async {
    try {
      LoadingUtil.show();
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      User? user = userCredential.user;
      CustomToastUtil.showGradient(context, message: 'Welcome to Instagram.');
      await storeUserData(
        context,
        fullName: name,
        email: email,
        username: userName,
        profileImageUrl: '',
        phone: phone,
      );
      Get.offAllNamed(AppRoutes.bottomNavbar);
    } on FirebaseAuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
    } catch (e) {
      CustomToastUtil.showError(context, message: e.toString());
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> resendOtp(BuildContext context, String phoneNumber) async {
    try {
      LoadingUtil.show();
      final completer = Completer<void>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          if (!completer.isCompleted) completer.complete();
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) completer.complete();
          CustomToastUtil.showError(context, message: e.message.toString());
        },

        codeSent: (String newVerificationId, int? resendToken) {
          if (!completer.isCompleted) completer.complete();
          CustomToastUtil.showDefault(
            context,
            message: 'OTP resent successfully',
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future;
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> resetPassword(
    BuildContext context,
    TextEditingController emailController,
  ) async {
    try {
      LoadingUtil.show();

      await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      CustomToastUtil.showDefault(
        context,
        message: 'Password reset email sent. Please check your inbox.',
      );

      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      CustomToastUtil.showError(context, message: e.message.toString());
      print(e.toString());
    } catch (e) {
      CustomToastUtil.showError(context, message: e.toString());
      print(e.toString());
    } finally {
      LoadingUtil.dismiss();
    }
  }

  Future<void> storeUserData(
    BuildContext context, {
    required String fullName,
    required String email,
    required String username,
    required String profileImageUrl,
    required String phone,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;
      final deviceToken = await _notificationService.getDeviceToken();

      final UserModel userModel = UserModel(
        fullName: fullName,
        email: email,
        username: username,
        profileImageUrl: profileImageUrl,
        userId: userId,
        deviceToken: deviceToken.toString(),
        bio: '',
        website: '',
        isPrivate: false,
        isVerified: false,
        createdAt: Timestamp.now(),
        following: [],
        followers: [],
        location: '',
        phone: phone,
        updatedAt: Timestamp.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set(userModel.toJson());
    } on FirebaseException catch (e) {
      CustomToastUtil.showError(
        context,
        message: e.message ?? 'Something went wrong',
      );
    } on Exception catch (e) {
      print(' errror in storing data ${e.toString()}');
    }
  }

  Future<void> updateDeviceToken() async {
    final deviceToken = await _notificationService.getDeviceToken();
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(_auth.currentUser!.uid)
        .update({'deviceToken': deviceToken.toString()});
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
