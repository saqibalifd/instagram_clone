import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class StoriesCircleWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isPlayed;
  final VoidCallback onStoryTap;
  const StoriesCircleWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.isPlayed,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onStoryTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isPlayed
                  ? LinearGradient(colors: [IGColors.gray, IGColors.gray])
                  : IGColors.buttonGradient,
            ),
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: CachedImageManager.image(
                  url: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: CircleAvatar(
                    backgroundColor: IGColors.gray.withValues(alpha: .3),
                    child: Icon(
                      AppIcons.profile,
                      color: IGColors.bgLight,
                      size: 40.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          name,
          style: ts.headlineSmall!.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
