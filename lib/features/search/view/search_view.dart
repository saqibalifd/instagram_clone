import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/controllers/suggested_user_controller.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';

enum _SearchResultType { none, usersOnly, postsOnly, mixed }

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final SuggestedUserController suggestedUserController = Get.put(
    SuggestedUserController(),
  );

  final PostsController postsController = Get.put(PostsController());

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

    final users = suggestedUserController.suggestedUsersList.where((u) {
      return u.fullName.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
    }).toList();

    final posts = postsController.allPostsList.where((p) {
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
      itemCount: postsController.allPostsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) =>
          _PostTile(post: postsController.allPostsList[index]),
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
      leading: Container(
        width: 46.r,
        height: 45.r,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.r),
          child: CachedImageManager.image(
            url: user.profileImageUrl,
            fit: BoxFit.cover,
            errorWidget: CircleAvatar(
              backgroundColor: IGColors.gray.withValues(alpha: .3),
              child: Icon(AppIcons.profile, color: IGColors.bgLight),
            ),
          ),
        ),
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
        Get.toNamed(AppRoutes.publicProfile, arguments: user.userId);
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
