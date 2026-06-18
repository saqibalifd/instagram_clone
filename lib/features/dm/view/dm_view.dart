import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/stories_model.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/features/dm/controller/dm_controller.dart';
import 'package:instagram/features/dm/widgets/dm_my_stories_circle_widget.dart';
import 'package:instagram/features/dm/widgets/dm_stories_circle_widget.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/image_picker_util.dart';

class DmView extends StatefulWidget {
  const DmView({super.key});

  @override
  State<DmView> createState() => _DmViewState();
}

class _DmViewState extends State<DmView> {
  final TextEditingController _searchController = TextEditingController();

  // ← Rx so Obx rebuilds when query changes
  final RxString _searchQuery = ''.obs;

  final List<StoryUserModel> storiesUsers = [
    StoryUserModel(
      name: 'Ali',
      profileImage: 'https://i.pravatar.cc/150?img=1',
      storyImage:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      songTitle: 'Blinding Lights • The Weeknd',
      timeAgo: '5m ago',
      isPlayed: false,
      userId: 'user_001',
    ),
    StoryUserModel(
      name: 'Iftikhar Ali',
      profileImage: 'https://i.pravatar.cc/150?img=2',
      storyImage:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
      songTitle: 'Calm Down • Rema',
      timeAgo: '15m ago',
      isPlayed: false,
      userId: 'user_002',
    ),
    StoryUserModel(
      name: 'Jamshed Hussain Alvi',
      profileImage: 'https://i.pravatar.cc/150?img=3',
      storyImage:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
      songTitle: 'Perfect • Ed Sheeran',
      timeAgo: '30m ago',
      isPlayed: false,
      userId: 'user_003',
    ),
    StoryUserModel(
      name: 'Fakhar Hussain',
      profileImage: 'https://i.pravatar.cc/150?img=4',
      storyImage:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?w=800',
      songTitle: 'Starboy • The Weeknd',
      timeAgo: '1h ago',
      isPlayed: false,
      userId: 'user_004',
    ),
    StoryUserModel(
      name: 'Hassan Ali',
      profileImage: 'https://i.pravatar.cc/150?img=5',
      storyImage:
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
      songTitle: 'Shape of You • Ed Sheeran',
      timeAgo: '2h ago',
      isPlayed: true,
      userId: 'user_005',
    ),
    StoryUserModel(
      name: 'Usman Khan',
      profileImage: 'https://i.pravatar.cc/150?img=6',
      storyImage:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
      songTitle: 'Until I Found You • Stephen Sanchez',
      timeAgo: '3h ago',
      isPlayed: false,
      userId: 'user_006',
    ),
    StoryUserModel(
      name: 'Zain Malik',
      profileImage: 'https://i.pravatar.cc/150?img=7',
      storyImage:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
      songTitle: 'Levitating • Dua Lipa',
      timeAgo: '4h ago',
      isPlayed: false,
      userId: 'user_007',
    ),
  ];

  final DmController dmController = Get.put(DmController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // ← update Rx string; Obx below will rebuild automatically
      _searchQuery.value = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Derives filtered list from the live RxList + current query.
  /// Called inside Obx so it re-runs on any change to either.
  List<UserModel> get _filteredUsers {
    final query = _searchQuery.value;
    if (query.isEmpty) return dmController.friendsUsers;
    return dmController.friendsUsers.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
          user.username.toLowerCase().contains(query) ||
          user.bio.toLowerCase().contains(query);
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          profileController.profileUser.value!.fullName,
          style: ts.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalSmallPadding,
              ),
              child: Obx(
                () => TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(AppIcons.search),
                    suffixIcon: _searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _clearSearch,
                          )
                        : null,
                    fillColor: IGColors.gray.withValues(alpha: .2),
                    filled: true,
                    hintText: 'Search',
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
            ),

            // ── Stories row (hidden while searching) ────────────────
            Obx(() {
              if (_searchQuery.value.isNotEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  SizedBox(height: 40.h),
                  SizedBox(
                    height: 110.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: storiesUsers.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: DmMyStoriesCircleWidget(
                              imageUrl:
                                  'https://img.magnific.com/free-psd/modern-dynamic-banner_125755-403.jpg',
                              onStoryTap: () {
                                Get.toNamed(
                                  AppRoutes.viewStory,
                                  arguments: {
                                    'currentStory': storiesUsers[index],
                                    'allStories': storiesUsers,
                                  },
                                );
                              },
                              onAddStory: () async {
                                await ImagePickerUtil.pickFromGallery(
                                  context,
                                  maxWidth: 1024,
                                  imageQuality: 85,
                                );
                              },
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: DmStoriesCircleWidget(
                            onStoryTap: () {
                              Get.toNamed(
                                AppRoutes.viewStory,
                                arguments: {
                                  'currentStory': storiesUsers[index],
                                  'allStories': storiesUsers,
                                },
                              );
                            },
                            imageUrl: storiesUsers[index].storyImage.toString(),
                            name:
                                storiesUsers[index].name.toString().length > 10
                                ? '${storiesUsers[index].name.toString().substring(0, 10)}...'
                                : storiesUsers[index].name.toString(),
                            isPlayed: storiesUsers[index].isPlayed,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),

            // ── Section header ───────────────────────────────────────
            Obx(
              () => Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalSmallPadding,
                    vertical: 8,
                  ),
                  child: Text(
                    _searchQuery.value.isNotEmpty ? 'Results' : 'Messages',
                    style: ts.displaySmall,
                  ),
                ),
              ),
            ),

            // ── Friends list (fully reactive) ────────────────────────
            Obx(() {
              // Show loader while first load is in progress
              if (dmController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),

                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final users = _filteredUsers; // derives from Rx values above

              if (users.isEmpty) return _buildEmptyState();

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final bool isOnline =
                      user.status == 'online' || user.status == 'active now';

                  return ListTile(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.chat,
                        arguments: {
                          'name': user.fullName,
                          'status': user.status,
                          'image': user.profileImageUrl,
                          'userId': user.userId,
                        },
                      );
                    },
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImageUrl),
                        ),
                        if (isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: IGColors.green,
                            ),
                          ),
                      ],
                    ),
                    title: _searchQuery.value.isNotEmpty
                        ? _buildHighlightedText(
                            user.fullName,
                            _searchController.text.trim(),
                            ts.bodyMedium!,
                          )
                        : Text(user.fullName),
                    subtitle: Text(user.status),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48.sp, color: IGColors.gray),
          SizedBox(height: 12.h),
          Text(
            _searchQuery.value.isNotEmpty
                ? 'No results for "${_searchController.text.trim()}"'
                : 'No messages yet',
            style: TextStyle(color: IGColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, TextStyle base) {
    if (query.isEmpty) return Text(text, style: base);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final start = lowerText.indexOf(lowerQuery);

    if (start == -1) return Text(text, style: base);

    final end = start + query.length;
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          if (start > 0) TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: base.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (end < text.length) TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }
}
