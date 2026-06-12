import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/profile/views/follow_tab_view.dart';

class AllFollowView extends StatefulWidget {
  const AllFollowView({super.key});

  @override
  State<AllFollowView> createState() => _AllFollowViewState();
}

class _AllFollowViewState extends State<AllFollowView> {
  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Saqibali.fd', style: ts.displayMedium),
          centerTitle: false,
          bottom: const TabBar(
            splashFactory: NoSplash.splashFactory,
            labelColor: IGColors.bgDark,
            unselectedLabelColor: IGColors.gray,
            indicatorColor: IGColors.bgDark,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(icon: Text('12 Followers')), // Followers
              Tab(icon: Text('36 Following')), // Followers
              Tab(icon: Text('Subscriptions')), // Followers
            ],
          ),
        ),
        body: const TabBarView(
          children: [FollowTabView(), FollowTabView(), FollowTabView()],
        ),
      ),
    );
  }
}
