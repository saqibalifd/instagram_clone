// // ============================================================
// //  WHAT GOES HERE
// //  Feed pagination, pull-to-refresh, like toggling.
// //  Talks to PostRepository — never PostSource directly.
// //  State: posts list, isLoading flag, hasMore flag.
// // ============================================================

// import 'package:get/get.dart';
// import '../../../data/models/post_model.dart';
// import '../../../data/repositories/interfaces/post_repository.dart';

// class FeedController extends GetxController {
//   final PostRepository _repo;
//   FeedController(this._repo);

//   final posts     = <PostModel>[].obs;
//   final isLoading = false.obs;
//   final hasMore   = true.obs;

//   @override void onInit() { super.onInit(); loadFeed(); }

//   Future<void> loadFeed({bool refresh = false}) async {
//     if (refresh) posts.clear();
//     isLoading.value = true;
//     try {
//       final batch = await _repo.getFeedPosts(limit: 20, afterId: refresh ? null : posts.lastOrNull?.id);
//       posts.addAll(batch);
//       hasMore.value = batch.length == 20;
//     } finally { isLoading.value = false; }
//   }

//   Future<void> likePost(String postId) => _repo.likePost(postId);
// }
