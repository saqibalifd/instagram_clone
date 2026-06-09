import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/home/widgets/public_empty_tab_widget.dart';
import 'package:instagram/features/profile/widgets/empty_tab_widget.dart';

class PublicProfileTabview extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String tabType;
  const PublicProfileTabview({
    super.key,
    required this.data,
    this.tabType = 'all',
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final myData = tabType == 'isVideo'
        ? data.where((post) => post['isVideo'] == true).toList()
        : tabType == 'isRepost'
        ? data.where((post) => post['isRepost'] == true).toList()
        : tabType == 'isTag'
        ? data.where((post) => post['isTag'] == true).toList()
        : data;

    if (myData.isEmpty) {
      if (tabType == 'isVideo') {
        return PublicEmptyTabWidget(
          icon: AppIcons.reels,
          title: "No Reels Yet",
          subtitle: "Your reels will appear here.",
        );
      }

      if (tabType == 'isRepost') {
        return PublicEmptyTabWidget(
          icon: AppIcons.repost,
          title: "No Reposts Yet",
          subtitle: "Posts you repost will appear here.",
        );
      }

      if (tabType == 'isTag') {
        return PublicEmptyTabWidget(
          icon: AppIcons.tagProfile,
          title: "Photos and videos of you",
          subtitle:
              "When people tag you in photos and videos, they'll appear here.",
        );
      }

      return PublicEmptyTabWidget(
        icon: AppIcons.grid,
        title: "No Posts Yet",
        subtitle: "Your posts will appear here.",
      );
    }

    return GridView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: myData.length,
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
            Image.network(myData[index]['image'], fit: BoxFit.cover),
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
                    myData[index]['viewsCount'].toString(),
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
