import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/stories_controller.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/features/dm/controller/dm_controller.dart';
import 'package:instagram/features/home/widgets/my_storie_circle_widget.dart';
import 'package:instagram/features/home/widgets/stories_circle_widget.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';
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
  File? image;

  late File slectedStory;
  StoriesController storiesController = Get.put(StoriesController());

  final DmController dmController = Get.put(DmController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text.trim().toLowerCase();
      // storiesController.fetchAllStories();
      // storiesController.fetchMyStory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          // await storiesController.fetchAllStories();
          // await storiesController.fetchMyStory();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                if (_searchQuery.value.isNotEmpty)
                  return const SizedBox.shrink();
                return Column(
                  children: [
                    SizedBox(height: 40.h),
                    Obx(() {
                      if (storiesController.allStoryList.isEmpty) {
                        return SizedBox();
                      }
                      if (storiesController.isLoading == true) {
                        return SizedBox();
                      }
                      return SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storiesController.allStoryList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: MyStorieCircleWidget(
                                  imageUrl: storiesController
                                      .allStoryList
                                      .first
                                      .mediaUrl,
                                  onStoryTap: () {
                                    Get.toNamed(
                                      AppRoutes.viewStory,
                                      arguments: {
                                        'currentStory':
                                            storiesController.allStoryList[1],
                                        'allStories':
                                            storiesController.allStoryList,
                                      },
                                    );
                                  },
                                  onAddStory: () async {
                                    // print('add story');
                                    final File? pickedImage =
                                        await ImagePickerUtil.pickFromGallery(
                                          context,
                                          maxWidth: 1024,
                                          imageQuality: 85,
                                        );

                                    if (pickedImage != null) {
                                      setState(() {
                                        slectedStory = pickedImage;
                                      });
                                    }
                                  },
                                ),
                              );
                            }
                            final story =
                                storiesController.allStoryList[index - 1];

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: StoriesCircleWidget(
                                onStoryTap: () {
                                  Get.toNamed(
                                    AppRoutes.viewStory,
                                    arguments: {
                                      'currentStory':
                                          storiesController.allStoryList[1],
                                      'allStories':
                                          storiesController.allStoryList,
                                    },
                                  );
                                },
                                imageUrl: story.mediaUrl,
                                name: '',
                                isPlayed: story.isHighlighted,
                              ),
                            );
                          },
                        ),
                      );
                    }),
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
                          Container(
                            width: 46.r,
                            height: 46.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: CachedImageManager.image(
                                url: user.profileImageUrl,
                                fit: BoxFit.cover,

                                errorWidget: CircleAvatar(
                                  backgroundColor: IGColors.gray.withValues(
                                    alpha: .3,
                                  ),
                                  child: Icon(
                                    AppIcons.profile,
                                    color: IGColors.bgLight,
                                  ),
                                ),
                              ),
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
