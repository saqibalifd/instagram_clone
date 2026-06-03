// ============================================================
//  WHAT GOES HERE
//  Profile screen: avatar, bio, follower counts, post grid.
//  Reads userId from Get.parameters["userId"] (route param).
//  Follow button visible only when viewing another user.
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../shared_widgets/user_avatar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.loadProfile(Get.parameters["userId"] ?? ""));
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        final user = controller.profileUser.value;
        if (user == null) return const Center(child: Text("User not found"));
        return Column(children: [
          UserAvatar(imageUrl: user.avatarUrl, fallbackInitial: user.username),
          Text(user.username, style: Theme.of(context).textTheme.titleLarge),
          // TODO: StatChip row (posts, followers, following)
          // TODO: Follow / Edit Profile button
          // TODO: GridView of user posts
        ]);
      }),
    );
  }
}
