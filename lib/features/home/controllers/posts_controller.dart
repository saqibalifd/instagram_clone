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

class PostsController extends GetxController {
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

  Future<void> uploadPosts() async {
    try {} on FirebaseException catch (e) {
    } catch (e) {
    } finally {
      LoadingUtil.dismiss();
    }
  }
}
