import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';

class SuggestedCardWidget extends StatelessWidget {
  final String name;
  final String image;
  final int totalMutual;
  final void Function() onFollow;
  const SuggestedCardWidget({
    super.key,
    required this.name,
    required this.image,
    required this.totalMutual,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      width: 180.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.gray, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.publicProfile,
                arguments: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
              );
            },
            child: CircleAvatar(
              radius: 50.r,
              backgroundImage: NetworkImage(image),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            name,
            style: ts.headlineSmall!.copyWith(fontSize: 13.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$totalMutual mutual friend',
            style: ts.bodySmall!.copyWith(fontSize: 11.sp),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.maxFinite,
            height: 32.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: IGColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onFollow,
              child: Text('Follow', style: TextStyle(fontSize: 13.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
