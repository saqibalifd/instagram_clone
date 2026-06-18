import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/story_border_wraper_widget.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class PublicProfileHeaderWidget extends StatefulWidget {
  final String image;
  final String name;
  final int totalPosts;
  final int followersCount;
  final int followingCount;
  final String bio;
  final VoidCallback onTap;

  const PublicProfileHeaderWidget({
    super.key,
    required this.image,
    required this.name,
    required this.totalPosts,
    required this.followersCount,
    required this.followingCount,
    required this.bio,
    required this.onTap,
  });

  @override
  State<PublicProfileHeaderWidget> createState() =>
      _PublicProfileHeaderWidgetState();
}

class _PublicProfileHeaderWidgetState extends State<PublicProfileHeaderWidget> {
  bool isStoryAvailable = true;
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
  ];
  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalSmallPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.viewStory,
                    arguments: {
                      'currentStory': storiesUsers[0],
                      'allStories': storiesUsers,
                    },
                  );
                },
                child: StoryBorderWrapper(
                  isActive: true,
                  child: Container(
                    width: 70.r,
                    height: 70.r,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: CachedImageManager.image(
                        url: widget.image,
                        fit: BoxFit.cover,
                        errorWidget: CircleAvatar(
                          backgroundColor: IGColors.gray.withValues(alpha: .3),
                          child: Icon(
                            AppIcons.profile,
                            color: IGColors.bgLight,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: ts.titleLarge),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),

                            Text(
                              widget.totalPosts.toString(),
                              style: ts.titleLarge,
                            ),
                            Text('Posts'),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.allFollow),
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),

                              Text(
                                widget.followersCount.toString(),
                                style: ts.titleLarge,
                              ),
                              Text('followers'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),

                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.allFollow),

                        child: GestureDetector(
                          onTap: widget.onTap,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),

                              Text(
                                widget.followingCount.toString(),
                                style: ts.titleLarge,
                              ),
                              Text('following'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(widget.name, style: ts.titleLarge),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height: 5.h),
              //         Text(widget.totalPosts.toString(), style: ts.titleLarge),
              //         Text('posts'),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.start,
            widget.bio,
            style: ts.bodyMedium,
          ),
        ],
      ),
    );
  }
}
