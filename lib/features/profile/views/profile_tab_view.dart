import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/profile/widgets/empty_tab_widget.dart';

class ProfileTabView extends StatelessWidget {
  final List<PostModel> posts;
  final String tabType;
  const ProfileTabView({super.key, this.tabType = 'all', required this.posts});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    // final
    //  myData = tabType == 'isFav'
    //     ? posts.where((post) => post.isVideo == true).toList()
    //     : tabType == 'isRepost'
    //     ? posts.where((post) => post.re == true).toList()
    //     : tabType == 'isTag'
    //     ? data.where((post) => post['isTag'] == true).toList()
    //     : data;

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

      if (tabType == 'isTag') {
        return EmptyTabWidget(
          icon: AppIcons.tagProfile,
          title: "Photos and videos of you",
          subtitle:
              "When people tag you in photos and videos, they'll appear here.",
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
      itemCount: posts.length,
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
            Image.network(posts[index].mediaUrl, fit: BoxFit.cover),
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
