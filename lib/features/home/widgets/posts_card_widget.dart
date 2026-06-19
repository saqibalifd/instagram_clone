import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/favourite_post_services.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/chached_images_manager.dart';
import 'package:instagram/utils/chached_video_manager.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsCardWidget extends StatefulWidget {
  final PostModel postModel;
  final String mediaType;

  const PostsCardWidget({
    super.key,
    required this.postModel,
    required this.mediaType,
  });

  @override
  State<PostsCardWidget> createState() => _PostsCardWidgetState();
}

class _PostsCardWidgetState extends State<PostsCardWidget> {
  bool isLiked = false;
  bool isFav = false;

  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _isPlaying = false;

  final TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    isFav = FavoritePostService.isFavorite(widget.postModel.postId);
    if (widget.mediaType == 'video') {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final controller = await CachedVideoManager.getController(
      widget.postModel.mediaUrl,
    );
    await controller.initialize();
    if (mounted) {
      setState(() {
        _videoController = controller;
        _videoInitialized = true;
      });
    }
  }

  void _resetZoom() {
    _controller.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.publicProfile,
                    arguments: widget.postModel.userId,
                  );
                },
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.r),
                    child: CachedImageManager.image(
                      url: widget.postModel.profileImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: CircleAvatar(
                        backgroundColor: IGColors.gray.withValues(alpha: .3),
                        child: Icon(AppIcons.profile, color: IGColors.bgLight),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.userName,
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      widget.postModel.location,
                      style: ts.bodySmall!.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.more,
                    moreActions: [
                      IGMoreAction(
                        icon: AppIcons.flag,
                        label: 'Report',
                        color: IGColors.like,
                        onTap: () {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.hidePost,
                        label: 'Hide post',
                        onTap: () {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.personRemove,
                        label: 'Unfollow',
                        onTap: () {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.copy,
                        label: 'Copy link',
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: Icon(AppIcons.more),
              ),
            ],
          ),
        ),

        // Post media
        SizedBox(
          width: double.maxFinite,
          height: 510.h,
          child: VisibilityDetector(
            key: Key('post-${widget.postModel.postId}'),
            onVisibilityChanged: (VisibilityInfo info) {
              if (widget.mediaType != 'video' ||
                  !_videoInitialized ||
                  _videoController == null ||
                  !mounted) {
                return;
              }

              final visibleFraction = info.visibleFraction;

              if (visibleFraction > 0.65) {
                // Mostly in view -> play
                if (!_videoController!.value.isPlaying) {
                  _videoController!.play();
                  setState(() => _isPlaying = true);
                }
              } else {
                // Scrolled away -> pause
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                  setState(() => _isPlaying = false);
                }
              }
            },
            child: ClipRRect(
              child: widget.mediaType == 'video'
                  ? _videoInitialized && _videoController != null
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                  _isPlaying = false;
                                } else {
                                  _videoController!.play();
                                  _isPlaying = true;
                                }
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 20,
                                  child: VideoPlayer(_videoController!),
                                ),
                                AnimatedOpacity(
                                  opacity: _isPlaying ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Center(child: CircularProgressIndicator())
                  : InteractiveViewer(
                      panEnabled: false,
                      minScale: 1.0,
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(20),
                      clipBehavior: Clip.hardEdge,
                      child: CachedImageManager.image(
                        url: widget.postModel.mediaUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Like button
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  setState(() => isLiked = !isLiked);
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      isLiked ? AppIcons.heartFill : AppIcons.heart,
                      color: isLiked ? IGColors.like : IGColors.bgDark,
                      size: 29,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      widget.postModel.likes.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              SizedBox(width: 8.w),

              // Comment button
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.comment,
                    comments: [
                      IGComment(
                        user: 'alex.doe',
                        text: 'Amazing shot! 🔥',
                        time: '2h',
                      ),
                      IGComment(
                        user: 'sara_m',
                        text: 'Love this so much ❤️',
                        time: '1h',
                      ),
                      IGComment(
                        user: 'john_travels',
                        text: 'Where was this taken? 😍',
                        time: '45m',
                      ),
                      IGComment(
                        user: 'priya.k',
                        text: 'Absolutely stunning 🌅',
                        time: '30m',
                      ),
                      IGComment(
                        user: 'mike_photos',
                        text: 'The lighting is perfect here!',
                        time: '20m',
                      ),
                      IGComment(user: 'layla99', text: 'Goals 🙌', time: '10m'),
                      IGComment(
                        user: 'dev.omar',
                        text: 'This is my wallpaper now lol',
                        time: '5m',
                      ),
                    ],
                    onCommentSubmit: (text) {
                      // Add comment logic here
                    },
                  );
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.messageCircle),
                    SizedBox(width: 5.w),
                    Text(
                      widget.postModel.comments.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              SizedBox(width: 8.w),

              // Share button
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.share,
                    shareOptions: [
                      IGShareOption(
                        icon: Icons.send_outlined,
                        label: 'Send in DM',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.add_circle_outline,
                        label: 'Add to Story',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.link,
                        label: 'Copy link',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.bookmark_border,
                        label: 'Save post',
                        onTap: () {},
                      ),
                    ],
                  );
                },
                icon: Row(
                  children: [
                    Icon(AppIcons.dm, color: IGColors.bgDark, size: 29),
                    SizedBox(width: 5.w),
                  ],
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const Spacer(),

              // Favorite button
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  if (!isFav) {
                    await FavoritePostService.addToFavorites(widget.postModel);
                    setState(() => isFav = true);
                    CustomToastUtil.showDefault(
                      context,
                      message: 'Post added to favorites',
                    );
                  } else {
                    await FavoritePostService.removeFromFavorites(
                      widget.postModel.postId,
                    );
                    setState(() => isFav = false);
                    CustomToastUtil.showDefault(
                      context,
                      message: 'Post removed from favorites',
                    );
                  }
                },
                icon: Icon(
                  isFav ? AppIcons.favoriteFill : AppIcons.favorite,
                  color: IGColors.bgDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Likes & caption
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.postModel.userName} ',
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ReadMoreText(
                        widget.postModel.caption,
                        trimMode: TrimMode.Line,
                        trimLines: 2,
                        trimCollapsedText: ' more',
                        trimExpandedText: ' less',
                        colorClickableText: IGColors.bgDark,
                        style: ts.bodyMedium!.copyWith(fontSize: 13.sp),
                        moreStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        lessStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '5 min ago',
                style: ts.bodySmall!.copyWith(
                  fontSize: 13.sp,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),
      ],
    );
  }
}
