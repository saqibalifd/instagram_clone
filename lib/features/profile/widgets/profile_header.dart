import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class ProfileHeader extends StatelessWidget {
  final String image;
  final String name;
  final int totalPosts;
  final int followersCount;
  final int followingCount;
  final String bio;
  final VoidCallback onTap;

  const ProfileHeader({
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
              Container(
                width: 70.r,
                height: 70.r,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: CachedImageManager.image(
                    url: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          name,
                          style: ts.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(totalPosts.toString(), style: ts.titleLarge),
                      Text('posts'),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),

                        Text(followersCount.toString(), style: ts.titleLarge),
                        Text('followers'),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),

              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),

                        Text(followingCount.toString(), style: ts.titleLarge),
                        Text('following'),
                      ],
                    ),
                  ),
                  SizedBox(width: 50.w),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.start,
            bio,
            style: ts.bodyMedium,
          ),
        ],
      ),
    );
  }
}
