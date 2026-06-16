import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/controllers/suggested_user_controller.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/favourite_post_services.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/features/home/widgets/suggested_card_widget.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/features/profile/views/profile_tab_view.dart';
import 'package:instagram/features/profile/widgets/profile_header.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final AuthController _authController = AuthController();
  final PostsController postsController = Get.put(PostsController());
  late TabController tabController;

  final String bio = '''
🚀 Flutter Developer | 2+ Years Experience
Passionate Flutter Developer with 2+ years of experience building modern, scalable, and high-performance Android and cross-platform mobile applications. Experienced in crafting beautiful UIs, integrating APIs, and delivering seamless user experiences.
''';

  final ProfileController _profileController = Get.put(ProfileController());
  final SuggestedUserController _suggestedUserController = Get.put(
    SuggestedUserController(),
  );
  // Change this field declaration:
  List<PostModel> favoritePosts = FavoritePostService.getFavorites();

  // To this:
  RxList<PostModel> favoritePost = <PostModel>[].obs;

  // To this:
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    _profileController.loadLocalProfile();
    _profileController.loadProfileStream();
    favoritePosts;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await FavoritePostService.init();
    setState(() {
      favoritePosts = FavoritePostService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      //appbar
      body: Obx(() {
        final user = _profileController.profileUser.value;

        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // app bar
                Row(
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      iconSize: 35,
                      color: IGColors.bgDark,

                      onPressed: () {
                        BottomSheetUtil.show(
                          context,
                          type: IGBottomSheet.addPost,
                          addPostActions: [
                            IGAddPostAction(
                              icon: AppIcons.grid,
                              label: 'Post',
                              subtitle:
                                  'Share a photo or video to your profile',
                              onTap: () {},
                            ),
                            IGAddPostAction(
                              icon: AppIcons.reels,
                              label: 'Reel',
                              subtitle: 'Create and share a short video',
                              onTap: () {},
                            ),
                            IGAddPostAction(
                              icon: AppIcons.stories,
                              label: 'Story',
                              subtitle:
                                  'Share a photo or video that disappears in 24 hours',
                              onTap: () {},
                            ),
                            IGAddPostAction(
                              icon: AppIcons.live,
                              label: 'Live',
                              subtitle:
                                  'Go live and connect with your followers in real time',
                              onTap: () {},
                            ),
                          ],
                        );
                      },
                      icon: Icon(AppIcons.add),
                    ),
                    Spacer(),
                    Text(
                      _profileController.profileUser.value!.username,
                      style: ts.displayMedium,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        await _authController.signOut();
                      },
                      icon: Icon(AppIcons.logout, color: IGColors.bgDark),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                //profile header
                Obx(() {
                  final userData = _profileController.profileUser.value!;
                  if (_profileController.profileSnapshotLoading.value) {
                    return SizedBox();
                  }

                  return ProfileHeader(
                    image: userData.profileImageUrl,
                    name: userData.fullName,
                    bio: userData.bio,
                    totalPosts: userData.posts.length,
                    followersCount: userData.followers.length,
                    followingCount: userData.following.length,
                  );
                }),

                SizedBox(height: 20.h),
                //edit and share buttons
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalSmallPadding,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 30.h,
                        width: 155.w,

                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.editProfile, arguments: user);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              IGColors.gray.withValues(alpha: .3),
                            ),
                            overlayColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                            elevation: WidgetStatePropertyAll(0),
                            shadowColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                          child: Text(
                            'Edit profile',
                            style: TextStyle(color: IGColors.bgDark),
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 30.h,
                        width: 155.w,

                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.shareProfile);
                          },
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: IGColors.gray.withValues(
                                  alpha: .3,
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ).copyWith(
                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                              ),
                          child: Text(
                            'Share profile',
                            style: TextStyle(color: IGColors.bgDark),
                          ),
                        ),
                      ),
                      Spacer(),

                      GestureDetector(
                        onTap: () {
                          _suggestedUserController.suggestionButtonSwitch();
                        },
                        child: Container(
                          height: 30.h,
                          width: 30.w,

                          decoration: BoxDecoration(
                            color: IGColors.gray.withValues(alpha: .3),

                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(AppIcons.addPerson, size: 18.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // suggested users list
                Obx(() {
                  if (_suggestedUserController.suggestedUsersList.isEmpty) {
                    return SizedBox();
                  }
                  return Visibility(
                    visible: _suggestedUserController.showSuggestion.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          child: Text(
                            'Discover people',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 245.h,
                          child: ListView.builder(
                            itemCount: _suggestedUserController
                                .suggestedUsersList
                                .length,
                            scrollDirection: Axis.horizontal,

                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            itemBuilder: (context, index) {
                              final suggestedUsers = _suggestedUserController
                                  .suggestedUsersList[index];
                              return SuggestedCardWidget(
                                onCancel: () {
                                  _suggestedUserController.skipUser(index);
                                },
                                onFollow: () {
                                  _suggestedUserController.followUser(
                                    suggestedUsers.userId,
                                  );
                                  _suggestedUserController.skipUser(index);
                                },
                                name: suggestedUsers.fullName,

                                image: suggestedUsers.profileImageUrl,

                                totalMutual: suggestedUsers.followers.length,
                                userId: suggestedUsers.userId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 20.h),
                //tab bar *****************
                TabBar(
                  controller: tabController,
                  splashFactory: NoSplash.splashFactory,

                  labelColor: IGColors.bgDark,
                  unselectedLabelColor: IGColors.gray,
                  indicatorColor: IGColors.bgDark,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Icon(AppIcons.grid),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Icon(AppIcons.reels),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Icon(AppIcons.repost),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Icon(AppIcons.favorite),
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ProfileTabView(
                        posts: postsController.myPostsList,
                        tabType: 'isFavorite',
                      ),
                      ProfileTabView(
                        posts: postsController.myVideoPostsList,
                        tabType: 'isVideo',
                      ),
                      ProfileTabView(
                        posts: postsController.myRepostsList,
                        tabType: 'isRepost',
                      ),
                      ProfileTabView(
                        posts: favoritePosts,
                        tabType: 'isFav',
                      ), // no Obx
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
