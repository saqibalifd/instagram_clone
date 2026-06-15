import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class CachedVideoManager {
  // Singleton cache manager with custom config
  static final CacheManager _cacheManager = CacheManager(
    Config(
      'instagram_reels_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20, // Keep max 20 videos cached
    ),
  );

  static CacheManager get instance => _cacheManager;

  /// Returns a VideoPlayerController using cached file if available,
  /// otherwise streams from network and caches simultaneously.
  static Future<VideoPlayerController> getController(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo != null && await fileInfo.file.exists()) {
      // ✅ Cache HIT — play from local file
      return VideoPlayerController.file(fileInfo.file);
    } else {
      // ❌ Cache MISS — download + cache in background, stream from network
      _cacheManager.downloadFile(url); // fire-and-forget cache population
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }
  }

  static Future<void> clearCache() => _cacheManager.emptyCache();
}
