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

  late List<StoryUserModel> allStories;
  late int currentIndex;

  late AnimationController _progressController;
  static const Duration _storyDuration = Duration(seconds: 5);

  StoryUserModel get currentStory => allStories[currentIndex];

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;
    allStories = args['allStories'] as List<StoryUserModel>;
    final StoryUserModel passedStory = args['currentStory'] as StoryUserModel;

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
  }

  @override
  void dispose() {
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

    return Scaffold(
      backgroundColor: IGColors.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Image.network(
                story.storyImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Colors.black54),
              ),
            ),

            // Left tap → previous
            Positioned(
              top: 0,
              bottom: 80, // leave bottom bar untouched
              left: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: _previousStory,
                behavior: HitTestBehavior.translucent,
              ),
            ),

            Positioned(
              top: 0,
              bottom: 80,
              right: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: _nextStory,
                behavior: HitTestBehavior.translucent,
              ),
            ),

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
                    backgroundImage: NetworkImage(story.profileImage ?? ''),
                  ),
                ),
                title: Text(
                  story.name ?? '',
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
                        story.songTitle ?? '',
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

            Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: IGColors.bgLight),
                      decoration: InputDecoration(
                        hintText: 'Send message',
                        filled: true,
                        fillColor: Colors.transparent,
                        hintStyle: const TextStyle(color: IGColors.bgLight),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: IGColors.bgLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: IGColors.bgLight),
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
