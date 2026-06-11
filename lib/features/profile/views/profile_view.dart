import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/favourite_post_services.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
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
  late TabController tabController;
  final List<PostModel> dummyPosts = [
    PostModel(
      postId: '1',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
    PostModel(
      postId: '1',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
    PostModel(
      postId: '1',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
  ];
  final String bio = '''
🚀 Flutter Developer | 2+ Years Experience
Passionate Flutter Developer with 2+ years of experience building modern, scalable, and high-performance Android and cross-platform mobile applications. Experienced in crafting beautiful UIs, integrating APIs, and delivering seamless user experiences.
''';

  final ProfileController _profileController = Get.put(ProfileController());
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
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            BottomSheetUtil.show(context, type: IGBottomSheet.addPost);
          },
          icon: Icon(AppIcons.add),
        ),
        title: Text(
          _profileController.profileUser.value!.username,
          style: ts.displayMedium,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _authController.signOut();
            },
            icon: Icon(AppIcons.logout),
          ),
        ],
      ),
      body: Obx(() {
        final user = _profileController.profileUser.value;

        return Column(
          children: [
            SizedBox(height: 20.h),

            //profile header row`
            ProfileHeader(
              image: user!.profileImageUrl,
              name: user.fullName,
              bio: user.bio,
              totalPosts: user.posts.length,
              followersCount: user.followers.length,
              followingCount: user.following.length,
            ),
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
                    width: 165.w,

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
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
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
                    width: 165.w,

                    child: ElevatedButton(
                      onPressed: () {
                        FavoritePostService.clearFavorites();
                        // Get.toNamed(AppRoutes.shareProfile);
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
                ],
              ),
            ),
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
                  child: Icon(AppIcons.tagProfile),
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ProfileTabView(posts: dummyPosts, tabType: 'isFavorite'),
                  ProfileTabView(posts: dummyPosts, tabType: 'isVideo'),
                  ProfileTabView(posts: dummyPosts, tabType: 'isRepost'),
                  ProfileTabView(
                    posts: favoritePosts,
                    tabType: 'isFav',
                  ), // no Obx
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
