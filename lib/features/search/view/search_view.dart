import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  final List<PostModel> dummyPosts = [
    PostModel(
      postId: '1',
      userId: 'user_001',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      tags: ['flutter', 'dart'],
      repostBy: [],
      favorites: [],
      viewsBy: ['user_4'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
    PostModel(
      postId: '2',
      userId: 'user_002',
      userName: 'Ali Khan',
      profileImageUrl: 'https://i.pravatar.cc/150?img=12',
      caption: 'Beautiful evening at the mountains 🌄',
      mediaUrl: 'https://picsum.photos/id/1018/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Murree, Pakistan',
      likes: ['user_1', 'user_5', 'user_6'],
      comments: ['Amazing view!', 'Nature ❤️'],
      tags: ['travel', 'mountains'],
      repostBy: ['user_7'],
      favorites: ['user_3'],
      viewsBy: ['user_2', 'user_4'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
    PostModel(
      postId: '3',
      userId: 'user_003',
      userName: 'Ahmed Raza',
      profileImageUrl: 'https://i.pravatar.cc/150?img=20',
      caption: 'Coding late night with coffee ☕💻',
      mediaUrl: 'https://picsum.photos/id/0/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      location: 'Islamabad, Pakistan',
      likes: ['user_1', 'user_2'],
      comments: ['Developer life 🔥', 'Keep coding'],
      tags: ['coding', 'developer'],
      repostBy: [],
      favorites: ['user_5'],
      viewsBy: ['user_1', 'user_8'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
  ];

  late List<PostModel> filteredPosts;

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
        final userName = post.userName.toLowerCase();
        final caption = post.caption.toLowerCase();
        final location = post.location?.toLowerCase() ?? '';
        final tags = post.tags.join(' ').toLowerCase();

        return userName.contains(query) ||
            caption.contains(query) ||
            location.contains(query) ||
            tags.contains(query);
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

          /// SEARCH BAR
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
                hintText: 'Search posts...',
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

          /// GRID VIEW
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
                          /// IMAGE
                          GestureDetector(
                            onTap: () {},
                            child: Image.network(
                              post.mediaUrl,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// VIEWS
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
                                  post.viewsBy.length.toString(),
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
