import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/dm/view/dm_view.dart';
import 'package:instagram/features/feed/views/feed_view.dart';
import 'package:instagram/features/home/views/home_view.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
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
  final ProfileController _profileController = Get.put(ProfileController());

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
    _profileController.loadLocalProfile();
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
      duration: const Duration(milliseconds: 320),
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
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home, color: IGColors.bgDark, size: 32),
            activeIcon: Icon(AppIcons.homeFill, size: 32),

            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.playSquare, height: 32),
            activeIcon: SvgPicture.asset(AppIcons.playSquareFill, height: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.dm, color: IGColors.bgDark, size: 32),
            activeIcon: Icon(AppIcons.dmFill, size: 32),

            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.searchSvg, height: 32),
            activeIcon: SvgPicture.asset(AppIcons.searchFillSvg, height: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: IGColors.bgLight,
              radius: 14.r,
              backgroundImage: NetworkImage(
                _profileController.profileUser.value!.profileImageUrl,
              ),
            ),
            activeIcon: CircleAvatar(
              backgroundColor: IGColors.bgLight,
              radius: 14.r,
              backgroundImage: NetworkImage(
                _profileController.profileUser.value!.profileImageUrl,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
