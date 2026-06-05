import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/theme/app_theme.dart';

class StoriesCircleWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isPlayed;
  const StoriesCircleWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.isPlayed,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isPlayed
                ? LinearGradient(colors: [IGColors.gray, IGColors.gray])
                : IGColors.buttonGradient,
          ),
          child: CircleAvatar(
            backgroundColor: IGColors.gray,
            radius: 30.r,
            backgroundImage: NetworkImage(imageUrl),
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
