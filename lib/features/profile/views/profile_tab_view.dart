import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/profile/widgets/empty_tab_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class ProfileTabView extends StatelessWidget {
  final List<PostModel> posts;
  final String tabType;
  const ProfileTabView({super.key, this.tabType = 'all', required this.posts});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    if (posts.isEmpty) {
      if (tabType == 'isVideo') {
        return EmptyTabWidget(
          icon: AppIcons.reels,
          title: "No Reels Yet",
          subtitle: "Your reels will appear here.",
        );
      }

      if (tabType == 'isRepost') {
        return EmptyTabWidget(
          icon: AppIcons.repost,
          title: "No Reposts Yet",
          subtitle: "Posts you repost will appear here.",
        );
      }

      if (tabType == 'isFav') {
        return EmptyTabWidget(
          icon: AppIcons.tagProfile,
          title: "No Favourite Posts Yet",
          subtitle:
              "Posts you add to your favourites will appear here so you can easily find them later.",
        );
      }

      return EmptyTabWidget(
        icon: AppIcons.grid,
        title: "No Posts Yet",
        subtitle: "Your posts will appear here.",
      );
    }

    return GridView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: tabType == 'isFav' ? posts.length - 1 : posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.allPosts,
                  arguments: {'posts': posts, 'index': index},
                );
              },
              child: CachedImageManager.image(
                url: posts[index].mediaUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10.h,
              left: 10.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(AppIcons.eyeOpen, color: IGColors.bgLight, size: 14.sp),
                  SizedBox(width: 5.w),
                  Text(
                    posts[index].viewsBy.length.toString(),
                    style: TextStyle(color: IGColors.bgLight, fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
