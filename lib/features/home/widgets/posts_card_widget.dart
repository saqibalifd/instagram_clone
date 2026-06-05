import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';

class PostsCardWidget extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final int likes;
  final String postImage;
  final String caption;
  final int totalComments;
  final String timeAgo;
  const PostsCardWidget({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.postImage,
    required this.likes,
    required this.caption,
    required this.totalComments,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              CircleAvatar(radius: 18.r, backgroundImage: NetworkImage(image)),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      location,
                      style: ts.bodySmall!.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Icon(AppIcons.more),
            ],
          ),
        ),

        // Post image
        SizedBox(
          width: double.maxFinite,
          height: 300.h,
          child: Image.network(
            postImage,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: IGColors.gray,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),

        // Action buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(AppIcons.heart),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(AppIcons.comment),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(AppIcons.dm),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(AppIcons.favorite),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Likes & caption
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$likes likes',
                style: ts.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$name ',
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    TextSpan(
                      text: caption,
                      style: ts.bodyMedium!.copyWith(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'View all $totalComments comments',
                style: ts.bodySmall!.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                timeAgo,
                style: ts.bodySmall!.copyWith(
                  fontSize: 10.sp,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),
        Divider(color: IGColors.gray, thickness: 0.3),
      ],
    );
  }
}
