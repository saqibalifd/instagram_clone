// ============================================================
//  WHAT GOES HERE
//  Concrete PostRepository — delegates to PostSource,
//  handles pagination cursors, wraps errors.
// ============================================================

import '../../../core/errors/app_exceptions.dart';
import '../../models/post_model.dart';
import '../../sources/post_source.dart';
import '../interfaces/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostSource _source;
  PostRepositoryImpl(this._source);

  @override
  Future<List<PostModel>> getFeedPosts({int limit = 20, String? afterId}) =>
      _source.getFeedPosts(limit: limit, afterId: afterId);

  @override
  Future<PostModel> createPost({required String body, List<String> imageUrls = const []}) =>
      _source.createPost(body: body, imageUrls: imageUrls);

  @override
  Future<void> likePost(String postId)   => _source.likePost(postId, 'currentUserId');
  @override
  Future<void> deletePost(String postId) => _source.deletePost(postId);
}
