// ============================================================
//  WHAT GOES HERE
//  Post-related operations contract.
//  One interface file per domain concept (auth, posts, profile …).
// ============================================================

import '../../models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getFeedPosts({int limit, String? afterId});
  Future<PostModel>       createPost({required String body, List<String> imageUrls});
  Future<void>            likePost(String postId);
  Future<void>            deletePost(String postId);
}
