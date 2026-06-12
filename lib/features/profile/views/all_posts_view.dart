import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/profile/widgets/all_post_card_widget.dart';

class AllPostsView extends StatefulWidget {
  const AllPostsView({super.key});

  @override
  State<AllPostsView> createState() => _AllPostsViewState();
}

class _AllPostsViewState extends State<AllPostsView> {
  late final List<PostModel> posts;
  late final int initialIndex;
  final ScrollController _scrollController = ScrollController();

  static const double _estimatedCardHeight = 500.0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    posts = args['posts'] as List<PostModel>? ?? [];
    initialIndex = args['index'] as int? ?? 0;

    if (initialIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(initialIndex * _estimatedCardHeight);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.grid, size: 40.sp, color: IGColors.gray),
              SizedBox(height: 10.h),
              const Text("No Posts Yet"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "Posts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        itemCount: posts.length - 1,
        itemBuilder: (context, index) {
          return AllPostCardWidget(postModel: posts[index]);
        },
      ),
    );
  }
}
