import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/stories_controller.dart';
import 'package:instagram/controllers/user_controller.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';
import 'package:story_view/story_view.dart';

class ViewStoryView extends StatefulWidget {
  const ViewStoryView({super.key});

  @override
  State<ViewStoryView> createState() => _ViewStoryViewState();
}

class _ViewStoryViewState extends State<ViewStoryView> {
  final StoriesController storiesController = Get.put(StoriesController());
  final StoryController storyController = StoryController();
  final UserController userController = Get.put(UserController());
  bool isLiked = false;
  final FocusNode _messageFocus = FocusNode();
  bool isFollowing = false;

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final String userId = Get.arguments as String;
    storiesController.fetchStoriesByUser(userId);
    userController.fetchUserById(userId);
  }

  @override
  void dispose() {
    storyController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void sendComment() {
    if (commentController.text.trim().isEmpty) return;

    // TODO: Call your API here
    print(commentController.text);

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (storiesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (storiesController.userStoryList.isEmpty) {
          return const Center(child: Text('No stories available'));
        }

        return Stack(
          children: [
            StoryView(
              storyItems: storiesController.userStoryList
                  .map(
                    (story) => StoryItem.pageImage(
                      url: story.mediaUrl,
                      controller: storyController,
                      duration: const Duration(seconds: 5),
                    ),
                  )
                  .toList(),
              controller: storyController,
              repeat: false,
              onComplete: () => Get.back(),
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Get.back();
                }
              },
            ),

            // User info overlay
            Positioned(
              top: 50.h,
              left: 0,
              right: 0,
              child: Obx(() {
                if (userController.specificUserLoading.value) {
                  return SizedBox();
                }
                if (userController.specificUserData.value == null) {
                  return SizedBox();
                }
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.publicProfile,
                        arguments:
                            userController.specificUserData.value!.userId,
                      );
                    },
                    child: Container(
                      width: 45.r,
                      height: 45.r,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: CachedImageManager.image(
                          url: userController
                              .specificUserData
                              .value!
                              .profileImageUrl
                              .toString(),
                          fit: BoxFit.cover,
                          errorWidget: CircleAvatar(
                            backgroundColor: IGColors.gray.withValues(
                              alpha: .3,
                            ),
                            child: Icon(
                              AppIcons.profile,
                              color: IGColors.bgLight,
                              size: 25.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userController.specificUserData.value!.fullName,
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
                          storiesController.userStoryList[0].musicTitle,
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
                );
              }),
            ),

            /// Comment Field
            Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _messageFocus,
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
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:instagram/controllers/stories_controller.dart';
// import 'package:instagram/core/constants/app_icons.dart';
// import 'package:instagram/core/theme/app_theme.dart';
// import 'package:instagram/data/models/stories_model.dart';
// import 'package:instagram/routes/app_routes.dart';

// class ViewStoryView extends StatefulWidget {
//   const ViewStoryView({super.key});

//   @override
//   State<ViewStoryView> createState() => _ViewStoryViewState();
// }

// class _ViewStoryViewState extends State<ViewStoryView>
//     with SingleTickerProviderStateMixin {
//   // ── NEW: real fetching, same controller as ViewStoryView ─────
//   final StoriesController storiesController = Get.put(StoriesController());
//   late final String userId;
//   // ─────────────────────────────────────────────────────────────────

//   bool isFollowing = false;
//   bool isLiked = false;
//   double _dragOffset = 0;
//   static const double _dragThreshold = 80;

//   // Index into storiesController.userStoryList (was an index into a
//   // static `allStories` list passed through Get.arguments before).
//   int currentIndex = 0;

//   late AnimationController _progressController;
//   static const Duration _storyDuration = Duration(seconds: 5);

//   bool _isPaused = false; // long-press pause
//   bool _timerStarted = false; // NEW: start timer only once data has loaded
//   final FocusNode _messageFocus = FocusNode();

//   StoryModel get currentStory => storiesController.userStoryList[currentIndex];

//   @override
//   void initState() {
//     super.initState();

//     // NEW: this screen now receives just the userId whose stories should
//     // be shown, e.g. Get.toNamed(AppRoutes.viewStory, arguments: userId);
//     userId = Get.arguments as String;

//     _progressController =
//         AnimationController(vsync: this, duration: _storyDuration)
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               _nextStory();
//             }
//           });

//     _messageFocus.addListener(_onFocusChange);

//     // NEW: fetch the real stories instead of reading a pre-built list.
//     storiesController.fetchStoriesByUser(userId);
//   }

//   void _onFocusChange() {
//     if (_messageFocus.hasFocus) {
//       _pauseTimer();
//     } else {
//       _resumeTimer();
//     }
//   }

//   void _pauseTimer() {
//     if (_progressController.isAnimating) {
//       _progressController.stop();
//     }
//   }

//   void _resumeTimer() {
//     // Only resume if not held by long-press AND keyboard is closed
//     if (!_isPaused && !_messageFocus.hasFocus) {
//       _progressController.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _messageFocus.removeListener(_onFocusChange);
//     _messageFocus.dispose();
//     _progressController.dispose();
//     super.dispose();
//   }

//   void _nextStory() {
//     final stories = storiesController.userStoryList;
//     if (currentIndex < stories.length - 1) {
//       setState(() {
//         currentIndex++;
//         isLiked = false;
//       });
//       _progressController.reset();
//       _progressController.forward();
//     } else {
//       Get.until((route) => route.isFirst);
//     }
//   }

//   void _previousStory() {
//     final stories = storiesController.userStoryList;
//     if (currentIndex > 0) {
//       setState(() {
//         currentIndex--;
//         isLiked = false;
//       });
//     }
//     _progressController.reset();
//     _progressController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {
//         setState(() {
//           _dragOffset += details.delta.dy;
//         });
//         if (_dragOffset.abs() == details.delta.dy.abs()) {
//           _progressController.stop();
//         }
//       },
//       onVerticalDragEnd: (details) {
//         if (_dragOffset.abs() >= _dragThreshold) {
//           Get.back();
//         } else {
//           setState(() {
//             _dragOffset = 0;
//           });
//           _resumeTimer();
//         }
//       },
//       child: Transform.translate(
//         offset: Offset(0, _dragOffset),
//         child: Scaffold(
//           backgroundColor: IGColors.bgDark,
//           body: SafeArea(
//             // NEW: Obx rebuilds reactively as storiesController.userStoryList
//             // / isLoading change, instead of reading a static list once.
//             child: Obx(() {
//               final stories = storiesController.userStoryList;

//               if (stories.isEmpty && storiesController.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: IGColors.bgLight),
//                 );
//               }

//               if (stories.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No stories',
//                     style: TextStyle(color: IGColors.bgLight),
//                   ),
//                 );
//               }

//               if (currentIndex >= stories.length) {
//                 currentIndex = stories.length - 1;
//               }

//               // Start the progress timer the first time stories finish loading.
//               if (!_timerStarted) {
//                 _timerStarted = true;
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (mounted) _progressController.forward(from: 0);
//                 });
//               }

//               final story = stories[currentIndex];

//               return Stack(
//                 children: [
//                   SizedBox(
//                     height: double.maxFinite,
//                     width: double.maxFinite,
//                     child: Image.network(
//                       story.mediaUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                           const ColoredBox(color: Colors.black54),
//                     ),
//                   ),

//                   // Left tap → previous (+ long press pause)
//                   Positioned(
//                     top: 0,
//                     bottom: 80,
//                     left: 0,
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: GestureDetector(
//                       onTap: _previousStory,
//                       onLongPressStart: (_) {
//                         _isPaused = true;
//                         _pauseTimer();
//                       },
//                       onLongPressEnd: (_) {
//                         _isPaused = false;
//                         _resumeTimer();
//                       },
//                       behavior: HitTestBehavior.translucent,
//                     ),
//                   ),

//                   // Right tap → next (+ long press pause)
//                   Positioned(
//                     top: 0,
//                     bottom: 80,
//                     right: 0,
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: GestureDetector(
//                       onTap: _nextStory,
//                       onLongPressStart: (_) {
//                         _isPaused = true;
//                         _pauseTimer();
//                       },
//                       onLongPressEnd: (_) {
//                         _isPaused = false;
//                         _resumeTimer();
//                       },
//                       behavior: HitTestBehavior.translucent,
//                     ),
//                   ),

//                   // Progress bars
//                   Positioned(
//                     top: 8.h,
//                     left: 12.w,
//                     right: 12.w,
//                     child: Row(
//                       children: List.generate(stories.length, (i) {
//                         return Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 2.w),
//                             child: _StoryProgressBar(
//                               isCurrent: i == currentIndex,
//                               isCompleted: i < currentIndex,
//                               controller: i == currentIndex
//                                   ? _progressController
//                                   : null,
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),

//                   // User info header
//                   Positioned(
//                     top: 20.h,
//                     left: 0,
//                     right: 0,
//                     child: ListTile(
//                       leading: GestureDetector(
//                         onTap: () {
//                           Get.toNamed(
//                             AppRoutes.publicProfile,
//                             arguments: story.userId,
//                           );
//                         },
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(story.profileImageUrl),
//                         ),
//                       ),
//                       title: Text(
//                         story.userName,
//                         style: const TextStyle(color: IGColors.bgLight),
//                       ),
//                       subtitle: Row(
//                         children: [
//                           Icon(
//                             AppIcons.music,
//                             size: 14,
//                             color: IGColors.bgLight.withValues(alpha: .6),
//                           ),
//                           SizedBox(width: 5.w),
//                           SizedBox(
//                             width: 120.w,
//                             child: Text(
//                               story.musicTitle,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: TextStyle(
//                                 color: IGColors.bgLight.withValues(alpha: .6),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: SizedBox(
//                         height: 30.h,
//                         child: OutlinedButton(
//                           onPressed: () {
//                             setState(() {
//                               isFollowing = !isFollowing;
//                             });
//                           },
//                           child: Text(
//                             isFollowing ? 'Following' : 'Follow',
//                             style: const TextStyle(color: IGColors.bgLight),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Bottom bar
//                   Positioned(
//                     left: 10,
//                     right: 10,
//                     bottom: 20,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             focusNode: _messageFocus,
//                             style: const TextStyle(color: IGColors.bgLight),
//                             decoration: InputDecoration(
//                               hintText: 'Send message',
//                               filled: true,
//                               fillColor: Colors.transparent,
//                               hintStyle: const TextStyle(
//                                 color: IGColors.bgLight,
//                               ),
//                               border: const OutlineInputBorder(),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: const BorderSide(
//                                   color: IGColors.bgLight,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: const BorderSide(
//                                   color: IGColors.bgLight,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isLiked = !isLiked;
//                             });
//                           },
//                           child: Icon(
//                             isLiked ? AppIcons.heartFill : AppIcons.heart,
//                             color: isLiked ? IGColors.like : IGColors.bgLight,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Icon(AppIcons.dm, color: IGColors.bgLight),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StoryProgressBar extends StatelessWidget {
//   const _StoryProgressBar({
//     required this.isCurrent,
//     required this.isCompleted,
//     this.controller,
//   });

//   final bool isCurrent;
//   final bool isCompleted;
//   final AnimationController? controller;

//   @override
//   Widget build(BuildContext context) {
//     if (isCompleted) return _bar(1.0);
//     if (isCurrent && controller != null) {
//       return AnimatedBuilder(
//         animation: controller!,
//         builder: (_, __) => _bar(controller!.value),
//       );
//     }
//     return _bar(0.0);
//   }

//   Widget _bar(double value) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(2),
//       child: LinearProgressIndicator(
//         value: value,
//         minHeight: 2.5,
//         backgroundColor: IGColors.gray,
//         valueColor: const AlwaysStoppedAnimation<Color>(IGColors.bgLight),
//       ),
//     );
//   }
// }
