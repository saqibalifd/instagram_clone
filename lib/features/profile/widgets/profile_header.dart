import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  final String image;
  final String name;
  final int totalPosts;
  final int followersCount;
  final int followingCount;
  final String bio;

  const ProfileHeader({
    super.key,
    required this.image,
    required this.name,
    required this.totalPosts,
    required this.followersCount,
    required this.followingCount,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalSmallPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 35.r, backgroundImage: NetworkImage(image)),
              SizedBox(width: 10.w),

              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: ts.titleLarge),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),

                      Text(followersCount.toString(), style: ts.titleLarge),
                      Text('followers'),
                    ],
                  ),
                ],
              ),
              Spacer(),

              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),

                      Text(followingCount.toString(), style: ts.titleLarge),
                      Text('following'),
                    ],
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
