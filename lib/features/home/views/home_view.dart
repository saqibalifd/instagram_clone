import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/features/home/controllers/posts_controller.dart';
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
  final List<StoryUserModel> storiesUsers = [
    StoryUserModel(
      name: 'Ali',
      profileImage: 'https://i.pravatar.cc/150?img=1',
      storyImage:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      songTitle: 'Blinding Lights • The Weeknd',
      timeAgo: '5m ago',
      isPlayed: false,
      userId: 'user_001',
    ),
    StoryUserModel(
      name: 'Iftikhar Ali',
      profileImage: 'https://i.pravatar.cc/150?img=2',
      storyImage:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
      songTitle: 'Calm Down • Rema',
      timeAgo: '15m ago',
      isPlayed: false,
      userId: 'user_002',
    ),
    StoryUserModel(
      name: 'Jamshed Hussain Alvi',
      profileImage: 'https://i.pravatar.cc/150?img=3',
      storyImage:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
      songTitle: 'Perfect • Ed Sheeran',
      timeAgo: '30m ago',
      isPlayed: false,
      userId: 'user_003',
    ),
    StoryUserModel(
      name: 'Fakhar Hussain',
      profileImage: 'https://i.pravatar.cc/150?img=4',
      storyImage:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?w=800',
      songTitle: 'Starboy • The Weeknd',
      timeAgo: '1h ago',
      isPlayed: false,
      userId: 'user_004',
    ),
    StoryUserModel(
      name: 'Hassan Ali',
      profileImage: 'https://i.pravatar.cc/150?img=5',
      storyImage:
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
      songTitle: 'Shape of You • Ed Sheeran',
      timeAgo: '2h ago',
      isPlayed: true,
      userId: 'user_005',
    ),
    StoryUserModel(
      name: 'Usman Khan',
      profileImage: 'https://i.pravatar.cc/150?img=6',
      storyImage:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
      songTitle: 'Until I Found You • Stephen Sanchez',
      timeAgo: '3h ago',
      isPlayed: false,
      userId: 'user_006',
    ),
    StoryUserModel(
      name: 'Zain Malik',
      profileImage: 'https://i.pravatar.cc/150?img=7',
      storyImage:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
      songTitle: 'Levitating • Dua Lipa',
      timeAgo: '4h ago',
      isPlayed: false,
      userId: 'user_007',
    ),
  ];

  final suggestedPosts = [
    {
      'name': 'Ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=1',
      'mutualFriends': 5,
    },
    {
      'name': 'Nadeem ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=4',
      'mutualFriends': 5,
    },
    {
      'name': 'Iftikhar ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=8',
      'mutualFriends': 5,
    },
  ];

  late File slectedStory;

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: IGColors.bgLight,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            BottomSheetUtil.show(
              context,
              type: IGBottomSheet.addPost,
              addPostActions: [
                IGAddPostAction(
                  icon: AppIcons.grid,
                  label: 'Post',
                  subtitle: 'Share a photo or video to your profile',
                  onTap: () {},
                ),
                IGAddPostAction(
                  icon: AppIcons.reels,
                  label: 'Reel',
                  subtitle: 'Create and share a short video',
                  onTap: () {},
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
        title: Text(
          'Instagram',
          style: GoogleFonts.grandHotel(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storiesUsers.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: MyStorieCircleWidget(
                        imageUrl:
                            'https://img.magnific.com/free-psd/modern-dynamic-banner_125755-403.jpg?semt=ais_hybrid&w=740&q=80',
                        onStoryTap: () {
                          Get.toNamed(
                            AppRoutes.viewStory,
                            arguments: {
                              'currentStory': storiesUsers[index],
                              'allStories': storiesUsers,
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

                  final storyIndex = index - 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: StoriesCircleWidget(
                      onStoryTap: () {
                        Get.toNamed(
                          AppRoutes.viewStory,
                          arguments: {
                            'currentStory': storiesUsers[index],
                            'allStories': storiesUsers,
                          },
                        );
                      },
                      imageUrl: storiesUsers[index].storyImage.toString(),
                      name: storiesUsers[index].name.toString().length > 10
                          ? '${storiesUsers[index].name.toString().substring(0, 10)}...'
                          : storiesUsers[index].name.toString(),
                      isPlayed: storiesUsers[index].isPlayed,
                    ),
                  );
                },
              ),
            ),
            suggestedPosts.isEmpty
                ? SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          'Suggested for you',
                          style: ts.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 240.h,
                        child: ListView.builder(
                          itemCount: suggestedPosts.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemBuilder: (context, index) {
                            return SuggestedCardWidget(
                              onCancel: () {
                                setState(() {
                                  suggestedPosts.removeAt(index);
                                });
                              },
                              onFollow: () {
                                setState(() {
                                  suggestedPosts.removeAt(index);
                                });
                              },
                              name: suggestedPosts[index]['name'].toString(),

                              image: suggestedPosts[index]['imageUrl']
                                  .toString(),

                              totalMutual:
                                  suggestedPosts[index]['mutualFriends'] as int,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

            SizedBox(height: 8.h),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: postsController.posts.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return PostsCardWidget(postModel: postsController.posts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
