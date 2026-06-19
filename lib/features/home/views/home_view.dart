import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/controllers/stories_controller.dart';
import 'package:instagram/controllers/suggested_user_controller.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/features/home/widgets/my_storie_circle_widget.dart';
import 'package:instagram/features/home/widgets/posts_card_widget.dart';
import 'package:instagram/features/home/widgets/stories_circle_widget.dart';
import 'package:instagram/features/home/widgets/suggested_card_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/image_picker_util.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? image;

  final PostsController postsController = Get.put(PostsController());
  final SuggestedUserController _suggestedUserController = Get.put(
    SuggestedUserController(),
  );
  StoriesController storiesController = Get.put(StoriesController());

  late File slectedStory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postsController.allPostsList();
    storiesController.fetchAllStories();
    storiesController.fetchMyStory();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: IGColors.bgLight,

      body: RefreshIndicator(
        onRefresh: () async {
          await postsController.fetchAllPosts();
          await storiesController.fetchMyStory();
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
                              onTap: () {},
                            ),
                            IGAddPostAction(
                              icon: AppIcons.live,
                              label: 'Live',
                              subtitle:
                                  'Go live and connect with your followers in real time',
                              onTap: () {},
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
                Obx(() {
                  if (storiesController.allStoryList.isEmpty) {
                    return SizedBox();
                  }
                  if (storiesController.isLoading == true) {
                    return SizedBox();
                  }
                  return SizedBox(
                    height: 110.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: storiesController.allStoryList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: MyStorieCircleWidget(
                              imageUrl:
                                  storiesController.allStoryList.first.mediaUrl,
                              onStoryTap: () {
                                Get.toNamed(
                                  AppRoutes.viewStory,
                                  arguments: {
                                    'currentStory':
                                        storiesController.allStoryList[1],
                                    'allStories':
                                        storiesController.allStoryList,
                                  },
                                );
                              },
                              onAddStory: () async {
                                // print('add story');
                                final File? pickedImage =
                                    await ImagePickerUtil.pickFromGallery(
                                      context,
                                      maxWidth: 1024,
                                      imageQuality: 85,
                                    );

                                if (pickedImage != null) {
                                  setState(() {
                                    slectedStory = pickedImage;
                                  });
                                }
                              },
                            ),
                          );
                        }
                        final story = storiesController.allStoryList[index - 1];

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: StoriesCircleWidget(
                            onStoryTap: () {
                              Get.toNamed(
                                AppRoutes.viewStory,
                                arguments: {
                                  'currentStory':
                                      storiesController.allStoryList[1],
                                  'allStories': storiesController.allStoryList,
                                },
                              );
                            },
                            imageUrl: story.mediaUrl,
                            name: story.userName.toString().length > 10
                                ? '${story.userName.toString().substring(0, 10)}...'
                                : story.userName.toString(),
                            isPlayed: story.isHighlighted,
                          ),
                        );
                      },
                    ),
                  );
                }),
                Obx(() {
                  if (_suggestedUserController.suggestedUsersList.isEmpty) {
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
                          itemCount: _suggestedUserController
                              .suggestedUsersList
                              .length,
                          scrollDirection: Axis.horizontal,

                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemBuilder: (context, index) {
                            final suggestedUsers = _suggestedUserController
                                .suggestedUsersList[index];
                            return SuggestedCardWidget(
                              onCancel: () {
                                _suggestedUserController.skipUser(index);
                              },
                              onFollow: () {
                                _suggestedUserController.followUser(
                                  suggestedUsers.userId,
                                );
                                _suggestedUserController.skipUser(index);
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
                    return CircularProgressIndicator();
                  }
                  if (postsController.allPostsList.isEmpty) {
                    return Center(child: Text('No posts'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postsController.allPostsList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return PostsCardWidget(
                        postModel: postsController.allPostsList[index],
                        mediaType:
                            postsController.allPostsList[index].mediaType,
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
