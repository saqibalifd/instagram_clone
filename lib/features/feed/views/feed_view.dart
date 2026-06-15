import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:video_player/video_player.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PageController pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> reels = [
    {
      "username": "john_doe",
      "caption": "Enjoying the beautiful sunset 🌅",
      "likes": "125K",
      'videoUrl':
          "https://iulownxcodnqzlefdavl.supabase.co/storage/v1/object/public/videos/WhatsApp%20Video%202026-06-15%20at%2010.25.11%20AM.mp4",
      "comments": "2.3K",
      "shares": "8.5K",
      "isFollowing": false,
    },
    {
      "username": "flutter_dev",
      "caption": "Building Instagram Clone in Flutter 🚀",
      "likes": "98K",
      'videoUrl':
          "https://iulownxcodnqzlefdavl.supabase.co/storage/v1/object/public/videos/WhatsApp%20Video%202026-06-15%20at%2010.25.16%20AM.mp4",
      "comments": "1.1K",
      "shares": "4.2K",
      "isFollowing": false,
    },
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          return _ReelPage(reel: reels[index], isActive: index == _currentPage);
        },
      ),
    );
  }
}

// ─── Per-reel stateful widget ────────────────────────────────────────────────

class _ReelPage extends StatefulWidget {
  const _ReelPage({required this.reel, required this.isActive});

  final Map<String, dynamic> reel;
  final bool isActive;

  @override
  State<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<_ReelPage> {
  late final CachedVideoPlayerPlus _player;
  bool _initialized = false;
  bool _isLiked = false;
  bool _isFollow = false;
  bool _showPlayIcon = false;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(widget.reel['videoUrl']),
      invalidateCacheIfOlderThan: const Duration(minutes: 69),
    );

    _player.initialize().then((_) {
      if (!mounted) return;
      _player.controller.setLooping(true);
      setState(() => _initialized = true);
      if (widget.isActive) _player.controller.play();
    });
  }

  @override
  void didUpdateWidget(_ReelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_initialized) return;

    if (widget.isActive && !oldWidget.isActive) {
      _player.controller.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _player.controller.pause();
      _player.controller.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_player.controller.value.isPlaying) {
        _player.controller.pause();
        _showPlayIcon = true;
      } else {
        _player.controller.play();
        _showPlayIcon = false;
      }
    });

    // Hide the icon after a short delay when resuming
    if (!_player.controller.value.isPlaying) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showPlayIcon = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Video layer ──────────────────────────────────────────────────────
        GestureDetector(
          onTap: _togglePlayPause,
          child: _initialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _player.controller.value.size.width,
                      height: _player.controller.value.size.height,
                      child: VideoPlayer(_player.controller),
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  ),
                ),
        ),

        // ── Play/Pause overlay icon ──────────────────────────────────────────
        if (_showPlayIcon)
          Center(
            child: AnimatedOpacity(
              opacity: _showPlayIcon ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  _player.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),

        // ── Bottom content ───────────────────────────────────────────────────
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left side
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.publicProfile,
                              arguments: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwcm9maWxlfGVufDB8fDB8fHww',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.reel["username"],
                          style: const TextStyle(
                            color: IGColors.bgLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 30.h,
                          child: OutlinedButton(
                            onPressed: () =>
                                setState(() => _isFollow = !_isFollow),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: IGColors.bgLight),
                            ),
                            child: Text(
                              _isFollow ? "Following" : "Follow",
                              style: const TextStyle(color: IGColors.bgLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.reel["caption"],
                      style: const TextStyle(color: IGColors.bgLight),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Right side actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isLiked = !_isLiked),
                    child: Icon(
                      AppIcons.heartFill,
                      color: _isLiked ? IGColors.like : IGColors.bgLight,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.reel["likes"],
                    style: const TextStyle(color: IGColors.bgLight),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => BottomSheetUtil.show(
                      context,
                      type: IGBottomSheet.comment,
                    ),
                    child: Icon(
                      AppIcons.messageFill,
                      color: IGColors.bgLight,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.reel["comments"],
                    style: const TextStyle(color: IGColors.bgLight),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () => BottomSheetUtil.show(
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
                    ),
                    child: Icon(
                      AppIcons.send,
                      color: IGColors.bgLight,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.reel["shares"],
                    style: const TextStyle(color: IGColors.bgLight),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => BottomSheetUtil.show(
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
                    ),
                    child: Icon(
                      AppIcons.more,
                      color: IGColors.bgLight,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Video progress bar ───────────────────────────────────────────────
        if (_initialized)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _player.controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white12,
              ),
            ),
          ),
      ],
    );
  }
}
