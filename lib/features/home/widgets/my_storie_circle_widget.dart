import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/theme/app_theme.dart';

class MyStorieCircleWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onStoryTap;

  final VoidCallback onAddStory;
  const MyStorieCircleWidget({
    super.key,
    required this.imageUrl,
    required this.onStoryTap,
    required this.onAddStory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: IGColors.buttonGradient,
              ),
              child: GestureDetector(
                onTap: onStoryTap,

                child: CircleAvatar(
                  backgroundColor: IGColors.gray,
                  radius: 40.r,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onAddStory,
                child: Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: IGColors.bgDark,
                    shape: BoxShape.circle,
                    border: Border.all(color: IGColors.bgLight, width: 2),
                  ),
                  child: Icon(Icons.add, color: IGColors.bgLight, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          'Your Story',
          style: TextStyle(fontSize: 11.sp, color: Colors.black87),
        ),
      ],
    );
  }
}
