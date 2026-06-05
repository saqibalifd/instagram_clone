import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/features/profile/views/profile_tab_view.dart';
import 'package:instagram/features/profile/widgets/profile_header.dart';
import 'package:instagram/routes/app_routes.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final AuthController _authController = AuthController();
  late TabController tabController;
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
  final String bio = '''
🚀 Flutter Developer | 2+ Years Experience
Passionate Flutter Developer with 2+ years of experience building modern, scalable, and high-performance Android and cross-platform mobile applications. Experienced in crafting beautiful UIs, integrating APIs, and delivering seamless user experiences.
''';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
          onPressed: () {},
          icon: Icon(AppIcons.add),
        ),
        title: Text('Saqibali.fd', style: ts.displayMedium),
        actions: [
          IconButton(
            onPressed: () async {
              await _authController.signOut();
            },
            icon: Icon(AppIcons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),

          //profile header row
          ProfileHeader(
            image:
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=880&q=80",
            name: 'Ali',
            bio: bio,
            totalPosts: 32,
            followersCount: 933,
            followingCount: 32,
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
                      Get.toNamed(AppRoutes.editProfile);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        IGColors.gray.withValues(alpha: .3),
                      ),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
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
                      Get.toNamed(AppRoutes.shareProfile);
                    },
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor: IGColors.gray.withValues(alpha: .3),
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
                ProfileTabView(data: dummyPosts),
                ProfileTabView(data: dummyPosts, tabType: 'isVideo'),
                ProfileTabView(data: dummyPosts, tabType: 'isRepost'),
                ProfileTabView(data: dummyPosts, tabType: 'isTag'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
