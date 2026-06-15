import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/routes/app_routes.dart';

enum _SearchResultType { none, usersOnly, postsOnly, mixed }

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  final List<UserModel> dummyUsers = [
    UserModel(
      fullName: 'Ali Khan',
      email: 'ali@example.com',
      username: 'ali_khan',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      gender: 'Male',
      userId: 'user_1',
      deviceToken: 'token_1',
      bio: 'Flutter Developer 🚀',
      website: 'https://alikhan.dev',
      isPrivate: false,
      isVerified: true,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      following: [],
      followers: [],
      posts: [],
      location: 'Lahore, Pakistan',
      phone: '+923001234567',
      blocked: [],
      likedPosts: [],
      status: 'offline',
    ),
    UserModel(
      fullName: 'Sara Ahmed',
      email: 'sara@example.com',
      username: 'sara_ahmed',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      gender: 'Female',
      userId: 'user_2',
      deviceToken: 'token_2',
      bio: 'Travel • Photography • Coffee ☕',
      website: 'https://saraahmed.com',
      isPrivate: true,
      isVerified: false,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      following: [],
      followers: [],
      posts: [],
      location: 'Karachi, Pakistan',
      phone: '+923112345678',
      blocked: [],
      likedPosts: [],
      status: 'offline',
    ),
    UserModel(
      fullName: 'Usman Malik',
      email: 'usman@example.com',
      username: 'usman_malik',
      profileImageUrl: 'https://i.pravatar.cc/150?img=3',
      gender: 'Male',
      userId: 'user_3',
      deviceToken: 'token_3',
      bio: 'Fitness enthusiast 💪',
      website: '',
      isPrivate: false,
      isVerified: false,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      following: [],
      followers: [],
      posts: [],
      location: 'Islamabad, Pakistan',
      phone: '+923223456789',
      blocked: [],
      likedPosts: [],
      status: 'offline',
    ),
  ];

  final List<PostModel> _dummyPosts = [
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

  List<UserModel> _filteredUsers = [];
  List<PostModel> _filteredPosts = [];
  _SearchResultType _resultType = _SearchResultType.none;
  bool _hasSearched = false;

  void _onSearch(String query) {
    query = query.trim();

    if (query.isEmpty) {
      setState(() {
        _filteredUsers = [];
        _filteredPosts = [];
        _resultType = _SearchResultType.none;
        _hasSearched = false;
      });
      return;
    }

    final q = query.toLowerCase();

    final users = dummyUsers.where((u) {
      return u.fullName.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
    }).toList();

    final posts = _dummyPosts.where((p) {
      return p.caption.toLowerCase().contains(q) ||
          p.tags.join(' ').toLowerCase().contains(q) ||
          (p.location?.toLowerCase().contains(q) ?? false);
    }).toList();

    _SearchResultType type;
    if (users.isNotEmpty && posts.isNotEmpty) {
      type = _SearchResultType.mixed;
    } else if (users.isNotEmpty) {
      type = _SearchResultType.usersOnly;
    } else if (posts.isNotEmpty) {
      type = _SearchResultType.postsOnly;
    } else {
      type = _SearchResultType.none;
    }

    setState(() {
      _filteredUsers = users;
      _filteredPosts = posts;
      _resultType = type;
      _hasSearched = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45.h),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalSmallPadding,
            ),
            child: TextFormField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(AppIcons.search),
                fillColor: IGColors.gray.withValues(alpha: .2),
                filled: true,
                hintText: 'Search people, posts, tags...',
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

          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (!_hasSearched) {
      return _buildExploreGrid();
    }

    if (_resultType == _SearchResultType.none) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.searchOff,
              size: 48.sp,
              color: IGColors.gray.withValues(alpha: .5),
            ),
            SizedBox(height: 12.h),
            Text(
              'No results found',
              style: TextStyle(fontSize: 16.sp, color: IGColors.gray),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (_resultType == _SearchResultType.usersOnly ||
            _resultType == _SearchResultType.mixed) ...[
          if (_resultType == _SearchResultType.mixed)
            _sectionHeader('People', AppIcons.profile),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _UserTile(user: _filteredUsers[i]),
              childCount: _filteredUsers.length,
            ),
          ),
        ],

        if (_resultType == _SearchResultType.mixed)
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),

        if (_resultType == _SearchResultType.postsOnly ||
            _resultType == _SearchResultType.mixed) ...[
          if (_resultType == _SearchResultType.mixed)
            _sectionHeader('Posts & Reels', AppIcons.grid),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _PostTile(post: _filteredPosts[i]),
              childCount: _filteredPosts.length,
            ),
          ),
        ],

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
      ],
    );
  }

  /// Default grid shown before any search
  Widget _buildExploreGrid() {
    return GridView.builder(
      itemCount: _dummyPosts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) => _PostTile(post: _dummyPosts[index]),
    );
  }

  SliverToBoxAdapter _sectionHeader(String title, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalSmallPadding,
          vertical: 8.h,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalSmallPadding,
        vertical: 4.h,
      ),
      leading: CircleAvatar(
        radius: 24.r,
        backgroundImage: NetworkImage(user.profileImageUrl),
      ),
      title: Row(
        children: [
          Text(
            user.username,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          if (user.isVerified) ...[
            SizedBox(width: 4.w),
            Icon(Icons.verified_rounded, size: 14.sp, color: Colors.blue),
          ],
        ],
      ),
      subtitle: Text(
        user.fullName,
        style: TextStyle(fontSize: 12.sp, color: IGColors.gray),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14.sp,
        color: IGColors.gray,
      ),
      onTap: () {
        // Navigate to user profile
        Get.toNamed(
          AppRoutes.publicProfile,
          arguments: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
        );
      },
    );
  }
}

// ─── Post / Reel tile ────────────────────────────────────────────────────────
class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to post detail
        // Get.toNamed(AppRoutes.postDetail, arguments: post);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail
          Image.network(post.mediaUrl, fit: BoxFit.cover),

          // Video badge
          if (post.isVideo)
            Positioned(
              top: 6.h,
              right: 6.w,
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),

          // Views
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: Row(
              children: [
                Icon(AppIcons.eyeOpen, color: IGColors.bgLight, size: 13.sp),
                SizedBox(width: 4.w),
                Text(
                  post.viewsBy.length.toString(),
                  style: TextStyle(
                    color: IGColors.bgLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
