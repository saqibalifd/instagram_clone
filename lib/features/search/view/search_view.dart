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
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> dummyPosts = [
    {
      "image": "https://picsum.photos/300/300?random=1",
      "viewsCount": 120,
      "userName": "saqib_ali",
      "caption": "Flutter development is amazing 🚀",
      "location": "Lahore Pakistan",
      "hashtags": "#flutter #dart",
    },
    {
      "image": "https://picsum.photos/300/300?random=2",
      "viewsCount": 340,
      "userName": "ali_khan",
      "caption": "Beautiful sunset photography 🌅",
      "location": "Islamabad",
      "hashtags": "#nature #sunset",
    },
    {
      "image": "https://picsum.photos/300/300?random=3",
      "viewsCount": 89,
      "userName": "developer_world",
      "caption": "Building mobile apps with Flutter",
      "location": "Karachi",
      "hashtags": "#coding #flutter",
    },
    {
      "image": "https://picsum.photos/300/300?random=4",
      "viewsCount": 560,
      "userName": "travel_diary",
      "caption": "Exploring beautiful places",
      "location": "Murree",
      "hashtags": "#travel #mountains",
    },
    {
      "image": "https://picsum.photos/300/300?random=5",
      "viewsCount": 1020,
      "userName": "food_lovers",
      "caption": "Delicious Pakistani food",
      "location": "Peshawar",
      "hashtags": "#food #restaurant",
    },
    {
      "image": "https://picsum.photos/300/300?random=6",
      "viewsCount": 450,
      "userName": "tech_guru",
      "caption": "Latest technology updates",
      "location": "Dubai",
      "hashtags": "#technology #ai",
    },
    {
      "image": "https://picsum.photos/300/300?random=7",
      "viewsCount": 780,
      "userName": "fitness_zone",
      "caption": "Daily workout motivation",
      "location": "New York",
      "hashtags": "#fitness #gym",
    },
    {
      "image": "https://picsum.photos/300/300?random=8",
      "viewsCount": 230,
      "userName": "music_world",
      "caption": "My favorite music playlist",
      "location": "London",
      "hashtags": "#music #songs",
    },
    {
      "image": "https://picsum.photos/300/300?random=9",
      "viewsCount": 900,
      "userName": "photography_hub",
      "caption": "Camera and photography tips",
      "location": "Turkey",
      "hashtags": "#photo #camera",
    },
    {
      "image": "https://picsum.photos/300/300?random=10",
      "viewsCount": 1500,
      "userName": "flutter_pro",
      "caption": "Advanced Flutter UI designs",
      "location": "Pakistan",
      "hashtags": "#flutter #ui",
    },
  ];

  late List<Map<String, dynamic>> filteredPosts;

  @override
  void initState() {
    super.initState();
    filteredPosts = dummyPosts;
  }

  void searchPosts(String query) {
    query = query.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        filteredPosts = dummyPosts;
      });
      return;
    }

    setState(() {
      filteredPosts = dummyPosts.where((post) {
        final userName = post['userName'].toString().toLowerCase();
        final caption = post['caption'].toString().toLowerCase();
        final location = post['location'].toString().toLowerCase();
        final hashtags = post['hashtags'].toString().toLowerCase();

        return userName.contains(query) ||
            caption.contains(query) ||
            location.contains(query) ||
            hashtags.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
              controller: searchController,
              onChanged: searchPosts,
              decoration: InputDecoration(
                prefixIcon: Icon(AppIcons.search),
                fillColor: IGColors.gray.withValues(alpha: .2),
                filled: true,
                hintText: 'Search with Meta AI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: filteredPosts.isEmpty
                ? Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  )
                : GridView.builder(
                    itemCount: filteredPosts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 0.6,
                        ),
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(post['image'], fit: BoxFit.cover),

                          Positioned(
                            bottom: 10.h,
                            left: 10.w,
                            child: Row(
                              children: [
                                Icon(
                                  AppIcons.eyeOpen,
                                  color: IGColors.bgLight,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  post['viewsCount'].toString(),
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
