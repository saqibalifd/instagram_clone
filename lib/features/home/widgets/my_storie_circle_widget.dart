import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/theme/app_theme.dart';

class MyStorieCircleWidget extends StatelessWidget {
  const MyStorieCircleWidget({super.key});

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
              child: CircleAvatar(
                backgroundColor: IGColors.gray,
                radius: 40.r,
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Handle add story tap
                },
                child: Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: IGColors.blue,
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
