// ============================================================
//  WHAT GOES HERE
//  Main scrollable feed screen.
//  * ListView.builder + Obx for reactive list
//  * Pull-to-refresh -> controller.loadFeed(refresh: true)
//  * Scroll-to-bottom -> controller.loadFeed() for pagination
//  * Uses PostCard from shared_widgets (also used by profile)
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/feed_controller.dart';
import '../widgets/feed_shimmer.dart';
import '../../../shared_widgets/post_card.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) return const FeedShimmer();
        return RefreshIndicator(
          onRefresh: () => controller.loadFeed(refresh: true),
          child: ListView.builder(
            itemCount: controller.posts.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == controller.posts.length) {
                controller.loadFeed();
                return const Center(child: CircularProgressIndicator());
              }
              return PostCard(post: controller.posts[i], onLike: () => controller.likePost(controller.posts[i].id));
            },
          ),
        );
      }),
    );
  }
}
