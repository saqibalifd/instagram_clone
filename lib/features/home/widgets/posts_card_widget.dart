import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/favourite_post_services.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/custom_toast_util.dart';

class PostsCardWidget extends StatefulWidget {
  final PostModel postModel;
  const PostsCardWidget({super.key, required this.postModel});

  @override
  State<PostsCardWidget> createState() => _PostsCardWidgetState();
}

class _PostsCardWidgetState extends State<PostsCardWidget> {
  bool isLiked = false;
  bool isFav = false;
  @override
  void initState() {
    super.initState();

    isFav = FavoritePostService.isFavorite(widget.postModel.postId);

    print('Initial isFav: $isFav');
  }

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
                    arguments: widget.postModel.userId,
                  );
                },
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundImage: NetworkImage(
                    widget.postModel.profileImageUrl,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.userName,
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      widget.postModel.location,
                      style: ts.bodySmall!.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.more,
                    moreActions: [
                      IGMoreAction(
                        icon: AppIcons.flag,
                        label: 'Report',
                        color: IGColors.like,
                        onTap: () {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.hidePost,
                        label: 'Hide post',
                        onTap: () {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.personRemove,
                        label: 'Unfollow',
                        onTap: () => {},
                      ),
                      IGMoreAction(
                        icon: AppIcons.copy,
                        label: 'Copy link',
                        onTap: () {},
                      ),
                    ],
                  );
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
            widget.postModel.mediaUrl,
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
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.comment,
                    comments: [
                      IGComment(
                        user: 'alex.doe',
                        text: 'Amazing shot! 🔥',
                        time: '2h',
                      ),
                      IGComment(
                        user: 'sara_m',
                        text: 'Love this so much ❤️',
                        time: '1h',
                      ),
                      IGComment(
                        user: 'john_travels',
                        text: 'Where was this taken? 😍',
                        time: '45m',
                      ),
                      IGComment(
                        user: 'priya.k',
                        text: 'Absolutely stunning 🌅',
                        time: '30m',
                      ),
                      IGComment(
                        user: 'mike_photos',
                        text: 'The lighting is perfect here!',
                        time: '20m',
                      ),
                      IGComment(user: 'layla99', text: 'Goals 🙌', time: '10m'),
                      IGComment(
                        user: 'dev.omar',
                        text: 'This is my wallpaper now lol',
                        time: '5m',
                      ),
                    ],
                    onCommentSubmit: (text) {
                      // Add comment logic here
                    },
                  );
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
                  BottomSheetUtil.show(
                    context,
                    type: IGBottomSheet.share,
                    shareOptions: [
                      IGShareOption(
                        icon: Icons.send_outlined,
                        label: 'Send in DM',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.add_circle_outline,
                        label: 'Add to Story',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.link,
                        label: 'Copy link',
                        onTap: () {},
                      ),
                      IGShareOption(
                        icon: Icons.bookmark_border,
                        label: 'Save post',
                        onTap: () {},
                      ),
                    ],
                  );
                },
                icon: Icon(AppIcons.dm, color: IGColors.bgDark),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  if (!isFav) {
                    await FavoritePostService.addToFavorites(widget.postModel);

                    setState(() {
                      isFav = !isFav;
                    });
                    CustomToastUtil.showDefault(
                      context,
                      message: 'Post added to favorites',
                    );
                  } else {
                    await FavoritePostService.removeFromFavorites(
                      widget.postModel.postId,
                    );
                    setState(() {
                      isFav = !isFav;
                    });
                    CustomToastUtil.showDefault(
                      context,
                      message: 'Post removed from favorites',
                    );
                  }

                  // try {
                  //   await FavoritePostService.addToFavorites(widget.postModel);
                  // } catch (e) {
                  //   print(e.toString());
                  // }
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
                '${widget.postModel.likes.length.toString()} likes',
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
                      text: '${widget.postModel.userName} ',
                      style: ts.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    TextSpan(
                      text: widget.postModel.caption,
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
                  'View all ${widget.postModel.comments.length.toString()} comments',

                  style: ts.bodySmall!.copyWith(fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.postModel.createdAt.toString(),
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
