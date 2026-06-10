import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<Map<String, dynamic>> dummyPosts = [
    {
      "image": "https://picsum.photos/300/300?random=1",
      "viewsCount": 120,
      "isVideo": true,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=2",
      "viewsCount": 340,
      "isVideo": true,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=3",
      "viewsCount": 89,
      "isVideo": true,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=4",
      "viewsCount": 560,
      "isVideo": false,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=5",
      "viewsCount": 1020,
      "isVideo": false,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=6",
      "viewsCount": 120,
      "isVideo": false,
      "isRepost": true,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=7",
      "viewsCount": 340,
      "isVideo": false,
      "isRepost": true,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=8",
      "viewsCount": 89,
      "isVideo": false,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=9",
      "viewsCount": 560,
      "isVideo": false,
      "isRepost": false,
      "isTag": false,
    },
    {
      "image": "https://picsum.photos/300/300?random=10",
      "viewsCount": 1020,
      "isVideo": false,
      "isRepost": true,
      "isTag": false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 45.h),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalSmallPadding,
            ),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(AppIcons.search),
                fillColor: IGColors.gray.withValues(alpha: .2),
                filled: true,
                hintText: 'Search with Meta AI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: dummyPosts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      dummyPosts[index]['image'],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            AppIcons.eyeOpen,
                            color: IGColors.bgLight,
                            size: 14.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            dummyPosts[index]['viewsCount'].toString(),
                            style: TextStyle(
                              color: IGColors.bgLight,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
