import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/features/profile/views/follow_tab_view.dart';

class AllFollowView extends StatefulWidget {
  const AllFollowView({super.key});

  @override
  State<AllFollowView> createState() => _AllFollowViewState();
}

class _AllFollowViewState extends State<AllFollowView> {
  final ProfileController profileController = Get.put(ProfileController());

  late final String userId;
  late final String userName;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    userId = args?['userId'] ?? '';
    userName = args?['userName'] ?? '';
    profileController.fetchUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Obx(() {
      if (profileController.specificUserLoading.value == true) {
        return const Center(child: CircularProgressIndicator());
      } else if (profileController.specificUserData.value == null) {
        return const Center(child: Text('No user found'));
      } else {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(userName, style: ts.displayMedium),
              centerTitle: false,
              bottom: TabBar(
                splashFactory: NoSplash.splashFactory,
                labelColor: IGColors.bgDark,
                unselectedLabelColor: IGColors.gray,
                indicatorColor: IGColors.bgDark,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: Text(
                      '${profileController.specificUserData.value?.followers.length.toString() ?? '0'} Followers',
                    ),
                  ),
                  Tab(
                    icon: Text(
                      '${profileController.specificUserData.value?.following.length.toString() ?? '0'} Following',
                    ),
                  ),
                  Tab(icon: Text('Subscriptions')),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FollowTabView(
                  tabType: 'followers',
                  userId: profileController.specificUserData.value!.userId,
                ),
                FollowTabView(
                  tabType: 'following',

                  userId: profileController.specificUserData.value!.userId,
                ),
                FollowTabView(
                  tabType: 'subscriptions',

                  userId: profileController.specificUserData.value!.userId,
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
