import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/routes/app_routes.dart';

class ViewStoryView extends StatefulWidget {
  const ViewStoryView({super.key});

  @override
  State<ViewStoryView> createState() => _ViewStoryViewState();
}

class _ViewStoryViewState extends State<ViewStoryView>
    with SingleTickerProviderStateMixin {
  bool isFollowing = false;
  bool isLiked = false;

  double _dragOffset = 0;
  static const double _dragThreshold = 80;

  late List<StoryModel> allStories;
  late int currentIndex;

  late AnimationController _progressController;
  static const Duration _storyDuration = Duration(seconds: 5);

  // ── NEW ──────────────────────────────────────────────
  bool _isPaused = false; // long-press pause
  final FocusNode _messageFocus = FocusNode();
  // ─────────────────────────────────────────────────────

  StoryModel get currentStory => allStories[currentIndex];

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;
    allStories = args['allStories'] as List<StoryModel>;
    final StoryModel passedStory = args['currentStory'] as StoryModel;

    currentIndex = allStories.indexWhere((s) => s.userId == passedStory.userId);
    if (currentIndex == -1) currentIndex = 0;

    _progressController =
        AnimationController(vsync: this, duration: _storyDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _nextStory();
            }
          });

    _progressController.forward();

    // ── NEW: pause timer when keyboard appears ───────────
    _messageFocus.addListener(_onFocusChange);
    // ─────────────────────────────────────────────────────
  }

  // ── NEW ──────────────────────────────────────────────
  void _onFocusChange() {
    if (_messageFocus.hasFocus) {
      _pauseTimer();
    } else {
      _resumeTimer();
    }
  }

  void _pauseTimer() {
    if (_progressController.isAnimating) {
      _progressController.stop();
    }
  }

  void _resumeTimer() {
    // Only resume if not held by long-press AND keyboard is closed
    if (!_isPaused && !_messageFocus.hasFocus) {
      _progressController.forward();
    }
  }
  // ─────────────────────────────────────────────────────

  @override
  void dispose() {
    _messageFocus.removeListener(_onFocusChange); // NEW
    _messageFocus.dispose(); // NEW
    _progressController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (currentIndex < allStories.length - 1) {
      setState(() {
        currentIndex++;
        isLiked = false;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      Get.until((route) => route.isFirst);
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isLiked = false;
      });
    }
    _progressController.reset();
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final story = currentStory;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dy;
        });
        if (_dragOffset.abs() == details.delta.dy.abs()) {
          _progressController.stop();
        }
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset.abs() >= _dragThreshold) {
          Get.back();
        } else {
          setState(() {
            _dragOffset = 0;
          });
          _resumeTimer(); // NEW: use _resumeTimer instead of forward()
        }
      },
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: Scaffold(
          backgroundColor: IGColors.bgDark,
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Image.network(
                    story.mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: Colors.black54),
                  ),
                ),

                // ── Left tap → previous (+ long press pause) ──────────
                Positioned(
                  top: 0,
                  bottom: 80,
                  left: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  child: GestureDetector(
                    onTap: _previousStory,
                    onLongPressStart: (_) {
                      // NEW
                      _isPaused = true;
                      _pauseTimer();
                    },
                    onLongPressEnd: (_) {
                      // NEW
                      _isPaused = false;
                      _resumeTimer();
                    },
                    behavior: HitTestBehavior.translucent,
                  ),
                ),

                // ── Right tap → next (+ long press pause) ─────────────
                Positioned(
                  top: 0,
                  bottom: 80,
                  right: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  child: GestureDetector(
                    onTap: _nextStory,
                    onLongPressStart: (_) {
                      // NEW
                      _isPaused = true;
                      _pauseTimer();
                    },
                    onLongPressEnd: (_) {
                      // NEW
                      _isPaused = false;
                      _resumeTimer();
                    },
                    behavior: HitTestBehavior.translucent,
                  ),
                ),

                // Progress bars
                Positioned(
                  top: 8.h,
                  left: 12.w,
                  right: 12.w,
                  child: Row(
                    children: List.generate(allStories.length, (i) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: _StoryProgressBar(
                            isCurrent: i == currentIndex,
                            isCompleted: i < currentIndex,
                            controller: i == currentIndex
                                ? _progressController
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // User info header
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.publicProfile,
                          arguments: story.userId,
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(story.profileImageUrl),
                      ),
                    ),
                    title: Text(
                      story.userName,
                      style: const TextStyle(color: IGColors.bgLight),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          AppIcons.music,
                          size: 14,
                          color: IGColors.bgLight.withValues(alpha: .6),
                        ),
                        SizedBox(width: 5.w),
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            story.musicTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: IGColors.bgLight.withValues(alpha: .6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      height: 30.h,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isFollowing = !isFollowing;
                          });
                        },
                        child: Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: const TextStyle(color: IGColors.bgLight),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom bar
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _messageFocus, // NEW
                          style: const TextStyle(color: IGColors.bgLight),
                          decoration: InputDecoration(
                            hintText: 'Send message',
                            filled: true,
                            fillColor: Colors.transparent,
                            hintStyle: const TextStyle(color: IGColors.bgLight),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: IGColors.bgLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: IGColors.bgLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        child: Icon(
                          isLiked ? AppIcons.heartFill : AppIcons.heart,
                          color: isLiked ? IGColors.like : IGColors.bgLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(AppIcons.dm, color: IGColors.bgLight),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar({
    required this.isCurrent,
    required this.isCompleted,
    this.controller,
  });

  final bool isCurrent;
  final bool isCompleted;
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) return _bar(1.0);
    if (isCurrent && controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (_, __) => _bar(controller!.value),
      );
    }
    return _bar(0.0);
  }

  Widget _bar(double value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 2.5,
        backgroundColor: IGColors.gray,
        valueColor: const AlwaysStoppedAnimation<Color>(IGColors.bgLight),
      ),
    );
  }
}
