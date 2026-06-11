import 'package:hive/hive.dart';
import '../models/post_model.dart';

class FavoritePostService {
  static const String boxName = 'favorite_posts';

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  /// Add Post
  static Future<void> addToFavorites(PostModel post) async {
    await _box.put(post.postId, post.toJson());
  }

  /// Remove Post
  static Future<void> removeFromFavorites(String postId) async {
    await _box.delete(postId);
  }

  /// Check Favorite
  static bool isFavorite(String postId) {
    return _box.containsKey(postId);
  }

  /// Get Single Post
  static PostModel? getPost(String postId) {
    final data = _box.get(postId);

    if (data == null) return null;

    return PostModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// Get All Favorite Posts
  static List<PostModel> getFavorites() {
    return _box.values
        .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Clear All
  static Future<void> clearFavorites() async {
    await _box.clear();
  }
}
