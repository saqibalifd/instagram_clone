import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/custom_toast_util.dart';

class PostsCardWidget extends StatefulWidget {
  final String image;
  final String name;
  final String location;
  final int likes;
  final String postImage;
  final String caption;
  final int totalComments;
  final String timeAgo;
  final String userId;

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
    required this.userId,
  });

  @override
  State<PostsCardWidget> createState() => _PostsCardWidgetState();
}

class _PostsCardWidgetState extends State<PostsCardWidget> {
  bool isLiked = false;
  bool isFav = false;

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
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.publicProfile,
                    arguments: widget.userId,
                  );
                },
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundImage: NetworkImage(widget.image),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      widget.location,
                      style: ts.bodySmall!.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  BottomSheetUtil.show(context, type: IGBottomSheet.more);
                },
                child: Icon(AppIcons.more),
              ),
            ],
          ),
        ),

        // Post image
        SizedBox(
          width: double.maxFinite,
          height: 300.h,
          child: Image.network(
            widget.postImage,
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
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  setState(() => isLiked = !isLiked);
                },
                icon: isLiked
                    ? Icon(AppIcons.heartFill, color: IGColors.like)
                    : Icon(AppIcons.heart, color: IGColors.bgDark),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 16.w),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  BottomSheetUtil.show(context, type: IGBottomSheet.comment);
                },
                icon: Icon(AppIcons.comment, color: IGColors.bgDark),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 16.w),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  BottomSheetUtil.show(context, type: IGBottomSheet.share);
                },
                icon: Icon(AppIcons.dm, color: IGColors.bgDark),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  setState(() => isFav = !isFav);
                  CustomToastUtil.showDefault(
                    context,
                    message: 'Post added to favourites',
                  );
                },
                icon: Icon(
                  isFav ? AppIcons.favoriteFill : AppIcons.favorite,
                  color: IGColors.bgDark,
                ),
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
                '${widget.likes} likes',
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
                      text: '${widget.name} ',
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    TextSpan(
                      text: widget.caption,
                      style: ts.bodyMedium!.copyWith(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  BottomSheetUtil.show(context, type: IGBottomSheet.comment);
                },
                child: Text(
                  'View all ${widget.totalComments} comments',

                  style: ts.bodySmall!.copyWith(fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.timeAgo,
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
