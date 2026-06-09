import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_icons.dart';

class PublicEmptyTabWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PublicEmptyTabWidget({
    super.key,
    this.icon = AppIcons.tagProfile,
    this.title = "",
    this.subtitle = "",
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Column(
      children: [
        Spacer(),
        Container(
          height: 100.h,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2),
          ),
          child: Center(child: Icon(icon, size: 40.sp)),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 280.w,
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: ts.displayLarge,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 280.w,
          child: Text(textAlign: TextAlign.center, subtitle),
        ),
        Spacer(),
      ],
    );
  }
}
