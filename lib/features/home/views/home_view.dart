import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/controllers/stories_controller.dart';
import 'package:instagram/controllers/user_controller.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/features/home/widgets/my_storie_circle_widget.dart';

import 'package:instagram/shared_widgets/posts_card_widget.dart';
import 'package:instagram/features/home/widgets/stories_circle_widget.dart';
import 'package:instagram/features/home/widgets/suggested_card_widget.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/custom_toast_util.dart';
import 'package:instagram/utils/image_picker_util.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? image;

  final PostsController postsController = Get.put(PostsController());
  final UserController _userController = Get.put(UserController());
  StoriesController storiesController = Get.put(StoriesController());
  final ProfileController profileController = Get.put(ProfileController());

  late File slectedStory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postsController.allPostsList();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: IGColors.bgLight,

      body: RefreshIndicator(
        onRefresh: () async {
          await postsController.fetchAllPosts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      color: IGColors.bgDark,
                      highlightColor: Colors.transparent,
                      iconSize: 35,

                      onPressed: () {
                        BottomSheetUtil.show(
                          context,
                          type: IGBottomSheet.addPost,
                          addPostActions: [
                            IGAddPostAction(
                              icon: AppIcons.grid,
                              label: 'Post',
                              subtitle:
                                  'Share a photo or video to your profile',
                              onTap: () {
                                Get.toNamed(AppRoutes.addPost);
                              },
                            ),
                            IGAddPostAction(
                              icon: AppIcons.reels,
                              label: 'Reel',
                              subtitle: 'Create and share a short video',
                              onTap: () {
                                Get.toNamed(AppRoutes.stories);
                              },
                            ),
                            IGAddPostAction(
                              icon: AppIcons.stories,
                              label: 'Story',
                              subtitle:
                                  'Share a photo or video that disappears in 24 hours',
                              onTap: () async {
                                final file = await ImagePickerUtil.pick(
                                  context,
                                  maxWidth: 1024,
                                  imageQuality: 85,
                                );
                                if (file != null) setState(() => image = file);
                                if (image != null) {
                                  await storiesController.addStory(
                                    context,
                                    image,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                      icon: Icon(AppIcons.add),
                    ),
                    Spacer(),
                    Text(
                      'Instagram',
                      style: GoogleFonts.grandHotel(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: IGColors.bgDark,
                      iconSize: 30,
                      onPressed: () {
                        Get.toNamed(AppRoutes.notification);
                      },
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(AppIcons.heart),

                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: IGColors.like,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 4,
                                minHeight: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: AppConstants.horizontalSmallPadding),
                      MyStorieCircleWidget(
                        imageUrl: profileController
                            .profileUser
                            .value!
                            .profileImageUrl,
                        onStoryTap: () {
                          Get.toNamed(
                            AppRoutes.viewStory,
                            arguments:
                                profileController.profileUser.value!.userId,
                          );
                        },
                        onAddStory: () async {
                          final file = await ImagePickerUtil.pick(
                            context,
                            maxWidth: 1024,
                            imageQuality: 85,
                          );
                          if (file != null) setState(() => image = file);
                          if (image != null) {
                            await storiesController.addStory(context, image);
                          }
                        },
                      ),

                      Obx(() {
                        if (_userController.friendsUsers.isEmpty) {
                          return SizedBox();
                        }
                        if (_userController.isLoading == true) {
                          return SizedBox();
                        }
                        return SizedBox(
                          height: 110.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _userController.friendsUsers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final frieds =
                                  _userController.friendsUsers[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: StoriesCircleWidget(
                                  imageUrl: frieds.profileImageUrl,
                                  name: frieds.fullName,
                                  isPlayed: false,
                                  onStoryTap: () {
                                    Get.toNamed(
                                      AppRoutes.viewStory,
                                      arguments: frieds.userId,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                Obx(() {
                  if (_userController.suggestedUsersList.isEmpty) {
                    return SizedBox();
                  }
                  if (_userController.isLoading == true) {
                    return SizedBox();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Text(
                          'Discover people',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 245.h,
                        child: ListView.builder(
                          itemCount: _userController.suggestedUsersList.length,
                          scrollDirection: Axis.horizontal,

                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemBuilder: (context, index) {
                            final suggestedUsers =
                                _userController.suggestedUsersList[index];
                            return SuggestedCardWidget(
                              onCancel: () {
                                _userController.skipUser(index);
                              },
                              onFollow: () async {
                                await _userController.followUser(
                                  suggestedUsers.userId,
                                );
                                _userController.skipUser(index);
                              },
                              name: suggestedUsers.fullName,

                              image: suggestedUsers.profileImageUrl,

                              userId: suggestedUsers.userId,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: 8.h),

                Obx(() {
                  if (postsController.isLoading.value) {
                    return SizedBox();
                  }
                  if (postsController.allPostsList.isEmpty) {
                    return SizedBox();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postsController.allPostsList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return VisibilityDetector(
                        key: Key(postsController.allPostsList[index].postId),
                        onVisibilityChanged: (info) {
                          postsController.onPostVisibilityChanged(
                            postId: postsController.allPostsList[index].postId,
                            visibleFraction: info.visibleFraction,
                          );
                        },
                        child: PostsCardWidget(
                          postModel: postsController.allPostsList[index],
                          mediaType:
                              postsController.allPostsList[index].mediaType,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
