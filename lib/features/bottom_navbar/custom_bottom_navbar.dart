import 'package:flutter/material.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/dm/view/dm_view.dart';
import 'package:instagram/features/feed/views/feed_view.dart';
import 'package:instagram/features/home/views/home_view.dart';
import 'package:instagram/features/profile/views/profile_view.dart';
import 'package:instagram/features/search/view/search_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int index;

  const CustomBottomNavbar({super.key, this.index = 0});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.index);
  }

  List<Widget> _buildScreens() {
    return [HomeView(), FeedView(), DmView(), SearchView(), ProfileView()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.home),
        activeColorPrimary: IGColors.bgDark,
        inactiveColorPrimary: IGColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.reels),
        activeColorPrimary: IGColors.bgDark,
        inactiveColorPrimary: IGColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.dm),
        activeColorPrimary: IGColors.bgDark,
        inactiveColorPrimary: IGColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.search),
        activeColorPrimary: IGColors.bgDark,
        inactiveColorPrimary: IGColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.profile),
        activeColorPrimary: IGColors.bgDark,
        inactiveColorPrimary: IGColors.gray,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: IGColors.bgLight,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style6,
    );
  }
}
