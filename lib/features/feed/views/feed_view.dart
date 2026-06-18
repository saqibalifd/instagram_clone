import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/chached_video_manager.dart';
import 'package:video_player/video_player.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PageController pageController = PageController();
  int currentIndex = 0;
  bool isLiked = false;
  bool isFollow = false;

  List<VideoPlayerController?> controllers = [];
  List<bool> initialized = [];

  final List<Map<String, dynamic>> reels = [
    {
      "username": "john_doe",
      "caption": "Enjoying the beautiful sunset 🌅",
      "likes": "125K",
      'videoUrl':
          "https://iulownxcodnqzlefdavl.supabase.co/storage/v1/object/public/videos/WhatsApp%20Video%202026-06-15%20at%2010.25.11%20AM.mp4",
      "comments": "2.3K",
      "shares": "8.5K",
    },
    {
      "username": "flutter_dev",
      "caption": "Building Instagram Clone in Flutter 🚀",
      "likes": "98K",
      'videoUrl':
          "https://iulownxcodnqzlefdavl.supabase.co/storage/v1/object/public/videos/WhatsApp%20Video%202026-06-15%20at%2010.25.16%20AM.mp4",
      "comments": "1.1K",
      "shares": "4.2K",
    },
  ];

  @override
  void initState() {
    super.initState();
    controllers = List.filled(reels.length, null);
    initialized = List.filled(reels.length, false);
    _initVideo(0);
    _preloadVideo(1);
  }

  Future<void> _preloadVideo(int index) async {
    if (index >= reels.length || initialized[index]) return;
    await _initVideo(index);
  }

  void _onPageChanged(int index) {
    controllers[currentIndex]?.pause();
    currentIndex = index;

    if (initialized[index]) {
      controllers[index]?.play();
    } else {
      _initVideo(index);
    }

    _preloadVideo(index + 1);
    setState(() {});
  }

  Future<void> _initVideo(int index) async {
    if (initialized[index]) return;

    final controller = await CachedVideoManager.getController(
      reels[index]['videoUrl'],
    );

    await controller.initialize();
    controller.setLooping(true);

    if (!mounted) return;

    setState(() {
      controllers[index] = controller;
      initialized[index] = true;
    });

    if (index == currentIndex) {
      controller.play();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    for (final c in controllers) {
      c?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (value) => _onPageChanged(value),
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];
          final ctrl = controllers[index];
          final isReady =
              initialized[index] && ctrl != null && ctrl.value.isInitialized;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: double.maxFinite,
                color: IGColors.bgDark,
                child: Center(
                  child: isReady
                      ? AspectRatio(
                          aspectRatio: ctrl!.value.aspectRatio,
                          child: VideoPlayer(ctrl),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                ),
              ),
              GestureDetector(
                onDoubleTap: () => setState(() => isLiked = !isLiked),
                onTap: () {
                  if (!isReady) return;
                  setState(() {
                    ctrl!.value.isPlaying ? ctrl.pause() : ctrl.play();
                  });
                },
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.transparent,
                  child: Center(
                    child: isReady && !ctrl!.value.isPlaying
                        ? Icon(
                            AppIcons.playButton,
                            color: IGColors.bgLight.withValues(alpha: 0.5),
                            size: 80,
                          )
                        : null,
                  ),
                ),
              ),

              /// Bottom Content
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Left Side
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
                                reel["username"],
                                style: const TextStyle(
                                  color: IGColors.bgLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 30.h,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFollow = !isFollow;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: IGColors.bgLight,
                                    ),
                                  ),
                                  child: Text(
                                    isFollow ? "Following" : "Follow",
                                    style: const TextStyle(
                                      color: IGColors.bgLight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            reel["caption"],
                            style: const TextStyle(color: IGColors.bgLight),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// Right Side Actions
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: Icon(
                            AppIcons.heartFill,
                            color: isLiked ? IGColors.like : IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["likes"],
                          style: const TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            BottomSheetUtil.show(
                              context,
                              type: IGBottomSheet.comment,
                            );
                          },
                          child: Icon(
                            AppIcons.messageFill,
                            color: IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["comments"],
                          style: const TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        InkWell(
                          onTap: () {
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
                          child: Icon(
                            AppIcons.send,
                            color: IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["shares"],
                          style: const TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
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
                                  onTap: () => {},
                                ),
                                IGMoreAction(
                                  icon: AppIcons.copy,
                                  label: 'Copy link',
                                  onTap: () {},
                                ),
                              ],
                            );
                          },
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
            ],
          );
        },
      ),
    );
  }
}
