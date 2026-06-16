import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class SuggestedCardWidget extends StatelessWidget {
  final String name;
  final String image;
  final int totalMutual;
  final String userId;
  final void Function() onFollow;
  final void Function() onCancel;

  const SuggestedCardWidget({
    super.key,
    required this.name,
    required this.image,
    required this.totalMutual,
    required this.userId,
    required this.onFollow,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      width: 210.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.gray, width: 0.5),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.publicProfile, arguments: userId);
                },
                child: Container(
                  width: 130.r,
                  height: 130.r,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CachedImageManager.image(
                      url: image,
                      fit: BoxFit.cover,
                      errorWidget: CircleAvatar(
                        backgroundColor: IGColors.gray.withValues(alpha: .3),
                        radius: 10.r,
                        child: Icon(AppIcons.profile, size: 60.sp),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                name,
                style: ts.headlineSmall!.copyWith(fontSize: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$totalMutual mutual friend',
                style: ts.bodySmall!.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 14.h),
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
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: onCancel,
              child: Icon(AppIcons.cross, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
