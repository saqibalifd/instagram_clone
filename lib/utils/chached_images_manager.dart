import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';

class CachedImageManager {
  // Shared custom cache manager — passed to every CachedNetworkImage
  static final CacheManager cacheManager = CacheManager(
    Config(
      'instagram_images_cache',
      stalePeriod: const Duration(days: 14),
      maxNrOfCacheObjects: 200,
    ),
  );

  static Widget image({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: cacheManager, // use our shared config
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? const _ShimmerBox(),
      errorWidget: (context, url, error) =>
          errorWidget ??
          const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }

  /// Pre-warms the cache for a list of URLs (e.g. prefetch next page).
  static Future<void> prefetch(List<String> urls) =>
      Future.wait(urls.map((u) => cacheManager.downloadFile(u)));

  static Future<void> clearCache() => cacheManager.emptyCache();
}

// ── Shimmer placeholder ────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox();
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) =>
          Container(color: Colors.grey.withOpacity(_anim.value)),
    );
  }
}
