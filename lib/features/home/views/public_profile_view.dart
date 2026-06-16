import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/suggested_user_controller.dart';

import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/home/controllers/public_profile_controller.dart';
import 'package:instagram/features/home/views/public_profile_tabview.dart';
import 'package:instagram/features/home/widgets/public_profile_header_widget.dart';
import 'package:instagram/routes/app_routes.dart';

class PublicProfileView extends StatefulWidget {
  const PublicProfileView({super.key});

  @override
  State<PublicProfileView> createState() => _PublicProfileViewState();
}

class _PublicProfileViewState extends State<PublicProfileView>
    with TickerProviderStateMixin {
  late TabController tabController;
  late String userId = '';

  final PublicProfileController publicProfileController = Get.put(
    PublicProfileController(),
  );
  SuggestedUserController suggestedUserController = Get.put(
    SuggestedUserController(),
  );
  final List dummyPosts = [];

  @override
  void initState() {
    super.initState();
    userId = Get.arguments;

    tabController = TabController(length: 4, vsync: this);

    publicProfileController.loadPublicProfile(userId);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Obx(() {
          if (publicProfileController.isLoading.value) {
            return const SizedBox();
          }

          final user = publicProfileController.user.value;

          if (user == null) {
            return const Text('No user found');
          }

          return Text(user.username, style: ts.displayMedium);
        }),
      ),

      body: Obx(() {
        if (publicProfileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final user = publicProfileController.user.value;

        if (user == null) {
          return const Center(child: Text('No user found'));
        }

        return Column(
          children: [
            SizedBox(height: 20.h),

            PublicProfileHeaderWidget(
              image: user.profileImageUrl,
              name: user.fullName,
              bio: user.bio,
              totalPosts: user.posts.length,
              followersCount: user.followers.length,
              followingCount: user.following.length,
            ),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalSmallPadding,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 165.w,
                    child: ElevatedButton(
                      onPressed: () {
                        if (suggestedUserController.isFollowed.value) {
                          suggestedUserController.unfollowUser(user.userId);
                          suggestedUserController.toggleFolow();
                        } else {
                          suggestedUserController.followUser(user.userId);
                          suggestedUserController.toggleFolow();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          suggestedUserController.isFollowed.value
                              ? IGColors.gray.withValues(alpha: .3)
                              : IGColors.blue,
                        ),
                        overlayColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                        shadowColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      child: Text(
                        suggestedUserController.isFollowed.value
                            ? 'Following'
                            : 'Follow',
                        style: TextStyle(
                          color: suggestedUserController.isFollowed.value
                              ? IGColors.bgDark
                              : IGColors.bgLight,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 30.h,
                    width: 165.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.chat,
                          arguments: {
                            'name': user.fullName,
                            'status': 'online',
                            'image': user.profileImageUrl,
                            'userId': user.userId,
                          },
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: IGColors.gray.withValues(
                              alpha: .3,
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            overlayColor: const WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: IGColors.bgDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            TabBar(
              controller: tabController,
              splashFactory: NoSplash.splashFactory,
              labelColor: IGColors.bgDark,
              unselectedLabelColor: IGColors.gray,
              indicatorColor: IGColors.bgDark,
              dividerColor: Colors.transparent,
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Icon(AppIcons.grid),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Icon(AppIcons.reels),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Icon(AppIcons.repost),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Icon(AppIcons.tagProfile),
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  PublicProfileTabview(data: []),
                  PublicProfileTabview(data: [], tabType: 'isVideo'),
                  PublicProfileTabview(data: [], tabType: 'isRepost'),
                  PublicProfileTabview(data: [], tabType: 'isTag'),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
