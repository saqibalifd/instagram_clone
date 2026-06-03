// ============================================================
//  WHAT GOES HERE
//  Load a user profile + their posts.
//  Follow / unfollow toggle.
//  Edit-profile form state when viewing own profile.
//  Inject UserRepository + PostRepository via constructor.
// ============================================================

import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/post_model.dart';

class ProfileController extends GetxController {
  final profileUser = Rxn<UserModel>();
  final userPosts   = <PostModel>[].obs;
  final isLoading   = false.obs;
  final isFollowing = false.obs;

  Future<void> loadProfile(String userId) async {
    isLoading.value = true;
    // TODO: profileUser.value = await userRepo.getUser(userId)
    // TODO: userPosts.assignAll(await postRepo.getUserPosts(userId))
    isLoading.value = false;
  }

  Future<void> toggleFollow() async {
    isFollowing.toggle();
    // TODO: call UserRepository.followUser / unfollowUser
  }
}
