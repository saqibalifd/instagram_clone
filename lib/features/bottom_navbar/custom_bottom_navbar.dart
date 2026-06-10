import 'package:flutter/material.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/dm/view/dm_view.dart';
import 'package:instagram/features/feed/views/feed_view.dart';
import 'package:instagram/features/home/views/home_view.dart';
import 'package:instagram/features/profile/views/profile_view.dart';
import 'package:instagram/features/search/view/search_view.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int index;

  const CustomBottomNavbar({super.key, this.index = 0});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PageController _pageController;
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeView(),
    FeedView(),
    DmView(),
    SearchView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: IGColors.bgLight,
        selectedItemColor: IGColors.bgDark,
        unselectedItemColor: IGColors.gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(AppIcons.reels), label: ''),
          BottomNavigationBarItem(icon: Icon(AppIcons.dm), label: ''),
          BottomNavigationBarItem(icon: Icon(AppIcons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(AppIcons.profile), label: ''),
        ],
      ),
    );
  }
}
